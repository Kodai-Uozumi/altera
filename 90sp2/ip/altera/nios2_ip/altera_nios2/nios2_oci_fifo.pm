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






















use cpu_utils;
use europa_all;
use nios2_common;
use strict;















sub make_nios2_oci_fifo
{
  my $Opt = shift;

  my $module = e_module->new ({
      name    => $Opt->{name}."_nios2_oci_fifo",
  });



  $module->add_contents (

    e_signal->news (
      ["tw",  $Opt->{oci_tm_width},1], # Trace message at head of fifo
    ),

    e_signal->news (
      ["itm", $Opt->{oci_tm_width},0], # instruction trace message written into fifo 
      ["atm", $Opt->{oci_tm_width},0], # data address trace message written into fifo
      ["dtm", $Opt->{oci_tm_width},0], # data value trace message written into fifo
      ["trc_ctrl", 16, 0],             # Trace control register
    ),

  );





  my $oci_fifo_depth = 1 << $Opt->{oci_fifo_addr_width}; 

  $module->add_contents (
    e_signal->news (
      ["fifohead",  $Opt->{oci_tm_width},             0,  1],
      ["fiforp",    $Opt->{oci_fifo_addr_width},      0,  1],
      ["fifowp",    $Opt->{oci_fifo_addr_width},      0,  1],
      ["fifocount", $Opt->{oci_fifo_addr_width} + 1,  0,  1],
      ["fifowp1",   $Opt->{oci_fifo_addr_width},      0,  1],
      ["fifowp2",   $Opt->{oci_fifo_addr_width},      0,  1],
      ["tm_count",  2,                                0,  1],
    ),
  );







  my $compute_tm_count_module = &make_nios2_compute_tm_count ($Opt);
  my $fifowp_inc_module =       &make_nios2_fifowp_inc ($Opt);
  my $fifocount_inc_module =    &make_nios2_fifocount_inc ($Opt);
  my ($testbench_module, $testbench_module_name) = &make_oci_testbench($Opt);

  $module->add_contents (





    e_assign->news (
      ["trc_this" => "trc_on ".               # trace is on
        "| (dbrk_traceon & ~dbrk_traceoff) ". # trace is about to turn on
        "| dbrk_traceme"],                    # trace one cycle

      ["itm_valid" => "|itm[".$Opt->{oci_tm_width}."-1 : ".$Opt->{oci_tm_width}."-4]"],
      ["atm_valid" => "|atm[".$Opt->{oci_tm_width}."-1 : ".$Opt->{oci_tm_width}."-4] & trc_this"],
      ["dtm_valid" => "|dtm[".$Opt->{oci_tm_width}."-1 : ".$Opt->{oci_tm_width}."-4] & trc_this"],

      ["free2" => "~fifocount[".$Opt->{oci_fifo_addr_width}."]"], # (fifocount <= 15)
      ["free3" => "~fifocount[".$Opt->{oci_fifo_addr_width}."] & ".
                  "~&fifocount[".$Opt->{oci_fifo_addr_width}."-1:0]"],

      ["empty" => "~|fifocount"], # (fifocount == 0)
      ["fifowp1" => "fifowp + 1"],
      ["fifowp2" => "fifowp + 2"],
    ),

    e_instance->new ({
      name    => $Opt->{name}."_nios2_oci_compute_tm_count_tm_count",
      module  => $compute_tm_count_module,
      port_map  => {
        itm_valid         =>  "itm_valid",
        atm_valid         =>  "atm_valid",
        dtm_valid         =>  "dtm_valid",
        compute_tm_count  =>  "compute_tm_count_tm_count",
      },
    }),
    e_assign->new ( ["tm_count" => "compute_tm_count_tm_count"],),


    e_instance->new ({
      name    => $Opt->{name}."_nios2_oci_fifowp_inc_fifowp",
      module  => $fifowp_inc_module,
      port_map  => {
        free2         => "free2",
        free3         => "free3",
        tm_count      => "tm_count",
        fifowp_inc    => "fifowp_inc_fifowp",
      },
    }),
    e_instance->new ({
      name    => $Opt->{name}."_nios2_oci_fifocount_inc_fifocount",
      module  => $fifocount_inc_module,
      port_map  => {
        empty         => "empty",
        free2         => "free2",
        free3         => "free3",
        tm_count      => "tm_count",
        fifocount_inc => "fifocount_inc_fifocount",
      },
    }),
    e_instance->new ({
      name    => "the_" . $testbench_module_name,
      module  => $testbench_module,
      port_map  => {
        itm_valid         =>  "itm_valid",
        itm               =>  "itm",
        atm_valid         =>  "atm_valid",
        atm               =>  "atm",
        dtm_valid         =>  "dtm_valid",
        dtm               =>  "dtm",
        trc_ctrl          =>  "trc_ctrl",
        test_ending       =>  "test_ending",
        test_has_ended    =>  "test_has_ended",
        dct_buffer        =>  "dct_buffer",
        dct_count         =>  "dct_count",
      },
    }),

    e_process->new ({
      clock     => "clk",
      reset     => "jrst_n",
      user_attributes_names => ["fiforp","fifowp","fifocount","ovf_pending"],
      user_attributes => [
        {
          attribute_name => 'SUPPRESS_DA_RULE_INTERNAL',
          attribute_operator => '=',
          attribute_values => [qw(R101)],
        },
      ],
      asynchronous_contents => [
        e_assign->news (
          ["fiforp" => "0"],
          ["fifowp" => "0"],
          ["fifocount" => "0"],
          ["ovf_pending" => "1"],
        ),
      ],
      contents  => [
        e_assign->news (
          ["fifowp" => "fifowp + fifowp_inc_fifowp"],
          ["fifocount" => "fifocount + fifocount_inc_fifocount"],
        ),
        e_if->new ({
          condition => "~empty",
          then => [ ["fiforp" => "fiforp + 1"] ],
        }),
        e_if->new ({
          condition => "~trc_this || (~free2 & tm_count[1]) ".
                       "  || (~free3 & (&tm_count))",
          then => [ ["ovf_pending" => "1"] ],
          elsif => { # overflow notification sent
            condition => "atm_valid | dtm_valid",
            then => [ ["ovf_pending" => "0"] ],
          },
        }),
      ],
    }),








    e_assign->news (
      ["fifohead" => "fifo_read_mux"],
      ["tw" => $Opt->{oci_data_trace}." ? ".
               " { (empty ? ".
               "      4'h0 ".
               "      : fifohead[".$Opt->{oci_tm_width}."-1 : ".$Opt->{oci_tm_width}."-4]),".
               "   fifohead[".$Opt->{oci_tm_width}."-5:0]} ".
               " : itm"],
    ),












































  );  # end of add_contents





  my @fifo_registers = ();
  my @fifo_read_mux_table;
  for (my $i=0; $i < $oci_fifo_depth ; $i++) {
    my $const = $Opt->{oci_fifo_addr_width} . "'d" . $i;
    push (@fifo_registers, 
      e_signal->new ({
        name  => "fifo_$i",
        width => $Opt->{oci_tm_width},
        never_export  => 1,
      }),
      e_signal->new ({
        name  => "fifo_$i\_enable",
        width => 1,
        never_export  => 1,
      }),
      e_assign->new ({
        lhs   => "fifo_$i\_enable",
        rhs   => "((fifowp == $const) && tm_count_ge1)  || ".
                 "(free2 && (fifowp1== $const) && tm_count_ge2)  ||".
                 "(free3 && (fifowp2== $const) && tm_count_ge3)    ",
      }),
      e_register->new ({
        out => "fifo_$i",
        in  => "fifo_$i\_mux",
        enable  => "fifo_$i\_enable", 
        clock => "clk",
      }), 
      e_signal->new ({
        name  => "fifo_$i\_mux",
        width => $Opt->{oci_tm_width},
        never_export  => 1,
      }),
      e_mux->new ({
        lhs   => "fifo_$i\_mux",
        table => [
          "(fifowp == $const) && itm_valid"     =>  "itm", 
          "(fifowp == $const) && atm_valid"     =>  "ovr_pending_atm", 
          "(fifowp == $const) && dtm_valid"     =>  "ovr_pending_dtm", 
          "(fifowp1 == $const) && (free2 & itm_valid & atm_valid)"  => "ovr_pending_atm", 
          "(fifowp1 == $const) && (free2 & itm_valid & dtm_valid)"  => "ovr_pending_dtm", 
          "(fifowp1 == $const) && (free2 & atm_valid & dtm_valid)"  => "ovr_pending_dtm", 
          "(fifowp2 == $const) && (free3 & itm_valid & atm_valid & dtm_valid)"  => "ovr_pending_dtm", 
        ],





      }),
    );
    push (@fifo_read_mux_table,
      $const  => "fifo_$i",
    );
  }

  $module->add_contents (

    @fifo_registers,


      e_assign->news (
        [["tm_count_ge1", 1, 0, 1],     "|tm_count"  ], # 1, 2, or 3 messages
        [["tm_count_ge2", 1, 0, 1],     "tm_count[1]"], # 2 or 3 messages
        [["tm_count_ge3", 1, 0, 1],     "&tm_count"  ], # 3 messages
      ),




    e_assign->news ( 
      [["ovr_pending_atm", $Opt->{oci_tm_width}],  
                        "{ovf_pending, atm[".($Opt->{oci_tm_width}-2).":0]}"],
      [["ovr_pending_dtm", $Opt->{oci_tm_width}], 
                        "{ovf_pending, dtm[".($Opt->{oci_tm_width}-2).":0]}"],
    ),


    e_mux->new ({
      lhs     => ["fifo_read_mux", $Opt->{oci_tm_width}, 0, 1],
      selecto => "fiforp",
      table   => [@fifo_read_mux_table],
    }),
  );

  return $module;
} # end module make_nios2_oci_fifo





