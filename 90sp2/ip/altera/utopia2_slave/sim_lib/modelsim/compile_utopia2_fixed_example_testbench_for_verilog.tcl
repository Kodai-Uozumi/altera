#!/usr/bin/env tcl

######################################################################
#
#  Synopsis:
#  tcl this_file.tcl  (Unix Systems)
#  vish this_file.tcl  (Any Command Line)
#  do this_file.tcl  (Modelsim GUI)
#
#  This file will compile all the necessary libraies and files for
#  running a mixed VHDL and Verilog simulation of the fixed example provided.
#  It does NOT work with Modelsim Altera (single HDL simulator) !
#
#
#  This file is only provided as an example. It should not be modified within
#  the installation directory.
#  If you intend to modify this script or the example provided, it is strongly
#  recommended to make a copy of the sim_lib directory in a different location
#  and edit the copy
#
#  Copyright Altera 2006
#
######################################################################


if {[catch {vsim -version} ]} {
 set shell 1
} else {
 set shell 0
}
###################################
proc myinfo { args } {
  global shell
  foreach mesg $args {
    if {$shell} {
      puts stdout "\# Info: $mesg"
    } else {
      puts "\# Info: $mesg"
    }
  }
}
proc myerror { args } {
  global shell
  foreach mesg $args {
    if {$shell} {
      puts stderr "\# Error: $mesg"
    } else {
      puts "\# Error: $mesg"
    }
  }
  if {$shell} {
    exit
  } else {
    error "Terminating script"
  }
}
proc myexec { args } {
  global shell
  if {$shell} {
    eval "exec $args"
  } else {
    eval $args
  }
}
###################################


myinfo "-------------------------------------------------------------------------------"
myinfo "                   Setting up basic variables"
myinfo "-------------------------------------------------------------------------------"

# Check if we are running a version of ModelSim Altera Edition
set version [myexec vsim -version]
if {[string match -nocase "*ALTERA*" $version]} {
    set modelsim_ae 1
} else {
    set modelsim_ae 0
}

set current_dir [pwd]

# Get Location of Quartus Libraries
global env

if {[info exists env(QUARTUS_ROOTDIR)]} {
        set quartus_rootdir "$env(QUARTUS_ROOTDIR)"
        regsub -all {\\} $quartus_rootdir  / quartus_rootdir
        set quartus_lib_path "$quartus_rootdir/eda/sim_lib"
} else {
        myerror "Can't find QUARTUS II\n"
}


myinfo "-------------------------------------------------------------------------------"
myinfo "              Creating the default directory values"
myinfo "-------------------------------------------------------------------------------"

set base_dir "${current_dir}/.."
myinfo "Setting up the base directory to : $base_dir"


myinfo "-------------------------------------------------------------------------------"
myinfo "                 Creating and mapping the libraries"
myinfo "-------------------------------------------------------------------------------"

# Remove modelsim.ini
if {[file exists modelsim.ini]} {
        myinfo "Removing modelsim.ini"
        file delete -force modelsim.ini
}

set lib_dir "$base_dir/modelsim/libs"
if {[file isdirectory $lib_dir]} then {
    myinfo "Cleaning Lib Directory"
    file delete -force $lib_dir
}
file mkdir $lib_dir


set lib_list ""
if {!$modelsim_ae} {
    lappend lib_list lpm
    lappend lib_list altera_mf
    lappend lib_list sgate
}
lappend lib_list altutm
lappend lib_list altuts
lappend lib_list work

foreach i $lib_list {
    myexec vlib $current_dir/libs/$i
    myexec vmap $i $current_dir/libs/$i
}



myinfo "-------------------------------------------------------------------------------"
myinfo "                     Compiling the libraries"
myinfo "-------------------------------------------------------------------------------"

if {!$modelsim_ae} {
    myexec vlog -work lpm       $quartus_lib_path/220model.v -nodebug
    myexec vlog -work altera_mf $quartus_lib_path/altera_mf.v
    myexec vlog -work sgate     $quartus_lib_path/sgate.v
}

myinfo "-------------------------------------------------------------------------------"
myinfo " Compiling the IP functional simulation models"
myinfo "-------------------------------------------------------------------------------"

set file_list ""
lappend file_list masterrx_example.vo
lappend file_list mastertx_example.vo
lappend file_list slavetx0_example.vo
lappend file_list slavetx1_example.vo
lappend file_list slaverx0_example.vo
lappend file_list slaverx1_example.vo

foreach i $file_list {
    myexec vlog -work work $base_dir/testbench/verilog/$i
}

myinfo "-------------------------------------------------------------------------------"
myinfo "                        Compiling the testbench"
myinfo "-------------------------------------------------------------------------------"

set tb_file_list ""
lappend tb_file_list master_tb_pack.vhd
lappend tb_file_list slave_user_if.vhd

foreach i $tb_file_list {
    myexec vcom -work work $base_dir/testbench/verilog/$i
}

set tb_file_list ""
lappend tb_file_list utopia2_example_top.vhd
lappend tb_file_list master_example_tb.vhd

foreach i $tb_file_list {
    myexec vcom -work work $base_dir/testbench/verilog/$i
}


myinfo "-------------------------------------------------------------------------------"
myinfo "                Sourcing the parameters used for the simulation"
myinfo "-------------------------------------------------------------------------------"

set parameter_file $base_dir/modelsim/parameters_example.tcl
set modelsim_parameters "+nowarnTSCALE +nowarnTFMPC +nowarnTOFD -c -t 1ps"
set top_level_name master_example_tb

if {[file exists $parameter_file]} {
    source      $parameter_file
} else {
    myinfo "No parameter file $parameter_file found, the simulation will use the default generics"
}


myinfo "-------------------------------------------------------------------------------"
myinfo "                            Starting simulation"
myinfo "-------------------------------------------------------------------------------"


myinfo "Running Testbench"
eval "myexec vsim $modelsim_parameters -L lpm -L altera_mf -L sgate -l run_modelsim.log -do \"run -all; quit\" work.${top_level_name}"
myinfo "Testbench Completed"

myinfo "Check run_modelsim.log for more Details"
exit


