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

































use europa_utils;
use e_mnemonic;
use strict;

sub make_instruction_spitter 
{
  my ($Opt, $project) = (@_);

  my @submodules = ( &make_wait_counter  ($Opt, $project),
                     &make_subinstruction($Opt, $project) );
  my $module = e_pipe_module->new 
      ({name        => $Opt->{name}."_instruction_scheduler",
        stage       => "Commit",
        project     => $project,
        pipe_clk_en => "commit",
     });
  my $marker = e_default_module_marker->new ($module);

  my $si_bits = e_mnemonic->subinstruction_bits();
  e_port->adds ([feed_new_instruction  => 1,        "out"],
                [subinstruction        => $si_bits, "out"],
                [is_subinstruction     => 1       , "out"],
                );


  foreach my $submodule (@submodules)
     {  e_instance->add ({module => $submodule->name()});   }


  e_assign->add({lhs => e_port->new([commit => 1, "out"]),
                 rhs => "( feed_new_instruction             ) && 
                         (~is_subinstruction                ) &&         
                         ( pipe_run                         )  ", });





















  




  e_register->add ({out         => e_port->new([is_neutrino => 1, "out"]),
                    in          => "p1_is_neutrino",
                    async_value => 1,
                    enable      => "pipe_run",
                 });

  e_assign->add ({lhs => "p1_is_neutrino", 
                  rhs => "instruction_not_ready && (~hold_for_hazard)",
                 });

  e_assign->add ({lhs => "instruction_not_ready", 
                  rhs => "(~feed_new_instruction                 ) | 
                          (d1_instruction_fifo_read_data_bad   &
                            ~is_subinstruction                   ) ",
                });























  e_register->add 
      ({out        => e_port->new([is_cancelled_from_commit_stage => 1,"out"]),
        sync_set   => "skip_acknowledge ||
                       cancel_delay_slot_acknowledge",
        sync_reset => "~p1_is_neutrino",
        priority   => "set",
        enable     => "commit",
       });
















  if ($Opt->{support_interrupts})
  {
     e_register->add ({out        => "dont_forget_to_cancel_delay_slot",
                       sync_set   => "do_cancel_next_instruction",
                       sync_reset => "(commit && (~d1_instruction_fifo_read_data_bad)) && cancel_delay_slot_acknowledge",
                       priority   => "reset",
                       enable     => "pipe_run",
                    });
     e_assign->add ({lhs => "cancel_delay_slot_acknowledge", 
                     rhs => "do_cancel_next_instruction || 
                             dont_forget_to_cancel_delay_slot"});
  } else {

     e_assign->add (["cancel_delay_slot_acknowledge", "1'b0"]);
  }














  e_assign->adds
      (["waiting_for_skip_outcome", "1'b1"                               ],
       ["qualified_skip_request",   "waiting_for_skip_outcome && do_skip"],);










  e_register->add 
      ({out        => "dont_forget_to_skip",
        sync_set   => "qualified_skip_request",
        sync_reset => " commit            && 
                        ~p1_is_neutrino   &&
                        skip_acknowledge  &&
                        ~do_iPFXx
                        ",
        priority   => "reset",
        enable     => "pipe_run",
     });
  e_assign->add (["skip_acknowledge", "qualified_skip_request || 
                                       dont_forget_to_skip"    ]);


  e_control_bit->add (qw(do_iPFXx));

  return $module;
} # end of new_contents

sub make_wait_counter
{
  my ($Opt, $project) = (@_);

  my $module = e_pipe_module->new 
      ({name        => $Opt->{name}."_wait_counter",
        stage       => "Commit",
        project     => $project,
        pipe_clk_en => "commit",
     });
  my $marker = e_default_module_marker->new ($module);
  my $depth = 3;

  my @delay_constant;
  for (my $i=0; $i<=$depth; $i++) {
    $delay_constant[$i] = $depth."'b". ("1"x($depth-$i)) . ("0"x$i);

  }
  e_port->add ([feed_new_instruction => 1, "out"]);
  e_signal->add (["instruction_delay",        $depth]),

  e_mux->add ({
     out  => "instruction_delay",
     table   => 
      ["(d1_instruction_fifo_read_data_bad) &  
        (commit                            )"  => $delay_constant[0], 
       "wait_once_after"                       => $delay_constant[1],
       "must_run_to_completion"                => $delay_constant[$depth],
       ],
      default                                  => $delay_constant[0],
     });
  
  my $run_to_completion_list 
      = $Opt->{fast_save_restore}                    ? 
        qq (=do_iSKPx WRCTL    RDCTL     TRAPx TRET) : 
        qq (=do_iSKPx WRCTL SAVE RESTORE TRAPx TRET) ; 

  e_control_bit->adds 
   ([must_run_to_completion => $run_to_completion_list                     ],
    [op_jmpcall             => qq (JMP CALL)                               ],
    qw(do_iSKPx),
   );

  my @wait_once_reasons = ("(op_jmpcall)");

  if ($Opt->{fast_save_restore}) 
  { 























     push (@wait_once_reasons, 
           "(op_save_restore && (trap_if_save    || 
                                 trap_if_restore ||
                                 ~is_neutrino      ) )",

           );
     


     if (!$Opt->{support_interrupts}) {
        e_assign->adds (["trap_if_save",    "1'b0"],
                        ["trap_if_restore", "1'b0"], );
     }

     e_control_bit->add  ([op_save_restore  => qq (SAVE RESTORE) ]);
  }

  e_assign->add (["wait_once_after", join (" || ", @wait_once_reasons)]);


  e_shift_register->add ({
        name            => "wait_counter_shift_register",
        serial_in       => "1'b1",
        serial_out      => "wait_counter_output",
        shift_length    => $depth,
        direction       => "LSB-first",
        parallel_in     => "instruction_delay",
        load            => "commit",
        enable          => "pipe_run           && 
                            (~|subinstruction) && 
                            ~hold_for_hazard    ",
     });



  my @feed_instruction_terms = 
      ("((wait_counter_output) | (|subinstruction))",
       "( ~hold_for_hazard                        )");
  push(@feed_instruction_terms, 
       "( ~do_force_trap                        )") 
      if ($Opt->{support_interrupts}); 

  e_assign->add 
      ({lhs => "feed_new_instruction", 
        rhs => &and_array (@feed_instruction_terms),
       });

  return $module;
}

sub make_subinstruction
{
  my ($Opt, $project) = (@_);

  my $module = e_pipe_module->new 
      ({name        => $Opt->{name}."_subinstruction_unit",
        stage       => "Commit",
        project     => $project,
        pipe_clk_en => "commit",
     });
  my $marker = e_default_module_marker->new ($module);

  my $si_bits = e_mnemonic->subinstruction_bits();
  return unless $si_bits > 0;

  e_port->add (["d1_instruction_fifo_out" => 16, "in"]);
    
  e_assign->add ({lhs => "subcount_en", 
                  rhs => "(feed_new_instruction & pipe_run)",
               });

  e_register->add 
      ({name      => "subinstruction_counter",
        out       => e_port->new ([subinstruction => $si_bits, "out"]),
        in        => "p1_subinstruction",
        enable    => "subcount_en",
     });

  e_mux->add ({lhs     => [p1_subinstruction => $si_bits],
               table   => ["(is_subinstruction)" => "subinstruction - 1"], 
               default  =>                    "p1_subinstruction_load_value",
            });

  my $load_value_mux = e_mux->add 
      ({lhs      => [p1_subinstruction_load_value => $si_bits],
        default  => "$si_bits\'b0",
      });


  $load_value_mux->add_table (d1_instruction_fifo_read_data_bad => 0);












  if ($Opt->{support_interrupts}) 
  {
     my $trap_mnem = e_mnemonic->get_mnemonic_by_name("TRAP")
         or &ribbit ("Holy moley!  running without TRAPs!");
     my $forced_trap_SIs = $trap_mnem->num_subinstructions()-1;
     $load_value_mux->add_table (force_trap_acknowledge   => $forced_trap_SIs);
  }




  foreach my $mnem (e_mnemonic->get_mnemonic_list())
  {

     next unless $mnem->num_subinstructions() > 1;

     my $selector = $mnem->make_match_expression("d1_instruction_fifo_out");
     $load_value_mux->add_table ($selector => $mnem->num_subinstructions()-1);
  }


  e_assign->add ({lhs => [is_subinstruction => 1, 1],
                  rhs => "(|(subinstruction)) & (~is_neutrino)", 
               });

  return $module;
}

"p'toey!";

