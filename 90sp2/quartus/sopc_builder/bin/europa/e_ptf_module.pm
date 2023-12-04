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

e_ptf_module - description of the module goes here ...

=head1 SYNOPSIS

The e_ptf_module class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_ptf_module;
use e_ptf_master;
use e_ptf_slave;
use e_instance;
use e_module;
@ISA = ("e_module");
use strict;
use europa_utils;
my %fields = (
              _hdl_generated => 1,
              _AUTOLOAD_ACCEPT_ALL => 1,
              );

my %pointers = (
                bridge_arbitration_module => e_module->dummy());

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
   my $this  = shift;
   my $self = $this->SUPER::new(@_);


   my $project = $self->project();
   if (exists ($self->{PORT_WIRING}->{PORT}))
   {
      foreach my $port_hash ($self->ptf_to_hashes
                              ($self->{PORT_WIRING}->{PORT}))
      {
         $port_hash->{parent} = $self;
         $port_hash->{project} = $project;




         next if  ($port_hash->{Is_Enabled} eq '0');

         my $port = e_ptf_port->new($port_hash);
         $port->parent($self);

         $self->add_contents($port);
         $self->document_object($port);
      }
   }
   if (exists ($self->{SLAVE}))
   {
      foreach my $slave_hash ($self->ptf_to_hashes
                              ($self->{SLAVE}))
      {
         $slave_hash->{parent} = $self;
         $slave_hash->{project} = $project;
         next if ($slave_hash->{SYSTEM_BUILDER_INFO}->{Is_Enabled} eq "0");
         my $slave = e_ptf_slave->new($slave_hash);
         $slave->parent($self);
         $self->add_contents($slave);
         $self->document_object($slave);

         if ($self->do_make_memory_model())
         {
            $self->_explicitly_empty_module(1);
            $slave->make_memory_model();
         }

      }
   }
   if (exists ($self->{MASTER}))
   {
      foreach my $master_hash ($self->ptf_to_hashes
                               ($self->{MASTER}))
      {
         $master_hash->{parent} = $self;
         $master_hash->{project} = $project;
         next if ($master_hash->{SYSTEM_BUILDER_INFO}->{Is_Enabled} eq "0");
         my $master = e_ptf_master->new($master_hash);
         $self->add_contents($master);
         $self->document_object($master);
      }
   }
   if ($self->{SYSTEM_BUILDER_INFO}{Is_Bridge})
   {
      $self->bridge_arbitration_module
          (e_module->new
           ({name =>"$self->{name}_bridge_arbitrator"})
           );
   }

   return $self;
}



=item I<do_make_memory_model()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub do_make_memory_model
{
   my $this = shift;
   my $sbi = $this->{SYSTEM_BUILDER_INFO};

   my $return = (!$sbi->{Instantiate_In_System_Module}) &&
       $sbi->{Make_Memory_Model};
   if ($return)
   {
      $this->_hdl_generated(0);
   }
   return ($return);
}



