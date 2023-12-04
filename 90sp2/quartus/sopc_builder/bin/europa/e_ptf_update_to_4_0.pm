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

e_ptf_update_to_4_0 - description of the module goes here ...

=head1 SYNOPSIS

The e_ptf_update_to_4_0 class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_ptf_update_to_4_0;
@ISA = ("e_ptf_update_to_2_8");
use e_ptf;
use e_ptf_update_to_2_8;
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

   foreach my $system (keys %{$this->ptf_hash()})
   {
      my $system_hash = $this->ptf_hash()->{$system};


      my $SWV = $system_hash->{System_Wizard_Version};


      while ($SWV =~ s/^(.*?\..*)\./$1/s){;}

      my $version_number = 4.0;
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

         if ($class eq "altera_avalon_onchip_memory")
         {

            $mod->{SYSTEM_BUILDER_INFO}->{Required_Device_Family}
              =~ s/STRATIX/STRATIX,STRATIXII/;
            
            $mod->{class_version} = "4.0";
         }
      }
   }
   $this->ptf_to_file();
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

The inherited class e_ptf_update_to_2_8

=begin html

<A HREF="e_ptf_update_to_2_8.html">e_ptf_update_to_2_8</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
