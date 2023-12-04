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

e_ptf_update_to_2_6 - description of the module goes here ...

=head1 SYNOPSIS

The e_ptf_update_to_2_6 class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_ptf_update_to_2_6;
@ISA = ("e_ptf_update_to_2_0");
use e_ptf;
use e_ptf_update_to_2_0;
use europa_utils;
use strict;






my %fields   = ();
my %pointers = ();
















=item I<ptf_update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub ptf_update
{
   my $this = shift;

   $this->SUPER::ptf_update();

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

      return if ($SWV >= 2.6);
      $this->need_to_write_file(1);
      $system_hash->{System_Wizard_Version} = "2.6";

      my @nios_wsa;
      my @replaced_names;
      foreach my $module (keys %{$system_hash})
      {
         next unless ($module =~ /MODULE\s+(\w+)/);
         my $name = $1;
         my $mod = $system_hash->{$module};


         my $class = $mod->{class};
         my $sbi   = $mod->{SYSTEM_BUILDER_INFO};
         my $wsa   = $mod->{WIZARD_SCRIPT_ARGUMENTS};

         if ($class eq "altera_nios")
         {
            push (@nios_wsa, $wsa);
         }
         if ($class eq "altera_avalon_user_defined_interface")
         {
            next if ($mod->{class_version}) >= "2.6";

            if (exists $mod->{"SLAVE s1"})
            {
               push (@replaced_names, $name);
               $mod->{"SLAVE avalonS"} = $mod->{"SLAVE s1"};
               delete $mod->{"SLAVE s1"};
               
               my $slave = $mod->{"SLAVE avalonS"};
               my $slave_sbi = $slave->{SYSTEM_BUILDER_INFO};

               $sbi->{View}{Is_Collapsed} = 1;
               $mod->{HDL_INFO}{Imported_HDL_Files} = "";

               $slave_sbi->{Is_Enabled} = 1;

               $wsa->{Component_Desc} = "";
               $wsa->{Component_Name} = "";
               $wsa->{Module_Name} = "";
               $wsa->{Technology} = "";

               if (!keys(%{$slave->{PORT_WIRING}}))
               {



                  $sbi->{Instantiate_In_System_Module} = 0;
                  $wsa->{HDL_Import} = 0;
                  $wsa->{Synthesize_Imported_HDL} = 0;

                  $slave->{PORT_WIRING} = 
                  {
                     "PORT clk" =>
                     {
                        direction => "input",
                        width => "1",
                        type => "clk",
                     },
                     "PORT reset_n" =>
                     {
                        direction => "input",
                        width => "1",
                        type => "reset_n",
                     },
                     "PORT address" =>
                     {
                        direction => "input",
                        width => $slave_sbi->{Address_Width},
                        type => "address",
                     },
                     "PORT write_n" =>
                     {
                        direction => "input",
                        width => "1",
                        type => "write_n",
                     },
                     "PORT read_n" =>
                     {
                        direction => "input",
                        width => "1",
                        type => "read_n",
                     },
                     "PORT chipselect" =>
                     {
                        direction => "input",
                        width => "1",
                        type => "chipselect",
                     }
                  };

                  if ($slave_sbi->{Uses_Tri_State_Data_Bus})
                  {
                     $slave->{PORT_WIRING}{"PORT data"} =
                     {
                        direction => "inout",
                        width     => $slave_sbi->{Data_Width},
                        type      => "data",
                     };
                     $slave_sbi->{Bus_Type} = "avalon_tristate";
                  }
                  else
                  {
                     $slave->{PORT_WIRING}{"PORT writedata"} =
                     {
                        direction => "input",
                        width     => $slave_sbi->{Data_Width},
                        type      => "writedata",
                     };
                     $slave->{PORT_WIRING}{"PORT readdata"} =
                     {
                        direction => "output",
                        width     => $slave_sbi->{Data_Width},
                        type      => "readdata",
                     };
                     $slave_sbi->{Bus_Type} = "avalon";
                  }
               }
            }
         }
      }
      my $string = "starting\n";
      foreach my $nwsa (@nios_wsa)
      {


         foreach my $replaced_name (@replaced_names)
         {
            $string .= "replaced names $replaced_name\n";
            foreach my $key (keys (%$nwsa))
            {
               my $value = $nwsa->{$key};
               $string .= "  key is $key, value was $value\n";
               if ($value =~ s|$replaced_name\/s1|$replaced_name\/avalonS|)
               {
                  $nwsa->{$key} = $value;
                  $string .= "               value is $value\n";
               }

            }
         }
      }

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

The inherited class e_ptf_update_to_2_0

=begin html

<A HREF="e_ptf_update_to_2_0.html">e_ptf_update_to_2_0</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
