#Copyright (C)2001-2008 Altera Corporation
#Any megafunction design, and related net list (encrypted or decrypted),
#support information, device programming or simulation file, and any other
#associated documentation or information provided by Altera or a partner
#under Altera's Megafunction Partnership Program may be used only to
#program PLD devices (but not masked PLD devices) from Altera.  Any other
#use of such megafunction design, net list, support information, device
#programming or simulation file, or any other related documentation or
#information is prohibited for any other purpose, including, but not
#limited to modification, reverse engineering, de-compiling, or use with
#any other silicon devices, unless such use is explicitly licensed under
#a separate agreement with Altera or a megafunction partner.  Title to
#the intellectual property, including patents, copyrights, trademarks,
#trade secrets, or maskworks, embodied in any such megafunction design,
#net list, support information, device programming or simulation file, or
#any other related documentation or information provided by Altera or a
#megafunction partner, remains with Altera, the megafunction partner, or
#their respective licensors.  No other licenses, including any licenses
#needed under any third party's intellectual property, are provided herein.
#Copying or modifying any file, or portion thereof, to which this notice
#is attached violates this copyright.























BEGIN {
  if ($ENV{EUROPA_LIB_OVERRIDE})
  {
    my @overrides = split(/\+/, $ENV{EUROPA_LIB_OVERRIDE});
    unshift @INC, @overrides;
    if ($ENV{EUROPA_LIB_OVERRIDE_PACKAGES})
    {
      my @packages = split(/\+/, $ENV{EUROPA_LIB_OVERRIDE_PACKAGES});
      for my $package (@packages)
      {
        if (!require $package)
        {
          print STDERR "Error: failed to load required package '$package'\n";
          exit 2;
        }
      }
    }
  }
}



use strict;





use print_command;
use mk_bsf;
use e_ptf;

use filename_utils;
use run_system_command_utils;

use europa_global_project;

use europa_utils;







use e_module;          # equivalent to a verilog module or vhdl entity.  




use e_expression;      # The basic verilog/vhdl expression engine.


use e_test_module;     # e_module which optionally routes out no signals
use e_fifo;            # FIFO with predictive fifo-full.
use e_async_fifo;      # asynchronous FIFO for clock domain crossing



use e_instance;        # equivalent to an instance of a module.  It


use e_rom;             # child of e_instance.  Set up to instantiate a lpm_rom.
use e_ram;             # child of e_instance.  Set up to instantiate a lpm_ram_dp.
use e_dpram;           # lpm_ram_dp or altsyncram.
use e_fifo_with_registered_outputs;




use e_signal;          # use this to define signals.
use e_port;            # e_signal plus direction.  You should only use





use e_control_signal;  # e_signal plus additional control stuff. ask




 


use e_assign;          # used for assigning wires or registers in

use e_mux;             # e_assign with capabilities for arbitrating




use e_stop;
use e_if_x;            
use e_process_x;       #simulation checking for x

use e_assign_is_x;     # assign non-zero if x 

use e_process;         # used to define generic processes.  Inside



use e_if;              # only allowed inside e_process contents.  Used


use e_case;            # only allowed inside e_process contents.  Used


use e_register;        # a more restrictive e_process definition to describe



use e_mux_reg;



use e_edge_detector;   # Register-plus-logic for rising/falling edge 


use e_shift_register;  # Pretty handy bundle which allows flexible



use e_width_conduit;
use e_export;



use e_slave;           # An abstract class that corresponds to a "SLAVE" 


use e_avalon_slave;    # An e_slave object which "knows about" Avalon 


use e_avalon_master;   # An e_slave object which "knows about" Avalon 




use e_clk_gen;        # generate a clock signal
use e_sim_fopen;      # An object for opening files
use e_sim_write;      # An object for implementing '$write' directives

use e_initial_block;  # For things that happen at init time, e.g. $readmemb
use e_readmem;        # Load a memory from a file, via $readmemh, $readmemb.
use e_reset_gen;      # generate a reset signal
use e_pull;           # Test bench pullup or pulldown

use e_drom;           # dynamic rom (can be written to by perl)
use e_log;            # logs ASCII output to a file

use e_sim_wave_text;  # an emux whose result is a text string when


use e_sim_cmd;        # A way to call a simulator function (e.g. $display)


use e_lpm_base;
use e_lpm_altsyncram;
use e_lpm_dcfifo;
use e_clock_crossing;
use e_synchronizer;
use e_comment;
use e_component;


use e_adapter;
use e_avalon_adapter_interface;
use e_avalon_adapter_master;
use e_avalon_adapter_slave;





























package europa_all;
    use Exporter;
    @europa_all::ISA = ("Exporter");
    @europa_all::EXPORT = qw($VERSION);



    $europa_all::VERSION = "6.0";  # it is a dotted-number string,







1;

