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

e_async_fifo.pm - Asynchronous FIFO class

=head1 VERSION

$Id: //acds/rel-r/9.0sp2/ip/sopc/lib/europa/e_async_fifo.pm#1 $
$DateTime: 2009/04/01 19:53:21 $

=head1 SYNOPSIS

The e_async_fifo class defines a FIFO which asynchronous
write and read data ports.  It is typically used to stream
data across asynchronous clock domains.

=head1 DESCRIPTION

=head2 Overview

The e_asynch_fifo has asynchronous write and read ports
of parameterizable data width.  It sports a backpressure
output on the write data interface as well as full and
empty flags.  Overflow and underflow errors are detected
and flagged on status pins as well.
There are no timing paths between the write and read sides
of the FIFO.

=head2 Examples

   e_async_fifo->add({
 		      name => "stream",
		      fifo_depth => "4",
		      data_width => "24"
 		     });

=cut

package e_async_fifo;

@ISA = ("e_instance");

use europa_all;
use e_synchronizer;
use europa_utils;

use strict;

$e_async_fifo::VERSION = 1.00;

my %all_unique_names = ();

my %fields = (
  name_stub    => "",
  data_width   => 32,
  fifo_depth   => 4
);

my %pointers = (
  unique_names => \%all_unique_names,
);

&package_setup_fields_and_pointers(__PACKAGE__,
                                   \%fields,
                                   \%pointers);

sub new {
  my $this = shift;
  my $self = $this->SUPER::new(@_);

  $self->make_async_fifo();
  return $self;
}

sub make_async_fifo {
  my $this = shift;
  my $name = $this->name() || &ribbit("no name specified for this\n");

  my $module_name = $name."_module";
  my $module      = $this->module
    (e_module->new({name => $module_name}));

  my $thing = e_default_module_marker->new($module);

  $module->comment("\nAsynchronous FIFO: " . $module->name() . "\n\n");

  my $dont_export = 0;
  my $data_width = $this->data_width();
  my $fifo_depth = $this->fifo_depth();

  ($fifo_depth == 4) || &ribbit("asynchronous FIFO depth must be 4 for now\n");

  my $addr_width = &addr_width($fifo_depth);

  my $fifo_write_submodule = &define_fifo_write($this,
						$addr_width,
						$fifo_depth
					       );
  my $fifo_read_submodule = &define_fifo_read($this,
					      $addr_width
					     );
  my $fifo_memory_submodule = &define_fifo_memory($this,
						  $data_width,
						  $addr_width,
						  $fifo_depth
						 );


  e_signal->add([clk_en => "1", "$dont_export"]);
  e_assign->add([clk_en => "1"]);

  e_instance->add({
		   name => "fifo_write",
		   module => $fifo_write_submodule,
		   port_map => {
				"clk" => "write_clk",
				"reset_n" => "write_reset_n",
			       }
		  });

  e_instance->add({
 		   name => "fifo_read",
		   module => $fifo_read_submodule,
		   port_map => {
				"clk" => "read_clk",
				"reset_n" => "read_reset_n",
			       }
		  });

  e_instance->add({
		   name => "fifo_memory",
		   module => $fifo_memory_submodule,
		  });
}




