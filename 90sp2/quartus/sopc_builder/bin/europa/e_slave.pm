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

e_slave - description of the module goes here ...

=head1 SYNOPSIS

The e_slave class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_slave;

use e_thing_that_can_go_in_a_module;
use e_module;
use e_signal;
use e_project;
@ISA = ("e_thing_that_can_go_in_a_module");
use europa_utils;
use strict;





my %fields = (
              section_name     => "SLAVE",
              sideband_signals => [],
              SBI_section      => {},
              _type_recognized_hash    => {},   # boolean cache-hash.
              _type_already_bound_hash => {},   # discovery-scoreboard
              );

my %pointers = ();

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
   my $self = $this->SUPER::new(@_);
   $self->_setup_type_recognized_hash();

   return $self;
}



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
   my $this = shift;
   $this->parent(@_);
}



=item I<_add_type_map_pair()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _add_type_map_pair
{
  my $this = shift;
  my $signal_name = shift;
  my $signal_type = shift;

  my $previous_type = $this->type_map()->{$signal_name};
  if ($previous_type ne "" && $previous_type ne $signal_type) {
    &goldfish ("Suspicious:  Signal $signal_name is already of type ",
               "$previous_type.  Overriding to $signal_type");
  }

  $this->type_map()->{$signal_name} = $signal_type;
  $this->_type_already_bound_hash()->{$signal_type} = 1;
}



=item I<type_map()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub type_map
{



  my $this = shift;

  if (!defined ($this->{type_map}))
  {
     $this->{type_map} = {};
  }
  if (@_) 
  {
     my ($new_map) = (@_);
     if (scalar(keys (%{$new_map})) == 0)
     {
        return $this->{type_map} = shift;
     }
     
     foreach my $signal_name (keys (%{$new_map})) 
     {
        $this->_add_type_map_pair($signal_name, $new_map->{$signal_name});
     }
  }
  return $this->{type_map};
}



=item I<recognized_types()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub recognized_types
{
  my $this = shift;


  return (@{$this->sideband_signals()});
}



=item I<_setup_type_recognized_hash()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _setup_type_recognized_hash
{
  my $this = shift;
  foreach my $type ($this->recognized_types()) {


    $this->_type_recognized_hash()->{$type}        = 1;
    $this->_type_recognized_hash()->{$type . "_n"} = 1;
  }
}



=item I<type_is_recognized()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub type_is_recognized
{
  my $this      = shift;
  my $type_name = shift;


  if (scalar(keys(%{$this->_type_recognized_hash})) == 0) {
    $this->_setup_type_recognized_hash();
  }

  return $this->_type_recognized_hash()->{$type_name};
}



=item I<type_is_already_bound_to_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub type_is_already_bound_to_port
{
  my $this      = shift;
  my $type_name = shift;

  return $this->_type_already_bound_hash()->{$type_name};
}














=item I<_call_this_when_any_signal_is_updated()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _call_this_when_any_signal_is_updated
{
  my $this = shift;
  my $updated_signal = shift;




  $this->_add_recognized_signals_to_map($updated_signal);



  $this->_assign_signal_types_from_map();
}



=item I<to_ptf()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_ptf
{
  my $this = shift;

  my $daddy   = $this->parent_module();
  my $mod_ptf = shift or &ribbit ("no place to put me\n");

  ref ($mod_ptf) eq "HASH" or &ribbit("expected reference to PTF  (hash).");


  foreach my $port_name ($daddy->_get_port_names())
  {
     my $port = $daddy->get_signal_by_name($port_name)
         or &ribbit ("no signal by name $port_name");
     $this->_call_this_when_any_signal_is_updated($port);
  }


  $this->_assign_signal_types_from_map(0);  # don't complain  

  my $own_section_name  = $this->section_name();
     $own_section_name .= " " . $this->name() if $this->name ne "";

  my $own_section = {};
  if (exists ($mod_ptf->{$own_section_name})) {
    $own_section = $mod_ptf->{$own_section_name};
  } else {
    $mod_ptf->{$own_section_name} = $own_section;
  }




  my $version = $daddy->_project()->builder_version();
  my $old_school =  $version < 2.0;
  $own_section = $mod_ptf if $old_school;

  if ($old_school)
  {
    &goldfish ("Writing PTF in old-style format " .
      "(System_Wizard_version: '$version')");
  }


  foreach my $value (values (%{$own_section->{PORT_WIRING}}))
  {
     $value->{Is_Enabled} = 0;
  }
  $own_section->{SYSTEM_BUILDER_INFO} = {}
    if !exists ($own_section->{SYSTEM_BUILDER_INFO});
    
  return if ($own_section->{SYSTEM_BUILDER_INFO}{Is_Enabled} eq '0');
  foreach my $slave_port ($this->_get_slave_ports()) {
    my $slave_port_type = $this->type_map()->{$slave_port->name()};
    $slave_port->add_to_ptf_section ($own_section->{PORT_WIRING},
                                     $slave_port_type);
  }

  my $SBI_section = $this->SBI_section();
  foreach my $key (keys %$SBI_section)
  {
     $own_section->{SYSTEM_BUILDER_INFO}{$key} = $SBI_section->{$key};
  }

}


















=item I<_add_recognized_signals_to_map()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _add_recognized_signals_to_map
{
  my $this = shift;
  my $sig_to_recognize = shift;  # will be e_signal object.


  return if $sig_to_recognize->isa_dummy();
  my $sig_name = $sig_to_recognize->name();
  return if $sig_name eq "";





  return unless $this->type_is_recognized($sig_name);


  next if $this->type_is_already_bound_to_port ($sig_name);



  $this->_add_type_map_pair($sig_name, $sig_name);
}










=item I<_assign_signal_types_from_map()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _assign_signal_types_from_map
{
  my $this = shift;
  my $be_sure_all_ports_are_actually_present = shift;

  my $daddy   = $this->parent_module();

  foreach my $mapped_sig_name (keys(%{$this->type_map()})) {
    my $mapped_type = $this->type_map()->{$mapped_sig_name};
    my $sig = $daddy->get_signal_by_name($mapped_sig_name);

    if ($be_sure_all_ports_are_actually_present) {

      &ribbit ("signal $mapped_sig_name appears in type-map, ",
               "but is not a port on module ", $daddy->name(), "\n")
        if !$sig;
    } else {





      next unless $sig;
    }


  }
}












=item I<_verify_type_map()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _verify_type_map
{
  my $this = shift;

  $this->_assign_signal_types_from_map(1);
}



=item I<_get_slave_ports()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_slave_ports
{
  my $this = shift;

  my $daddy   = $this->parent_module();
  my @port_list = ();






  foreach my $port_name (keys (%{$this->type_map()})) {
    my $sig = $daddy->get_signal_by_name ($port_name) or next;








    push (@port_list, $sig);
  }
  return @port_list;
}



=item I<_get_mapped_types()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_mapped_types
{
  my $this = shift;
  return values (%{$this->type_map()});
}


1;  # ONE!  One vonderful package!  Ah ah ah!

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
