#!/usr/bin/env tcl

######################################################################
#
#  Synopsis:
#  tcl this_file.tcl  (Unix Systems)
#  vish this_file.tcl  (Any Command Line)
#  do this_file.tcl  (Modelsim GUI)
#
#  This file will compile all the necessary libraies and files for
#  running a VHDL simulation of the fixed example provided, using Modelsim.
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

#vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
# The parameters will set what kind of simulation the user wants to do
# verilog/vhdl
# ipfs/rtl
# source or sink

# IP_FS indicates if the script should look for IP Functional models (set to 1) or RTL models (set to 0)
set IP_FS 1

# transfer direction is used to indicate if it is a source (mtx) or a sink (mrx)
set transfer_direction mrx

# design language is either verilog or vhdl. If it is verilog, then rtl will be mixed simulation.
set design_language verilog

#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


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

# end of parameters



if {$design_language == "verilog"} {
        set rtl_ext v
        set ipfs_ext vo
        set modelsim_compile_cmd vlog
        set modelsim_compile_arg "-hazards"
} elseif {$design_language == "vhdl"} {
        set rtl_ext vhd
        set ipfs_ext vho
        set modelsim_compile_cmd vcom
        set modelsim_compile_arg "-93"
} else {
        myerror "Design language not set correctly, exiting"
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


set library_name_extension ""
if {$design_language == "verilog"} {
        set library_name_extension "_ver"
}

set lib_list ""
if {!$modelsim_ae} {
    lappend lib_list lpm${library_name_extension}
    if {$IP_FS} {
        lappend lib_list sgate${library_name_extension}
        lappend lib_list altera_mf${library_name_extension}
    }
}
lappend lib_list auk_pac_lib
lappend lib_list work


foreach i $lib_list {
    myexec vlib $current_dir/libs/$i
    myexec vmap $i $current_dir/libs/$i
}

#if {$modelsim_ae && $design_language == "verilog"} {
#       # this is a fix for a badly mapped library in ModelSimAE up to (at least) 5.7e
#       myexec vmap sgate_ver \$MODEL_TECH/../altera/verilog/sgate
#}

myinfo "-------------------------------------------------------------------------------"
myinfo "                     Compiling the libraries"
myinfo "-------------------------------------------------------------------------------"


if {!$modelsim_ae} {
    if {$design_language == "vhdl"} {
        myexec vcom -93 -work lpm       $quartus_lib_path/220pack.vhd
        myexec vcom -93 -work lpm       $quartus_lib_path/220model.vhd
      if {$IP_FS} {
        myexec vcom -93 -work altera_mf $quartus_lib_path/altera_mf_components.vhd
        myexec vcom -93 -work altera_mf $quartus_lib_path/altera_mf.vhd
        myexec vcom -93 -work sgate     $quartus_lib_path/sgate_pack.vhd
        myexec vcom -93 -work sgate     $quartus_lib_path/sgate.vhd
      }
    }
    if {$design_language == "verilog"} {
        myexec vlog -work lpm${library_name_extension}       $quartus_lib_path/220model.v -nodebug
      if {$IP_FS} {
        myexec vlog -work altera_mf${library_name_extension} $quartus_lib_path/altera_mf.v
        myexec vlog -work sgate${library_name_extension}     $quartus_lib_path/sgate.v
      }
    }
}


myinfo "-------------------------------------------------------------------------------"
myinfo "Compiling the wrappers or the IP functional simulation models of the wrapper"
myinfo "-------------------------------------------------------------------------------"

set file_list ""

if {$IP_FS} {
    lappend file_list auk_pac_${transfer_direction}_pl3_link.$ipfs_ext
} else {
    lappend file_list auk_pac_${transfer_direction}_pl3_link.$rtl_ext
}

foreach i $file_list {
    myexec $modelsim_compile_cmd $modelsim_compile_arg -work work $base_dir/testbench/$design_language/$i
}


myinfo "-------------------------------------------------------------------------------"
myinfo "                        Compiling the testbench"
myinfo "-------------------------------------------------------------------------------"


set tb_file_list ""
lappend tb_file_list auk_pac_${transfer_direction}_ref_tb.$rtl_ext

foreach i $tb_file_list {
    myexec $modelsim_compile_cmd $modelsim_compile_arg -work work $base_dir/testbench/$design_language/$i
}



myinfo "-------------------------------------------------------------------------------"
myinfo "                            Starting simulation"
myinfo "-------------------------------------------------------------------------------"

set modelsim_parameters "+nowarnTSCALE +nowarnTFMPC +nowarnTOFD -c "
if {$design_language == "verilog"} {
    if {$IP_FS} {
        append modelsim_parameters "-L sgate_ver -L altera_mf_ver -L lpm_ver "
    } else {
        append modelsim_parameters "-L auk_pac_lib "
    }
}

myinfo "Running Testbench"
eval "myexec vsim $modelsim_parameters -l run_modelsim.log -do \"run -all; quit\" work.auk_pac_${transfer_direction}_ref"
myinfo "Testbench Completed"

myinfo "Check run_modelsim.log for more Details"
exit

