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

e_ptf_update_to_2_8 - description of the module goes here ...

=head1 SYNOPSIS

The e_ptf_update_to_2_8 class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_ptf_update_to_2_8;
@ISA = ("e_ptf_update_to_2_6");
use e_ptf;
use e_ptf_update_to_2_6;
use europa_utils;
use strict;






my %fields   = ();
my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );









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

      my $version_number = 2.82;
      return if ($SWV >= $version_number);
      $this->need_to_write_file(1);
      $system_hash->{System_Wizard_Version} = "$version_number";

      my @replaced_names;
      foreach my $module (keys %{$system_hash})
      {
         next unless ($module =~ /MODULE\s+(\w+)/);
         my $name = $1;
         my $mod = $system_hash->{$module};


         my $class = $mod->{class};
         my $sbi   = $mod->{SYSTEM_BUILDER_INFO};
         my $wsa   = $mod->{WIZARD_SCRIPT_ARGUMENTS};


         if (($class eq "altera_nios") || ($class eq "altera_nios_time_limited"))
         {
            $mod->{class_version} = "3.0";


            delete ($mod->{SIMULATION});



            my $max_address_width;
            if ($wsa->{CPU_Architecture} =~ /nios_(\d+)/)
            {
              my $max_address_width = $1;
              my $im_sbi = $mod->{'MASTER instruction_master'}{SYSTEM_BUILDER_INFO};
              my $dm_sbi = $mod->{'MASTER data_master'}{SYSTEM_BUILDER_INFO};
              
              $im_sbi->{Max_Address_Width} = $max_address_width;
              $dm_sbi->{Max_Address_Width} = $max_address_width;
            }
         }
         
         if ($class eq 'altera_avalon_cs8900')
         {
            my $constants = $mod->{WIZARD_SCRIPT_ARGUMENTS}{CONSTANTS};
            delete ($mod->{WIZARD_SCRIPT_ARGUMENTS}{CONSTANTS});

            $this->modify_bridges_or_cpus($mod->{'SLAVE s1'},
                                          $constants,
                                          $system_hash);
         }
         if ($class eq 'altera_avalon_lan91c111')
         {
            my $constants =
                $mod->{WIZARD_SCRIPT_ARGUMENTS}{CONSTANTS};

            my %new_constants = %$constants;
            $this->modify_bridges_or_cpus($mod->{'SLAVE s1'},
                                          \%new_constants,
                                          $system_hash);
            foreach my $constant (keys (%$constants))
            {
               next if ($constant eq 
                            'CONSTANT LAN91C111_REGISTERS_OFFSET');
               next if ($constant eq 
                        'CONSTANT LAN91C111_DATA_BUS_WIDTH');
               delete $constants->{$constant};
            }

            if (!exists($constants->
                        {'CONSTANT LAN91C111_REGISTERS_OFFSET'}))
            {
               $constants->{'CONSTANT LAN91C111_REGISTERS_OFFSET'} = 
               {
                  value   => "0x0000",
                  comment => "offset 0 or 0x300, depending on address bus wiring",
               };
            }
            if (!exists($constants->
                        {'CONSTANT LAN91C111_DATA_BUS_WIDTH'}))
            {
               $constants->{'CONSTANT LAN91C111_DATA_BUS_WIDTH'} = 
               {
                  value   => "16",
                  comment => "width 16 or 32, depending on data bus wiring",
               };
            }

         }
      }
   }
   $this->ptf_to_file();
}



=item I<modify_bridges_or_cpus()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub modify_bridges_or_cpus
{
   my $this = shift;

   my $slave_ptf   = shift;
   my $constants   = shift;
   my $system_hash = shift;


   foreach my $master ($this->get_module_master_list_from_slave_SBI
                       ($slave_ptf))
   {
      my $module = $system_hash->{"MODULE $master->[0]"};
      my $master_hash = $module->{"MASTER $master->[1]"};
      my $slave = $master_hash->{SYSTEM_BUILDER_INFO}{Bridges_To};
      if ($slave)
      {
         $this->modify_bridges_or_cpus($module->{"SLAVE $slave"},
                                       $constants,
                                       $system_hash);
      }
      elsif ($module->{SYSTEM_BUILDER_INFO}{Is_CPU})
      {

         $module->{SOFTWARE_COMPONENTS}
         {"SOFTWARE_COMPONENT Plugs_Library"} = 
         {
            class         => "altera_plugs_library",
            class_version => "2.0",
            WIZARD_SCRIPT_ARGUMENTS => {CONSTANTS => $constants},
            SYSTEM_BUILDER_INFO => {Is_Enabled => 1},
         }
      }
   }
}



=item I<get_module_master_list_from_slave_SBI()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_module_master_list_from_slave_SBI
{
   my $this = shift;
   my $slave = shift;


   my @mastered_by = grep {/^MASTERED_BY\s+/}
   keys(%{$slave->{SYSTEM_BUILDER_INFO}})
       or &ribbit ("slave doesn't exist");

   return map {s/^MASTERED_BY\s+(\w+)\/(\w+)//;
               [$1,$2];
            } @mastered_by;
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

The inherited class e_ptf_update_to_2_6

=begin html

<A HREF="e_ptf_update_to_2_6.html">e_ptf_update_to_2_6</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
