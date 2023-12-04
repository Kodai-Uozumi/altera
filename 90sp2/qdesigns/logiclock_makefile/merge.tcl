package require ::quartus::logiclock
package require ::quartus::flow

project_open $quartus(args)
initialize_logiclock
logiclock_import -do_routing -overwrite
uninitialize_logiclock

execute_flow -flow analysis_and_synthesis
project_close