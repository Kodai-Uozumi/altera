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

e_vfifo - description of the module goes here ...

=head1 SYNOPSIS

The e_vfifo class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_vfifo;

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
  almost_empty_warn=> 1, # how many entries before mt do I assert almost_empty
);

my %pointers = (
  unique_names => \%all_unique_names,
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


  $self->make_vfifo();
    
  return $self;
}








=item I<make_vfifo()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_vfifo
{
  my $this = shift;

  my $name = $this->name_stub() . "_vfifo_module";
  while ($this->{unique_names}->{$name}) {
    $name =~ s/_(\d+)$//;
    my $digit = $1 || 0;
    $digit++;
    
    $name .= "_" . $digit;
  }

  $this->{unique_names}->{$name} = 1;
  $this->name($name);


  my $width = $this->data_width();

  my $depth;
  if (defined ($this->depth())) {
      $depth = $this->depth();
      ribbit ("$this->{name}: Minimum Depth for a validated fifo is 2; ".
	      "you wanted $depth") if ($depth < 2);
  } else {
      ribbit ("$this->{name}: Depth for a validated fifo is not set!")
	  if ($depth < 2);
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


  $this->add_contents
      (
       e_port->new(["clk"]),
       e_port->new(["reset_n"]),
       e_port->new(["invalidate"]),
       e_port->new(["enable"]),
       e_port->new(["wr"]),
       e_port->new(["rd"]),
       e_port->new(["wr_data",  $width]),
       e_port->new(["rd_data",  $width, "output"]),
       e_port->new(["almost_empty", 1, 'output',]),
       e_port->new(["almost_full", 1, 'output',]),
       e_port->new(["empty", 1, 'output',]),
       e_port->new(["full", 1, 'output',]),
       e_port->new(["valid", 1, 'output',]),
       );
  

  $this->add_contents
      (
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

       e_signal->new({
	   name => "valid_vector",
	   width => $depth,
       }),
       );
  
  my @one_hot_vectors = &one_hot_encoding($depth);

  my %rd_data_mux_hash = (default => [rd_data => "entry_0"]);
  my %wr_data_mux_hash = (default => []);
  my %seven_mux_hash = (default => ["valid_vector" => $depth."'b0"]);
  my %five__mux_hash = (default => ["valid_vector" => $depth."'b0"]);
  my %three_mux_hash = 
      (default => 
       ["valid_vector" => "shift_vector | ".$depth."'b0"]);
  my %one___mux_hash = (default => ["valid_vector" => $depth."'b0"]);
  
  for (my $i = 0; $i < $depth; $i++) {

      $this->add_contents
	  (
	   e_signal->new
	   ({name => "entry_$i",width=> $width})
	   );

      $rd_data_mux_hash{$i} = [rd_data => "entry_$i"];

      $wr_data_mux_hash{$i} = ["entry_$i" => "wr_data"];

      $seven_mux_hash{$i} = ["valid_vector" => $one_hot_vectors[$i] ];
      $five__mux_hash{$i} = ["valid_vector" => $one_hot_vectors[$i] ];
      $three_mux_hash{$i} = 
	  ["valid_vector" => "shift_vector | ".$one_hot_vectors[$i] ];
      $one___mux_hash{$i} = 
          ["valid_vector" => "valid_vector | ".$one_hot_vectors[$i] ];
  }

  $this->add_contents
      (
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











  

  $this->add_contents
      (
       e_process->new({
	   clock   => "",
	   contents=> [
		       e_case->new({
			   switch => "rd_address",
			   parallel=> 1,


			   contents=> {%rd_data_mux_hash},
		       }),
		       ],
       }),
       );
  
  my $rw_case = e_case->new ({
      switch => "rdwr",
      parallel=> 1,
      full => 1,
      contents=> {
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
				 rhs => "(wr_address == ".($depth - 1).") ? ".
				     "0 : (wr_address + 1)",
			     }),
			     ],
		}),
		e_if->new({
		    comment => " Disabled invalidate handling",
		    condition => "!enable & invalidate",
		    then => [
			     e_assign->new({
				 lhs => "entries",
				 rhs => $entries_bits."'h1",
			     }),
			     e_assign->news
			     (
			      ["wr_address" => $fifo_address_bits."'h1"],
			      ["rd_address" => $fifo_address_bits."'h0"],
			      ),
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
				 rhs => "(rd_address == ".($depth - 1).") ? ".
				     "0 : (rd_address + 1)",
			     }),
			     ],
		}),
		],
	  3 => [
		e_assign->new({
		    lhs => "wr_address",
		    rhs => "(wr_address == ".($depth - 1).") ? ".
			"0 : (wr_address + 1)",
		}),
		e_assign->new({
		    lhs => "rd_address",
		    rhs => "(rd_address == ".($depth - 1).") ? ".
			"0 : (rd_address + 1)",
		}),
		],
	  default => [
                e_if->new({
		    comment => " Disabled invalidate handling",
		    condition => "!enable & invalidate",
		    then => [
			     e_assign->new({
				 lhs => "entries",
				 rhs => $entries_bits."'h0",
			     }),
			     e_assign->news
			     (
			      ["wr_address" => $fifo_address_bits."'h0"],
			      ["rd_address" => $fifo_address_bits."'h0"],
			      ),
			     ],
			 }),
		      ],
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


      contents=>{%wr_data_mux_hash},
  });

  $this->add_contents
      (
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
  

  $this->add_contents
      (
       e_signal->new({name => "valid_vector",  width => $depth}),
       e_signal->new({name => "shift_vector",  width => $depth}),
       e_signal->new({name => "valid_control", width => 3}),
       e_signal->new({name => "emone",
		      width=> $entries_bits,
		      never_export => 1}),
       e_assign->new({lhs  => "shift_vector", 
		      rhs  => "{1'b0, valid_vector[".($depth - 1).":1]}"}),
       e_assign->new({lhs  => "valid_control", 
		      rhs  => "{invalidate, (rd & !empty), (wr & !full)}"}),
       e_assign->new({lhs  => "valid",
		      rhs  => "valid_vector[0] | (rd & wr & empty)"}),
       e_assign->new({lhs  => "emone",
		      rhs  => "entries - 1"}),
       );


  my $one_case   = e_case->new ({
      switch   => "entries",
      parallel => 1,
      contents => {%one___mux_hash},
  });

  my $three_case = e_case->new ({
      switch   => "emone",
      parallel => 1,
      contents => {%three_mux_hash},
  });

  my $five_case = e_case->new ({
      switch   => "entries",
      parallel => 1,
      contents => {%five__mux_hash},
  });

  my $seven_case = e_case->new ({
      switch   => "emone",
      parallel => 1,
      contents => {%seven_mux_hash},
  });
  
  my $v_case = e_case->new ({
      switch   => "valid_control",
      parallel => 1,
      contents => {
	  0 => [],
	  1 => [ $one_case, ],

	  2 => ["valid_vector" => "shift_vector"],
	  3 => [ $three_case,








		],
	  5 => [ $five_case,








		],
	  7 => [ $seven_case,








		],

	  default => ["valid_vector" => "{".$depth."{1'b0}}"],
      },
  });
  
  my $vector = e_process->new({
      asynchronous_contents => 
	  [
	   e_assign->new({lhs => "valid_vector", rhs => "{".$depth."{1'b0}}"}),
	   ],
      contents => 
          [
           e_if->new({
              comment => " special empty case:",
              condition => "rd & wr & empty",
              then => ["valid_vector" => "{".$depth."{1'b0}}"],
              else => [$v_case],
           }),
           ],
  });

  $this->add_contents($vector);

}


qq {
Under the trees, among the rocks, a thatched hut:
Verses and sacred commentaries live there together.
I’ll burn the books I carry in my bag,
But how can I forget the verses written in my gut? 

- Ikkyu (1394-1481) 

End of package e_vfifo.pm
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
