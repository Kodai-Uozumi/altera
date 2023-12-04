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

e_default_module_marker - description of the module goes here ...

=head1 SYNOPSIS

The e_default_module_marker class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_default_module_marker;

use e_module;
@ISA = ("e_object");
use e_default_module_marker;

use strict;
use europa_utils;


my $GLOBAL_CURRENT_MODULE = e_module->dummy();




my $serial_number_counter = 0;






my %fields = (
              serial_number => 0,
              );

my %pointers = (
                previous_module => e_module->dummy(),
               );

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<new()>

Object constructor

=cut

sub new {
  my $this  = shift;
  my $self = $this->SUPER::new();

  $self->current_module (@_);
  $self->serial_number ($serial_number_counter++);

  return $self;
}














=item I<current_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub current_module
{
  my $this = shift;
  my $marked_module = shift;
  &ribbit ("Too many arguments") if @_;

  if ($marked_module) {
    &ribbit ("Must be constructed from an e_module") 
      unless (&is_blessed ($marked_module) && $marked_module->isa("e_module"));

    $this->previous_module($GLOBAL_CURRENT_MODULE);
    $GLOBAL_CURRENT_MODULE = $marked_module;

  }

  return $GLOBAL_CURRENT_MODULE;
}













=item I<add_contents()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_contents
{
  my $this = shift;
  return () if $GLOBAL_CURRENT_MODULE->isa_dummy();

  foreach my $thing (@_) {

    &ribbit ("expected a thing that can go in a module not ($thing)") 
      unless (&is_blessed ($thing) && 
              $thing->isa ("e_thing_that_can_go_in_a_module"));

    $thing->within ($GLOBAL_CURRENT_MODULE);
  }
  return $GLOBAL_CURRENT_MODULE->contents();
}



=item I<DESTROY()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub DESTROY
{
  my $this = shift;




  &ribbit ("default module-markers being destroyed in unexpected order")
    if $this->serial_number() != --$serial_number_counter;

  $GLOBAL_CURRENT_MODULE = $this->previous_module();
}


1;  #One!  One vonderful pachage!  Ah, ah, ah!




=back

=cut

=head1 EXAMPLE

Here is a usage example ...

=head1 AUTHOR

Santa Cruz Technology Center

=head1 BUGS AND LIMITATIONS

list them here ...

=head1 SEE ALSO

The inherited class e_object

=begin html

<A HREF="e_object.html">e_object</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
