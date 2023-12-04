package require ::quartus::backannotate
package require ::quartus::logiclock

set project_name $quartus(args) 
project_open $project_name
set revision_name [get_current_revision $project_name]

if [revision_exists modular_output_$project_name] { delete_revision modular_output_$project_name }
create_revision -based_on $revision_name -set_current -copy_results modular_output_$project_name

initialize_logiclock

logiclock_back_annotate  -no_delay_chain -region region_$project_name -lock -routing -no_demote_lab
puts "exporting"
logiclock_export -file_name ./atom_netlists/${project_name}.qsf -routing 

uninitialize_logiclock
export_assignments
set_current_revision $revision_name
project_close

qexec "quartus_cdb $project_name --vqm=./atom_netlists/$project_name.vqm"
