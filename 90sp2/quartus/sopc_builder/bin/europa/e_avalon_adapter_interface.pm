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

e_avalon_adapter_interface 


=head1 SYNOPSIS

This package contains subroutines needed by both e_avalon_adapter_master and
e_avalon_adapter_slave.  These routines could equavalently be placed in 
e_avalon_slave, but since the routines are very adapter-centric, it makes
more sense to put them in their own package and have the adapter interface
objects do multiple inheritance.

=head1 METHODS

=over 4

=cut

package e_avalon_adapter_interface;

use e_thing_that_can_go_in_a_module;
use e_module;
use e_signal;
use e_project;
@ISA = ("e_thing_that_can_go_in_a_module");
use europa_utils;
use strict;

my %fields = (



  module => undef,
);

my %pointers = (
);

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );

=item I<non_adapter_types()>

Here's a list of types that adapters don't need
to handle.
These ones are special because they are not simply
outputs from a (slave, master) and input to the (master, slave).
 

=cut

=item I<add_to_type_map()>

Call this function to build up the type map "on-the-fly",
that is, as the owning object requests ports and signals by type.

=cut

sub add_to_type_map($$$)
{
  my $this = shift;
  my $type = shift;
  my $signal = shift;

  $this->parent_module()->get_and_set_once_by_name({
    thing => 'signal',
    name => $signal,
    width => $this->get_port_width_by_type($type),
  });
  $this->type_map()->{$signal} = $type;
}


=item I<get_port_by_type()>

Make an assignment to the signal type which this interface provides
to its owner.

=cut

sub get_port_by_type($$)
{
  my $this = shift;
  my $type = shift;

  my $signal = $this->get_signal_by_type($type);
  $this->add_to_type_map($type, $signal);
  
  return $signal;
}

=item I<get_port_width_by_type()>

Return widths of interface port signals.

=cut

sub get_port_width_by_type($$)
{
  my $this = shift;
  my $type = shift;
  
  my $width = 1;
  
  if ($type =~ /data(_n)?$/)
  {
    $width = $this->SBI_section()->{Data_Width};
  }
  elsif ($type =~ /byteenable(_n)?/)
  {
    $width =
      round_up_to_next_computer_acceptable_bit_width(
        $this->SBI_section()->{Data_Width}
      ) / 8;
  }
  elsif ($type =~ /^address(_n)?$/)
  {
    $width = $this->SBI_section()->{Address_Width};
  }
  elsif ($type =~ /^nativeaddress$/)
  {
    $width = $this->SBI_section()->{Address_Width};

    $width -= log2(
      round_up_to_next_computer_acceptable_bit_width(
        $this->SBI_section()->{Data_Width}
      ) / 8);
  }
  elsif ($type =~ /^byteaddress(_n)?$/)
  {
    if ($this->section_name() eq 'SLAVE')
    {
      $width = $this->SBI_section()->{Address_Width};

      $width += log2(
        round_up_to_next_computer_acceptable_bit_width(
          $this->SBI_section()->{Data_Width}
        ) / 8);
    }
    else
    {

      $width = $this->SBI_section()->{Address_Width};
    }
  }
  elsif ($type =~ /^burstcount(_n)?$/)
  {
    $width = &Bits_To_Encode($this->SBI_section()->{Maximum_Burst_Size});





    $width = 1 if !$width;
  }
  
  return $width;
}

=item I<get_signal_by_type()>

Return the name of the signal which represents a particular
Avalon type to the export side of the interface.

=cut

sub get_signal_by_type($$)
{
  my $this = shift;
  my $type = shift;




  
  my $signal = $this->name() . "_$type";

  $this->add_to_type_map($type, $signal);

  return $signal;
}
 
sub max_pending_reads
{
  my $this = shift;

  my $mpr = $this->SBI_section()->{Maximum_Pending_Read_Transactions};
  return $mpr;
}


1;
