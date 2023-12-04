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

s_conduit_slave_arbitration_module - description of the module goes here ...

=head1 SYNOPSIS

The s_conduit_slave_arbitration_module class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package s_conduit_slave_arbitration_module;

use e_ptf_arbitration_module;
@ISA = ("e_ptf_slave_arbitration_module");
use strict;
use europa_utils;
use europa_all;



=item I<_master_specific_special_care()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _master_specific_special_care
{
   return;
}



=item I<_slave_specific_special_care()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _slave_specific_special_care
{
   return;
}



=item I<_type_needs_special_care()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _type_needs_special_care
{
   return 0;
}



=item I<_get_master_request_signal_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master_request_signal_name
{
   my $this = shift;
   my $master_desc = shift;

   my $master = $this->_get_master($master_desc);
   my $request_type = 'valid';
   my $master_port_of_type =
       $master->_get_exclusively_named_port_or_its_complement("$request_type");

   return $master_port_of_type;
}



=item I<_get_master_grant_signal_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master_grant_signal_name
{
   my $this = shift;
   return $this->_get_master_request_signal_name(@_);
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

The inherited class e_ptf_slave_arbitration_module

=begin html

<A HREF="e_ptf_slave_arbitration_module.html">e_ptf_slave_arbitration_module</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;

