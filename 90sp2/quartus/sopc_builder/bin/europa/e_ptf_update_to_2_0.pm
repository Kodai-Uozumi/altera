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







=head1 NAME

e_ptf_update_to_2_0 - description of the module goes here ...

=head1 SYNOPSIS

The e_ptf_update_to_2_0 class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_ptf_update_to_2_0;
@ISA = ("e_ptf");
use e_ptf;
use europa_utils;
use strict;







my %fields   = (need_to_write_file => 0,) ;
my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );










=item I<ptf_hash()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub ptf_hash
{
   my $this = shift;
   if (@_)
   {
      $this->SUPER::ptf_hash(@_);
      $this->ptf_update();
      $this->ptf_to_file()
          if ($this->need_to_write_file());
   }
   return ($this->SUPER::ptf_hash());
}










=item I<ptf_update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub ptf_update
{
   my $this = shift;


   my @slaves;
   my $nios_hash;
   my $nios_data_width;

   my $nios_name;

   my $system_hash;
   foreach my $system (keys %{$this->ptf_hash()})
   {
      die unless ($system =~ /SYSTEM\s+/);
      die ("more than one system")
          if ($system_hash);

      $system_hash = $this->ptf_hash()->{$system};


      my $SWV = $system_hash->{System_Wizard_Version};


      while ($SWV =~ s/^(.*?\..*)\./$1/s){;}

      return if ($SWV >= 2.0);
      $this->need_to_write_file(1);
      $system_hash->{System_Wizard_Version} = "2.0";

      foreach my $module (keys %{$system_hash})
      {
         next unless ($module =~ /MODULE\s+(\w+)/);
         my $name = $1;
         my $mod = $system_hash->{$module};
         $mod->{class_version} = "2.0";
         delete ($mod->{SYSTEM_BUILDER_INFO}{Is_Bus_Master});



         my $port_wiring = $mod->{PORT_WIRING};
         foreach my $port (keys (%$port_wiring))
         {
            if ($port_wiring->{$port}{avalon_role})
            {
               $port_wiring->{$port}{type} = 
                   $port_wiring->{$port}{avalon_role};
               $port_wiring->{$port}{type} =~ s/n$/\_n/;
               $port_wiring->{$port}{type} =~ s/^registeredselect
                                               /chipselect/six;
               delete ($port_wiring->{$port}{avalon_role});
            }
         }

         my $class = $mod->{class};
         if ((
              $class =~ s/(altera_nios_dev_board_flash)_small/$1/)||
             ($class =~ s/altera_nios_dev_board_sram16
              /altera_nios_dev_board_sram32/x)
             )
         {
            $mod->{class} = $class;
         }

         my $sbi   = $mod->{SYSTEM_BUILDER_INFO};
         my $wsa   = $mod->{WIZARD_SCRIPT_ARGUMENTS};

         delete $wsa->{Uses_Registered_Select_Signal};
         if ($class eq "altera_nios")
         {
            &ribbit ("more than one nios\n")
                if ($nios_hash);
            $nios_hash = $system_hash->{$module};
            $nios_name = $name;

            $nios_data_width = $nios_hash->{SYSTEM_BUILDER_INFO}
            {Data_Width}
            or die "1.1 cpu $name has no data width\n";

            my $wsa = $nios_hash->{WIZARD_SCRIPT_ARGUMENTS};

            $wsa->{CPU_Architecture} = "nios_$nios_data_width";
            $wsa->{DM_SBI} = {Data_Width => $nios_data_width};
	    $wsa->{mainmem_offset} = "0x0";
	    $wsa->{datamem_offset} = "0x0";
         }
         elsif ($class eq "altera_avalon_onchip_memory")
         {
            my $address_span =
                $mod->{SYSTEM_BUILDER_INFO}{Address_Span};

            if ($address_span)
            {
               $wsa->{Size_Value} = $address_span;
               $wsa->{Size_Multiple} = 1;
               $wsa->{Shrink_to_fit_contents} = 0;
            }

            $sbi->{Read_Latency} = 1;
            my $contents = $mod->{WIZARD_SCRIPT_ARGUMENTS}
            {Contents};
            my $initfile = $mod->{WIZARD_SCRIPT_ARGUMENTS}
            {Initfile};

            $contents =~ s/^user_file$/textfile/;
            $initfile = "" 
                if ($contents eq "germs");
            delete $mod->{WIZARD_SCRIPT_ARGUMENTS}{Contents};
            delete $mod->{WIZARD_SCRIPT_ARGUMENTS}{Initfile};

            $mod->{WIZARD_SCRIPT_ARGUMENTS}{"CONTENTS srec"} = 
            {
               Kind => $contents,
               Build_Info    => "",
               Command_Info  => "",
               Textfile_Info => $initfile,
               String_Info   => "",
            };
         }
         elsif ($class eq "altera_avalon_uart")
         {
            $mod->{WIZARD_SCRIPT_ARGUMENTS}{sim_true_baud} = "0";
	    $mod->{WIZARD_SCRIPT_ARGUMENTS}{use_cts_rts} = "0";
	    $mod->{WIZARD_SCRIPT_ARGUMENTS}{use_eop_register} = "0";
	    $mod->{WIZARD_SCRIPT_ARGUMENTS}{sim_char_stream} = "";
         }
         elsif ($class eq "altera_avalon_timer")
         {
            $mod->{WIZARD_SCRIPT_ARGUMENTS} = 
            {
               always_run => "0",
               fixed_period => "0",
               mult => "0.001",
               period => "1",
               period_units => "msec",
               reset_output => "0",
               snapshot => "1",
               timeout_pulse_output => "0",
            };
         }
	 elsif ($class eq "altera_nios_dev_board_sram32")
	 {
	    $sbi->{Make_Memory_Model} = "1";
	    if ($mod->{SYSTEM_BUILDER_INFO}{Data_Width} == 16)
	    {
	      $mod->{WIZARD_SCRIPT_ARGUMENTS} =
              {
	      	sram_memory_size => "32",
              	sram_memory_units => "1024",
              	sram_data_width => "16",
              	"CONTENTS srec" =>
            	   {
            	   Kind        => "blank", # one of germs, blank, build, command, textfile, or string
            	   Build_Info => "",       # if Kind is build...
	    	   Command_Info => "",     # if Kind is command...
	    	   Textfile_Info => "",    # if Kind is textfile
	    	   String_Info => "",      # if Kind is string
            	   }
             };
              $mod->{SYSTEM_BUILDER_INFO}{Address_Span} = 32768;
	    }
	    else
	    {
	      $mod->{WIZARD_SCRIPT_ARGUMENTS} =
              {
	      	sram_memory_size => "256",
              	sram_memory_units => "1024",
              	sram_data_width => "32",
              	"CONTENTS srec" =>
            	   {
            	   Kind        => "blank", # one of germs, blank, build, command, textfile, or string
            	   Build_Info => "",       # if Kind is build...
	    	   Command_Info => "",     # if Kind is command...
	    	   Textfile_Info => "",    # if Kind is textfile
	    	   String_Info => "",      # if Kind is string
                  } 
             };
             $mod->{SYSTEM_BUILDER_INFO}{Address_Span} = 262144;
	    }
         }
	 elsif ($class eq "altera_avalon_cs8900")
         {
	    $mod->{WIZARD_SCRIPT_ARGUMENTS} = 
               {
         	   CONSTANTS =>
         	   {
         	      "CONSTANT PLUGS_PLUG_COUNT" =>
         	      {
         		 value => "5",
         		 comment => "Maximum number of plugs",
         	      },
         	      "CONSTANT PLUGS_ADAPTER_COUNT" =>
         	      {
         		 value => "2",
         		 comment => "Maximum number of adapters",
         	      },
         	      "CONSTANT PLUGS_DNS" =>
         	      {
         		 value => "1",
         		 comment => "Have routines for DNS lookups",
         	      },
         	      "CONSTANT PLUGS_PING" =>
         	      {
         		 value => "1",
         		 comment => "Respond to icmp echo (ping) messages",
         	      },
         	      "CONSTANT PLUGS_TCP" =>
         	      {
         		 value => "1",
         		 comment => "Support tcp in/out connections",
         	      },
         	      "CONSTANT PLUGS_IRQ" =>
         	      {
         		 value => "1",
         		 comment => "Run at interrupte level",
         	      },
         	      "CONSTANT PLUGS_DEBUG" =>
         	      {
         		 value => "1",
         		 comment => "Support debug routines",
         	      },
         	   }
         	}
	 }
	 elsif ($class eq "altera_avalon_user_defined_interface")
	 {
		$mod->{do_black_box} = 0;
		$mod->{WIZARD_SCRIPT_ARGUMENTS} =
		{
		  HDL_Import => "1",
		  Nios_Gen_Waits => "1",
                  Synthesize_Imported_HDL => "1",
		};
	 }

         push (@slaves,$system_hash->{$module})
             unless $class eq "altera_nios";
      }
   }


   foreach my $system_wsa (
                           "mainmem_module",
                           "datamem_module",
                           "maincomm_module",
                           "gdbcomm_module",
                           "germs_monitor_id",
                           "reset_offset",
                           "reset_module",
                           "vecbase_offset",
                           "vecbase_module",
                           )
   {
      my $value =
          $system_hash->{WIZARD_SCRIPT_ARGUMENTS}{$system_wsa};

      delete ($system_hash->{WIZARD_SCRIPT_ARGUMENTS}{$system_wsa});

      my $new_wsa = $system_wsa;
      $new_wsa =~ s/gdbcomm/debugcomm/;
      if ($new_wsa =~ s/\_module$/\_slave/)
      {
         $value .= "/s1"
	   if ($value);
         delete ($nios_hash->{WIZARD_SCRIPT_ARGUMENTS}{$system_wsa});
      }
      $nios_hash  ->{WIZARD_SCRIPT_ARGUMENTS}{$new_wsa} = $value;

   }

   delete ($system_hash->{WIZARD_SCRIPT_ARGUMENTS}
           {Principal_Tri_State_Data_Bus});
   $system_hash->{WIZARD_SCRIPT_ARGUMENTS}{generate_sdk} = 1;
   $system_hash->{WIZARD_SCRIPT_ARGUMENTS}{generate_hdl} = 1;
   $system_hash->{WIZARD_SCRIPT_ARGUMENTS}{do_build_sim} = 1;




   delete ($nios_hash->{Is_Bus_Master});



   my $nios_sbi = $nios_hash->{SYSTEM_BUILDER_INFO};
   $nios_sbi->{Is_Data_Master} = 1;
   $nios_hash->{"MASTER data_master"}{SYSTEM_BUILDER_INFO} = $nios_sbi;
   delete ($nios_hash->{SYSTEM_BUILDER_INFO});

   $nios_hash->{SYSTEM_BUILDER_INFO}{Is_Enabled} = $nios_sbi->{Is_Enabled};
   delete ($nios_sbi->{Is_Enabled});

   $nios_hash->{SYSTEM_BUILDER_INFO}{Instantiate_In_System_Module} = 
       $nios_sbi->{Instantiate_In_System_Module};
   delete ($nios_sbi->{Instantiate_In_System_Module});

   $nios_hash->{SYSTEM_BUILDER_INFO}{Is_CPU} = 1;

   my $nios_ports = $nios_hash->{PORT_WIRING};
   $nios_hash->{"MASTER data_master"}{PORT_WIRING} = $nios_ports;
   delete ($nios_hash->{PORT_WIRING});


   $nios_sbi = $nios_hash->{"MASTER data_master"}{SYSTEM_BUILDER_INFO};
   $nios_sbi->{Interrupt_Range} = "16-62";
   $nios_sbi->{Interrupt_Reserved} = "0-15";   
   $nios_sbi->{Bus_Type} = "avalon";
   $nios_sbi->{Register_Incoming_Signals} = "1";

   $nios_hash->{"MASTER instruction_master"}->
   {SYSTEM_BUILDER_INFO} = 
   {
      Address_Width => 8,
      Bus_Type => "avalon",
      Data_Width => "16",
      Is_Instruction_Master => "1",
   };

   $nios_hash->{WIZARD_SCRIPT_ARGUMENTS}{support_interrupts} = 1;
   $nios_hash->{WIZARD_SCRIPT_ARGUMENTS}{stack_mode} = 1;
   $nios_hash->{WIZARD_SCRIPT_ARGUMENTS}{include_debug} = 0;
   $nios_hash->{WIZARD_SCRIPT_ARGUMENTS}{include_trace} = 0;
   $nios_hash->{WIZARD_SCRIPT_ARGUMENTS}{implement_forward_b1} = 1;
   $nios_hash->{WIZARD_SCRIPT_ARGUMENTS}{support_rlc_rrc} = 1;
   $nios_hash->{WIZARD_SCRIPT_ARGUMENTS}{CONSTANTS} =
         {
            "CONSTANT __nios_catch_irqs__" =>
            {
               value => "1",
            },
            "CONSTANT __nios_use_constructors__" =>
            {
               value => "1",
            },
            "CONSTANT __nios_use_cwpmgr__" =>
            {
               value => "1",
            },
            "CONSTANT __nios_use_fast_mul__" =>
            {
               value => "1",
            },
            "CONSTANT __nios_use_small_printf__" =>
            {
               value => "1",
            },
         };


   foreach my $slave (@slaves)
   {
      my $slave_sbi = $slave->{SYSTEM_BUILDER_INFO};

      $slave->{"SLAVE s1"}{SYSTEM_BUILDER_INFO} = $slave_sbi;
      delete ($slave->{SYSTEM_BUILDER_INFO});



      $slave->{SYSTEM_BUILDER_INFO}{Is_Enabled} = $slave_sbi->{Is_Enabled};
      delete ($slave_sbi->{Is_Enabled});

      if ($slave_sbi->{Make_Memory_Model} ne "")
      {
         $slave->{SYSTEM_BUILDER_INFO}{Make_Memory_Model} = 
	 $slave_sbi->{Make_Memory_Model};
	 delete ($slave_sbi->{Make_Memory_Model});
      }

      $slave->{SYSTEM_BUILDER_INFO}{Instantiate_In_System_Module} = 
          $slave_sbi->{Instantiate_In_System_Module};
      delete ($slave_sbi->{Instantiate_In_System_Module});
      
      my $slave_ports = $slave->{PORT_WIRING};
      $slave->{"SLAVE s1"}{PORT_WIRING} = $slave_ports;
      delete ($slave->{PORT_WIRING});
      
      $slave_sbi->{Master_Arbitration} =
          "percentage";
      $slave_sbi->{"MASTERED_BY $nios_name/data_master"}
          {priority} =     "1";
      if ($slave_sbi->{Address_Alignment} =~ /^dynamic/i) 
      {
         $slave_sbi->{"MASTERED_BY $nios_name/instruction_master"}
                    {priority}     = "1";
      }
      else
      {
         $slave_sbi->{Address_Alignment} = "native"; 
      }

      $slave_sbi->{Bus_Type} = "avalon";

      if ($slave_sbi->{Uses_Tri_State_Data_Bus})
      {

         my $bus_name = $slave_sbi->{Tri_State_Data_Bus};

         $system_hash->
         {"MODULE $bus_name"}
         {class} = "altera_avalon_tri_state_bridge";

         my $mod = $system_hash->
         {"MODULE $bus_name"};

         $mod->{class_version} = "2.0";



         $mod->{SYSTEM_BUILDER_INFO}->{Instantiate_In_System_Module} =
             $mod->{SYSTEM_BUILDER_INFO}->{Is_Enabled} =
                 $mod->{SYSTEM_BUILDER_INFO}->{Is_Bridge} =
                 1;



         $slave_sbi->{"MASTERED_BY ${bus_name}/tristate_master"} = 
             $mod->{"SLAVE avalon_slave"}{SYSTEM_BUILDER_INFO}
                {"MASTERED_BY $nios_name/data_master"} = 
             $slave_sbi->{"MASTERED_BY $nios_name/data_master"};

         if ($slave_sbi->{Address_Alignment} =~ /^dynamic/i) 
         {
            $mod->{"SLAVE avalon_slave"}{SYSTEM_BUILDER_INFO}
                {"MASTERED_BY $nios_name/instruction_master"} = 
                    $slave_sbi->{"MASTERED_BY $nios_name/instruction_master"};
         }

         if (exists $mod->{"SLAVE s1"})
         {
            $mod->{"SLAVE avalon_slave"} = $mod->{"SLAVE s1"};
            delete $mod->{"SLAVE s1"};
         }
         my $tri_slave_sbi = $mod->{"SLAVE avalon_slave"}
         {SYSTEM_BUILDER_INFO};

         $tri_slave_sbi->{Master_Arbitration} = "percentage";
         $tri_slave_sbi->{Bus_Type}           = "avalon";
         $tri_slave_sbi->{Register_Incoming_Signals} = 0;
         $tri_slave_sbi->{Register_Outgoing_Signals} = 1;


         $mod->{"MASTER tristate_master"}
         {SYSTEM_BUILDER_INFO}{Bridges_To} = "avalon_slave";
         $tri_slave_sbi->     {Bridges_To} = "tristate_master";

         my $tri_master_sbi = $mod->{"MASTER tristate_master"}
         {SYSTEM_BUILDER_INFO};



         $tri_master_sbi->{Bus_Type} = 
             $slave_sbi->{Bus_Type} = "avalon_tristate";


         delete $slave_sbi->{"MASTERED_BY $nios_name/data_master"};
         delete $slave_sbi->{"MASTERED_BY $nios_name/instruction_master"};
      }
      delete $slave_sbi->{Tri_State_Data_Bus};

   } 
}

1;

=back

=cut

=head1 EXAMPLE

Here is a usage example ...

=head1 AUTHOR

Santa Cruz Technology Center

=head1 BUGS AND LIMITATIONS

list them here ...

=head1 SEE ALSO

The inherited class e_ptf

=begin html

<A HREF="e_ptf.html">e_ptf</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
