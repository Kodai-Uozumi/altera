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

package require http 2.5
package require tls
package require base64

http::register https 443 ::tls::socket

set proxyhost {}
set proxyport {}

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
		if { ! [system_call "mkdir ${name}.sem"] } {		
			if { ![file exists ${name}.sem] } {
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
		if { [system_call "rmdir ${name}.sem"] } {
			set result "WARNING: rmdir ${name}.sem failed"
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
	global quartus
	set result 0
	set semfile $filename

	if [create_semaphore $semfile] {
		if [catch {file copy $filename $filename.tmp}] {
			set result "Error copying $filename to $filename.tmp"
		} else {
			if [info exist quartus] {
				set gzip_cmd [file join $quartus(binpath) gnu gzip]
			} else {
				set gzip_cmd "gzip"
			}
			set gzip_cmd "$gzip_cmd -q -f"
			if [catch {eval exec "$gzip_cmd $filename.tmp"}] {
				set result "Error: $gzip_cmd $filename.tmp.gz from $filename.tmp"
			} else {
				set filename $filename.tmp.gz
				
				if [file exists $filename] {
					set result [send_file $filename $url $proxy $userpass]
					file delete $filename
				}
				set result
			}
		}

		remove_semaphore $semfile
	}

	set result
}

proc send_file { filename url proxy userpass } {
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

	if [file exists $filename] {
		set filedata [read_file $filename]
		set tok {}
		if {$userpass != ""} {
			set auth [list Authorization:  Basic [::base64::encode $userpass]]
			set tok [http::geturl "$url" -type "multipart/form-data" -query $filedata -headers $auth]
		} else {
			set tok [http::geturl "$url" -type "multipart/form-data" -query $filedata]
		}
		upvar #0 $tok data
		set result $data(http)
	} else {
		set result "Can't find file: $filename"
	}
}
