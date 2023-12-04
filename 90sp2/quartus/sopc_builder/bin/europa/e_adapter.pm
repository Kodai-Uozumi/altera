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

package e_adapter;

use europa_utils;
use e_avalon_adapter_interface;
use e_avalon_adapter_master;
use e_avalon_adapter_slave;

@ISA = ("e_module");
use strict;

my %fields = (

  _downstream_masters => [],
  _upstream_slaves => [],
  _signal_types_going_upstream   => {},
  _signal_types_going_downstream => {},
  _special_assigned_signals => {},
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
  $this = $this->SUPER::new(@_);

  $this->init();
  $this->create_interfaces();


  $this->make_special_assignments();

  $this->record_assigned_signals();

  $this->make_default_assignments();
  $this->add_sim_wave();

  return $this;
}

=item I<record_assigned_signals()>

Mark any already-assigned signal names as "special".
Any remaining signal types are elible for assignment
during make_default_assignments().

=cut
sub record_assigned_signals($)
{
  my $this = shift;

  my @output_signals = $this->get_output_signals();
  for my $sig (@output_signals)
  {




    my $name = $sig->name();
    if ($this->get_signal_sources_by_name($name))
    {
      $this->set_is_assigned($name);
    }
  }
  
}

sub init
{
  my $this = shift;
  
  $this->add_signal_types_going_upstream(qw(
    endofpacket
    readdata
    readdatavalid
    waitrequest
  ));
  $this->add_signal_types_going_downstream(qw(
    address
    nativeaddress
    arbiterlock
    arbiterlock2
    burstcount
    byteenable
    chipselect
    debugaccess
    read
    write
    writedata
  ));
}

sub get_upstream_interfaces($)
{
  my $this = shift;
 
  my $us = $this->_upstream_slaves();
  return @{$us};
}

sub get_downstream_interfaces($)
{
  my $this = shift;
  
  my $ds = $this->_downstream_masters();
  return @{$ds};
}

=item I<create_interfaces()>

Builds up list of masters and slaves from the ptf.

=cut
sub create_interfaces
{
  my $this = shift;
  my $sph = $this->project()->spaceless_module_ptf();
  
  my @sim_ports;
  
  foreach my $rec (
    {interface => 'slave', type => 'upstream',},
    {interface => 'master', type => 'downstream'},
  )
  {
    my $interface = $rec->{interface};
    my $type = $rec->{type};
    
    my $uppercase = uc($interface);
    my $INTERFACES = $sph->{$uppercase} 
      || &ribbit ("no $interface interface in adapter");
      
    foreach my $name (keys %$INTERFACES)
    {
      my $value = $INTERFACES->{$name};
      my $spaceless_SBI = $value->{SYSTEM_BUILDER_INFO};
      my $new_SBI = spaceless_to_spaced_hash($spaceless_SBI);
      my $set_hash = {name => $name,
                      SBI_section => $new_SBI,
                      within => $this,
                      };
      my $class = "e_avalon_adapter_$interface";
      my $interface_object = $class->new($set_hash);
      my $slave_or_master_list = "_${type}_${interface}s";
      push @{$this->$slave_or_master_list()}, $interface_object;
    }
  }
}

=item I<add_sim_wave()>

Throw interesting signals into the simulation wave.
In the future, when adapters derived from this one
become invisible to the user, these signals will be
irritating and useless.  Therefore only add these
signals upon detection of a special ptf assignment.

=cut

sub add_sim_wave
{
  my $this = shift;
  
  if (!$this->project()->WSA()->{do_sim_wave})
  {
    return;
  }
  
  my @sim_ports;
  push @sim_ports,
    sort ($this->get_input_names(), $this->get_output_names());
  
  $this->project()->set_sim_wave_signals(\@sim_ports);
}

=item I<make_special_assignments()>

Derived classes should override this function and do
what they please with interface signals according to 
type.  Silly example:

  my $this = shift;
  

  my $downstream = $this->get_object_by_name("downstream");
  my $upstream = $this->get_object_by_name("upstream");

  e_assign->new({
    lhs => $downstream->get_signal_by_type("chipselect"),
    rhs => $upstream->get_signal_by_type("chipselect") . " | 1",
  })->within($this);

There's no need for a derived class to call SUPER.

=cut

sub make_special_assignments($)
{
}

