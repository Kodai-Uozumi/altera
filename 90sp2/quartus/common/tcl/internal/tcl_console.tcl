# ***************************************************************
# ***************************************************************
#
# Description:	This script is run automatically by all 
#				executables that support the --shell or -s command.
#				It emulates support for a console
#
# Version:		1.0
#
# Authors:		 Altera Corporation
#
#               Copyright (c)  Altera Corporation 1999 - 2002
#               All rights reserved.
#
# ***************************************************************
# ***************************************************************

set tcl_command ""

# q_unknown -- (modified version of init.tcl's unknown)
# This procedure is called when a Tcl command is invoked that doesn't
# exist in the interpreter.  It takes the following steps to make the
# command available:
#
#	1. If the command was invoked interactively at top-level:
#	    (a) see if the command exists as an executable UNIX program.
#		If so, "exec" the command.
#	    (b) see if the command requests csh-like history substitution
#		in one of the common forms !!, !<number>, or ^old^new.  If
#		so, emulate csh's history substitution.
#	    (c) see if the command is a unique abbreviation for another
#		command.  If so, invoke the command.
#
# Arguments:
# args -	A list whose elements are the words of the original
#		command, including the command name.

proc q_unknown args {
    global auto_noexec 
    global errorCode errorInfo

    # If the command word has the form "namespace inscope ns cmd"
    # then concatenate its arguments onto the end and evaluate it.

    set cmd [lindex $args 0]
    if {[regexp "^namespace\[ \t\n\]+inscope" $cmd] && [llength $cmd] == 4} {
        set arglist [lrange $args 1 end]
		set ret [catch {uplevel $cmd $arglist} result]
        if {$ret == 0} {
            return $result
        } else {
			return -code $ret -errorcode $errorCode $result
        }
    }

    # Save the values of errorCode and errorInfo variables, since they
    # may get modified if caught errors occur below.  The variables will
    # be restored just before re-executing the missing command.

    set savedErrorCode $errorCode
    set savedErrorInfo $errorInfo

	# The caller may have put all arguments between "", so we need to assume
	# that we still have a second list at this point. Split it and and then
	# try to get the first argument
    set name [lindex [split [lindex $args 0] " "] 0]
	set arglist [lrange [split [lindex $args 0] " "] 1 end]
	for { set i 0 } { $i < [llength $arglist] } { incr i } {
			set argv($i) [lindex $arglist $i]
	}
	
	if {![info exists auto_noexec]} {
	    set new [auto_execok $name]
	    if {[string compare {} $new]} {
			set errorCode $savedErrorCode
			set errorInfo $savedErrorInfo
			set redir ""
			if {[string equal [info commands console] ""]} {
				set redir ">&@stdout <@stdin"
			}
			# Must use eval here to expand the arglist, allowing us to
			# pass an arbitrary number of arguments.
			return [eval exec $new $arglist]
	    }
	}
	set errorCode $savedErrorCode
	set errorInfo $savedErrorInfo
	if {[string equal $name "!!"]} {
	    set newcmd [history event]
	} elseif {[regexp {^!(.+)$} $name dummy event]} {
	    set newcmd [history event $event]
	} elseif {[regexp {^\^([^^]*)\^([^^]*)\^?$} $name dummy old new]} {
	    set newcmd [history event -1]
	    catch {regsub -all -- $old $newcmd $new newcmd}
	}

	if {[info exists newcmd]} {
	    tclLog $newcmd
	    history change $newcmd 0
	    return [uplevel $newcmd]
	} else {
		return -code error "invalid command name \"$name\""
	}
}

# -------------------------------------------------
# -------------------------------------------------
proc is_script_based {savedErrorInfo} {
	#  Determine if the error came from "source <file>".
# -------------------------------------------------
# -------------------------------------------------

	set result 0

	if {[string compare $savedErrorInfo ""]} {

		set flag 1
		while { $flag } {

			set split_index [string first "\n" $savedErrorInfo]

			# If there are no more new-lines in the string,
			# set line to the string and exit loop.
			if { $split_index == -1 } {
				set line $savedErrorInfo
				set flag 0
			} else {
				set line [string range $savedErrorInfo 0 $split_index]
				set savedErrorInfo [string replace $savedErrorInfo 0 $split_index]
			}
			regsub {^\s+\(file \"(.+)\"\s+line\s+\d+\)\s*$} $line {\1} src_file
			if {[string compare $src_file $line] != 0 && [file isfile $src_file] == 1} {
				set result 1
			}
		}
	}

	return $result
}

# q_display_banner
# This procedure is called to display a banner with basic help about 
# the console

proc q_display_banner {} {

	post_message "*******************************************************************"
	post_message "The Quartus II Shell supports all TCL commands in addition"
	post_message "to Quartus II Tcl commands. All unrecognized commands are"
	post_message "assumed to be external and are run using Tcl's \"exec\""
	post_message "command."
	post_message "- Type \"exit\" to exit."
	post_message "- Type \"help\" to view a list of Quartus II Tcl packages."
	post_message "- Type \"help <package name>\" to view a list of Tcl commands"
	post_message "  available for the specified Quartus II Tcl package."
	post_message "- Type \"help -tcl\" to get an overview on Quartus II Tcl usages."
	post_message "*******************************************************************"
	puts ""
}


# Display Help
q_display_banner
	

# Go into an infinite loop evaluating commands
# The user has to call TCL's "exit" to exit
while { 1 } {

	# Prevent infinite loops when a script is redirected to stdin.
	if {[eof stdin]} { exit 0; }
	
	puts -nonewline "tcl> "
	flush stdout
	set tcl_command [gets stdin]

	# Continue requesting more lines of input until a complete
	# command has been entered.
	while { ![info complete $tcl_command] } {
		# Exit 1 (error) on eof here, since the last command
		# was not complete.
		if {[eof stdin]} { exit 1; }
			
		puts -nonewline "> "
		flush stdout
		append tcl_command "\n" [gets stdin]
	}

	# Call TCL interpreter to evaluate command
	set catch_result [catch {eval $tcl_command} result]
	set savedErrorInfo $::errorInfo

	set tcl_command_is_valid 1
	if {[string match "*invalid*command*name*" $result] == 1} {
		set tcl_command_is_valid 0
		if [catch {[llength $tcl_command] > 0}] {
				# In order to mimick tclsh, we'll eliminate the "invalid command name" portion and retry
			set tcl_command [list [string range $result 22 end-1]]
		} else {
			set current_command [lindex $tcl_command 0]
			if {[string length [info commands $current_command]] > 0} {
				set tcl_command_is_valid 1
			}
		}
	}

	# If the command was invalid, try an abbreviation, system command,
	# or history item.
	if {$tcl_command_is_valid == 0} {
		set catch_result [catch { q_unknown $tcl_command } result]
		if {$result == 1} {
			history add $tcl_command
		}
	} else {
		# Update History
		history add $tcl_command
	}

	# Only display results when its is not empty
	if { [ string compare $result ""] } {
		if {$catch_result != 0 && [is_script_based $savedErrorInfo]} {
			puts $savedErrorInfo
		} else {
			puts $result
		}
	}
}
