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

e_process_x - description of the module goes here ...

=head1 SYNOPSIS

The e_process_x class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_process_x;

use europa_utils;
use europa_all;
use e_expression;

use e_process;
@ISA = ("e_process");
use strict;

my %fields = (
                _e_if => e_if_x->new(),
                _e_reset_if => e_if->new(),
              );

my %pointers = (
              );

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<_order()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _order
{
   return ['check_x'];
}



=item I<new()>

Object constructor

=cut

sub new
{
   my $this = shift;
   $this = $this->SUPER::new(@_);
   $this->tag('simulation');
   $this->_e_reset_if()->then([ $this->_e_if() ]);
   $this->contents([ $this->_e_reset_if() ]);
   return $this;
}



=item I<check_x()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub check_x
{
   my $this = shift;
   if (@_)
   {
      $this->_e_if->condition($_[0]);
   }
   else
   {
      &ribbit ("bad form");
   }
}



=item I<do_not_stop()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub do_not_stop
{
   my $this = shift;

   return $this->_e_if->do_not_stop(@_);
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
    my $this = shift;

    $this->build_reset_if();
    return $this->SUPER::to_verilog(@_);
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
    my $this = shift;

    $this->build_reset_if();
    return $this->SUPER::to_vhdl(@_);
}



=item I<build_reset_if()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub build_reset_if
{
    my $this = shift;

    my $reset_expression = $this->reset()->expression();

    $this->reset('');

    $reset_expression = &complement($reset_expression) if $this->reset_level();

    $this->_e_reset_if()->condition($reset_expression);
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

The inherited class e_process

=begin html

<A HREF="e_process.html">e_process</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
