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

e_efifo - description of the module goes here ...

=head1 SYNOPSIS

The e_efifo class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_efifo;

@ISA = qw(e_module);

use e_module;
use e_port;
use e_parameter;
use europa_utils;

use strict;
my %all_unique_names = ();

my %fields = (
  name_stub        => "",
  data_width       => 1,
  depth            => undef,
  implement_as_esb => 1,
  almost_full_warn => 1, # how many entries before full do I assert almost_full
  almost_empty_warn=> 1, # how many entries before empty do I assert almost_empty
);

my %pointers = (
  unique_names => \%all_unique_names,
);

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
  $self->make_efifo();
    
  return $self;
}



=item I<make_efifo()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_efifo
{
  my $this = shift;

  my $name = $this->name_stub() . "_efifo_module";
  while ($this->{unique_names}->{$name}) {
    $name =~ s/_(\d+)$//;
    my $digit = $1 || 0;
    $digit++;
    
    $name .= "_" . $digit;
  }

  $this->{unique_names}->{$name} = 1;
  $this->name($name);


  my $width = $this->data_width();

  my $depth = 4;
  if (defined ($this->depth())) {
      $depth = $this->depth();
      ribbit ("Max Depth for an elasticity fifo is 4; you wanted $depth") if ($depth > 4);
      ribbit ("Min Depth for an elasticity fifo is 2; you wanted $depth") if ($depth < 2);
  }
  my $fifo_address_bits = ceil(log2($depth));

  my $entries_bits = $fifo_address_bits + 1;
  
  my $almost_empty = $this->almost_empty_warn();
  if ($almost_empty > $depth) {
      goldfish("almost_empty_warn set beyond $depth; forced to $depth");
      $almost_empty = $depth;
  }
  my $almost_full = $this->almost_full_warn();
  if ($almost_full > $depth) {
      goldfish("almost_full_warn set beyond $depth; forced to $depth");
      $almost_full = $depth;
  }


  $this->add_contents(
    e_port->new(["clk"]),
    e_port->new(["reset_n"]),
    e_port->new(["wr"]),
    e_port->new(["rd"]),
    e_port->new(["wr_data",  $width]),
    e_port->new(["rd_data",  $width, "output"]),
    e_port->new(["almost_empty", 1, 'output',]),
    e_port->new(["almost_full", 1, 'output',]),
    e_port->new(["empty", 1, 'output',]),
    e_port->new(["full", 1, 'output',]),
  );
  

  $this->add_contents(
		      e_signal->new({
			  name => "rd_address",
			  width => $fifo_address_bits,
		      }),
		      e_signal->new({
			  name => "wr_address",
			  width => $fifo_address_bits,
		      }),
		      e_signal->new({
			  name => "rdwr",
			  width=> 2,
		      }),
		      e_signal->new({
			  name => "entries",
			  width => $entries_bits,
		      }),
  );
  
  my %rd_data_mux_hash = (default => []);
  my %wr_data_mux_hash = (default => []);
  for (my $i = 0; $i < $depth; $i++) {

      $this->add_contents(e_signal->new({name => "entry_$i",width=> $width}));

      $rd_data_mux_hash{$i} = [rd_data => "entry_$i"];

      $wr_data_mux_hash{$i} = [e_assign->new({lhs => "entry_$i",rhs => "wr_data"})];
  }

  $this->add_contents(
		      e_assign->new({
			  lhs => 'rdwr',
			  rhs => "{rd, wr}",
		      }),
		      e_assign->new({
			  lhs => 'full',
			  rhs => "(entries == $depth)",
		      }),
		      e_assign->new({
			  lhs => 'almost_full',
			  rhs => "(entries >= ". ($depth - $almost_full) .")",
		      }),
		      e_assign->new({
			  lhs => 'empty',
			  rhs => "(entries == 0)",
		      }),
		      e_assign->new({
			  lhs => 'almost_empty',
			  rhs => "(entries <= ". $almost_empty .")",
		      }),
		      );


  $this->add_contents(
		      e_process->new({
			  clock   => "",
			  contents=> [
				      e_case->new({
					  switch => "rd_address",
					  parallel=> 1,
					  full => 1,
					  contents=> {%rd_data_mux_hash},
				      }),
				      ],
			  }),
		      );

  my $rw_case = e_case->new ({
      switch => "rdwr",
      parallel=> 1,
      full => 1,
      contents=>{ # 0 => [], # just a test, to see if a null case shows up
		  1 => [
			e_if->new({
			    comment => " Write data",
			    condition => "!full",
			    then => [
				     e_assign->new({
					 lhs => "entries",
					 rhs => "entries + 1",
				     }),
				     e_assign->new({
					 lhs => "wr_address",
					 rhs => "(wr_address == ". ($depth - 1) .") ? 0 : (wr_address + 1)",
				     }),
				     ],
			}),
			],
		  2 => [
			e_if->new({
			    comment => " Read data",
			    condition => "(!empty)",
			    then => [
				     e_assign->new({
					 lhs => "entries",
					 rhs => "entries - 1",
				     }),
				     e_assign->new({
					 lhs => "rd_address",
					 rhs => "(rd_address == ". ($depth - 1) .") ? 0 : (rd_address + 1)",
				     }),
				     ],
			}),
			],
		  3 => [
			e_assign->new({
			    lhs => "wr_address",
			    rhs => "(wr_address == ". ($depth - 1) .") ? 0 : (wr_address + 1)",
			}),
			e_assign->new({
			    lhs => "rd_address",
			    rhs => "(rd_address == ". ($depth - 1) .") ? 0 : (rd_address + 1)",
			}),
			],
		  default => [],
	      },
  });

  my $fsm = e_process->new({
      asynchronous_contents => [
	  e_assign->new({
	      lhs => "wr_address",
	      rhs => "0",
	  }),
	  e_assign->new({
	      lhs => "rd_address",
	      rhs => "0",
	  }),
	  e_assign->new({
	      lhs => "entries",
	      rhs => "0",
	  }),
      ],
      contents => [$rw_case],
  });

  $this->add_contents($fsm);

  my $wr_case = e_case->new({
      switch => "wr_address",
      parallel=> 1,
      full => 1,
      contents=>{%wr_data_mux_hash},
  });

  $this->add_contents(
		      e_process->new({
			  contents => [
				       e_if->new({
					   comment => "Write data",
					   condition => "wr & !full",
					   then => [$wr_case],
				       }),
				   ],
		      }),
		      );

}


qq {
Green waters and verdant mountains 
are the places to walk in meditation;
by the streams or under the trees
are places to clear the mind. 
Observe impermanence, 
never forget it; 
this urges on the will to seek enlightenment. 

 - Keizan Jokin (1264-1325)

End of package e_efifo.pm
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

The inherited class e_module

=begin html

<A HREF="e_module.html">e_module</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
