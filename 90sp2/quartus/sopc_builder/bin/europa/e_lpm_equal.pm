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

e_lpm_equal - description of the module goes here ...

=head1 SYNOPSIS

The e_lpm_equal class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_lpm_equal;

use europa_utils;
use e_instance;
use e_blind_instance;

@ISA = qw (e_instance);

use strict;

my %fields =
(

  data_width => 0,
  chain_size => 8,
);

my %pointers =
(
);





&package_setup_fields_and_pointers(__PACKAGE__,
                                   \%fields,
                                   \%pointers);



=item I<new()>

Object constructor

=cut

sub new 
{
  my $this = shift;
  my $self = $this->SUPER::new(@_);


  ribbit("Data Port width not specified") if $self->data_width() == 0;
  
  $self->_create_module();

  return $self;
}



=item I<_create_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _create_module
{
  my $this = shift;

  my $proto_name = $this->name() . "_module";
  my $module = e_module->new({name => $proto_name, });

  $module->do_black_box(0);




  my $data_width = $this->data_width();

  $module->add_contents(e_port->new(["dataa",$data_width]));
  $module->add_contents(e_port->new(["datab",$data_width]));
      
  $module->add_contents(e_port->new(["aeb",1,"out"]));
  
  $this->module($module);
}









=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
  my $this = shift;  
  $this->parent(@_);











  $this->add_objects();

  my $ret = $this->SUPER::update(@_);
  
  return $ret;
}





=item I<add_objects()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_objects
{
  my $this = shift;
  my $module = $this->module();

  ribbit("bad usage") if (!$module or !$this or @_);

  my @things;
  



  my $chain_size = $this->chain_size();
  push @things,
  e_blind_instance->new({
      name => 'the_lpm_equality_compare',
      module => 'lpm_compare',
      use_sim_models => 1,
      in_port_map => {
          dataa  => 'dataa',
          datab  => 'datab',
      },
      out_port_map => {
          aeb    => 'aeb',
      },
      parameter_map => {
          lpm_width          => $this->data_width(),
          lpm_type           => qq("LPM_COMPARE"),
          lpm_representation => qq("UNSIGNED"),
	  lpm_hint           => qq("CHAIN_SIZE=$chain_size"),
      },
  });
  


  
  $module->add_contents(@things);
}


qq{
Let the wise one watch over the mind,
So hard to perceive, so artful,
Alighting where it wishes;
A watchfully protected mind
Will bring happiness.

 - Dhammapada
};

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
