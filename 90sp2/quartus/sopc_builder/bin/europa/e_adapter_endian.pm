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
package e_adapter_endian;

use europa_utils;
use e_avalon_adapter_interface;
use e_avalon_adapter_master;
use e_avalon_adapter_slave;

@ISA = ("e_adapter");
use strict;

my %fields = (
);

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );

sub make_special_assignments($)
{
  my $this = shift;
  my ($upstream) = $this->get_upstream_interfaces();
  my ($downstream) = $this->get_downstream_interfaces();

  my $us_readdata = $upstream->get_signal_by_type('readdata');
  my $us_writedata = $upstream->get_signal_by_type('writedata');
  my $us_byteenable = $upstream->get_signal_by_type('byteenable');
  
  my $ds_readdata = $downstream->get_signal_by_type('readdata');
  my $ds_writedata = $downstream->get_signal_by_type('writedata');
  my $ds_byteenable = $downstream->get_signal_by_type('byteenable');

  my $rd_width = $upstream->get_port_width_by_type('readdata');
  my $wd_width = $downstream->get_port_width_by_type('writedata');
  my $be_width = $upstream->get_port_width_by_type('byteenable');

  my $number_of_bytes = ceil($rd_width / 8);
  my @us_readdata_lanes;
  foreach my $byte_lane (0..$number_of_bytes - 1)
  {
    my $start = $byte_lane * 8;
    my $end = $start + 7;
    my $tmp_rhs = "${us_readdata}_${end}_to_$start";
    e_assign->new(["$us_readdata [$end:$start]", [$tmp_rhs,8]])
	->within($this);
    push(@us_readdata_lanes, $tmp_rhs);
  }
  e_assign->new(
        [concatenate(@us_readdata_lanes),
        $ds_readdata]
  )->within($this);

  my @us_writedata_lanes;
  $number_of_bytes = ceil($wd_width / 8);
  foreach my $byte_lane (0..$number_of_bytes - 1)
  {
    my $start = $byte_lane * 8;
    my $end = $start + 7;
    push(@us_writedata_lanes, "$us_writedata [$end:$start]");
  }
  e_assign->new(
        [$ds_writedata,
        concatenate(@us_writedata_lanes)]
  )->within($this);

  my @be_bits;
  foreach my $be_bit (0..$be_width - 1)
  {
    push(@be_bits, "$us_byteenable [$be_bit]");
  }
  e_assign->new([$ds_byteenable, 
                concatenate(@be_bits)]
  )->within($this);
}

return (1);
