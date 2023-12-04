# Modelsim do file to run the example test vectors 

# Use Tcl commands to copy the vectors 
file copy -force -- ../input_ht_vector.dat .
file copy -force -- ../output_ht_vector.dat .
file copy -force -- ../input_ui_vector.dat .
file copy -force -- ../output_ui_vector.dat .

# Make a local work directory
vlib work 

if [regexp {ModelSim ALTERA} [vsim -version]] {
        # Using Altera OEM Version, libraries should already be compiled 
} else {
        # Using non-OEM Version, compile all of the libraries
        vlib lpm_ver
        vmap lpm_ver lpm_ver 
        vlog -work lpm_ver $env(QUARTUS_ROOTDIR)/eda/sim_lib/220model.v 

        vlib altera_mf_ver
        vmap altera_mf_ver altera_mf_ver
        vlog -work altera_mf_ver $env(QUARTUS_ROOTDIR)/eda/sim_lib/altera_mf.v

        vlib sgate_ver
        vmap sgate_ver sgate_ver
        vlog -work sgate_ver $env(QUARTUS_ROOTDIR)/eda/sim_lib/sgate.v
}

# Compile the IP Functional Simulation Model and testbench into work
vlog -work work ../ht_top.vo ../ht_top_tb.v 

# Load and Simulate the testbench 
vsim -L altera_mf_ver -L lpm_ver -L sgate_ver ht_top_tb 

# Run it all 
onbreak { resume } 
run -all 
