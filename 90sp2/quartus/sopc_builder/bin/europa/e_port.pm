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

e_port - description of the module goes here ...

=head1 SYNOPSIS

The e_port class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_port;

use europa_utils;
use e_signal;
use e_expression;
@ISA = ("e_signal");
use strict;







my %fields = (
              vhdl_default  => e_expression->new(),
              _direction    => 'input',
              );
my %pointers = ();

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
   return ["name", "width", "direction","vhdl_default"];
}



=item I<access_methods_for_auto_constructor()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub access_methods_for_auto_constructor
{
   my $this = shift;
   return (qw(direction vhdl_default),
           $this->SUPER::access_methods_for_auto_constructor(@_));
}



=item I<direction()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub direction
{
   my $this  = shift;

   if (@_)
   {
      my $old_direction = $this->_direction();
      my $val = shift;
      my $new_direction = $val;
      if ($val =~ /inout/i)
      {
         $this->_is_inout(1);
         $this->export(1);
      }
      elsif ($val =~ /^out/i)
      {
         $this->export(1);
      }
      else
      {
         $this->export(0);
      }

      if ($old_direction ne $new_direction)
      {
         my $name = $this->name();
         if ($name && ($old_direction !~ /out/))
         {
            $this->remove_child_from_parent_signal_list
                ($name, $old_direction);
         }
         if ($name && ($new_direction !~ /out/))
         {
            $this->add_child_to_parent_signal_list
                ($name, $new_direction);
         }
      }
      return $this->_direction($val);
   }

   my $return_direction = $this->_direction(); 
   return $return_direction;
}



=item I<is_output()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub is_output
{
   my $this = shift;
   return $this->export();
}



=item I<is_input()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub is_input
{
   my $this = shift;
   return !$this->export();
}



=item I<enough_data_known()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub enough_data_known
{
   my $this = shift;
   return $this->direction() && $this->SUPER::enough_data_known();
}



=item I<add_this_to_parent()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_this_to_parent
{
   my $this = shift;

   if ($this->enough_data_known())
   {
      if ($this->direction() !~ /out/)
      {
         $this->add_child_to_parent_signal_list
             ($this->name(), 'input');
      }
      $this->SUPER::add_this_to_parent();
   }
}



=item I<remove_this_from_parent()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub remove_this_from_parent
{
   my $this = shift;

   if ($this->enough_data_known())
   {
      if ($this->direction() eq 'input')
      {
         $this->remove_child_from_parent_signal_list
             ($this->name(), 'input');
      }
      $this->SUPER::add_this_to_parent();
   }
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
   my $this = shift;
   my $vs = $this->SUPER::to_vhdl(@_);

   my $vd = $this->vhdl_default();
   if ($vd->expression() =~/\d/)
   {
      $vs .= " := ".$vd->to_vhdl($this->width());
   }
   return ($vs);
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

The inherited class e_signal

=begin html

<A HREF="e_signal.html">e_signal</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
