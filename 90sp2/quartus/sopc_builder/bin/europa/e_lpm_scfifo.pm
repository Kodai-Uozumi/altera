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

e_lpm_scfifo - description of the module goes here ...

=head1 SYNOPSIS

The e_lpm_scfifo class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_lpm_scfifo;
use e_lpm_base;
@ISA = ("e_lpm_base");

use strict;
use europa_utils;





=item I<vhdl_declare_component()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_declare_component
{
return q[
COMPONENT scfifo
   GENERIC (LPM_WIDTH: POSITIVE;
      lpm_widthu: POSITIVE;
      lpm_numwords: POSITIVE;
      lpm_showahead: STRING := "OFF";
      almost_full_value: POSITIVE:= 0;
      almost_empty_value: POSITIVE:= 0;
      allow_rwcycle_when_full: STRING := "OFF";
      maximize_speed: POSITIVE:= 5;
      overflow_checking: STRING:= "ON";
      underflow_checking: STRING:= "ON");
   PORT (data: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      clock, wrreq, rdreq, aclr, sclr: IN STD_LOGIC;
      full, empty, almost_full, almost_empty: OUT STD_LOGIC;
      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
      usedw: OUT STD_LOGIC_VECTOR(LPM_WIDTHU-1 DOWNTO 0));
END COMPONENT;
         ];
}



=item I<set_port_map_defaults()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub set_port_map_defaults
{


   my $this = shift;
   $this->port_map
       (clock => 'clk',
        sclr  => 'open',
        almost_full  => 'open',
        almost_empty => 'open',
        aclr  => '~reset_n',
        usedw => 'open');
}



=item I<set_parameter_map_defaults()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub set_parameter_map_defaults
{

   my $this = shift;
   $this->parameter_map({overflow_checking  => "OFF",
                         underflow_checking => "OFF",
                      });
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

The inherited class e_lpm_base

=begin html

<A HREF="e_lpm_base.html">e_lpm_base</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
