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

e_synchronizer2.pm 

Derives inspiration from e_synchronizer.pm, but

1) it's a static-only package
2) Much different API (pass it a hash of options, rather than name/port_map)
3) returns a list of objects to be added to teh caller's module, rather than
defining a module and returning an instance thereof.

The reason for this package's existence is: e_synchronizer's instance is nice
and tidy, but it prevents Quartus from recognizing register fan-in, which in
turn makes Quartus ignore our careful clock-domain cutting assignments.

A bit of history: e_synchronizer makes a mysterious (and illegal) assignment,
"MAX_DELAY = 100ns".  This assignment is useful because it has the side effect
of overriding Quartus' notions of proper setup time with a large value.  We can
get the same effect with an actual, sensible, clock-frequency-dependent value,
and furthermore cut the clock domain-crossing paths, if we don't bury the logic
in an instance, but rather put it at the caller's top level.

It is the responsibility of the caller to put the logic returned by this module
at the same hierarchical level as the data input - otherwise, we're back where
we started - Quartus will think the input register has no fan-in, and ignore
the timing assignments.

=cut


package e_synchronizer2;
use europa_utils;
@ISA = qw(e_thing_that_can_go_in_a_module);

use strict;

my %fields = (
  data_width       => 1,
  suppress_da      => [],
  cut_timing       => 0,
  data_in          => undef,
  data_out         => undef,
  clock            => undef,
  reset_n          => undef,
  max_delay        => 0, # "100ns",
  comment          => '',
);

my %pointers = ();

&package_setup_fields_and_pointers(__PACKAGE__,
				   \%fields,
				   \%pointers,
				  );
sub new 
{
  my $this = shift;
  my $self = $this->SUPER::new(@_);

  return ($self->get_contents());
}

sub get_contents
{
  my $this = shift;
  my $opt = shift;

  my $d1 = $this->_unique_name($this->data_in());

  my $data_in_d1 = {
    comment => $this->comment(),
    preserve_register  => "1",
    cut_from_timing => $this->cut_timing(),
    out => $d1,
    in => $this->data_in(),
    clock => $this->clock(),
    reset => $this->reset_n(),
    enable => "1",
  };
  my $data_out = {
    preserve_register  => "1",
    out => $this->data_out(),
    in => $d1,
    clock => $this->clock(),
    reset => $this->reset_n(),
    enable => "1"
  };







  if (@{$this->suppress_da()})
  {
    my $suppression = [{
      attribute_name =>
        "SUPPRESS_DA_RULE_INTERNAL",
      attribute_operator => '=',
      attribute_values => $this->suppress_da(),
    }];
    $data_in_d1->{user_attributes} = $suppression;
    $data_out->{user_attributes} = $suppression;
  }


  my $delay = $this->max_delay();
  if ($delay)
  {
    push @{$data_in_d1->{user_attributes}}, 
      {
        attribute_name => "{-from \\\"*\\\"} MAX_DELAY",
        attribute_operator => '=',
        attribute_values => ['\"' . $delay . '\"'],
      };
  }

  my @contents = (
    e_register->new($data_in_d1),
    e_register->new($data_out),
  );

  return @contents;
}

1;

