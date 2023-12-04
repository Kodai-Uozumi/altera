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

e_if_x - description of the module goes here ...

=head1 SYNOPSIS

The e_if_x class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_if_x;

use europa_utils;
use e_expression_is_x;
use e_sim_write;
use e_if;
@ISA = ("e_if");
use strict;

my %fields = (
              _condition => e_expression_is_x->new(),
              _e_sim_write => e_sim_write->new(),
              _e_stop => e_stop->new(),
              );

my %pointers = (
              );

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<new()>

Object constructor

=cut

sub new
{
    my $this = shift;

    $this = $this->SUPER::new(@_);

    $this->then([$this->_e_sim_write(), $this->_e_stop]);

    $this->_e_sim_write()->show_time(1);

    return $this;
}



=item I<do_not_stop()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub do_not_stop
{
   my $this = shift;

   return $this->_e_stop->do_not_stop(@_);
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
   my $this = shift;
   my $x_expr = $this->condition()->expression();
   my $module = $this->parent_module()->name();
   my $prefix = $this->_e_stop->do_not_stop() ? "WARNING" : "ERROR";
   $this->_e_sim_write()->spec_string
       ($prefix . ": " . $module.'/'."$x_expr is 'x'\\n");
   return $this->SUPER::to_verilog(@_);
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
   my $this = shift;
   my $x_expr = $this->condition()->expression();
   my $module = $this->parent_module()->name();
   my $prefix = $this->_e_stop->do_not_stop() ? "WARNING" : "ERROR";
   $this->_e_sim_write()->spec_string
       ($prefix . ": " . $module.'/'."$x_expr is 'x'\\n");
   return $this->SUPER::to_vhdl(@_);
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

The inherited class e_if

=begin html

<A HREF="e_if.html">e_if</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
