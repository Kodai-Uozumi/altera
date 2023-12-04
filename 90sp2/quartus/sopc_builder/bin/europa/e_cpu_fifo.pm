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

e_cpu_fifo - description of the module goes here ...

=head1 SYNOPSIS

The e_cpu_fifo class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_cpu_fifo;

@ISA = qw(e_module);

use e_module;
use e_port;
use e_parameter;
use europa_utils;

use strict;
my %all_unique_names = ();

my %fields = (
  name_stub    => "",
  data_width   => 1,
  fifo_depth   => 1,
  use_flush    => 0,
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


  $self->make_fifo();
    
  return $self;
}



=item I<make_fifo()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_fifo
{
  my $this = shift;

  my $name = $this->name_stub() . "_fifo_module";
  while ($this->{unique_names}->{$name})
  {
    $name =~ s/_(\d+)$//;
    my $digit = $1 || 0;
    $digit++;
    
    $name .= "_" . $digit;
  }
  $this->{unique_names}->{$name} = 1;

  $this->name($name);
  


  my $depth = $this->fifo_depth();
  my $fifo_address_bits=($depth > 0)? (&Bits_To_Encode($depth-1)) : 0; 















  $this->add_contents(
    e_port->new(["clk"]),
    e_port->new(["clk_en"]),
    e_port->new(["reset_n"]),
    e_port->new(["fifo_write"]),
    e_port->new(["fifo_read"]),
    e_port->new(["fifo_wr_data", $this->data_width()]),
    e_port->new(["fifo_rd_data", $this->data_width(), "output"]),

    e_port->new(["ic_read",       1,                   "output"]),
    e_port->new(["fifo_read_data_bad", 1,              "output"]),
  );


  if ($this->use_flush) {
    $this->add_contents( e_port->new(["flush",        1]) );
  } else {
    $this->add_contents(
        e_assign->new({
            lhs => e_signal->new(["flush", 1]),
            rhs => 0,
        }),
    );
  }



  $this->add_contents(







    e_register->new({
        q   => e_signal->new(["internal_fifo_empty"]),
        sync_set    => "fifo_becoming_empty",
        sync_reset  => "(fifo_write & ~fifo_read)",# & internal_fifo_empty 
        priority    => "set", 
        async_set   => "reset_n",
        async_value => "1", 
    }),








    e_register->new({
        q   => e_signal->new(["ic_read"]),
        sync_set    => "set_ic_read",
        sync_reset  => "reset_ic_read",
        priority    => "reset", 
        enable      => "~ic_wait",
        async_set   => "reset_n",
        async_value => "0", 
    }),
    e_assign->news (
      [["set_ic_read", 1, 0, 1],  "fifo_becoming_empty | internal_fifo_empty"],
      [["reset_ic_read", 1, 0, 1], "(fifo_write & ~fifo_read        ) || ".
                                   "  (dont_forget_to_reset_ic_read &&   ".
                                   "    ~internal_fifo_empty           ) "],
      [["ic_read_confusion", 1, 0, 1],  "set_ic_read & reset_ic_read"],
    ),










































    e_register->new ({
        q           => "dont_forget_to_reset_ic_read",
        sync_set    => "(fifo_write & ~fifo_read) && ic_wait",
        sync_reset  => "
                (dont_forget_to_reset_ic_read && ~ic_wait             ) ||
                (internal_fifo_empty && dont_forget_to_reset_ic_read )  ",


        priority    => "reset",
        enable      => "1'b1",
        async_set   => "reset_n",
        async_value => "1'b1",
    }),
  );


  if ($depth > 1) {
    $this->add_contents(


        e_assign->new({
            lhs => e_signal->new(["fifo_inc"]),
            rhs => "fifo_write"
        }),
        e_assign->new({
            lhs => e_signal->new(["fifo_dec"]),
            rhs => "fifo_read & ~(fifo_read_data_bad)"
        }),





        e_shift_register->new ({
            name               => "rdaddress_calculator",
            direction          => "MSB-first",
            parallel_out       => e_signal->new (["read_pointer", $depth]),
            serial_in          => "read_pointer\[($depth-1)\]",
            shift_enable       => "fifo_dec",
            shift_length       => $depth,
            async_value        => 1,
            parallel_in        => "1",
            load               => "flush",
        }),


        e_shift_register->new ({
            name               => "wraddress_calculator",
            direction          => "MSB-first",
            parallel_out       => e_signal->new (["write_pointer", $depth]),
            serial_in          => "write_pointer\[($depth-1)\]",
            shift_enable       => "fifo_inc",
            shift_length       => $depth,
            async_value        => "1",
            parallel_in        => "1",
            load               => "flush",
        }),





        e_assign->new({
            lhs => e_signal->new(["next_read_pointer", $depth]),
            rhs => "{read_pointer[($depth-2):0], read_pointer[($depth-1)]}",
        }),

        e_assign->new({
            lhs => e_signal->new(["fifo_becoming_empty", 1]),
            rhs => "
                ((next_read_pointer==write_pointer) 
                    & (fifo_read & ~fifo_write ) )
                | flush", 

        }),

        e_assign->new ({
           lhs => e_signal->new ({name         => "ic_read_prime",
                                  width        => 1,
                                  never_export => 1,            }),
           rhs => "internal_fifo_empty || continue_read_cycle",
        }),
        
        e_register->new ({
           q          => [continue_read_cycle => 1],
           sync_set   => "ic_read_prime",
           sync_reset => "~ic_wait",
           priority   => "reset",
           enable     => "1'b1",
        }),
              
        e_assign->new({
            lhs => "fifo_read_data_bad",

            rhs => "(internal_fifo_empty & ~(fifo_write)) | flush",
        }),

        e_assign->new ({
           lhs => e_signal->new ({name         => "bad_news",
                                  width        => 1,
                                  never_export => 1,          }),
           rhs => "ic_read_prime ^ ic_read",
        }),
    );
  } elsif ($depth>0) { # depth==1
    $this->add_contents( 
        e_assign->new ({
            lhs => e_signal->new({
                name => "write_pointer",
                width => 1, }),
            rhs => "1",
        }),
        e_assign->new ({
            lhs => e_signal->new({
                name => "read_pointer",
                width => 1, }),
            rhs => "1",
        }),






        e_assign->new({
            comment => "set to internal_fifo_empty",
            lhs => "fifo_becoming_empty",
            rhs => "(fifo_read & ~fifo_write) | flush", 
        }),


        e_assign->new({
            lhs => "fifo_read_data_bad",
            rhs => "(internal_fifo_empty & ~fifo_write)",
        }),
    );
  } else {  # depth == 0 
    &ribbit ("Nios 2.0 does not support a non-existant cpu fifo.");
    $this->add_contents( 
        e_assign->new({
            lhs => e_signal->new(["internal_fifo_empty"]),
            rhs => "1'b1",
        }),
        e_assign->new({
            lhs => "fifo_read_data_bad",
            rhs => "~fifo_write",
        }),






        e_register->new ({
           q           => [continue_read_cycle => 1],
           sync_set    => "ic_read",
           sync_reset  => "~ic_wait",
           priority    => "reset",
           enable      => "1'b1",
        }),
        e_assign->new({
            lhs => "fifo_empty",
            rhs => "fifo_read",
        }),
        e_assign->new({
            lhs => "ic_read",
            rhs => "fifo_empty || continue_read_cycle",
        }),
    );
  }


 
  







  
  

  if (0) {  # make the fifo ram based.
    if (($depth | ($depth - 1)) != ($depth * 2 - 1))
    {
        ribbit("fifo depth '$depth' is not an integer power of 2!");
    }
    $this->add_contents(

        e_signal->new({
            name => "wraddress",
            width => $fifo_address_bits,
        }),
        e_process->new({
            asynchronous_contents => [
                e_assign->new({
                    lhs => "wraddress",
                    rhs => 0,
                }),
            ],
            contents => [
                e_if->new({
                    condition => "flush", 
                    then => [
                        e_assign->new({
                            lhs => "wraddress",
                            rhs => "0",
                        }),
                    ],
                    else => [ 
                        e_if->new({
                            condition => "fifo_inc", 
                            then => [
                                e_assign->new({
                                    lhs => "wraddress",
                                    rhs => "wraddress - 1",
                                }),
                            ],
                        }),
                    ], # end of else
                }),
            ], # end of e_process contents
        }),

        e_signal->new({
            name => "rdaddress",
            width => $fifo_address_bits,
        }),
        e_process->new({
            asynchronous_contents => [
                e_assign->new({
                    lhs => "rdaddress",
                    rhs => 0,
                }),
            ],
            contents => [
                e_if->new({
                    condition => "flush",
                    then => [
                        e_assign->new({
                            lhs => "rdaddress",
                            rhs => "0",
                        }),
                    ],
                    else => [
                        e_if->new({
                            condition => "fifo_dec",
                            then => [
                                e_assign->new({
                                    lhs => "rdaddress",
                                    rhs => "rdaddress - 1",
                                }),
                            ],
                        }),
                    ],
                }),
            ],
        }),
        e_ram->new({
            name        => $this->name() . "_fifo_ram", 
            port_map    => {
                wren    => "fifo_write",
                data    => "fifo_wr_data",
                q       => "internal_fifo_rd_data",
                wrclock   => "clk"  ,
                wraddress => "wraddress",
                rdaddress => "rdaddress",
            },
        }),
    );
  } else { # make the fifo be a set of registers
    my @rd_mux_table;
    for (my $i=0; $i<$depth ; $i++) {
        my $select_bit = $i;
        my $reg_name = "fifo_reg_". $i;
        my $reg_write_select = $reg_name . "_write_select" ;
        my $reg_read_select = $reg_name . "_read_select" ;
        $this->add_contents(
            e_register->new({
                q   => e_signal->new({
                    name    => $reg_name, 
                    width   => $this->data_width()}),
                d   => "fifo_wr_data",
                enable  => "$reg_write_select & fifo_write",
            }),
            e_assign->new({
                lhs => e_signal->new([$reg_write_select, 1]),
                rhs => "write_pointer [$select_bit]",
            }),
            e_assign->new({
                lhs => e_signal->new([$reg_read_select, 1]),
                rhs => "read_pointer  [$select_bit]",
            }),
        );
        push (@rd_mux_table, ($reg_read_select  => $reg_name));
    }
    if ($depth>0) {
        $this->add_contents(
            e_mux->new ({
                out   => "internal_fifo_rd_data", 
                table => [ @rd_mux_table ], 
            }),
        );
    } else {
        $this->add_contents(
            e_assign->new({
                lhs => "internal_fifo_rd_data", 
                rhs => "0",
            }),
        );
    }
  }
    



  $this->add_contents(
    e_signal->new({
      name => "internal_fifo_rd_data",
      width => $this->data_width(),
    }),    
    e_assign->new({
      lhs => "fifo_rd_data",
      rhs => "internal_fifo_empty ? fifo_wr_data : internal_fifo_rd_data",
    }),
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

The inherited class e_module

=begin html

<A HREF="e_module.html">e_module</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
