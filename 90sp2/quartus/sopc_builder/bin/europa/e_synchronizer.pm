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

e_synchronizer.pm - Metastable synchronizer class

=head1 VERSION

1.01

=head1 SYNOPSIS

The e_synchronizer class defines a synchronizer composed
of two registers in series which are clocked in the receiving clock
domain.

=head1 DESCRIPTION

=head2 Overview

The purpose of the synchronizer is to safely transfer asynchronous
signals into a synchronously clocked domain.  The implementation
of the synchronizer is simply to back to back flops clocked by the
receiving clock. Metastable events may
be generated in the first of the two synchronizer flops due to the
asynchronous data transitions.  The purpose of the second flop then
is to filter out these metastable states and not allow them to
propagate further into the block.  Metastable events on the first
flop happen numerous times per second and result in the data transition
out of the synchronizer after the second flop being delayed by one
cycle.  Circuits making use of synchronized inputs must be tolerant
of this delay variation.
In addition, input data pulses must be valid for at least two
cycles in the receiving clock domain, otherwise pulses will get
swallowed i.e. disappear on the occurence of metastable events.
If in doubt, add a pulse stretcher module before the input of the
synchronizer to guarantee a miniumum pulse width.
Multi-bit words can be fed into a multi-bit synchronizer
module to synchronize a set of bits, such as a set of interrupt
pins, but the user must remember that these bits must be
independent from one another.  Buses cannot be synchronized with
a simple synchronizer such as this. This cannot be emphasized strongly
enough. Instead a bus transfer require either a handshake unit such the
Avalon clock crossing adaptor or an asynchronous FIFO such as
e_async_fifo to cross clock domains.  One exception is Gray coded
counters.  The Gray coded states can be passed through synchronizers
since only one bit changes at a time on the bus.
All timing paths terminating on the data input of the first
register stage of the synchronizer are declared as false paths and
are cut.

=head2 Examples

  e_synchronizer->add(
                      {
                       name => "$top_name\_irq_0_sync",
                       port_map => {
                                    data_in  => "irq_0",
                                    data_out => "irq_0_sync",
                                    clk      => "cpu_clk",
                                    reset_n  => "cpu_reset_n"
                                   }
	  	      }
                     );

=cut

package e_synchronizer;

@ISA = ("e_instance");

use e_module;
use e_port;
use e_parameter;
use europa_utils;

use strict;

$e_synchronizer::VERSION = 1.01;

my %all_unique_names = ();

my %fields = (
	      name_stub        => "",
	      data_width       => 1,
              suppress_da      => [],
	      cut_timing       => 1
	     );

my %pointers = (
		unique_names => \%all_unique_names,
	       );

&package_setup_fields_and_pointers(__PACKAGE__,
				   \%fields,
				   \%pointers,
				  );

=head1 METHODS

=over 4

=cut



=item I<new()>

Instantiate a new synchronizer module.

=cut

sub new {
  my $this = shift;
  my $self = $this->SUPER::new(@_);

  $self->_make_synchronizer();
  return $self;
}

sub _make_synchronizer {
  my $this = shift;

  my $name = $this->name() || &ribbit("no name specified for this\n");

  my $module_name = $name."_module";
  my $module      = $this->module
    (e_module->new({name => $module_name}));

  $module->add_contents(
			e_port->new(["clk"]),
			e_port->new(["reset_n"]),
			e_port->new(["data_in",  $this->data_width()]),
			e_port->new(["data_out", $this->data_width(), "output"])
		       );




  my $data_in_d1 = {
    preserve_register  => "1",
    cut_from_timing => $this->cut_timing(),
    out => "data_in_d1",
    in => "data_in",
    clock => "clk",
    enable => "1",
  };
  my $data_out = {
    preserve_register  => "1",
    out => "data_out",
    in => "data_in_d1",
    clock => "clk",
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

  $module->add_contents(
    e_register->new($data_in_d1),
    e_register->new($data_out),
  );
}

=back

=cut

=head1 BUGS AND LIMITATIONS

We need an effective way to cut timing paths on signal nets. Currently
only flop and chip IOs can be used as -to and -from timing path
endpoints. Module ports cannot be used since they may disappear
during the synthesis flattening process. The max_delay mechanism also
has its limitations. The result is that we are currently not able
to cut all false paths, some of which may be reported by the timing
analyzer.

=head1 SEE ALSO

e_async_fifo.pm
e_register.pm

=head1 AUTHOR

Paul Scheidt

=head2 History

Added preserve_register attribute to ensure that no synchronizer
flops ever get optimized away by Quartus.

=head1 COPYRIGHT

Copyright (c) 2005, Altera Corporation. All Rights Reserved.

=cut

1;