sub set_is_assigned($@)
{
  my $this = shift;

  map {$this->_special_assigned_signals->{$_} = 1} @_;
}

sub is_assigned($$)
{
  my $this = shift;
  my $sig = shift;

  return $this->_special_assigned_signals->{$sig};
}

sub dispatch_default_wiring($$$$)
{
  my $this = shift;
  my ( 
    $dispatch_function,
    $destination_signal,
    $source_signal,
    $destination,
    $source 
  ) = @_;


  return if (!$source_signal || !$destination_signal);


  return if $this->is_assigned($destination_signal);
  
  $this->$dispatch_function(
    $destination_signal,
    $source_signal,
    $destination,
    $source,
  );
}

=item I<make_default_assignments($)>

Wire up any signals which haven't already been assigned
by a derived class in make_special_assignments.

=cut

sub make_default_assignments($)
{
  my $this = shift;
  for my $upstream ($this->get_upstream_interfaces())
  {
    for my $downstream ($this->get_downstream_interfaces())
    {
      for my $type ($this->signal_types_going_upstream())
      {
        my $upstream_signal = $upstream->get_signal_by_type($type);
        my $downstream_signal = $downstream->get_signal_by_type($type);
        my $downstream_width = $downstream->get_port_width_by_type($type);
        
        if ($downstream_width)
        {
          $this->dispatch_default_wiring(
            "assign_upstream_default",
            $upstream_signal,
            $downstream_signal,
            $upstream,
            $downstream,
          );
        }
      }

      for my $type ($this->signal_types_going_downstream())
      {
        my $upstream_signal = $upstream->get_signal_by_type($type);
        my $downstream_signal = $downstream->get_signal_by_type($type);
        my $upstream_width = $upstream->get_port_width_by_type($type);
        
        if ($upstream_width)
        {
          $this->dispatch_default_wiring(
            "assign_downstream_default",
            $downstream_signal,
            $upstream_signal,
            $downstream,
            $upstream,
          );
        }
      }
    }
  }
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
  return $this->assign_default(@_);
}

=item I<assign_downstream_default($$$)>

Instantiate logic to drive an output-to-avalon signal on the downstream
master interface.

Parameters:
lhs: output signal name
rhs: input signal name

=cut

sub assign_downstream_default
{
  my $this = shift;
  return $this->assign_default(@_);
}

=item I<assign_default($$$)>

Parameters:
lhs: output signal name
rhs: input signal name

=cut

sub assign_default($$$)
{
  my $this = shift;
  my ($lhs, $rhs) = @_;

  e_assign->new({
    lhs => $lhs,
    rhs => $rhs,
  })->within($this);
}

=item I<signal_types_going_upstream($)>

A list of adapter/avalon signal_types which go upstream.

=cut

sub signal_types_going_upstream($)
{
  my $this = shift;
  return sort keys %{$this->_signal_types_going_upstream()};
}

=item I<signal_types_going_downstream($)>

A list of adapter/avalon signal_types which go downstream.

=cut

sub signal_types_going_downstream($)
{
  my $this = shift;
  return sort keys %{$this->_signal_types_going_downstream()};
}

=item I<add_signal_types_going_downstream($)>

Add to the list of adapter/avalon signal_types which go downstream.

=cut

sub add_signal_types_going_downstream($@)
{
  my $this = shift;
  
  map {$this->_signal_types_going_downstream()->{$_} = 1} @_;
}

=item I<add_signal_types_going_upstream($)>

Add to the list of adapter/avalon signal_types which go upstream.

=cut

sub add_signal_types_going_upstream($@)
{
  my $this = shift;
  
  map {$this->_signal_types_going_upstream()->{$_} = 1} @_;
}


=item I<remove_signal_types_going_upstream($)>

Add to the list of adapter/avalon signal_types which go upstream.

=cut

sub remove_signal_types_going_upstream($@)
{
  my $this = shift;
  
  foreach my $signal (@_)
  {
    delete $this->_signal_types_going_upstream()->{$signal};
  }
}

=item I<remove_signal_types_going_downstream($)>

Add to the list of adapter/avalon signal_types which go downstream.

=cut

sub remove_signal_types_going_downstream($@)
{
  my $this = shift;
  
  foreach my $signal (@_)
  {
    delete $this->_signal_types_going_downstream()->{$signal};
  }
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
