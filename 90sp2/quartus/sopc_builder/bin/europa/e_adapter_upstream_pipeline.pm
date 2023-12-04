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

e_adapter - description of the module goes here ...

=head1 SYNOPSIS

The e_adapter class is an abstract base class for adapters.

=head1 METHODS

=over 4

=cut

package e_adapter_upstream_pipeline;

use europa_utils;
use e_avalon_adapter_interface;
use e_avalon_adapter_master;
use e_avalon_adapter_slave;

@ISA = ("e_adapter");
use strict;

my %fields = (
);

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );

=item I<make_special_assignments($)>

=cut

sub make_special_assignments($)
{
  my $this = shift;
  my ($upstream) = $this->get_upstream_interfaces();
  my ($downstream) = $this->get_downstream_interfaces();

  my $clk = $upstream->get_signal_by_type('clk');
  my $reset = $upstream->get_signal_by_type('reset_n');
  my $us_readdatavalid = $upstream->get_signal_by_type('readdatavalid');
  my $ds_readdatavalid = $downstream->get_signal_by_type('readdatavalid');

  e_register->new({
    out => $us_readdatavalid,
    in => $ds_readdatavalid,
    enable => 1,
    clock => $clk,
    sync_reset => $upstream->get_signal_by_type('flush'),
    reset => $reset,
  })->within($this);

  e_assign->new({
    lhs => $upstream->get_signal_by_type('waitrequest'),
    rhs => $downstream->get_signal_by_type('waitrequest'),
  })->within($this);
}

=item I<assign_upstream_default($$$)>

Instantiate logic to drive an output-to-avalon signal on the upstream
slave interface.

Parameters:
lhs: output signal name
rhs: input signal name

=cut

sub assign_upstream_default
{
  my $this = shift;
  my ($lhs, $rhs, $upstream, $downstream) = @_;

  my $clk = $downstream->get_signal_by_type('clk');
  my $reset = $downstream->get_signal_by_type('reset_n');

  e_register->new({
    out => $lhs,
    in => $rhs,
    enable => $downstream->get_signal_by_type('readdatavalid'),
    clock => $clk,
    reset => $reset,
  })->within($this);
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

The base class e_module.

=begin html

<A HREF="e_adapter.html">e_adapter</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
