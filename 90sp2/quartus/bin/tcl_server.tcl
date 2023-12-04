#//START_MODULE_HEADER///////////////////////////////////////////////////////
#
#  Filename:    tcl_server.tcl
#
#  Description: Tcl package for quartus-tcl server
#         
#
#  Authors:     Altera Corporation
#
#               Copyright (c)  Altera Corporation 1999 - 2002
#               All rights reserved.
#
#
#//END_MODULE_HEADER/////////////////////////////////////////////////////////

package provide quartus_server 1.0

set _q_cli_cnt 0

proc _q_setup_server {port} {
	global _q_lsock;
	if [catch { set _q_lsock [socket -server _q_accept $port] } emsg] {
	}
	msg_tcl_enable_eda_socket
	return;
}

proc _q_accept {sock addr port} {
	global _q_cli_cnt;
	global _q_cli_msg_sock;
	global _q_cli_sock;
	catch { puts "accepted $sock from $addr" }
	fconfigure $sock -buffering line
	if { $_q_cli_cnt == 0} {
		set _q_cli_sock $sock
		incr _q_cli_cnt
		fileevent $sock readable [list _q_exec_cmd $sock]
	} elseif { $_q_cli_cnt == 1} {
		set _q_cli_msg_sock $sock
		incr _q_cli_cnt
	} else {
		catch { close $sock }
		error "Internal Error in quartus-tcl server: Client count incorrect";
		return;
	}
}

proc _q_exec_cmd {sock} {
	global _q_cli_sock;
	global _q_cli_msg_sock;
	global _q_cli_cnt;
	global _q_lsock;
	if {[eof $sock]} {
		catch { puts "closing $sock conection.." }
		catch { close $sock }
		## if cmd sock is closed, then close msgsock
		if {$sock == $_q_cli_sock} { 
			catch { close $_q_cli_sock }
			unset _q_cli_sock
		}
		if { [info exists _q_cli_msg_sock] } {
			catch { close $_q_cli_msg_sock }
			unset _q_cli_msg_sock
		}
		set _q_cli_cnt 0
		return;
	} else {
		if {[catch {gets $sock line}]} {
			catch { close $sock }
			## if cmd sock is closed, then close msgsock
			if {$sock == $_q_cli_sock} { 
				catch { close $_q_cli_sock }
				unset _q_cli_sock
			}
			if { [info exists _q_cli_msg_sock] } {
				catch {close $_q_cli_msg_sock }
				unset _q_cli_msg_sock
			}
			set _q_cli_cnt 0
			return;
		} elseif {[string compare $line "shutdown_quartus"] == 0} {
			exit;
		}
	}

	## eval the client command, and send result back to client
	set ecmd [lindex $line 0]
	if { $ecmd != "project" && $ecmd != "device" && 
	$ecmd != "cmp" && $ecmd != "sim" && $ecmd != "show_main_window"
	&& $ecmd != "hide_main_window" && $ecmd != "get_version" 
	&& $ecmd != "help" && $ecmd != "convert"
	&& $ecmd != "import_assignments_from_maxplus2" } {
		set res "Error: Invalid command";
	} elseif [catch { set res [eval $line] } result] {
		set res "Error: $result";
	} 
	if { $res == "" } {
		set res " "
	}
	regsub -all {\n+$} $res {} res_clean
	set nlines [regsub -all \n $res_clean {} ignore]
	incr nlines
	
	catch { puts $sock "$nlines $res_clean" };
}

proc q_shutdown_server {} {
	global _q_lsock;
	if { [info exists _q_lsock] } {
		catch { puts "Shutting down quartus tcl server ..." }
		catch { close $_q_lsock }
		unset _q_lsock;
	} else {
		error "No active Quartus tcl server"
	}
}
if [info exists env(QUARTUS_TCL_PORT)] {
	set _q_port $env(QUARTUS_TCL_PORT)
} else {
	set _q_port 2589  
}

## start Tcl server only if env variable exists and is set to 1
if { [info exists env(QUARTUS_ENABLE_TCL_SERVER)]  } {
	if { $env(QUARTUS_ENABLE_TCL_SERVER) == 1 } {
		_q_setup_server $_q_port
	}
}