sub make_nios2_compute_tm_count
{
  my $Opt = shift;

  my $module = e_module->new ({
      name    => $Opt->{name}."_nios2_oci_compute_tm_count",
  });



  $module->add_contents (

    e_signal->news (
      ["itm_valid", 1, 0,], 
      ["atm_valid", 1, 0,], 
      ["dtm_valid", 1, 0,], 
      ["compute_tm_count", 2, 1,],
    ),
    e_assign->new ([["switch_for_mux", 3, 0, 1], 
                            "{itm_valid, atm_valid, dtm_valid}"]),
    e_process->new ({
      clock => "",
      contents  => [
        e_case->new ({
          switch  => "switch_for_mux",
          parallel  => 0,
          full      => 0,
          contents  => {   
            "3'b000" => [compute_tm_count => 0],
            "3'b001" => [compute_tm_count => 1],
            "3'b010" => [compute_tm_count => 1],
            "3'b011" => [compute_tm_count => 2],
            "3'b100" => [compute_tm_count => 1],
            "3'b101" => [compute_tm_count => 2],
            "3'b110" => [compute_tm_count => 2],
            "3'b111" => [compute_tm_count => 3],
          },
        }),
      ],
    }),
  );

  return $module;
} # end module 






sub make_nios2_fifowp_inc
{
  my $Opt = shift;

  my $module = e_module->new ({
      name    => $Opt->{name}."_nios2_oci_fifowp_inc",
  });



  $module->add_contents (

    e_signal->news (
      ["free2",     1, 0,], 
      ["free3",     1, 0,], 
      ["tm_count",  2, 0,], 
      ["fifowp_inc", $Opt->{oci_fifo_addr_width}, 1,],
    ),
    e_process->new ({
      clock => "",
      contents  => [
        e_if->new ({
          condition => "free3 & (tm_count == 3)",
          then => [ ["fifowp_inc" => "3"] ],
          elsif => {
            condition => "free2 & (tm_count >= 2)",
            then => [ ["fifowp_inc" => "2"] ],
            elsif => {
              condition => "tm_count >= 1",
              then => [ ["fifowp_inc" => "1"] ],
              else => ["fifowp_inc" => "0"],
            },
          },
        }),
      ],
    }),
  );
  return $module;
} # end module 