sub define_fifo_write {
  my $this = shift;
  my $addr_width = shift; # 2 for now
  my $depth = shift;      # 4 for now

  my $export = 1; # flag to propagate signal up the module hierarchy

  my $module = e_module->new({
			      name => $this->name()."_fifo_write"
			     });

  my $thing = e_default_module_marker->new($module);

  e_signal->add([fifo_full => "1", "$export"]);
  e_signal->add([write_ptr => "$addr_width", "$export"]);
  e_signal->add([write_gray_ptr => "$addr_width"]);
  e_signal->add([read_shadow_ptr => "$addr_width"]);
  e_signal->add([read_shadow_gray_ptr => "$addr_width"]);
  e_signal->add([read_gray_ptr_sync => "$addr_width"]);
  e_signal->add([next_write_level_ctr => $addr_width]);
  e_signal->add([fifo_almost_full_threshold => "$addr_width"]);
  e_signal->add([fifo_full_level => "$addr_width"]);

  e_assign->add([fifo_almost_full_threshold => "$depth-2"]); # 2
  e_assign->add([fifo_full_level => "$depth-1"]); # 3


  e_register->add({out => "write_ptr",
      	     in => "write_ptr + 1",
      	     clock => "write_clk",
      	     reset => "reset_n",
      	     enable => "write_enable"
      	    });

  e_register->add({out => "read_shadow_ptr",
      	     in => "read_shadow_ptr + 1",
      	     clock => "write_clk",
      	     reset => "reset_n",
      	     enable => "read_token"
      	    });

  gray_encode_write_ptr($addr_width);
  gray_encode_read_shadow_ptr($addr_width);

  e_synchronizer->add({
		       name => "read_ptr_sync",
		       data_width => "$addr_width",
		       port_map => {data_in  => "read_gray_ptr",
				    data_out => "read_gray_ptr_sync",
				    clk_in   => "read_clk",
				    clk_out  => "write_clk",
				    reset_n  => "reset_n",
				   }
		      });
  e_assign->add([read_token => "read_gray_ptr_sync != read_shadow_gray_ptr"]);

  e_register->add({out => "write_level_ctr",
      	     in => "next_write_level_ctr",
      	     clock => "write_clk",
      	     reset => "reset_n"
      	    });
  e_assign->add({ lhs => "next_write_level_ctr",
      	    rhs => "(write_enable & !read_token)? (write_level_ctr + 1) :
                          (!write_enable & read_token) ? (write_level_ctr - 1) : write_level_ctr"
      	    });
  e_register->add({out => "fifo_full",
      	     in => "write_enable & (write_level_ctr == fifo_full_level)",
      	     clock => "write_clk",
      	     reset => "reset_n"
      	     });
  e_register->add({out => "fifo_back_pressure",
      	     in => "write_level_ctr >= fifo_almost_full_threshold",
      	     clock => "write_clk",
      	     reset => "reset_n"
      	     });
  e_register->add({out => "fifo_overflow_error",
		   in => "fifo_full & write_enable",
		   clock => "write_clk",
		   reset => "write_reset_n"
		  });

  return $module;
}
sub gray_encode_write_ptr {
  my $width = shift;

  e_assign->add([ "write_gray_ptr[$width-1]", "write_ptr[$width-1]" ]);

  for (my $i=0; $i <= $width-2; $i++) {
    e_assign->add({ lhs => "write_gray_ptr[$i]",
		    rhs => "write_ptr[$i] ^ write_ptr[$i+1]" 
		  });
  }
}
sub gray_encode_read_shadow_ptr {
  my $width = shift;

  e_assign->add([ "read_shadow_gray_ptr[$width-1]", "read_shadow_ptr[$width-1]" ]);

  for (my $i=0; $i <= $width-2; $i++) {
    e_assign->add({ lhs => "read_shadow_gray_ptr[$i]",
		    rhs => "read_shadow_ptr[$i] ^ read_shadow_ptr[$i+1]" 
		  });
  }
}




sub define_fifo_read {
  my $this = shift;
  my $addr_width = shift; # 2 for now

  my $export = 1; # flag to propagate signal up the module hierarchy

  my $module = e_module->new({
			      name => $this->name()."_fifo_read"
			     });

  my $thing = e_default_module_marker->new($module);

  e_signal->add([read_ptr => "$addr_width", "$export"]);
  e_signal->add([fifo_empty => "1", "$export"]);
  e_signal->add([read_gray_ptr => "$addr_width"]);
  e_signal->add([write_shadow_ptr => "$addr_width"]);
  e_signal->add([write_shadow_gray_ptr => "$addr_width"]);
  e_signal->add([write_gray_ptr_sync => "$addr_width"]);
  e_signal->add([next_read_level_ctr => $addr_width]);

  e_register->add({out => "read_ptr",
		   in => "read_ptr + 1",
		   clock => "read_clk",
		   reset => "read_reset_n",
		   enable => "read_enable"
		  });

  gray_encode_read_ptr($addr_width);
  gray_encode_write_shadow_ptr($addr_width);

  e_register->add({out => "write_shadow_ptr",
		   in => "write_shadow_ptr + 1",
		   clock => "read_clk",
		   reset => "reset_n",
		   enable => "write_token"
		  });



  e_synchronizer->add({
		       name => "write_ptr_sync",
		       data_width => "$addr_width",
		       port_map => {data_in  => "write_gray_ptr",
				    data_out => "write_gray_ptr_sync",
				    clk_in   => "write_clk",
				    clk_out  => "read_clk",
				    reset_n  => "reset_n",
				   }
		      });

  e_assign->add([write_token => "write_gray_ptr_sync != write_shadow_gray_ptr"]);

  e_register->add({out => "read_level_ctr",
      	     in => "next_read_level_ctr",
      	     clock => "read_clk",
      	     reset => "reset_n"
      	    });

  e_assign->add({ lhs => "next_read_level_ctr",
      	    rhs => "(read_enable & !write_token)? (read_level_ctr - 1) :
                          (!read_enable & write_token) ? (read_level_ctr + 1) : read_level_ctr"
      	  });

  e_register->add({out => "fifo_empty",
      	     in => "next_fifo_empty",
      	     clock => "read_clk",
      	     reset => "read_reset_n",
      	     async_value => 1
      	     });

  e_assign->add({lhs => "next_fifo_empty",
      	   rhs=> "(fifo_empty) ?  ((read_level_ctr > 0) ? 0 : fifo_empty) :
                                        (read_enable & (read_level_ctr == 1))"
      	  });

  e_register->add({out => "fifo_underflow_error",
      	     in => "fifo_empty & read_enable",
      	     clock => "read_clk",
      	     reset => "read_reset_n",
      	     });


  e_register->add({out => "fifo_read_data",
		   in => "read_data",
		   clock => "read_clk",
		   enable => "read_enable",
		   reset => "read_reset_n",
		  });

  return $module;
}

