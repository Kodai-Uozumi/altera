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

e_lpm_instance - description of the module goes here ...

=head1 SYNOPSIS

The e_lpm_instance class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_lpm_instance;

use europa_utils;
use format_conversion_utils;
use e_blind_instance;
use e_width_conduit;



@ISA = qw (e_instance);

use strict;







my %fields =
(
  _order => ["name", "port_map"],
  implement_as_esb => 1,
  mif_file     => "",
  dat_file     => "",

  _mem_array_signal => e_signal->new({
    name => "mem_array",
    width => 1,
    depth => 1,
    never_export => 1,
  }),
  
  _internal_modules => [],
  
  read_address => "rdaddress",



  registered_readaddress => 0,
  registered_readdata => 0,
  

  Read_Latency      => 0,
);

my %pointers =
(
  _blind_instance => e_blind_instance->dummy(),
);

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );
















=item I<_get_rdaddress_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_rdaddress_name
{
  my $this = shift;
  return "read_address";
}




=item I<rdclken()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub rdclken
{
  my $this = shift;
  
  return 1;
}



=item I<get_rdclock_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_rdclock_name
{
   return 'clk';
}



=item I<read_latency_logic()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub read_latency_logic
{
  my $this = shift;
  my $module = shift;
  my $nametag = shift;
  my $delays = shift;
  
  my @things = ();





     push @things, 
       e_register->new({
         delay => $delays,
         in => $this->read_address(),
         out => $this->_get_rdaddress_name(),
         enable => $this->rdclken(),
         clock => $this->get_rdclock_name(),
       });

  return @things;
}



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
  my $this = shift;  
  

  $this->parent(@_);

  $this->_mem_array_signal->width($this->mem_data_width());
  $this->_mem_array_signal->depth($this->mem_depth());





  $this->add_compilation_objects($this->module());
  $this->add_simulation_objects($this->module());

  my $ret = $this->SUPER::update(@_);

  my $esb_imp_word = $this->implement_as_esb() ? "ON" : "OFF";

  my $file = "\"" . $this->mif_file() . "\"";

  if ($this->_blind_instance()->isa_dummy())
  {
    goldfish("Probable error: dummy blind instance at update.\n");
  }
  else
  {

    $this->_blind_instance()->parameter_map($this->ebi_parameter_map());
  }
  



  my $signal = $this->module->get_object_by_name("q");
  if ($signal)
  {
    $signal->width($this->mem_data_width());
  }
  return $ret;
}        




=item I<_create_prototype_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _create_prototype_module
{
  my $this = shift;

  my $proto_name = $this->name() . "_module";
  my $prototype_module = e_module->new({name => $proto_name, });
  $prototype_module->do_black_box(1);




  foreach my $portie (keys(%{$this->port_map()})) {


    my $direction = $portie eq "q" ? "out" : "in";

    $prototype_module->add_contents 
      (e_port->new ({
         name => $portie, 
         direction => $direction,
         copied => 1}),       
       );
  }  

  $prototype_module->add_contents
      (e_width_conduit->new
       ([q => $this->_mem_array_signal()->name()])
       );

  return $this->module($prototype_module);
}



=item I<add_simulation_objects()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_simulation_objects
{
  my $this = shift;
  my $module = shift;

  ribbit("bad usage") if (!$module or !$this or @_);

  my @things;
  push @things,
    $this->read_latency_logic($module, "sim", $this->Read_Latency());
  
  push @things, $this->_mem_array_signal();


  push @things,
    e_assign->new({
      comment => $this->Read_Latency() ?
        " Data read is synchronized through latent_rdaddress." :
        " Data read is asynchronous.",
      lhs => "q",
      rhs => sprintf("mem_array[%s]", $this->_get_rdaddress_name()),
    });

  map {$_->tag("simulation")} @things;
  
  $module->add_contents(@things);
}



=item I<add_compilation_objects()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_compilation_objects
{
  my $this = shift;
  my $module = shift;

  ribbit("bad usage") if (!$module or !$this or @_);

  my @things;
  
  push @things,
    $this->read_latency_logic(
      $module,
      "comp",
      $this->Read_Latency() -
        $this->registered_readaddress() -
        $this->registered_readdata()
    );
  


  my $inst = e_blind_instance->new({
    name          => $this->ebi_name(),
    _module_name  => $this->ebi_module_name(),
    in_port_map   => $this->ebi_in_port_map(),
    out_port_map  => $this->ebi_out_port_map(),
    parameter_map => $this->ebi_parameter_map(),
  });




  $this->_blind_instance($inst);
  
  push @things, $inst;
  

  map {$_->tag("compilation")} @things;
  $module->add_contents(@things);
}



=item I<module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub module
{
  my $this = shift;
 
  if ((@_) && !$this->module()->isa_dummy()) {
    &ribbit("bad attempt to set new prototype module");
  }
  
  return $this->SUPER::module(@_)
}



=item I<mem_data_width()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub mem_data_width
{ 
  my $this = shift;  
  my $width;
  

  my @signals = qw(q data);
  
  return max(
    map
    {
      $this->module()->_get_signal_width ($_,  @_)
    }
    @signals
  );
}



=item I<mem_addr_width()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub mem_addr_width
{ 
  my $this = shift;

  my @signals = $this->module()->get_signal_names();
  for (@signals)
  {
    if (/address/)
    {
      return $this->module()->_get_signal_width ($_,  @_);
    }
  }

  return 1;  
}



=item I<mem_depth()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub mem_depth
{
  my $this = shift;
  my $a_width = $this->mem_addr_width(@_);
  return 2 ** $a_width;
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
   my $this = shift;
   $this->update_blind_instance();
   $this->update_mem_depth();
   return $this->SUPER::to_verilog(@_);
}  



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
   my $this = shift;
   $this->update_blind_instance();
   $this->update_mem_depth();
   return $this->SUPER::to_vhdl(@_);
}  



=item I<update_mem_depth()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update_mem_depth
{
   my $this = shift;
   $this->_mem_array_signal()->depth($this->mem_depth());
}
__PACKAGE__->DONE();

=back

=cut

=head1 EXAMPLE

Here is a usage example ...

=head1 AUTHOR

Santa Cruz Technology Center

=head1 BUGS AND LIMITATIONS

list them here ...

=head1 SEE ALSO

The inherited class e_instance

=begin html

<A HREF="e_instance.html">e_instance</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
