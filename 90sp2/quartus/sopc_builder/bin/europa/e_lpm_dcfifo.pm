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

e_lpm_dcfifo - description of the module goes here ...

=head1 SYNOPSIS

The e_lpm_dcfifo class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_lpm_dcfifo;
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
COMPONENT dcfifo
   GENERIC
      (lpm_width                 :  POSITIVE;
      lpm_widthu                 :  POSITIVE;
      lpm_numwords               :  POSITIVE;
      lpm_showahead              :  STRING     := "OFF";
      lpm_hint                   :  STRING     := "USE_EAB=ON";
      overflow_checking          :  STRING     := "ON";
      underflow_checking         :  STRING     := "ON";
      delay_rdusedw              :  POSITIVE   := 1;
      delay_wrusedw              :  POSITIVE   := 1;
      rdsync_delaypipe           :  POSITIVE   := 3;
      wrsync_delaypipe           :  POSITIVE   := 3;
      use_eab                    :  STRING     := "ON";
      clocks_are_synchronized    :  STRING     := "FALSE";
      add_ram_output_register    :  STRING     := "OFF";
      lpm_type                   :  STRING     := "DCFIFO";
      intended_device_family     :  STRING     := "NON_STRATIX");

   PORT (data                               :  IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
        rdclk, wrclk, wrreq, rdreq, aclr    :  IN STD_LOGIC;
        rdfull,wrfull, wrempty, rdempty     :  OUT STD_LOGIC;
        q                                   :  OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
        rdusedw, wrusedw                    :  OUT STD_LOGIC_VECTOR(LPM_WIDTHU-1 DOWNTO 0));
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
   $this->port_map({wrempty => 'open', rdfull => 'open'});
}



=item I<set_parameter_map_defaults()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub set_parameter_map_defaults
{

   my $this = shift;

}



=item I<set_autoparameters()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub set_autoparameters
{
   my $this = shift;
   my $return = $this->SUPER::set_autoparameters(@_);

   my $device = $this->parent_module()->project()->device_family();
   my $Device = $device;
   $Device =~ s/^(\w)(.*)$/$1.lc($2)/e;
   $this->parameter_map({intended_device_family => $Device});
   return $return;
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
