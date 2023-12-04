begin_group Quartus II TCL
begin_group Commands
begin_template Build
# Make active the specified revision and start the build
# Require package ::quartus::flow
# Require package ::quartus::project
set_current_revision __revision_name;
execute_module -tool swb;
end_template

begin_template Compile
# Make active the specified revision and compile the design
# Require package ::quartus::flow
# Require package ::quartus::project
set_current_revision __revision_name;
execute_flow -compile;
end_template

begin_template Create Base Clock 
# Create a new base clock 
# Fmax is the clock frequency
# Clock name is the clock name
# Require package ::quartus::project
create_base_clock -fmax __fmax __clock_name;
end_template

begin_template Create Base Clock with Duty Cycle Assignment
# Create a new base clock 
# Fmax is clock frequency
# Duty_cycle is the percentage of time that the derived clock period is high
# Clock_name is the clock name
# Require package ::quartus::project
create_base_clock -fmax __fmax -duty_cycle __duty_cycle __clock_name;
end_template

begin_template Create New Revision
# Create a new revision and set to active
# Require package ::quartus::project
create_revision -set_current __revision_name;
end_template

begin_template Create New Project
# Create a new project and open it
# Require package ::quartus::project
if {![project_exists __project_name]} {
	project_new __project_name;
}
end_template

begin_template Perform Minimum Timing Analysis
# Make active the specified revision and perform timing analysis with minimum delays
# Require package ::quartus::project
# Require package ::quartus::flow
set_current_revision __revision_name;
execute_flow -min_timing;
end_template

begin_template Remove Global Assignment
# Name is the keyword for the assignment
# Value to be assigned (string, number, or ON/OFF)
# Require package ::quartus::project
set_global_assignment -name __name -remove __value;
end_template

begin_template Remove Instance Assignment
# Source is source of the assignment
# Destination is destination of the assignment
# Name is the keyword for the assignment
# Value to be assigned (string, number, or ON/OFF)
set_instance_assignment -name __name -from __source -to __destination   -remove __value;
end_template

begin_template Set Global Assignment 
# Name is the keyword for the assignment
# Value to be assigned (string, number, or ON/OFF)
# Require package ::quartus::project
set_global_assignment -name __name  __value;
end_template

begin_template Set Instance Assignment
# Source is source of the assignment
# Destination is destination of the assignment
# Name is the keyword for the assignment
# Value to be assigned (string, number, or ON/OFF)
# Require package ::quartus::project
set_instance_assignment -name __name -from __source -to __destination __value;
end_template

begin_template Simulate 
# Make active the specified revision and simulate the design
# Require package ::quartus::project
# Require package ::quartus::flow
set_current_revision __revision_name;
execute_module -tool sim;
end_template
end_group
end_group
