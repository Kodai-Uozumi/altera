# Copyright (c) 2005 Altera Corporation. All rights reserved.  

# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output files 
# any of the foregoing (including device programming or simulation files), and 
# any associated documentation or information are expressly subject to the terms 
# and conditions of the Altera Program License Subscription Agreement, Altera 
# MegaCore Function License Agreement, or other applicable license agreement, 
# including, without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by Altera or its 
# authorized distributors.  Please refer to the applicable agreement for 
# further details.
#

package require ::quartus::project
package require http
package require tls
package require base64
package require autoproxy

http::register https 443 ::tls::socket

set proxyhost {}
set proxyport {}

# Settings
set QTB_UNIX_FILE_SEND_ATTEMPTS 3
set QTB_WINDOWS_FILE_SEND_ATTEMPTS 3
set QTB_MAX_SECS_ELAPSED_TO_SEND 90
set QTB_MAX_FILES_TO_SEND 15
set STR_NUM_LENGTH 50
set QTB_SENDER_FILE_DELAY 10

# Environment variables
set QTB_DEBUG_TCL "QTB_DEBUG_TCL"                               ;# Turn on debug messages for this script
set QTB_ENV_QUARTUS_TALKBACK_PROXY  "QUARTUS_TALKBACK_PROXY"    ;# HTTP & HTTPS proxy host:port
set QTB_ENV_QUARTUS_TALKBACK_PROXY_USERPASS  "QUARTUS_TALKBACK_PROXY_USERPASS"    ;# HTTP & HTTPS proxy username:password
set QTB_SENDER_TEST_URL "QTB_SENDER_TEST_URL"                   ;# Was quartus.ini: qtb_sender_test_url
set QTB_COMPRESS_FILES "QTB_COMPRESS_FILES"                     ;# Was quartus.ini: qtb_compress_files
set QTB_SENDER_NO_RENAME "QTB_SENDER_NO_RENAME"                 ;# Was quartus.ini qtb_sender_no_rename

#
# FROM OLD QTB_SENDER.TCL: routines to compress and post the files via http
#
proc system_call { command } {
	global tcl_platform

	if { $tcl_platform(platform) == "unix" } {
		set got_error [catch {eval exec $command} result]
	} 

	return $got_error
}

proc create_semaphore { name } {
	global tcl_platform

	if { $tcl_platform(platform) == "unix" } {
		if { ! [system_call "mkdir ${name}_${uid}.sem"] } {		
			if { ![file exists ${name}_${uid}.sem] } {
				return 0
			}
			return 1
		} else {
			return 0
		}
	} else {
		return 1
	}
}

proc remove_semaphore { name } {
	global tcl_platform

	if { $tcl_platform(platform) == "unix" } {
		if { [system_call "rmdir ${name}_${uid}.sem"] } {
			set result "WARNING: rmdir ${name}_${uid}.sem failed"
		}
	}
}

proc read_file {filename} {
	if [file exists $filename] {
		set fp [open $filename r]
		fconfigure $fp -translation binary
		set content [read $fp]
		close $fp
		set content
	}
}

proc qproxy_filter url {
	variable proxyhost
	variable proxyport
	return [list $proxyhost $proxyport]
}

proc compress_send_file { filename url proxy userpass } {
	global tcl_platform
	global quartus
	global env
	set result 0
	set semfile $filename
	set return_from_send_file 0

	debug_msg "In compress_send_files..."
    
	if [create_semaphore $semfile] {
		debug_msg "Created compress_send_files semaphore okay..."
		if [catch {file copy $filename $filename.tmp}] {
			debug_msg "Error copying $filename to $filename.tmp"
			set result 1
		} else {
			# Gnu/gzip is under /quartus/bin/gnu/gzip for windows
			# and /quartus/<plat>/gnu/gzip for UNIX plats

			# But Windows install image has binpath = win, 
			# not bin like the relq image.
			if { $tcl_platform(platform) != "unix" } {
				regsub {(.*)(win|WIN)(.*?)} $quartus(binpath) {\1bin\3} qbinpath
			} else {
				set qbinpath $quartus(binpath)
			}
			
			# Append .exe on Window platform
			if { $tcl_platform(platform) == "windows" } {
				set gzip_cmd "$gzip_cmd.exe"
			}

			set gzip_cmd [file join $qbinpath gnu gzip]

			if { ![file exists $gzip_cmd] } {
				debug_msg "Error: $gzip_cmd does not exist"
			}

			set gzip_cmd "$gzip_cmd -q -f"

			if [catch {eval exec "$gzip_cmd $filename.tmp"}] {
				debug_msg "Error: $gzip_cmd $filename.tmp.gz from $filename.tmp"
				set result 1
			} else {
				set filename $filename.tmp.gz
				
				if [file exists $filename] {
					set return_from_send_file [send_file $filename $url $proxy $userpass]
					debug_msg "Done sending $filename to $url with $proxy and $userpass"
					set result $return_from_send_file
					file delete $filename
				} else {
					debug_msg "$filename does not exist!"
					set result 1
				}
				
			}
		}

		remove_semaphore $semfile
	}
	return $return_from_send_file
}

