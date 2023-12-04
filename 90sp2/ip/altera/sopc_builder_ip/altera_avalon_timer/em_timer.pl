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






















































use europa_all;
use strict;



my $project = e_project->new(@ARGV);


my $Options = &copy_of_hash($project->WSA());


$Options->{clock_freq} = 
  $project->get_module_clock_frequency();

&make_timer ($project->top(), $Options);

$project->output();









sub Validate_Timer_Options
{
  my ($Timer_Options) = (@_);





  &validate_parameter ({hash    => $Timer_Options,
                        name    => "fixed_period",
                        type    => "boolean",
                        default => 0,
                       });





  &validate_parameter ({hash    => $Timer_Options,
                        name    => "snapshot",
                        type    => "boolean",
                        default => 1,
                       });





  &validate_parameter ({hash    => $Timer_Options,
                        name    => "always_run",
                        type    => "boolean",
                        default => 0,
                       });






  &validate_parameter ({hash    => $Timer_Options,
                        name    => "timeout_pulse_output",
                        type    => "boolean",
                        default => 0,
                       });






  &validate_parameter ({hash    => $Timer_Options,
                        name    => "reset_output",
                        type    => "boolean",
                        default => 0,
                       });

  &validate_parameter ({hash    => $Timer_Options,
                        name    => "period",
                        type    => "string",
                        default => 0,
                       });
  
  &validate_parameter ({hash    => $Timer_Options,
                        name    => "counter_size",
                        type    => "int",
                        allowed => [32,64],
                        default => 32,
                       });
  
  



  &ribbit ("fixed-period timers must specify a nonzero period") 
    if ($Timer_Options->{fixed_period} && ($Timer_Options->{period} == 0));


  &validate_parameter ({hash    => $Timer_Options,
                        name    => "period_units",
                        type    => "string",
                        allowed => ["ns",
                                    "us",
                                    "usec",
                                    "ms",
                                    "msec",
                                    "s",
                                    "sec",
                                    "clocks",
                                    "clock"],
                        default => "sec",
                       });








  if (!$Timer_Options->{load_value}) {
    if ($Timer_Options->{period_units} =~ /^clock/i) {
      $Timer_Options->{load_value} = $Timer_Options->{period} - 1;
    } else {
      &ribbit ("bad period_unit value: $Timer_Options->{period_units}") 
        unless $Timer_Options->{period_units} =~ /^(\w*)s(ec)?$/i;
  
      my $t = $Timer_Options->{period} * &unit_prefix_to_num ($1);
      















      
      my $temp = $t * $Timer_Options->{clock_freq};
      my $load_value = sprintf("%.0f",$temp);
      

      $load_value = $load_value - 1;

      $Timer_Options->{load_value} = $load_value<1?1:$load_value;
    }
  } 

  $Timer_Options->{counter_bits} = 
    &Bits_To_Encode ($Timer_Options->{load_value});

  &ribbit ("Timepout value ", $Timer_Options->{period}, 
           $Timer_Options->{period_units}, " is too long for a ",$Timer_Options->{counter_size},"-bit counter")
    if ($Timer_Options->{counter_bits} > $Timer_Options->{counter_size});

  if (($Timer_Options->{load_value} < 1) && 
      ($Timer_Options->{period} != 0)      ) {
    &ribbit ("Timepout value ", $Timer_Options->{period}, 
             $Timer_Options->{period_units}, " is less than one clock.\n",
             "  using minimum possible value (1 clock period).");
  }

  $Timer_Options->{counter_bits} = $Timer_Options->{counter_size} if !$Timer_Options->{fixed_period};
}








