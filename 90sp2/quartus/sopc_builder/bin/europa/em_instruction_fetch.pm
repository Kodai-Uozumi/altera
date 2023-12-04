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
use strict;

sub make_instruction_fetch 
{
   my ($Opt, $project) = (@_);
   
   my @submodules =(&make_Instruction_Address_Request($Opt, $project),
                    &make_target_address_unit        ($Opt, $project),
                    );
   
   my $module = e_module->new ({name => $Opt->{name}."_instruction_fetch"});
   $project->add_module ($module);      
   my $marker = e_default_module_marker->new ($module);

   $module->add_attribute (auto_dissolve => "FALSE");

   foreach my $submod (@submodules) 
     { e_instance->add({module => $submod->name()}); }
   




   e_assign->add 
       ({lhs => e_port->new ([ic_address => $Opt->{i_Address_Width}, "out"]),
         rhs => "{pc, {1'b0}}", 
      });


   e_port->add ([target_address => ($Opt->{i_Address_Width} - 1) , "out"]);

   return $module;
} 










































sub make_target_address_unit
{
   my ($Opt, $project) = (@_);

   my $module = e_module->new ({name => $Opt->{name}."_target_address"});
   $project->add_module ($module);      
   my $marker = e_default_module_marker->new ($module);






   my $PC_bits = $Opt->{i_Address_Width} - 1;
   e_assign->add 
       ({lhs    => [branch_target_address => $PC_bits],
         rhs    => "branch_base + signed_branch_offset",
       });

   my $pc_width = $Opt->{i_Address_Width} - 1;
   my $behavioral_tag = $Opt->{use_lcells} ? "simulation" : "normal";






























   if ($Opt->{use_lcells}) 
   {
      foreach my $i (0..$pc_width-1)
      {
         if ($Opt->{use_apex_lcells}) 
         {
            e_lcell->add 
             ({name          => "target_address_$i",
               tag           => "synthesis",
               parameter_map => {lut_mask       => "ACAC",
                                 operation_mode => "normal",
                                 id             => $i,
                                },
               port_map      => {dataa   => "jump_target_address    [$i]",
                                 datab   => "branch_target_address  [$i]",
                                 datac   => "do_jump",  
                                 datad   => "1'b0",  
                                 regout  => "last_target_address    [$i]",
                                 combout => "current_target_address [$i]",
                                 
                                 ena    => "pipe_run && (do_jump | do_branch)",
                                 clk    => "clk",
                                 aclr   => "~reset_n",
                                 },
               });
         } else {

            e_lcell->add 
             ({name          => "target_address_$i",
               tag           => "synthesis",
               parameter_map => {lut_mask       => "ACAC",
                                 operation_mode => "normal",
                                 id             => $i,
                                 lpm_type       => "yeager_lcell",
                                },
               port_map      => {dataa   => "jump_target_address    [$i]",
                                 datab   => "branch_target_address  [$i]",
                                 datac   => "do_jump",  
                                 datad   => "1'b0",  
                                 regout  => "last_target_address    [$i]",
                                 combout => "current_target_address [$i]",
                                 
                                 ena    => "pipe_run && (do_jump | do_branch)",
                                 clk    => "clk",
                                 aclr   => "~reset_n",
                                 },
               module        => "yeager_lcell_hidden_from_quartus",
               });
         }
      }
   }
   
   e_assign->add 
       ({lhs => [current_target_address => $pc_width],
         rhs => "do_jump ? jump_target_address : branch_target_address",
         tag => $behavioral_tag,
        });

   e_register->add 
       ({out    => [last_target_address => $pc_width],
         in     => "current_target_address",
         enable => "pipe_run && (do_jump || do_branch)",
         tag    => $behavioral_tag,
       });



   e_assign->add 
       ({lhs   => e_port->new ([target_address => $pc_width, "out"]), 
         rhs   => "(do_jump || do_branch)   ? 
                    current_target_address  : 
                    last_target_address     ",
       });
   
   return $module;
}











sub make_Instruction_Address_Request
{
   my ($Opt, $project) = (@_);

   my $module = e_module->new ({name => $Opt->{name}."_address_request"});
   $project->add_module ($module);      
   my $marker = e_default_module_marker->new ($module);

   my $pc_width = $Opt->{i_Address_Width} - 1;
   my $reset_instr_address = $$Opt{"Reset_Address"} >> 1;



   e_register->add ({out         => e_port->new ([pc => $pc_width, "out"]),
                     in          => "next_pc",
                     enable      => "pc_clken",  # see definition below
                     async_value => $reset_instr_address,
                  });
 
   e_assign->add ({lhs => [next_pc_plus_one => $pc_width],
                   rhs => "pc + 1", 
                });
 
   e_assign->add ({
      lhs => [pc_clken => 1],
      rhs => "(ic_read | p1_flush) & ~ic_wait",
   });


   e_assign->add 
       ({lhs => [next_pc => $pc_width],
         rhs => "(do_jump | do_branch | 
                 (remember_to_flush & ~waiting_for_delay_slot)) ? 
                    target_address                              :
                    next_pc_plus_one                        ",
       });
 
   e_assign->add (["nonsequential_pc", "(do_branch | do_jump) & pipe_run"]); 
 




   if ($Opt->{cache_has_icache}) {
    e_assign->add ({
      lhs => e_port->new ([ic_address_m1 => $Opt->{i_Address_Width}, "out"]),
      rhs => "{next_pc, {1'b0}}", 
    });
    e_assign->add ({
      lhs => e_port->new ([ic_address_clken => 1, "out"]),
      rhs => "pc_clken", 
    });
   }

   e_register->add ({out    => e_port->new ([ic_flush => 1, "out"]),
                     in     => "p1_flush",
                     enable => "~ic_wait",
                  });
 












   e_assign->add
     ({lhs => e_port->new([p1_flush => 1, "out"]),
       rhs => "(nonsequential_pc  & ~d1_instruction_fifo_read_data_bad )  | 
               (remember_to_flush & ~waiting_for_delay_slot            )  ",
        });
 











   e_register->add
       ({out        => "remember_to_flush",
         sync_set   => "nonsequential_pc & 
                       (d1_instruction_fifo_read_data_bad | ic_wait)",
         sync_reset => "p1_flush & ~ic_wait",
         priority   => "reset",
         enable     => "1'b1",        # We'll be sorry for this...
       });
 







   e_register->add
       ({out        => "waiting_for_delay_slot",
         sync_set   => "nonsequential_pc && d1_instruction_fifo_read_data_bad",
         sync_reset => "~instruction_fifo_read_data_bad",
         priority   => "reset",
         enable     => "pipe_run",        
      });
 
   return $module;
}

1; # every perl module ends with 1.