proc send_file { filename url proxy userpass } {
	global regtest_mode
	
	variable proxyhost
	variable proxyport

	if {$proxy != ""} {
		string trim $proxy
		if {[lindex [split $proxy :] 1] != ""} {
			set proxyport [lindex [split $proxy :] 1]
		} else {
			set proxyport 80
		}
		set proxyhost [lindex [split $proxy :] 0]
		http::config -proxyfilter qproxy_filter
	}
	
	debug_msg "Proxy config (ignoring due to autoproxy): $proxyhost:$proxyport"

	if [file exists $filename] {
		set filedata [read_file $filename]
		set tok {}
		if {$userpass != ""} {
			# Altera changes to the Tcl-core http package define the -proxy_auth argument to geturl
			debug_msg "Running http::geturl \"$url\" -type \"multipart/form-data\" -query \$filedata -proxy_auth [concat "Basic" [base64::encode $userpass]]"
			set tok [http::geturl "$url" -type "multipart/form-data" -query $filedata -proxy_auth [concat "Basic" [base64::encode $userpass]]]
		} else {
		    debug_msg "Running http::geturl \"$url\" -type \"multipart/form-data\" -query \$filedata"
			set tok [http::geturl "$url" -type "multipart/form-data" -query $filedata]
		}
		upvar #0 $tok data
		set result $data(http)
		debug_msg "send_file(): http return code: $data(http)"
		
		# For regtests, we need to note this in a special log file
		if { $regtest_mode } {
			regtest_msg "send_file(): http return code: $data(http)"
		}

		foreach f [array names data] {
		    if {$f != "-query"} {
		        debug_msg "$f: $data($f)"
		    }
		}
		debug_msg "\n"
		
		if {[string match "*200 OK" $data(http)]} {
		    return 0
		} else {
		    return 1
		}
	} else {
		set result "Can't find file: $filename"
		debug_msg "Can't find file: $filename"
		return 1
	}
}

#
# PROCEDURE: DEBUG_MSG
#
proc debug_msg { strMsg } {
    global debug
    global dbg_log
    if { $debug } { puts $dbg_log $strMsg }
}

#
# PROCEDURE: REGTEST_MSG
#
proc regtest_msg { strMsg } {
    global regtest_mode
    global regtest_log
    if { $regtest_mode } { puts $regtest_log $strMsg }
}

####################
# START OF MAIN CODE
####################

#
# Determine the temp directory
#

global tcl_platform
set temp_path ""
foreach index [array names env -regexp {^(TEMP|TMP|TMPDIR)$}] {
	# We don't really care which so long as it exists!
	if { [string length $env($index)] > 0 } {
		set temp_path $env($index)
	}
}
if { [string length $temp_path ] == 0 } {
	# Default to /tmp on UNIX
	if { [string equal $tcl_platform(platform) "unix"] } {
		set temp_path "/tmp"
	} else {
		puts "No temporary directory found in environment.  Looking for: TEMP, TMP, or TMPDIR.  Aborting Quartus Talkback XML file sender."
		exit
	}
}

set temp_path "$temp_path/"

#
# Read environment variables / set defaults
# 
global env

#
# Before anything, check to see if another tcl_sender is running.  If so, abort.
#

# Semaphores are user-specific, else we may not be able to delete other users' hung semaphonres
set uid $tcl_platform(user)
set semaphore_file [file join $temp_path "qtb_tcl_sender_running_${uid}.sem"]

