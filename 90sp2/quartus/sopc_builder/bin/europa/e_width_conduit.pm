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

e_width_conduit - description of the module goes here ...

=head1 SYNOPSIS

The e_width_conduit class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_width_conduit;
use europa_utils;
use e_expression;
use e_lcell;
use e_if;
use e_thing_that_can_go_in_a_module;
@ISA = ("e_thing_that_can_go_in_a_module");

use strict;

my %fields = (
              _conduit_width_hash => {},
              );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<set()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub set
{
   my $this = shift;
   my $set = shift;
   if (ref ($set) eq 'ARRAY')
   {
      $this->add_name($set);
      $this->isa_dummy(0);
   }
   else
   {
      $this->SUPER::set($set);
   }
   return $this;
}


=item I<add_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_name
{
   my $this = shift;
   my $name_hash = $this->_conduit_width_hash();
   my $a = shift;
   my @array;
   if (ref ($a) eq 'ARRAY')
   {
      @array = @$a;
   }
   else
   {
      @array = ($a, @_);
   }
   foreach my $name (@array)
   {
      if (!$name_hash->{$name}++)
      {
         $this->add_child_to_parent_signal_list
             ($name, 'call_me_if_sig_updates');
      }
   }
}



=item I<remove_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub remove_name
{
   my $this = shift;

   my $name_hash = $this->_conduit_width_hash();
   foreach my $name (@_)
   {
      $this->remove_child_from_parent_signal_list
          ($name, 'call_me_if_sig_updates');
      delete $name_hash->{$name};
   }
}



=item I<add_this_to_parent()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_this_to_parent
{
   my $this = shift;
   my $name_hash = $this->_conduit_width_hash();
   foreach my $name (keys (%$name_hash))
   {
      $this->add_child_to_parent_signal_list
          ($name, 'call_me_if_sig_updates');
   }
   $this->add_child_to_parent_object_list();
}



=item I<remove_signal_names_from_parent()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub remove_signal_names_from_parent
{
   my $this = shift;
   my $name_hash = $this->_conduit_width_hash();
   foreach my $name (keys (%$name_hash))
   {
      $this->remove_child_from_parent_signal_list
          ($name, 'call_me_if_sig_updates');
   }
}



=item I<remove_this_from_parent()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub remove_this_from_parent
{
   my $this = shift;
   $this->remove_signal_names_from_parent();
   $this->remove_child_from_parent_object_list();
}



=item I<make_linked_signal_conduit_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_linked_signal_conduit_list
{
   my $this = shift;
   my $signal_name = shift;

   my @signals = keys (%{$this->_conduit_width_hash()});
   my @other_signals = grep {$_ ne $signal_name} @signals;

   if (@signals == @other_signals)
   {
      &ribbit ("couldn't find $signal_name in signal list");
   }

   $this->remove_signal_names_from_parent();

   my $parent_module = $this->parent_module();
   return map 
   {$parent_module->
        make_linked_signal_conduit_list($_);}
   @other_signals;
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
   return;
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
   return;
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

The inherited class e_thing_that_can_go_in_a_module

=begin html

<A HREF="e_thing_that_can_go_in_a_module.html">e_thing_that_can_go_in_a_module</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
