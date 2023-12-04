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

e_mux_reg - description of the module goes here ...

=head1 SYNOPSIS

The e_mux_reg class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_mux_reg;

use e_thing_that_can_go_in_a_module;
@ISA = ("e_thing_that_can_go_in_a_module");
use europa_utils;

use strict;
use e_mux;
use e_register;







my %fields = (optimize => 0,);

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<register()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub register
{
   my $this = shift;
   if (@_)
   {
      $this->{_register} = e_register->new(@_);
   }
   return $this->{_register} || (bless {}, 'e_register');
}



=item I<mux()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub mux
{
   my $this = shift;
   if (@_)
   {
      $this->{_mux} = e_mux->new(@_);
   }
   return $this->{_mux} || (bless {}, 'e_mux');
}



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
   my $this = shift;
   my $parent = $this->parent(shift);

   my $reg = $this->register();
   my $mux = $this->mux();
   $reg->update($this);
   $mux->lhs($reg->d());
   $mux->update($this);

   if ($this->should_optimize())
   {
      $this->tag('simulation');
   }
}



=item I<_update_signal()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _update_signal
{
   my $this = shift;
   return $this->register()->_update_signal(@_);
}



=item I<should_optimize()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub should_optimize
{
   my $this = shift;
   my $mux = $this->mux();
   my $mux_table   = @{$mux->table()} / 2;
   my $mux_default = ($mux->default->expression() eq '')? 0:1;

   my $return = $this->optimize() &&
       (($mux_table + $mux_default) == 3) &&
       ($this->project()->device_family =~ /^STRATIX/i);

   return $return;
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
   my $this = shift;
   if ($this->should_optimize())
   {
      $this->make_mux_reg_instances
          ();
   }
   return $this->mux()->to_verilog(@_).
       $this->register()->to_verilog(@_);
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
   my $this = shift;

   if ($this->should_optimize())
   {
      $this->make_mux_reg_instances
          ();
   }
   return $this->mux()->to_vhdl(@_).
          $this->register()->to_vhdl(@_);

}



=item I<make_mux_reg_instances()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_mux_reg_instances
{
   my $this = shift;

   my $reg = $this->register();
   my $mux = $this->mux();
   my $out = $reg->out();
   my $out_expr = $out->expression();
   my $out_sig_width = $out->width();
   my $complement = 0;
   if ($out_expr =~ s/\(?\~(\w+)\)?/$1/)
   {
      $complement = 1;
   }

   my $tmp_out = $reg->tmp_name_process();
   my @table_expressions = @{$mux->table()};

   my $sel_0 = "|(".shift (@table_expressions)->expression().")";
   my $data_0  = (shift (@table_expressions))->bit_slice
       ($out_sig_width);

   my $sel_1 = 
       "|(".shift (@table_expressions)->expression().")";

   my $data_1 = (shift (@table_expressions))->bit_slice
       ($out_sig_width);

   my $data_2;
   if (@table_expressions)
   {
      shift (@table_expressions);
      $data_2 = (shift (@table_expressions))
          ->bit_slice($out_sig_width);
   }
   else
   {
      $data_2 = $mux->default()->bit_slice($out_sig_width);
   }

   my @instances;

   my $clock = $reg->clock()->expression();
   my $reset = $reg->reset()->expression();
   $reset = &complement($reset)
       if ($reg->reset_level() == 0);

   my $enable = $reg->enable();
   foreach my $index (reverse (0 .. ($out_sig_width - 1)))
   {
      push (@instances,
            e_blind_instance->new({
               tag    => 'compilation',
               module => 'stratix_lcell',
               in_port_map =>
               {
                  clk  => $clock,
                  aclr => $reset,
                  ena  => $enable,

                  sload => $sel_1,
                  dataa => $data_0->[$index],
                  datab => $data_1->[$index],
                  datac => $data_2->[$index],
                  datad => $sel_0,
               },
               out_port_map =>
               {
                  regout => $tmp_out."[$index]",
               },
               parameter_map => {
                  operation_mode        => "normal",
                  synch_mode            => "on",
                  register_cascade_mode => "off",
                  sum_lutc_input        => "datac",
                  lut_mask              => "CCAA",
                  power_up              => "low",
                  cin0_used             => "false",
                  cin1_used             => "false",
                  cin_used              => "false",
                  output_mode           => "comb_only",
               }
            })
            );
   }

   $this->parent_module()->add_contents(@instances);
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

The inherited class e_thing_that_can_go_in_a_module

=begin html

<A HREF="e_thing_that_can_go_in_a_module.html">e_thing_that_can_go_in_a_module</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