=item I<to_esf()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_esf
{
  my $this = shift;
  my $return_hash = shift;

  if ($this->{ESF_ATTRIBUTES}) {
    foreach my $option (keys %{$this->{ESF_ATTRIBUTES}}) {
      foreach my $setting (keys %{$this->{ESF_ATTRIBUTES}{$option}}) {
        my $string = $this->_exclusive_name() 
              .  " : "
              . $setting
              .  " = "
              . $this->{ESF_ATTRIBUTES}{$option}{$setting};
        push (@{$return_hash->{$option}} , $string );
      }
    }
  }

  foreach my $content (@{$this->_updated_contents} ) {
    if ($content->can("to_esf")) {
      $content->to_esf($return_hash);
    }
  }

  return ($return_hash);
}



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
    my $this = shift;

    $this->SUPER::update();

    if ($this->{SYSTEM_BUILDER_INFO}->{Disable_Simulation_Port_Wiring})
    {
        return;
    }
        
    my $port_hash = $this->{SIMULATION}->{PORT_WIRING};
    if ($port_hash)
    {
       my $module_name = $this->{SIMULATION}{Module_Name} ||
           $this->name().'_test_component';

       my $existing_module_in_project = 
           $this->project()->get_module_by_name($module_name);

       my $module = $existing_module_in_project;


       if (!$module)
       {
          $module = e_module->new({
             name => $module_name,
             _hdl_generated => "1",
          });
       }

       my $port_map;
       foreach my $port_hash ($this->ptf_to_hashes
                              ($port_hash->{PORT}))
       {
          next if $port_hash->{Is_Enabled} eq '0';
          delete $port_hash->{Is_Enabled};


          if (!$existing_module_in_project)
          {
             $module->add_contents(e_port->new({
                name => $port_hash->{name},
                width => $port_hash->{width},
                direction => $port_hash->{direction},
             }));
          }
          my $port_name = $port_hash->{name};



          my $existing_port = $this->get_object_by_name($port_name);
          my $port_rename;
          if ($existing_port)
          {


             my $ptf_exclusive_name_override = $port_hash->{__exclusive_name};
             if ($ptf_exclusive_name_override)
             {
               $existing_port->_exclusive_name($ptf_exclusive_name_override);
             }
             $port_map->{$port_name} = $existing_port->_exclusive_name();
          }
       } #foreach my $port_hash

       my $instance = e_instance->new({
          comment => $this->{SIMULATION}->{Instance_Comment},
          module   => $module,
          port_map => $port_map,
       });

       $this->project()->test_module->add_contents($instance);
    } # found PORT_WIRING under SIMULATION

} # &update


=item I<check_x()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub check_x
{
   my $this = shift;
   my $signal_name = shift;

   foreach my $instance (@{$this->_instantiated_by()})
   {
      my $port = $instance->port_map($signal_name);
      if (!$port)
      {
         &ribbit ("no port for $signal_name\n");
      }

      $instance->parent_module()->
          get_and_set_once_by_name
          ({
             thing   => "e_process_x",
             name    => "check x for $port",
             check_x => $port,
           });
   }
}



=item I<clock_source>

returns the name of the clock source associated with the slave.
=cut

sub clock_source
{
   my $this = shift;
   return $this->{SYSTEM_BUILDER_INFO}{Clock_Source} || &ribbit ("no clock source");
}



=item I<get_clock_hash>

returns a the whole clock hash.

=cut

sub get_clock_hash
{
   my $this = shift;

   return $this->project()->get_clock_hash();
}



=item I<get_clock_frequency>

returns a hash keyed by clock name.  Value is frequency in Hz.
=cut

sub get_clock_frequency
{
   my $this = shift;
   my $clock_name = shift || $this->clock_source();
   return $this->project()->get_clock_frequency($clock_name) || &ribbit ("no frequency found for $clock_name");
}




=item I<augment_clock_name()>

Given that a port is a clock port, what name would you give this port?

=cut

sub augment_clock_name
{
   my $this = shift;   
   my $clk_name = shift || return;
   return $this->project()->augment_clock_name($clk_name);
}



=item I<augment_out_clock_name()>

Given that a port is an out_clk port, what name would you give this port?

=cut

sub augment_out_clock_name
{
   my $this = shift;   
   my $port_name = shift || return;
   return $this->project()->augment_out_clock_name($port_name);
}




=item I<clock()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub clock
{
   my $this = shift;
   return 
       $this->augment_clock_name
       (
        $this->{SYSTEM_BUILDER_INFO}{Clock_Source} ||
        "clk"
        );
}



=item I<reset()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub reset
{
   my $this = shift;
   return $this->clock()."_reset";
}



=item I<reset_n()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub reset_n
{
   my $this = shift;
   return $this->reset()."_n";
}



=item I<is_adapter()>

Is this an adapter?  It is if it says it is (Is_Adapter) or if it's a test
adapter (Is_Test_Adapter).  Is_Test_Adapter is for use by adapter-like
components which can be manually added, but which are not subject to other
rules that adapters obey (like being automatically deleted and reinserted by
SOPC Builder).

Also see e_ptf_slave::is_adapter().

=cut

sub is_adapter
{
   my $this = shift;
   return $this->{SYSTEM_BUILDER_INFO}{Is_Adapter} ||
          $this->{SYSTEM_BUILDER_INFO}{Is_Test_Adapter};
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

The inherited class e_module

=begin html

<A HREF="e_module.html">e_module</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
