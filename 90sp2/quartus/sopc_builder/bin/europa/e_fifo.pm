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

e_fifo - description of the module goes here ...

=head1 SYNOPSIS

The e_fifo class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_fifo;

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
  fifo_depth       => 1,
  implement_as_esb => 1,













  
  flush        => "",
  full_port    => 1,
  empty_port   => 1,
  p1_full_port => 0,
  p1_empty_port => 0,
  Read_Latency => 1,
  device_family => '',
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
  my $fifo_address_bits = log2($depth);
  

  if (not is_power_of_two($depth))
  {
    ribbit("fifo depth '$depth' is not an integer power of 2!");
  }



  $this->add_contents(
    e_signal->new({
      name => "fifo_rd_data",
      width => $this->data_width(),
      export => 1,
    }),
  );


  $this->add_contents(
    e_port->new(["clk"]),
    e_port->new(["reset_n"]),
    e_port->new(["fifo_write"]),
    e_port->new(["fifo_read"]),
    e_port->new(["inc_pending_data"]),
    e_port->new(["fifo_wr_data",  $this->data_width()]),
    e_port->new(["fifo_rd_data",  $this->data_width(), "output"]),
    e_port->new(["fifo_datavalid", 1, 'output',]),
  );
  
  $this->add_contents(e_port->new(["fifo_full", 1, "output"]))
    if ($this->full_port());
  $this->add_contents(e_port->new(["fifo_empty", 1, "output"]))
    if ($this->empty_port());
  $this->add_contents(e_port->new(["p1_fifo_full", 1, "output"]))
    if ($this->p1_full_port());
  $this->add_contents(e_port->new(["p1_fifo_empty", 1, "output"]))
    if ($this->p1_empty_port());
  

  if ($fifo_address_bits)
  {
    $this->add_contents(
      e_signal->new({
        name => "rdaddress",
        width => $fifo_address_bits,
      }),
      e_signal->new({
        name => "wraddress",
        width => $fifo_address_bits,
      }),
    );


    $this->add_contents(
      e_mux->new({
        lhs => e_signal->new({
          name => "p1_wraddress",
          width => $fifo_address_bits,
          never_export => 1,
        }),
        table => [
          "fifo_write", "wraddress - 1",
        ],
        default => "wraddress",
      }),
      e_register->new({
        async_value => 0,
        in => "p1_wraddress",
        out => "wraddress",
        sync_reset => ($this->flush() or "0"),
      }),
    );


    $this->add_contents(
      e_assign->new({
        lhs => 'rdaddress',
        rhs =>
          "flush_fifo ? 0 : fifo_read ? (rdaddress_reg - 1) : rdaddress_reg",
      }),
      e_register->new({
        async_value => 0,
        enable => '1',
        in => "rdaddress",
        out => "rdaddress_reg",
      }),
    );
  }



  $this->add_contents(
    e_assign->new({
      lhs => 'fifo_datavalid',
      rhs => '~fifo_empty',
    }),
  );


 


  $this->add_contents(
    e_assign->new({
      lhs => e_signal->new(["fifo_inc"]),
      rhs => "fifo_write & ~fifo_read"
    }),
    e_assign->new({
      lhs => e_signal->new(["fifo_dec"]),
      rhs => "fifo_read & ~fifo_write"
    }),
  );

  if ($fifo_address_bits)
  {
    $this->add_contents(
      e_assign->new({
        lhs => e_signal->new(["estimated_rdaddress", $fifo_address_bits]),
        rhs => "rdaddress_reg - 1",
      }),
    );
  








    $this->add_contents(
      e_mux->new({
        lhs => e_signal->new({
          name => "p1_estimated_wraddress",
          width => $fifo_address_bits,
          never_export => 1,
        }),
        table => [
          "inc_pending_data", "estimated_wraddress - 1",
        ],
        default => "estimated_wraddress",
      }),
      e_register->new({
        async_value => "{$fifo_address_bits {1'b1}}",
        in => "p1_estimated_wraddress",
        out => "estimated_wraddress",
        sync_set => ($this->flush() or "0"),
        set_value => "{$fifo_address_bits {1'b1}}",
      }),
    );
  }

  my $fifo_just_emptied =
    $fifo_address_bits ?
    "(fifo_dec & (wraddress == estimated_rdaddress))" :
    "fifo_dec";
  my $fifo_just_filled = 
    $fifo_address_bits ?
    "(inc_pending_data & (estimated_wraddress == rdaddress))" :
    "inc_pending_data";
    
  $this->add_contents(
    e_assign->new({
      lhs => "p1_fifo_empty",
      rhs => "@{[$this->flush()]}  | " .
        "((~fifo_inc & fifo_empty) | " .
        "$fifo_just_emptied)",
    }),
    e_register->new({
      async_value => 1,
      in => "p1_fifo_empty",
      out => "fifo_empty",
    }),
    e_assign->new({
      lhs => "p1_fifo_full",
      rhs => "~@{[$this->flush()]} & " .
        "((~fifo_dec & fifo_full)  | " .
        "$fifo_just_filled)",
    }),
    e_register->new({
      async_value => 0,
      in => "p1_fifo_full",
      out => "fifo_full",
    }),
    e_signal->new({
      name => 'fifo_ram_q',
      width => $this->data_width(),
    }),
  );

  if ($fifo_address_bits)
  { 





    





    my $needs_passthrough =
      not grep {$_ eq $this->device_family()}
      (qw(
        APEXII
        APEX20K
        APEX20KE
        APEX20KC
        EXCALIBUR_ARM
        EXCALIBUR_MIPS
        MERCURY
        ACEX1K
        FLEX10K
        FLEX10KA
        FLEX10KB
        FLEX10KE
      ));
    
    my $fifo_ram;

    $fifo_ram = 
      e_ram->new({
        name => $this->name() . "_fifo_ram", 
        Read_Latency => $this->Read_Latency(),
        implement_as_esb => $this->implement_as_esb(),
        port_map =>
        {
          wren => "fifo_write",
          data => "fifo_wr_data",
          q    => "fifo_ram_q",
          wrclock   => "clk"  ,
          wraddress => "wraddress",
          rdaddress => "rdaddress",
        },
      });









    if ($needs_passthrough)
    {
      $this->add_contents(
        e_assign->new(['write_collision', 'fifo_write && (wraddress == rdaddress)'])
      );


      $this->add_contents(
        e_register->new({
          out => ['last_write_data', $this->data_width(),],
          in => "fifo_wr_data",
          enable => 'write_collision',
          clock => "clk",
          async_value => 0,
        }),







        e_register->new({
          out => ['last_write_collision', 1,],
          enable => "1",
          clock => "clk",
          async_value => 0,
          sync_set => 'write_collision',
          sync_reset => 'fifo_read',
          priority => 'set',
        }),
        e_assign->new(['fifo_rd_data', 'last_write_collision ? last_write_data : fifo_ram_q',]),
      );
    }
    else
    {


      $this->add_contents(
        e_assign->new(['fifo_rd_data', 'fifo_ram_q',]),
      );
    }
    $this->add_contents($fifo_ram);
  }
  else
  {

    my $fifo_reg = 
      e_register->new({
        out => "fifo_rd_data",
        in => "fifo_wr_data",
        enable => "fifo_write",
        clock => "clk",
        async_value => 0,
      });
    $this->add_contents($fifo_reg);
  }
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