sub make_nios2_fifocount_inc
{
  my $Opt = shift;

  my $module = e_module->new ({
      name    => $Opt->{name}."_nios2_oci_fifocount_inc",
  });



  $module->add_contents (

    e_signal->news (
      ["empty",     1, 0,], 
      ["free2",     1, 0,], 
      ["free3",     1, 0,], 
      ["tm_count",  2, 0,], 
      ["fifocount_inc", $Opt->{oci_fifo_addr_width} + 1 , 1,],
    ),
    e_process->new ({
      clock => "",
      contents  => [
        e_if->new ({
          condition => "empty",
          then => [ 

            ["fifocount_inc" => "tm_count[1:0]"],
          ],
          elsif => {  # writing n and reading 1
            condition => "free3 & (tm_count == 3)",
            then => [ ["fifocount_inc" => "2"] ],
            elsif => {
              condition => "free2 & (tm_count >= 2)",
              then => [ ["fifocount_inc" => "1"] ],
              elsif => {
                condition => "tm_count >= 1",
                then => [ ["fifocount_inc" => "0"] ],
                else  => ["fifocount_inc" => 
                          "{".($Opt->{oci_fifo_addr_width}+1)."{1'b1}}"],
              },
            },
          },
        }),
      ],
    }),
  );
  return $module;
}





