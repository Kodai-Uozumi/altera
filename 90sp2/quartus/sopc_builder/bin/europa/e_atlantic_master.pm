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

e_atlantic_master - description of the module goes here ...

=head1 SYNOPSIS

The e_atlantic_master class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_atlantic_master;

use europa_utils;
use e_atlantic_slave;
@ISA = ("e_atlantic_slave");
use strict;

my %fields = (
              section_name     => "MASTER"
              );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



sub input_types($)
{
  my $this = shift;
  my @types = (



    $this->SUPER::output_types()
  );
  
  return @types;
}

sub output_types($)
{
  my $this = shift;
  return (

    $this->SUPER::input_types()
  );
}

sub inout_types($)
{
  my $this = shift;
  return (
    $this->SUPER::inout_types(),
  );
}  

=back

=cut

=head1 EXAMPLE

Here is a usage example ...

=head1 AUTHOR

Santa Cruz Technology Center

=head1 BUGS AND LIMITATIONS

list them here ...

=head1 SEE ALSO

The inherited class e_avalon_slave

=begin html

<A HREF="e_atlantic_master.html">e_atlantic_master</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
