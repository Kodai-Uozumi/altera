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

e_ptf_arbitration_module - description of the module goes here ...

=head1 SYNOPSIS

The e_ptf_arbitration_module class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_ptf_arbitration_module;

use e_module;

@ISA = ("e_module");
use strict;
use europa_utils;






my %fields = ();

my %pointers = (
                _master_or_slave => (bless {}, "e_ptf_slave"),
                );

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );







=item I<clock()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub clock
{
   my $this = shift;
   return $this->_master_or_slave()->clock();
}



=item I<reset()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub reset
{
   my $this = shift;
   return $this->_master_or_slave()->reset();
}



=item I<reset_n()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub reset_n
{
   my $this = shift;
   return $this->_master_or_slave()->reset_n();
}



=item I<_make_signal()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _make_signal
{
   my $this = shift;

   my $signal = shift or &ribbit ("no signal");

   $signal =~ s|\/|\_|g;
   $signal =~ s|\_{2,}|\_|g;
   return ($signal);
}



=item I<_update_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _update_name
{
   my $this = shift;
   my $slave = $this->_master_or_slave();
   my $slave_mod = $slave->parent_module();

   my $name = join
       ('/',$slave_mod->name(),$slave->name(),"arbitrator");
   return ($this->name($this->_make_signal($name)));
}



=item I<_get_exclusively_named_port_by_type()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_exclusively_named_port_by_type
{
   my $this = shift;

   my $type = shift or &ribbit ("no type");
   my $return = $this->_master_or_slave()->
       _get_exclusively_named_port_or_its_complement
           ($type);

   return ($return);
}



=item I<_get_top()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_top
{
   my $this = shift;

   my $project =
       $this->_master_or_slave()->parent_module()->_project() 
           or &ribbit ("no project");

   my $top = $project->top() or &ribbit ("no top");
   return ($top);
}



=item I<_get_mux_of_type()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_mux_of_type
{
   my $this = shift;
   my $type = shift or &ribbit ("no type");

   my $mux = $this->get_object_by_name("mux $type");

   if (!$mux)  #make $mux_type if it does not exist.
   {
      my $default = 0;
      if ($type =~ /\_n$/)
      {
         $default = 1;
      }
      $mux = e_mux->new
          ({name => "mux $type",
            default => $default,
            parent => $this,
         });

      $this->add_contents($mux);
      $this->document_object($mux);
   }
   return ($mux);
}



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
   my $this = shift;
   $this->_update_name();


   $this->SUPER::update(@_);
}












=item I<_get_parents_ports()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_parents_ports
{
   my $this  = shift;
   my $ports = $this->_master_or_slave->_ports_by_type();

   foreach my $port (values (%$ports))
   {
      my $exclusive_name = $port->_exclusive_name();
      my $sig = e_signal->new($port);
      $sig->name($exclusive_name);
      $sig->export(0);
      $this->add_contents($sig);
   }
}



=item I<_get_master_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master_module
{
   my $this = shift or ribbit ("no this!");
   my ($master_module_name,
       $master_name) = split (/\//,shift);

   $master_module_name or &ribbit ("no master module name");
   

   my $project = $this->_master_or_slave()->project();
   my $master_module =
       $project->get_module_by_name($master_module_name);
   if (!$master_module)
   {
      &ribbit ("($project), known modules include ",
               join ("\n", keys
                     (%{$project->module_hash()})),
               "\n",
               $this->name(),
               "$this no master module declared for $master_module_name\n"
               );
   }
   return ($master_module);
}



=item I<_get_master()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master
{
   my $this = shift;
   my $master_desc = shift;
   my ($master_module_name,
       $master_name) = split (/\//,
                              $master_desc);

   $master_name or &ribbit ("no master module name");

   my $master_module = $this->_get_master_module($master_desc);
   my $master = $master_module->get_object_by_name($master_name)
       or &ribbit ("no master could be found ($master_desc) ".
                   "known names include ",$master_module->get_object_names(),"\n");

   return ($master);
}



=item I<_get_slave()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_slave
{
   my $this = shift;
   return ($this->_get_master(@_));
}




=item I<_get_slave_id()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_slave_id
{
   my $this = shift;
   my $slave_name        = $this->_master_or_slave()->name();
   my $slave_module      = $this->_master_or_slave()->parent_module();
   my $slave_module_name = $slave_module->name();

   my $number_of_kids    = scalar (keys (%{$slave_module->{SLAVE}}) +
                                   keys (%{$slave_module->{MASTER}})
                                   );

   my $slave_id = "$slave_module_name";
   $slave_id .= "/$slave_name";


   return ($slave_id);

}















=item I<make_signal_of_type()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_signal_of_type
{
  my $this = shift;
  my $type = shift  or &ribbit ("No type");

  my @other_signal_values;  # additional parameters to e_signal
  my $dummy_e_signal = e_signal->new (["dummy"]);
  my @signal_order = grep {$_ !~ /^name$/}  @{$dummy_e_signal->_order()};
  foreach my $signal_value (@_)  {
    push @other_signal_values, shift (@signal_order), $signal_value;
  }

  my $signal_name = $this->get_signal_name_by_type ($type);
  my $new_signal = e_signal->new ({
      name    => $signal_name, 
      type    => $type,
      @other_signal_values,
    }) ->within ($this);
  return $signal_name;
}










=item I<get_signal_name_by_type()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_signal_name_by_type
{
  my $this = shift;
  my $type = shift  or &ribbit ("No type");

  my $module_desc = $this->_get_slave_id();
  my $signal_name = $this->_make_signal ($module_desc ."_". $type) ;
  return $signal_name;
}




=item I<get_signal_name_of_type()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_signal_name_of_type
{ my $this = shift; return $this->get_signal_name_by_type(@_); }



=item I<get_modelsim_list_info()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_modelsim_list_info
{
  my $this = shift;
  




  my @interesting_types = qw(
    address
    begintransfer
    byteenable
    chipselect
    clk
    dataavailable
    irq
    irqnumber
    outputenable
    read
    readdata
    readdatavalid
    readyfordata
    reset
    waitrequest
    write
    writedata
  );
  

  my @sim_signals = map {
    $this->_master_or_slave()->_ports_by_type()->{$_} or ()
  } @interesting_types;
  
  print STDERR "ptf signals in e_ptf_arbitration_module @{[$this->name()]}:\n";
  print STDERR (map {"  @{[$_->_exclusive_name()]}\n"} @sim_signals), "\n";  
    








  

  my %unique;
  map {$unique{$_->name()} = $_} @sim_signals;
  @sim_signals = values %unique;

  






  



  
  return {
    instance_name => $this->_instantiated_by()->[0]->name(),
    file_name => __FILE__, 
    package_name => 'e_ptf_arbitration_module_modelsim_assertions',
    test_function => 'do_timestep',
    signals => \@sim_signals,
  };
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

The inherited class e_module

=begin html

<A HREF="e_module.html">e_module</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
