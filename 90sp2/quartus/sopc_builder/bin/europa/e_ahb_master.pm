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































package e_ahb_master;
use europa_utils;
use e_ahb_slave;
use europa_utils;

@ISA = ("e_ahb_slave");
use strict;

my %fields   = (
                master_number_hash  => {},
                section_name     => "MASTER"
                );
my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );
















sub _get_master_number
{
  my $this  = shift;
  my $master_desc = shift or &ribbit ("No master desc"); 
  my $slave_id = shift or &ribbit ("No slave id"); 
  my $master_number = shift;

  my %master_number_hash;

  if ($master_number) { # make master number
    $master_number_hash{$slave_id} = $master_number;
print "slave $slave_id gave $master_desc number $master_number\n";
  } else { # find master number
    %master_number_hash = $this->master_number_hash();
    $master_number = $master_number_hash{$slave_id};  
print "slave $slave_id requests $master_desc number $master_number\n";
  }
  return $master_number;
}

sub recognized_types
{
  my $this = shift;


  my @known_sigs = $this->SUPER::recognized_types();
  push (@known_sigs, 
    qw (
        hgrant
        hbusreq
        hlock
        hprot
        hready
    )
  );

  return @known_sigs;
}


1;