sub gray_encode_read_ptr {
  my $width = shift;

  e_assign->add([ "read_gray_ptr[$width-1]", "read_ptr[$width-1]" ]);

  for (my $i=0; $i <= $width-2; $i++) {
    e_assign->add({ lhs => "read_gray_ptr[$i]",
		    rhs => "read_ptr[$i] ^ read_ptr[$i+1]"
		  });
  }
}
sub gray_encode_write_shadow_ptr {
  my $width = shift;

  e_assign->add([ "write_shadow_gray_ptr[$width-1]", "write_shadow_ptr[$width-1]" ]);

  for (my $i=0; $i <= $width-2; $i++) {
    e_assign->add({ lhs => "write_shadow_gray_ptr[$i]",
		    rhs => "write_shadow_ptr[$i] ^ write_shadow_ptr[$i+1]" 
		  });
  }
}





sub define_fifo_memory {
  my $this = shift;
  my $data_width = shift;
  my $addr_width = shift;  # 2 for now
  my $depth = shift;       # 4 for now

  my $module = e_module->new({
			      name => $this->name()."_fifo_memory"
			     });

  my $thing = e_default_module_marker->new($module);

  e_signal->add([write_data => "$data_width"]);
  e_signal->add([read_data => "$data_width"]);
  e_signal->add([read_select => "$depth"]);
  e_signal->add([write_select => "$depth"]);

  e_assign->add([read_select => "1 << read_ptr"]);
  e_assign->add([write_select => "1 << write_ptr"]);


  my $mux_or = "0";

  for (my $row=0; $row<$depth; $row++) {
    e_signal->add({
      	     name  => "mem_word_$row",
      	     width => "$data_width"
      	    });
    e_register->add({out => "mem_word_$row",
      	       in => "write_data",
      	       clock => "write_clk",
      	       reset => "write_reset_n",
      	       enable => "write_select[$row]",
      	      });


    e_signal->add({
      	     name  => "qualified_mem_word_$row",
      	     width => "$data_width"
      	    });
    e_assign->add({
      	     lhs => "qualified_mem_word_$row",
      	     rhs => "read_select[$row] ? mem_word_$row : 0"
      	    });
    $mux_or = $mux_or . " | qualified_mem_word_$row";
  }
  e_assign->add({
		 lhs => "read_data",
		 rhs => "$mux_or"
		});

  return $module;
}




sub addr_width {
  my $depth = shift;
  my $addr_width;
  for (my $width=1; $width<$depth; $width++) {
    if (2 ** $width >= $depth) {
      $addr_width = $width;
      last;
    }
  }
  (2 ** $addr_width == $depth ) ||
    &ribbit("FIFO depth must be a power of 2\n");
  return $addr_width;
}

=head1 BUGS AND LIMITATIONS

Currently the FIFO is restricted to having a depth of four
words.  This may be expanded in the future.  The FIFO storage
is composed of discrete LE flip-flops rather than memory
blocks in order to conserve memories and achieve higher fmax.

=head1 SEE ALSO

=head1 AUTHOR

Paul Scheidt

=head2 History

=head1 COPYRIGHT

Copyright (c) 2004, Altera Corporation. All Rights Reserved.

=cut

1;