if [file exists $semaphore_file ] {
	set t1 [file mtime $semaphore_file]
	set t2 [clock seconds]
	if { [expr $t2 - $t1] > 120 } {
		# semaphore is old; just delete it and continue
		file delete $semaphore_file 
	} else {
		# Semaphore is not old, so abort.
		debug_msg "qtb_tcl_sender already running.  Aborting Quartus Talkback XML file sender."
		exit
	}
}

# Okay, we are going to run now, so create the semaphore
file mkdir $semaphore_file


# Are we in debug mode?
set debug 0
foreach index [array names env $QTB_DEBUG_TCL] {
    set debug $env($index)
	if [catch {set dbg_log [open "qtb_tcl_sender.tcl.out" w]} err ] {
		puts "Could not open debug output file: $err"
	}
}

debug_msg "\nNow running $argv0\n"
debug_msg "env($QTB_DEBUG_TCL) == $debug"


# Is file renaming disabled?
set rename_disabled 0
foreach index [array names env $QTB_SENDER_NO_RENAME] {
    set rename_disabled $env($index)
}
debug_msg "env($QTB_SENDER_NO_RENAME) == $rename_disabled"

# Should we compress XML files?
set compress_files 0
foreach index [array names env $QTB_COMPRESS_FILES] {
    set compress_files $env($index)
}

debug_msg "env($QTB_COMPRESS_FILES) == $compress_files"
if { $compress_files } {
    set send_file "compress_send_file"
} else {
    set send_file "send_file"
}

# We output the temp dir now -- we determined it first thing to create the semaphore file
debug_msg "\nTEMP_PATH = $temp_path"

#
# Are we in regtest mode?
#
set regtest_mode $quartus(regtest_mode)

if { $regtest_mode } {

	# Open the special regtest log file
	if [catch {set regtest_log [open "qtb_tcl_sender.tcl.regtest.out" w]} err ] {
		debug_msg "Could not open regtest output file: $err"
	}

	# ...then copy files from the project directory into the temp directory 
	#    to bypass the disabling of this behavior in Quartus.

	# pwd is assumed to be the regtest directory.
	debug_msg "Searching [pwd] for *.xml..."

	# Check for potential glob errors first...
	if [catch {set xmlfiles [glob -nocomplain "*.xml"]} err] {
		debug_msg "Glob error: $err"
	}
	
	# Make src full path?
	# Copy explicitly with actual file names...
	
	foreach f $xmlfiles {
		set src [file join [pwd] $f]
		set dest [file join $temp_path $f]
		debug_msg "Copying from $src to $dest"
		if [catch {file copy $src $dest} err] {
			debug_msg "$err"
		}
	}
}	

#
# Determine proxy settings
#

# First, set the hostname and port of the proxy.

# The autoproxy package will fetch proxy settings from the registry for Windows
# and from environment variables for UNIX
::autoproxy::init

set proxy ""

# Quartus proxy host:port is set in Tools, Options, Internet Connectivity

if { [get_user_option -name "PROXY_ENABLED"] == "on" } {
	set proxy [get_user_option -name "PROXY_SETTINGS"]
}

# Environment variables override Quartus settings
foreach index [array names env $QTB_ENV_QUARTUS_TALKBACK_PROXY] {
    set proxy $env($index)
}

debug_msg "PROXY_SETTINGS = $proxy"

# Okay, if we overrode autoproxy, let it know:
if { [string length $proxy] == 0 } {
    # If we need to override autoproxies init defaults, we can using this syntax:
    #   ::autoproxy::configure -host localhost -port 808 
    # or even this, but only for http url's (not https):
    #   ::autoproxy::configure -host localhost -port 808 -basic -username kirk -password kirk
    # However, note that due to a bug in autoproxy, you can't override Windows settings when autoconfiguration is enabled.
    
    # Split $proxy into $proxy_host and $proxy_port...
    set proxy_host [lindex [split $proxy :] 1]
    set proxy_port [lindex [split $proxy :] 2]
    ::autoproxy::configure -host $proxy_host -port $proxy_port
}

# For authenticating proxies we only support the Basic protocol.
# The username and password are set either 1) From Quartus Tools, Options, Internet Connectivity
# or 2) in the environment: $QTB_ENV_QUARTUS_TALKBACK_PROXY_USERPASS
# Environment settings take precedence over the Quartus settings

