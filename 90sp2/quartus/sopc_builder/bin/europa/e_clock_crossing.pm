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

0.1

=head1 SYNOPSIS

The e_synchronizer class defines a synchronizer composed
of two registers in series which are clocked in the receiving clock
domain.

=head1 DESCRIPTION

=head2 Overview

The purpose of the synchronizer is to filter out metastable
events when passing signals from one clock domain to another
clock domain. Input data pulses must be valid for at least two
cycles in the receiving clock domain, otherwise pulses may get
swallowed i.e. disappear on metastable events. If in doubt, then
add a pulse stretcher module before the input of the synchronizer.
Multi-bit words can be fed into the synchronizer
module to synchronize a set of bits, such as a set of interrupt
pins, but the user must remember that these bits must be 
independent.  Buses cannot be synchronized with a simple synchronizer
such as this, but instead require either a handshake unit such the
Avalon clock crossing adaptor or an asynchronous FIFO. Gray coded
counters can however be synchronized, provided special precautions
are taken, since only one bit changes at a time.
All timing paths terminating on the data input of the first
register stage of the synchronizer
are cut using the Altera Quartus CUT synthesis attribute.

=head2 Examples

      e_synchronizer->add({
                       name => "$top_name\_xferred_sync",
                       port_map => {data_in => "master_done",
                                    data_out => "xferred",
                                    clk => "slave_clk",
                                    reset_n => "slave_reset_n"
                                   }
			  });

=head1 BUGS AND LIMITATIONS

We need a better way to cut timing paths on signal nets. Currently
only flop and chip IOs can be used as -to and -from timing path
endpoints. Module ports cannot be used since they may disappear
during the synthesis flattening process.  This forces us to 
gratuitously instantiate flops soley to satisfy the static timing 
analyzer.

=head1 SEE ALSO

e_register.pm

=head1 AUTHOR

Paul Scheidt

=head2 History

=head1 COPYRIGHT

Copyright (c) 2004, Altera Corporation. All Rights Reserved.

=cut


=head1 NAME

e_clock_crossing - description of the module goes here ...

=head1 SYNOPSIS

The e_clock_crossing class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_clock_crossing;

@ISA = ("e_instance");

use e_module;
use e_port;
use e_parameter;
use europa_utils;

use strict;

my %all_unique_names = ();

my %fields = (
	      name_stub        => "",
	      data_width       => 1
	     );

my %pointers = (
		unique_names => \%all_unique_names,
	       );

&package_setup_fields_and_pointers(__PACKAGE__,
				   \%fields, 
				   \%pointers,
				  );



=item I<new()>

Object constructor

=cut

sub new {
  my $this = shift;
  my $self = $this->SUPER::new(@_);


  $self->make_synchronizer();
  return $self;
}




=item I<make_synchronizer()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_synchronizer {
  my $this = shift;

  my $name = $this->name() || &ribbit 
    ("no name specified for this\n");

  my $module_name = $name."_module";
  my $module      = $this->module
    (e_module->new({name => $module_name}));


  $module->add_contents(
			e_port->new(["clk"]),
			e_port->new(["reset_n"]),
			e_port->new(["data_in",  $this->data_width()]),
			e_port->new(["data_out",  $this->data_width(), "output"])
		       );




  $module->add_contents (
			 e_register->new({
					  out => "data_in_d1",
					  in => "data_in",
					  clock => "clk",
					  enable => "1",
					  cut_to_timing => "1"
					 }),
			 e_register->new({
					  out => "data_out",
					  in => "data_in_d1",
					  clock => "clk",
					  enable => "1"
					 })
			);
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

The inherited class e_instance

=begin html

<A HREF="e_instance.html">e_instance</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
