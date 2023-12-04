# START_MODULE_HEADER/////////////////////////////////////////////////////
#
# Filename:    msg_puts.tcl
#
# Description: Changes "puts" function to call msg_tcl_puts which is buffered
#
# Authors:     Devin Sundaram
#
#              Copyright (c) Altera Corporation 1997 - 2003
#              All rights reserved.
#
# END_MODULE_HEADER///////////////////////////////////////////////////////

rename puts native_puts
proc puts {args} {
	if {[llength $args] == 1} {
		# just one args means we default to stdout, and therefore use our function
		msg_tcl_puts [lindex $args 0]
	} elseif {[llength $args] == 2 && [string equal [lindex $args 0] "-nonewline"]} {
		# Just pass -nonewline arg on to our function
		msg_tcl_puts -nonewline [lindex $args 1]
	} elseif {[llength $args] == 2 && [string equal [lindex $args 0] "stdout"]} {
		# if we are printing to stdout, we use our function
		msg_tcl_puts [lindex $args 1]
	} elseif {[llength $args] == 3 && [string equal [lindex $args 0] "-nonewline"] && [string equal [lindex $args 1] "stdout"]} {
		# Combination of previous 2 cases
		msg_tcl_puts -nonewline [lindex $args 2]
	} else {
		# We must have been passed a specific channel other than stdout, let tcl handle that
		eval native_puts $args
	}
}