# Next, set up username/password for authenticating proxies.
set proxy_userpass ""

# From Quartus Tools, Options, Internet Connectivity
if { [get_user_option -name "PROXY_ENABLED"] == "on" } {
	set proxy_userpass [get_user_option -name "PROXY_USER1"]:[base64::decode [get_user_option -name "PROXY_USER2"]]
}

# Overridden by environment variables if they exist
foreach index [array names env $QTB_ENV_QUARTUS_TALKBACK_PROXY_USERPASS] {
    set proxy_userpass $env($index)
}

debug_msg "PROXY_USERPASS = $proxy_userpass"

#
# Set destination URL
#
# TODO: quartus.ini: qtb_sender_test_url, or if that doesn't exist, 
#       the production URL, either for compressed or non-compressed XML files (only when quartus.ini: qtb_compress_files is "off"). 

set url ""
foreach index [array names env $QTB_SENDER_TEST_URL] {
    set url $env($index)
}

if {[string length $url] == 0} {
    if {$compress_files} {
		set url "https://talkback.altera.com/cgi-bin/talkbackzip.pl"
	} else {
		set url "https://talkback.altera.com/cgi-bin/talkback.pl"
	}
}
debug_msg "QTB URL = $url"

#
# Copy the files, but do not exceed QTB_MAX_SECS_ELAPSED_TO_SEND for the entire sending process
#

# Start timer
set timer_start [clock seconds]
debug_msg "\nTimer start (s): $timer_start\n"

# For each QTB XML file in the temp directory, upload!

# First, cd to the temp directory where the XML files are
set start_dir [pwd]
if {[catch {cd $temp_path} err]} {
    debug_msg "Couldn't change directory to $temp_path.  Aborting Quartus Talkback XML file sender.\n"
} else {
	set file_count 0
    foreach qtb_file [glob -nocomplain "quartus_talkback*.xml"] {
        debug_msg "Processing: $qtb_file"
    
		# Don't mess with the file if we don't own it.
		if { [file owned $qtb_file] } {
	    
			if { [string equal $tcl_platform(platform) "unix"] } {
				set max_attempts_to_make $QTB_UNIX_FILE_SEND_ATTEMPTS
			} else {
				set max_attempts_to_make $QTB_WINDOWS_FILE_SEND_ATTEMPTS
			}        
	        
			set attempts 0
			while { $attempts < $max_attempts_to_make } {
				if {[$send_file [file join $temp_path $qtb_file] $url $proxy $proxy_userpass] == 0} {
					debug_msg "Sent successfully."
					set file_count [expr $file_count + 1]
					# Rename the file to sent_*
					if {!$rename_disabled} {
						debug_msg "Renaming to sent_..."
						if {[catch {file rename -force $qtb_file "sent_$qtb_file"} err]} {
							debug_msg "Couldn't rename file.  Error: $err"
						}
					}
	                
					# Exit the retry loop
					set attempts $max_attempts_to_make
				} else {
					debug_msg "Failed to send on attempt #$attempts."
					set attempts [expr $attempts + 1]
				}
			}
	    
			# Delay after sending each file QTB_SENDER_FILE_DELAY seconds
			debug_msg "Pausing...\n"
			after [expr 1000 * $QTB_SENDER_FILE_DELAY]
	    
			# Stop
			set timer_stop [clock seconds]
			debug_msg "Timer stop (s): $timer_stop\n"
	    
			# Exceeded limit?
			if { $timer_stop - $timer_stop > $QTB_MAX_SECS_ELAPSED_TO_SEND } {
				debug_msg "Exceeded QTB_MAX_SECS_ELAPSED_TO_SEND.  Aborting Quartus Talkback XML file sender.\n"
				break
			}

			if { $file_count == $QTB_MAX_FILES_TO_SEND } {
				debug_msg "Exceeded QTB_MAX_FILES_TO_SEND.  Aborting Quartus Talkback XML file sender.\n"
				break
			}
		}
	}
}

#
# Clean up the semaphore...
#

debug_msg "\nDeleting semaphore.\n"
cd $start_dir
if [catch [file delete $semaphore_file ] err] {
	debug_msg "$err"
}

debug_msg "\n\nProgram complete.\n\n"
 
# END MAIN