sub make_oci_testbench
{
  my $Opt = shift;

  my $module_name = $Opt->{name}."_oci_test_bench";



  my $module_filename = $module_name;

  my $module = e_module->new ({
      name          => $module_name,
      output_file   => $module_filename,
  });

  my $file_name = $Opt->{name} . ".comptr";
  my $file_handle = "comptr_handle";

  my $tm_data_width = $Opt->{oci_tm_width}-4;     # bits in tm data field
  my $dct_count_width = ($tm_data_width > 16) ? 4 : 3;  # Num bits in pending DCT counter

  $module->add_contents (

    e_signal->news (
      ["itm_valid", 1], 
      ["itm", $Opt->{oci_tm_width}, 0],
      ["atm_valid", 1], 
      ["atm", $Opt->{oci_tm_width}, 0],
      ["dtm_valid", 1], 
      ["dtm", $Opt->{oci_tm_width}, 0],
      ["trc_ctrl", 16],
      ["test_ending", 1],       # Asserted for one cycle when test end detected
      ["test_has_ended", 1],    # Same as test_ending but stays high
      ["dct_buffer", $tm_data_width-2],      # Partially completed DCT frame
      ["dct_count", $dct_count_width],       # Number of DCT instructions in DCT buffer
    ),
  );



  $module->sink_signals(
    "test_ending",
    "test_has_ended",
    "dct_buffer",
    "dct_count",
  );

  if ($create_comptr) {
      $module->add_contents (

        e_sim_fopen->new({
          file_name        => $file_name,
          file_handle      => $file_handle,
          contents         => [
            e_sim_write->new ({
               spec_string => "Version 1\\n",
               file_handle => $file_handle,
            }),
    
            e_sim_write->new ({
               spec_string => "Nios2Info" . 
                 sprintf(" %x", $Opt->{general_exception_addr}) .
                 sprintf(" %x", $Opt->{fast_tlb_miss_exception_addr}) . "\\n",
               file_handle => $file_handle,
            }),
    

            e_sim_write->new ({
               spec_string => "TraceMode 1 7 0\\n",
               file_handle => $file_handle,
            }),
    


            e_sim_write->new ({
               spec_string => "%h%h\\n",
               expressions => ["$TM_GAP", "32'd" . $Opt->{reset_addr}],
               show_time   => 1,
               file_handle => $file_handle,
            }),
          ],
        }),
    
        e_process->new({
          tag      => "simulation",
          contents => [
            e_if->new({ 
              condition => "itm_valid",
              then      => [ 
                e_sim_write->new ({
                  spec_string => "%h\\n",
                  expressions => ["~test_has_ended & itm"],
                  show_time   => 1,
                  file_handle => $file_handle,
                })
              ],
            }),
            e_if->new({ 
              condition => "atm_valid",
              then      => [ 
                e_sim_write->new ({
                  spec_string => "%h\\n",
                  expressions => ["~test_has_ended & atm"],
                  show_time   => 1,
                  file_handle => $file_handle,
                })
              ],
            }),
            e_if->new({ 
              condition => "dtm_valid",
              then      => [ 
                e_sim_write->new ({
                  spec_string => "%h\\n",
                  expressions => ["~test_has_ended & dtm"],
                  show_time   => 1,
                  file_handle => $file_handle,
                })
              ],
            }),

            e_if->new({ 
              condition => "test_ending & (dct_count != 0)",
              then => [
                e_sim_write->new ({
                  spec_string => "%h\\n",
                  expressions => ["{$TM_DCT, dct_buffer, 2'b00}"],
                  show_time   => 1,
                  file_handle => $file_handle,
                })
              ],
            }),
          ],
        }),
      );
  }

  return ($module, $module_name);
} # end module 

1;
