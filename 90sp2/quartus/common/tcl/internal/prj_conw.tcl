# ***************************************************************
# ***************************************************************
#
# Description:  This script is used by the Tcl Console in the
#               Quartus II User Interface.
#
# Version:      1.0
#
# Authors:      Altera Corporation
#
#               Copyright (c)  Altera Corporation 2003
#               All rights reserved.
#
# ***************************************************************
# ***************************************************************

# Conventions:
#  * All user functions and variables begin with q_
#  * All internal variables and functions begin with _q_

# _q_gui_unknown -- (modified version of init.tcl's unknown)
# This procedure is called when a Tcl command is invoked that doesn't
# exist in the interpreter.  It takes the following steps to make the
# command available:
#
#	1. If the command was invoked interactively at top-level:
#	    (a) see if the command exists as an executable UNIX program.
#		If so, "exec" the command.
#	    (b) see if the command is a unique abbreviation for another
#		command.  If so, invoke the command.
#
# Arguments:
# args -	A list whose elements are the words of the original
#		command, including the command name.
#
# This is an internal command.

proc _q_gui_unknown args {
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
	
	return -code error "invalid command name \"$name\""
}

