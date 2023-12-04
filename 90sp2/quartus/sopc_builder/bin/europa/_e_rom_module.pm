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

_e_rom_module - description of the module goes here ...

=head1 SYNOPSIS

The _e_rom_module class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package _e_rom_module;

use e_module;
use e_port;
use e_parameter;
use europa_utils;
@ISA = ("e_module");
use strict;

my %fields = (
              name => "lpm_rom",
              contents => 
              [
               e_port->news
               ([address => 1,  "in"],
                [q       => 1, "out"]
                ), 
               e_parameter->news
               (
                [lpm_width           => 1 , "natural"],
                [lpm_widthad         => 1 , "natural"],
                [lpm_address_control => " ", "string" ],
                [lpm_address_outdata => " ", "string" ],
                [lpm_file            => " ", "string" ],
                )
               ]
              );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
  my $this = shift;

  return if ($this->_hdl_generated());
  my $indent = "  ";

  $this->final_update();
  my $translate_off_string = $this->_project()->_translate_off . "\n";
  my $translate_on_string  = $this->_project()->_translate_on  . "\n";

  my $vs .= qq[

module lpm_rom (
                 q,
                 address
               );

   parameter lpm_file = " ";
   parameter lpm_width = 1;
   parameter lpm_widthad = 1;
   parameter lpm_address_control = " ";
   parameter lpm_address_outdata = " ";
 
 
   output  [ (lpm_width - 1) : 0] q;
   input   [ (lpm_widthad - 1) : 0] address;

/* synthesis translate_off */
// $translate_off_string

   reg [lpm_width - 1 : 0] mem_array [(1 << lpm_widthad) - 1 : 0];
   reg [lpm_width - 1 : 0] q;

   initial
     \$readmemb (lpm_file, mem_array);

   always @(address)
     q <= mem_array[address];

// $translate_on_string
/* synthesis translate_on */
endmodule   
           ];

    push (@{$this->_project()->module_pool()->{verilog}},$vs);
   $this->_hdl_generated(1);

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