sub make_timer
{
  my ($module, $Timer_Options) = (@_);
  &Validate_Timer_Options ($Timer_Options);





  my $marker = e_default_module_marker->new($module);


  e_assign->add (["clk_en", 1]);






  e_signal->adds(["internal_counter",   $Timer_Options->{counter_bits}],
                 ["counter_load_value", $Timer_Options->{counter_bits}]);






  my $load_value_string = sprintf("%d'h%X", 
                                  $Timer_Options->{counter_bits},
                                  $Timer_Options->{load_value},   );
  
  e_register->add ({out         => "internal_counter",
                    in          => "internal_counter - 1",
                    enable      => "(counter_is_running || force_reload)",
                    sync_set    => "(counter_is_zero    || force_reload)",
                    set_value   => "counter_load_value",
                    async_value => $load_value_string,
                   });

  e_assign->add(["counter_is_zero", "(internal_counter == 0)"]);






  if ($Timer_Options->{fixed_period})
  {
    e_assign->add (["counter_load_value", $Timer_Options->{load_value}]);
   } else {
     if ($Timer_Options->{counter_size} == 64 ) {
         e_assign->add (["counter_load_value",
                         &concatenate("period_halfword_3_register", "period_halfword_2_register","period_halfword_1_register", "period_halfword_0_register"),
                       ]);
     } else { 
         e_assign->add (["counter_load_value",
                         &concatenate("period_h_register", "period_l_register"),
                        ]);  
     }
  }

  if ($Timer_Options->{counter_size} == 64 ) {
    e_register->add ({out => "force_reload",
                      in  => "(period_halfword_3_wr_strobe || period_halfword_2_wr_strobe || period_halfword_1_wr_strobe || period_halfword_0_wr_strobe)",
                   });
  } else { 
    e_register->add ({out => "force_reload",
                      in  => "(period_h_wr_strobe || period_l_wr_strobe)",
                    });
  }  





















  if ($Timer_Options->{always_run}) 
  {
     if ($Timer_Options->{reset_output}) {
        e_assign->add (["do_start_counter", "start_strobe"]);
     } else { 
        e_assign->add (["do_start_counter", "1"]);
     }
     e_assign->add    (["do_stop_counter",  "0"]);
  } else {
     e_assign->add (["do_start_counter", "start_strobe"]);
     e_assign->add
      (["do_stop_counter", "(stop_strobe                            ) ||
                            (force_reload                           ) ||
                            (counter_is_zero && ~control_continuous )  "]);
  }
  e_register->add ({out         => "counter_is_running",
                    sync_set    => "do_start_counter",
                    sync_reset  => "do_stop_counter",
                    priority    => "set",
                    async_value => "1'b0",
                   });









  e_edge_detector->add ({in   => "counter_is_zero",
                         out  => "timeout_event",
                         edge => "rising",
                        });

  e_register->add ({out        => "timeout_occurred",
                    sync_set   => "timeout_event",
                    sync_reset => "status_wr_strobe",
                   });

  e_assign->add(["irq", "timeout_occurred && control_interrupt_enable"]);










  e_avalon_slave->add ({name => "s1",});  

  e_port->adds (["writedata", 16, "in"],
                ["readdata",  16, "out"],
               );
  
  if ($Timer_Options->{counter_size} == 64 ) {
      e_port->adds (["address",    4, "in"]);
  } else { 
      e_port->adds (["address",    3, "in"]);
  }



  if ($Timer_Options->{timeout_pulse_output}) {
    e_port->add   (["timeout_pulse", 1, "out"]);
    e_assign->add (["timeout_pulse", "timeout_event"]);
  }






  if ($Timer_Options->{reset_output}) {
    e_port->add   (["resetrequest", 1, "out"]);
    e_assign->add (["resetrequest", "timeout_occurred"]);
  }




  my $read_mux = e_mux->add ({lhs  => e_signal->add (["read_mux_out", 16]),
                              type => "and-or",
                             });




  e_register->add ({out => "readdata",
                    in  => "read_mux_out"});




  if ($Timer_Options->{counter_size} == 64 ) {
      e_assign->adds 
         (["period_halfword_0_wr_strobe", "chipselect && ~write_n && (address == 2)"],
          ["period_halfword_1_wr_strobe", "chipselect && ~write_n && (address == 3)"],
          ["period_halfword_2_wr_strobe", "chipselect && ~write_n && (address == 4)"],
          ["period_halfword_3_wr_strobe", "chipselect && ~write_n && (address == 5)"]);
  } else { 
      e_assign->adds 
         (["period_l_wr_strobe", "chipselect && ~write_n && (address == 2)"],
          ["period_h_wr_strobe", "chipselect && ~write_n && (address == 3)"]);
  }

  if (!$Timer_Options->{fixed_period}) 
  {
     if ($Timer_Options->{counter_size} == 64 ) {
        e_register->adds (
                          {out         => e_signal->add(["period_halfword_0_register", 16]),
                           in          => "writedata",
                           async_value => ($Timer_Options->{load_value} & 0xFFFF),
                           enable      => "period_halfword_0_wr_strobe",
                          },
    
                          {out         => e_signal->add(["period_halfword_1_register", 16]),
                           in          => "writedata",
                           async_value => (($Timer_Options->{load_value} >> 16)  & 0xFFFF),
                           enable      => "period_halfword_1_wr_strobe",
                          },
    
                          {out         => e_signal->add(["period_halfword_2_register", 16]),
                           in          => "writedata",
                           async_value => (($Timer_Options->{load_value} >> 32)  & 0xFFFF),
                           enable      => "period_halfword_2_wr_strobe",
                          },
    
                          {out         => e_signal->add(["period_halfword_3_register", 16]),
                           in          => "writedata",
                           async_value => (($Timer_Options->{load_value} >> 48)  & 0xFFFF),
                           enable      => "period_halfword_3_wr_strobe",
                          });
    
        $read_mux->add_table("(address == 2)" => "period_halfword_0_register",
                             "(address == 3)" => "period_halfword_1_register",
                             "(address == 4)" => "period_halfword_2_register",
                             "(address == 5)" => "period_halfword_3_register");
     } else { 
        e_register->adds (
                          {out         => e_signal->add(["period_l_register", 16]),
                           in          => "writedata",
                           async_value => ($Timer_Options->{load_value} & 0xFFFF),
                           enable      => "period_l_wr_strobe",
                          },
    
                          {out         => e_signal->add(["period_h_register", 16]),
                           in          => "writedata",
                           async_value => ($Timer_Options->{load_value} >> 16),
                           enable      => "period_h_wr_strobe",
                          });
    
        $read_mux->add_table("(address == 2)" => "period_l_register",
                             "(address == 3)" => "period_h_register");
     }
     
  }




  if ($Timer_Options->{snapshot}) {
     if ($Timer_Options->{counter_size} == 64 ) {
        e_assign->adds 
          (["snap_halfword_0_wr_strobe", "chipselect && ~write_n && (address == 6)"],
           ["snap_halfword_1_wr_strobe", "chipselect && ~write_n && (address == 7)"],
           ["snap_halfword_2_wr_strobe", "chipselect && ~write_n && (address == 8)"],
           ["snap_halfword_3_wr_strobe", "chipselect && ~write_n && (address == 9)"],
           ["snap_strobe",      "snap_halfword_0_wr_strobe ||snap_halfword_1_wr_strobe ||snap_halfword_2_wr_strobe ||snap_halfword_3_wr_strobe"    ]);
    
        $read_mux->add_table ("(address == 6)" => 'snap_read_value[15: 0]',
                              "(address == 7)" => 'snap_read_value[31:16]',
                              "(address == 8)" => 'snap_read_value[47:32]',
                              "(address == 9)" => 'snap_read_value[63:48]',
                              );
     } else { 
        e_assign->adds 
          (["snap_l_wr_strobe", "chipselect && ~write_n && (address == 4)"],
           ["snap_h_wr_strobe", "chipselect && ~write_n && (address == 5)"],
           ["snap_strobe",      "snap_l_wr_strobe || snap_h_wr_strobe"    ]);
    
        $read_mux->add_table ("(address == 4)" => 'snap_read_value[15: 0]',
                              "(address == 5)" => 'snap_read_value[31:16]',
                              );
     }
     
     e_register->add({in     => "internal_counter",
                      enable => "snap_strobe",
                      out    => e_signal->add (["counter_snapshot", 
                                                $Timer_Options->{counter_bits}]),
                     });
   
     e_assign->add([
                    e_signal->add (["snap_read_value", $Timer_Options->{counter_size}]),
                    "counter_snapshot"]);
     
  }














  e_assign->add
      (["control_wr_strobe", "chipselect && ~write_n && (address == 1)"]);

  e_signal->add ({name  => "control_register",
                  width => ($Timer_Options->{always_run} ? 1 : 4),
                 });

  e_register->add ({out    => "control_register",
                    in     => 'writedata[control_register.msb : 0]',
                    enable => "control_wr_strobe",
                   });

  $read_mux->add_table("(address == 1)" => "control_register");


  if (!$Timer_Options->{always_run}) {
    e_assign->adds 
      (["stop_strobe",        'writedata[3] && control_wr_strobe'],
       ["start_strobe",       'writedata[2] && control_wr_strobe'],
       ["control_continuous", 'control_register[1]'              ]);
  }
  elsif ($Timer_Options->{reset_output})
  {
    e_assign->adds 
        (["start_strobe",     'writedata[2] && control_wr_strobe']);
  }






  e_assign->add(["control_interrupt_enable", 'control_register']);







  e_assign->add
      (["status_wr_strobe", "chipselect && ~write_n && (address == 0)"]);

  $read_mux->add_table
   ("(address == 0)" => &concatenate("counter_is_running","timeout_occurred"));

  return $module;
}
