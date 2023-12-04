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

e_avalon_slave - description of the module goes here ...

=head1 SYNOPSIS

The e_avalon_slave class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_avalon_slave;

use europa_utils;
use e_slave;
@ISA = ("e_slave");
use strict;

my %fields = (
              SBI_section => {Bus_Type => "avalon"}
              );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );







=item I<recognized_types()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub recognized_types($)
{
  my $this = shift;
  
  my @a = $this->global_input_types();
  my @b = $this->global_output_types();
  my @c = $this->input_types();
  my @d = $this->inout_types();
  my @e = $this->output_types();
  my @f = $this->SUPER::recognized_types();

  return (@a, @b, @c, @d, @e, @f);
}

sub global_input_types($)
{
  my $this = shift;
  return qw(
    clk
    reset
    always0
    always1
  );
}
sub global_output_types($)
{
  my $this = shift;
  return qw(
    out_clk
  );
}

sub input_types($)
{
  my $this = shift;
  
  return qw(
    address
    arbitrationshare
    beginbursttransfer
    begintransfer
    burstcount
    bursthint
    byteaddress
    byteenable
    chipselect
    read
    write
    writebyteenable
    writedata
    baseaddress
  );
}

sub output_types($)
{
  my $this = shift;
  return qw(
    dataavailable
    endofpacket
    irq
    readdata
    readdatavalid
    readyfordata
    resetrequest
    waitrequest
  );
}

sub inout_types($)
{
  my $this = shift;
  return qw(
    data
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

The inherited class e_slave

=begin html

<A HREF="e_slave.html">e_slave</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
