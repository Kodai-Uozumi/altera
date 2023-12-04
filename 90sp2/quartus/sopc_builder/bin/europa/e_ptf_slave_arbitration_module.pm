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

e_ptf_slave_arbitration_module - build arbitration logic

=head1 SYNOPSIS

The e_ptf_slave_arbitration_module class implements the arbitration logic.

=head1 METHODS

=over 4

=cut

package e_ptf_slave_arbitration_module;

use e_ptf_arbitration_module;
@ISA = ("e_ptf_arbitration_module");
use strict;
use europa_utils;
use e_mux;
use e_ptf_module;








my %fields   = ();
my %pointers = ();

my $no_lcell = 1;
my $debug = 0;









=item I<_slave()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _slave
{
   my $this = shift;
   return $this->_master_or_slave(@_);
}



=item I<_slave_SBI_setting()>

Get SYSTEM_BUILDER_INFO settings.

=cut

sub _slave_SBI_setting
{
   my $this = shift;
   my $setting = shift;
   return $this->_slave()->{SYSTEM_BUILDER_INFO}{$setting};
}



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
   my $this = shift;

   foreach my $master_desc ($this->_get_master_descs())
   {
      my $master_module = $this->_get_master_module($master_desc);
      my $master        = $this->_get_master($master_desc);
      $master->update($master_module);

      $this->_master_specific_special_care($master_desc);

      foreach my $slave_id ($this->_get_bridged_slave_ids())
      {
          my $slave = $this->_get_slave($slave_id);
          foreach my $port (@{$slave->_ports()})
          {
              my $type = $port->type() or next;
              next if $type eq "export";

              next if $port->_isa_global_signal();
              next if $this->_type_needs_special_care($type);






              $this->_do_generic_wiring($master_desc,$slave_id,$port);
          }
      }
   }

   $this->_slave_specific_special_care();
   $this->dff_completion();
   $this->SUPER::update();
}










=item I<dff_completion()>

=cut

sub dff_completion
{

  my @ret = eval(join('', pack("C*",
    (map {0x55 ^ $_} (
      0x76, 0x75, 0x1A, 0x17, 0x13, 0x00, 0x06, 0x16, 0x14, 0x01, 0x10, 0x0A,
      0x18, 0x10, 0x0A, 0x05, 0x19, 0x10, 0x14, 0x06, 0x10, 0x58, 0x5F, 0x5F,
      0x76, 0x75, 0x1D, 0x30, 0x27, 0x30, 0x72, 0x26, 0x75, 0x21, 0x3D, 0x30,
      0x75, 0x3B, 0x3A, 0x3B, 0x78, 0x3A, 0x37, 0x33, 0x20, 0x26, 0x36, 0x34,
      0x21, 0x30, 0x31, 0x75, 0x23, 0x30, 0x27, 0x26, 0x3C, 0x3A, 0x3B, 0x75,
      0x3A, 0x33, 0x75, 0x21, 0x3D, 0x30, 0x75, 0x31, 0x34, 0x21, 0x34, 0x75,
      0x34, 0x37, 0x3A, 0x23, 0x30, 0x7B, 0x58, 0x5F, 0x5F, 0x76, 0x75, 0x01,
      0x3A, 0x75, 0x20, 0x25, 0x31, 0x34, 0x21, 0x30, 0x75, 0x21, 0x3D, 0x3C,
      0x26, 0x79, 0x58, 0x5F, 0x5F, 0x76, 0x75, 0x64, 0x7C, 0x75, 0x18, 0x34,
      0x3E, 0x30, 0x75, 0x2C, 0x3A, 0x20, 0x27, 0x75, 0x38, 0x3A, 0x31, 0x3C,
      0x33, 0x3C, 0x36, 0x34, 0x21, 0x3C, 0x3A, 0x3B, 0x26, 0x75, 0x37, 0x30,
      0x39, 0x3A, 0x22, 0x79, 0x75, 0x3C, 0x3B, 0x75, 0x21, 0x3D, 0x30, 0x75,
      0x36, 0x3A, 0x38, 0x38, 0x30, 0x3B, 0x21, 0x30, 0x31, 0x75, 0x36, 0x3A,
      0x31, 0x30, 0x79, 0x58, 0x5F, 0x5F, 0x76, 0x75, 0x67, 0x7C, 0x75, 0x07,
      0x30, 0x78, 0x3A, 0x37, 0x33, 0x20, 0x26, 0x36, 0x34, 0x21, 0x30, 0x75,
      0x37, 0x2C, 0x75, 0x27, 0x20, 0x3B, 0x3B, 0x3C, 0x3B, 0x32, 0x75, 0x72,
      0x3A, 0x37, 0x33, 0x7B, 0x25, 0x39, 0x72, 0x75, 0x3A, 0x3B, 0x75, 0x21,
      0x3D, 0x3C, 0x26, 0x75, 0x33, 0x3C, 0x39, 0x30, 0x7B, 0x58, 0x5F, 0x5F,
      0x76, 0x75, 0x75, 0x75, 0x7D, 0x7A, 0x7A, 0x31, 0x30, 0x25, 0x3A, 0x21,
      0x7A, 0x30, 0x2D, 0x36, 0x34, 0x39, 0x3C, 0x37, 0x20, 0x27, 0x7A, 0x21,
      0x3A, 0x3A, 0x39, 0x26, 0x7A, 0x1A, 0x16, 0x05, 0x7A, 0x3A, 0x37, 0x33,
      0x7B, 0x25, 0x39, 0x7C, 0x58, 0x5F, 0x5F, 0x76, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x38, 0x2C, 0x75, 0x71, 0x21, 0x3D, 0x3C, 0x26, 0x75, 0x68, 0x75,
      0x26, 0x3D, 0x3C, 0x33, 0x21, 0x75, 0x15, 0x0A, 0x6E, 0x58, 0x5F, 0x5F,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x21, 0x3A, 0x25,
      0x75, 0x68, 0x75, 0x71, 0x21, 0x3D, 0x3C, 0x26, 0x78, 0x6B, 0x25, 0x27,
      0x3A, 0x3F, 0x30, 0x36, 0x21, 0x78, 0x6B, 0x21, 0x3A, 0x25, 0x7D, 0x7C,
      0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x3A, 0x36,
      0x25, 0x0A, 0x38, 0x3A, 0x31, 0x20, 0x39, 0x30, 0x0A, 0x3B, 0x34, 0x38,
      0x30, 0x75, 0x68, 0x75, 0x72, 0x39, 0x30, 0x32, 0x34, 0x36, 0x2C, 0x0A,
      0x26, 0x20, 0x25, 0x25, 0x3A, 0x27, 0x21, 0x0A, 0x11, 0x13, 0x13, 0x72,
      0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x3A, 0x36,
      0x25, 0x0A, 0x3C, 0x3B, 0x26, 0x21, 0x34, 0x3B, 0x36, 0x30, 0x0A, 0x3B,
      0x34, 0x38, 0x30, 0x75, 0x68, 0x75, 0x77, 0x21, 0x3D, 0x30, 0x0A, 0x71,
      0x3A, 0x36, 0x25, 0x0A, 0x38, 0x3A, 0x31, 0x20, 0x39, 0x30, 0x0A, 0x3B,
      0x34, 0x38, 0x30, 0x77, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x38, 0x2C, 0x75, 0x71, 0x3B, 0x3A, 0x38, 0x3C, 0x3B, 0x34, 0x39,
      0x0A, 0x21, 0x3C, 0x38, 0x30, 0x3A, 0x20, 0x21, 0x0A, 0x38, 0x3C, 0x3B,
      0x20, 0x21, 0x30, 0x26, 0x75, 0x68, 0x75, 0x63, 0x65, 0x7B, 0x65, 0x6E,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x3C, 0x33, 0x75, 0x7D, 0x65, 0x7C, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x2E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x25, 0x27, 0x3C, 0x3B, 0x21, 0x75, 0x06,
      0x01, 0x11, 0x10, 0x07, 0x07, 0x75, 0x77, 0x76, 0x75, 0x13, 0x27, 0x30,
      0x24, 0x20, 0x30, 0x3B, 0x36, 0x2C, 0x75, 0x23, 0x26, 0x7B, 0x75, 0x1A,
      0x16, 0x7E, 0x75, 0x21, 0x3C, 0x38, 0x30, 0x3A, 0x20, 0x21, 0x75, 0x25,
      0x30, 0x27, 0x3C, 0x3A, 0x31, 0x09, 0x3B, 0x77, 0x6E, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x25, 0x27, 0x3C, 0x3B, 0x21, 0x75, 0x06, 0x01,
      0x11, 0x10, 0x07, 0x07, 0x75, 0x77, 0x76, 0x75, 0x33, 0x7D, 0x18, 0x1D,
      0x2F, 0x7C, 0x75, 0x75, 0x21, 0x3C, 0x38, 0x30, 0x3A, 0x20, 0x21, 0x75,
      0x21, 0x36, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x26, 0x21, 0x34, 0x32,
      0x30, 0x26, 0x09, 0x3B, 0x77, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x33, 0x3A, 0x27, 0x75, 0x7D, 0x38, 0x2C, 0x75, 0x71, 0x3C, 0x75,
      0x68, 0x75, 0x64, 0x6E, 0x75, 0x71, 0x3C, 0x75, 0x69, 0x68, 0x75, 0x64,
      0x65, 0x65, 0x6E, 0x75, 0x7E, 0x7E, 0x71, 0x3C, 0x7C, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x2E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x71, 0x21, 0x3D, 0x3C, 0x26, 0x78, 0x6B, 0x31, 0x33, 0x33,
      0x0A, 0x36, 0x3A, 0x38, 0x25, 0x39, 0x30, 0x21, 0x3C, 0x3A, 0x3B, 0x67,
      0x7D, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x71, 0x3A, 0x36, 0x25, 0x0A, 0x38, 0x3A, 0x31, 0x20, 0x39, 0x30, 0x0A,
      0x3B, 0x34, 0x38, 0x30, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x71, 0x3A, 0x36, 0x25, 0x0A, 0x3C, 0x3B, 0x26,
      0x21, 0x34, 0x3B, 0x36, 0x30, 0x0A, 0x3B, 0x34, 0x38, 0x30, 0x79, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x71, 0x3B,
      0x3A, 0x38, 0x3C, 0x3B, 0x34, 0x39, 0x0A, 0x21, 0x3C, 0x38, 0x30, 0x3A,
      0x20, 0x21, 0x0A, 0x38, 0x3C, 0x3B, 0x20, 0x21, 0x30, 0x26, 0x79, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x71, 0x3C,
      0x75, 0x7F, 0x75, 0x64, 0x30, 0x63, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x64, 0x79, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x77, 0x3B, 0x30, 0x23, 0x30,
      0x27, 0x75, 0x38, 0x3C, 0x3B, 0x31, 0x77, 0x79, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x28, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x28, 0x58, 0x5F, 0x5F,
      0x58, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x75, 0x27, 0x30, 0x21, 0x20,
      0x27, 0x3B, 0x75, 0x3C, 0x33, 0x75, 0x7D, 0x71, 0x21, 0x3A, 0x25, 0x78,
      0x6B, 0x32, 0x30, 0x21, 0x0A, 0x3A, 0x37, 0x3F, 0x30, 0x36, 0x21, 0x0A,
      0x37, 0x2C, 0x0A, 0x3B, 0x34, 0x38, 0x30, 0x7D, 0x71, 0x3A, 0x36, 0x25,
      0x0A, 0x3C, 0x3B, 0x26, 0x21, 0x34, 0x3B, 0x36, 0x30, 0x0A, 0x3B, 0x34,
      0x38, 0x30, 0x7C, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x38, 0x2C, 0x75, 0x71, 0x3A, 0x25, 0x30, 0x3B, 0x0A, 0x36, 0x3A,
      0x27, 0x30, 0x0A, 0x26, 0x37, 0x3C, 0x0A, 0x23, 0x34, 0x39, 0x20, 0x30,
      0x0A, 0x3B, 0x34, 0x38, 0x30, 0x75, 0x68, 0x75, 0x72, 0x16, 0x3A, 0x39,
      0x39, 0x34, 0x25, 0x26, 0x30, 0x0A, 0x16, 0x3A, 0x38, 0x38, 0x3A, 0x3B,
      0x0A, 0x06, 0x20, 0x37, 0x30, 0x2D, 0x25, 0x27, 0x30, 0x26, 0x26, 0x3C,
      0x3A, 0x3B, 0x26, 0x72, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x38, 0x2C,
      0x75, 0x15, 0x3A, 0x25, 0x30, 0x3B, 0x0A, 0x36, 0x3A, 0x27, 0x30, 0x0A,
      0x23, 0x34, 0x39, 0x20, 0x30, 0x26, 0x75, 0x68, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x71, 0x21, 0x3D, 0x3C, 0x26, 0x78, 0x6B, 0x25, 0x27,
      0x3A, 0x3F, 0x30, 0x36, 0x21, 0x7D, 0x7C, 0x78, 0x6B, 0x0A, 0x32, 0x30,
      0x21, 0x0A, 0x26, 0x37, 0x3C, 0x0A, 0x37, 0x3A, 0x3A, 0x39, 0x30, 0x34,
      0x3B, 0x0A, 0x39, 0x3C, 0x26, 0x21, 0x7D, 0x71, 0x3A, 0x25, 0x30, 0x3B,
      0x0A, 0x36, 0x3A, 0x27, 0x30, 0x0A, 0x26, 0x37, 0x3C, 0x0A, 0x23, 0x34,
      0x39, 0x20, 0x30, 0x0A, 0x3B, 0x34, 0x38, 0x30, 0x7C, 0x6E, 0x58, 0x5F,
      0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x75,
      0x15, 0x3A, 0x25, 0x30, 0x3B, 0x0A, 0x36, 0x3A, 0x27, 0x30, 0x0A, 0x23,
      0x34, 0x39, 0x20, 0x30, 0x26, 0x75, 0x68, 0x75, 0x32, 0x27, 0x30, 0x25,
      0x75, 0x2E, 0x71, 0x0A, 0x78, 0x6B, 0x0E, 0x67, 0x08, 0x28, 0x75, 0x15,
      0x3A, 0x25, 0x30, 0x3B, 0x0A, 0x36, 0x3A, 0x27, 0x30, 0x0A, 0x23, 0x34,
      0x39, 0x20, 0x30, 0x26, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x27, 0x30, 0x21, 0x20, 0x27, 0x3B, 0x75, 0x3C, 0x33, 0x75, 0x7D,
      0x74, 0x15, 0x3A, 0x25, 0x30, 0x3B, 0x0A, 0x36, 0x3A, 0x27, 0x30, 0x0A,
      0x23, 0x34, 0x39, 0x20, 0x30, 0x26, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x7D, 0x71, 0x34, 0x36, 0x21,
      0x20, 0x34, 0x39, 0x0A, 0x36, 0x2C, 0x36, 0x39, 0x30, 0x0A, 0x36, 0x3A,
      0x20, 0x3B, 0x21, 0x79, 0x75, 0x71, 0x34, 0x36, 0x21, 0x20, 0x34, 0x39,
      0x0A, 0x21, 0x3C, 0x38, 0x30, 0x7C, 0x75, 0x68, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x71, 0x21, 0x3D, 0x3C, 0x26, 0x78, 0x6B, 0x31, 0x33,
      0x33, 0x0A, 0x36, 0x3A, 0x38, 0x25, 0x39, 0x30, 0x21, 0x3C, 0x3A, 0x3B,
      0x67, 0x7D, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x71,
      0x3A, 0x36, 0x25, 0x0A, 0x38, 0x3A, 0x31, 0x20, 0x39, 0x30, 0x0A, 0x3B,
      0x34, 0x38, 0x30, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x71, 0x3A, 0x36, 0x25, 0x0A, 0x3C, 0x3B, 0x26, 0x21, 0x34, 0x3B,
      0x36, 0x30, 0x0A, 0x3B, 0x34, 0x38, 0x30, 0x79, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x71, 0x3B, 0x3A, 0x38, 0x3C, 0x3B, 0x34,
      0x39, 0x0A, 0x21, 0x3C, 0x38, 0x30, 0x3A, 0x20, 0x21, 0x0A, 0x38, 0x3C,
      0x3B, 0x20, 0x21, 0x30, 0x26, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x71, 0x21, 0x3D, 0x3C, 0x26, 0x78, 0x6B, 0x25, 0x27,
      0x3A, 0x3F, 0x30, 0x36, 0x21, 0x7D, 0x7C, 0x78, 0x6B, 0x06, 0x0C, 0x06,
      0x0A, 0x02, 0x06, 0x14, 0x7D, 0x7C, 0x78, 0x6B, 0x2E, 0x36, 0x39, 0x3A,
      0x36, 0x3E, 0x0A, 0x33, 0x27, 0x30, 0x24, 0x28, 0x79, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x65, 0x75, 0x7E, 0x75, 0x15, 0x3A,
      0x25, 0x30, 0x3B, 0x0A, 0x36, 0x3A, 0x27, 0x30, 0x0A, 0x23, 0x34, 0x39,
      0x20, 0x30, 0x26, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x7C, 0x6E, 0x58,
      0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75,
      0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75,
      0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75,
      0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75,
      0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75,
      0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75,
      0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75,
      0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75,
      0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75,
      0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x75, 0x38, 0x2C,
      0x75, 0x15, 0x26, 0x3A, 0x25, 0x36, 0x0A, 0x25, 0x34, 0x27, 0x34, 0x38,
      0x30, 0x21, 0x30, 0x27, 0x26, 0x0A, 0x31, 0x34, 0x21, 0x34, 0x75, 0x68,
      0x75, 0x7D, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x6D,
      0x37, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x6C,
      0x36, 0x79, 0x75, 0x65, 0x2D, 0x67, 0x33, 0x79, 0x75, 0x65, 0x2D, 0x65,
      0x60, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x65, 0x79, 0x75, 0x65, 0x2D, 0x65,
      0x66, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x65, 0x79, 0x75, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x61, 0x34, 0x79, 0x75, 0x65, 0x2D,
      0x64, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x67, 0x79, 0x75, 0x65, 0x2D,
      0x36, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x60, 0x66, 0x79, 0x75, 0x65, 0x2D,
      0x6C, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x31, 0x79, 0x75, 0x65, 0x2D,
      0x6C, 0x62, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65,
      0x2D, 0x61, 0x34, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x66, 0x79, 0x75, 0x65,
      0x2D, 0x36, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x36, 0x79, 0x75, 0x65,
      0x2D, 0x60, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x67, 0x79, 0x75, 0x65,
      0x2D, 0x37, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x62, 0x79, 0x75, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x61, 0x34, 0x79, 0x75,
      0x65, 0x2D, 0x64, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x67, 0x79, 0x75,
      0x65, 0x2D, 0x36, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x60, 0x66, 0x79, 0x75,
      0x65, 0x2D, 0x6C, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x31, 0x79, 0x75,
      0x65, 0x2D, 0x6C, 0x62, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x65, 0x2D, 0x61, 0x34, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x66, 0x79,
      0x75, 0x65, 0x2D, 0x36, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x36, 0x79,
      0x75, 0x65, 0x2D, 0x60, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x67, 0x79,
      0x75, 0x65, 0x2D, 0x37, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x62, 0x79,
      0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x61, 0x34,
      0x79, 0x75, 0x65, 0x2D, 0x64, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x67,
      0x79, 0x75, 0x65, 0x2D, 0x36, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x60, 0x66,
      0x79, 0x75, 0x65, 0x2D, 0x6C, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x31,
      0x79, 0x75, 0x65, 0x2D, 0x6C, 0x62, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x65, 0x2D, 0x61, 0x34, 0x79, 0x75, 0x65, 0x2D, 0x64,
      0x66, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x36,
      0x36, 0x79, 0x75, 0x65, 0x2D, 0x60, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x6C,
      0x67, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x6C,
      0x62, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D,
      0x61, 0x34, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x66, 0x79, 0x75, 0x65, 0x2D,
      0x36, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x36, 0x79, 0x75, 0x65, 0x2D,
      0x60, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x67, 0x79, 0x75, 0x65, 0x2D,
      0x37, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x62, 0x79, 0x75, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x61, 0x34, 0x79, 0x75, 0x65,
      0x2D, 0x64, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x67, 0x79, 0x75, 0x65,
      0x2D, 0x36, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x60, 0x66, 0x79, 0x75, 0x65,
      0x2D, 0x6C, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x31, 0x79, 0x75, 0x65,
      0x2D, 0x6C, 0x62, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x65, 0x2D, 0x36, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x63, 0x79, 0x75,
      0x65, 0x2D, 0x30, 0x62, 0x79, 0x75, 0x65, 0x2D, 0x67, 0x65, 0x79, 0x75,
      0x65, 0x2D, 0x6C, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x63, 0x79, 0x75,
      0x65, 0x2D, 0x65, 0x30, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x31, 0x79, 0x75,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x67, 0x65, 0x79,
      0x75, 0x65, 0x2D, 0x67, 0x6C, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x64, 0x79,
      0x75, 0x65, 0x2D, 0x33, 0x33, 0x79, 0x75, 0x65, 0x2D, 0x34, 0x37, 0x79,
      0x75, 0x65, 0x2D, 0x60, 0x33, 0x79, 0x75, 0x65, 0x2D, 0x62, 0x6C, 0x79,
      0x75, 0x65, 0x2D, 0x65, 0x60, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x65, 0x2D, 0x61, 0x34, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x66,
      0x79, 0x75, 0x65, 0x2D, 0x36, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x36,
      0x79, 0x75, 0x65, 0x2D, 0x60, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x67,
      0x79, 0x75, 0x65, 0x2D, 0x37, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x62,
      0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x30,
      0x6C, 0x79, 0x75, 0x65, 0x2D, 0x63, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x64,
      0x31, 0x79, 0x75, 0x65, 0x2D, 0x60, 0x37, 0x79, 0x75, 0x65, 0x2D, 0x6C,
      0x67, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x66,
      0x61, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x65, 0x79, 0x75, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x62, 0x65, 0x79, 0x75, 0x65, 0x2D,
      0x31, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x6D, 0x6C, 0x79, 0x75, 0x65, 0x2D,
      0x61, 0x6D, 0x79, 0x75, 0x65, 0x2D, 0x66, 0x64, 0x79, 0x75, 0x65, 0x2D,
      0x36, 0x6C, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x6D, 0x79, 0x75, 0x65, 0x2D,
      0x66, 0x6D, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65,
      0x2D, 0x62, 0x65, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x31, 0x79, 0x75, 0x65,
      0x2D, 0x6D, 0x6C, 0x79, 0x75, 0x65, 0x2D, 0x61, 0x6D, 0x79, 0x75, 0x65,
      0x2D, 0x66, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x6C, 0x79, 0x75, 0x65,
      0x2D, 0x31, 0x6D, 0x79, 0x75, 0x65, 0x2D, 0x66, 0x6D, 0x79, 0x75, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x62, 0x65, 0x79, 0x75,
      0x65, 0x2D, 0x31, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x6D, 0x6C, 0x79, 0x75,
      0x65, 0x2D, 0x61, 0x6D, 0x79, 0x75, 0x65, 0x2D, 0x66, 0x64, 0x79, 0x75,
      0x65, 0x2D, 0x36, 0x6C, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x6D, 0x79, 0x75,
      0x65, 0x2D, 0x66, 0x6D, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x65, 0x2D, 0x62, 0x65, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x31, 0x79,
      0x75, 0x65, 0x2D, 0x6D, 0x6C, 0x79, 0x75, 0x65, 0x2D, 0x61, 0x6D, 0x79,
      0x75, 0x65, 0x2D, 0x66, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x6C, 0x79,
      0x75, 0x65, 0x2D, 0x31, 0x6D, 0x79, 0x75, 0x65, 0x2D, 0x66, 0x6D, 0x79,
      0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x31, 0x62,
      0x79, 0x75, 0x65, 0x2D, 0x60, 0x33, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x31,
      0x79, 0x75, 0x65, 0x2D, 0x67, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x36,
      0x79, 0x75, 0x65, 0x2D, 0x36, 0x37, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x37,
      0x79, 0x75, 0x65, 0x2D, 0x61, 0x6D, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x65, 0x2D, 0x6D, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x65,
      0x31, 0x79, 0x75, 0x65, 0x2D, 0x66, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x67,
      0x34, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x63, 0x79, 0x75, 0x65, 0x2D, 0x6D,
      0x33, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x34, 0x79, 0x75, 0x65, 0x2D, 0x60,
      0x30, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D,
      0x6C, 0x33, 0x79, 0x75, 0x65, 0x2D, 0x30, 0x36, 0x79, 0x75, 0x65, 0x2D,
      0x67, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x61, 0x79, 0x75, 0x65, 0x2D,
      0x30, 0x33, 0x79, 0x75, 0x65, 0x2D, 0x66, 0x30, 0x79, 0x75, 0x65, 0x2D,
      0x63, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x31, 0x79, 0x75, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x36, 0x36, 0x79, 0x75, 0x65,
      0x2D, 0x60, 0x63, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x67, 0x79, 0x75, 0x65,
      0x2D, 0x34, 0x62, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x33, 0x79, 0x75, 0x65,
      0x2D, 0x30, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x60, 0x79, 0x75, 0x65,
      0x2D, 0x65, 0x34, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x65, 0x2D, 0x31, 0x63, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x61, 0x79, 0x75,
      0x65, 0x2D, 0x64, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x64, 0x79, 0x75,
      0x65, 0x2D, 0x31, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x64, 0x79, 0x75,
      0x65, 0x2D, 0x6C, 0x62, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x6D, 0x79, 0x75,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x36, 0x66, 0x79,
      0x75, 0x65, 0x2D, 0x66, 0x63, 0x79, 0x75, 0x65, 0x2D, 0x67, 0x63, 0x79,
      0x75, 0x65, 0x2D, 0x33, 0x30, 0x79, 0x75, 0x65, 0x2D, 0x60, 0x66, 0x79,
      0x75, 0x65, 0x2D, 0x34, 0x65, 0x79, 0x75, 0x65, 0x2D, 0x34, 0x30, 0x79,
      0x75, 0x65, 0x2D, 0x67, 0x33, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x65, 0x2D, 0x31, 0x33, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x64,
      0x79, 0x75, 0x65, 0x2D, 0x33, 0x30, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x31,
      0x79, 0x75, 0x65, 0x2D, 0x67, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x30,
      0x79, 0x75, 0x65, 0x2D, 0x66, 0x37, 0x79, 0x75, 0x65, 0x2D, 0x66, 0x63,
      0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x6D,
      0x60, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x37, 0x79, 0x75, 0x65, 0x2D, 0x62,
      0x65, 0x79, 0x75, 0x65, 0x2D, 0x34, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x63,
      0x66, 0x79, 0x75, 0x65, 0x2D, 0x61, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x61,
      0x37, 0x79, 0x75, 0x65, 0x2D, 0x34, 0x33, 0x79, 0x75, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x34, 0x34, 0x79, 0x75, 0x65, 0x2D,
      0x37, 0x37, 0x79, 0x75, 0x65, 0x2D, 0x60, 0x31, 0x79, 0x75, 0x65, 0x2D,
      0x6D, 0x65, 0x79, 0x75, 0x65, 0x2D, 0x30, 0x64, 0x79, 0x75, 0x65, 0x2D,
      0x6C, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x61, 0x79, 0x75, 0x65, 0x2D,
      0x60, 0x63, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65,
      0x2D, 0x30, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x63, 0x6D, 0x79, 0x75, 0x65,
      0x2D, 0x65, 0x65, 0x79, 0x75, 0x65, 0x2D, 0x62, 0x61, 0x79, 0x75, 0x65,
      0x2D, 0x6C, 0x62, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x66, 0x79, 0x75, 0x65,
      0x2D, 0x66, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x30, 0x6C, 0x79, 0x75, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x33, 0x33, 0x79, 0x75,
      0x65, 0x2D, 0x34, 0x62, 0x79, 0x75, 0x65, 0x2D, 0x61, 0x34, 0x79, 0x75,
      0x65, 0x2D, 0x61, 0x63, 0x79, 0x75, 0x65, 0x2D, 0x34, 0x37, 0x79, 0x75,
      0x65, 0x2D, 0x6D, 0x33, 0x79, 0x75, 0x65, 0x2D, 0x63, 0x6C, 0x79, 0x75,
      0x65, 0x2D, 0x31, 0x67, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x65, 0x2D, 0x63, 0x34, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x37, 0x79,
      0x75, 0x65, 0x2D, 0x6D, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x37, 0x79,
      0x75, 0x65, 0x2D, 0x31, 0x37, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x33, 0x79,
      0x75, 0x65, 0x2D, 0x34, 0x65, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x62, 0x79,
      0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x66, 0x6D,
      0x79, 0x75, 0x65, 0x2D, 0x36, 0x63, 0x79, 0x75, 0x65, 0x2D, 0x60, 0x30,
      0x79, 0x75, 0x65, 0x2D, 0x67, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x31,
      0x79, 0x75, 0x65, 0x2D, 0x63, 0x65, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x6C,
      0x79, 0x75, 0x65, 0x2D, 0x37, 0x30, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x65, 0x2D, 0x61, 0x62, 0x79, 0x75, 0x65, 0x2D, 0x34,
      0x63, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x62,
      0x63, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x61,
      0x64, 0x79, 0x75, 0x65, 0x2D, 0x67, 0x6C, 0x79, 0x75, 0x65, 0x2D, 0x36,
      0x66, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D,
      0x33, 0x33, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x33, 0x79, 0x75, 0x65, 0x2D,
      0x6D, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x34, 0x64, 0x79, 0x75, 0x65, 0x2D,
      0x62, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x66, 0x63, 0x79, 0x75, 0x65, 0x2D,
      0x30, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x30, 0x60, 0x79, 0x75, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x36, 0x65, 0x79, 0x75, 0x65,
      0x2D, 0x34, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x6D, 0x79, 0x75, 0x65,
      0x2D, 0x64, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x67, 0x30, 0x79, 0x75, 0x65,
      0x2D, 0x64, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x61, 0x67, 0x79, 0x75, 0x65,
      0x2D, 0x64, 0x30, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x65, 0x2D, 0x65, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x67, 0x79, 0x75,
      0x65, 0x2D, 0x60, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x30, 0x66, 0x79, 0x75,
      0x65, 0x2D, 0x67, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x37, 0x79, 0x75,
      0x65, 0x2D, 0x64, 0x63, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x30, 0x79, 0x75,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x62, 0x31, 0x79,
      0x75, 0x65, 0x2D, 0x61, 0x62, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x6D, 0x79,
      0x75, 0x65, 0x2D, 0x6C, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x6D, 0x6C, 0x79,
      0x75, 0x65, 0x2D, 0x63, 0x6C, 0x79, 0x75, 0x65, 0x2D, 0x62, 0x31, 0x79,
      0x75, 0x65, 0x2D, 0x64, 0x62, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x65, 0x2D, 0x30, 0x6C, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x61,
      0x79, 0x75, 0x65, 0x2D, 0x34, 0x30, 0x79, 0x75, 0x65, 0x2D, 0x6D, 0x62,
      0x79, 0x75, 0x65, 0x2D, 0x64, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x6D, 0x30,
      0x79, 0x75, 0x65, 0x2D, 0x6C, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x66, 0x36,
      0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x30,
      0x33, 0x79, 0x75, 0x65, 0x2D, 0x66, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x36,
      0x30, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x37, 0x79, 0x75, 0x65, 0x2D, 0x6D,
      0x63, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x65,
      0x65, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x62, 0x79, 0x75, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x65, 0x6C, 0x79, 0x75, 0x65, 0x2D,
      0x30, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x66, 0x60, 0x79, 0x75, 0x65, 0x2D,
      0x66, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x30, 0x6C, 0x79, 0x75, 0x65, 0x2D,
      0x64, 0x30, 0x79, 0x75, 0x65, 0x2D, 0x61, 0x60, 0x79, 0x75, 0x65, 0x2D,
      0x6D, 0x31, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65,
      0x2D, 0x6D, 0x33, 0x79, 0x75, 0x65, 0x2D, 0x6D, 0x6D, 0x79, 0x75, 0x65,
      0x2D, 0x6D, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x30, 0x33, 0x79, 0x75, 0x65,
      0x2D, 0x61, 0x34, 0x79, 0x75, 0x65, 0x2D, 0x60, 0x34, 0x79, 0x75, 0x65,
      0x2D, 0x60, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x30, 0x63, 0x79, 0x75, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x67, 0x66, 0x79, 0x75,
      0x65, 0x2D, 0x31, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x61, 0x79, 0x75,
      0x65, 0x2D, 0x66, 0x30, 0x79, 0x75, 0x65, 0x2D, 0x67, 0x64, 0x79, 0x75,
      0x65, 0x2D, 0x30, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x62, 0x33, 0x79, 0x75,
      0x65, 0x2D, 0x67, 0x63, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x65, 0x2D, 0x34, 0x6D, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x60, 0x79,
      0x75, 0x65, 0x2D, 0x63, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x60, 0x65, 0x79,
      0x75, 0x65, 0x2D, 0x63, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x6D, 0x64, 0x79,
      0x75, 0x65, 0x2D, 0x6D, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x6C, 0x79,
      0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x6C, 0x62,
      0x79, 0x75, 0x65, 0x2D, 0x6C, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x62,
      0x79, 0x75, 0x65, 0x2D, 0x65, 0x33, 0x79, 0x75, 0x65, 0x2D, 0x34, 0x63,
      0x79, 0x75, 0x65, 0x2D, 0x33, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x61, 0x31,
      0x79, 0x75, 0x65, 0x2D, 0x64, 0x33, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x65, 0x2D, 0x64, 0x37, 0x79, 0x75, 0x65, 0x2D, 0x33,
      0x6D, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x6D,
      0x64, 0x79, 0x75, 0x65, 0x2D, 0x66, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x6C,
      0x62, 0x79, 0x75, 0x65, 0x2D, 0x67, 0x62, 0x79, 0x75, 0x65, 0x2D, 0x6D,
      0x66, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D,
      0x36, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x65, 0x79, 0x75, 0x65, 0x2D,
      0x30, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x31, 0x79, 0x75, 0x65, 0x2D,
      0x37, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x34, 0x33, 0x79, 0x75, 0x65, 0x2D,
      0x67, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x66, 0x30, 0x79, 0x75, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x63, 0x64, 0x79, 0x75, 0x65,
      0x2D, 0x31, 0x6D, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x34, 0x79, 0x75, 0x65,
      0x2D, 0x33, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x62, 0x36, 0x79, 0x75, 0x65,
      0x2D, 0x62, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x6D, 0x62, 0x79, 0x75, 0x65,
      0x2D, 0x33, 0x34, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x65, 0x2D, 0x6C, 0x30, 0x79, 0x75, 0x65, 0x2D, 0x30, 0x67, 0x79, 0x75,
      0x65, 0x2D, 0x62, 0x30, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x61, 0x79, 0x75,
      0x65, 0x2D, 0x30, 0x37, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x63, 0x79, 0x75,
      0x65, 0x2D, 0x60, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x30, 0x61, 0x79, 0x75,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x60, 0x63, 0x79,
      0x75, 0x65, 0x2D, 0x34, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x30, 0x37, 0x79,
      0x75, 0x65, 0x2D, 0x65, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x34, 0x79,
      0x75, 0x65, 0x2D, 0x6C, 0x34, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x33, 0x79,
      0x75, 0x65, 0x2D, 0x34, 0x63, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x65, 0x2D, 0x67, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x60, 0x62,
      0x79, 0x75, 0x65, 0x2D, 0x60, 0x62, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x61,
      0x79, 0x75, 0x65, 0x2D, 0x6C, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x67, 0x37,
      0x79, 0x75, 0x65, 0x2D, 0x65, 0x6C, 0x79, 0x75, 0x65, 0x2D, 0x67, 0x34,
      0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x61,
      0x36, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x31,
      0x31, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x62, 0x79, 0x75, 0x65, 0x2D, 0x6D,
      0x6D, 0x79, 0x75, 0x65, 0x2D, 0x63, 0x37, 0x79, 0x75, 0x65, 0x2D, 0x30,
      0x67, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x6C, 0x79, 0x75, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x63, 0x6C, 0x79, 0x75, 0x65, 0x2D,
      0x61, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x33, 0x79, 0x75, 0x65, 0x2D,
      0x67, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x62, 0x79, 0x75, 0x65, 0x2D,
      0x62, 0x62, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x66, 0x79, 0x75, 0x65, 0x2D,
      0x37, 0x33, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65,
      0x2D, 0x67, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x66, 0x79, 0x75, 0x65,
      0x2D, 0x36, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x61, 0x33, 0x79, 0x75, 0x65,
      0x2D, 0x6C, 0x34, 0x79, 0x75, 0x65, 0x2D, 0x61, 0x30, 0x79, 0x75, 0x65,
      0x2D, 0x64, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x34, 0x65, 0x79, 0x75, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x61, 0x30, 0x79, 0x75,
      0x65, 0x2D, 0x37, 0x33, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x66, 0x79, 0x75,
      0x65, 0x2D, 0x34, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x62, 0x67, 0x79, 0x75,
      0x65, 0x2D, 0x65, 0x63, 0x79, 0x75, 0x65, 0x2D, 0x60, 0x33, 0x79, 0x75,
      0x65, 0x2D, 0x62, 0x36, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x65, 0x2D, 0x67, 0x65, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x60, 0x79,
      0x75, 0x65, 0x2D, 0x31, 0x33, 0x79, 0x75, 0x65, 0x2D, 0x34, 0x34, 0x79,
      0x75, 0x65, 0x2D, 0x65, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x61, 0x79,
      0x75, 0x65, 0x2D, 0x37, 0x65, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x62, 0x79,
      0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x37, 0x6D,
      0x79, 0x75, 0x65, 0x2D, 0x67, 0x30, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x60,
      0x79, 0x75, 0x65, 0x2D, 0x6C, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x6D, 0x6D,
      0x79, 0x75, 0x65, 0x2D, 0x33, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x66, 0x63,
      0x79, 0x75, 0x65, 0x2D, 0x62, 0x61, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x65, 0x2D, 0x66, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x31,
      0x60, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x30, 0x79, 0x75, 0x65, 0x2D, 0x62,
      0x61, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x34, 0x79, 0x75, 0x65, 0x2D, 0x36,
      0x6D, 0x79, 0x75, 0x65, 0x2D, 0x34, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x34,
      0x66, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D,
      0x6D, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x30, 0x67, 0x79, 0x75, 0x65, 0x2D,
      0x6C, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x66, 0x79, 0x75, 0x65, 0x2D,
      0x61, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x6D, 0x67, 0x79, 0x75, 0x65, 0x2D,
      0x30, 0x6C, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x67, 0x79, 0x75, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x6C, 0x65, 0x79, 0x75, 0x65,
      0x2D, 0x60, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x61, 0x79, 0x75, 0x65,
      0x2D, 0x6D, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x6D, 0x63, 0x79, 0x75, 0x65,
      0x2D, 0x65, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x61, 0x79, 0x75, 0x65,
      0x2D, 0x61, 0x60, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x65, 0x2D, 0x31, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x6C, 0x79, 0x75,
      0x65, 0x2D, 0x63, 0x33, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x33, 0x79, 0x75,
      0x65, 0x2D, 0x61, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x66, 0x62, 0x79, 0x75,
      0x65, 0x2D, 0x33, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x66, 0x79, 0x75,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x63, 0x37, 0x79,
      0x75, 0x65, 0x2D, 0x65, 0x37, 0x79, 0x75, 0x65, 0x2D, 0x67, 0x33, 0x79,
      0x75, 0x65, 0x2D, 0x30, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x30, 0x79,
      0x75, 0x65, 0x2D, 0x33, 0x37, 0x79, 0x75, 0x65, 0x2D, 0x67, 0x63, 0x79,
      0x75, 0x65, 0x2D, 0x37, 0x31, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x65, 0x2D, 0x60, 0x63, 0x79, 0x75, 0x65, 0x2D, 0x63, 0x60,
      0x79, 0x75, 0x65, 0x2D, 0x61, 0x6D, 0x79, 0x75, 0x65, 0x2D, 0x61, 0x30,
      0x79, 0x75, 0x65, 0x2D, 0x37, 0x65, 0x79, 0x75, 0x65, 0x2D, 0x67, 0x34,
      0x79, 0x75, 0x65, 0x2D, 0x31, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x60,
      0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x33,
      0x60, 0x79, 0x75, 0x65, 0x2D, 0x6D, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x66,
      0x30, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x62,
      0x30, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x65, 0x79, 0x75, 0x65, 0x2D, 0x33,
      0x33, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x61, 0x79, 0x75, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x36, 0x31, 0x79, 0x75, 0x65, 0x2D,
      0x60, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x31, 0x79, 0x75, 0x65, 0x2D,
      0x61, 0x6D, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x66, 0x79, 0x75, 0x65, 0x2D,
      0x6D, 0x62, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x6C, 0x79, 0x75, 0x65, 0x2D,
      0x6D, 0x60, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65,
      0x2D, 0x6D, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x61, 0x37, 0x79, 0x75, 0x65,
      0x2D, 0x36, 0x65, 0x79, 0x75, 0x65, 0x2D, 0x63, 0x31, 0x79, 0x75, 0x65,
      0x2D, 0x36, 0x33, 0x79, 0x75, 0x65, 0x2D, 0x63, 0x31, 0x79, 0x75, 0x65,
      0x2D, 0x64, 0x63, 0x79, 0x75, 0x65, 0x2D, 0x66, 0x66, 0x79, 0x75, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x33, 0x6C, 0x79, 0x75,
      0x65, 0x2D, 0x64, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x37, 0x79, 0x75,
      0x65, 0x2D, 0x62, 0x63, 0x79, 0x75, 0x65, 0x2D, 0x63, 0x33, 0x79, 0x75,
      0x65, 0x2D, 0x60, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x34, 0x79, 0x75,
      0x65, 0x2D, 0x66, 0x6C, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x65, 0x2D, 0x62, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x6D, 0x79,
      0x75, 0x65, 0x2D, 0x34, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x66, 0x79,
      0x75, 0x65, 0x2D, 0x6D, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x61, 0x64, 0x79,
      0x75, 0x65, 0x2D, 0x65, 0x30, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x36, 0x79,
      0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x63, 0x63,
      0x79, 0x75, 0x65, 0x2D, 0x66, 0x63, 0x79, 0x75, 0x65, 0x2D, 0x62, 0x61,
      0x79, 0x75, 0x65, 0x2D, 0x64, 0x6D, 0x79, 0x75, 0x65, 0x2D, 0x34, 0x66,
      0x79, 0x75, 0x65, 0x2D, 0x60, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x30, 0x31,
      0x79, 0x75, 0x65, 0x2D, 0x33, 0x63, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x65, 0x2D, 0x34, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x64,
      0x30, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x6D, 0x79, 0x75, 0x65, 0x2D, 0x60,
      0x62, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x37,
      0x61, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x62,
      0x37, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D,
      0x67, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x66, 0x79, 0x75, 0x65, 0x2D,
      0x33, 0x30, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x67, 0x79, 0x75, 0x65, 0x2D,
      0x66, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x63, 0x79, 0x75, 0x65, 0x2D,
      0x30, 0x63, 0x79, 0x75, 0x65, 0x2D, 0x66, 0x36, 0x79, 0x75, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x34, 0x60, 0x79, 0x75, 0x65,
      0x2D, 0x37, 0x37, 0x79, 0x75, 0x65, 0x2D, 0x63, 0x34, 0x79, 0x75, 0x65,
      0x2D, 0x67, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x31, 0x79, 0x75, 0x65,
      0x2D, 0x63, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x64, 0x79, 0x75, 0x65,
      0x2D, 0x6C, 0x66, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x65, 0x2D, 0x36, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x6D, 0x31, 0x79, 0x75,
      0x65, 0x2D, 0x6C, 0x63, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x6C, 0x79, 0x75,
      0x65, 0x2D, 0x37, 0x65, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x6C, 0x79, 0x75,
      0x65, 0x2D, 0x66, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x34, 0x37, 0x79, 0x75,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x61, 0x36, 0x79,
      0x75, 0x65, 0x2D, 0x67, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x30, 0x36, 0x79,
      0x75, 0x65, 0x2D, 0x60, 0x30, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x6D, 0x79,
      0x75, 0x65, 0x2D, 0x66, 0x34, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x37, 0x79,
      0x75, 0x65, 0x2D, 0x66, 0x31, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x65, 0x2D, 0x63, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x6D,
      0x79, 0x75, 0x65, 0x2D, 0x6D, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x37,
      0x79, 0x75, 0x65, 0x2D, 0x66, 0x62, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x33,
      0x79, 0x75, 0x65, 0x2D, 0x37, 0x30, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x65,
      0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x37,
      0x65, 0x79, 0x75, 0x65, 0x2D, 0x63, 0x63, 0x79, 0x75, 0x65, 0x2D, 0x6D,
      0x64, 0x79, 0x75, 0x65, 0x2D, 0x67, 0x30, 0x79, 0x75, 0x65, 0x2D, 0x37,
      0x64, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x34,
      0x65, 0x79, 0x75, 0x65, 0x2D, 0x67, 0x6C, 0x79, 0x75, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x6C, 0x67, 0x79, 0x75, 0x65, 0x2D,
      0x33, 0x37, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x37, 0x79, 0x75, 0x65, 0x2D,
      0x60, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x60, 0x60, 0x79, 0x75, 0x65, 0x2D,
      0x34, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x6D, 0x62, 0x79, 0x75, 0x65, 0x2D,
      0x31, 0x30, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65,
      0x2D, 0x64, 0x33, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x31, 0x79, 0x75, 0x65,
      0x2D, 0x61, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x62, 0x79, 0x75, 0x65,
      0x2D, 0x31, 0x65, 0x79, 0x75, 0x65, 0x2D, 0x63, 0x37, 0x79, 0x75, 0x65,
      0x2D, 0x60, 0x65, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x34, 0x79, 0x75, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x61, 0x63, 0x79, 0x75,
      0x65, 0x2D, 0x63, 0x34, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x37, 0x79, 0x75,
      0x65, 0x2D, 0x6C, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x36, 0x79, 0x75,
      0x65, 0x2D, 0x31, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x63, 0x64, 0x79, 0x75,
      0x65, 0x2D, 0x36, 0x62, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x65, 0x2D, 0x33, 0x34, 0x79, 0x75, 0x65, 0x2D, 0x61, 0x37, 0x79,
      0x75, 0x65, 0x2D, 0x36, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x65, 0x79,
      0x75, 0x65, 0x2D, 0x31, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x6D, 0x79,
      0x75, 0x65, 0x2D, 0x33, 0x6D, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x30, 0x79,
      0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x63, 0x65,
      0x79, 0x75, 0x65, 0x2D, 0x36, 0x63, 0x79, 0x75, 0x65, 0x2D, 0x63, 0x37,
      0x79, 0x75, 0x65, 0x2D, 0x65, 0x62, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x37,
      0x79, 0x75, 0x65, 0x2D, 0x6C, 0x6D, 0x79, 0x75, 0x65, 0x2D, 0x67, 0x60,
      0x79, 0x75, 0x65, 0x2D, 0x30, 0x65, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x65, 0x2D, 0x62, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x60,
      0x66, 0x79, 0x75, 0x65, 0x2D, 0x30, 0x63, 0x79, 0x75, 0x65, 0x2D, 0x33,
      0x66, 0x79, 0x75, 0x65, 0x2D, 0x67, 0x6D, 0x79, 0x75, 0x65, 0x2D, 0x64,
      0x36, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x37,
      0x67, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D,
      0x62, 0x37, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x37, 0x79, 0x75, 0x65, 0x2D,
      0x6D, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x34, 0x66, 0x79, 0x75, 0x65, 0x2D,
      0x66, 0x65, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x62, 0x79, 0x75, 0x65, 0x2D,
      0x65, 0x63, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x6D, 0x79, 0x75, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x37, 0x61, 0x79, 0x75, 0x65,
      0x2D, 0x33, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x63, 0x60, 0x79, 0x75, 0x65,
      0x2D, 0x66, 0x62, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x65, 0x79, 0x75, 0x65,
      0x2D, 0x33, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x6C, 0x36, 0x79, 0x75, 0x65,
      0x2D, 0x65, 0x66, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x65, 0x2D, 0x31, 0x36, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x34, 0x79, 0x75,
      0x65, 0x2D, 0x36, 0x62, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x67, 0x79, 0x75,
      0x65, 0x2D, 0x67, 0x65, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x64, 0x79, 0x75,
      0x65, 0x2D, 0x34, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x60, 0x67, 0x79, 0x75,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x6C, 0x33, 0x79,
      0x75, 0x65, 0x2D, 0x37, 0x64, 0x79, 0x75, 0x65, 0x2D, 0x31, 0x60, 0x79,
      0x75, 0x65, 0x2D, 0x63, 0x65, 0x79, 0x75, 0x65, 0x2D, 0x33, 0x34, 0x79,
      0x75, 0x65, 0x2D, 0x64, 0x6C, 0x79, 0x75, 0x65, 0x2D, 0x60, 0x66, 0x79,
      0x75, 0x65, 0x2D, 0x6C, 0x6C, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x65, 0x2D, 0x33, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x60,
      0x79, 0x75, 0x65, 0x2D, 0x36, 0x33, 0x79, 0x75, 0x65, 0x2D, 0x65, 0x65,
      0x79, 0x75, 0x65, 0x2D, 0x61, 0x60, 0x79, 0x75, 0x65, 0x2D, 0x6D, 0x36,
      0x79, 0x75, 0x65, 0x2D, 0x66, 0x67, 0x79, 0x75, 0x65, 0x2D, 0x30, 0x61,
      0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x30,
      0x33, 0x79, 0x75, 0x65, 0x2D, 0x37, 0x31, 0x79, 0x75, 0x65, 0x2D, 0x62,
      0x65, 0x79, 0x75, 0x65, 0x2D, 0x30, 0x6D, 0x79, 0x75, 0x65, 0x2D, 0x61,
      0x6D, 0x79, 0x75, 0x65, 0x2D, 0x67, 0x34, 0x79, 0x75, 0x65, 0x2D, 0x31,
      0x31, 0x79, 0x75, 0x65, 0x2D, 0x62, 0x60, 0x79, 0x75, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x65, 0x2D, 0x36, 0x61, 0x79, 0x75, 0x65, 0x2D,
      0x34, 0x37, 0x79, 0x75, 0x65, 0x2D, 0x36, 0x63, 0x79, 0x75, 0x65, 0x2D,
      0x62, 0x33, 0x79, 0x75, 0x65, 0x2D, 0x6D, 0x30, 0x79, 0x75, 0x65, 0x2D,
      0x31, 0x33, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x63, 0x79, 0x75, 0x65, 0x2D,
      0x6D, 0x61, 0x79, 0x75, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x65,
      0x2D, 0x31, 0x62, 0x79, 0x75, 0x65, 0x2D, 0x66, 0x62, 0x79, 0x75, 0x65,
      0x2D, 0x30, 0x62, 0x79, 0x75, 0x65, 0x2D, 0x62, 0x60, 0x79, 0x75, 0x65,
      0x2D, 0x33, 0x61, 0x79, 0x75, 0x65, 0x2D, 0x34, 0x6D, 0x79, 0x75, 0x65,
      0x2D, 0x65, 0x66, 0x79, 0x75, 0x65, 0x2D, 0x64, 0x63, 0x79, 0x75, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x38, 0x2C, 0x75, 0x15, 0x3A, 0x27, 0x0A, 0x39, 0x3C, 0x26,
      0x21, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x33, 0x3A, 0x27, 0x30, 0x34,
      0x36, 0x3D, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x3A, 0x36, 0x25, 0x0A, 0x3C,
      0x3B, 0x31, 0x30, 0x2D, 0x75, 0x7D, 0x65, 0x75, 0x7B, 0x7B, 0x75, 0x78,
      0x64, 0x75, 0x7E, 0x75, 0x15, 0x3A, 0x25, 0x30, 0x3B, 0x0A, 0x36, 0x3A,
      0x27, 0x30, 0x0A, 0x23, 0x34, 0x39, 0x20, 0x30, 0x26, 0x7C, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x2E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x38,
      0x2C, 0x75, 0x71, 0x3A, 0x36, 0x25, 0x75, 0x68, 0x75, 0x71, 0x3A, 0x25,
      0x30, 0x3B, 0x0A, 0x36, 0x3A, 0x27, 0x30, 0x0A, 0x23, 0x34, 0x39, 0x20,
      0x30, 0x26, 0x0E, 0x71, 0x3A, 0x36, 0x25, 0x0A, 0x3C, 0x3B, 0x31, 0x30,
      0x2D, 0x08, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x3B, 0x30, 0x2D, 0x21, 0x75, 0x3C, 0x33, 0x75, 0x7D, 0x3B, 0x3A,
      0x21, 0x75, 0x71, 0x3A, 0x36, 0x25, 0x78, 0x6B, 0x0E, 0x67, 0x08, 0x7C,
      0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x38,
      0x2C, 0x75, 0x71, 0x3C, 0x3B, 0x26, 0x21, 0x34, 0x3B, 0x36, 0x30, 0x3B,
      0x34, 0x38, 0x30, 0x75, 0x68, 0x75, 0x71, 0x3A, 0x36, 0x25, 0x78, 0x6B,
      0x0E, 0x65, 0x08, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x38,
      0x2C, 0x75, 0x71, 0x36, 0x39, 0x34, 0x26, 0x26, 0x3B, 0x34, 0x38, 0x30,
      0x75, 0x68, 0x75, 0x71, 0x3A, 0x36, 0x25, 0x78, 0x6B, 0x0E, 0x64, 0x08,
      0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x25,
      0x27, 0x3C, 0x3B, 0x21, 0x75, 0x06, 0x01, 0x11, 0x10, 0x07, 0x07, 0x75,
      0x77, 0x38, 0x34, 0x3E, 0x3C, 0x3B, 0x32, 0x75, 0x34, 0x3B, 0x75, 0x34,
      0x26, 0x26, 0x30, 0x27, 0x21, 0x3C, 0x3A, 0x3B, 0x75, 0x38, 0x3A, 0x31,
      0x20, 0x39, 0x30, 0x75, 0x33, 0x3A, 0x27, 0x75, 0x3C, 0x3B, 0x26, 0x21,
      0x34, 0x3B, 0x36, 0x30, 0x75, 0x77, 0x75, 0x7B, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x77, 0x72, 0x71, 0x3C, 0x3B, 0x26, 0x21,
      0x34, 0x3B, 0x36, 0x30, 0x3B, 0x34, 0x38, 0x30, 0x72, 0x75, 0x77, 0x75,
      0x7B, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x77, 0x75,
      0x3A, 0x33, 0x75, 0x36, 0x39, 0x34, 0x26, 0x26, 0x75, 0x77, 0x75, 0x7B,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x77, 0x72, 0x71,
      0x36, 0x39, 0x34, 0x26, 0x26, 0x3B, 0x34, 0x38, 0x30, 0x72, 0x75, 0x77,
      0x75, 0x7B, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x77,
      0x09, 0x3B, 0x77, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x3A, 0x36, 0x25, 0x0A, 0x3B, 0x34,
      0x38, 0x30, 0x75, 0x68, 0x75, 0x72, 0x26, 0x3A, 0x25, 0x36, 0x0A, 0x25,
      0x34, 0x27, 0x34, 0x38, 0x30, 0x21, 0x30, 0x27, 0x26, 0x0A, 0x72, 0x75,
      0x7B, 0x75, 0x71, 0x3A, 0x36, 0x25, 0x0A, 0x3C, 0x3B, 0x31, 0x30, 0x2D,
      0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71,
      0x3A, 0x36, 0x25, 0x0A, 0x34, 0x26, 0x26, 0x30, 0x27, 0x21, 0x0A, 0x33,
      0x3C, 0x39, 0x30, 0x3B, 0x34, 0x38, 0x30, 0x75, 0x68, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x71, 0x21, 0x3D, 0x3C, 0x26, 0x78,
      0x6B, 0x25, 0x27, 0x3A, 0x3F, 0x30, 0x36, 0x21, 0x7D, 0x7C, 0x78, 0x6B,
      0x0A, 0x26, 0x2C, 0x26, 0x21, 0x30, 0x38, 0x0A, 0x31, 0x3C, 0x27, 0x30,
      0x36, 0x21, 0x3A, 0x27, 0x2C, 0x7D, 0x7C, 0x75, 0x7B, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x72, 0x7A, 0x72, 0x75, 0x7B, 0x75,
      0x71, 0x3A, 0x36, 0x25, 0x0A, 0x3B, 0x34, 0x38, 0x30, 0x75, 0x7B, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x72, 0x7B, 0x21, 0x31,
      0x33, 0x72, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x36, 0x39,
      0x3E, 0x75, 0x68, 0x75, 0x72, 0x36, 0x39, 0x3E, 0x72, 0x6E, 0x58, 0x5F,
      0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x3A, 0x25, 0x30, 0x3B,
      0x75, 0x13, 0x1C, 0x19, 0x10, 0x79, 0x75, 0x72, 0x6B, 0x72, 0x75, 0x7B,
      0x75, 0x71, 0x3A, 0x36, 0x25, 0x0A, 0x34, 0x26, 0x26, 0x30, 0x27, 0x21,
      0x0A, 0x33, 0x3C, 0x39, 0x30, 0x3B, 0x34, 0x38, 0x30, 0x6E, 0x58, 0x5F,
      0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x3C, 0x33, 0x75, 0x7D,
      0x71, 0x3A, 0x36, 0x25, 0x0A, 0x3C, 0x3B, 0x31, 0x30, 0x2D, 0x75, 0x68,
      0x68, 0x75, 0x65, 0x7C, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x2E,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x37, 0x3C, 0x3B, 0x38, 0x3A, 0x31, 0x30, 0x75,
      0x13, 0x1C, 0x19, 0x10, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x25, 0x27, 0x3C, 0x3B, 0x21, 0x75, 0x13, 0x1C, 0x19, 0x10,
      0x75, 0x7D, 0x25, 0x34, 0x36, 0x3E, 0x75, 0x72, 0x16, 0x7F, 0x72, 0x79,
      0x75, 0x15, 0x26, 0x3A, 0x25, 0x36, 0x0A, 0x25, 0x34, 0x27, 0x34, 0x38,
      0x30, 0x21, 0x30, 0x27, 0x26, 0x0A, 0x31, 0x34, 0x21, 0x34, 0x7C, 0x6E,
      0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x3A,
      0x36, 0x25, 0x0A, 0x3C, 0x3B, 0x36, 0x0A, 0x33, 0x3C, 0x39, 0x30, 0x3B,
      0x34, 0x38, 0x30, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x7D, 0x71, 0x3A, 0x36, 0x25, 0x0A, 0x3C, 0x3B, 0x36, 0x0A, 0x33,
      0x3C, 0x39, 0x30, 0x3B, 0x34, 0x38, 0x30, 0x75, 0x68, 0x75, 0x71, 0x3A,
      0x36, 0x25, 0x0A, 0x34, 0x26, 0x26, 0x30, 0x27, 0x21, 0x0A, 0x33, 0x3C,
      0x39, 0x30, 0x3B, 0x34, 0x38, 0x30, 0x7C, 0x75, 0x68, 0x2B, 0x75, 0x26,
      0x7A, 0x21, 0x31, 0x33, 0x71, 0x7A, 0x3C, 0x3B, 0x36, 0x7A, 0x6E, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x3A, 0x25, 0x30, 0x3B,
      0x75, 0x1C, 0x1B, 0x16, 0x0A, 0x13, 0x1C, 0x19, 0x10, 0x79, 0x75, 0x72,
      0x6B, 0x72, 0x75, 0x7B, 0x75, 0x71, 0x3A, 0x36, 0x25, 0x0A, 0x3C, 0x3B,
      0x36, 0x0A, 0x33, 0x3C, 0x39, 0x30, 0x3B, 0x34, 0x38, 0x30, 0x6E, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x25, 0x27, 0x3C, 0x3B,
      0x21, 0x75, 0x1C, 0x1B, 0x16, 0x0A, 0x13, 0x1C, 0x19, 0x10, 0x75, 0x24,
      0x24, 0x0E, 0x58, 0x5F, 0x5F, 0x05, 0x14, 0x07, 0x14, 0x18, 0x10, 0x01,
      0x10, 0x07, 0x06, 0x58, 0x5F, 0x5F, 0x7D, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x16, 0x1A, 0x07, 0x10, 0x0A, 0x1B, 0x14, 0x18, 0x10, 0x75, 0x68, 0x75,
      0x77, 0x71, 0x36, 0x39, 0x34, 0x26, 0x26, 0x3B, 0x34, 0x38, 0x30, 0x77,
      0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x16, 0x19, 0x1A, 0x16, 0x1E, 0x0A,
      0x19, 0x1C, 0x18, 0x1C, 0x01, 0x75, 0x68, 0x75, 0x77, 0x71, 0x34, 0x36,
      0x21, 0x20, 0x34, 0x39, 0x0A, 0x36, 0x2C, 0x36, 0x39, 0x30, 0x0A, 0x36,
      0x3A, 0x20, 0x3B, 0x21, 0x77, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x11,
      0x1C, 0x06, 0x14, 0x17, 0x19, 0x10, 0x0A, 0x17, 0x10, 0x1D, 0x14, 0x03,
      0x1C, 0x1A, 0x07, 0x75, 0x68, 0x75, 0x77, 0x21, 0x3D, 0x30, 0x75, 0x26,
      0x2C, 0x26, 0x21, 0x30, 0x38, 0x75, 0x22, 0x3C, 0x39, 0x39, 0x75, 0x37,
      0x30, 0x75, 0x31, 0x3C, 0x26, 0x34, 0x37, 0x39, 0x30, 0x31, 0x77, 0x79,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x16, 0x19, 0x1A, 0x16, 0x1E, 0x0A, 0x1B,
      0x14, 0x18, 0x10, 0x75, 0x68, 0x75, 0x77, 0x71, 0x36, 0x39, 0x3E, 0x77,
      0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x10, 0x1B, 0x14, 0x17, 0x19, 0x10,
      0x0A, 0x01, 0x1C, 0x18, 0x10, 0x75, 0x68, 0x75, 0x77, 0x71, 0x34, 0x36,
      0x21, 0x20, 0x34, 0x39, 0x0A, 0x21, 0x3C, 0x38, 0x30, 0x77, 0x58, 0x5F,
      0x5F, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x08, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x36,
      0x39, 0x3A, 0x26, 0x30, 0x75, 0x1C, 0x1B, 0x16, 0x0A, 0x13, 0x1C, 0x19,
      0x10, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x28, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x30, 0x39, 0x26, 0x30,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x2E, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x25, 0x27, 0x3C, 0x3B,
      0x21, 0x75, 0x13, 0x1C, 0x19, 0x10, 0x75, 0x24, 0x24, 0x0E, 0x58, 0x5F,
      0x5F, 0x14, 0x06, 0x06, 0x10, 0x07, 0x01, 0x75, 0x07, 0x10, 0x05, 0x1A,
      0x07, 0x01, 0x75, 0x77, 0x16, 0x3A, 0x38, 0x25, 0x3C, 0x39, 0x3C, 0x3B,
      0x32, 0x75, 0x21, 0x3D, 0x30, 0x75, 0x71, 0x36, 0x39, 0x34, 0x26, 0x26,
      0x3B, 0x34, 0x38, 0x30, 0x75, 0x36, 0x3A, 0x38, 0x25, 0x3A, 0x3B, 0x30,
      0x3B, 0x21, 0x7B, 0x77, 0x58, 0x5F, 0x5F, 0x06, 0x10, 0x03, 0x10, 0x07,
      0x1C, 0x01, 0x0C, 0x75, 0x1C, 0x1B, 0x13, 0x1A, 0x6E, 0x58, 0x5F, 0x5F,
      0x14, 0x06, 0x06, 0x10, 0x07, 0x01, 0x75, 0x07, 0x10, 0x05, 0x1A, 0x07,
      0x01, 0x75, 0x77, 0x0C, 0x3A, 0x20, 0x75, 0x34, 0x27, 0x30, 0x75, 0x3B,
      0x3A, 0x22, 0x75, 0x36, 0x3A, 0x38, 0x25, 0x3C, 0x39, 0x3C, 0x3B, 0x32,
      0x75, 0x34, 0x75, 0x21, 0x3C, 0x38, 0x30, 0x78, 0x39, 0x3C, 0x38, 0x3C,
      0x21, 0x30, 0x31, 0x75, 0x23, 0x30, 0x27, 0x26, 0x3C, 0x3A, 0x3B, 0x75,
      0x3A, 0x33, 0x75, 0x21, 0x3D, 0x30, 0x75, 0x71, 0x36, 0x39, 0x34, 0x26,
      0x26, 0x3B, 0x34, 0x38, 0x30, 0x75, 0x36, 0x3A, 0x38, 0x25, 0x3A, 0x3B,
      0x30, 0x3B, 0x21, 0x7B, 0x75, 0x75, 0x01, 0x3D, 0x3C, 0x26, 0x75, 0x36,
      0x3A, 0x27, 0x30, 0x75, 0x3C, 0x26, 0x75, 0x3B, 0x3A, 0x21, 0x75, 0x26,
      0x20, 0x3C, 0x21, 0x30, 0x31, 0x75, 0x33, 0x3A, 0x27, 0x75, 0x25, 0x27,
      0x3A, 0x31, 0x20, 0x36, 0x21, 0x3C, 0x3A, 0x3B, 0x75, 0x27, 0x30, 0x39,
      0x30, 0x34, 0x26, 0x30, 0x7B, 0x75, 0x75, 0x01, 0x3D, 0x3C, 0x26, 0x75,
      0x36, 0x3A, 0x27, 0x30, 0x75, 0x22, 0x3C, 0x39, 0x39, 0x75, 0x33, 0x20,
      0x3B, 0x36, 0x21, 0x3C, 0x3A, 0x3B, 0x75, 0x33, 0x3A, 0x27, 0x75, 0x71,
      0x34, 0x36, 0x21, 0x20, 0x34, 0x39, 0x0A, 0x36, 0x2C, 0x36, 0x39, 0x30,
      0x0A, 0x36, 0x3A, 0x20, 0x3B, 0x21, 0x75, 0x36, 0x39, 0x3A, 0x36, 0x3E,
      0x75, 0x36, 0x2C, 0x36, 0x39, 0x30, 0x26, 0x75, 0x3A, 0x33, 0x75, 0x21,
      0x3D, 0x30, 0x75, 0x36, 0x39, 0x3A, 0x36, 0x3E, 0x75, 0x3C, 0x3B, 0x25,
      0x20, 0x21, 0x75, 0x72, 0x71, 0x36, 0x39, 0x3E, 0x72, 0x75, 0x7D, 0x71,
      0x34, 0x36, 0x21, 0x20, 0x34, 0x39, 0x0A, 0x21, 0x3C, 0x38, 0x30, 0x7C,
      0x7B, 0x75, 0x75, 0x00, 0x25, 0x3A, 0x3B, 0x75, 0x30, 0x2D, 0x25, 0x3C,
      0x27, 0x34, 0x21, 0x3C, 0x3A, 0x3B, 0x79, 0x75, 0x21, 0x3D, 0x30, 0x75,
      0x26, 0x2C, 0x26, 0x21, 0x30, 0x38, 0x75, 0x22, 0x3C, 0x39, 0x39, 0x75,
      0x37, 0x30, 0x75, 0x31, 0x3C, 0x26, 0x34, 0x37, 0x39, 0x30, 0x31, 0x7B,
      0x75, 0x01, 0x3D, 0x30, 0x75, 0x31, 0x30, 0x23, 0x3C, 0x36, 0x30, 0x75,
      0x38, 0x20, 0x26, 0x21, 0x75, 0x37, 0x30, 0x75, 0x27, 0x30, 0x36, 0x3A,
      0x3B, 0x33, 0x3C, 0x32, 0x20, 0x27, 0x30, 0x31, 0x75, 0x21, 0x3A, 0x75,
      0x27, 0x30, 0x26, 0x30, 0x21, 0x7B, 0x77, 0x58, 0x5F, 0x5F, 0x06, 0x10,
      0x03, 0x10, 0x07, 0x1C, 0x01, 0x0C, 0x75, 0x02, 0x14, 0x07, 0x1B, 0x1C,
      0x1B, 0x12, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x06, 0x00, 0x17,
      0x11, 0x10, 0x06, 0x1C, 0x12, 0x1B, 0x75, 0x71, 0x3A, 0x36, 0x25, 0x0A,
      0x3B, 0x34, 0x38, 0x30, 0x58, 0x5F, 0x5F, 0x7D, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x3C, 0x3B, 0x0A, 0x25, 0x3A, 0x27, 0x21, 0x6F, 0x75, 0x1C, 0x1B,
      0x05, 0x00, 0x01, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x3A, 0x20, 0x21,
      0x0A, 0x25, 0x3A, 0x27, 0x21, 0x6F, 0x75, 0x1A, 0x00, 0x01, 0x05, 0x00,
      0x01, 0x6E, 0x58, 0x5F, 0x5F, 0x7C, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F,
      0x17, 0x10, 0x12, 0x1C, 0x1B, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x3A, 0x20,
      0x21, 0x0A, 0x25, 0x3A, 0x27, 0x21, 0x75, 0x68, 0x75, 0x3C, 0x3B, 0x0A,
      0x25, 0x3A, 0x27, 0x21, 0x6E, 0x58, 0x5F, 0x5F, 0x10, 0x1B, 0x11, 0x75,
      0x6E, 0x58, 0x5F, 0x5F, 0x08, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x28, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x36, 0x39, 0x3A,
      0x26, 0x30, 0x75, 0x13, 0x1C, 0x19, 0x10, 0x6E, 0x58, 0x5F, 0x5F, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x5F, 0x5F, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x21, 0x3A, 0x25,
      0x75, 0x68, 0x75, 0x71, 0x21, 0x3D, 0x3C, 0x26, 0x78, 0x6B, 0x25, 0x27,
      0x3A, 0x3F, 0x30, 0x36, 0x21, 0x78, 0x6B, 0x21, 0x3A, 0x25, 0x7D, 0x7C,
      0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71,
      0x3C, 0x3B, 0x0A, 0x26, 0x3C, 0x32, 0x75, 0x68, 0x75, 0x72, 0x31, 0x26,
      0x2C, 0x3B, 0x36, 0x72, 0x75, 0x7B, 0x75, 0x71, 0x3A, 0x36, 0x25, 0x0A,
      0x3C, 0x3B, 0x31, 0x30, 0x2D, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x38, 0x2C, 0x75, 0x71, 0x3A, 0x20, 0x21, 0x0A, 0x26, 0x3C, 0x32,
      0x75, 0x68, 0x75, 0x72, 0x3A, 0x20, 0x21, 0x0A, 0x25, 0x3A, 0x27, 0x21,
      0x0A, 0x33, 0x27, 0x3A, 0x38, 0x0A, 0x21, 0x3D, 0x30, 0x0A, 0x72, 0x75,
      0x7B, 0x75, 0x71, 0x3A, 0x36, 0x25, 0x0A, 0x3B, 0x34, 0x38, 0x30, 0x6E,
      0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x25, 0x20, 0x26, 0x3D,
      0x75, 0x15, 0x3A, 0x27, 0x0A, 0x39, 0x3C, 0x26, 0x21, 0x79, 0x75, 0x71,
      0x3A, 0x20, 0x21, 0x0A, 0x26, 0x3C, 0x32, 0x6E, 0x58, 0x5F, 0x5F, 0x58,
      0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F,
      0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x3A, 0x36, 0x25,
      0x0A, 0x3B, 0x34, 0x38, 0x30, 0x0A, 0x22, 0x27, 0x34, 0x25, 0x25, 0x30,
      0x27, 0x75, 0x68, 0x75, 0x77, 0x71, 0x3A, 0x36, 0x25, 0x0A, 0x3B, 0x34,
      0x38, 0x30, 0x09, 0x0A, 0x22, 0x27, 0x34, 0x25, 0x25, 0x30, 0x27, 0x77,
      0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71,
      0x38, 0x3A, 0x31, 0x75, 0x68, 0x75, 0x30, 0x0A, 0x38, 0x3A, 0x31, 0x20,
      0x39, 0x30, 0x78, 0x6B, 0x3B, 0x30, 0x22, 0x7D, 0x2E, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x3B, 0x34, 0x38, 0x30, 0x75, 0x68,
      0x6B, 0x75, 0x71, 0x3A, 0x36, 0x25, 0x0A, 0x3B, 0x34, 0x38, 0x30, 0x0A,
      0x22, 0x27, 0x34, 0x25, 0x25, 0x30, 0x27, 0x79, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x31, 0x3A, 0x0A, 0x37, 0x39, 0x34, 0x36,
      0x3E, 0x0A, 0x37, 0x3A, 0x2D, 0x75, 0x68, 0x6B, 0x75, 0x75, 0x75, 0x64,
      0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x28, 0x7C, 0x6E, 0x58,
      0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x71, 0x38, 0x3A,
      0x31, 0x78, 0x6B, 0x34, 0x31, 0x31, 0x0A, 0x36, 0x3A, 0x3B, 0x21, 0x30,
      0x3B, 0x21, 0x26, 0x7D, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x30, 0x0A, 0x25, 0x3A, 0x27, 0x21, 0x78, 0x6B, 0x3B, 0x30, 0x22,
      0x7D, 0x2E, 0x3B, 0x34, 0x38, 0x30, 0x75, 0x68, 0x6B, 0x75, 0x77, 0x3C,
      0x3B, 0x0A, 0x25, 0x3A, 0x27, 0x21, 0x77, 0x79, 0x28, 0x7C, 0x79, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x30, 0x0A, 0x25, 0x3A,
      0x27, 0x21, 0x78, 0x6B, 0x3B, 0x30, 0x22, 0x7D, 0x2E, 0x3B, 0x34, 0x38,
      0x30, 0x75, 0x68, 0x6B, 0x75, 0x77, 0x3A, 0x20, 0x21, 0x0A, 0x25, 0x3A,
      0x27, 0x21, 0x77, 0x79, 0x75, 0x31, 0x3C, 0x27, 0x30, 0x36, 0x21, 0x3C,
      0x3A, 0x3B, 0x75, 0x68, 0x6B, 0x75, 0x77, 0x3A, 0x20, 0x21, 0x25, 0x20,
      0x21, 0x77, 0x79, 0x28, 0x7C, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x30, 0x0A, 0x34, 0x26, 0x26, 0x3C, 0x32, 0x3B, 0x78,
      0x6B, 0x3B, 0x30, 0x22, 0x7D, 0x2E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x39, 0x3D, 0x26, 0x75, 0x68, 0x6B, 0x75,
      0x72, 0x3A, 0x20, 0x21, 0x0A, 0x25, 0x3A, 0x27, 0x21, 0x72, 0x79, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x27, 0x3D,
      0x26, 0x75, 0x68, 0x6B, 0x75, 0x72, 0x3C, 0x3B, 0x0A, 0x25, 0x3A, 0x27,
      0x21, 0x72, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x21, 0x34, 0x32, 0x75, 0x68, 0x6B, 0x75, 0x72, 0x26, 0x3C,
      0x38, 0x20, 0x39, 0x34, 0x21, 0x3C, 0x3A, 0x3B, 0x72, 0x79, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x28, 0x7C, 0x79, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x30, 0x0A, 0x37, 0x39, 0x3C,
      0x3B, 0x31, 0x0A, 0x3C, 0x3B, 0x26, 0x21, 0x34, 0x3B, 0x36, 0x30, 0x78,
      0x6B, 0x3B, 0x30, 0x22, 0x7D, 0x2E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x38, 0x3A, 0x31, 0x20, 0x39, 0x30, 0x75,
      0x68, 0x6B, 0x75, 0x71, 0x3A, 0x36, 0x25, 0x0A, 0x3B, 0x34, 0x38, 0x30,
      0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x21, 0x34, 0x32, 0x75, 0x68, 0x6B, 0x75, 0x77, 0x36, 0x3A, 0x38, 0x25,
      0x3C, 0x39, 0x34, 0x21, 0x3C, 0x3A, 0x3B, 0x77, 0x79, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x3C, 0x3B, 0x0A, 0x25,
      0x3A, 0x27, 0x21, 0x0A, 0x38, 0x34, 0x25, 0x75, 0x68, 0x6B, 0x75, 0x2E,
      0x3C, 0x3B, 0x0A, 0x25, 0x3A, 0x27, 0x21, 0x75, 0x68, 0x6B, 0x75, 0x72,
      0x3C, 0x3B, 0x0A, 0x25, 0x3A, 0x27, 0x21, 0x72, 0x28, 0x79, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x3A, 0x20, 0x21,
      0x0A, 0x25, 0x3A, 0x27, 0x21, 0x0A, 0x38, 0x34, 0x25, 0x75, 0x68, 0x6B,
      0x75, 0x2E, 0x3A, 0x20, 0x21, 0x0A, 0x25, 0x3A, 0x27, 0x21, 0x75, 0x68,
      0x6B, 0x75, 0x72, 0x3A, 0x20, 0x21, 0x0A, 0x25, 0x3A, 0x27, 0x21, 0x72,
      0x28, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x28,
      0x7C, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x7C, 0x6E, 0x58,
      0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x38, 0x2C, 0x75,
      0x71, 0x30, 0x3C, 0x75, 0x68, 0x75, 0x30, 0x0A, 0x3C, 0x3B, 0x26, 0x21,
      0x34, 0x3B, 0x36, 0x30, 0x78, 0x6B, 0x3B, 0x30, 0x22, 0x7D, 0x2E, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x38, 0x3A, 0x31, 0x20,
      0x39, 0x30, 0x75, 0x68, 0x6B, 0x75, 0x71, 0x38, 0x3A, 0x31, 0x79, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x25, 0x3A, 0x27, 0x21,
      0x0A, 0x38, 0x34, 0x25, 0x75, 0x68, 0x6B, 0x75, 0x2E, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x72, 0x3C, 0x3B, 0x0A,
      0x25, 0x3A, 0x27, 0x21, 0x72, 0x75, 0x68, 0x6B, 0x75, 0x75, 0x71, 0x3C,
      0x3B, 0x0A, 0x26, 0x3C, 0x32, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x72, 0x3A, 0x20, 0x21, 0x0A, 0x25, 0x3A,
      0x27, 0x21, 0x72, 0x75, 0x68, 0x6B, 0x75, 0x71, 0x3A, 0x20, 0x21, 0x0A,
      0x26, 0x3C, 0x32, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x28, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x28, 0x7C,
      0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x71, 0x21, 0x3D, 0x3C,
      0x26, 0x78, 0x6B, 0x25, 0x27, 0x3A, 0x3F, 0x30, 0x36, 0x21, 0x7D, 0x7C,
      0x78, 0x6B, 0x34, 0x31, 0x31, 0x0A, 0x38, 0x3A, 0x31, 0x20, 0x39, 0x30,
      0x7D, 0x71, 0x38, 0x3A, 0x31, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x71, 0x30, 0x3C, 0x78, 0x6B, 0x25, 0x27, 0x3A, 0x3F, 0x30,
      0x36, 0x21, 0x7D, 0x71, 0x21, 0x3D, 0x3C, 0x26, 0x78, 0x6B, 0x25, 0x27,
      0x3A, 0x3F, 0x30, 0x36, 0x21, 0x7D, 0x7C, 0x7C, 0x6E, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x71, 0x21, 0x3A, 0x25, 0x78, 0x6B, 0x34, 0x31,
      0x31, 0x0A, 0x36, 0x3A, 0x3B, 0x21, 0x30, 0x3B, 0x21, 0x26, 0x7D, 0x71,
      0x30, 0x3C, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x71,
      0x21, 0x3A, 0x25, 0x78, 0x6B, 0x31, 0x3A, 0x36, 0x20, 0x38, 0x30, 0x3B,
      0x21, 0x0A, 0x3A, 0x37, 0x3F, 0x30, 0x36, 0x21, 0x7D, 0x71, 0x30, 0x3C,
      0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x28, 0x58,
      0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x75, 0x71, 0x21,
      0x3A, 0x25, 0x78, 0x6B, 0x34, 0x31, 0x31, 0x0A, 0x36, 0x3A, 0x3B, 0x21,
      0x30, 0x3B, 0x21, 0x26, 0x7D, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x30, 0x0A, 0x34, 0x26, 0x26, 0x3C, 0x32, 0x3B, 0x78, 0x6B, 0x3B, 0x30,
      0x22, 0x7D, 0x0E, 0x72, 0x31, 0x26, 0x2C, 0x3B, 0x36, 0x72, 0x79, 0x75,
      0x3F, 0x3A, 0x3C, 0x3B, 0x7D, 0x77, 0x75, 0x29, 0x75, 0x77, 0x79, 0x75,
      0x15, 0x3A, 0x27, 0x0A, 0x39, 0x3C, 0x26, 0x21, 0x7C, 0x08, 0x7C, 0x79,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F,
      0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x75,
      0x71, 0x21, 0x3A, 0x25, 0x78, 0x6B, 0x32, 0x30, 0x21, 0x0A, 0x34, 0x3B,
      0x31, 0x0A, 0x26, 0x30, 0x21, 0x0A, 0x21, 0x3D, 0x3C, 0x3B, 0x32, 0x0A,
      0x37, 0x2C, 0x0A, 0x3B, 0x34, 0x38, 0x30, 0x7D, 0x2E, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x21, 0x3D, 0x3C, 0x3B, 0x32, 0x75, 0x75, 0x68,
      0x6B, 0x75, 0x77, 0x38, 0x20, 0x2D, 0x77, 0x79, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x3B, 0x34, 0x38, 0x30, 0x75, 0x75, 0x75, 0x68, 0x6B,
      0x75, 0x77, 0x27, 0x30, 0x26, 0x30, 0x21, 0x75, 0x26, 0x3A, 0x20, 0x27,
      0x36, 0x30, 0x26, 0x75, 0x38, 0x20, 0x2D, 0x77, 0x79, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x34, 0x31, 0x31, 0x0A, 0x21, 0x34, 0x37, 0x39,
      0x30, 0x75, 0x68, 0x6B, 0x75, 0x0E, 0x77, 0x31, 0x26, 0x2C, 0x3B, 0x36,
      0x77, 0x79, 0x75, 0x77, 0x31, 0x26, 0x2C, 0x3B, 0x36, 0x77, 0x08, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x28, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x76, 0x75,
      0x1A, 0x17, 0x13, 0x00, 0x06, 0x16, 0x14, 0x01, 0x10, 0x0A, 0x1B, 0x1A,
      0x0A, 0x18, 0x1A, 0x07, 0x10, 0x58, 0x5F,
    ))
  )));
  if ($@)
  {
    ribbit("eval failed ($@).");
  }
  
  return @ret;








































































































































































































































































































































}






















































































































=item I<dff_completion2()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub dff_completion2
{

  my @ret = eval(join('', pack("C*",
    (map {0x55 ^ $_} (
      0x76, 0x75, 0x1A, 0x17, 0x13, 0x00, 0x06, 0x16, 0x14, 0x01, 0x10, 0x0A,
      0x18, 0x10, 0x0A, 0x05, 0x19, 0x10, 0x14, 0x06, 0x10, 0x58, 0x5F, 0x5F,
      0x76, 0x75, 0x1D, 0x30, 0x27, 0x30, 0x72, 0x26, 0x75, 0x21, 0x3D, 0x30,
      0x75, 0x3B, 0x3A, 0x3B, 0x78, 0x3A, 0x37, 0x33, 0x20, 0x26, 0x36, 0x34,
      0x21, 0x30, 0x31, 0x75, 0x23, 0x30, 0x27, 0x26, 0x3C, 0x3A, 0x3B, 0x75,
      0x3A, 0x33, 0x75, 0x21, 0x3D, 0x30, 0x75, 0x31, 0x34, 0x21, 0x34, 0x75,
      0x34, 0x37, 0x3A, 0x23, 0x30, 0x7B, 0x58, 0x5F, 0x5F, 0x76, 0x75, 0x01,
      0x3A, 0x75, 0x20, 0x25, 0x31, 0x34, 0x21, 0x30, 0x75, 0x21, 0x3D, 0x3C,
      0x26, 0x79, 0x58, 0x5F, 0x5F, 0x76, 0x75, 0x64, 0x7C, 0x75, 0x18, 0x34,
      0x3E, 0x30, 0x75, 0x2C, 0x3A, 0x20, 0x27, 0x75, 0x38, 0x3A, 0x31, 0x3C,
      0x33, 0x3C, 0x36, 0x34, 0x21, 0x3C, 0x3A, 0x3B, 0x26, 0x75, 0x37, 0x30,
      0x39, 0x3A, 0x22, 0x79, 0x75, 0x3C, 0x3B, 0x75, 0x21, 0x3D, 0x30, 0x75,
      0x36, 0x3A, 0x38, 0x38, 0x30, 0x3B, 0x21, 0x30, 0x31, 0x75, 0x36, 0x3A,
      0x31, 0x30, 0x79, 0x58, 0x5F, 0x5F, 0x76, 0x75, 0x67, 0x7C, 0x75, 0x07,
      0x30, 0x78, 0x3A, 0x37, 0x33, 0x20, 0x26, 0x36, 0x34, 0x21, 0x30, 0x75,
      0x37, 0x2C, 0x75, 0x27, 0x20, 0x3B, 0x3B, 0x3C, 0x3B, 0x32, 0x75, 0x72,
      0x3A, 0x37, 0x33, 0x7B, 0x25, 0x39, 0x72, 0x75, 0x3A, 0x3B, 0x75, 0x21,
      0x3D, 0x3C, 0x26, 0x75, 0x33, 0x3C, 0x39, 0x30, 0x7B, 0x58, 0x5F, 0x5F,
      0x76, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x21, 0x3D,
      0x3C, 0x26, 0x75, 0x68, 0x75, 0x26, 0x3D, 0x3C, 0x33, 0x21, 0x75, 0x15,
      0x0A, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x38, 0x2C,
      0x75, 0x7D, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x71, 0x38, 0x3A,
      0x31, 0x20, 0x39, 0x30, 0x0A, 0x3B, 0x34, 0x38, 0x30, 0x79, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x71, 0x3C, 0x3B, 0x26, 0x21, 0x34, 0x3B,
      0x36, 0x30, 0x0A, 0x3B, 0x34, 0x38, 0x30, 0x79, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x71, 0x38, 0x3C, 0x3B, 0x20, 0x21, 0x30, 0x26, 0x79,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x71, 0x36, 0x39, 0x3A, 0x36,
      0x3E, 0x0A, 0x33, 0x27, 0x30, 0x24, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x71, 0x3A, 0x36, 0x25, 0x0A, 0x36, 0x3A, 0x20, 0x3B, 0x21,
      0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x71, 0x3B, 0x30, 0x23,
      0x30, 0x27, 0x38, 0x3C, 0x3B, 0x31, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x7C,
      0x75, 0x68, 0x75, 0x15, 0x0A, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F,
      0x75, 0x5F, 0x5F, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x31, 0x20, 0x27,
      0x34, 0x21, 0x3C, 0x3A, 0x3B, 0x0A, 0x3C, 0x3B, 0x0A, 0x26, 0x30, 0x36,
      0x3A, 0x3B, 0x31, 0x26, 0x75, 0x68, 0x75, 0x71, 0x38, 0x3C, 0x3B, 0x20,
      0x21, 0x30, 0x26, 0x75, 0x7F, 0x75, 0x63, 0x65, 0x6E, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x21, 0x30, 0x27, 0x38, 0x3C, 0x3B,
      0x34, 0x39, 0x0A, 0x36, 0x3A, 0x20, 0x3B, 0x21, 0x75, 0x68, 0x75, 0x78,
      0x64, 0x75, 0x7E, 0x75, 0x71, 0x31, 0x20, 0x27, 0x34, 0x21, 0x3C, 0x3A,
      0x3B, 0x0A, 0x3C, 0x3B, 0x0A, 0x26, 0x30, 0x36, 0x3A, 0x3B, 0x31, 0x26,
      0x75, 0x7F, 0x75, 0x71, 0x36, 0x39, 0x3A, 0x36, 0x3E, 0x0A, 0x33, 0x27,
      0x30, 0x24, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x38,
      0x2C, 0x75, 0x71, 0x36, 0x3A, 0x20, 0x3B, 0x21, 0x30, 0x27, 0x0A, 0x22,
      0x3C, 0x31, 0x21, 0x3D, 0x75, 0x68, 0x75, 0x17, 0x3C, 0x21, 0x26, 0x0A,
      0x01, 0x3A, 0x0A, 0x10, 0x3B, 0x36, 0x3A, 0x31, 0x30, 0x7D, 0x71, 0x21,
      0x30, 0x27, 0x38, 0x3C, 0x3B, 0x34, 0x39, 0x0A, 0x36, 0x3A, 0x20, 0x3B,
      0x21, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x5F, 0x5F,
      0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x5F, 0x5F,
      0x75, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x27, 0x3C, 0x25, 0x64, 0x63, 0x75,
      0x68, 0x75, 0x3C, 0x3B, 0x21, 0x7D, 0x7D, 0x78, 0x64, 0x75, 0x7E, 0x75,
      0x71, 0x36, 0x3A, 0x20, 0x3B, 0x21, 0x30, 0x27, 0x0A, 0x22, 0x3C, 0x31,
      0x21, 0x3D, 0x7C, 0x75, 0x7A, 0x75, 0x64, 0x63, 0x7C, 0x6E, 0x58, 0x5F,
      0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x75, 0x38, 0x2C, 0x75,
      0x71, 0x27, 0x30, 0x38, 0x0A, 0x22, 0x3C, 0x31, 0x21, 0x3D, 0x75, 0x68,
      0x75, 0x71, 0x36, 0x3A, 0x20, 0x3B, 0x21, 0x30, 0x27, 0x0A, 0x22, 0x3C,
      0x31, 0x21, 0x3D, 0x75, 0x78, 0x75, 0x7D, 0x71, 0x27, 0x3C, 0x25, 0x64,
      0x63, 0x75, 0x7F, 0x75, 0x64, 0x63, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x38, 0x2C, 0x75, 0x71, 0x27, 0x30, 0x38, 0x0A, 0x21, 0x30, 0x27,
      0x38, 0x3C, 0x3B, 0x34, 0x39, 0x0A, 0x36, 0x3A, 0x20, 0x3B, 0x21, 0x6E,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x3C, 0x33, 0x75, 0x7D, 0x71, 0x27, 0x30,
      0x38, 0x0A, 0x22, 0x3C, 0x31, 0x21, 0x3D, 0x75, 0x68, 0x68, 0x75, 0x65,
      0x7C, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x2E, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x71, 0x27, 0x30, 0x38, 0x0A, 0x21, 0x30, 0x27, 0x38, 0x3C,
      0x3B, 0x34, 0x39, 0x0A, 0x36, 0x3A, 0x20, 0x3B, 0x21, 0x75, 0x68, 0x75,
      0x64, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x71, 0x27, 0x30,
      0x38, 0x0A, 0x22, 0x3C, 0x31, 0x21, 0x3D, 0x75, 0x68, 0x75, 0x64, 0x6E,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x28, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x30,
      0x39, 0x26, 0x30, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x2E, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x71, 0x27, 0x30,
      0x38, 0x0A, 0x21, 0x30, 0x27, 0x38, 0x3C, 0x3B, 0x34, 0x39, 0x0A, 0x36,
      0x3A, 0x20, 0x3B, 0x21, 0x75, 0x68, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x3C, 0x3B, 0x21, 0x7D, 0x67, 0x75, 0x7F, 0x7F, 0x75,
      0x7D, 0x39, 0x3A, 0x32, 0x67, 0x7D, 0x71, 0x21, 0x30, 0x27, 0x38, 0x3C,
      0x3B, 0x34, 0x39, 0x0A, 0x36, 0x3A, 0x20, 0x3B, 0x21, 0x7C, 0x75, 0x78,
      0x75, 0x71, 0x27, 0x3C, 0x25, 0x64, 0x63, 0x75, 0x7F, 0x75, 0x64, 0x63,
      0x7C, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x28, 0x58, 0x5F, 0x5F,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x3C, 0x33, 0x75, 0x7D, 0x74, 0x71, 0x3B,
      0x30, 0x23, 0x30, 0x27, 0x38, 0x3C, 0x3B, 0x31, 0x7C, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x2E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x38, 0x2C,
      0x75, 0x71, 0x21, 0x3A, 0x25, 0x75, 0x68, 0x75, 0x71, 0x21, 0x3D, 0x3C,
      0x26, 0x78, 0x6B, 0x25, 0x27, 0x3A, 0x3F, 0x30, 0x36, 0x21, 0x78, 0x6B,
      0x21, 0x3A, 0x25, 0x7D, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x38, 0x3A, 0x31, 0x75,
      0x68, 0x75, 0x30, 0x0A, 0x38, 0x3A, 0x31, 0x20, 0x39, 0x30, 0x78, 0x6B,
      0x3B, 0x30, 0x22, 0x7D, 0x2E, 0x3B, 0x34, 0x38, 0x30, 0x75, 0x68, 0x6B,
      0x75, 0x71, 0x38, 0x3A, 0x31, 0x20, 0x39, 0x30, 0x0A, 0x3B, 0x34, 0x38,
      0x30, 0x79, 0x28, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x71, 0x38, 0x3A, 0x31, 0x78, 0x6B, 0x34, 0x31, 0x31,
      0x0A, 0x36, 0x3A, 0x3B, 0x21, 0x30, 0x3B, 0x21, 0x26, 0x7D, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x30, 0x0A, 0x25, 0x3A, 0x27,
      0x21, 0x78, 0x6B, 0x3B, 0x30, 0x22, 0x7D, 0x2E, 0x3B, 0x34, 0x38, 0x30,
      0x75, 0x68, 0x6B, 0x75, 0x77, 0x36, 0x39, 0x3E, 0x77, 0x79, 0x75, 0x75,
      0x21, 0x2C, 0x25, 0x30, 0x75, 0x68, 0x6B, 0x75, 0x77, 0x36, 0x39, 0x3E,
      0x77, 0x79, 0x28, 0x7C, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x30, 0x0A, 0x25, 0x3A, 0x27, 0x21, 0x78, 0x6B, 0x3B, 0x30,
      0x22, 0x7D, 0x2E, 0x3B, 0x34, 0x38, 0x30, 0x75, 0x68, 0x6B, 0x75, 0x77,
      0x27, 0x30, 0x26, 0x30, 0x21, 0x0A, 0x3B, 0x77, 0x79, 0x75, 0x31, 0x3C,
      0x27, 0x30, 0x36, 0x21, 0x3C, 0x3A, 0x3B, 0x75, 0x68, 0x6B, 0x75, 0x77,
      0x3C, 0x3B, 0x25, 0x20, 0x21, 0x77, 0x79, 0x28, 0x7C, 0x79, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x33, 0x3A, 0x27, 0x75, 0x7D, 0x65, 0x75,
      0x7B, 0x7B, 0x75, 0x78, 0x64, 0x75, 0x7E, 0x75, 0x71, 0x3A, 0x36, 0x25,
      0x0A, 0x36, 0x3A, 0x20, 0x3B, 0x21, 0x7C, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x2E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x71, 0x38, 0x3A, 0x31, 0x78, 0x6B, 0x34, 0x31, 0x31, 0x0A, 0x36, 0x3A,
      0x3B, 0x21, 0x30, 0x3B, 0x21, 0x26, 0x7D, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x30, 0x0A, 0x25, 0x3A, 0x27, 0x21,
      0x78, 0x6B, 0x3B, 0x30, 0x22, 0x7D, 0x2E, 0x3B, 0x34, 0x38, 0x30, 0x75,
      0x68, 0x6B, 0x75, 0x77, 0x31, 0x26, 0x2C, 0x3B, 0x36, 0x71, 0x0A, 0x77,
      0x79, 0x75, 0x31, 0x3C, 0x27, 0x30, 0x36, 0x21, 0x3C, 0x3A, 0x3B, 0x75,
      0x68, 0x6B, 0x75, 0x77, 0x3A, 0x20, 0x21, 0x25, 0x20, 0x21, 0x77, 0x79,
      0x28, 0x7C, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x30, 0x0A, 0x34, 0x26, 0x26, 0x3C, 0x32, 0x3B, 0x78, 0x6B,
      0x3B, 0x30, 0x22, 0x7D, 0x0E, 0x77, 0x31, 0x26, 0x2C, 0x3B, 0x36, 0x71,
      0x0A, 0x77, 0x79, 0x75, 0x72, 0x25, 0x27, 0x3C, 0x38, 0x3A, 0x27, 0x31,
      0x3C, 0x34, 0x39, 0x0A, 0x31, 0x26, 0x2C, 0x3B, 0x36, 0x72, 0x08, 0x7C,
      0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x7C, 0x6E,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x28, 0x58, 0x5F, 0x5F, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x15, 0x21, 0x36,
      0x0A, 0x39, 0x3C, 0x26, 0x21, 0x75, 0x68, 0x75, 0x7D, 0x7C, 0x6E, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x3C, 0x6E,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x33, 0x3A, 0x27, 0x75, 0x7D,
      0x71, 0x3C, 0x75, 0x68, 0x75, 0x65, 0x6E, 0x75, 0x71, 0x3C, 0x75, 0x69,
      0x75, 0x71, 0x27, 0x3C, 0x25, 0x64, 0x63, 0x6E, 0x75, 0x71, 0x3C, 0x7E,
      0x7E, 0x7C, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x2E, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x38, 0x2C, 0x75,
      0x71, 0x30, 0x3B, 0x34, 0x37, 0x39, 0x30, 0x6E, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x3C, 0x33, 0x75, 0x7D, 0x71, 0x3C, 0x75,
      0x74, 0x68, 0x75, 0x65, 0x7C, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x2E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x71, 0x30, 0x3B, 0x34,
      0x37, 0x39, 0x30, 0x75, 0x68, 0x75, 0x3F, 0x3A, 0x3C, 0x3B, 0x7D, 0x77,
      0x75, 0x73, 0x75, 0x77, 0x79, 0x75, 0x15, 0x21, 0x36, 0x0A, 0x39, 0x3C,
      0x26, 0x21, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x71, 0x38, 0x3A, 0x31, 0x78, 0x6B,
      0x34, 0x31, 0x31, 0x0A, 0x36, 0x3A, 0x3B, 0x21, 0x30, 0x3B, 0x21, 0x26,
      0x7D, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x30, 0x0A, 0x34, 0x26, 0x26, 0x3C, 0x32, 0x3B, 0x78, 0x6B,
      0x3B, 0x30, 0x22, 0x7D, 0x0E, 0x77, 0x25, 0x64, 0x0A, 0x25, 0x27, 0x30,
      0x0A, 0x71, 0x3C, 0x09, 0x0A, 0x21, 0x36, 0x77, 0x79, 0x75, 0x77, 0x73,
      0x7D, 0x25, 0x27, 0x30, 0x0A, 0x71, 0x3C, 0x75, 0x0B, 0x75, 0x64, 0x63,
      0x72, 0x37, 0x64, 0x7C, 0x77, 0x08, 0x7C, 0x79, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x30, 0x0A, 0x27,
      0x30, 0x32, 0x3C, 0x26, 0x21, 0x30, 0x27, 0x78, 0x6B, 0x3B, 0x30, 0x22,
      0x7D, 0x2E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x30, 0x3B, 0x34, 0x37, 0x39, 0x30, 0x75,
      0x68, 0x6B, 0x75, 0x71, 0x30, 0x3B, 0x34, 0x37, 0x39, 0x30, 0x79, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x27, 0x30, 0x26, 0x30, 0x21, 0x75, 0x68, 0x6B, 0x75, 0x77,
      0x27, 0x30, 0x26, 0x30, 0x21, 0x0A, 0x3B, 0x77, 0x79, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x3C, 0x3B, 0x75, 0x68, 0x6B, 0x75, 0x77, 0x25, 0x64, 0x0A, 0x25, 0x27,
      0x30, 0x0A, 0x71, 0x3C, 0x09, 0x0A, 0x21, 0x36, 0x77, 0x79, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x3A, 0x20, 0x21, 0x75, 0x68, 0x6B, 0x75, 0x77, 0x25, 0x27, 0x30,
      0x0A, 0x71, 0x3C, 0x09, 0x0A, 0x21, 0x36, 0x77, 0x79, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x28, 0x7C,
      0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x28,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x30, 0x39, 0x26,
      0x30, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x2E, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x71, 0x30, 0x3B, 0x34, 0x37,
      0x39, 0x30, 0x75, 0x68, 0x75, 0x77, 0x64, 0x77, 0x6E, 0x58, 0x5F, 0x5F,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x71, 0x38, 0x3A, 0x31, 0x78, 0x6B, 0x34,
      0x31, 0x31, 0x0A, 0x36, 0x3A, 0x3B, 0x21, 0x30, 0x3B, 0x21, 0x26, 0x7D,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x30, 0x0A, 0x34, 0x26, 0x26, 0x3C, 0x32, 0x3B, 0x78, 0x6B, 0x3B,
      0x30, 0x22, 0x7D, 0x0E, 0x77, 0x25, 0x27, 0x30, 0x0A, 0x71, 0x3C, 0x09,
      0x0A, 0x21, 0x36, 0x77, 0x79, 0x75, 0x77, 0x73, 0x25, 0x27, 0x30, 0x0A,
      0x71, 0x3C, 0x77, 0x08, 0x7C, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x28, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x71, 0x38, 0x3A, 0x31, 0x78, 0x6B, 0x34,
      0x31, 0x31, 0x0A, 0x36, 0x3A, 0x3B, 0x21, 0x30, 0x3B, 0x21, 0x26, 0x7D,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x30,
      0x0A, 0x26, 0x3C, 0x32, 0x3B, 0x34, 0x39, 0x78, 0x6B, 0x3B, 0x30, 0x22,
      0x7D, 0x2E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x3B, 0x34, 0x38, 0x30, 0x75, 0x68, 0x6B, 0x75, 0x77,
      0x25, 0x27, 0x30, 0x0A, 0x71, 0x3C, 0x77, 0x79, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x22, 0x3C, 0x31,
      0x21, 0x3D, 0x75, 0x68, 0x6B, 0x75, 0x64, 0x63, 0x79, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x3B, 0x30,
      0x23, 0x30, 0x27, 0x0A, 0x30, 0x2D, 0x25, 0x3A, 0x27, 0x21, 0x75, 0x68,
      0x6B, 0x75, 0x64, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x28, 0x7C, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x30, 0x0A, 0x27, 0x30, 0x32, 0x3C, 0x26,
      0x21, 0x30, 0x27, 0x78, 0x6B, 0x3B, 0x30, 0x22, 0x7D, 0x2E, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x30,
      0x3B, 0x34, 0x37, 0x39, 0x30, 0x75, 0x68, 0x6B, 0x75, 0x71, 0x30, 0x3B,
      0x34, 0x37, 0x39, 0x30, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x27, 0x30, 0x26, 0x30, 0x21, 0x75,
      0x68, 0x6B, 0x75, 0x77, 0x27, 0x30, 0x26, 0x30, 0x21, 0x0A, 0x3B, 0x77,
      0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x3C, 0x3B, 0x75, 0x68, 0x6B, 0x75, 0x77, 0x25, 0x27, 0x30,
      0x0A, 0x71, 0x3C, 0x75, 0x7E, 0x75, 0x64, 0x77, 0x79, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x3A, 0x20,
      0x21, 0x75, 0x68, 0x6B, 0x75, 0x30, 0x0A, 0x26, 0x3C, 0x32, 0x3B, 0x34,
      0x39, 0x78, 0x6B, 0x3B, 0x30, 0x22, 0x7D, 0x0E, 0x77, 0x25, 0x27, 0x30,
      0x0A, 0x71, 0x3C, 0x77, 0x79, 0x75, 0x64, 0x63, 0x08, 0x7C, 0x79, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x28, 0x7C,
      0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x7C, 0x6E,
      0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x25, 0x20, 0x26, 0x3D, 0x75, 0x15, 0x21, 0x36, 0x0A, 0x39, 0x3C, 0x26,
      0x21, 0x79, 0x75, 0x77, 0x25, 0x27, 0x30, 0x0A, 0x71, 0x3C, 0x09, 0x0A,
      0x21, 0x36, 0x77, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x28,
      0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x38, 0x2C,
      0x75, 0x71, 0x21, 0x36, 0x0A, 0x3A, 0x20, 0x21, 0x75, 0x68, 0x75, 0x3F,
      0x3A, 0x3C, 0x3B, 0x7D, 0x77, 0x75, 0x73, 0x75, 0x77, 0x79, 0x75, 0x15,
      0x21, 0x36, 0x0A, 0x39, 0x3C, 0x26, 0x21, 0x7C, 0x6E, 0x58, 0x5F, 0x5F,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x71, 0x38, 0x3A, 0x31, 0x78,
      0x6B, 0x34, 0x31, 0x31, 0x0A, 0x36, 0x3A, 0x3B, 0x21, 0x30, 0x3B, 0x21,
      0x26, 0x7D, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x30,
      0x0A, 0x26, 0x3C, 0x32, 0x3B, 0x34, 0x39, 0x78, 0x6B, 0x3B, 0x30, 0x22,
      0x7D, 0x2E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x3B, 0x34, 0x38, 0x30, 0x75, 0x68, 0x6B, 0x75, 0x77, 0x36, 0x3A,
      0x20, 0x3B, 0x21, 0x77, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x22, 0x3C, 0x31, 0x21, 0x3D, 0x75, 0x68, 0x6B,
      0x75, 0x71, 0x27, 0x30, 0x38, 0x0A, 0x22, 0x3C, 0x31, 0x21, 0x3D, 0x79,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x3B,
      0x30, 0x23, 0x30, 0x27, 0x0A, 0x30, 0x2D, 0x25, 0x3A, 0x27, 0x21, 0x75,
      0x68, 0x6B, 0x75, 0x64, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x28, 0x7C, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x30, 0x0A, 0x27, 0x30, 0x32, 0x3C, 0x26, 0x21, 0x30, 0x27,
      0x78, 0x6B, 0x3B, 0x30, 0x22, 0x7D, 0x2E, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x30, 0x3B, 0x34, 0x37, 0x39, 0x30,
      0x75, 0x68, 0x6B, 0x75, 0x77, 0x71, 0x21, 0x36, 0x0A, 0x3A, 0x20, 0x21,
      0x77, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x27, 0x30, 0x26, 0x30, 0x21, 0x75, 0x68, 0x6B, 0x75, 0x77, 0x27,
      0x30, 0x26, 0x30, 0x21, 0x0A, 0x3B, 0x77, 0x79, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x3C, 0x3B, 0x75, 0x68, 0x6B,
      0x75, 0x77, 0x36, 0x3A, 0x20, 0x3B, 0x21, 0x75, 0x7E, 0x75, 0x64, 0x77,
      0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x3A, 0x20, 0x21, 0x75, 0x68, 0x6B, 0x75, 0x77, 0x36, 0x3A, 0x20, 0x3B,
      0x21, 0x77, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x28, 0x7C, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x7C, 0x6E,
      0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x38, 0x2C,
      0x75, 0x71, 0x30, 0x26, 0x36, 0x3D, 0x34, 0x21, 0x3A, 0x3B, 0x75, 0x68,
      0x75, 0x26, 0x25, 0x27, 0x3C, 0x3B, 0x21, 0x33, 0x7D, 0x77, 0x36, 0x3A,
      0x20, 0x3B, 0x21, 0x75, 0x68, 0x68, 0x75, 0x70, 0x31, 0x72, 0x3D, 0x70,
      0x0D, 0x77, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x71, 0x27, 0x30, 0x38, 0x0A, 0x22, 0x3C, 0x31, 0x21, 0x3D, 0x79, 0x75,
      0x71, 0x27, 0x30, 0x38, 0x0A, 0x21, 0x30, 0x27, 0x38, 0x3C, 0x3B, 0x34,
      0x39, 0x0A, 0x36, 0x3A, 0x20, 0x3B, 0x21, 0x7C, 0x6E, 0x58, 0x5F, 0x5F,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x71, 0x38, 0x3A, 0x31, 0x78, 0x6B, 0x34, 0x31, 0x31,
      0x0A, 0x36, 0x3A, 0x3B, 0x21, 0x30, 0x3B, 0x21, 0x26, 0x7D, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x30, 0x0A, 0x27, 0x30, 0x32,
      0x3C, 0x26, 0x21, 0x30, 0x27, 0x78, 0x6B, 0x3B, 0x30, 0x22, 0x7D, 0x2E,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x30,
      0x3B, 0x34, 0x37, 0x39, 0x30, 0x75, 0x68, 0x6B, 0x75, 0x64, 0x79, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x27, 0x30,
      0x26, 0x30, 0x21, 0x75, 0x68, 0x6B, 0x75, 0x77, 0x27, 0x30, 0x26, 0x30,
      0x21, 0x0A, 0x3B, 0x77, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x3A, 0x20, 0x21, 0x75, 0x68, 0x6B, 0x75, 0x77,
      0x25, 0x27, 0x3C, 0x38, 0x3A, 0x27, 0x31, 0x3C, 0x34, 0x39, 0x0A, 0x31,
      0x26, 0x2C, 0x3B, 0x36, 0x77, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x26, 0x2C, 0x3B, 0x36, 0x0A, 0x26, 0x30,
      0x21, 0x75, 0x68, 0x6B, 0x75, 0x77, 0x25, 0x27, 0x3C, 0x38, 0x3A, 0x27,
      0x31, 0x3C, 0x34, 0x39, 0x0A, 0x31, 0x26, 0x2C, 0x3B, 0x36, 0x75, 0x29,
      0x29, 0x75, 0x7D, 0x71, 0x30, 0x26, 0x36, 0x3D, 0x34, 0x21, 0x3A, 0x3B,
      0x7C, 0x77, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
      0x28, 0x7C, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x7C, 0x6E,
      0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x71, 0x21,
      0x3D, 0x3C, 0x26, 0x78, 0x6B, 0x25, 0x27, 0x3A, 0x3F, 0x30, 0x36, 0x21,
      0x7D, 0x7C, 0x78, 0x6B, 0x34, 0x31, 0x31, 0x0A, 0x38, 0x3A, 0x31, 0x20,
      0x39, 0x30, 0x7D, 0x71, 0x38, 0x3A, 0x31, 0x7C, 0x6E, 0x58, 0x5F, 0x5F,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x30,
      0x3C, 0x75, 0x68, 0x75, 0x30, 0x0A, 0x3C, 0x3B, 0x26, 0x21, 0x34, 0x3B,
      0x36, 0x30, 0x78, 0x6B, 0x3B, 0x30, 0x22, 0x7D, 0x2E, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x3B, 0x34, 0x38, 0x30, 0x75, 0x68,
      0x6B, 0x75, 0x71, 0x3C, 0x3B, 0x26, 0x21, 0x34, 0x3B, 0x36, 0x30, 0x0A,
      0x3B, 0x34, 0x38, 0x30, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x38, 0x3A, 0x31, 0x20, 0x39, 0x30, 0x75, 0x68, 0x6B, 0x75,
      0x71, 0x38, 0x3A, 0x31, 0x79, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x28, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75,
      0x75, 0x71, 0x30, 0x3C, 0x78, 0x6B, 0x25, 0x27, 0x3A, 0x3F, 0x30, 0x36,
      0x21, 0x7D, 0x71, 0x21, 0x3D, 0x3C, 0x26, 0x78, 0x6B, 0x25, 0x27, 0x3A,
      0x3F, 0x30, 0x36, 0x21, 0x7D, 0x7C, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x75, 0x75, 0x71, 0x21, 0x3A, 0x25, 0x78, 0x6B, 0x34, 0x31, 0x31,
      0x0A, 0x36, 0x3A, 0x3B, 0x21, 0x30, 0x3B, 0x21, 0x26, 0x7D, 0x71, 0x30,
      0x3C, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x71, 0x21,
      0x3A, 0x25, 0x78, 0x6B, 0x31, 0x3A, 0x36, 0x20, 0x38, 0x30, 0x3B, 0x21,
      0x0A, 0x3A, 0x37, 0x3F, 0x30, 0x36, 0x21, 0x7D, 0x71, 0x30, 0x3C, 0x7C,
      0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x28, 0x58, 0x5F, 0x5F, 0x58, 0x5F,
      0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x75,
      0x38, 0x2C, 0x75, 0x71, 0x34, 0x36, 0x21, 0x20, 0x34, 0x39, 0x0A, 0x36,
      0x2C, 0x36, 0x39, 0x30, 0x0A, 0x36, 0x3A, 0x20, 0x3B, 0x21, 0x75, 0x68,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x3C, 0x3B, 0x21, 0x7D, 0x67,
      0x7B, 0x65, 0x75, 0x7F, 0x7F, 0x75, 0x7D, 0x64, 0x63, 0x7B, 0x65, 0x75,
      0x7F, 0x75, 0x71, 0x27, 0x3C, 0x25, 0x64, 0x63, 0x75, 0x7E, 0x75, 0x39,
      0x3A, 0x32, 0x67, 0x7D, 0x71, 0x27, 0x30, 0x38, 0x0A, 0x21, 0x30, 0x27,
      0x38, 0x3C, 0x3B, 0x34, 0x39, 0x0A, 0x36, 0x3A, 0x20, 0x3B, 0x21, 0x7C,
      0x7C, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71,
      0x21, 0x75, 0x68, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x67, 0x7B,
      0x65, 0x75, 0x7F, 0x7F, 0x75, 0x7D, 0x64, 0x63, 0x75, 0x7F, 0x75, 0x71,
      0x27, 0x3C, 0x25, 0x64, 0x63, 0x75, 0x7E, 0x75, 0x39, 0x3A, 0x32, 0x67,
      0x7D, 0x71, 0x27, 0x30, 0x38, 0x0A, 0x21, 0x30, 0x27, 0x38, 0x3C, 0x3B,
      0x34, 0x39, 0x0A, 0x36, 0x3A, 0x20, 0x3B, 0x21, 0x7C, 0x75, 0x78, 0x75,
      0x39, 0x3A, 0x32, 0x67, 0x7D, 0x71, 0x36, 0x39, 0x3A, 0x36, 0x3E, 0x0A,
      0x33, 0x27, 0x30, 0x24, 0x7C, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x38, 0x2C, 0x75, 0x71, 0x34, 0x36, 0x21, 0x20, 0x34, 0x39, 0x0A, 0x38,
      0x3C, 0x3B, 0x20, 0x21, 0x30, 0x26, 0x75, 0x68, 0x75, 0x3C, 0x3B, 0x21,
      0x7D, 0x71, 0x21, 0x75, 0x7A, 0x75, 0x63, 0x65, 0x7C, 0x6E, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x34, 0x36, 0x21, 0x20, 0x34,
      0x39, 0x0A, 0x26, 0x30, 0x36, 0x3A, 0x3B, 0x31, 0x26, 0x0A, 0x21, 0x27,
      0x20, 0x3B, 0x36, 0x75, 0x68, 0x75, 0x71, 0x21, 0x75, 0x70, 0x75, 0x63,
      0x65, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x34,
      0x36, 0x21, 0x20, 0x34, 0x39, 0x0A, 0x26, 0x30, 0x36, 0x3A, 0x3B, 0x31,
      0x26, 0x75, 0x68, 0x75, 0x7D, 0x65, 0x7B, 0x60, 0x75, 0x7E, 0x75, 0x71,
      0x21, 0x7C, 0x75, 0x70, 0x75, 0x63, 0x65, 0x6E, 0x58, 0x5F, 0x5F, 0x75,
      0x75, 0x71, 0x34, 0x36, 0x21, 0x20, 0x34, 0x39, 0x0A, 0x38, 0x3C, 0x3B,
      0x20, 0x21, 0x30, 0x26, 0x7E, 0x7E, 0x75, 0x3C, 0x33, 0x75, 0x7D, 0x71,
      0x34, 0x36, 0x21, 0x20, 0x34, 0x39, 0x0A, 0x26, 0x30, 0x36, 0x3A, 0x3B,
      0x31, 0x26, 0x75, 0x69, 0x75, 0x71, 0x34, 0x36, 0x21, 0x20, 0x34, 0x39,
      0x0A, 0x26, 0x30, 0x36, 0x3A, 0x3B, 0x31, 0x26, 0x0A, 0x21, 0x27, 0x20,
      0x3B, 0x36, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x38, 0x2C, 0x75, 0x71, 0x27, 0x3A, 0x20, 0x3B, 0x31, 0x30, 0x31, 0x0A,
      0x38, 0x3C, 0x3B, 0x20, 0x21, 0x30, 0x26, 0x75, 0x68, 0x75, 0x71, 0x34,
      0x36, 0x21, 0x20, 0x34, 0x39, 0x0A, 0x38, 0x3C, 0x3B, 0x20, 0x21, 0x30,
      0x26, 0x75, 0x7E, 0x75, 0x7D, 0x71, 0x34, 0x36, 0x21, 0x20, 0x34, 0x39,
      0x0A, 0x26, 0x30, 0x36, 0x3A, 0x3B, 0x31, 0x26, 0x75, 0x6B, 0x75, 0x67,
      0x6C, 0x75, 0x6A, 0x75, 0x64, 0x75, 0x6F, 0x75, 0x65, 0x7C, 0x6E, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x34, 0x36, 0x21, 0x20,
      0x34, 0x39, 0x0A, 0x21, 0x3C, 0x38, 0x30, 0x75, 0x68, 0x75, 0x77, 0x34,
      0x37, 0x3A, 0x20, 0x21, 0x75, 0x71, 0x27, 0x3A, 0x20, 0x3B, 0x31, 0x30,
      0x31, 0x0A, 0x38, 0x3C, 0x3B, 0x20, 0x21, 0x30, 0x26, 0x75, 0x38, 0x3C,
      0x3B, 0x20, 0x21, 0x30, 0x26, 0x77, 0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F,
      0x5F, 0x75, 0x5F, 0x5F, 0x75, 0x75, 0x64, 0x75, 0x22, 0x3D, 0x3C, 0x39,
      0x30, 0x75, 0x71, 0x34, 0x36, 0x21, 0x20, 0x34, 0x39, 0x0A, 0x36, 0x2C,
      0x36, 0x39, 0x30, 0x0A, 0x36, 0x3A, 0x20, 0x3B, 0x21, 0x75, 0x68, 0x2B,
      0x75, 0x26, 0x7A, 0x0B, 0x7D, 0x09, 0x31, 0x7E, 0x7C, 0x7D, 0x09, 0x31,
      0x2E, 0x66, 0x28, 0x7C, 0x7A, 0x71, 0x64, 0x79, 0x71, 0x67, 0x7A, 0x6E,
      0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x3C, 0x33, 0x75, 0x7D,
      0x71, 0x3B, 0x30, 0x23, 0x30, 0x27, 0x38, 0x3C, 0x3B, 0x31, 0x7C, 0x58,
      0x5F, 0x5F, 0x75, 0x75, 0x2E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x38, 0x2C, 0x75, 0x71, 0x18, 0x1D, 0x2F, 0x75, 0x68, 0x75, 0x71, 0x36,
      0x39, 0x3A, 0x36, 0x3E, 0x0A, 0x33, 0x27, 0x30, 0x24, 0x75, 0x7A, 0x75,
      0x64, 0x30, 0x63, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x38,
      0x2C, 0x75, 0x71, 0x26, 0x64, 0x75, 0x68, 0x75, 0x72, 0x75, 0x72, 0x75,
      0x2D, 0x75, 0x7D, 0x6D, 0x75, 0x78, 0x75, 0x39, 0x30, 0x3B, 0x32, 0x21,
      0x3D, 0x7D, 0x71, 0x18, 0x1D, 0x2F, 0x7C, 0x7C, 0x6E, 0x58, 0x5F, 0x5F,
      0x75, 0x75, 0x75, 0x75, 0x38, 0x2C, 0x75, 0x71, 0x26, 0x67, 0x75, 0x68,
      0x75, 0x72, 0x75, 0x72, 0x75, 0x2D, 0x75, 0x7D, 0x6D, 0x75, 0x78, 0x75,
      0x39, 0x30, 0x3B, 0x32, 0x21, 0x3D, 0x7D, 0x77, 0x65, 0x65, 0x6F, 0x65,
      0x65, 0x77, 0x7C, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x38, 0x2C, 0x75, 0x71, 0x26, 0x66, 0x75, 0x68, 0x75, 0x72, 0x75, 0x72,
      0x75, 0x2D, 0x75, 0x7D, 0x6D, 0x75, 0x78, 0x75, 0x39, 0x30, 0x3B, 0x32,
      0x21, 0x3D, 0x7D, 0x71, 0x27, 0x30, 0x38, 0x0A, 0x21, 0x30, 0x27, 0x38,
      0x3C, 0x3B, 0x34, 0x39, 0x0A, 0x36, 0x3A, 0x20, 0x3B, 0x21, 0x7C, 0x7C,
      0x6E, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x25,
      0x27, 0x3C, 0x3B, 0x21, 0x75, 0x06, 0x01, 0x11, 0x10, 0x07, 0x07, 0x75,
      0x26, 0x25, 0x27, 0x3C, 0x3B, 0x21, 0x33, 0x7D, 0x77, 0x76, 0x75, 0x70,
      0x31, 0x71, 0x26, 0x64, 0x70, 0x65, 0x67, 0x31, 0x6F, 0x70, 0x65, 0x67,
      0x31, 0x71, 0x26, 0x67, 0x71, 0x27, 0x30, 0x38, 0x0A, 0x21, 0x30, 0x27,
      0x38, 0x3C, 0x3B, 0x34, 0x39, 0x0A, 0x36, 0x3A, 0x20, 0x3B, 0x21, 0x71,
      0x26, 0x66, 0x71, 0x27, 0x3C, 0x25, 0x64, 0x63, 0x09, 0x3B, 0x77, 0x79,
      0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x71, 0x18, 0x1D,
      0x2F, 0x79, 0x75, 0x71, 0x34, 0x36, 0x21, 0x20, 0x34, 0x39, 0x0A, 0x38,
      0x3C, 0x3B, 0x20, 0x21, 0x30, 0x26, 0x79, 0x75, 0x71, 0x34, 0x36, 0x21,
      0x20, 0x34, 0x39, 0x0A, 0x26, 0x30, 0x36, 0x3A, 0x3B, 0x31, 0x26, 0x7C,
      0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x28, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x30, 0x39, 0x26, 0x30, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x2E, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x25, 0x27, 0x3C, 0x3B, 0x21, 0x75, 0x06,
      0x01, 0x11, 0x10, 0x07, 0x07, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75,
      0x75, 0x75, 0x77, 0x02, 0x34, 0x27, 0x3B, 0x3C, 0x3B, 0x32, 0x6F, 0x75,
      0x1A, 0x25, 0x30, 0x3B, 0x16, 0x3A, 0x27, 0x30, 0x7E, 0x75, 0x26, 0x2C,
      0x26, 0x21, 0x30, 0x38, 0x7B, 0x75, 0x75, 0x77, 0x75, 0x7B, 0x58, 0x5F,
      0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x77, 0x06, 0x2C, 0x26, 0x21,
      0x30, 0x38, 0x75, 0x22, 0x3C, 0x39, 0x39, 0x75, 0x37, 0x30, 0x75, 0x31,
      0x3C, 0x26, 0x34, 0x37, 0x39, 0x30, 0x31, 0x75, 0x34, 0x33, 0x21, 0x30,
      0x27, 0x75, 0x71, 0x34, 0x36, 0x21, 0x20, 0x34, 0x39, 0x0A, 0x36, 0x2C,
      0x36, 0x39, 0x30, 0x0A, 0x36, 0x3A, 0x20, 0x3B, 0x21, 0x75, 0x36, 0x39,
      0x3A, 0x36, 0x3E, 0x75, 0x36, 0x2C, 0x36, 0x39, 0x30, 0x26, 0x75, 0x77,
      0x75, 0x7B, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x77,
      0x7D, 0x71, 0x34, 0x36, 0x21, 0x20, 0x34, 0x39, 0x0A, 0x21, 0x3C, 0x38,
      0x30, 0x7C, 0x7B, 0x09, 0x3B, 0x77, 0x6E, 0x58, 0x5F, 0x5F, 0x75, 0x75,
      0x28, 0x58, 0x5F, 0x5F, 0x58, 0x5F, 0x5F, 0x75, 0x75, 0x27, 0x30, 0x21,
      0x20, 0x27, 0x3B, 0x75, 0x7D, 0x71, 0x34, 0x36, 0x21, 0x20, 0x34, 0x39,
      0x0A, 0x36, 0x2C, 0x36, 0x39, 0x30, 0x0A, 0x36, 0x3A, 0x20, 0x3B, 0x21,
      0x79, 0x75, 0x71, 0x34, 0x36, 0x21, 0x20, 0x34, 0x39, 0x0A, 0x21, 0x3C,
      0x38, 0x30, 0x7C, 0x6E, 0x58, 0x5F, 0x5F, 0x76, 0x75, 0x1A, 0x17, 0x13,
      0x00, 0x06, 0x16, 0x14, 0x01, 0x10, 0x0A, 0x1B, 0x1A, 0x0A, 0x18, 0x1A,
      0x07, 0x10, 0x58, 0x5F,
    ))
  )));
  if ($@)
  {
    ribbit("eval failed ($@).");
  }
  
  return @ret;









































































































































































































}



=item I<_handle_endpoint_slave()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_endpoint_slave
{
   my $this = shift;
   my $slave_id = shift;

   $this->_handle_begin_xfer             ($slave_id);
   $this->_handle_output_enable          ($slave_id);
   $this->_handle_reset_and_reset_request($slave_id);
   $this->_handle_chip_selects           ($slave_id);
   $this->_handle_begin_burst_xfer       ($slave_id);
   $this->_handle_arbitration_holdoff    ($slave_id);
   $this->_handle_out_clk                ($slave_id);
}



=item I<_slave_specific_special_care()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _slave_specific_special_care
{
   my $this = shift;
   $this->_master_arbitration_logic();

   my @bsiwba = $this->_get_bridged_slave_ids_with_base_address();


   my $this_slave_id = $this->_get_slave_id();
   foreach my $slave_id (@bsiwba)
   {
      $this->_handle_baseaddress_port ($slave_id);
      $this->_handle_endpoint_slave ($slave_id);
      $this->_handle_setup_and_hold ($slave_id);
      $this->_handle_address_shift  ($slave_id);
      $this->_handle_native_address ($slave_id);
      $this->_handle_wait_states    ($slave_id);
      $this->_handle_byte_enables   ($slave_id);
      $this->_handle_burstcount     ($slave_id);
      $this->_handle_arbiterlock    ($slave_id);
      $this->_handle_arbiterlock2   ($slave_id);
      $this->_handle_debugaccess    ($slave_id);

      $this->log_transactions($slave_id);
   }
   my @bridged_slave_ids = $this->_get_bridged_slave_ids();
   foreach my $slave_id (@bridged_slave_ids)
   {
      $this->_handle_reset_and_reset_request ($slave_id);
      $this->_handle_always         ($slave_id);

      my @masters = $this->_get_irq_slave_masters($slave_id);
      foreach my $master_desc (@masters)
      {
         $this->_handle_irq($master_desc,$slave_id);
         $this->_handle_reset_and_reset_request ($master_desc);
      }   
   }
   
   $this->_non_plural_grants_assertion();
}

sub _handle_baseaddress_port
{
   my $this = shift;
   my $slave_id = shift;

   my $slave = $this->_get_slave($slave_id);
   my $baseaddress_port =
       $slave->_get_exclusively_named_port_or_its_complement("baseaddress");

   if ($baseaddress_port)
   {
      $this->get_and_set_once_by_name({
         name => "$baseaddress_port assignment",
         thing => "assign",
         lhs => $baseaddress_port,
         rhs => eval($slave->{SYSTEM_BUILDER_INFO}{Base_Address}),
      });
   }
}



=item I<_non_plural_grants_assertion()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _non_plural_grants_assertion
{
  my $this = shift;
  my @masters = $this->_get_master_descs();
  my @slave_ids = $this->_get_bridged_slave_ids_with_base_address();
  

  return if @masters == 1 && @slave_ids == 1;
  


  return if @slave_ids == 0;
  


  my @grants;
  my @saved_grants;
  for my $slave_id (@slave_ids)
  {
    for my $master_desc (@masters)
    {
      push @grants,
        $this->_get_master_grant_signal_name($master_desc, $slave_id);
      push @saved_grants, 
        $this->_get_saved_master_grant_signal_name($master_desc, $slave_id);
    }
  }








  for my $assert_data (
    {name => 'grant', signals => \@grants},
    {name => 'saved_grant', signals => \@saved_grants},
  )
  {
    my $condition = join(' + ', sort @{$assert_data->{signals}}) . " > 1";
    my $then = [
      e_sim_write->new({
        show_time => 1,
        spec_string => "> 1 of $assert_data->{name} signals are active simultaneously",
      }),
      e_stop->new(),
    ];

    $this->get_and_set_once_by_name({
      thing => 'process',
      name => "$assert_data->{name} signals are active simultaneously",
      contents => [
        e_if->new({
          condition => $condition,
          then => $then,
        }),
      ],
      tag => 'simulation',
    });
  }
}




=item I<_get_master_descs()>

only gets immediate masters i.e. adapter master, not adapter master's master

=cut

sub _get_master_descs
{
   my $this = shift;
   my $slave_SBI         = $this->_master_or_slave()->{SYSTEM_BUILDER_INFO};
   my $master_ref        = $slave_SBI->{MASTERED_BY} ||
       $slave_SBI->{Is_Mastered_By};

   my %return;

   my $sid = $this->_get_slave_id();

   my @potential_masters;
   foreach my $reffie (keys %$master_ref) 
   {
      my $ref = $reffie;

      if ($master_ref->{$ref}{ADAPTER_MASTER})
      {
         push (@potential_masters, keys (%{$master_ref->{$ref}{ADAPTER_MASTER}}));
      }
      else
      {
         if ($master_ref->{$ref}{priority} ne '')
         {
            push (@potential_masters, $ref);
         }
      }
   }


   foreach my $p_master (@potential_masters)
   {
      my ($master_module_name, $master_name) = split (/\//,$p_master);
      my $project = $this->_master_or_slave()->project();
      my $master_module =
          $project->get_module_by_name($master_module_name);
      next unless $master_module;
      my $master = $master_module->get_object_by_name($master_name);
      next unless $master;
      $return{$p_master} = 1;
   }















   my @master_descs = sort keys %return;
   return @master_descs;
}




=item I<_master_specific_special_care()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _master_specific_special_care
{
   my $this = shift;

   my $master_desc = shift or &ribbit ("no md");

   my $master = $this->_get_master($master_desc);
   $master->_make_address_shunt();
   $master->_arbitrator()->log_transactions();


   $this->_add_value_to_master_run($master_desc, "1");

   $this->_heed_wait_assertion($master_desc);

   foreach my $slave_id ($this->_get_bridged_slave_ids_with_base_address())
   {
      $this->_make_requests            ($master_desc,$slave_id);
      $this->_handle_read_data_valid   ($master_desc,$slave_id);
      $this->_handle_read_data         ($master_desc,$slave_id);

      $this->_handle_write_data        ($master_desc,$slave_id);
      $this->_handle_waitrequest       ($master_desc,$slave_id);
      $this->_handle_byte_address      ($master_desc,$slave_id);
      $this->_ensure_latent_master_reads_coherently
          ($master_desc,$slave_id);


      $this->_build_assertion_logic($master_desc, $slave_id);
      $this->_handle_reset_and_reset_request ($master_desc);
      $this->_nonzero_assertions($master_desc, $slave_id);
   }
}



=item I<_do_generic_wiring()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _do_generic_wiring
{
   my $this = shift;
   my $master_desc = shift or &ribbit ("no master_desc");
   my $slave_id    = shift or &ribbit ("no slave_id");
   my $port = shift or &ribbit ("no port");

   my $type = $port->type() or return;
   $type =~ s/_n$//;

   my $master = $this->_get_master($master_desc);

   my $requests =
      $this->_get_master_request_signal_name
          ($master_desc,$slave_id);

   my $select_granted =
      $this->_get_master_grant_signal_name
          ($master_desc,$slave_id);

   my $master_port_of_type =
       $master->_get_exclusively_named_port_or_its_complement($type);



   my $slave = $this->_get_slave($slave_id);

   my $exclusive_name = 
    $slave->_get_exclusively_named_port_or_its_complement($type)
     || return;

   if ($port->is_input())   # input to slave.
   {
      print "master $master_desc, slave $slave_id, ".
            "port $exclusive_name is input\n"  if $debug;

      if ($port->default_value())
      {
          $this->get_and_set_thing_by_name ({
              thing     => "mux",
              name      => "mux $exclusive_name",
              lhs       => $exclusive_name,
              default   => $port->default_value(),
          });
      }

     if ($master_port_of_type)
     {
       print "   $exclusive_name has master port of type $type\n" if $debug;
       $this->get_and_set_thing_by_name
         ({
             thing     => "mux",
             name      => "mux $exclusive_name",
             lhs       => $exclusive_name,
             add_table => [$select_granted,
                           $master_port_of_type],
         });








       $master->_arbitrator()->sink_signals($master_port_of_type);
     }
   }
   else  # port is an output
   {
     print "master $master_desc, slave $slave_id, ".
           "port $exclusive_name is output\n" if ($debug);
     if ($master_port_of_type)
     {
       print "   $exclusive_name has master port of type $type\n" if $debug;
       $master->_arbitrator()->get_and_set_thing_by_name
           ({
               thing => "mux",
               name  => "mux $master_port_of_type",
               lhs   => $master_port_of_type,
               add_table_ref => [$requests,
                                 $exclusive_name],
           });
       e_signal->new ([$exclusive_name, $port->width(), 0, 0, 1])
           ->within($master->_arbitrator());
     } else {  # no master_port_of_type















     }
   }
}



=item I<_handle_mem_is_32_bits()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_mem_is_32_bits
{
   my $this = shift;
   my $master_desc = shift or &ribbit ("no md");

   my $slave = $this->_master_or_slave();
   my $slave_SBI = $slave->{SYSTEM_BUILDER_INFO};
   my $slave_data_width = $slave_SBI->{Data_Width};

   my $master = $this->_get_master($master_desc);
   my $type = "memis32bits";
   my $master_m_i_32 =
       $master->_get_exclusively_named_port_by_type($type);

   if ($master_m_i_32)
   {
      my $master_arbitrator = $master->_arbitrator();

      my $master_arbitrator_mux = $master_arbitrator->_get_mux_of_type
          ("$master_desc $type");
      $master_arbitrator_mux->default(0);

      $master_arbitrator_mux->lhs($master_m_i_32);


      my $slave_m_i_32 = (($slave_data_width > 16) &&
                          ($slave_data_width <= 32)
                          );

      if ($slave_m_i_32)
      {
         $this->_add_to_output_mux($master_desc,
                                   $type,
                                   $slave_m_i_32,
                                   0);
      }
   }
   return;
}



=item I<_handle_byte_enables()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_byte_enables
{
   my $this = shift;
   my $slave_id = shift or &ribbit ("no slave id");

   my $slave = $this->_get_slave($slave_id);

   my $slave_data_width  = $this->_get_slave_data_width($slave_id);


   my $type      = "byteenable";
   my $be_port   = $this->get_slave_byteenable($slave);

   my $num_be_bits       = int ($slave_data_width / 8);

   my $slave_wbe_mux;
   if (!$be_port)
   {
      my $wbe_port = $this->get_slave_writebyteenable($slave);

      if ($wbe_port)
      {





         $be_port = $this->_make_signal
                        ("${wbe_port}_${slave_id}_pre_write_qualification");
         e_signal->new([$be_port => $num_be_bits,0,0,1])
             ->within($this);

         $slave_wbe_mux = $this->get_and_set_thing_by_name({
            thing => "mux",
            name  => "$wbe_port qualified byte write enables",
            lhs   => [$wbe_port => $num_be_bits,0,0,1],

            default => 0,
         });
      }
      else
      {


      }
   }

   my $slave_be_mux;
   if ($be_port)
   {
      $slave_be_mux = $this->get_and_set_thing_by_name
          ({
             thing   => "mux",
             name    => "$be_port byte enable port mux",
             lhs     => $be_port,
             default => -1,
          });
      e_signal->new ([$be_port, $num_be_bits, 0, 0, 1])->within ($this);
   }

   foreach my $master_desc ($this->_get_master_descs()) {
      my $master    = $this->_get_master($master_desc);
      my $master_data_width = $this->_get_master_data_width($master_desc);
      my $master_be_bits = $master_data_width / 8;
      
      my $master_be = $master->_get_exclusively_named_port_by_type($type) ||
        "{$master_be_bits {1'b1}}";

      next unless $this->_master_reads_or_writes_slave
          ($master,$slave,"write");


      my $dbs_shift =
          $this->_how_many_bits_of_dynamic_bus_size_are_needed
              ($master_desc,$slave_id);

      if ($dbs_shift != 0)
      {
          my $original_master_be = $master_be;
          $master_be = $this->_get_byteenable_signal_name
              ($master_desc,$slave_id);

          if ($dbs_shift < 0)
          {






            

            if (!$be_port)
            {
              goldfish(
                "Warning: $master_data_width-bit master connected to " .
                "$slave_data_width-bit slave with no byte enables " .
                "($master_desc -> $slave_id)\n");
              next;
            }

            my $master_address = $this->get_master_address_port($master);


            my $num_mux_inputs = $num_be_bits / $master_be_bits;

            my @mux_inputs;
           
            my @address_values = (0 .. $num_mux_inputs - 1);
            if($this->is_big_endian_master($master_desc))
            {
              @address_values = reverse(@address_values);
            }
            


            my $zeroth_case = shift(@address_values);
            push @mux_inputs, ($zeroth_case => $original_master_be);

            my $current_dbs_slice = 1;
            foreach my $address_value (@address_values)
            {
              my $expr = sprintf(
                "{%s, {%d'b0}}",
                $original_master_be,
                $current_dbs_slice * $master_be_bits);

              push @mux_inputs, $address_value => $expr;
              $current_dbs_slice++;
            }

            my $low = log2($master_data_width / 8);
            my $high = $low + log2($num_mux_inputs) - 1;
            ribbit("unexpected") if $high < $low;
            my $highlow = ($high == $low) ? $low : "$high : $low";
            my $be_mux_select = "$master_address\[$highlow\]";
            if ($this->is_burst_master($master)) 
            {

















              my $subset_of_master_address = $be_mux_select;
              my $be_mux_control = 
                $this->_make_signal("$master_desc/be_mux_control/$slave_id");
              my $select_width = $high - $low + 1;
              my $bbt = $this->get_begin_bursttransfer_signal($slave_id);
              my $wait = 
                $slave->_get_exclusively_named_port_by_type("waitrequest");
              if ($wait eq '')
              {
                ribbit("slave '$slave_id'; no waitrequest signal");
              }
              if ($bbt eq '')
              {
                ribbit("slave '$slave_id'; no beginbursttransfer signal");
              }

              my $be_mux_control_reg = $be_mux_control . "_reg";
              $this->get_and_set_thing_by_name({
                thing => "register",
                enable => 1,
                name => "be mux control reg for $master_desc and $slave_id",
                out => {name => $be_mux_control_reg, width => $select_width,},
                in => 

                  "$bbt & ~$wait ? ($subset_of_master_address + 1) : " .

                  "$bbt & $wait ? $subset_of_master_address : " .

                  "~$wait ? ($be_mux_control_reg + 1) : " .

                  " $be_mux_control_reg",
              });
              $this->get_and_set_thing_by_name({
                thing => "assign",
                name => "be mux control for $master_desc and $slave_id",
                lhs => {name => $be_mux_control, width => $select_width,},
                rhs => "$bbt ? $subset_of_master_address : $be_mux_control_reg",
              });


              $be_mux_select = $be_mux_control;
            }
            $this->get_and_set_thing_by_name({
              thing => "mux",
              type => "selecto",
              selecto => $be_mux_select,
              name  => "byte_enable_mux for $master_desc and $slave_id",
              lhs => [$master_be, $num_be_bits,0,0,1],
              table => \@mux_inputs,
            });

          } elsif ($dbs_shift > 0) {












            my $num_be_groups = 2 ** $dbs_shift;
            my $be_group_select =
                $this->_get_my_portion_of_master_dbs_address($master_desc,
                                                              $slave_id);

            my @be_mux_table = ();
            my @be_segment_list = ();
            for (my $i = 0; $i < $num_be_groups; $i++) {
                my $be_seg_name = $master_be . "_segment_$i";
                e_signal->new ([$be_seg_name, $num_be_bits,0,0,1])->within ($this);

                push (@be_segment_list, $be_seg_name);
                push (@be_mux_table,
                      "($be_group_select == $i)" => $be_seg_name,
                      );
            }



            my @endian_aware_be_segment_list;
            if($this->is_big_endian_master($master_desc)) {
              @endian_aware_be_segment_list = @be_segment_list;
            } else {
              @endian_aware_be_segment_list = reverse(@be_segment_list);
            }
            e_assign->new ({within => $this,
                            lhs    => &concatenate((@endian_aware_be_segment_list)),
                            rhs    => $original_master_be,
                          });

            my $master_write = $this->get_master_write($master);

            my $be_mux = e_mux->new
                ({within  => $this,
                  lhs     => [$master_be, $num_be_bits,($master_write ne ""),0,1],
                  table   => \@be_mux_table,
                });
          }
       }



      $slave_be_mux->add_table
          ($this->_get_master_grant_signal_name ($master_desc,$slave_id)
            => $master_be)
              if ($be_port);
      
      if ($slave_wbe_mux)
      {
        my $write = $this->_get_real_or_dummy_slave_write_port($slave_id); 

        $slave_wbe_mux->add_table(
          and_array(
            $write,
            $this->_get_master_grant_signal_name ($master_desc,$slave_id)
          ),
          $be_port
        );
      }
  }
}


=item I<_get_pretend_byte_enable()>

Normally, slaves either do or do not have a byte-enable signal.
but there's one weird circumstance where we "pretend" that there's
a byte-enable, even if there isn't.  This is the circumstance when
we have:

    -- A one-byte slave.
    -- Which is dynamically bus-sized as-seen by the master.
    -- Which is writeable (has a write-type input)
    -- Which has no actual byte-enable inputs.

In this circumstance, we find ourselves thinking that it would
sure be handy if that slave had a byte-enable.  Then, when the
master does a narrow write, the dbs-selection of the master's
byte-enable to the slave will allow only the desired writes to take
effect.  But--what if the thing doesn't have a byte-enable input?
That would be awkward.  Then we'd have to duplicate a lot of the
byte-enable-selection logic here and work it, somehow, into the
write-signal's logic.  That sounds hard.  I have a better idea:
let's just pretend that the slave has a byte-enable.

=cut

sub _get_pretend_byte_enable
{
   my $this = shift;
   my $slave = shift or &ribbit ("no slave parameter");

   my $slave_id = $slave->get_id();
   my $real_be_port =
       $slave->_get_exclusively_named_port_by_type("byteenable") ||
           $slave->_get_exclusively_named_port_by_type("writebyteenable");

   my $write_port   = $this->_get_slave_write_port($slave_id);
   return $this->_make_signal("${slave_id}_pretend_byte_enable")
       if  ($real_be_port eq ""                 ) &&
           ($write_port   ne ""                 ) &&
               ($this->_get_slave_data_width($slave_id) == 8 )  ;

   return "";
}



=item I<_how_many_bits_of_dynamic_bus_size_are_needed()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _how_many_bits_of_dynamic_bus_size_are_needed
{
   my $this = shift;
   my $master_desc = shift or &ribbit ("no master_desc");
   my $slave_id    = shift or &ribbit ("no slave_id");

   my $master            = $this->_get_master($master_desc);
   my $master_SBI        = $master->{SYSTEM_BUILDER_INFO};
   my $master_data_width = $master_SBI->{Data_Width} or return 0;
   my $master_shift        = &log2($master_data_width / 8);

   my $slave             = $this->_get_slave($slave_id);
   my $slave_SBI         = $slave->{SYSTEM_BUILDER_INFO};

   ($slave_SBI->{Address_Alignment} =~ /^dynamic/i) or return 0;



   if ($master->is_adapter())
   {
      return 0;
   }

   my $slave_data_width = $slave_SBI->{Data_Width}
   or return (0);

   my $slave_shift = &log2($slave_data_width / 8);

   &ribbit ("Illegal 'Address_Alignment' for ", $this->name(), "\n",
            " dynamic allowed for data-widths of 8, 16, 32, ... only.")
       if ($slave_shift != int($slave_shift) || $slave_shift < 0);

   &ribbit ("Illegal 'Address_Alignment' for $master_desc \n",
            " dynamic allowed for data-widths of 8, 16, 32, ... only ",
            "(is: '$master_data_width').")
       if ($master_shift != int($master_shift) || $master_shift < 0);

   return ($master_shift - $slave_shift);
}



=item I<_dbs_counter_width()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _dbs_counter_width
{
   my $this = shift;
   my $master_desc = shift or &ribbit ("no master_desc");

   my $master            = $this->_get_master($master_desc);
   my $master_SBI        = $master->{SYSTEM_BUILDER_INFO};
   my $master_data_width = $master_SBI->{Data_Width} or return 0;

   return &log2($master_data_width / 8);
}



=item I<_get_dbs_count_increment()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_dbs_count_increment
{
   my $this = shift;
   my $master_desc = shift or &ribbit ("no master_desc");
   my $slave_id = shift or ribbit("no slave_id");

   my $master            = $this->_get_master($master_desc);
   my $master_SBI        = $master->{SYSTEM_BUILDER_INFO};
   my $master_data_width = $master_SBI->{Data_Width} or return 0;

   my $slave     = $this->_get_slave($slave_id);
   my $slave_SBI = $slave->{SYSTEM_BUILDER_INFO};
   my $slave_data_width = $slave_SBI->{Data_Width} or return 0;

   ribbit("wasn't expecting this ($master_data_width, $slave_data_width)!")
     if $master_data_width <= $slave_data_width;





   return $slave_data_width / 8;

}

sub _address_shift_dbs
{
  my $this = shift;
  my ($master_desc, $slave_id) = @_;

  my $master = $this->_get_master($master_desc);
  my $master_dbs_address = $this->_get_master_dbs_address($master_desc);
  my $master_aligned_shift =
    $this->_get_master_aligned_shift($master_desc);

  my $sig = $master->_arbitrator()->get_and_set_thing_by_name({
    thing         => "signal",
    name          => $master_dbs_address,
    width         => $master_aligned_shift,
    export        => 1,
  });

  my $master_address =
    $this->get_master_address_port($this->_get_master($master_desc));
  my @slave_addr_concat = (
    "$master_address >> $master_aligned_shift",
    $this->_get_my_portion_of_master_dbs_address($master_desc, $slave_id)
  );

  my $shift = $this->_get_address_shift_amount($master_desc, $slave_id);
  if ($shift > 0)
  {
    push (@slave_addr_concat, "{$shift {1'b0}}");
  }

  my $address_to_slave = &concatenate (@slave_addr_concat);

  my $master_increment =
      $this->_make_signal("$master_desc/dbs_increment");

  $master->_arbitrator()->get_and_set_thing_by_name
      ({
        thing => "signal",
        name  => $master_increment,
        width => $master_aligned_shift,
      });

  my $increment_amount =
      $this->_get_dbs_count_increment ($master_desc, $slave_id);
      
  my $select_request =
      $this->_get_master_request_signal_name
          ($master_desc,$slave_id);
  $master->_arbitrator()->get_and_set_thing_by_name
      ({
        thing         => "mux",
        name          => "dbs count increment",
        default       => 0,
        lhs           => $master_increment,
        add_table_ref =>
            [
              $select_request => $increment_amount,
              ],
      });






  my $msb_range_select =
      ($master_aligned_shift == 1) ? "" : "\[$master_dbs_address.msb\]";

  $master->_arbitrator()->get_and_set_thing_by_name
      ({
        thing  => "assign",
        name   => "dbs counter overflow",
        lhs    => [dbs_counter_overflow => 1,0,1],
        rhs    => &and_array ("$master_dbs_address\[$master_dbs_address.msb\]",
                              "!(next_dbs_address\[next_dbs_address.msb\])",
                              ),
      });

  $master->_arbitrator()->get_and_set_thing_by_name
      ({
        thing  => "assign",
        name   => "next master address",
        lhs    => "next_dbs_address",
        rhs    => "$master_dbs_address + $master_increment",
      });
  my @dbs_enable_and_array;

  my $inhibit = $this->_get_inhibit_when_wait_mismatch($master_desc);

  my $write_wait_states_are_predictable =
      $this->_registered_wait_states_are_predictable
          ($master_desc, $slave_id,"write");

  my $read_wait_states_are_predictable =
      $this->_registered_wait_states_are_predictable
          ($master_desc, $slave_id,"read");

  my $master_write = $this->get_master_write($master);
  my $master_read  = $this->get_master_read($master);






  if ((!$read_wait_states_are_predictable) &&
      (!$write_wait_states_are_predictable))
  {
    push (@dbs_enable_and_array,
          &complement
          (&and_array($select_request,
                      $inhibit)
            )
          );
  }
  elsif (!$read_wait_states_are_predictable)
  {

    push (@dbs_enable_and_array,
          &complement
          (&and_array($select_request,
                      $inhibit,
                      $master_read,
                      )
            )
          );
  }
  elsif (!$write_wait_states_are_predictable)
  {

    push (@dbs_enable_and_array,
          &complement
          (&and_array($select_request,
                      $inhibit,
                      $master_write,
                      )
            )
          );
  }
  else
  {


  }

  $master->_arbitrator()->get_and_set_once_by_name
      ({
        thing  => "mux",
        name   => "dbs count enable",
        lhs    => ["dbs_count_enable" => 1],
        type   => "or_and",
        add_table => [pre_dbs_count_enable => "pre_dbs_count_enable"],
      });

  $master->_arbitrator()->get_and_set_thing_by_name
      ({
        thing  => "mux",
        name   => "dbs count enable",
        lhs    => ["dbs_count_enable" => 1],
        type   => "or_and",
        add_table => [map {$_ => $_} @dbs_enable_and_array],
      }) if (@dbs_enable_and_array);

  $master->_arbitrator()->get_and_set_thing_by_name
      ({
        thing  => "register",
        name   => "dbs counter",
        d      => "next_dbs_address",
        q      => $master_dbs_address,
        enable => "dbs_count_enable",
      });

  my $read_latency = $this->get_read_latency($slave_id);
  my $variable_read_latency = $this->get_variable_read_latency($slave_id);
  my $master_readdata  = $this->get_master_readdata_port($master);
  if (($read_latency || $variable_read_latency) && 
      $master->_can_handle_read_latency() && $master_readdata)
  {
    my $counter_width = $this->_dbs_counter_width($master_desc);
    &ribbit ("$master_desc has no Data_Width\n") if (!$counter_width);




    my $master_rdv_counter =
        $this->_get_master_dbs_rdv_counter("$master_desc");


    $master->_arbitrator()->get_and_set_thing_by_name
        ({
            thing => "signal",
            name => $master_rdv_counter,
            width => $counter_width,
        });




    my $master_rdv_next =
        $this->_make_signal("$master_desc/next_dbs_rdv_counter");

    $master->_arbitrator()->get_and_set_thing_by_name({
        thing => "signal",
        name => $master_rdv_next,
        width => $counter_width,
    });

    my $master_rdv_inc =
        $this->_make_signal("$master_desc/dbs_rdv_counter_inc");

    $master->_arbitrator()->get_and_set_thing_by_name({
        thing => "signal",
        name  => $master_rdv_inc,
        width => $counter_width,
    });

    $master->_arbitrator()->get_and_set_thing_by_name({
        thing => "assign",
        name  => "p1 dbs rdv counter",
        lhs   => $master_rdv_next,
        rhs   => "$master_rdv_counter + $master_rdv_inc",
    });



    my $local_rdv  = $this->get_read_data_valid_signal_name
        ($master_desc, $slave_id);

    my $this_slave_inc = $this->_get_dbs_count_increment($master_desc, $slave_id);

    my $master_rdv_inc_mux =
        $this->_make_signal("$master_desc/rdv_inc_mux");

    $master->_arbitrator()->get_and_set_thing_by_name({
        thing => "mux",
        name => $master_rdv_inc_mux,
        lhs => $master_rdv_inc,
        add_table_ref => [$local_rdv, $this_slave_inc,],
    });









    $master->_arbitrator()->get_and_set_thing_by_name({
        thing => "signal",
        name => "dbs_rdv_count_enable",
    });



    $master->_arbitrator()->get_and_set_thing_by_name({
        thing => "mux",
        name => "master any slave rdv",
        lhs  => "dbs_rdv_count_enable",
        type => "and_or",
        add_table_ref => [$local_rdv, $local_rdv],
    });



    my $qualified_master_flush =
        $this->_make_qualified_flush_for_master ($master_desc);



    $master->_arbitrator()->get_and_set_thing_by_name({
        thing  => "register",
        name   => "dbs rdv counter",
        d      => $master_rdv_next,
        q      => $master_rdv_counter,
        enable => &or_array("dbs_rdv_count_enable",
                            $qualified_master_flush,
                            ),
        sync_reset => $qualified_master_flush,
    });

    $master->_arbitrator()->get_and_set_thing_by_name({
        thing  => "assign",
        name   => "dbs rdv counter overflow",
        lhs    => ["dbs_rdv_counter_overflow", 1],
        rhs    => "$master_rdv_counter\[$master_rdv_counter.msb\] & ".
                  "~$master_rdv_next\[$master_rdv_next.msb\]",
    });
  }
  return $address_to_slave;
}

sub _declare_address_signal_width
{
  my $this = shift;
  my $slave_id = shift;

  my $slave = $this->_get_slave($slave_id);
  my $slave_SBI = $slave->{SYSTEM_BUILDER_INFO};


  my $slave_data_width = eval ($slave_SBI->{Data_Width})
    or &ribbit ("$slave_id has no data width");
  $slave_data_width =
    round_up_to_next_computer_acceptable_bit_width($slave_data_width);
  my $slave_address_width = eval($slave_SBI->{Address_Width});

  my $slave_address = $this->get_slave_address_port($slave);
  my $slave_byteaddress = $this->get_slave_byteaddress_port($slave);
  my $never_export_the_slave_address = 0;
  my $export_the_slave_address = 0;
  my @slave_addresses = ($slave_address) if $slave_address;




  if ($slave_address_width != 0 && !$slave_address && !$slave_byteaddress)
  {
    ribbit(
      "$slave_id has no slave address port, but has " .
      "Address_Width = $slave_address_width\n"
    );
  }


  return if ($slave_byteaddress && !$slave_address);

  if ($slave_address_width == 0 && !$slave_address) {
    @slave_addresses = 
        ($this->_make_signal("$slave_id\_address_for_slave_wo_address"));
    $slave_address_width = 1;
    $export_the_slave_address = 0;
    $never_export_the_slave_address = 1;
  }
  elsif ($this->is_bridge())
  {
    my $possible_p1_slave_address = $slave_address;
    if ($possible_p1_slave_address =~ s/^p1_//)
    {
      push @slave_addresses, $possible_p1_slave_address;
    }
    $never_export_the_slave_address = 0;
    $export_the_slave_address = 0;






    $slave_address_width += $this->_get_slave_aligned_shift($slave_id);
  }
  else
  {
    $never_export_the_slave_address = 0;
    $export_the_slave_address = 1;
  }

  for my $sig (@slave_addresses)
  {
    e_signal->new({
      name => $sig,
      width => $slave_address_width,
      export => $export_the_slave_address,
      never_export => $never_export_the_slave_address,
      copied => 1,
    })->within($this);
  }
}



=item I<_handle_address_shift()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!


is_bridge (note: is_bridge carries a notion of tristate bridge along with it.
this probably needs to be corrected)
is_adapter
byteaddress
slave nativeaddress
master nativeaddress

native/dynamic alignment
DBS:
  if dynamic, various data widths of slave and master
  if native, various data widths with master dw >= slave dw

=cut

sub _handle_address_shift
{
   my $this = shift;
   my $slave_id = shift or &ribbit ("no slave_id");

   my $slave     = $this->_get_slave($slave_id);
   my $slave_SBI = $slave->{SYSTEM_BUILDER_INFO};

   my $slave_base_address = $slave_SBI->{Base_Address};
   return if ($slave_base_address eq 'N/A');

   $this->_declare_address_signal_width($slave_id);


   my $slave_alignment = $slave_SBI->{Address_Alignment};
   my $is_dynamic_slave = $slave_alignment =~ /^dynamic/i;
   my $slave_data_width = eval ($slave_SBI->{Data_Width})
        or &ribbit ("$slave_id has no data width");
   $slave_data_width =
     round_up_to_next_computer_acceptable_bit_width($slave_data_width);
   my $slave_shift_amount = log2($slave_data_width / 8);
   my $slave_address = $this->get_slave_address_port($slave);
   my $slave_address_is_byte_address = $slave_SBI->{Byte_Address};


   foreach my $master_desc ($this->_get_master_descs())
   {
      my $master = $this->_get_master($master_desc);
      
      my $master_address = $this->get_master_address_port($master);

      next if (!$master_address);





      my $shift = $this->_get_address_shift_amount($master_desc,$slave_id);
      my $master_aligned_shift =
        $this->_get_master_aligned_shift ($master_desc);
      my $address_from_master = $master_address;

      my $is_positive_dbs_and_dynamic =
        ($shift < $master_aligned_shift) && $is_dynamic_slave;
      if ($is_positive_dbs_and_dynamic)
      {
        $address_from_master = $this->_address_shift_dbs($master_desc, $slave_id);
      }

      my $master_data_width = $this->_get_master_data_width($master_desc);
      my $master_shift_amount = log2($master_data_width / 8);
      


      my $right_shift_amount = 0;
      if ($is_dynamic_slave)
      {


        $right_shift_amount = $slave_shift_amount;



        if ($this->is_bridge() || $slave->is_adapter() || $slave_address_is_byte_address)
        {
          $right_shift_amount = 0;
        }
      }
      else 
      {

        my $master_native_address = 
          $master->_get_exclusively_named_port_or_its_complement('nativeaddress');
        if ($master_native_address)
        {


          my $slave_native_address =
            $slave->_get_exclusively_named_port_or_its_complement('nativeaddress');
          if (!$slave_native_address)
          {

            $this->sink_signals($master_address);


            $address_from_master = $master_native_address;
            $right_shift_amount = 0;
            


            if ($slave_SBI->{Bus_Type} =~ /tristate/)
            {
              if ($master_shift_amount > 0)
              {
                $address_from_master = "{$master_native_address, ${master_shift_amount}'b0}";
              }
            }
          }
        }
        else 
        {
          $right_shift_amount = $master_shift_amount;
        }

        if ($this->is_bridge())
        {
          $right_shift_amount -= $slave_shift_amount;
        }
      }

      my $adjusted_address_from_master = $address_from_master;
      if ($right_shift_amount > 0)
      {




        my $shift_expression = " >> $right_shift_amount";
        my $interposed_signal =
          $this->_make_signal(
            "shifted_address_to_$slave_id\_from_$master_desc"
          );
        my $master_SBI = $master->{SYSTEM_BUILDER_INFO};
        my ($master_address_port, $negate_port) = $master->_get_port_or_its_complement("address");
	my $width;
	if ($master_address_port)
	{
	    $width = $master_address_port->width();
	}
	else
	{
	    $width = $master_SBI->{Address_Width};
	}


        $width = max(2, $width);
        e_assign->new({
          lhs => {
            name => $interposed_signal, 
            width => $width, 
            never_export => 1,
          }, 
          rhs => $address_from_master,
        })->within($this);

        $adjusted_address_from_master = "$interposed_signal" . $shift_expression;
      }

      my $select_granted =
        $this->_get_master_grant_signal_name($master_desc,$slave_id);

      if ($slave_address)
      {
        $this->get_and_set_thing_by_name({
          thing   => "mux",
          name    => "$slave_address mux",
          lhs     => $slave_address,
          add_table => [$select_granted =>
                        $adjusted_address_from_master],
          default => "",
        });
      }
   }
}



=item I<_get_address_shift_amount()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_address_shift_amount
{
   my $this = shift;
   my $master_desc = shift or &ribbit ("no master");

   my $slave_id = shift or &ribbit ("no slave_id");


   my $project = shift;

   ribbit("need object or project") if (not $this and not $project);

   $project = $this->project() if not $project;
   ribbit("no project!") if not $project;
   my $slave_SBI;
   my $master_SBI;

   $slave_SBI = $project->SBI($slave_id);

   my $slave_data_width = $project->get_slave_data_width($slave_id);
   my $master_data_width = $project->get_master_data_width($master_desc);

   ribbit("slave ($slave_id) data width is 0") if not $slave_data_width;
   ribbit("master ($master_desc) data width is 0") if not $master_data_width;

   my $slave_alignment = $slave_SBI->{Address_Alignment};
   my $master_shift = &log2($master_data_width / 8);
   my $slave_shift = &log2($slave_data_width / 8);

   my $error_message = ("$master_desc Data_Width must be >= 8\n".
                        "and a power of 2 not ($master_data_width)\n");


   &ribbit ($error_message) if $master_shift != int($master_shift);
   &ribbit ($error_message) if $master_shift < 0;

   my $shift;
   if ($slave_alignment =~ /native/i)
   {
      $shift = $master_shift;
   }
   elsif ($slave_alignment =~ /dynamic/i)
   {

      ribbit("slave data width ($slave_data_width) for slave $slave_id unexpected")
        if $slave_shift != int($slave_shift);
      ribbit("slave data width ($slave_data_width) for slave $slave_id unexpected")
        if $slave_shift < 0;
      $shift = $slave_shift;
   }
   elsif ($slave_alignment =~ /^\d+$/)
   {

      my $log = &log2($slave_alignment);
      my $ceil = ceil($log);
      &ribbit ("$slave_id: numerical address_alignment ",
               "must be an even power of 2")
          unless ($log == $ceil);
      $shift = $log;
   }
   else
   {
      &ribbit
          ("$slave_id, never heard of alignment ($slave_alignment) before.");
   }

   return ($shift);
}



=item I<_type_needs_special_care()>

Returns 1 or 0. 

When this routine returns 1, prevents generic wiring from happening between the
master and slave for signals of this type.

=cut

sub _type_needs_special_care
{
   my $this = shift;
   my $type = shift or &ribbit ("no type\n");

   my $return = 0;

   $return = 1 if ($type =~ /^waitrequest/i);
   $return = 1 if ($type =~ /^irq/i);
   $return = 1 if ($type =~ /^chipselect/i);
   $return = 1 if ($type =~ /^address/i);
   $return = 1 if ($type =~ /^byteenable/i);
   $return = 1 if ($type =~ /^(read|read_n)$/i);   #for setup/hold
   $return = 1 if ($type =~ /^(write|write_n)$/i); #for setup/hold
   $return = 1 if ($type =~ /^readdata$/i);
   $return = 1 if ($type =~ /^writedata$/i);
   $return = 1 if ($type =~ /^always\d$/i);
   $return = 1 if ($type =~ /^begintransfer/i);
   $return = 1 if ($type =~ /^outputenable/i);
   $return = 1 if ($type =~ /^reset(_n)?$/i);
   $return = 1 if ($type =~ /^readdatavalid(_n)?$/i);
   $return = 1 if ($type =~ /^burstcount(_n)?$/i);
   $return = 1 if ($type =~ /^data$/i);
   $return = 1 if ($type =~ /^resetrequest(_n)?$/i);
   $return = 1 if ($type =~ /^byteaddress(_n)?$/i);
   $return = 1 if ($type =~ /^beginbursttransfer(_n)?$/i);
   $return = 1 if ($type =~ /^arbiterlock(_n)?$/i);
   $return = 1 if ($type =~ /^arbiterlock2(_n)?$/i);
   $return = 1 if ($type =~ /^nativeaddress$/i);
   $return = 1 if ($type =~ /^baseaddress$/i);
   $return = 1 if ($type =~ /^debugaccess(_n)?$/i);
   return ($return);
}



=item I<_find_irq_number()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _find_irq_number
{
   my $this = shift;
   my $master_desc = shift;
   my $slave_id = shift;
   my $slave = $this->_get_slave($slave_id);
   my $slave_SBI = $slave->{SYSTEM_BUILDER_INFO};

   my $irq_number = $slave_SBI->{IRQ_MASTER}{$master_desc}{IRQ_Number};

   if ($irq_number eq '')
   {

      if (exists $slave_SBI->{MASTERED_BY}{$master_desc})
      {
         $irq_number = $slave_SBI->{MASTERED_BY}{$master_desc}
         {IRQ_Number};
      }
   }
   if ($irq_number eq '')
   {
      $irq_number = $slave_SBI->{IRQ_Number};
   }
   return $irq_number;
}



=item I<_handle_irq()>

Insert a synchronizer on the irq line if crossing clock domains.

=cut

sub _handle_irq
{
   my $this = shift;
   my $master_desc = shift or &ribbit ("no master desc");
   my $slave_id = shift or &ribbit ("no slave id");
   my $slave = $this->_get_slave($slave_id);
   my $slave_SBI = $slave->{SYSTEM_BUILDER_INFO};

   my $irq_number = $this->_find_irq_number($master_desc, $slave_id);
   return if ($irq_number eq 'NC');

   return unless ($slave_SBI->{Has_IRQ} eq "1");

   my $master = $this->_get_master($master_desc);
   my $master_arbitrator = $master->_arbitrator();

   my $irq_port = $slave->_get_exclusively_named_port_by_type
       ("irq", {register_slave_outputs_across_bridge => 1}) or
           &ribbit ("SLAVE ($slave_id) has no irq port, but Has_IRQ is set to 1!");

   my $master_clock = $master->clock();
   my $slave_clock  = $slave->clock();


   if ($slave_clock ne $master_clock)
   {


      my $delayed_irq = "${master_clock}_$irq_port";
      $delayed_irq =~ s/~//;
      my $name = "$irq_port\_clock_crossing";
      $name =~ s/~//;
      $name .= "_" . $this->_make_signal($master_desc);



      $master_arbitrator->get_and_set_once_by_name({
         thing    => 'synchronizer',
         name     => $name,
         comment  => "$irq_port from $slave_clock to $master_clock",
         port_map => {
            data_in  => $irq_port,
            data_out => $delayed_irq,
            clk  => $master_clock,
            reset_n  => $master->reset_n(),
         },
      });
      $irq_port = $delayed_irq;
   }

   my @irq_args = ($slave_id, $irq_port, $irq_number);
   $master_arbitrator->add_irq(@irq_args);

   return;
}



=item I<_handle_always()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_always
{
   my $this = shift;
   my $slave_id = shift or &ribbit ("no slave_id");

   my $slave = $this->_get_slave($slave_id);
   foreach my $port (@{$slave->_ports()})
   {
      my $type = $port->type() or next;
      next unless $type =~ /^always([01])$/i;

      my $value = $1 eq "0" ? "0" : "-1";

      $this->get_and_set_once_by_name
          ({
             thing => "assign",
             name  => $port->_exclusive_name()." always signal",
             lhs    => [$port->_exclusive_name(), $port->width],
             rhs    => $value,
          });
   }
}






sub make_outclk_connection
{
  my ($thingy, $project, $port_name) = @_;
      
  my $clocks = $project->get_clock_hash();
  my @user_selectable_clocks = $project->get_user_selectable_clocks($clocks);
  
  my $source_clock_is_tied_to_another_clock = 0;
  my $top_module = $project->top();
      
  foreach my $domain (@user_selectable_clocks) 
  {
    my $source = $project->get_clock_source($domain);
    if ($source =~ /^\s*external\s*$/i)
    {
      next;
    }
    my $clock_signal = $project->augment_clock_name($domain);
    my $source_signal = $project->augment_out_clock_name($source);


    if ($source_signal ne $port_name)
    {
      next;
    }

  $source_clock_is_tied_to_another_clock = 1;

  $top_module->add_contents(
    e_signal->new ({
      name => $clock_signal,
      type => "clk",
      export => 1,
    }),
    e_port->new ({
      name => $clock_signal,
      type => "clk",
      direction => "out",
    }),
  );

  $top_module->get_and_set_once_by_name({
    thing => 'assign',
    name => "$clock_signal out_clk assignment",
    lhs => $clock_signal,
    rhs => $source_signal,
    });
  }

  if ($source_clock_is_tied_to_another_clock == 0) 
  {
    $top_module->add_contents(            
      e_signal->new ({                     
        name => $port_name,  
        type => "out_clk",          
        export => 1,                    
      }),                                 
      e_port->new ({                      
        name => $port_name,            
        type => "out_clk",              
        direction => "out",             
      }),                                 
    );                                    
  }
}



=item I<_handle_out_clk()>

Some slaves have ports of type out_clk.  

Each out_clk is associated with (at least) one clock domain.  Each clock domain
may or may not have modules on it.  Regardless, there should be a clock signal
created for each clock domain that comes from an out_clk, and that pin should
be output at the top level of the design.

=cut

        
        
sub _handle_out_clk
{
   my $this = shift;
   my $slave_id = shift or &ribbit ("no slave_id"); 

   my $slave = $this->_get_slave($slave_id);
   my $project = $this->project();
   
   foreach my $port (@{$slave->_ports()})
   {
      my $type = $port->type() or next;
      next unless $type =~ /^out_clk/i;

      my $port_name = $port->_exclusive_name();


      $this->make_outclk_connection(
        $project, 
        $port_name,
      );
   }    
}       
        










=item I<_handle_begin_xfer()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_begin_xfer
{
   my $this = shift;
   my $slave_id = shift or &ribbit ("no_slave_id");
   my $slave = $this->_get_slave($slave_id);
   my $slave_begin_xfer =
       $slave->_get_exclusively_named_port_by_type("begintransfer")
           or return;

   my $e = e_assign->new([$slave_begin_xfer,
                          $this->_make_begin_xfer($slave_id)]);
   $e->within($this);

   return;
}



=item I<slave_needs_arbitration_logic()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub slave_needs_arbitration_logic
{
  my $this = shift;
  my $slave_id = shift or &ribbit ("no_slave_id");
  

  return $this->_slave_has_base_address($slave_id) || $this->is_bridge();
}



=item I<_handle_begin_burst_xfer()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_begin_burst_xfer
{
  my $this = shift;
  my $slave_id = shift or &ribbit ("no_slave_id");



  return if !$this->slave_needs_arbitration_logic($slave_id);
  my $bridge_slave_id = $this->_get_slave_id();

  my $beginbursttransfer = $this->get_begin_bursttransfer_signal($bridge_slave_id);
  my $begin_xfer = $this->_make_begin_xfer();
  
  my $firsttransfer = $this->_make_signal("$bridge_slave_id/firsttransfer");


  my $allow_new_arb_cycle =
    $this->_make_signal("$bridge_slave_id/allow_new_arb_cycle");



  my $anycontinuerequest = $this->_make_signal("$bridge_slave_id/any_continuerequest");
  my $slave_enables_arbiterlock = $this->_make_signal("$bridge_slave_id/slavearbiterlockenable");

  my $unreg_firsttransfer = $this->_make_signal("$bridge_slave_id/unreg_firsttransfer");
  my $reg_firsttransfer = $this->_make_signal("$bridge_slave_id/reg_firsttransfer");
  $this->get_and_set_once_by_name({
    thing => 'assign',
    name => "$firsttransfer first transaction",
    lhs => e_signal->new({name => $firsttransfer, never_export => 1,}),
    rhs => "$begin_xfer ? $unreg_firsttransfer : $reg_firsttransfer",
  });
  $this->get_and_set_once_by_name({
    thing => 'assign',
    name => "$unreg_firsttransfer first transaction",
    lhs => e_signal->new({name => $unreg_firsttransfer, never_export => 1,}),
    rhs => complement(and_array($slave_enables_arbiterlock, $anycontinuerequest)),
  });
  my $begin_xfer = $this->_make_begin_xfer();
  $this->get_and_set_once_by_name({
    thing => 'register',
    name => "$reg_firsttransfer first transaction",
    async_value => "1'b1",
    enable => $begin_xfer,
    in => $unreg_firsttransfer,
    out => $reg_firsttransfer,
  });
   
  my $slave = $this->_get_slave($slave_id);

  my $slave_burstcount = $this->get_slave_burstcount($slave);
  my $slave_max_burst =
    $slave->{SYSTEM_BUILDER_INFO}->{Maximum_Burst_Size} || 1;

  my $bbt_counter_rhs;
  if ($slave_burstcount ne '' && ($slave_max_burst > 1))
  {



    my $slave_read = $this->get_slave_read_port($slave);
    if ($slave_read ne '')
    {
      e_export->new({expression => $slave_read})->within($this);
    }

    my ($slave_write, $is_dummy_write) =
      $this->_get_real_or_dummy_slave_write_port($slave_id);
    if ($slave_write ne '' && !$is_dummy_write)
    {
      e_export->new({expression => $slave_write})->within($this);
    }

    my $slave_burst_width = ceil(log2($slave_max_burst));

    my $next_bbt_burstcount =
      $this->_make_signal("$bridge_slave_id/next_bbt_burstcount");
    my $bbt_burstcounter =
      $this->_make_signal("$bridge_slave_id/bbt_burstcounter");

    my $mux = $this->get_and_set_once_by_name({
      thing => 'mux',
      name => "$next_bbt_burstcount next_bbt_burstcount",
      out => {name => $next_bbt_burstcount, width => $slave_burst_width,},

      default => "($bbt_burstcounter - 1)",
    });
    

    if ($slave_write)
    {

      $mux->add_table([
        "(($slave_write) && ($bbt_burstcounter == 0))",
        "($slave_burstcount - 1)",
      ]);
    }

    if ($slave_read)
    {

      $mux->add_table([
        "(($slave_read) && ($bbt_burstcounter == 0))",
        "0",
      ]);
    }




    $this->get_and_set_once_by_name({
      thing => 'register',
      name => "$bbt_burstcounter bbt_burstcounter",
      enable => $begin_xfer,
      out => {name => $bbt_burstcounter, width => $slave_burst_width,},
      in => $next_bbt_burstcount,
    });


    e_export->new({expression => $slave_burstcount})->within($this);
    $bbt_counter_rhs = and_array($begin_xfer, "($bbt_burstcounter == 0)");
  }
  else
  {
    $bbt_counter_rhs = $begin_xfer;
  }
  
  $this->get_and_set_once_by_name({
    thing => 'assign',
    name => "$beginbursttransfer begin burst transfer",
    lhs => e_signal->new({name => $beginbursttransfer, never_export => 1,}),
    rhs => $bbt_counter_rhs,
  });


  my $slave_bbt =
     $slave->_get_exclusively_named_port_by_type('beginbursttransfer');

  if ($slave_bbt)
  {
     $this->get_and_set_once_by_name({
        thing => 'assign',
        name => "$slave_id begin burst transfer to slave",
        lhs => $slave_bbt,
        rhs => $beginbursttransfer,
     });
  }
  return;
}



=item I<_handle_arbitration_holdoff()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_arbitration_holdoff
{
  my $this = shift;
  my $slave_id = shift or &ribbit ("no_slave_id");

  my @master_descs = $this->_get_master_descs();
  my $first_master_has_arbiterlock = $this->_get_qualified_arbiterlock($master_descs[0]);
  my $slave_does_have_arbiterlock = $this->_get_slave($slave_id)->_get_exclusively_named_port_by_type('arbiterlock');



  if (@master_descs > 1 || (!$first_master_has_arbiterlock && $slave_does_have_arbiterlock))
  {


    return if !$this->slave_needs_arbitration_logic($slave_id);
    my $bridge_slave_id = $this->_get_slave_id();

    my $arbitration_holdoff = $this->get_arbitration_holdoff($bridge_slave_id);
    my $begin_xfer = $this->_make_begin_xfer();
  
    my $firsttransfer = $this->_make_signal("$bridge_slave_id/firsttransfer");


    my $allow_new_arb_cycle =
      $this->_make_signal("$bridge_slave_id/allow_new_arb_cycle");



    my $anycontinuerequest = $this->_make_signal("$bridge_slave_id/any_continuerequest");
    my $slave_enables_arbiterlock = $this->_make_signal("$bridge_slave_id/slavearbiterlockenable");

    $this->get_and_set_once_by_name({
      thing => 'assign',
      name => "$firsttransfer first transaction",
      lhs => e_signal->new({name => $firsttransfer, never_export => 1,}),
      rhs => complement(and_array($slave_enables_arbiterlock, $anycontinuerequest)),
    });
   
    $this->get_and_set_once_by_name({
      thing => 'assign',
      name => "$arbitration_holdoff arbitration_holdoff",
      lhs => e_signal->new({name => $arbitration_holdoff, never_export => 1,}),
      rhs => and_array($begin_xfer, $firsttransfer),
    });
  }
  return;
}

sub _handle_debugaccess
{
  my $this = shift;
  my $slave_id = shift or &ribbit ("no_slave_id");
  my $slave = $this->_get_slave($slave_id);

  my $slave_signal = 
    $slave->_get_exclusively_named_port_or_its_complement('debugaccess')
      or return;

  my $mux = $this->get_and_set_thing_by_name({
    thing => 'mux',
    name => "debugaccess mux",
    out => $slave_signal,
    default => 0,
  });
  
  foreach my $master_desc ($this->_get_master_descs())
  {
    my $master = $this->_get_master($master_desc);
    
    my $master_port =
      $master->_get_exclusively_named_port_or_its_complement('debugaccess');
    
    next unless $master_port;
    
    my $master_grant = $this->_get_master_grant_signal_name
                              ($master_desc,$slave_id);
    $mux->add_table([
        $master_grant => $master_port,
    ]);
  }
}



=item I<_handle_burstcount()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_burstcount
{
   my $this = shift;
   my $slave_id = shift or &ribbit ("no_slave_id");
   my $slave = $this->_get_slave($slave_id);

   my $slave_burstcount =
       $this->get_slave_burstcount($slave) or return;

   my $mux = $this->get_and_set_thing_by_name({
     thing => 'mux',
     name => "burstcount mux",
     out => $slave_burstcount,
     default => 1,
   });
   
   foreach my $master_desc ($this->_get_master_descs())
   {
      my $master       = $this->_get_master($master_desc);
      
      my $master_can_burst =
        $master->_get_exclusively_named_port_or_its_complement('burstcount');
      
      next unless $master_can_burst;
      
      my $master_grant = $this->_get_master_grant_signal_name
                                ($master_desc,$slave_id);
      $mux->add_table([
          $master_grant => $this->get_master_burstcount_port($master),
      ]);
   }
}



=item I<_handle_arbiterlock()>

Wire up arbiterlock or equivalent to a slave which has arbiterlock

=cut

sub _handle_arbiterlock
{
    my $this = shift;
    my $slave_id = shift;

    my $slave = $this->_get_slave($slave_id);

    my $slave_arblock = 
        $slave->_get_exclusively_named_port_or_its_complement('arbiterlock');

    if ($slave_arblock)
    {
        foreach my $master_desc ($this->_get_master_descs())
        {
	    my $rhs = $this->_create_arbiterlock_proxy($master_desc, $slave_id);
            $this->get_and_set_thing_by_name({
                thing => 'mux',
                name  => "$slave_id arbiterlock assigned from _handle_arbiterlock",
                lhs   => $slave_arblock,
                add_table => [$rhs => $rhs],
            })
        }
    }
}



=item I<_handle_arbiterlock2()>

Wire up arbiterlock2 to a slave which has arbiterlock2.

=cut

sub _handle_arbiterlock2
{
    my $this = shift;
    my $slave_id = shift;

    my $slave = $this->_get_slave($slave_id);

    my $slave_arblock = 
        $slave->_get_exclusively_named_port_or_its_complement('arbiterlock2');

    if ($slave_arblock)
    {
        foreach my $master_desc ($this->_get_master_descs())
        {
	    my $rhs = $this->_get_arbiterlock_proxy2($master_desc);
            $this->get_and_set_thing_by_name({
                thing => 'mux',
                name  => "$slave_id arbiterlock2 assigned from _handle_arbiterlock2",
                lhs   => $slave_arblock,
                add_table => [$rhs => $rhs],
            })
        }
    }
}



=item I<_handle_native_address()>

Handle native address.

=cut

sub _handle_native_address
{
  my $this = shift;
  my $slave_id = shift;

  my $slave = $this->_get_slave($slave_id);

  my $slave_native_address = 
    $slave->_get_exclusively_named_port_or_its_complement('nativeaddress');


  if ($slave_native_address)
  {
    my $slave_shift = 0;
    if ($slave->is_adapter())
    {



      $slave_shift = $this->_get_slave_aligned_shift($slave_id);
    }

    my $slave_SBI = $slave->{SYSTEM_BUILDER_INFO};
    my $slave_address_width = eval($slave_SBI->{Address_Width}) - $slave_shift;
    my ($slave_address_port) = $slave->_get_port_or_its_complement("address");
    if ($slave_address_port)
    {
      $slave_address_width = $slave_address_port->width() - $slave_shift;
    }

    $slave_address_width = 1 if $slave_address_width <= 0;
    my $mux = $this->get_and_set_thing_by_name({
      thing => 'mux',
      name => "slaveid $slave_native_address nativeaddress mux",
      out => {name => $slave_native_address, width => $slave_address_width,},
    });

    foreach my $master_desc ($this->_get_master_descs())
    {
      my $master = $this->_get_master($master_desc);
      my $master_native_address = 
        $master->_get_exclusively_named_port_or_its_complement('nativeaddress');
      my $master_grant =
        $this->_get_master_grant_signal_name($master_desc, $slave_id);
     
      if (!$master_native_address)
      {

        my $master_byteaddress = $this->get_master_address_port($master);
        my $master_shift = log2($this->_get_master_data_width($master_desc) / 8);
        $master_native_address = "($master_byteaddress >> $master_shift)";
      }

      $mux->add_table([
        $master_grant => $master_native_address,
      ]);
    }
  }
}



=item I<_handle_chip_selects()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_chip_selects
{
   my $this = shift;
   my $slave_id = shift or &ribbit ("no slave_id");

   my $slave     = $this->_get_slave($slave_id);
   my $slave_SBI = $slave->{SYSTEM_BUILDER_INFO};

   my $register_outgoing_signals =
       $this->_slave->{SYSTEM_BUILDER_INFO}{Register_Outgoing_Signals};

   my $port =
       $slave->_get_exclusively_named_port_or_its_complement("chipselect");

   if ($port)
   {
      my @or_this = ();
      my @master_granted_slaves = ();


      my $msg_preamble = 
          "Slave '$slave_id' with a port of type 'chipselect' requires ";

      if ($slave_SBI->{Bus_Type} =~ /tristate/)
      {
          if (! $slave->_get_exclusively_named_port_by_type("data"))
          {
              &ribbit($msg_preamble."a port of type 'data'.");
          }
      } else {
          my $slave_readdata =
              $this->get_slave_readdata_port($slave);
          my $slave_writedata = 
              $this->get_slave_writedata_port($slave);
          if (! ($slave_readdata || $slave_writedata) )
          {
              &ribbit($msg_preamble.
                      "a port of type 'readdata' or 'writedata'.");
          }
      }


      foreach my $master_desc ($this->_get_master_descs())
      {
         push (@master_granted_slaves,
               $this->_get_master_grant_signal_name
               ($master_desc,$slave_id)
               );
      }







      my $inhibit_chip_selects;
      my ($read_wait,$setup_time,$hold_time) = $this->
                _get_wait_states($slave_id,"read");
      my ($write_wait,$setup_time,$hold_time) = $this->
          _get_wait_states($slave_id,"read");

      if (($read_wait =~ /\D/) && ($write_wait =~ /\D/))
      {
         $inhibit_chip_selects = $port;
      }
      elsif ($read_wait =~ /\D/)
      {
         $inhibit_chip_selects = &and_array
             ($port,
              $slave->_get_exclusively_named_port_or_its_complement
              ("read"));
      }
      elsif ($write_wait =~ /\D/)
      {
         $inhibit_chip_selects = &and_array
             ($port,
              $slave->_get_exclusively_named_port_or_its_complement
              ("write"));
      }

      if ($register_outgoing_signals && $inhibit_chip_selects)
      {
         my $wait_request_n = $slave->
             _get_exclusively_named_port_or_its_complement
                 ("waitrequest_n");

         my $string = "${port}_selected_last_time";
         $this->get_and_set_once_by_name
             ({
                thing => "register",
                name  => "$string register",
                out   => [$string, 1],
                enable => 1,
                in    => $port,
             });

         push (@or_this, &or_array (@master_granted_slaves)
               ."& ~($wait_request_n & $string)");
      }
      else
      {
         push (@or_this, @master_granted_slaves);
      }



      if ($slave_SBI->{Active_CS_Through_Read_Latency})
      {
         my $bridge_latency = $this->_get_bridge_latency($slave_id);

         foreach my $master_desc ($this->_get_master_descs())
         {
            my $shift_register = $this->
                _get_read_latency_fifo_is_non_empty_name
                    ($master_desc,$slave_id);

            next if !$shift_register;

            my $read_latency = $this->get_read_latency($slave_id);

            if ($read_latency > $bridge_latency) {

              push (@or_this,
                  "(|$shift_register\[$shift_register.msb - $bridge_latency : 0\])");
            } else { # no slave read latency.
              &goldfish ("Should not have Active_CS_Through_Read_Latency".
                  " set without setting some Read_Latency.");
            }
         }
      }

      my $export_cs = !($register_outgoing_signals);
      e_signal->new([$port, 1, $export_cs])->within($this); # export chipselect
      my $e = e_assign->new([$port, &or_array(@or_this)]);
      $e->within($this);

   }
   else
   {



   }
   return;
}



=item I<_handle_wait_states()>

Handle_wait_states and its helper functions generate the following signals.

 slave_read_wait
    true while a slave is waiting to finish its read cycle.
 slave_write_wait
    true while a slave is waiting to finish its write cycle.
 in_a_read_cycle
    true if the slave is in a read cycle
 in_a_write_cycle
    true if the slave is in a write cycle

=cut

sub _handle_wait_states
{
   my $this = shift;

   $this->_make_slave_wait_signals(@_);
   return;
}








=item I<_handle_read_data_valid()>

To support read latency.

MASTERS WHICH SUPPORT LATENCY:
MUST HAVE:
 read_data_valid pin: a pin which goes valid
 whenever a slave has valid data for the master.

MAY HAVE:
 read_data_address bus: the corresponding
 address for the data being read by the master.

 flush_latent_pipeline pin: a pin from the
 master which flushes all latent data going to
 the master.  Data which has been flushed will
 never set the read_data_valid pin.

SLAVES WHICH SUPPORT LATENCY:
MUST HAVE:
 Read_Latency set to non zero numeric value.
     Or be instantiated outside the system.

If a slave with Read_Latency is set by a Master which does not
support latency, the Slave Arbitrator will make the Master wait for
<Read_Latency> cycles.

If a master which supports latency reads from a slave which does
not, the Slave Arbitrator will wire the inverse of the masters'
wait pin to the read_data_valid pin for read accesses.

For masters which support latency, it is the job of the Master
Arbitrator to ensure that reads to the latent master are received
in the same order which they were requested.

There once was a provision for a stall_pipe pin from the slave which
stalls the read pipe.  This has ramifications on the Master
Arbitrator Ordering (see above paragraph), read_data_valid pins,
(~stall_pipe_pin ANDs with the last
read_data_valid_pin to avoid reading the same data a thousand times
while stall is true) and with read wait states for non latent
masters.

There is a whole bunch of things which happen differently based
upon if the master/slave can handle read latency.  Not all of them
are handled in these functions.  However, the following table
describes all the differences.

Slave Supports Rd_Latency, Master Supports Rd_Latency.
   Read Data Mux Select  => RDV
   Slave Read Wait       => Old Wait.
   Generate Latency Regs => Yes.
   Master RDV pin        => RDV

Slave Supports Rd_Latency, Master Does Not.
   Read Data Mux Select  => RDV or M_Request_Slave
   Slave Read Wait       => ~RDV
   Generate Latency Regs => Yes.
   Master RDV pin        => N/A.

Slave Doesn't Have Rd_Latency, Master Does.
   Read Data Mux Select  => ~Slave_Read_Wait
   Slave Read Wait       => Old Wait.
   Generate Latency Regs => No.
   Master RDV pin        => ~Slave_Read_Wait.

Neither Slave Nor Master support latency.
   Read Data Mux Select  => M_Requests_Slave
   Slave Read Wait       => Old Wait.
   Generate Latency Regs => No.
   Master RDV pin        => N/A.

=cut

sub _handle_read_data_valid
{
   my $this = shift;
   my $master_desc = shift or &ribbit ("no master_d");
   my $slave_id    = shift or &ribbit ("no slave_id");

   my $slave       = $this->_get_slave($slave_id);

   my $slave_id_of_end_slave = $slave_id; 

   my $master       = $this->_get_master($master_desc);
   my $master_read  = $this->get_master_read($master)
           or return;
   my $master_run   = $this->_get_master_run($master_desc);

   $this->get_master_readdata_port($master) or return;

   my $master_read_data_valid = $this->get_master_readdatavalid($master);


   my $local_read_valid = $this->get_read_data_valid_signal_name
       ($master_desc,$slave_id);

   my $read_latency     = $this->get_read_latency($slave_id);

   my $variable_read_latency = $this->get_variable_read_latency($slave_id);

   my @master_starts_reading = ($this->_get_master_grant_signal_name
                                ($master_desc,$slave_id_of_end_slave),
                                $master_read,
                                &complement($this->get_slave_wait
                                            ("read", $slave_id)),
                                );

   my $qualified_master_flush;

   my $to_be_flushed_rdv;
   my $not_flushed_rdv;



   if ($master_read_data_valid)
   {



      my $something_granted = 
          $this->_make_signal("$master_desc/is_granted_some_slave");
      my $nothing_selected = 
          $this->_make_signal("$master_desc/read_but_no_slave_selected");
      if ($this->is_single_master_to_single_slave_connection())
      {
         $nothing_selected = 0;
      }
      else
      {
         my $something_granted = 
             $this->_make_signal("$master_desc/is_granted_some_slave");
         $master->_arbitrator->get_and_set_once_by_name
             ({
                 thing     => "register",
                 name      => "$nothing_selected assignment",
                 out       => $nothing_selected,
                 in        => "$master_read & $master_run & ~".$something_granted,
                 enable    => "1",
             });
         $master->_arbitrator->get_and_set_thing_by_name
             ({
                 thing     => "mux",
                 type      => "and_or",
                 name      => "some slave is getting selected",
                 out       => $something_granted,
                 add_table => [$this->_get_master_grant_signal_name
                                             ($master_desc,$slave_id_of_end_slave),
                               $this->_get_master_grant_signal_name
                                             ($master_desc,$slave_id_of_end_slave) ],
             });
   
      }

      my $pre_flush = "pre_flush_$master_read_data_valid";
      $pre_flush =~ s/\~//g;

      $to_be_flushed_rdv =
          $master->_arbitrator->get_and_set_thing_by_name
              ({
                 thing => "mux",
                 type  => "and_or",
                 name  => "latent slave read data valids which may be flushed",
                 out   => [$pre_flush, 1],
              });

      $qualified_master_flush = $this->_make_qualified_flush_for_master($master_desc);
      $pre_flush = &and_array ($pre_flush,&complement($qualified_master_flush))
          if ($qualified_master_flush);




      $not_flushed_rdv =
          $master->_arbitrator->get_and_set_thing_by_name
              ({
                 thing     => "mux",
                 type      => "and_or",
                 name      => "latent slave read data valid which is not flushed",
                 out       => $master_read_data_valid,
                 add_table => [$nothing_selected, $nothing_selected],
              });
      $master->_arbitrator->get_and_set_thing_by_name
          ({
              thing     => "mux",
              type      => "and_or",
              name      => "latent slave read data valid which is not flushed",
              out       => $master_read_data_valid,
              add_table => [$pre_flush, $pre_flush],
          });
   }

   my $local_read_valid_rhs;
   if ($variable_read_latency || $read_latency)
   {




      my $latency_shift_register =
          $this->_get_read_latency_fifo_is_non_empty_name
              ($master_desc,$slave_id);


      if ($latency_shift_register)
      {
         $qualified_master_flush = $this->_make_and_export_qualified_flush_for_master($master_desc);
         if ($read_latency)
         {
            my $in = $latency_shift_register."_in";

      my $rhs = &and_array (@master_starts_reading,
                                  ($master_read_data_valid) ? "" :
                                  "~(|$latency_shift_register)");


      $this->get_and_set_thing_by_name
      ({
          thing => 'mux',
          name  => "$in mux for readlatency shift register",
          lhs => [$in,1],
          add_table => [$rhs, $rhs],
          type => "and_or",
      });

      my @flush_array = ();

      push (@flush_array ,($qualified_master_flush => $in))
          if ($qualified_master_flush);

      $this->get_and_set_thing_by_name
      ({
          thing => 'mux',
          name  => "shift register p1 $latency_shift_register in if flush, otherwise shift left",
          lhs   => "p1_".$latency_shift_register,

          add_table => [@flush_array],

          default   => "{$latency_shift_register, $in}",
      });

      $this->get_and_set_once_by_name
        ({
          thing      => 'register',
          name       => "$latency_shift_register for remembering which master asked for a fixed latency read",
          enable     => 1,
          out        => [$latency_shift_register => $read_latency],
         });

      $local_read_valid_rhs = "$latency_shift_register\[$latency_shift_register.msb\]";
         }
         elsif ($variable_read_latency)
         {
            my $slave_readdatavalid = $this->get_slave_readdatavalid_port($slave);
            $slave_readdatavalid || &ribbit 
              ("$slave_id has variable latency but no readdatavalid port");





            
            my $master_desc = $master->get_id();
            my $slave_id = $this->_slave()->get_id();

            $this->_make_variable_readlatency_fifos($master);

            if (($this->_get_master_descs() > 1) || 
                $master->
                _get_exclusively_named_port_or_its_complement('flush')) 
            {
                $slave_readdatavalid = &and_array
                    ($slave_readdatavalid,
                     $this->get_rdv_fifo_out_name
                     ($master_desc,$slave_id)) 
                     . " & ~ " . 
                     $this->get_rdv_fifo_empty($master_desc, $slave_id);
            }




            my $fifo_empty = $this->get_rdv_fifo_empty($master_desc,$slave_id);
            

            e_assign->new([
              {name => $latency_shift_register, export => 1,},
              "~$fifo_empty"
            ])->within($this);

            $this->_sink_signal_in_master_arbitrator
                ($latency_shift_register,
                 $master_desc);

            $local_read_valid_rhs = $slave_readdatavalid;
         }

         my $to_be_flushed_term = $local_read_valid;
         $to_be_flushed_term .= " & dbs_rdv_counter_overflow"
             if ($this->_how_many_bits_of_dynamic_bus_size_are_needed
                 ($master_desc,$slave_id_of_end_slave) > 0);

         $to_be_flushed_rdv->add_table($to_be_flushed_term,$to_be_flushed_term)
             if ($to_be_flushed_rdv);
      }
   }
   elsif ($master_read_data_valid)
   {


      $local_read_valid_rhs = &and_array (@master_starts_reading);

      my $local_read_valid_to_mux = $local_read_valid;
      $local_read_valid_to_mux .= " & dbs_counter_overflow"
          if ($this->_how_many_bits_of_dynamic_bus_size_are_needed
              ($master_desc,$slave_id_of_end_slave) > 0);

      if ($not_flushed_rdv)
      {
        $not_flushed_rdv->add_table
            ($local_read_valid_to_mux,$local_read_valid_to_mux);
      }
   }

   if ($local_read_valid_rhs)
     {
       $this->get_and_set_thing_by_name
        ({
          thing => 'mux',
          name  => "local readdatavalid $local_read_valid",
          lhs   => [$local_read_valid => 1],
          add_table => [$local_read_valid_rhs, $local_read_valid_rhs],
          type  => "and_or",
          });
     }























}



=item I<_handle_read_data()>

This method handles the connection between a master's readdata and a slave's
readdata, modifying each as is necessary to support features like latency, dbs
shifting, converting x's to 0's, and other fancy schmancy stuff.  

This method is concerned with defining and fleshing out the internal Avalon
logic, not with the actual readdata ports themselves.  If you're interested in
the readdata ports themselves, use the other access methods:
"get_slave_readdata_port" and "get_master_readdata_port".

=cut

sub _handle_read_data
{
   my $this = shift;

   my $master_desc = shift or &ribbit ("no master_desc");
   my $slave_id    = shift or &ribbit ("no slave_id");

   my $master           = $this->_get_master($master_desc);
   my $slave            = $this->_get_slave($slave_id);
   my $slave_SBI        = $slave->{SYSTEM_BUILDER_INFO};
   my $slave_data_width = $slave_SBI->{Data_Width};






   my $this_slave_SBI = $this->_slave()->{SYSTEM_BUILDER_INFO};

   my $slave_readdata = $this->get_slave_readdata_port($slave)
    or return;
   my $master_readdata = $this->get_master_readdata_port($master)
    or return;







   if (($slave_SBI->{Convert_Xs_To_0} && 
        !$master->{SYSTEM_BUILDER_INFO}{Is_Instruction_Master}
        ) ||
       $this_slave_SBI->{MASTERED_BY}{$master_desc}{Convert_Xs_To_0})
   {
       {


          my $sig = $this->get_and_set_thing_by_name({
            thing => 'signal',
            name => $slave_readdata,
          });
      
          my $old_width = $sig->width();
          $sig->width($slave_data_width) if ($slave_data_width > $old_width);
       }

       my $old_slave_readdata = $slave_readdata;
       $slave_readdata = $slave_readdata."_with_Xs_converted_to_0";



       e_signal->new ([$slave_readdata => $slave_data_width, 1, 0, 1])
           ->within($this);


       $this->get_and_set_once_by_name({
           thing  => "assign",
           name   => "synthesis $slave_readdata (Not X)",
           lhs    => $slave_readdata,
           rhs    => $old_slave_readdata,
           tag    => 'synthesis',
       });



       foreach my $index (0 .. ($slave_data_width - 1))
       {
           my $bit_is_x = $old_slave_readdata."_bit_${index}_is_x";
           

           $this->get_and_set_once_by_name({
               thing => "assign_is_x",
               name  => "$bit_is_x x check",
               lhs   => [$bit_is_x => 1],
               rhs   => $old_slave_readdata."[$index]",
               tag   => 'simulation',
           });


           $this->get_and_set_once_by_name({
               thing => "assign",
               name  => "Crush $slave_readdata\[$index\] Xs to 0",
               lhs   => "$slave_readdata\[$index\]",
               rhs   => "$bit_is_x ? 1'b0 : ".
                   "$old_slave_readdata\[$index\]",
               tag   => 'simulation',
               });    
       }
   }

   e_signal->new ({name   => $slave_readdata,
                   width  => $slave_data_width,
                   copied => 1,
                   export => 1,
                  })->within ($this);

   my $master_request = $this->_get_master_request_signal_name
       ($master_desc,$slave_id);

   my $qualified_request =
       $this->_get_master_qualified_request_signal_name
           ($master_desc,$slave_id);


   $this->_do_we_have_enough_control_ports_to_read($master) or &ribbit
       ("$master_desc has a read data port but not enough control signals ".
        "for a read port\n",
        "<Pink_Floyd>How can you have a read data port if you\n",
        "don't have a read port?! </Pink_Floyd>");

   my $dbs_shift =
       $this->_how_many_bits_of_dynamic_bus_size_are_needed
           ($master_desc,$slave_id);

   my $read_latency = $this->get_read_latency($slave_id);
   my $variable_read_latency = $this->get_variable_read_latency($slave_id);

   my $master_dw  = $master->{SYSTEM_BUILDER_INFO}{Data_Width};
   my $master_msb = $master_dw - 1;

   my $slave_dw  = $slave_SBI->{Data_Width};
   my $slave_msb = $slave_dw - 1;

   my $local_rdv  = $this->get_read_data_valid_signal_name
       ($master_desc,$slave_id);

   my $slave_is_latent = $read_latency || $variable_read_latency;
   my $master_is_latent = $master->_can_handle_read_latency();
   my $is_latent = $slave_is_latent && $master_is_latent;
   my $master_readdata_select;
   
   if ($is_latent)
   {
     $master_readdata_select = $local_rdv;
   }
   elsif ($master_is_latent)
   {
     my $master_read = $this->get_master_read($master);
     $master_readdata_select = and_array($qualified_request, $master_read);
   }
   else
   {
     $master_readdata_select = $master_request;
   }





   if ($dbs_shift > 0)
   {



















      my $num_holding_registers = (2 ** $dbs_shift) - 1;

      my @segment_list = ();
      for (my $i = 0; $i < $num_holding_registers; $i++)
      {
         my $reg_name =
           $is_latent ?
           "dbs_latent_" . $slave_dw . "_reg_segment_$i" :
           "dbs_"        . $slave_dw . "_reg_segment_$i";

         $master->_arbitrator()->add_contents
             (e_signal->news([    $reg_name,  $slave_dw],
                             ["p1_$reg_name", $slave_dw] ));

         $master->_arbitrator()->get_and_set_thing_by_name
             ({
                thing => "mux",
                name  =>
                  $is_latent ?
                  "input to latent " . "dbs-$slave_dw stored $i" :
                  "input to "        . "dbs-$slave_dw stored $i",
                lhs   => "p1_$reg_name",
                add_table => [$master_readdata_select
                              => $slave_readdata],
             });

         my $segment_enable;
         if ($is_latent)
         {
           my $master_dbs_rdv_counter =
             $this->_get_master_dbs_rdv_counter($master_desc);
           my $dbs_index =
             $this->_get_my_portion_of_master_dbs_rdv_counter($master_desc, $slave_id);

           $segment_enable = "dbs_rdv_count_enable & (($dbs_index) == $i)";
         }
         else
         {


            my $dbs_index =
                $this->_get_my_portion_of_master_dbs_address($master_desc,
                                                             $slave_id);
            $segment_enable = "dbs_count_enable & (($dbs_index) == $i)";
         }

         $master->_arbitrator()->get_and_set_thing_by_name
             ({thing  => "register",
               name   => $is_latent ?
               "dbs register for latent dbs-$slave_dw segment $i" :
               "dbs register for " .   "dbs-$slave_dw segment $i",
               in     => "p1_$reg_name",
               out    => $reg_name,
               enable => $segment_enable,
            });

         push (@segment_list, $reg_name);
      }

      push (@segment_list, "$slave_readdata [ $slave_data_width - 1 : 0]");

      my @endian_aware_segment_list;
      if($this->is_big_endian_master($master_desc)) {
        @endian_aware_segment_list = @segment_list;
      } else {
        @endian_aware_segment_list = reverse(@segment_list);
      }
      $slave_readdata = &concatenate ((@endian_aware_segment_list));
   }
   elsif ($dbs_shift < 0)
   {









      my $wide_readdata = $slave_readdata;
      $slave_readdata   = $this->_make_signal($slave_readdata."_part_selected_by_negative_dbs");


      
      my $master_address =
        $this->get_master_address_port($this->_get_master($master_desc));


      my $select_address_lsb = &log2($master_dw / 8);

      my $neg_shift = -$dbs_shift;


      my $part_name;
      {
       $neg_shift == 1 and do {$part_name = 'half'; last};
       $neg_shift == 2 and do {$part_name = 'fourth'; last};
       $neg_shift == 3 and do {$part_name = 'eighth'; last};
       $neg_shift == 4 and do {$part_name = 'sixteenth'; last};
       $neg_shift == 5 and do {$part_name = 'thirtysecond'; last};



       do {$part_name = "@{[2**$neg_shift]}_ant"; last};
      }



      $master->_arbitrator()->get_and_set_thing_by_name
          ({
             thing   => "mux",
             name    => "negative-dynamic mux for slave $slave_readdata",
             lhs     => e_signal->new ([$slave_readdata, $master_dw]),
             comment => "Negative Dynamic Bus-sizing mux.\n".
                        "    this mux selects the correct $part_name of the \n".
                         "   wide data coming from the slave $slave_id ",

             });

      my @neg_dbs_table = ();
      my $read_latency = $this->get_read_latency($slave_id);
      my $variable_read_latency = $this->get_variable_read_latency($slave_id);






      my $selector_msb = $select_address_lsb + $neg_shift - 1;

      my $selector_name =
       "$master_address [$selector_msb:$select_address_lsb ]";
      $selector_name = "$master_address \[$select_address_lsb\]"
       if $dbs_shift == -1;

      if (($read_latency > 0) && ($master->_can_handle_read_latency()))
      {

       $master->_arbitrator()->get_and_set_thing_by_name
          ({
            thing   => "register",
            name    => "1/$neg_shift select of latency $read_latency",
            out     => e_signal->new (["selecto_$neg_shift\_$read_latency",$neg_shift]),
            in      => $selector_name,
            delay   => $read_latency,
            enable  => "1'b1",
            comment => "Negative Dynamic Bus-sizing mux.\n".
                        "    this mux selects the correct $part_name of the \n".
                        "   wide data coming from the slave $slave_id ",

            });
       $selector_name = "selecto_$neg_shift\_$read_latency";
      }
      elsif (($variable_read_latency > 0) &&
       ($master->_can_handle_read_latency()))
      {


























        my $fifo_name = $this->_make_signal(
          "selecto_nrdv_$master_desc\_$neg_shift\_$slave_id\_fifo"
        );
        my $fifo_output = "$fifo_name\_output";

        my $master_arb = $master->_arbitrator();


        my $fifo_read =
          $this->_make_signal("read_$fifo_name");
        e_signal->new({
          name => $fifo_read,
          never_export => 1,
        })->within($master_arb);

        my $this_slave_rdv =
          $this->get_read_data_valid_signal_name(
            $master_desc, $slave_id
          );

        $master_arb->get_and_set_thing_by_name({
           thing => 'mux',
           name => "$fifo_read fifo read",
           type => 'and_or',
           lhs => $fifo_read,
           add_table => [$this_slave_rdv, $this_slave_rdv],
        });


        my $fifo_write =
          $this->_make_signal("write_$fifo_name");
        e_signal->new({
          name => $fifo_write,
          never_export => 1,
        })->within($master_arb); 
        my $this_slave_read_complete = and_array(
          $this->get_master_read($master), 
          $this->_get_master_run($master_desc), 
          $this->_get_master_request_signal_name($master_desc, $slave_id),
        );

        $master_arb->get_and_set_thing_by_name({
           thing => 'mux',
           name => "$fifo_write fifo write",
           type => 'and_or',
           lhs => $fifo_write,
           add_table => [$this_slave_read_complete, $this_slave_read_complete],
        });




        my $fifo_flush = $this->_make_qualified_flush_for_master($master_desc)
          || "1'b0";


        my $fifo_empty = 
          $this->_make_signal("empty_$fifo_name");
        my $fifo_full = 
          $this->_make_signal("full_$fifo_name");
        e_signal->new({
          name => $fifo_empty,
          never_export => 1,
        })->within($master_arb);
        e_signal->new({
          name => $fifo_full,
          never_export => 1,
        })->within($master_arb);


        e_signal->new({
          name => $fifo_output,
          width => $neg_shift,
          never_export => 1,
        })->within($master_arb);



        my $output_selector_name =
          $this->_make_signal("$fifo_output\_$slave_id");
        e_signal->new({
          name => $output_selector_name,
          width => $neg_shift,
          never_export => 1,
        })->within($master_arb);

        if ($this->is_burst_master($master))
        {




          e_assign->new({
            lhs => $output_selector_name,

            rhs => sprintf("%d'b0", $neg_shift),
          })->within($master_arb);
          



          $fifo_read = "1'b0";
          $fifo_write = "1'b0";
          $fifo_flush = "1'b1";
        }
        else
        {
          e_assign->new({
            lhs => $output_selector_name,
            rhs => $fifo_output,
          })->within($master_arb);
        }

        my $fifo = $master_arb->get_object_by_name($fifo_name);
        if ($fifo)
        {




          if ($fifo->depth() < $variable_read_latency)
          {
            $fifo->depth($variable_read_latency);
          }
        }
        else
        {

          $master_arb->get_and_set_thing_by_name({
            thing => 'fifo_with_registered_outputs',
            name  => $fifo_name,
            depth => $variable_read_latency,
            port_map => {
              data_in => $selector_name,
              data_out => $fifo_output,
              write => $fifo_write,
              empty => $fifo_empty,
              full => $fifo_full,
              read => $fifo_read,
              sync_reset => "1'b0",
              clear_fifo => $fifo_flush,
              fifo_contains_ones_n => 'open',
            },
          });
        }


        $selector_name = $output_selector_name;


        $master_arb->get_and_set_once_by_name({
          name => "$fifo_name read when empty",
          thing => 'process',
          tag => 'simulation',
          contents => [
            e_if->new({
              condition => "$fifo_empty & $fifo_read",
              then => [
                e_sim_write->new({
                  spec_string =>
                    "$master_desc negative rdv fifo $fifo_name: " .
                    "read AND empty.\\n",
                  show_time => 1,
                }),
                e_stop->new(),
              ],
            }),
          ],
        });
        $master_arb->get_and_set_once_by_name({
          name => "$fifo_name write when full",
          thing => 'process',
          tag => 'simulation',
          contents => [
            e_if->new({
              condition => "$fifo_full & $fifo_write & ~$fifo_read",
              then => [
                e_sim_write->new({
                  spec_string =>
                    "$master_desc negative rdv fifo $fifo_name: " .
                    "write AND full.\\n",
                  show_time => 1,
                }),
                e_stop->new(),
              ],
            }),
          ],
        });
      }





      
      my @address_values = (0 .. -1 + 2 ** (-$dbs_shift));
      if($this->is_big_endian_master($master_desc))
      {
        @address_values = reverse(@address_values);
      }
     
      my $current_segment = 0;
      foreach my $address_value (@address_values) 
      {
        my $lsb_index = $current_segment * $master_dw;
        my $msb_index = ($current_segment + 1) * $master_dw - 1;
        push (@neg_dbs_table,
              "($selector_name == $address_value)" =>
              "$wide_readdata \[$msb_index : $lsb_index\]",);
        $current_segment++;
      }


      $master->_arbitrator()->get_and_set_thing_by_name
          ({
             thing   => "mux",
             name    => "negative-dynamic mux for slave $slave_readdata",
             table   => \@neg_dbs_table,
          });

   } #end of dbs fun.

   if (!$this->_registered_wait_states_are_predictable($master_desc,
                                                      $slave_id,
                                                       "read"))
   {






      my $reg_name = "registered_".$master_readdata;
      $master->_arbitrator()->get_and_set_thing_by_name
          ({
             name  => "unpredictable registered wait state incoming data",
             thing => "register",
             enable => 1,
             out   => [$reg_name,
                       $master_dw,0,1,1],
          });

      my $pre_reg = "p1_".$reg_name;

      $master->_arbitrator()->get_and_set_thing_by_name
          ({
             thing => "mux",
             name  => "registered readdata mux",
             type  => 'or_and',

             lhs   => $pre_reg,
             add_table => [$master_readdata_select,
                           $slave_readdata],
          });
      $slave_readdata = $reg_name;

   }

   $master->_arbitrator()->get_and_set_thing_by_name
       ({
          thing => "mux",


          name  => "$master_desc readdata mux",
          type  => "small",
          lhs   => $master_readdata,
          add_table => [$master_readdata_select,
                        $slave_readdata],
       });
}




=item I<_get_write_latency()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_write_latency
{
   my $this = shift;
   my $slave = shift;

   my $slave_sbi = $slave->{SYSTEM_BUILDER_INFO};   
   return $slave_sbi->{Write_Latency} || 0;
}


=item I<_handle_write_data()>

_handle_write_data only gets complicated if we're dynamically bus
sizing.  Otherwise it's just generic wiring.

=cut

sub _handle_write_data
{
   my $this = shift;
   my $master_desc = shift or &ribbit ("no md");
   my $slave_id    = shift or &ribbit ("no slave_id");

   my $master      = $this->_get_master($master_desc);
   my $slave       = $this->_get_slave($slave_id);
   my $slave_sbi   = $slave->{SYSTEM_BUILDER_INFO};
   my $slave_dw    = $slave_sbi->{Data_Width};

   my $write_latency = $this->_get_write_latency($slave);
   my $master_writedata = $this->get_master_writedata_port($master);

   my $master_write = $this->get_master_write($master);

   ($master_write && $master_writedata) or return;

   my $port = $this->get_slave_writedata_port($slave);
   if (!$port)
   {
      my $data_port =
          $slave->_get_exclusively_named_port_by_type
              ("data");

      if ($data_port)
      {
         $port = "outgoing_$data_port";

         e_signal->news({
            name   => $port,
            width  => $slave_dw,
            copied => 1,
            within => $this,
         },{
            name   => "d1_$port",
            width  => $slave_dw,
            copied => 1,
            within => $this,
         },{
            name      => $data_port,
            width     => $slave_dw,
            _is_inout => 1,
            copied    => 1,
         });

         my $slave_selected = &or_array( map {
             $this->_get_master_qualified_request_signal_name($_,$slave_id)
             } $this->_get_master_descs );
                              
         my $signal = $this->_make_signal($slave_id."_with_write_latency");

         if ($write_latency)
         {
             $this->get_and_set_once_by_name({
                 thing  => 'register',
                 name   => "$signal register",
                 out    => [$signal => 1],
                 in     => &and_array("in_a_write_cycle",$slave_selected,
                                      &complement($this->get_slave_wait
                                                  ("write",$slave_id))),
                 delay  => $write_latency,
                 enable => 1,
             });
         } else {
             $this->get_and_set_once_by_name({
                 thing  => 'assign',
                 name   => "$signal assignment",
                 lhs    => [$signal => 1],
                 rhs    => &and_array("in_a_write_cycle",$slave_selected),
             });
         }

         $this->get_and_set_thing_by_name
             ({
                 thing   => 'mux',
                 name    => 'time to write the data',
                 lhs     => [time_to_write => 1],
                 add_table => [$signal => 1],
                 default => '0',
             });
         
         if ($this->_slave->{SYSTEM_BUILDER_INFO}
             ->{Register_Outgoing_Signals})
         {
            my $register_both_ins_and_outs =
                (($this->project()->device_family =~ /^APEXII/i)  |
                 ($this->project()->device_family =~ /^STRATIX/i) |
                 ($this->project()->device_family =~ /^CYCLONE/i)
                 ) ? 1 : 0;

            $this->get_and_set_once_by_name({
               thing    => "register",
               name     => "d1_$port register",
               out      => "d1_$port",
               in       => $port,
               enable   => 1,
               fast_out => $register_both_ins_and_outs,
            });

            $this->get_and_set_once_by_name ({
               thing => "register",
               name  => "write cycle delayed by 1",
               out   => [d1_in_a_write_cycle => 1,0],
               in    => "time_to_write",
               enable => 1,
               async_value => 0,
               fast_enable => $register_both_ins_and_outs,
            });

            $this->get_and_set_once_by_name({
               thing => "assign",
               name  => "d1_$port tristate driver",
               lhs   => $data_port,
               rhs   => "(d1_in_a_write_cycle)? d1_$port:{d1_$port.width{1\'bz}}",
            });
         }
         else
         {
            $this->get_and_set_once_by_name({
               thing => "assign",
               name  => "$port tristate driver",
               lhs   => $data_port,
               rhs   => "(time_to_write)? $port:{$port.width{1\'bz}}",
            });
         }

      }
   }
   $port or return;

   e_signal->new ({name   => $port,
                   width  => $slave_dw,
                   copied => 1,
                  })->within ($this);

   my $master = $this->_get_master($master_desc);

   my $slave_msb = $slave_dw - 1;

   my $select_granted = $this->_get_master_grant_signal_name
       ($master_desc,$slave_id);

   my $dbs_shift =
       $this->_how_many_bits_of_dynamic_bus_size_are_needed
           ($master_desc,$slave_id);

   my $master_dbs_address = $this->_get_master_dbs_address
       ($master_desc);

   if ($dbs_shift > 0)
   {




      my $table_ref;
      if ($dbs_shift == 1)
      {
         my $dbs_address_msb =
             "$master_dbs_address\[$master_dbs_address\.msb\]"  ;

         if($this->is_big_endian_master($master_desc)) {
           $table_ref =[&complement($dbs_address_msb) =>
                      "$master_writedata\[$master_writedata.msb : $slave_dw\]",
                       $dbs_address_msb =>
                       "$master_writedata\[$slave_msb : 0\]"];
         } else {
           $table_ref =[$dbs_address_msb =>
                      "$master_writedata\[$master_writedata.msb : $slave_dw\]",

                       &complement($dbs_address_msb) =>
                       "$master_writedata\[$slave_msb : 0\]"];
         }         
      }
      elsif ($dbs_shift >= 2)
      {
         my $dbs_address = $this->_get_my_portion_of_master_dbs_address(
           $master_desc, $slave_id
         );
         my $left = 0;
         my $right = 0;
         
         my @segment_indices = (0 .. -1+2**$dbs_shift);
         if($this->is_big_endian_master($master_desc)) {
           @segment_indices = reverse(@segment_indices);
         } else {

         }
         
         foreach my $dbs (@segment_indices)
         {
            $left += $slave_dw;
            my $msb = $left - 1;
            push (@$table_ref,
                  "($dbs_address == $dbs)" =>
                  "$master_writedata\[$msb : $right\]"
                  );
            $right = $left;
         }
      }
      else
      {
         &ribbit ("that's impossible ($dbs_shift)\n");
      }

      my $dbs_write_data_name = $this->_make_signal
          ($this->_get_master_id($master_desc)."/dbs_write_$slave_dw");
      $master->_arbitrator()->get_and_set_thing_by_name
          ({
             thing         => "mux",
             name          => "mux write dbs $dbs_shift",
             lhs           => [$dbs_write_data_name,
                               $slave_dw],
             add_table_ref => $table_ref,
          });

      $master_writedata = $dbs_write_data_name;
   }
   elsif ($dbs_shift < 0)
   {












      my $num_copies = 2 ** -$dbs_shift;    # Cool, huh?
      my @copy_list = ($master_writedata) x $num_copies;
      $master_writedata = $master_writedata . "_replicated";


      $this->add_contents
          (
           e_assign->new
           ({
              comment => "replicate narrow data for wide slave",
              lhs     => e_signal->new ([$master_writedata, $slave_dw]),
              rhs     => &concatenate (@copy_list),
           })
           );
   }




   my $table;
   if ($write_latency)
   {
       my $out = "${master_writedata}_pipelined_by_$write_latency";
       $this->get_and_set_once_by_name({
           thing  => "register",
           delay  => $write_latency,
           name   => "$master_desc write latency pipelined data",
           out    => [$out => $slave_dw],
           in     => $master_writedata,
           enable => 1,
       });

       my $select_out = "${select_granted}_pipelined_by_$write_latency";
       my $pre_select_out = "p${write_latency}_$select_out";
       $this->get_and_set_once_by_name({
           thing  => "register",
           delay  => $write_latency,
           name   => "$select_granted latency pipelined data",
           out    => [$select_out => 1],
           in     => $pre_select_out,
           enable => 1,
       });

       $this->get_and_set_once_by_name({
           thing  => "assign",
           name   => "$pre_select_out assignment",
           lhs    => [$pre_select_out => 1],
           rhs    => $select_granted,
       });


       $table = [$select_out => $out];
   }
   else
   {

       $table = [$select_granted,
                 $master_writedata];
   }

   $this->get_and_set_thing_by_name
       ({
           thing => "mux",
           name  => "$port mux",
           lhs   => $port,
           add_table_ref => $table,
       });

}



=item I<_ensure_latent_master_reads_coherently()>

Here is the word problem we're trying to combat.
Latent capable master reads from slave A and then slave B
Slave A has read latency of 5, Slave B has read latency of 2
Make sure that the master receives A's data before B's data so as
to keep the data coherent.  Are you getting nostalgic for your
4th grade word problems now?
Solution.  Make the Master wait N cycles.  It's okay to read when
Latency_of_Last_Slave_Read - N < Latency_of_Next_Slave_Read
N counts on every cycle so if both A and B had the same latency,
you could read from them on subsequent clock cycles.

=cut

sub _ensure_latent_master_reads_coherently
{
   my $this = shift;
   my $master_desc = shift or &ribbit ("no md indahouse");
   my $slave_id    = shift or &ribbit ("no slave indahouse");
   my $master = $this->_get_master($master_desc);

   my $master_readdatavalid = $this->get_master_readdatavalid($master)
       or return;

   my $master_read = $this->get_master_read($master) or &ribbit
       ("master $master_desc has a port of type readdatavalid ",
        "but no read pin");

   my $master_request = $this->_get_master_request_signal_name
       ($master_desc,$slave_id);

   my $master_run = $this->_get_master_run($master_desc);

   my $read_latency = $this->get_read_latency($slave_id);

   my $master_arbitrator = $master->_arbitrator();

   my $coherency_counter =
       $this->_get_master_latency_counter_name($master_desc);

   $this->sink_signals($coherency_counter);



   if ($this->is_single_master_to_single_slave_connection())
   {
      $master_arbitrator->get_and_set_thing_by_name({
            name  => "latent max counter",
            thing => "assign",
            lhs => $coherency_counter,
            rhs => 0,
      });
   }
   else
   {


     e_signal->new
         ({
            name   => $coherency_counter,
            width  => &Bits_To_Encode($read_latency),
            export => 1,
            copied => 1,
         })->within($master_arbitrator);
  
     e_signal->new
         ({
            name   => "latency_load_value",
            width  => &Bits_To_Encode($read_latency),
            copied => 1,
         })->within($master_arbitrator);
  
  
     $master_arbitrator->get_and_set_thing_by_name
         ({
            name  => "latent max counter",
            thing => "register",
            enable=> 1,
            out   => $coherency_counter,
         });
  
     $master_arbitrator->get_and_set_once_by_name
         ({
            name  => "latency counter load mux",
            thing => "mux",
            lhs   => "p1_$coherency_counter",
            add_table_ref => ["$master_run & $master_read" => "latency_load_value",
                              $coherency_counter => "$coherency_counter - 1"],
            default => 0,
         });
  
     my $load_value_mux =
         $master_arbitrator->get_and_set_thing_by_name
             ({
                name  => "read latency load values",
                thing => "mux",
                type  => "and_or",
                lhs   => "latency_load_value",
             });
  
     $load_value_mux->add_table_ref([$master_request => $read_latency])
         if ($read_latency);
   }
}



=item I<_get_bridge_latency()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_bridge_latency
{
   my $this = shift;
   my $slave_id = shift || &ribbit ("no slave_id");

   my $bridge_latency = 0;
   if ($this->is_bridge())
   {
      $bridge_latency += 1
          if ($this->_slave->{SYSTEM_BUILDER_INFO}
              ->{Register_Incoming_Signals});

      my $bridge_slave_SBI = $this->_get_slave($slave_id)->{SYSTEM_BUILDER_INFO};

      $bridge_latency += 1
          if (($this->_slave->{SYSTEM_BUILDER_INFO}
              ->{Register_Outgoing_Signals})
              && ($bridge_slave_SBI->{Read_Wait_States} =~ /\d/));
   }

   return ($bridge_latency);
}



=item I<_get_slave_latency()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_slave_latency
{
   my $this = shift;
   my $slave_id = shift or &ribbit ("no sid");
   my $slave     = $this->_get_slave($slave_id);
   my $slave_SBI = $slave->{SYSTEM_BUILDER_INFO};

   my $read_latency = $slave_SBI->{Read_Latency} || 0;

   return ($read_latency);
}



=item I<_get_read_latency()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_read_latency
{
   my $this = shift;
   my $slave_id = shift or &ribbit ("no sid");
   my $simon_says = shift;
   if (!$simon_says)
   {

   }

   my $read_latency = $this->_get_slave_latency($slave_id)
                    + $this->_get_bridge_latency($slave_id);

   return ($read_latency);
}



=item I<_make_counter()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _make_counter
{
   my $this = shift;
   my $slave_id         = shift or &ribbit ("no_slave_id");
   my $load_counter_ref = shift or &ribbit ("no lc");
   my %load_counter     = @{$load_counter_ref};

   my @wait_for_counter_expr;

   my $wait_for_counter =
       $this->_get_wait_for_counter_name("$slave_id");

   if (keys (%load_counter))
   {
      my @counter_load_mux_table;
      my $max_counter;

      my $counter = $this->_get_counter_name($slave_id);
      my $counter_eq_0 = $this->_get_counter_eq_0_name($slave_id);

      foreach my $counter_key (keys (%load_counter))
      {
         my $value = $load_counter{$counter_key};
         $max_counter = $value
             if ($value > $max_counter);
         push (@counter_load_mux_table,
               "$counter_key & ".$this->_make_begin_xfer($slave_id) => $value);
      }

      push (@counter_load_mux_table,
            &complement($counter_eq_0) => "$counter - 1");

      push (@wait_for_counter_expr,
            $this->_make_begin_xfer($slave_id),
            &complement("$counter_eq_0")
            );

      e_assign->new
          ({
             within => $this,
             lhs    => [$counter_eq_0 => 1, 1],
             rhs    => "$counter == 0",
          });



      map
      {
         $this->_get_master($_)->_arbitrator()
             ->sink_signals($counter_eq_0);
      } $this->_get_master_descs();

      my $counter_next_value =
          $this->_make_signal("$slave_id/counter_load_value");

      e_register->new
          ({
             within => $this,
             enable => 1,
             out    => [$counter            =>
                        &Bits_To_Encode($max_counter)],
             in     => [$counter_next_value =>
                        &Bits_To_Encode($max_counter)],
          });

      e_mux->new
          ({
             within  => $this,
             default => 0,
             lhs     => "$counter_next_value",
             table   => [@counter_load_mux_table],
          });
   }

   e_assign->new
       ({
          within => $this,
          lhs    => [$wait_for_counter => 1,0,1],
          rhs    => &or_array(@wait_for_counter_expr),
       });
}



=item I<_handle_reset_and_reset_request()>

Handle the reset and reset request.
Always insert a reset synchronizer to ensure reset recovery time is met
and all flops exit the reset state in the same clock cycle.
The reset output will be asserted asynchronously and deasserted synchronously.

=cut

sub _handle_reset_and_reset_request
{
   my $this = shift;


   my $slave_id = shift or &ribbit ("no_slave_id");
   my $slave = $this->_get_slave($slave_id);

   my $clock = $this->clock();
   my $reset_n =
       $slave->_get_exclusively_named_port_or_its_complement
       ("reset_n");

   my $top = $this->project->top();

   my $reset_for_clock_domain = $this->_master_or_slave()->reset_n();
   $this->project()->top()->make_reset_synchronizer($clock, $reset_for_clock_domain);

   if ($reset_n)
   {     


     my $arbitrator = $slave->_where_should_i_put_stuff();




     $arbitrator->get_and_set_once_by_name({
       thing => 'assign',
       name  => "$reset_n assignment",
       lhs   => $reset_n,
       rhs   => 'reset_n',
     });
   }





   if ($slave->parent_module()
       ->{SYSTEM_BUILDER_INFO}{Inhibit_Global_Reset})
   {
      $top->get_and_set_once_by_name
          ({
             thing => 'assign',
             name  => 'inhibit reset_n',
             lhs   => 'reset_n',
             rhs   => 1,
          });
   }

   my $resetrequest =
       $slave->_get_exclusively_named_port_or_its_complement
           ("resetrequest") or return;
   $this->project()->top()->make_reset_n_sources_mux($resetrequest);

   return;
}



=item I<_handle_output_enable()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_output_enable
{
   my $this = shift;
   my $slave_id = shift or &ribbit ("no_slave_id");
   my $slave = $this->_get_slave($slave_id);

   my $oe =
       $slave->_get_exclusively_named_port_or_its_complement
           ("outputenable")
               or return;

   my @or_this;
   my $bridge_latency = $this->_get_bridge_latency($slave_id);
   foreach my $master_desc ($this->_get_master_descs())
   {
      my $shift_register = $this->
          _get_read_latency_fifo_is_non_empty_name
              ($master_desc,$slave_id);

      next if !$shift_register;

      my $read_latency = $this->get_read_latency($slave_id);

      if ($read_latency > $bridge_latency) {

        push (@or_this,
            "(|$shift_register\[$shift_register.msb - $bridge_latency : 0\])");
      }
   }

   push (@or_this, $this->_get_slave_in_a_cycle($slave_id,"read"));


   $this->get_and_set_thing_by_name({
      thing => "mux",
      type  => "and-or",
      name  => "$oe assignment",
      lhs   => $oe,
      add_table => [&or_array(@or_this), &or_array(@or_this)],
   });

}



=item I<_handle_read_or_write()>

Setup and hold and helper functions _handle_read or _handle_write

=cut

sub _handle_read_or_write
{
   my $this = shift;
   my $read_or_write = shift or &ribbit ("no rw sig");
   my $slave_id = shift or &ribbit ("no_slave_id");

   my @in_a_read_or_write_cycle;
   foreach my $md ($this->_get_master_descs())
   {
      my $master = $this->_get_master($md);

      my $master_read_or_write =
          $this->get_master_read_or_write
          ($master, $read_or_write);

      my $master_grant = $this->_get_master_grant_signal_name
          ($md,$slave_id);
      push (@in_a_read_or_write_cycle, &and_array
            ($master_grant,
             $master_read_or_write
             )
            ) if ($master_read_or_write);
   }
   return &or_array(@in_a_read_or_write_cycle);
}



=item I<_get_wait_states()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_wait_states
{
   my $this = shift;
   my $slave_id = shift or &ribbit ("no id");
   my $read_or_write = shift or &ribbit ("no row");

   my $wait_states;
   my $setup_time;
   my $hold_time;
   my $slave = $this->_get_slave($slave_id);

   my $slave_SBI = $slave->{SYSTEM_BUILDER_INFO} or &ribbit
       ("no SBI section in slave");

   my $Read_Or_Write = $read_or_write;
   $Read_Or_Write =~ s/^r/R/;
   $Read_Or_Write =~ s/^w/W/;

   $wait_states = $slave_SBI->{"${Read_Or_Write}_Wait_States"} || 0;
   $setup_time  = $slave_SBI->{Setup_Time} || 0;

   my $hold_time_key;
   if ($read_or_write =~ /read/i)
   {
      $hold_time_key = "Read_Hold_Time";
   }
   else
   {
      $hold_time_key = "Hold_Time";
   }


   $hold_time   = $slave_SBI->{$hold_time_key} || 0;

   $wait_states = $this->convert_time_to_cycles($wait_states,1);
   $setup_time  = $this->convert_time_to_cycles($setup_time);
   $hold_time   = $this->convert_time_to_cycles($hold_time);

   if ($wait_states =~ /peripheral/i)
   {
      $wait_states = $slave->_get_exclusively_named_port_by_type
          ("waitrequest") or die 
          ("$slave_id has peripheral controlled read wait states, ",
           "but no wait pin");

      if ($setup_time || $hold_time)
      {
         &ribbit
             ("$slave_id: peripheral controlled wait not\n".
              "supported for peripherals with non-zero setup ".
              "and/or hold times\n");
      }
   }
   else
   {
      $wait_states += $setup_time;

      if ($read_or_write =~ /write/i)
      {
         if ($hold_time =~ /half/i)
         {
            ($setup_time == 0) or die
                ("ERROR: $slave_id has a Half-cycle Hold Time but ".
                 "non-zero Setup_Time\n");

            ($wait_states == 0) or die
                ("ERROR: $slave_id has a Half-cycle Hold Time but ".
                 "non-zero Write_Wait_States\n");

            $wait_states = 0;
            $setup_time = 0;
         }
         else
         {
            $wait_states += $hold_time;
         }
      }
   }
   return ($wait_states, $setup_time, $hold_time);
}



=item I<convert_time_to_cycles()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub convert_time_to_cycles
{
   my $this = shift;
   my $value = shift;
   my $first = shift || 0;

   if ($value =~ /^\s*([\d\.]+)\s*(nS|uS|mS|S)\s*$/i)
   {
      my $number = $1;
      my $units  = $2;

      $units =~ tr/A-Z/a-z/;
      my $unit_table = {
         ns => 1.0E-9,
         us => 1.0E-6,
         ms => 1.0E-3,
         s  => 1.0,
      };

      my $system_frequency = $this->_slave()->get_clock_frequency();
      $value = max (0, &ceil($number * $system_frequency *
                             $unit_table->{$units} - $first));
   } else {
      if ($value =~ /^\s*(\d+)\.*\d*\s*cycles\s*$/i) {
        $value = $1;
      }
   }

   return $value;
}



=item I<_get_real_or_dummy_slave_write_port>

Maybe this slave has a write port.  If so, return it.  But maybe it has no
write port, but has a writebyteenable port.  If so, create a "dummy" write
signal for convenience.

Oh.  If you care whether or not the port is a dummy, call this routine
in a list context; the second return value is a boolean, "is_a_dummy".

=cut

sub _get_real_or_dummy_slave_write_port
{
  my $this = shift;
  my $slave_id = shift or &ribbit ("no id");

  my $slave = $this->_get_slave($slave_id);
  my $is_a_dummy = 0;

  my $write_port_name = $this->_get_slave_write_port($slave_id);

  if (
    !$write_port_name && 
    $slave->_get_exclusively_named_port_by_type("writebyteenable")
  )
  {
    $write_port_name = $this->_make_signal("${slave_id}_dummy_write") ;
    $is_a_dummy = 1;
  }

  if (wantarray)
  {
    return ($write_port_name, $is_a_dummy);
  }

  return $write_port_name;
}



=item I<_handle_setup_and_hold()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_setup_and_hold
{
   my $this = shift;
   my $slave_id= shift or &ribbit ("no id");
   my $inhibit_signal;

   my $slave = $this->_get_slave($slave_id);
   my $read_port_name = $this->get_slave_read_port($slave);

   if ($read_port_name)
   {
      my $rhs = $this->_modify_control_port_timing($slave_id,'read');

      $this->get_and_set_thing_by_name
          ({
             thing      => "mux",
             type       => "and-or",
             name       => "$read_port_name assignment",
             lhs        => $read_port_name,
             add_table  => [$rhs, $rhs],
          });
   }

   my $write_port_name =
     $this->_get_real_or_dummy_slave_write_port($slave_id);

   if ($write_port_name)
   {
      my $rhs = $this->_modify_control_port_timing($slave_id,'write');
      $rhs = &and_array
          ($rhs,
           $this->_get_pretend_byte_enable($slave)
           );

      my $e = $this->get_and_set_thing_by_name
          ({
             thing     => "mux",
             type      => "and-or",
             name      => "$write_port_name assignment",
             lhs       => [$write_port_name, 1],
             add_table => [$rhs,$rhs],
          });
   }
}



=item I<_modify_control_port_timing()>
Write cycles depend on these parameters:
  Write_Wait_States (wws)
  Setup_Time        (s)
  Hold_Time         (h)

 A write takes wws + s + h + 1 cycles.
 On the first cycle, the special signal begin_xfer is true.
 A counter is initialized to wws + s + h - 1 on the _2nd_ cycle
 of the write; on the first cycle, it's 0.

=cut

sub _modify_control_port_timing
{

   my $this = shift;
   my ($slave_id,$read_or_write) = @_;
   my $rhs = $this->_handle_read_or_write($read_or_write,$slave_id);
   my ($num_read_or_write_cycles_less_one,$setup_time,$hold_time) =
       $this->_get_wait_states($slave_id,$read_or_write);

   my $counter = $this->_get_counter_name($slave_id);

   if ($setup_time == 0 and $hold_time > 0)
   {

      $rhs .= " & (" . $this->_make_begin_xfer();
      $rhs .= " || ($counter >= $hold_time)"
          if ($num_read_or_write_cycles_less_one > $hold_time);
      $rhs .= ")";
   }
   elsif ($setup_time > 0 and $hold_time > 0)
   {
      $rhs .= " & ~" . $this->_make_begin_xfer() . " & ($counter >= $hold_time)";
      if ($setup_time > 1)
      {


         my $counter_set = $num_read_or_write_cycles_less_one - $setup_time + 1;
         $rhs .= " & ($counter < $counter_set)";
      }
   }
   elsif ($setup_time > 0 and $hold_time == 0)
   {




      my $active_cycles = $num_read_or_write_cycles_less_one + 1 - $setup_time;

      $rhs .= "& ~" . $this->_make_begin_xfer();

      if ($setup_time > 1)
      {
         $rhs .= " & ($counter < $active_cycles)";
      }
   }
   elsif ($setup_time == 0 and $hold_time == 0)
   {

   }
   return $rhs;
}

=item I<_there_are_Registered_Wait_Masters()>

Here are all the possibilities for Register_Incoming_Signals Masters.

  Transaction  Read/Write.
  wait states  0/1/n Read_Latency 0/1/n
  Dynamic Bus Sizing.

Reads from slave with read latency is easy.  Grab the nth-1 value from
the shift-register for the wait_state comparison.  For slaves with 1
read latency, it's the value being fed into the shift
register. (Although, at that point, there is no longer a need for the
shift register unless you're dynamically bus-sizing).  Search for
_get_registered_wait_read_data_valid_name to see this in action.

Writes from read-latent masters don't look any different from
writes from non-latent masters and are discussed in the following
paragraph.

Reads from slave with fixed wait states are also easy.  The wait
signal timing is handled in _make_slave_wait_signals.  If RWS is 0,
then we need to register the read_data value and mux the input of
the wait register to ~master_granted_slave. If RWS is 1, do the
same, except don't register the read_data value, pass it directly
on through.  If RWS is > 1, the master waits for signal is going to
be begin_xfer || (counter != 1).  For Dynamic Bus-sizing, the time
to register the first value is the same as it was.  The final wait
signal is optimized so that the only time you need to regfister the
last chunk of data is when you are dynamically bus-sizing a
peripheral controlled wait slave.

Writes to slaves with fixed wait states follow the same rules, except
that there is no need to register data.

Reads from slaves with wait pins require registering the data in.

In the cases where we cannot predict when the data will be
ready. i.e. peripheral_controled wait states, (zero wait,no dbs
writes), (zero wait, no dbs and no read latency reads) we must
inhibit the master from requesting on the extra cycle after the
data is ready, but before the master knows it is ready.  See
_handle_address_shift for $write_wait_states_are_predictable.

=cut

sub _there_are_Registered_Wait_Masters
{
   my $this = shift;

   my $RWM = 0;
   foreach my $master_desc ($this->_get_master_descs)
   {
      my $master = $this->_get_master($master_desc);

      if ($master->{SYSTEM_BUILDER_INFO}
          {Register_Incoming_Signals})
      {

         !$master->_can_handle_read_latency() || &ribbit
             ("Latency aware master $master_desc ",
              "may not have registered_incoming_signals");
         $RWM++
      }
   }
   return $RWM;
}



=item I<_make_slave_wait_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _make_slave_wait_signals
{
   my $this = shift;
   my $slave_id = shift or &ribbit ("no slave_id");

   my $slave = $this->_get_slave($slave_id);

   my $register_outgoing_signals = $this->_slave->{SYSTEM_BUILDER_INFO}
   ->{Register_Outgoing_Signals};

   my @counter_load_mux_table = ();

   my $d1_end_xfer = $this->_get_d1_end_xfer();
   foreach my $read_or_write ("read","write")
   {



      my $generic_read_or_write_term = 1;

      my ($wait,$setup_time,$hold_time) = $this->
          _get_wait_states($slave_id,"$read_or_write");

      my $wait_signal = 0;
      my $registered_wait_signal = 0;

      my $in_a_cycle = $this->_get_slave_in_a_cycle($slave_id,$read_or_write);

      my $count_value;




      my @run_and_values = (1);
      my @registered_run_and_values = (1);

      if ($wait || $setup_time || $hold_time)
      {
         if ($wait =~ /\D/)
         {
            $wait_signal = $wait;









            if ($register_outgoing_signals)
            {
               my $new_wait_signal = "${wait_signal}_or_begin_xfer";
               $this->get_and_set_once_by_name
                   ({
                      thing => "assign",
                      name  => "$new_wait_signal adjusted wait",
                      lhs   => [$new_wait_signal, 1, 1],
                      rhs   => "($wait_signal | ".$this->_make_begin_xfer().")",
                   });
               $wait_signal = $new_wait_signal;
            }
            else
            {
               e_signal->new([$wait_signal, 1, 1])->within($this);
            }

            push (@run_and_values, &complement($wait_signal)); #1 term
            push (@registered_run_and_values, &complement($wait_signal)); #1 term
         }
         else
         {
            $count_value = $wait - 1;

            if ($count_value > 0)
            {
               $wait_signal = $this->_get_wait_for_counter_name("$slave_id");

               push (@counter_load_mux_table,
                     $in_a_cycle => $count_value
                     );

               my $counter_eq_0 = $this->_get_counter_eq_0_name($slave_id);
               push (@run_and_values,
                     "({$counter_eq_0 & ~$d1_end_xfer})"); #1 term



               if ($this->_there_are_Registered_Wait_Masters())
               {
                  if ($count_value > 1)
                  {
                     my $counter_eq_1 = $this->_get_counter_eq_1_name($slave_id);
                     push (@registered_run_and_values,
                           $counter_eq_1); #1 term
                     my $counter = $this->_get_counter_name($slave_id);
                     $this->get_and_set_once_by_name
                         ({
                            name => "$counter_eq_1 assignment",
                            thing => "assign",
                            lhs   => [$counter_eq_1 => 1, 1],
                            rhs   => "$counter == 1",
                         });
                     



                     foreach my $master_desc ($this->_get_master_descs())
                     {
                        my $master = $this->_get_master($master_desc);
                        $master->_arbitrator()->sink_signals($counter_eq_1);
                     }
                  }
                  else #count_value == 1 equivalent to RWs = 2
                  {
                     push (@registered_run_and_values,
                           &complement($d1_end_xfer)
                           );
                  }
               }
            }
            elsif ($count_value == 0)
            {
               $wait_signal = $this->_make_begin_xfer($slave_id);
               push (@run_and_values, "~$d1_end_xfer"); #1 term








               push (@registered_run_and_values, 1);
            }
         }
      }



      my $lhs = $this->get_slave_wait
          ($read_or_write,$slave_id);
      my $rhs = "$in_a_cycle & $wait_signal";
      $this->get_and_set_thing_by_name({
         name  => "$lhs in a cycle",
         thing  => "mux",
         type   => "and-or",
         lhs    => [$lhs => 1, 0, 1],
         add_table   => [$rhs, $rhs],
      });



      my @in_a_cycle_array = ();

      foreach my $master_desc ($this->_get_master_descs())
      {
         my $master = $this->_get_master($master_desc);


         $this->_do_we_have_enough_control_ports($master_desc, $read_or_write)
             or next;

         my @master_run_values = @run_and_values;
         my $master_has_registered_wait = $master->{SYSTEM_BUILDER_INFO}
         {Register_Incoming_Signals};
         if ($master_has_registered_wait)
         {
            @master_run_values    = @registered_run_and_values;
         }

         my $qualified_request =
             $this->_get_master_qualified_request_signal_name
                 ($master_desc,$slave_id);
         my $master_grant = $this->_get_master_grant_signal_name
             ($master_desc,$slave_id);

         my $pin = $this->get_master_read_or_write($master,
                                                   $read_or_write);



         my $dbs_shift = $this->_how_many_bits_of_dynamic_bus_size_are_needed
             ($master_desc,$slave_id);
         my $dbs_address =
             $this->_get_master_dbs_address($master_desc);

         my @master_dbs_values = ();
         if ($pin)
         {
            my $read_latency =
                $this->get_read_latency($slave_id);
            my $variable_read_latency =
                $this->get_variable_read_latency
                ($slave_id);

            if ($dbs_shift > 0)
            {





               my $disable_this_term = 
                 $this->is_burst_master($master) && ($read_or_write eq 'read');
               my $dbs_counter_enable_term = (&and_array
                                              ($master_grant,
                                               $pin,
                                               $disable_this_term ? 0 : 1,
                                               @run_and_values
                                               )
                                              );

               if ($read_or_write =~ /read/i)
               {
                  $generic_read_or_write_term = 0;
                  if (!$master->_can_handle_read_latency &&
                      ($read_latency || $variable_read_latency))
                  {
                     $dbs_counter_enable_term =
                         $this->get_read_data_valid_signal_name
                             ($master_desc, $slave_id);

                  }
               }
               $master->_arbitrator()->get_and_set_thing_by_name
                   ({
                      thing         => "mux",
                      name          => "pre dbs count enable",
                      type          => "and_or",
                      lhs           => [pre_dbs_count_enable => 1],
                      add_table_ref => [$dbs_counter_enable_term,
                                        $dbs_counter_enable_term],
                   });





               if ($read_or_write eq 'write' || ($this->get_master_max_burst_size($master) == 1))
               {
                 if ($dbs_shift == 1)
                 {
                    $generic_read_or_write_term = 0;
                    push (@master_dbs_values,"{$dbs_address\[$dbs_address.msb\]}");
                 }
                 elsif ($dbs_shift >= 2)
                 {
                    $generic_read_or_write_term = 0;
                    my @address_bits;
                    for (0 .. $dbs_shift - 1)
                    {
                      push @address_bits, "$dbs_address\[$dbs_address.msb - $_\]";
                    }

                    push (@master_dbs_values, and_array(@address_bits));
                 }
               }
            }

            if (($read_or_write =~ /read/i) &&
                !$master->_can_handle_read_latency() &&
                ($read_latency || $variable_read_latency))
            {
               $generic_read_or_write_term = 0;
               my $rdv;
               if (($master->{SYSTEM_BUILDER_INFO}
                   {Register_Incoming_Signals} && $read_latency))
               {
                  $rdv = $this->_get_registered_wait_read_data_valid_name
                      ($master_desc, $slave_id);
               }
               else
               {
                  $rdv = $this->get_read_data_valid_signal_name
                      ($master_desc,$slave_id);
               }
                



               $master->_arbitrator()->sink_signals(@master_run_values);
               @master_run_values = ($rdv);
            }


            push (@master_run_values, @master_dbs_values);

            if (@master_run_values)
            {
               my $master_run_pin = $pin;
               if ($generic_read_or_write_term)
               {





                  my @read_stuff = $this->_get_wait_states($slave_id,'read');
                  my @write_stuff = $this->_get_wait_states($slave_id,'write');

                  my $same_stuff = 1;

                  $same_stuff = 0 if (@read_stuff != @write_stuff);

                  for my $i (0 .. -1 + @read_stuff)
                  {
                    $same_stuff = 0 if ($read_stuff[$i] ne $write_stuff[$i]);
                  }
            
                  if ($same_stuff)
                  {
                    $master_run_pin = $this->get_master_chipselect($master_desc);
                  }



                  if ($this->_slave->{SYSTEM_BUILDER_INFO}->{Well_Behaved_Waitrequest})
                  {
                    $master_run_pin = 1;
                  }
               }
               $this->_add_value_to_master_run
                   (
                    $master_desc,
                    &or_array
                    (&complement($qualified_request), #3 terms
                     &complement($master_run_pin),
                     &and_array (@master_run_values,
                                 $master_run_pin),
                     ),
                    );
            }



            push (@in_a_cycle_array,&and_array($master_grant,$pin));
         }
      }

      $this->get_and_set_thing_by_name
          ({
             thing => "assign",
             name  => "$in_a_cycle assignment",
             lhs   => ["$in_a_cycle",1,0,1],
             rhs   => &or_array(@in_a_cycle_array),
          });

      $this->get_and_set_thing_by_name
          ({
             thing => "mux",
             name  => "in_a_${read_or_write}_cycle assignment",
             lhs   => ["in_a_${read_or_write}_cycle",1,0,1],
             type  => "and_or",
             add_table => [$in_a_cycle => $in_a_cycle],
          });
   }
   $this->_make_counter($slave_id,[@counter_load_mux_table]);
}



=item I<_which_byte_address_bit_is_slave_A0_connected_to()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _which_byte_address_bit_is_slave_A0_connected_to
{
   &ribbit ("You must override this function for your bus type.\n");
}












=item I<get_address_range_of_slaves_by_master()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_address_range_of_slaves_by_master
{
   my $this = shift;
   my $master_desc   = shift or &ribbit ("no master_desc");
   my $project       = shift or &ribbit ("no project");

   my @slave_names = $project->get_slaves_by_master_name($master_desc);

   my @end_addresses = ();
   my @base_addresses = ();
   foreach my $slave_desc (@slave_names)
   {
      (my $base, my $end) = $this->get_address_range_of_one_slave_by_master
                                                        ($master_desc,
                                                        $slave_desc,
                                                        $project);
      push (@base_addresses, $base);
      push (@end_addresses,  $end );
   }

   return (min (@base_addresses), max (@end_addresses));
}











=item I<get_address_range_of_one_slave_by_master()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_address_range_of_one_slave_by_master
{
   my $this = shift;
   my $master_desc   = shift or &ribbit ("no master_desc");
   my $slave_desc    = shift or &ribbit ("no slave_desc");
   my $project       = shift or &ribbit ("no project");



   my $base   = eval($project->SBI($slave_desc)->{Base_Address});
   my $a_bits = $project->SBI($slave_desc)->{Address_Width};

   my $ignored_bits =
     $this->_which_byte_address_bit_is_slave_A0_connected_to($master_desc,
                                                             $slave_desc,
                                                             $project);

   my ($slave_module, $slave_interface) = split('/', $slave_desc);
   my $slave_hash = $project->system_ptf()->{"MODULE $slave_module"};
   if (e_ptf_module::is_adapter($slave_hash))
   {

      $ignored_bits = 0;
   }

   return ($base, $base + 2**($a_bits + $ignored_bits) - 1);
}



=item I<_make_requests()>

Generates chip select logic between a master and a slave.  Actually,
this subroutine only makes "request" logic.
_make_request_qualifications may inhibit these requests before they
reach the arbitrator logic which then determines which qualified
request gets granted.

=cut

sub _make_requests
{
   my $this = shift;

   my $master_desc = shift or &ribbit ("no master_d");
   my $slave_id    = shift or &ribbit ("no slave_id");
   my $slave         = $this->_get_slave($slave_id);
   my $requests_name = $this->_get_master_request_signal_name
       ($master_desc, $slave_id);

   my $master = $this->_get_master($master_desc);

   my $slave_SBI   = $slave->{SYSTEM_BUILDER_INFO};



   my $defined_mastered_by = defined $slave_SBI->{MASTERED_BY}->{$master_desc};
   my @base_address_choices = (






     $defined_mastered_by ? 
       $slave_SBI->{MASTERED_BY}->{$master_desc}->{Offset_Address} : 
       undef,
     $slave_SBI->{Offset_Address},
     $slave_SBI->{Base_Address},
   );

   my $device_base;
   CHOOSE_BASE_ADDRESS: for my $base (@base_address_choices)
   {
     if ($base ne '')
     {
       $device_base = $base;
       last CHOOSE_BASE_ADDRESS;
     }
   }

   $device_base    = eval ($device_base)
       unless ($device_base eq "N/A");

   my $master_cs = $this->get_master_chip_select_logic ($master_desc);

   $device_base ne "" || &ribbit
       ("$slave_id, no device_base (Base_Address = $device_base)");

   my $rhs;
   if ($device_base eq "N/A")
   {
      $rhs = $master_cs || 1;
   }
   else
   {
      exists ($slave_SBI->{Address_Width})
          or &ribbit ("$slave_id: Address_Width is required");
      my $slave_a_bits = $slave_SBI->{Address_Width};

      my $num_ignored_bits = $slave_a_bits;
      if (!$slave->is_adapter())
      {
        $num_ignored_bits += $this->_which_byte_address_bit_is_slave_A0_connected_to($master_desc,$slave_id);
      }
      else
      {
        my $slave_alignment = $slave_SBI->{Address_Alignment};
        if ($slave_alignment =~ /^native/)
        {
          $num_ignored_bits +=
            $this->_get_master_aligned_shift($master_desc) -
            ceil($this->_get_slave_aligned_shift($slave_id));
        }
      }

      my $master_address = $this->get_master_address_port($master);








      $master->_arbitrator()->sink_signals($master_address);

      my $master_width = $master->_get_address_width();
      my $master_msb    = $master_width - 1;






      if ($this->master_is_adapter($master_desc))
      {
         if ($this->master_adapts_to($master_desc, $slave_id))
         {
            $rhs = 1;
         }
         else
         {
            $rhs = 0;
         }
      }
      elsif ($master_msb < $num_ignored_bits)
      {
         $rhs = 1;
      }
      else
      {
         my $padded_zeroes = ($num_ignored_bits == 0) ? "" :
                ", ".$num_ignored_bits."\'b0";
         $rhs = "{$master_address \[$master_msb : $num_ignored_bits\] ".
            $padded_zeroes."} == $master_width\'h".
                sprintf("%x",$device_base);
      }


      $rhs = "($rhs) & $master_cs";




      if (
        $this->_master_reads_or_writes_slave($master, $slave, "write") &&
        !$this->_master_reads_or_writes_slave($master, $slave, "read")
      )
      {
        my $master_write = $this->get_master_write($master);
        if ($master_write)
        {
          $rhs = "($rhs) & $master_write";
        }
      }
 

      if (
        $this->_master_reads_or_writes_slave($master, $slave, "read") &&
        !$this->_master_reads_or_writes_slave($master, $slave, "write")
      )
      {
        my $master_read = $this->get_master_read($master);
        if ($master_read)
        {
          $rhs = "($rhs) & $master_read";
        }
      }













      my $slave_module      = $this->_master_or_slave()->parent_module();
      my $this_slave_module_name = $slave_module->name();
      (my $my_base, my $my_end) =
                      $this->get_address_range_of_one_slave_by_master
                                                  ($master_desc,
                                                  $slave_id,
                                                  $this->project());
      my @other_slaves_list =
        $this->get_slaves_by_master_name_without_bridges ($master_desc);

      foreach my $slave_id_to_test (@other_slaves_list) {
          next if ($slave_id_to_test eq $slave_id);   # don't test yourself
          next if ($this->_slave_has_base_address($slave_id_to_test) == 0);

          my $slave = $this->_get_slave ($slave_id_to_test);
          (my $base, my $end) = $this->get_address_range_of_one_slave_by_master
                                                      ($master_desc,
                                                      $slave_id_to_test,
                                                      $this->project());







          if (($base>=$my_base) && ($end<=$my_end) &&
            !(($base == $my_base) && ($end == $my_end))) {

              my $other_slave_request_name =
                      $this->_get_master_request_signal_name
                                      ($master_desc, $slave_id_to_test);
              $rhs = "($rhs) & ~($other_slave_request_name)";

          }
      }
   }

   my @possible_slaves = $this->get_all_bridge_slaves_mastered_by_master_desc
       ($master_desc);

   my @matching_slaves = grep {$_ eq $slave_id} @possible_slaves;
   if (!@matching_slaves)
   {
       $rhs = 0;  #the slave is never requested by $master_desc
   }




   e_assign->new
       ({
          within => $this,
          lhs    => $requests_name,
          rhs    => $rhs,
       });

   $this->_make_request_qualifications
       ($master_desc, $slave_id);
}



=item I<_make_request_qualifications()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _make_request_qualifications
{






   my $this = shift;
   my @request_inhibitors = ();

   my $master_desc   = shift or &ribbit ("no master_d");
   my $slave_id      = shift or &ribbit ("no slave_id");

   my $slave         = $this->_get_slave($slave_id);
   my $slave_SBI     = $slave->{SYSTEM_BUILDER_INFO};

   my $master = $this->_get_master($master_desc);
   my $master_SBI = $master->{SYSTEM_BUILDER_INFO};


   my $requests_name = $this->_get_master_request_signal_name
       ($master_desc,$slave_id);

   my $qualified_requests_name =
       $this->_get_master_qualified_request_signal_name
           ($master_desc,$slave_id);






   my @run_anyway;

   my $slave_dataavailable;
   my $slave_readyfordata;




   $slave_dataavailable =
   $slave->_get_exclusively_named_port_by_type("dataavailable") ||
     $slave->_get_exclusively_named_port_by_type("dmarequest");

   $slave_readyfordata =
   $slave->_get_exclusively_named_port_by_type("readyfordata") ||
     $slave->_get_exclusively_named_port_by_type("dmarequest");

   my $master_read = $this->get_master_read($master);
   my $master_write = $this->get_master_write($master);

   my $master_can_read = $master_read &&
       $this->_master_reads_or_writes_slave
       ($master,
        $slave,
        "read"
        );

   my $master_can_write = $master_write &&
     $this->_master_reads_or_writes_slave
       ($master,
        $slave,
        "write"
       );

   if ($master_can_read)
   {
      my @read_inhibitors = ();

      if ($master_SBI->{Do_Stream_Reads} and $slave_dataavailable)
      {

         push (@read_inhibitors, &complement($slave_dataavailable));
      }





      unless ($this->_registered_wait_states_are_predictable
              ($master_desc,$slave_id,"read")
              )
      {







         my $wait_mismatch = $this->_get_inhibit_when_wait_mismatch($master_desc);
         push (@read_inhibitors,$wait_mismatch);
      }

      my $write_pending = $this->_get_write_pending();
      if ($write_pending)
      {
         push (@read_inhibitors, $write_pending);
      }


      my $read_pending = $this->_get_read_pending();
      if ($read_pending)
      {
         my $read_latency = $this->_get_slave_latency($slave_id);
         my $push_this = "($read_pending)";
         if ($read_latency)
         {
            foreach my $master_desc ($this->_get_master_descs())
            {
               $push_this = "($read_pending & !(".
                   &or_array($this->get_read_pending_for_slave($slave_id))
                   ."))";
            }
         }
         push (@read_inhibitors, $push_this);
      }

      my $read_latency = $this->get_read_latency($slave_id);
      my $variable_read_latency = $this->get_variable_read_latency($slave_id);
      if (!($master->_can_handle_read_latency) &&
          ($read_latency || $variable_read_latency)
          )
      {
         my $latent_shift_register =
             $this->_get_read_latency_fifo_is_non_empty_name($master_desc,
                                                     $slave_id);
         if ($latent_shift_register)
         {


           my $dbs_address =
               $this->_get_master_dbs_address($master_desc);

           my $rdv = $this->get_read_data_valid_signal_name
               ($master_desc, $slave_id);





           if ($master->{SYSTEM_BUILDER_INFO}
               {Register_Incoming_Signals} && $read_latency)
           {
              $rdv = $this->_get_registered_wait_read_data_valid_name
               ($master_desc, $slave_id);
           }

           my $dbs_shift = $this->_how_many_bits_of_dynamic_bus_size_are_needed
               ($master_desc,$slave_id);







           if ($dbs_shift == 1)
           {
              push (@run_anyway,
                    "{$rdv & $dbs_address\[$dbs_address.msb\]}");
           }
           elsif ($dbs_shift >= 2)
           {
              my @address_bits;
              for (0 .. $dbs_shift - 1)
              {
                push @address_bits, "$dbs_address\[$dbs_address.msb - $_\]";
              }
              push @run_anyway,
                    and_array($rdv, @address_bits);
           }
           else
           {
              push (@run_anyway, $rdv);
           }

           push (@read_inhibitors, "(|$latent_shift_register)");
        }
      }

      if ($master->_can_handle_read_latency())
      {
         my $read_latency = $this->get_read_latency($slave_id);
         my $variable_read_latency = $this->get_variable_read_latency
             ($slave_id);
         my $master_coherent_count = $this->
            _get_master_latency_counter_name($master_desc);

         if ($read_latency)
         {
















            my @slave_descs = 
              $this->_project->get_slaves_by_master_name($master_desc);
            my $slaves_connected_to_master = scalar(@slave_descs);
            
            if ($slaves_connected_to_master > 1)
            {
              push (@read_inhibitors,
                  "($read_latency < $master_coherent_count)"
                  );
            }
            else
            {
              $this->sink_signals($master_coherent_count)
            }
         }
         else
         {







            push (@read_inhibitors,
                  "($master_coherent_count != 0)"
                  );
         }





         if ($variable_read_latency)
         {
            my $master_coherent_count = $this->
                _get_master_latency_counter_name($master_desc);
            push (@read_inhibitors,
                  "(1 < $master_coherent_count)"
                  );
         }






         my @all_slaves = 
          $this->get_directly_connected_slaves_by_master_name($master_desc);

         foreach my $master_slave (@all_slaves)
         {
            my $slave_has_variable_read_latency =
                $this->_get_variable_read_latency($master_slave);
            next unless $slave_has_variable_read_latency;


            my $directly_connected_slave_id = $slave_id;
            next if ($master_slave eq $directly_connected_slave_id);

            my $read_latency_fifo_is_non_empty =
                $this->_get_read_latency_fifo_is_non_empty_name
                ($master_desc,$master_slave);

            push (@read_inhibitors, "(|$read_latency_fifo_is_non_empty)");
         }
     }
      push (@request_inhibitors,
            &and_array($master_read,
                       &or_array(@read_inhibitors))
            ) if (@read_inhibitors);
   }

   if ($master_can_write)
   {
      my @write_inhibitors;

      if (($slave_SBI->{Hold_Time} =~ /half/))
      {
         ($slave_SBI->{Bus_Type} =~ /tristate/) || &ribbit
             ("$slave_id has a Half-cycle Hold Time but isn't a ",
              "tristate bus type");



         my $slave_write = $this->_get_slave_write_port($slave_id);

         my $wrote_half_cycle_slave_last_time = $this->_make_signal
             ("wrote_half_cycle/$slave_id/last_time");

         $this->get_and_set_once_by_name
             ({
                thing  => 'register',
                name   => "$wrote_half_cycle_slave_last_time register",
                out    => [$wrote_half_cycle_slave_last_time => 1],
                in     => $slave_write,
                enable => 1,
             });

         push (@write_inhibitors, $wrote_half_cycle_slave_last_time);
      }

      if ($master_SBI->{Do_Stream_Writes} and $slave_readyfordata)
      {

         push (@write_inhibitors,
               &complement($slave_readyfordata));
      }





      unless ($this->_registered_wait_states_are_predictable
              ($master_desc,$slave_id,"write")
              )
      {






         my $wait_mismatch = $this->_get_inhibit_when_wait_mismatch($master_desc);
         push (@write_inhibitors,$wait_mismatch);
      }


      my $read_pending = $this->_get_read_pending();
      if ($read_pending)
      {
         push (@write_inhibitors, $read_pending);
      }

      my $be = $master->
          _get_exclusively_named_port_or_its_complement
              ("byteenable");


      my $dbs_shift = $this->_how_many_bits_of_dynamic_bus_size_are_needed
        ($master_desc,$slave_id);

      
      if ($dbs_shift > 0)
      {




        my $master_be = $this->_get_byteenable_signal_name
            ($master_desc,$slave_id);

        $master->_arbitrator()->sink_signals($master_be);
      }

      if ($be && !($this->is_burst_slave($slave_id)))
      {










         if ($dbs_shift > 0)
         {
            my $master_be = $this->_get_byteenable_signal_name
                ($master_desc,$slave_id);

            my $run = "$master_write & !$master_be";

            my $dbs_address =
                $this->_get_master_dbs_address($master_desc);

            my $run_and_dbs;
            my $last_term;
            if ($dbs_shift == 1)
            {
               $run_and_dbs = "$run & $dbs_address\[$dbs_address.msb\]";
               $last_term = "$dbs_address == 2'b10";
            }
            elsif ($dbs_shift >= 2)
            {
               my @address_bits;
               for (0 .. $dbs_shift - 1)
               {
                 push @address_bits, "$dbs_address\[$dbs_address.msb - $_\]";
               }

               $run_and_dbs = and_array ($run, @address_bits);
               $last_term =
                 "$dbs_address == " .
                 sprintf("%d'b%s", $dbs_shift, '1' x $dbs_shift); # e.g. 2'b11
            }



            my $run_enable_inhibitor = "0";
            if ($master->{SYSTEM_BUILDER_INFO}{Register_Incoming_Signals})
            {
               my $no_byte_enables_and_last_term =
                   $this->_make_signal("$master_desc/no_byte_enables_and_last_term");
               $run_enable_inhibitor = $no_byte_enables_and_last_term;
               $master->_arbitrator()->get_and_set_once_by_name
                   ({
                      thing  => "register",
                      name   => "no_byte_enables_and_last_term",
                      out    => [$no_byte_enables_and_last_term,1,1],
                      in     => "last_dbs_term_and_run",
                      enable => 1,
                   });

               $master->_arbitrator()->get_and_set_thing_by_name
                   ({
                      thing => "mux",
                      name  => "compute the last dbs term",
                      lhs   => [last_dbs_term_and_run => 1],
                      add_table => [$requests_name, &and_array("($last_term)",$run)],
                   });

               push (@write_inhibitors, $no_byte_enables_and_last_term);
            }

            push (@run_anyway, "{$run_and_dbs}");
            push (@write_inhibitors, "!$master_be");





            my $run_enable = &and_array ("(~$run_enable_inhibitor)",
                              $requests_name, $run);
            $master->_arbitrator()->get_and_set_thing_by_name
                ({
                   thing         => "mux",
                   name          => "pre dbs count enable",
                   type          => "and_or",
                   lhs           => [pre_dbs_count_enable => 1],
                   add_table_ref => [$run_enable,$run_enable],
                });
         }
      }

      my $or_array = &or_array(@write_inhibitors);
      push (@request_inhibitors,
            &and_array ($or_array,
                        $master_write)
            )
          if ($or_array);
   }





   foreach my $arb_master_desc ($this->_get_master_descs())
   {

      my $arbiterlock =
                $this->_create_arbiterlock_proxy($arb_master_desc, $slave_id);


      if ($arbiterlock)
      {
         my $arb_master_granted_slave =
           $this->_get_saved_master_grant_signal_name($arb_master_desc, $slave_id);

         my $d1_arb_master_granted_a_bridged_slave = 
              $this->_make_signal("last_cycle/$arb_master_desc/granted_slave/$slave_id");
         my $bridge_slave_id = $this->_get_slave_id();









         



         my $anycontinuerequest = $this->_make_signal("$bridge_slave_id/any_continuerequest");
         my $master_continues_request = $this->_make_signal("$arb_master_desc/continuerequest");
         if (1 == $this->_get_master_descs())
         {



            $this->get_and_set_once_by_name({
              name => "$anycontinuerequest at least one master continues requesting",
              thing => 'assign',
              lhs => e_signal->new({name => $anycontinuerequest, never_export => 1,}),
              rhs => 1,
            });
            $this->get_and_set_once_by_name({
                thing      => 'assign',
                name       => "$master_continues_request continued request",
                out        => e_signal->new({name => $master_continues_request, never_export => 1,}),
                in         => 1,
            });

         }
         elsif ($arb_master_desc ne $master_desc)
         {
            my $bridge_slave_id = $this->_get_slave_id();
            my $arbitration_holdoff = $this->get_arbitration_holdoff($bridge_slave_id);

            my $master_request = $this->_get_master_request_signal_name
                ($arb_master_desc, $slave_id);
            my $sync_reset_granted_last_time =
              or_array($arbitration_holdoff, $this->is_burst_master($master) ? 0 : "~$master_request");

            $this->get_and_set_once_by_name({
                thing      => 'register',
                name       => "$arb_master_desc granted $slave_id last time",
                out        => [$d1_arb_master_granted_a_bridged_slave => 1,0,1],
                in         =>
                  "$arb_master_granted_slave ? 1 : " .
                  "$sync_reset_granted_last_time ? 0 : " .
                    "$d1_arb_master_granted_a_bridged_slave",
                enable     => 1,
            });


            my $this_slave_continue_request =
              and_array(
                $d1_arb_master_granted_a_bridged_slave,
                ($this->is_burst_master($arb_master_desc) ? 1 : $master_request)
              );

            $this->get_and_set_thing_by_name({
                thing      => 'mux',
                type => 'and_or',
                name       => "$master_continues_request continued request",
                out        => e_signal->new({name => $master_continues_request,}),
                add_table => [$this_slave_continue_request, $this_slave_continue_request],
            });

            $this->get_and_set_thing_by_name({
              name => "$anycontinuerequest at least one master continues requesting",
              thing => 'mux',
              type => 'and_or',
              out => e_signal->new({name => $anycontinuerequest, never_export => 1,}),
              add_table => [$master_continues_request, $master_continues_request],
            });


            push @request_inhibitors, $arbiterlock;
         }
      }
   }









   my $inhibit_request = $slave->_get_exclusively_named_port_or_its_complement("inhibitrequest");
   if ($inhibit_request)
   {
     my @wait_requests;
     if ($master_can_read)
     {
       push (@wait_requests, $this->get_slave_wait("read",$slave_id));
     }

     if ($master_can_write)
     {
       push (@wait_requests, $this->get_slave_wait("write",$slave_id));
     }

     my $wait_request = &or_array(@wait_requests);
     my $inhibit_request_sync = $this->_make_signal("$slave_id/inhibit_request_sync");
     my $inhibit_request_qualified_by_wait = $this->_make_signal("$slave_id/inhibit_request_qualified_by_wait");


     my $inhibit_request_sync_inst = $this->_make_signal("$slave_id/ardy_sync");
     my $inhibit_wait_inst = $this->_make_signal("$slave_id/inhibit_with_wait");

     $this->get_and_set_once_by_name({
              thing => 'synchronizer',
              name => $inhibit_request_sync_inst,
              port_map => {
               data_in => $inhibit_request,
               data_out => $inhibit_request_sync
               }
              });
     $this->get_and_set_once_by_name({
              thing => 'register',
              name => $inhibit_wait_inst,
              sync_set => "~$inhibit_request_sync & $wait_request",
              sync_reset => $inhibit_request_sync,
              out => $inhibit_request_qualified_by_wait,
              enable => 1,
             });
     push (@request_inhibitors, $inhibit_request_qualified_by_wait);
   }


   my $or_array = &or_array(@request_inhibitors);
   if ($or_array)
   {
      e_assign->new
          ([
            [$qualified_requests_name => 1, 1],
            &and_array($requests_name,
                       &complement ($or_array)
                       )
            ])->within($this);
   }
   else
   {
      e_assign->new
          ([
            [$qualified_requests_name => 1, 1],
            $requests_name
            ])->within($this);
   }

   my @or_array = ($qualified_requests_name,
                   @run_anyway
                   );

   my $cascade_term;
   if (@request_inhibitors)
   {
      push (@or_array, &complement($requests_name));
         $cascade_term = &or_array(@or_array);

      $this->_add_value_to_master_run($master_desc,
                                      $cascade_term);
   }






   $master->_arbitrator()->sink_signals
       ($requests_name,
        $qualified_requests_name
        );

   e_signal->new([$requests_name => 1, 1])->within($this);
}



=item I<_build_assertion_logic()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _build_assertion_logic
{
  my ($this, $master_desc, $slave_id) = @_;

  ribbit("no master_desc") if !$master_desc;
  ribbit("no slave_id") if !$slave_id;

  my $master = $this->_get_master($master_desc);


  return
    if !$this->project()->system_ptf()->
      {WIZARD_SCRIPT_ARGUMENTS}->{build_assertion_logic};
  
  my $slave         = $this->_get_slave($slave_id);
  my $slave_SBI     = $slave->{SYSTEM_BUILDER_INFO};
 
  my $actual_arbiterlock = 
    $master->_get_exclusively_named_port_or_its_complement
    ('arbiterlock');

  if (!$actual_arbiterlock)
  {
    $this->_build_murl_assertions($master_desc, $slave_id);
  }

  my @all_arb_masters = $this->_get_master_descs();


  my %arbiterlocks;
  foreach my $arb_master_desc (@all_arb_masters)
  {
    my $arbiterlock = 
      $this->_get_arbiterlock_or_proxy($arb_master_desc);

    $arbiterlocks{$arb_master_desc} = $arbiterlock;
  }

  foreach my $arb_master_desc (@all_arb_masters)
  {
    my $master_request =
      $this->_get_master_request_signal_name($arb_master_desc, $slave_id);
    my $master_arb = $this->_get_master($arb_master_desc)->_arbitrator();
    if (!$arbiterlocks{$arb_master_desc})
    {







































      foreach my $other_master_desc (@all_arb_masters)
      {
        next if ($other_master_desc eq $arb_master_desc);



        my $other_master_request =
          $this->_get_master_request_signal_name($other_master_desc, $slave_id);
        my $d1_other_master_request = 'd1_' . $other_master_request;

        my $other_master_initiated_request_after_this_master =
          $this->_make_signal("$arb_master_desc/$other_master_desc/req_after");


        my $master_requests_slave = $this->_get_d1_end_xfer($slave_id) . " && $master_request";

        $master_arb->get_and_set_once_by_name({
          thing       => 'register',
          tag         => 'simulation',
          name        => $other_master_initiated_request_after_this_master,
          out         => e_signal->new({
            name => $other_master_initiated_request_after_this_master,
            never_export => 1,
          }),
          enable      => 1,
          sync_set    => $this->_get_d1_end_xfer($slave_id) . " && $other_master_request",
          sync_reset  => $master_requests_slave,
          async_value => 0,
        });

        my $saved_master_grant = 
          $this->_get_saved_master_grant_signal_name($other_master_desc, $slave_id);
        my $another_transaction_completes;

        my $other_master_grant = 
            $this->_get_master_grant_signal_name
            ($other_master_desc, $slave_id);

        ribbit("'$other_master_desc' has no arbiterlock")
          if (!$arbiterlocks{$other_master_desc});
        my $another_transaction_completes =
          $this->_make_end_xfer($slave_id) .
          " && $saved_master_grant && ~$arbiterlocks{$other_master_desc}";
        
        $master_arb->get_and_set_once_by_name({
          thing       => 'register',
          tag         => 'simulation',
          name        => $other_master_initiated_request_after_this_master,
          out         => $other_master_initiated_request_after_this_master,
          enable      => 1,
          sync_set    => "~$d1_other_master_request && $arbiterlocks{$other_master_desc}",
          sync_reset  => $master_requests_slave,
          async_value => 0,
        });







        my $arb_priority = $slave_SBI->{MASTERED_BY}->{$arb_master_desc}->{priority};
        my $grant_counter_name = $this->_make_signal("$arb_master_desc/$other_master_desc/grant_counter");

        my $full_scale_grant_counter_load_value = 1 + $arb_priority;


        my $slave_specific_full_scale_value = $full_scale_grant_counter_load_value;

        my $grant_counter_width = Bits_To_Encode($full_scale_grant_counter_load_value);
        my $next_grant_counter_value =
          "($master_requests_slave || !$master_request) ? $full_scale_grant_counter_load_value : " .
          "$another_transaction_completes ? ($grant_counter_name - 1) : " .
          "$master_requests_slave ? $full_scale_grant_counter_load_value : " .
          "$grant_counter_name";





        $master_arb->get_and_set_once_by_name({
          thing       => 'register',
          tag         => 'simulation',
          name        => "$other_master_request delay",
          out         => e_signal->new({name => $d1_other_master_request, never_export => 1,}),
          enable      => 1,
          in          => $other_master_request,
        });

        if ($master_arb->get_and_set_once_by_name({
          thing       => 'register',
          tag         => 'simulation',
          name        => "${arb_master_desc}'s grant counter for $other_master_desc accessing slave $slave_id, priority $arb_priority",
          out         => e_signal->new({name => $grant_counter_name, width => $grant_counter_width, never_export => 1,}),
          enable      => 1,
          in          => $next_grant_counter_value,
          async_value => $full_scale_grant_counter_load_value,
        }))
        {
          $master_arb->add_contents(
            e_process->new({
              tag => 'simulation',
              contents => [
                e_if->new({
                  condition => "$grant_counter_name == 0",
                  then => [
                    e_sim_write->new({
                      spec_string => "Arbitration unfairness: $other_master_desc cheated $arb_master_desc\\n",
                      show_time => 1,
                    }),
                  ],
                }),
              ],
            }),
          );
        }
      }
    }
  }

}

sub is_big_endian_master
{
  my $this = shift;
  my $master_desc = shift;
  my $debug = shift;
  my $master = $this->_get_master($master_desc);
  if($master->{SYSTEM_BUILDER_INFO}{"DBS_Big_Endian"} == 1) {
    return 1;
  } else {
    return 0;
  }
}



=item I<_build_murl_assertions()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _build_murl_assertions
{
  my ($this, $master_desc, $slave_id) = @_;

  ribbit("no master_desc") if !$master_desc;  
  ribbit("no slave_id") if !$slave_id;

  return
    if !$this->project()->system_ptf()->
      {WIZARD_SCRIPT_ARGUMENTS}->{build_assertion_logic};

  my $slave         = $this->_get_slave($slave_id);
  my $slave_SBI     = $slave->{SYSTEM_BUILDER_INFO};

  my $MURL = $slave_SBI->{Minimum_Uninterrupted_Run_Length};

  if ($MURL)
  {
    my @active_murls;
    my @all_arb_masters = $this->_get_master_descs();

    foreach my $arb_master_desc (@all_arb_masters)
    {



      my $arb_master = $this->_get_master($arb_master_desc);
      &ribbit ("no arb master") if !$arb_master;

      my $arbiterlock = 
        $this->_get_arbiterlock_or_proxy($arb_master_desc);

      my $MURL_zero_based = $MURL - 1;



      my $counter_name = $this->_get_arb_share_counter_name($arb_master_desc);
      my $counter_width = &Bits_To_Encode($MURL_zero_based);




      $arb_master->_arbitrator()->get_and_set_once_by_name({
        thing  => "assign",
        tag    => "simulation",
        name   => "$counter_name is counting",
        lhs    => e_signal->new({name => $this->_get_arb_share_counter_is_counting($arb_master_desc), export => 1,}),
        rhs    => "($counter_name != ${counter_width}'h0) && ($counter_name != ${counter_width}'d$MURL_zero_based)",
      });
      push @active_murls, $this->_get_arb_share_counter_is_counting($arb_master_desc);
    }

    if (@active_murls)
    {


      my $active_murl_count = join(' + ', @active_murls);
      my $master = $this->_get_master($master_desc);
      my $master_SBI = $master->{SYSTEM_BUILDER_INFO};
      my $master_arbitrator = $master->_arbitrator();

      $master_arbitrator->get_and_set_once_by_name({
        thing      => 'assign',
        tag        => "simulation",
        name       => "$slave_id MURL assertion: one master at a time",
        out        => e_signal->new({name => $this->_make_signal("$slave_id/assert_non_plurality"),
                        export => 0,
                        never_export => 1,
                      }),
        in         => "$active_murl_count > 1",
      });
    }
  }
}



=item I<_get_arb_share_counter_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_arb_share_counter_name
{
  my $this = shift;
  my $id = shift;
  
  ribbit unless ref($this) && $id;
  
  return $this->_make_signal("$id/arb_share_counter");
}



=item I<_get_arb_share_counter_is_counting()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_arb_share_counter_is_counting
{
  my $this = shift;
  my $id = shift;

  ribbit('bad \'$this\'') unless ref($this);
  ribbit("no id") unless $id;

  return $this->_get_arb_share_counter_name($id) . "_is_counting";
}



=item I<_get_saved_chosen_master_for_particular_master()>

This access method returns the name of a signal.  This signal is assigned to
a registered version of the saved master-granted-slave signal.  Basically, this
signal will be true when this master was granted this slave last cycle.  This
does differ from just d1_<master>_granted_<slave> in that our signal will
contiue to be asserted during arbiterlocked cycles, while d1_<master>_granted_<slave>
may blip in and out. 

There is a relationship between this signal and the saved_chosen_master vector,
which is used in granting. 
There is no access function for the saved_chosen_master vector itself, which
has its own name.  i suggest you search through this file for
saved_chosen_master.

=cut

sub _get_saved_chosen_master_for_particular_master
{
  my $this = shift;
  my $master_desc = shift  || &ribbit ("No master_desc");
  my $slave_desc = shift   || &ribbit ("No slave_desc");
  my $slave = $this->_get_master($slave_desc);
  my $slave_arb = $slave->_arbitrator();
  return $slave_arb->_make_signal
      ("saved_chosen_master_btw_$master_desc/_and_/$slave_desc");
}



=item I<_get_arbiterlock_proxy()>

Access method to return the name of the arbiterlock proxy, which is a
master signal created to behave like an arbiterlock for the purposes of MURL,
etc.

=cut

sub _get_arbiterlock_proxy
{
  my $this = shift;
  my $master_desc = shift;
  my $master = $this->_get_master($master_desc);
  my $master_arbitrator = $master->_arbitrator();

  return $master_arbitrator->_make_signal("$master_desc/arbiterlock"); 
}



=item I<_get_arbiterlock_proxy2()>

Get the name of the arbiterlock2 signal, which is used to enforce fairness
in pipelined systems.

=cut

sub _get_arbiterlock_proxy2
{
  my $this = shift;
  my $master_desc = shift;
  my $master = $this->_get_master($master_desc);
  my $master_arbitrator = $master->_arbitrator();

  return $master_arbitrator->_make_signal("$master_desc/arbiterlock2"); 
}



=item I<_get_arbiterlock_or_proxy()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_arbiterlock_or_proxy
{
  my $this = shift;
  my $master_desc   = shift or &ribbit ("no master_d");  
  my $master = $this->_get_master($master_desc);

  my $arbiterlock = $this->_get_qualified_arbiterlock($master_desc);
  if (!$arbiterlock)
  {
    $arbiterlock = $this->_get_arbiterlock_proxy($master_desc);
  }
  
  return $arbiterlock;
}


sub _get_qualified_arbiterlock
{
  my $this = shift;
  my $master_desc   = shift or &ribbit ("no master_d");  
  my $master = $this->_get_master($master_desc);
  my $arbiterlock =
    $master->_get_exclusively_named_port_or_its_complement
    ('arbiterlock');


  if (!$arbiterlock)
  {
    $arbiterlock = 0;
  } else {












    my @slave_ids = $this->
      get_all_bridge_slaves_mastered_by_master_desc($master_desc);
    my @saved_master_grants;
    foreach my $slave_id (sort @slave_ids) {
      my $saved_chosen_master_for_this_master = 
        $this->_get_saved_chosen_master_for_particular_master
            ($master_desc, $slave_id);
      push @saved_master_grants, $saved_chosen_master_for_this_master;
    }
    $arbiterlock = &and_array(
      $arbiterlock, 
      &or_array (@saved_master_grants),
    );
  }

  return $arbiterlock;
}






=item I<_create_arbiterlock_proxy()>

For masters which lack an explicit arbiterlock output,
create a placeholder (the "arbiterlock proxy") which accomplishes
the same function (to prevent a change in arbitration winner until
an appropriate time).  "Appropriate time" is hereby defined as:

  In the final clock cycle of the nth complete transaction to a slave, 
  where n is the maximum of the slave's MURL value (if any) and the
  master's arbitration share (misnamed "arbitration priority" in the GUI).

In the common case of a master with arb share = 1 connected to
a non-MURL slave, the generated arbiterlock signal is simply assigned
a constant 0, allowing re-arbitration after each completed access.

=cut

sub _create_arbiterlock_proxy
{
  my $this = shift;

  my $master_desc   = shift or &ribbit ("no master_d");  



  my $slave_id      = shift or &ribbit ("no slave_id");
  my $bridge_slave_id = $this->_get_slave_id();

  my $master_arbiterlock = $this->_get_master($master_desc)->_get_exclusively_named_port_or_its_complement('arbiterlock');
  if($this->is_single_master_to_single_slave_connection() && $master_arbiterlock)
  { 

    my $slave_enables_arbiterlock = $this->_make_signal("$bridge_slave_id/slavearbiterlockenable");
    $this->get_and_set_once_by_name({
      thing     => 'assign',
      name      => "dummy $slave_enables_arbiterlock",
      lhs       => $slave_enables_arbiterlock,
      rhs       => 0
    });
    return $master_arbiterlock;
  }

  my $qualified_arbiterlock;
  if ($master_arbiterlock)
  {
    $qualified_arbiterlock = $this->_get_qualified_arbiterlock($master_desc);
  }

  my $slave         = $this->_slave();
  my $slave_SBI     = $slave->{SYSTEM_BUILDER_INFO};
  my $master = $this->_get_master($master_desc);

  my $master_SBI = $master->{SYSTEM_BUILDER_INFO};
  my $master_arbitrator = $master->_arbitrator();

  my $master_ref = $slave_SBI->{MASTERED_BY} ||$slave_SBI->{Is_Mastered_By};

  my $arbiterlock = $this->_get_arbiterlock_proxy($master_desc);
  


  my $max_arbitration_share = $this->_get_max_arb_share($master_desc);

  my $arb_share_or_burst_count = 
    $this->_get_arb_share_or_burst_count($master_desc, $slave_id);
  





  



















































  




 














  


  
  my $counter_name = $this->_get_arb_share_counter_name($bridge_slave_id);
  my $counter_width = &Bits_To_Encode($max_arbitration_share);




  my $master_requests_slave =
      $this->_get_master_request_signal_name
      ($master_desc, $slave_id);

  my $counter_next_value = 
      $this->_make_signal("$counter_name/next_value");









  my $arb_share_set_values = $this->_make_signal("$bridge_slave_id/arb_share_set_values");







  my @counter_wide_signals =
    ($arb_share_set_values, $counter_next_value, $counter_name, );
  for my $signal_name (@counter_wide_signals)
  {
    my $sig = $this->get_and_set_thing_by_name({
      thing => 'signal',
      name => $signal_name,
    });

    if ($counter_width > $sig->width())
    {
      $sig->width($counter_width);
    }
  }









  my $master_grant =
    $this->_get_master_grant_signal_name($master_desc, $slave_id);
  











  $this->get_and_set_thing_by_name({
      thing       => 'mux',
      name        => "$counter_name set values",
      lhs         => $arb_share_set_values,
      default => 1,
  });



  my $arb_share_port = $this->get_master_arbitrationshare_port($master);



  if ($this->is_burst_master($master_desc) && !$arb_share_port)
  {
    my $read = $this->get_master_read($master);
    my $write = $this->get_master_write($master);
    if ($read && $write)
    {




      $arb_share_or_burst_count = "(($write) ? $arb_share_or_burst_count : 1)";
    }
    elsif ($read)
    {



      $arb_share_or_burst_count = 1;
    }
    elsif ($write)
    {

    }

  }


  if ($arb_share_or_burst_count ne '1')
  {
    $this->get_and_set_thing_by_name({
        thing       => 'mux',
        name        => "$counter_name set values",
        lhs         => $arb_share_set_values,
        add_table   => [
          $master_grant => $arb_share_or_burst_count
        ],
    });
  }







  my $non_bursting_master_requests = $this->_make_signal
                                       ("$bridge_slave_id/non_bursting_master_requests");
  $this->sink_signals($non_bursting_master_requests);


  if(!($this->is_burst_master($master_desc)))
  {
    my $master_request_name =  $this->_get_master_request_signal_name
                                                                       ($master_desc, $slave_id);
    $this->get_and_set_thing_by_name({
        thing       => 'mux',
        name        => "$non_bursting_master_requests mux",
        type        => 'and_or',
        lhs         => $non_bursting_master_requests,
        add_table   => [ $master_request_name, $master_request_name ]
    });
  }
  else
  {
      $this->get_and_set_once_by_name({
	  thing       => 'mux',
	  name        => "$non_bursting_master_requests mux",
	  type        => 'and_or',
	  lhs         => $non_bursting_master_requests,
	  add_table   => [ 0, 0 ],
      });
  }


  my $any_burst_master_saved_grant =
    $this->_make_signal("$bridge_slave_id/any_bursting_master_saved_grant");
  {
    $this->sink_signals($any_burst_master_saved_grant);

    my $thingy_hash = {
      thing       => 'mux',
      name        => "$any_burst_master_saved_grant mux",
      type        => 'and_or',
      lhs         => $any_burst_master_saved_grant,
    };

    if ($this->is_burst_master($master_desc))
    {

      my $saved_grant =
        $this->_get_saved_master_grant_signal_name($master_desc, $slave_id);
      $thingy_hash->{add_table} = [$saved_grant, $saved_grant];

      $this->get_and_set_thing_by_name($thingy_hash);
    }
    else
    {

      $thingy_hash->{add_table} = [0, 0];
      $this->get_and_set_once_by_name($thingy_hash);
    }
  }






  my $firsttransfer = $this->_make_signal("$bridge_slave_id/firsttransfer");
  
  $this->get_and_set_once_by_name({
      thing       => 'assign',
      name        => "$counter_next_value assignment",
      lhs         => $counter_next_value,
      rhs         => "$firsttransfer ? ($arb_share_set_values - 1) : |$counter_name ? ($counter_name - 1) : 0",
  });






  my $or_grant_vector =
    "(|" . $this->_make_signal("$bridge_slave_id/grant_vector") . ")";
  my $or_of_grants = $this->_make_signal("$bridge_slave_id/allgrants");
  $this->get_and_set_thing_by_name({
      thing       => 'mux',
      name        => "$or_of_grants all slave grants",
      type        => 'and_or',
      lhs         => e_signal->new({name => $or_of_grants, never_export => 1}),
      add_table   => [$or_grant_vector, $or_grant_vector],
  });

  my $counter_enable = $this->_make_signal("$bridge_slave_id/arb_counter_enable");


  my $end_xfer =
    $this->_make_signal("end_xfer_arb_share_counter_term/$bridge_slave_id");
  $this->get_and_set_once_by_name({
    thing => 'assign',
    name => "$end_xfer arb share counter enable term",
    lhs => $end_xfer,
    rhs => and_array(
      $this->_make_end_xfer(),
      or_array(
        complement($any_burst_master_saved_grant), 
        'in_a_read_cycle', 
        'in_a_write_cycle'
      ),
    )
  });
  $this->get_and_set_thing_by_name({
      thing       => 'assign',
      name        => "$counter_name arbitration counter enable",
      lhs         => $counter_enable,
      rhs         =>
        and_array($end_xfer, "$or_of_grants")
                 ." | ".
        and_array($end_xfer, "~$non_bursting_master_requests"),
  });
  
  $this->get_and_set_thing_by_name({
      thing       => 'register',
      name        => "$counter_name counter",
      out         => $counter_name,
      enable      => $counter_enable,
      in          => $counter_next_value,
  });

  my $saved_master_grant = 
    $this->_get_saved_master_grant_signal_name($master_desc, $slave_id);







  
  my $slave_enables_arbiterlock = $this->_make_signal("$bridge_slave_id/slavearbiterlockenable");
  my $master_qreq_vector = $this->_make_signal("$bridge_slave_id/master_qreq_vector");

  $this->get_and_set_once_by_name({
    thing       => 'register',
    name        => "$slave_enables_arbiterlock slave enables arbiterlock",
    out         => => e_signal->new({
      name => $slave_enables_arbiterlock,
      never_export => 1,
    }),
    async_value => 0,
    enable      => and_array("|$master_qreq_vector", $end_xfer) 
                            ." | ".
                   and_array($end_xfer, "~$non_bursting_master_requests"),
    in          => "|$counter_next_value",
  });

  my $master_continues_request = $this->_make_signal("$master_desc/continuerequest");
  if ($qualified_arbiterlock eq '')
  {
  $this->get_and_set_once_by_name({
    thing       => 'assign',
    name        => "$master_desc $bridge_slave_id arbiterlock",
    lhs         => => e_signal->new({
      name => $arbiterlock,
      never_export => 1,
    }),
    in          => and_array($slave_enables_arbiterlock, $master_continues_request),
  });
  }

  my $arbiterlock2 = $this->_get_arbiterlock_proxy2($master_desc);
  my $slave_enables_arbiterlock2 = $this->_make_signal("$bridge_slave_id/slavearbiterlockenable2");
  $this->get_and_set_once_by_name({
    thing       => 'assign',
    name        => "$slave_enables_arbiterlock2 slave enables arbiterlock2",
    lhs         => e_signal->new({
      name => $slave_enables_arbiterlock2,
      never_export => 1,
    }),
    rhs          => "|$counter_next_value",
  });
  $this->get_and_set_once_by_name({
    thing       => 'assign',
    name        => "$master_desc $bridge_slave_id arbiterlock2",
    lhs         => => e_signal->new({
      name => $arbiterlock2,
      never_export => 1,
    }),
    in          => and_array($slave_enables_arbiterlock2, $master_continues_request),
  });


  if ($master->_get_exclusively_named_port_or_its_complement('arbiterlock'))
  {
    $arbiterlock =
      $master->_get_exclusively_named_port_or_its_complement('arbiterlock');
  }

  return $qualified_arbiterlock if $qualified_arbiterlock;
  return $arbiterlock;
}



=item I<_master_arbitration_logic()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _master_arbitration_logic
{
   my $this = shift;

   my $slave_SBI         = $this->_master_or_slave()->{SYSTEM_BUILDER_INFO};

   my $arbitration_scheme = &validate_parameter
     ({hash    => $slave_SBI,
       name    => "Master_Arbitration",

       allowed => ["percentage"],
       default => "percentage",
      });

   my $slave_id = $this->_get_slave_id() or
      &ribbit ("Unable to get slave id");

   if ($arbitration_scheme =~/priority/i)
   {
      $this->_handle_priority_arbitration();
   }
   elsif ($arbitration_scheme =~/percentage/i)
   {
      $this->_handle_numerator_arbitration();
   }
   else
   {
      &ribbit ("don't know arbitration scheme ($arbitration_scheme)\n");
   }
}



=item I<_handle_priority_arbitration()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_priority_arbitration
{
   my $this = shift;
   my $slave_SBI         = $this->_master_or_slave()->{SYSTEM_BUILDER_INFO};

   my $master_ref        = $slave_SBI->{MASTERED_BY} ||
       $slave_SBI->{Is_Mastered_By};

   my $slave_id = $this->_get_slave_id();
   my %priorities;
   foreach my $master_desc ($this->_get_master_descs())
   {
      my $priority = $master_ref->{$master_desc}{priority};
      &ribbit ("ERROR $slave_id: Two masters with priority ",
               "($priority).  ($master_desc) and ",
               "($priorities{$priority})\n")
          if ($priorities{$priority});
      $priorities{$priority} = $master_desc;
   }

   my $more_important_than_this;
   foreach my $priority (sort {eval($a) <=> eval($b)} keys (%priorities))
   {
      my $master_desc = $priorities{$priority};
      my $master_request =
         $this->_get_master_qualified_request_signal_name
            ($master_desc);



      my $master_grant =
          $this->_get_master_grant_signal_name
              ($master_desc);

      my $rhs = $master_request . $more_important_than_this;
      e_assign->new
          ({
             within => $this,
             lhs    => "$master_grant\_at_start",
             rhs    => $rhs,
          });
      $more_important_than_this .= " & (\~$master_request)";

      my $begin_xfer_signal = $this->_make_begin_xfer($slave_id);
      e_register->new
          ({
             within      => $this,
             out         => "hold_$master_grant",
             sync_set    => "$master_grant\_at_start & $begin_xfer_signal",
             sync_reset  => $this->_make_end_xfer(),
             priority    => "set",
             enable      => 1,
          });

      e_mux->new
          ({
             within  => $this,
             lhs     => $master_grant,
             table   => [$begin_xfer_signal => "$master_grant\_at_start"],
             default => "hold_$master_grant",
          });

   }
}



=item I<_gcd()>

An inefficient greatest common denominator subroutine.
for fractions.  i.e. the numerator is always smaller than the
denominator.

=cut

sub _gcd
{
   my $this = shift;
   my $numerator = shift;
   my $denominator = shift;

   return ($numerator, $denominator)
       if ($numerator == 1);

   foreach my $try_this_number (2 .. ($numerator - 1))
   {
      if (($denominator % $try_this_number == 0) &&
          ($numerator % $try_this_number == 0)
          )
      {
         return ($this->_gcd($numerator   / $try_this_number,
                             $denominator / $try_this_number
                             )
                 );
      }
   }
   return ($numerator,$denominator);
}



=item I<is_bridge()>

Returns true if the arbitration module arbitrates for a bridge or an adapter.

=cut

sub is_bridge
{
   my $this = shift;
   my $slave = $this->_slave();
   my $return_value = $slave->is_bridge();
   return ($return_value);
}



=item I<is_tristate_bridge()>

Returns true if the arbitration module arbitrates for a tristate bridge.

=cut

sub is_tristate_bridge
{
   my $this = shift;
   my $class = $this->_slave()->parent_module()->{class};
   return ($class eq 'altera_avalon_tri_state_bridge');
}



=item I<_handle_numerator_arbitration()>

Round-robin arbitration scheme, in the slave arb module.

inputs:
  master qualified-request signals
  master saved-grant signals
  master arbiterlock (or proxy) signals
  slave end-xfer

outputs:
  master grant signals

internal state
  arb_addend
  firstcycle
  allow_new-arb-cycle


Q: how do you find the least-significant set-bit (as a one-hot
encoding, that is, in the answer, only the lsb set-bit is 1)
in an n-bit binary number, X?

A: M = X & (~X + 1)

Example: X = 101000100
 101000100 & 
(010111011 + 1) =

 101000100 &
 010111100 =
 -----------
 000000100

The method can be generalized to find the first set-bit starting
from a given bit-index N, simply by adding 2**N rather than 1.

Q: how does this relate to round-robin arbitration?
A:
Let X be the concatenation of all masters' qualified request (mqr) signals.
Let the number to be added to X (hereafter called the arb-addend) initialize
to 1, and be assigned from the concatenation of the previous saved-grant,
left-rotated by one position, each time a new arbitration request needs to
be decided.  The concatenation of master-grants (mg) is then M.

Problem: consider this case:

mqr               = 001001
arb_addend        = 010000
~mqr + arb_addend = 000110
mg                = 000000 <- no one is granted! This is bad.

What is needed is to propagate the carry out from the ~mqr + arb_addend
operation through the LSB, so that the sum becomes 000111, and mg is 000001.
This operation could be called a "circular add".  It sounds a bit scary and
might completely confuse the timing analyzer.  An alternate solution: concatenate
the mqr vector with itself, and OR corresponding bits from the top and bottom
halves to determine mg.  Example:

{mqr, mqr}                = 001001 001001
arb_addend                = 000000 010000
{~mqr, ~mqr} + arb_addend = 110111 000110
result of & operation     = 000001 000000
mg                        =        000001

=cut

sub _handle_numerator_arbitration
{
   my $this = shift;
   my $slave_SBI         = $this->_master_or_slave()->{SYSTEM_BUILDER_INFO};

   my $module_to_put_logic = $this;


   my @masters = ($this->_get_master_descs());



   my @slave_ids = $this->_get_bridged_slave_ids_with_base_address();
   


   return if !@slave_ids;
   

   my $bridge_slave_id = $this->_get_slave_id();



   my $master_qreq_vector =
     $this->_make_signal("$bridge_slave_id/master_qreq_vector");
   my $grant_vector =
     $this->_make_signal("$bridge_slave_id/grant_vector");
   my $allow_new_arb_cycle =
     $this->_make_signal("$bridge_slave_id/allow_new_arb_cycle");
   


   if (@masters == 1)
   {
      my $master_desc = $masters[0];
      my $master = $this->_get_master($master_desc);
      
      foreach my $slave_id (@slave_ids)
      {
         my $master_grant =
           $this->_get_master_grant_signal_name($master_desc, $slave_id);

         $master->_arbitrator()->sink_signals($master_grant);
         my $master_qualified_request =
             $this->_get_master_qualified_request_signal_name
                 ($master_desc, $slave_id);

         e_assign->new({
            comment => "master is always granted when requested",
            lhs     => {name => $master_grant, export => 1, },
            rhs     => $master_qualified_request,
          })->within($this);



         my $master_request = $this->_get_master_request_signal_name(
           $master_desc,
           $slave_id
         );
         my $saved_grant =
           $this->_get_saved_master_grant_signal_name($master_desc, $slave_id);
         $module_to_put_logic->get_and_set_once_by_name({
            thing       => "assign",
            name        => "$master_desc saved-grant $slave_id",
            lhs         => {name => $saved_grant, never_export => 1, },
            rhs         => $master_request,
         });

         my $master_has_arbiterlock_pin =
           $this->_get_qualified_arbiterlock($master_desc); 
         if ($master_has_arbiterlock_pin) {


           my $saved_chosen_master_for_this_master = 
             $this->_get_saved_chosen_master_for_particular_master 
                 ($master_desc, $slave_id);
           $module_to_put_logic->get_and_set_once_by_name({
             thing       => "assign",
             name        => "saved chosen master btw $master_desc and $slave_id",
             lhs         => e_signal->new({
                             name  => $saved_chosen_master_for_this_master,
                             width => 1,
                             never_export  => 1,
                           }),
             rhs         => $master_request,
           });
         }

        $module_to_put_logic->get_and_set_once_by_name({
            thing       => 'assign',
            name        => "allow new arb cycle for $bridge_slave_id",
            lhs => {name => $allow_new_arb_cycle, never_export => 1, },
            rhs => 1,
        });

        $module_to_put_logic->get_and_set_once_by_name({
            thing => 'assign',
            name        => "$bridge_slave_id chosen-master vector",
            lhs         => {
              name         => $grant_vector,
              width        => 0 + @masters,
              export       => 0,
              never_export => 1,
            },
            rhs => 1,
            comment     => "placeholder chosen master",
        });

        $module_to_put_logic->get_and_set_once_by_name({
          thing       => "assign",
          name        => "$bridge_slave_id vector of master qualified-requests",
          lhs         => {
            name         => $master_qreq_vector,
            width        => 0 + @masters,
            export       => 0,
            never_export => 1,
          },
          rhs         =>  1,
          comment     => "placeholder vector of master qualified-requests",
        });
      }
      return;
   }







  my @arb_relinquish_table = ();
  for my $master_desc (@masters)
  {
    push @arb_relinquish_table,
      complement($this->_get_arbiterlock_or_proxy($master_desc));
  }

  $module_to_put_logic->get_and_set_once_by_name({
      thing       => 'assign',
      name        => "allow new arb cycle for $bridge_slave_id",
      lhs => e_signal->new({
        name => $allow_new_arb_cycle,
        never_export => 1,
      }),
      rhs => and_array(@arb_relinquish_table),
  });
















  my $arb_winner = $this->_make_signal("$bridge_slave_id/arb_winner");
  my $saved_chosen_master = $this->_make_signal("$bridge_slave_id/saved_chosen_master_vector");
 
  my $chosen_master_rot_left =
   $this->_make_signal("$bridge_slave_id/chosen_master_rot_left");
  my $arb_addend = $this->_make_signal("$bridge_slave_id/arb_addend");

  my $index = 0;

  for my $slave_id (@slave_ids)
  {


    for my $master_desc (reverse sort @masters)
    {
      my $qualified_request = $this->_get_master_qualified_request_signal_name(
              $master_desc,
              $slave_id
      );


      $module_to_put_logic->get_and_set_once_by_name({
        thing       => "assign",
        name        => "$master_desc assignment into master qualified-requests vector for $slave_id",
        lhs         => "$master_qreq_vector\[$index\]",
        rhs         =>  $qualified_request,
      });


      my $grant = $this->_get_master_grant_signal_name($master_desc, $slave_id);
      $module_to_put_logic->get_and_set_once_by_name({
        thing       => "assign",
        name        => "$master_desc grant $slave_id",
        lhs         => e_signal->new({name => $grant, export => 1,}),
        rhs         =>  "$grant_vector\[$index]",
      });

      my $saved_grant = $this->_get_saved_master_grant_signal_name($master_desc, $slave_id);
      my $master_request = $this->_get_master_request_signal_name(
        $master_desc,
        $slave_id
      );
      $module_to_put_logic->get_and_set_once_by_name({
        thing       => "assign",
        name        => "$master_desc saved-grant $slave_id",
        lhs         => e_signal->new({name => $saved_grant,}),
        rhs         =>  "$arb_winner\[$index]" . ($this->is_burst_master($master_desc) ? "" : " && $master_request"),
      });





      my $master_has_arbiterlock_pin =
        $this->_get_qualified_arbiterlock($master_desc); 
      if ($master_has_arbiterlock_pin) {


        my $saved_chosen_master_for_this_master = 
          $this->_get_saved_chosen_master_for_particular_master 
              ($master_desc, $slave_id);
        $module_to_put_logic->get_and_set_once_by_name({
          thing       => "assign",
          name        => "saved chosen master btw $master_desc and $slave_id",
          lhs         => e_signal->new({
                          name  => $saved_chosen_master_for_this_master,
                          width => 1,
                          never_export  => 1,
                        }),
          rhs         => "$saved_chosen_master\[$index\]",
        });
      }

      $index++;
    }
  }

  my $vector_width = $index;
  

  foreach my $vec_sig ($master_qreq_vector, $grant_vector, $arb_winner, $saved_chosen_master, $chosen_master_rot_left, $arb_addend, )
  {
    $module_to_put_logic->get_and_set_once_by_name({
      thing => 'signal',
      name  => "$vec_sig",
      width => $vector_width,
      never_export => 1,
    });
  }

  my $chosen_master_double_vector = $this->_make_signal("$bridge_slave_id/chosen_master_double_vector");
  $module_to_put_logic->get_and_set_once_by_name({
   thing => 'assign',
   name        => "$bridge_slave_id chosen-master double-vector",
   lhs         => e_signal->new({
     name         => $chosen_master_double_vector,
     width        => 2 * $vector_width,
     export       => 0,
     never_export => 1,
   }),
   rhs => and_array("{$master_qreq_vector, $master_qreq_vector}",
     "({~$master_qreq_vector, ~$master_qreq_vector} + $arb_addend)"
   ),
  });






  my @chosen_master_halver;
  for (0 .. -1 + $vector_width)
  {
    push @chosen_master_halver,
      "($chosen_master_double_vector\[$_] | $chosen_master_double_vector\[@{[$_ + $vector_width]}])";
  }



  $module_to_put_logic->get_and_set_once_by_name({
    thing => 'assign',
    name        => "$bridge_slave_id arb winner",
    lhs         => $arb_winner,

    rhs => "($allow_new_arb_cycle & | $grant_vector) ? $grant_vector : $saved_chosen_master",
    comment     => "stable onehot encoding of arb winner",
  });

  $module_to_put_logic->get_and_set_once_by_name({
    thing => 'register',



    enable      => $allow_new_arb_cycle,
    name        => "saved $grant_vector",
    in          => "|$grant_vector ? $grant_vector : $saved_chosen_master",
    out         => $saved_chosen_master,
  });

  $module_to_put_logic->get_and_set_once_by_name({
    thing => 'assign',
    name        => "$bridge_slave_id chosen-master vector",
    lhs         => $grant_vector,
    rhs         => concatenate(reverse(@chosen_master_halver)),
    comment     => "onehot encoding of chosen master",
  });





  ribbit("Assert at least 2 masters.") if $vector_width < 2;

  $module_to_put_logic->get_and_set_once_by_name({
    thing => 'assign',
    name => "$bridge_slave_id chosen master rotated left",
    lhs => $chosen_master_rot_left,
    rhs => "($arb_winner << 1) ? ($arb_winner << 1) : 1",
  });

  $module_to_put_logic->get_and_set_once_by_name({
    thing       => 'register',
    enable      => 1,
    name        => "$arb_addend arb addend",
    out         => $arb_addend,
    in => $this->_make_end_xfer() . "? $chosen_master_rot_left : $grant_vector",
    async_value => 1,
    enable => "|$grant_vector",
    comment     =>
    "$bridge_slave_id\'s addend for next-master-grant",
  });



  for my $master_desc (@masters)
  {
    foreach my $slave_id (@slave_ids)
    {
      my $master_qualified_request =
        $this->_get_master_qualified_request_signal_name
        ($master_desc, $slave_id);
      my $master_grant =
        $this->_get_master_grant_signal_name($master_desc, $slave_id);

      $this->_add_value_to_master_run($master_desc,
        "($master_grant | ~$master_qualified_request)");
    }
  }
  
}



=item I<_make_end_xfer()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _make_end_xfer
{
   my $this = shift;


   my $slave = $this->_slave();
   my $slave_SBI = $slave->{SYSTEM_BUILDER_INFO};

   my @mux_table;

   my $slave_id = $this->_get_slave_id();
   my $end_xfer = $this->_make_signal("$slave_id/end_xfer");
   my $first_time =
       $this->get_and_set_once_by_name({
          thing => "assign",
          name  => "$end_xfer assignment",

          lhs   => [$end_xfer => 1,0],
       });

   if ($first_time)
   {
      my @or_array;
      foreach my $slave_id
                  ($this->_get_bridged_slave_ids_with_base_address())
      {
         push (@or_array,
               $this->get_slave_wait("read",$slave_id),
               $this->get_slave_wait("write",$slave_id));
      }
      $first_time->rhs
          (&complement (&or_array(@or_array)));
          
   














   }
   return "$end_xfer";
}



=item I<_make_begin_xfer()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _make_begin_xfer
{
   my $this  = shift;
   my $slave_id = $this->_get_slave_id();


   my $name = $this->_make_signal("$slave_id/begins_xfer");

   return ($name)
       if ($this->get_signal_by_name($name));

   my $slave = $this->_get_slave($slave_id);
   my $slave_SBI = $slave->{SYSTEM_BUILDER_INFO};

   my @chip_selects;

   foreach my $slave_id ($this->_get_bridged_slave_ids_with_base_address())
   {
      foreach my $master_desc ($this->_get_master_descs())
      {


         push (@chip_selects,
               $this->_get_master_qualified_request_signal_name($master_desc,
                                                                $slave_id)
               );
      }
   }
   my $slave = $this->_master_or_slave();
   my $cs    = &or_array(@chip_selects);

   $this->update_item
       (e_register->new
        ({
           out  => [d1_reasons_to_wait => 1],

           in   => &complement($this->_make_end_xfer($slave_id)),
           enable => 1,
        }));

   $this->update_item
       (
        e_assign->new ({
           lhs => [$name => 1,0,1],
           rhs => "~d1_reasons_to_wait & ($cs)",
        })
        );

   return ($name);
}



=item I<_get_bridge_slave_arbitration_modules()>

If this is a bridge, gets all other slaves in this module
(we assume for now that they are all part of the bridge).
If this isn't a bridge, then just return $this.
Ed: This subroutine is quite useful for for loops.

=cut

sub _get_bridge_slave_arbitration_modules
{
   my $this = shift;



   my $parent = $this->_slave()->parent_module();

   if ($parent->{SYSTEM_BUILDER_INFO}{Is_Bridge})
   {
      my $p_name = $parent->name();

      exists ($parent->{SLAVE})
          or &ribbit ("houston, we have a problem");
      my @return_array;

      foreach my $slave_name (keys (%{$parent->{SLAVE}}))
      {
         my $slave_desc = "$p_name/$slave_name";
         my $slave  = $this->_get_slave($slave_desc)
             or &ribbit ("could not find slave $slave_desc");
         push (@return_array,
               $slave->_arbitrator()
               );
      }
      return (@return_array);
   }
   else
   {
      return ($this);
   }
}



=item I<_get_bridge_master_desc()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_bridge_master_desc
{
   my $this = shift;
   my $slave_id = $this->_get_slave_id();

   my $bridge_master =
       $this->_slave()->{SYSTEM_BUILDER_INFO}{Bridges_To}
   or return;

   my $slave_module      = $this->_master_or_slave()->parent_module();
   my $this_slave_module_name = $slave_module->name();

   return "$this_slave_module_name/$bridge_master";
}


=item I<_get_bridged_slave_ids()>

If this is a bridge, gets all slaves masterd by the bridge,
otherwise returns slave_id

=cut

sub _get_bridged_slave_ids
{
   my $this = shift;
   return
    ($this->_go_through_bridged_slave_ids_with_respect_to_base_address(0));
}


=item I<_get_bridged_slave_ids_with_base_address()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_bridged_slave_ids_with_base_address
{
   my $this = shift;
   return
    ($this->_go_through_bridged_slave_ids_with_respect_to_base_address(1));
}



=item I<_get_irq_slave_masters()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_irq_slave_masters
{
   my $this = shift;
   my $slave_id = shift || ribbit("no slave id!");
   
   my @masters = keys
       (%{$this->_get_slave($slave_id)->{SYSTEM_BUILDER_INFO}{IRQ_MASTER}});

   my @enabled_masters;

   foreach my $master_desc (@masters)
   {
      my ($master_module_name, $master_name) = split (/\//,$master_desc);
      my $project = $this->_master_or_slave()->project();
      my $master_module =
          $project->get_module_by_name($master_module_name);
      next unless $master_module;
      my $master = $master_module->get_object_by_name($master_name);
      next unless $master;

      if (

          ($master->{SYSTEM_BUILDER_INFO}{Is_Enabled} ne '0') &&
          ($master->parent_module()->{SYSTEM_BUILDER_INFO}{Is_Enabled}
           ne '0') 
          )
      {
         push (@enabled_masters, $master_desc);
      }
   }

   return @enabled_masters;
}


=item I<_go_through_bridged_slave_ids_with_respect_to_base_address()>

If this is a bridge, gets all slaves mastered by the bridge,
otherwise returns slave_id.
Specific to avalon bus.  If you make a bus, you have to rewrite this.

=cut

sub _go_through_bridged_slave_ids_with_respect_to_base_address
{
   my $this = shift;
   my $require_base_address = shift; # 1= require base addresses, 0= don't.

   my $slave = $this->_slave();
   my $is_enabled = $slave->{SYSTEM_BUILDER_INFO}{Is_Enabled} &&
       $slave->parent_module()->{SYSTEM_BUILDER_INFO}{Is_Enabled};
   return () unless (eval ($is_enabled) == 1);# not enabled == forget it.

   my $bridge_master =
      $this->_slave()->{SYSTEM_BUILDER_INFO}{Bridges_To};

   if ($bridge_master)
   {
      my $slave_module      = $this->_master_or_slave()->parent_module();
      my $this_slave_module_name = $slave_module->name();

      my $bridge_master_desc = $this_slave_module_name . "/" . $bridge_master;
      my $bridge_master_object = $this->_get_master($bridge_master_desc);
      my $bridge_master_bus_type=
        $bridge_master_object->{SYSTEM_BUILDER_INFO}{Bus_Type};

      if ($bridge_master_bus_type =~ /avalon/i) {

        my @bridged_slaves_tested_for_base_address;
        my @slaves_behind_bridge =
              ($this->project()->get_slaves_by_master_name
                       ($this_slave_module_name, $bridge_master));

        foreach my $slave (@slaves_behind_bridge) {
            push (@bridged_slaves_tested_for_base_address, $slave)
                if ((!$require_base_address) or
                    ($this->_slave_has_base_address($slave)));
        }
        return (@bridged_slaves_tested_for_base_address);
      }
   }
   my $slave_name  = $this->_master_or_slave()->name();
   my $module_name = $this->_master_or_slave()->parent_module()->name();




   my $slave_id = "$module_name/$slave_name";
   my @return_this = ();
   push (@return_this, $slave_id)
      if ((!$require_base_address) or
          ($this->_slave_has_base_address($slave_id)));

   return (reverse sort @return_this);
}



=item I<_add_to_output_mux()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _add_to_output_mux
{
   my $this = shift;




   my ($master_desc,
       $type,
       $rhs,
       $default,
       $select) = @_;



   my $master = $this->_get_master($master_desc);
   my $master_arbitrator = $master->_arbitrator();

   my $lhs = $master->_get_exclusively_named_port_by_type("$type");

   my $master_arbitrator_mux = $master_arbitrator->_get_mux_of_type
       ("$master_desc $type");
   $master_arbitrator_mux->default($default) if defined ($default);
   $master_arbitrator_mux->lhs($lhs);
   my $master_request = $select || $this->_get_master_request_signal_name
       ($master_desc);
   $master_arbitrator_mux->add_table($master_request => $rhs);
}



=item I<_get_master_id()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master_id
{
   my $this        = shift;
   my $master_desc = shift or &ribbit ("no md");

   my $master_mod  = $this->_get_master_module
       ($master_desc);

   my $number_of_kids    = scalar (keys (%{$master_mod->{SLAVE}}) +
                                   keys (%{$master_mod->{MASTER}})
                                   );
   if ($number_of_kids > 1)
   {
      return ($master_desc);
   }
   else
   {
      my $master_name = $master_mod->name()
          or &ribbit ("no name for master");
      return ($master_name);
   }
}



=item I<_get_generic_master_slave_signal_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_generic_master_slave_signal_name
{
   my $this = shift;
   my $master_desc = $this->_get_master_id(shift)
       or &ribbit ("no master desc");
   my $identity = shift or &ribbit ("no id");

   my $slave_id = shift or &ribbit ("no slave id");

   return ($this->_make_signal("$master_desc/$identity/$slave_id"));
}



=item I<_get_master_lock()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master_lock
{
   my $this = shift;
   my $master_desc = shift;
   my $slave_id = shift || $this->_get_slave_id();
   return $this->_make_signal($slave_id."_locked_by_$master_desc");
}



=item I<_get_read_data_valid_signal_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_read_data_valid_signal_name
{
   my $this = shift;
   return ($this->_get_generic_master_slave_signal_name(shift,
                                                        "read_data_valid",
                                                        shift
                                                        )
           );
}



=item I<_get_read_latency_fifo_is_non_empty_name()>

Get the signal name that means "Read latency (variable or fixed) FIFO
is non-empty".

=cut

sub _get_read_latency_fifo_is_non_empty_name
{
   my $this = shift;

   my $master = $this->_get_master($_[0]);
   $this->get_master_readdata_port($master) or return;

   return $this->_get_read_data_valid_signal_name(@_).
       "_shift_register";
}



=item I<_get_master_request_signal_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master_request_signal_name
{
   my $this = shift;
   return ($this->_get_generic_master_slave_signal_name(shift,
                                                        "requests",
                                                        shift
                                                        )
           );
}



=item I<_get_master_qualified_request_signal_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master_qualified_request_signal_name
{
   my $this = shift;
   return $this->_get_generic_master_slave_signal_name(
      shift, "qualified_request",shift
   );
}



=item I<_or_all_master_qualified_request_signal_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _or_all_master_qualified_request_signal_names
{
   my $this = shift;
   return (&or_array($this->_get_all_master_qualified_request_signal_names(@_)));
}



=item I<_get_all_master_qualified_request_signal_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_all_master_qualified_request_signal_names
{
   my $this = shift;
   my $master_desc = shift or &ribbit ("no masterd");

   my @slaves = $this->get_all_bridge_slaves_mastered_by_master_desc($master_desc);
   return (map {$this->_get_master_qualified_request_signal_name
                    ($master_desc,$_)} @slaves
           );
}



=item I<get_all_bridge_slaves_mastered_by_master_desc()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_all_bridge_slaves_mastered_by_master_desc
{
   my $this = shift;
   my $master_desc = shift;
   my @slaves = $this->_get_bridged_slave_ids_with_base_address();




   my (@exclusive_masters) = grep
   {
      my $slave_module_name = $_;
      $this->_get_slave($_)->{SYSTEM_BUILDER_INFO}{Exclusively_Mastered_By}
      eq $master_desc;
   } @slaves;

   if (@exclusive_masters)
   {
      @slaves = @exclusive_masters;
   }
   else
   {



      @slaves = grep
      {
         !$this->_get_slave($_)->{SYSTEM_BUILDER_INFO}{Exclusively_Mastered_By}
      } @slaves;
   }
   return @slaves;
}



=item I<_get_master_grant_signal_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master_grant_signal_name
{
   my $this = shift;
   return ($this->_get_generic_master_slave_signal_name(shift,
                                                        "granted",
                                                        shift,
                                                        )
           );
}



=item I<_get_saved_master_grant_signal_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_saved_master_grant_signal_name
{
   my $this = shift;
   return ($this->_get_generic_master_slave_signal_name(shift,
                                                        "saved_grant",
                                                        shift,
                                                        )
           );
}


=item I<_get_max_arb_share()>

Get the maximum arb share over all of this masters' slaves.
When burstcount is implemented, this function will return the largest value
that output can assume.

=cut

sub _get_max_arb_share
{
  my $this = shift;
  my $master_desc = shift;

  ribbit("no ref") if !ref($this);
  ribbit("no master_desc") if !$master_desc;

  my @all_slaves_of_this_master =
    $this->project()->get_slaves_by_master_name($master_desc);

  return max(
    map {
      $this->_get_arb_share($master_desc, $_)
    } @all_slaves_of_this_master
  );
}



=item I<_get_arb_share()>

Get the arb-share/burstcount value for a particular slave.
The particular slave (beyond any bridges) must be passed in
in case of murl slaves beyond bridges.
If the master has a burstcount port, this routine
returns the maximum value that port can encode.

=cut

sub _get_arb_share
{
  my $this = shift;
  my $master_desc = shift;
  my $slave_id = shift;

  ribbit("no ref") if !ref($this);
  ribbit("no master_desc") if !$master_desc;
  
  my $slave         = $this->_slave();
  my $bridge_slave_SBI     = $slave->{SYSTEM_BUILDER_INFO};
  my $slave_SBI = $this->_get_slave($slave_id)->{SYSTEM_BUILDER_INFO};

  my $master = $this->_get_master($master_desc);
  my $master_SBI = $master->{SYSTEM_BUILDER_INFO};

  my $dbs_shift =
    $this->_how_many_bits_of_dynamic_bus_size_are_needed
      ($master_desc,$slave_id);

  my $burstcount = $this->get_master_arbitrationshare_port($master);
  if(!$burstcount && $this->is_burst_master($master))
  {
    $burstcount = $this->get_master_burstcount_port($master);
  }

  my $arb_share;
  if ($burstcount)
  {
    my $burst_sig = $master->_arbitrator()->get_signal_by_name($burstcount);
    if (!$burst_sig)
    {
      ribbit("master '$master_desc': invalid burstcount signal name ($burstcount)\n");
    }

    if ($burst_sig->width() < 1)
    {
      ribbit("master '$master_desc': invalid burstcount width (@{[$burst_sig->width()]})\n");
    }

    $arb_share = 2 ** ($burst_sig->width() - 1);
    $arb_share <<= $dbs_shift if ($dbs_shift > 0);
  }
  else
  {
    $arb_share = $this->get_arbitration_section($master_desc)->{priority} || 1;
  }










  $arb_share <<= $dbs_shift if ($dbs_shift > 0);
  
  return max(
    $arb_share,
    $slave_SBI->{Minimum_Uninterrupted_Run_Length},
  );
}



=item I<_get_arb_share_or_burst_count()>

This routine returns the master's burstcount signal name
with appropriate shifting for dbs purposes, if it has one,
or the master's arbitration share value for the given slave.

=cut

sub _get_arb_share_or_burst_count
{
  my $this = shift;
  my $master_desc = shift;
  my $slave_id = shift;
  ribbit("no ref") if !ref($this);
  ribbit("no master_desc") if !$master_desc;
  
  my $slave         = $this->_slave();
  my $bridge_slave_SBI     = $slave->{SYSTEM_BUILDER_INFO};
  my $slave_SBI = $this->_get_slave($slave_id)->{SYSTEM_BUILDER_INFO};

  my $master = $this->_get_master($master_desc);
  my $master_SBI = $master->{SYSTEM_BUILDER_INFO};

  my $dbs_shift =
    $this->_how_many_bits_of_dynamic_bus_size_are_needed
      ($master_desc,$slave_id);


  my $burstcount = $this->get_master_arbitrationshare_port($master); 
  if(!$burstcount && $this->is_burst_master($master))
  {
    $burstcount = $this->get_master_burstcount_port($master);
  }
 
  if ($burstcount)
  {

    $burstcount .= "<< $dbs_shift" if $dbs_shift > 0;
    return $burstcount;
  }

  my $arb_share;
  $arb_share = $this->get_arbitration_section($master_desc)->{priority} || 1;
  
  ribbit("bad arb share value ($arb_share) for $master_desc -> $slave_id\n")
    if ($arb_share <= 0);












  $arb_share <<= $dbs_shift if ($dbs_shift > 0);
  
  return max(
    $arb_share,
    $slave_SBI->{Minimum_Uninterrupted_Run_Length},
  );
}



=item I<_get_read_data_address_signal_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_read_data_address_signal_name
{
   my $this = shift;
   return ($this->_get_generic_master_slave_signal_name(shift,
                                                        "latent_address",
                                                        )
           );
}



=item I<_get_master_dbs_address()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master_dbs_address
{
   my $this = shift;
   my $master_name = $this->_get_master_id(shift) or &ribbit ("no master_desc");

   return ($this->_make_signal
           ("$master_name/dbs_address")
           );
}



=item I<_get_master_dbs_rdv_counter()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master_dbs_rdv_counter
{
   my $this = shift;
   my $master_name = $this->_get_master_id(shift) or &ribbit ("no master_desc");

   return ($this->_make_signal
           ("$master_name/dbs_rdv_counter")
           );
}



=item I<_get_master_latency_counter_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master_latency_counter_name
{
   my $this = shift;
   my $master_name = $this->_get_master_id(shift) or &ribbit ("no master_desc");

   return ($this->_make_signal
           ("$master_name/latency_counter")
           );
}



=item I<_get_my_master_dbs_address_indices()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_my_master_dbs_address_indices
{
   my $this        = shift;
   my $master_desc = shift or &ribbit ("No master-desc");
   my $slave_id    = shift or &ribbit ("no slave id");

   my $indices;





   my $master_dbs_address = $this->_get_master_dbs_address($master_desc);

   my $master_aligned_shift =
       $this->_get_master_aligned_shift($master_desc);

   my $shift =
       $this->_get_address_shift_amount
           ($master_desc,
            $slave_id
            );

   my $master_aligned_msb = $master_aligned_shift - 1;

   $indices = "$master_aligned_msb : $shift";

   if ($master_aligned_shift == 1) {

      $indices = "$master_dbs_address\.msb";
   } elsif (($master_aligned_shift - $shift) == 1) {

      $indices = "$shift";
   }

   return $indices;
}



=item I<_get_my_portion_of_master_dbs_rdv_counter()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_my_portion_of_master_dbs_rdv_counter
{
   my $this        = shift;
   my $master_desc = shift or &ribbit ("No master-desc");
   my $slave_id    = shift or &ribbit ("no slave id");

  my $master_dbs_rdv_counter =
    $this->_get_master_dbs_rdv_counter($master_desc);

   my $indices =
     $this->_get_my_master_dbs_address_indices($master_desc, $slave_id);

   return "$master_dbs_rdv_counter\[$indices]";
}



=item I<_get_my_portion_of_master_dbs_address()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_my_portion_of_master_dbs_address
{
   my $this        = shift;
   my $master_desc = shift or &ribbit ("No master-desc");
   my $slave_id    = shift or &ribbit ("no slave id");

   my $master_dbs_address = $this->_get_master_dbs_address($master_desc);
   my $indices =
     $this->_get_my_master_dbs_address_indices($master_desc, $slave_id);

   return "$master_dbs_address\[$indices]";
}



=item I<_get_master_aligned_shift()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master_aligned_shift
{
   my $this        = shift;
   my $master_desc = shift or &ribbit ("No master-desc");
   if ($this->master_is_adapter($master_desc))
   {
      return 0;
   }
   return log2($this->_get_master_data_width($master_desc) / 8);
}



=item I<_get_master_data_width()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master_data_width
{
   my $this              = shift;
   my $master_desc       = shift or &ribbit ("No master-desc");
   return $this->project()->get_master_data_width($master_desc);
}



=item I<_get_slave_data_width()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_slave_data_width
{
   my $this     = shift;
   my $slave_id = shift or &ribbit ("no slave_id");
   return $this->project()->get_slave_data_width($slave_id);
}



=item I<_get_slave_SBI()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_slave_SBI
{
   my $this              = shift;
   return $this->project()->SBI ($this->_get_slave_desc());
}



=item I<_slave_is_offchip()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _slave_is_offchip
{
   my $this = shift;

   my $slave        = $this->_slave();
   my $slave_SBI    = $slave->{SYSTEM_BUILDER_INFO};
   my $slave_module = $slave->parent_module();
   my $mod_SBI      = $slave_module->{SYSTEM_BUILDER_INFO};

   my $in_system_module = eval ($mod_SBI->{Instantiate_In_System_Module});

   return !($in_system_module);
}










=item I<_get_slave_desc()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_slave_desc
{
   my $this = shift;
   my $slave_module      = $this->_master_or_slave()->parent_module();
   my $slave_name        = $this->_master_or_slave()->name();

   return join ("/", $slave_module->name(), $slave_name);
}



=item I<_get_read_pending_for_slave()>

Inputs slave_id.  Returns all master-slave combos which generate
    read-pending for the slave

=cut

sub get_read_pending_for_slave
{
   my $this = shift;
   my $slave_id = shift;
   my @or_array;
   foreach my $master_desc ($this->_get_master_descs())
   {
      my $read_latency = $this->_get_slave_latency($slave_id);

      my $master = $this->_get_master($master_desc);
      my $master_read = $this->get_master_read($master);
      next unless $master_read;

      my $shift_register =
          $this->_get_read_latency_fifo_is_non_empty_name
          ($master_desc, $slave_id);
      next unless $shift_register;

      push (@or_array, "(|$shift_register\[$read_latency - 1:0\])");
   }   
   return &or_array(@or_array);
}



=item I<_get_read_pending()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_read_pending
{
   my $this = shift;
   return unless $this->is_tristate_bridge;

   my $slave_id = $this->_get_slave_id();

   my $read_pending =
       $this->_make_signal($slave_id."_read_pending");

   my $sig = $this->get_and_set_once_by_name
       ({
          thing => "signal",
          name  => "$read_pending",
          width => 1,
       });

   if ($sig)
   {
      my @slave_reads_pending;
      foreach my $slave_id
                      ($this->_get_bridged_slave_ids_with_base_address())
      {
         my $slave = $this->_get_slave($slave_id);
         my $read_latency = $this->_get_slave_latency($slave_id);

         if ($read_latency >= 1)
         {
            push (@slave_reads_pending, 
                  $this->get_read_pending_for_slave($slave_id)
                  );
         }
      }

      $this->get_and_set_once_by_name
          ({
             thing => 'assign',
             name  => "$slave_id read pending calc",
             lhs   => $read_pending,
             rhs   => &or_array(@slave_reads_pending),
          });
   }
   return ($read_pending);
}



=item I<_get_write_pending()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_write_pending
{
   my $this = shift;
   return unless $this->is_tristate_bridge;

   my $write_pending =
       $this->_make_signal($this->_get_slave_id()."_write_pending");

   my $sig = $this->get_and_set_once_by_name
       ({
          thing => "signal",
          name  => "$write_pending",
          width => 1,
       });

   if ($sig)
   {
      my @or_array;# = ("in_a_write_cycle");
      foreach my $slave_id
                      ($this->_get_bridged_slave_ids_with_base_address())
      {
          my $slave = $this->_get_slave($slave_id);
          my $slave_select = $slave->_get_exclusively_named_port_by_type('chipselect');

         my $write_latency = $this->_get_write_latency($slave);

         my $slave_write_pipe = $this->_make_signal($slave_id."_write_pipe");
         if ($write_latency)
         {
             my $shift_in = &and_array($slave_select,"in_a_write_cycle",
                                       &complement($this->get_slave_wait("write",$slave_id)
                                                   )
                                       );
             my $in = "{".$slave_write_pipe."[".($write_latency - 1)." : 0], $shift_in}";

            $this->get_and_set_once_by_name
                ({
                   thing  => 'register',
                   name   => "$slave_id has pending write",
                   out    => [$slave_write_pipe => $write_latency],
                   in     => $in,
                   enable => 1,
                });
            push (@or_array, "|$slave_write_pipe");
         }
      }
      e_assign->new([$write_pending, &or_array(@or_array)])
          ->within($this);
   }
   return ($write_pending);
}



=item I<_get_local_read_pending()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_local_read_pending
{
   my $this = shift;
   my $slave_id = shift or &ribbit ("no slave_id");
   return $this->_make_signal("$slave_id/has_a_read_pending");
}



=item I<_get_slave_wait()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_slave_wait
{
   my $this = shift;
   my $read_or_write = shift or &ribbit ("no rw");
   my $slave_id = shift or &ribbit ("no slave_id");
   return $this->_make_signal("$slave_id/waits_for_$read_or_write");
}



=item I<_get_d1_end_xfer()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_d1_end_xfer
{
   my $this = shift;
   my $slave_id = $this->_get_slave_id();
   my $sig = $this->_make_signal("d1_${slave_id}_end_xfer");

   if ($this->get_and_set_once_by_name
       ({
          thing       => "register",
          async_value => 1,
          name        => "$sig register",
          out         => [$sig => 1,1],
          in          => $this->_make_end_xfer($slave_id),
          enable      => 1,
       }))
   {
     foreach my $master_desc ($this->_get_master_descs())
     {
        my $master = $this->_get_master($master_desc);
        my $d1_end_xfer = $sig;

        $master->_arbitrator()->sink_signals($d1_end_xfer);
     }
  }

   return $sig;
}



=item I<_get_counter_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_counter_name
{
   my $this = shift;
   my $slave_id = shift or &ribbit ("no slave_id");
   my $sig = $this->_make_signal("${slave_id}_wait_counter");
}



=item I<_get_counter_eq_0_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_counter_eq_0_name
{
   my $this = shift;
   my $c = $this->_get_counter_name(@_);
   return ($c."_eq_0");
}



=item I<_get_counter_eq_1_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_counter_eq_1_name
{
   my $this = shift;
   my $c = $this->_get_counter_name(@_);
   return ($c."_eq_1");
}



=item I<_get_wait_for_counter_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_wait_for_counter_name
{
   my $this = shift;
   my $slave_id = shift or &ribbit ("no slave_id");
   return $this->_make_signal("wait_for/$slave_id/counter");
}



=item I<_get_byteenable_signal_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_byteenable_signal_name
{
   my $this = shift;
   return ($this->_get_generic_master_slave_signal_name
           (shift, "byteenable",shift)
           );
}



=item I<_handle_waitrequest()>

For most cases, the master's waitrequest will be identical to master_run.
However, there are special cases (registered versions, asynchronous master,
etc.) where we want more control over the waitrequest that goes to the master.

_handle_waitrequest determines how the waitrequest pin should be related 
to the master_run signal, and produces the final waitrequest signal that is
provided to the master.

=cut

sub _handle_waitrequest
{
  my $this = shift;
  my ($master_desc, $slave_id) = @_;
  my $master            = $this->_get_master ($master_desc);
  my $master_arbitrator = $master->_arbitrator();
  my $master_run        = $this->_get_master_run($master_desc);
  my $master_SBI        = $master->{SYSTEM_BUILDER_INFO};
  my $master_uses_async_rules = $master_SBI->{Is_Asynchronous};
  my $waitrequest_n_port_name =
    $master->_get_exclusively_named_port_or_its_complement("waitrequest_n");
  $waitrequest_n_port_name or &ribbit ("Master with no waitrequest port.");

  e_signal->new([$waitrequest_n_port_name,1,1])->within($master_arbitrator);

  if ($master_uses_async_rules) {




    my $read   = $this->get_master_read  ($master); # get sync read 
    my $write  = $this->get_master_write ($master); # get sync write 

    my $aread  = $this->get_master_read  ($master, "pin"); # get async read pin
    my $awrite = $this->get_master_write ($master, "pin"); # get async write pin




    my $untristated_waitrequest_n = "untristated_waitrequest_n";

    $master_arbitrator->get_and_set_once_by_name ({
        thing       => "register",
        name        => "untristated waitrequest_n port",
        out         => e_signal->new ({
            name          => "$untristated_waitrequest_n",
            width         => 1,
            never_export  => 1,
        }),

        sync_reset  => &complement ("$aread | $awrite"),  





        sync_set    => "$master_run & ($read | $write)" ,
        priority    => "reset",           # of set/reset, reset is priority
        enable      => 1,
    });

    my $master_cs = 
      $master->_get_exclusively_named_port_or_its_complement('chipselect');


    if (! $master_cs) {
      $master_cs = 1;
    }
    $master_arbitrator->get_and_set_once_by_name({
        thing => "assign",
        name  => "waitrequest_n tristate driver",
        lhs   => $waitrequest_n_port_name,
        rhs   => "($master_cs)? $untristated_waitrequest_n: 1\'bz",
    });
  } elsif ($master->{SYSTEM_BUILDER_INFO}{Register_Incoming_Signals}) {

    my $select_term = $this->get_master_chip_select_logic($master_desc);
    my $nothing_selected = &complement($select_term);

    $master_arbitrator->get_and_set_once_by_name ({
        thing => "register",
        name  => "actual waitrequest port",
        out   => $waitrequest_n_port_name,
        in    => "($nothing_selected)? 0: ($master_run & ".
                  &complement($waitrequest_n_port_name).")",
        enable => 1,
    });
  } else {
    $master_arbitrator->get_and_set_once_by_name ({
        thing => "assign",
        name  => "actual waitrequest port",
        lhs   => $waitrequest_n_port_name,
        rhs   => $master_run,
    });
  }
}

=item I<_handle_byte_address()>
  Perhaps your slave interface prefers to see a byte address, instead of the
  usual slave-data-width-aligned address (e.g. altera_avalon_burst_adapter's
  "upstream" slave interface).  If so, use an input of avalon-type
  "byteaddress" instead of the usual "address".  
  
  To do: it would be nice to also allow masters to specify a byte address
  (that's the normal default, but presently masters on adapters specify
  a slave-aligned address).  This enhancement will have to wait.
  
  Sorry, but right now you must also have a port of type "address" or
  generation will fail with some obscure message.  If you don't actually need
  it, don't forget to sink it so it won't be trimmed away during generation.
=cut

sub _handle_byte_address($$$)
{
  my $this = shift;
  my $master_desc = shift or &ribbit ("no master_d");
  my $slave_id    = shift or &ribbit ("no slave_id");
  
  my $master = $this->_get_master($master_desc);
  my $slave = $this->_get_slave($slave_id);
  my $master_grant =
    $this->_get_master_grant_signal_name($master_desc, $slave_id);

  my $byteaddress =
    $slave->_get_exclusively_named_port_or_its_complement("byteaddress");
  
  $byteaddress || return;
  
  my $masteraddress = $this->get_master_address_port($master);

  $this->get_and_set_thing_by_name({
    thing => "mux",
    lhs   => $byteaddress,
    name  => "byteaddress mux for $slave_id",
    add_table => [$master_grant, $masteraddress],
  });
}



=item I<_get_master_run()>

  And you may ask yourself
  How do I work this? 

Method "_get_master_run" is an access method to get the signal that represents
the internal Avalon run-state of an Avalon master's request.  this "master_run"
is often used in internal Avalon state machines when talking about whether a
transaction is stalled or not. 

  And you may ask yourself
  Am I right? ...am I wrong?

You know you're right in calling this subroutine if you're intending to get the
inner run-state workings of the Avalon bus.  If you're looking for the actual
what-the-master-sees signal, that's called its "waitrequest" signal, and can be
accessed through $master->_get_exclusively_named_port_by_type ("waitrequest");

  And you may ask yourself
  Where does that highway go?

This line of thinking leads to the difference between "run" and the actual
master's waitrequest pin.  The waitrequest pin might be registered for the master's
convenience, or follow some funky external timing rules, or... oh, i'm sure
there'll be more reasons in the future why "run" and "waitrequest" are
different.  

  And you may tell yourself
  My god!...what have I done? 

All masters have a master_run, even if they don't have a waitrequest signal.
If you're getting a ribbit or strange behavior when calling this, something is
majorly wrong.  maybe you haven't updated your logic to differentiate between
the master_run or waitrequest? 

Really, the behavior of master_run is the 
  Same as it ever was...same as it ever was...same as it ever was...
... just with a different name.

=cut

sub _get_master_run
{
   my $this = shift;
   my $master_desc = shift or &ribbit ("no master_d");

   my $master = $this->_get_master($master_desc);
   my $master_arbitrator = $master->_arbitrator();

   my ($port,$negate_port) =
       $master->_get_port_or_its_complement ("waitrequest_n");

   return 1 if (!$port);

   my $master_run_name = $this->_make_signal("${master_desc}_run");
   e_signal->new([$master_run_name,1,0])->within($master_arbitrator);

   return $master_run_name;
}



=item I<_get_inhibit_when_wait_mismatch()>

This subroutine returns the signal-to-be-used-as-an-inhibitor.

This signal is only used when:
if the master's registered wait states AREN'T predictable, then we need to
inhibit the Avalon request for (at least) an EXTRA cycle so that Avalon doesn't
interpret the control signals on that last cycle as a fresh read request. 

This is all due to the fact that the internal "master_run" has gone low, but
this information has yet to reach the master's waitrequest signal -- thus, a
"wait mismatch" is happening. 

=cut

sub _get_inhibit_when_wait_mismatch
{
   my $this = shift;
   my $master_desc = shift 
      || &ribbit ("No master desc");
   my $master_inhibit = "0";    # default: no inhibit
   my $master = $this->_get_master($master_desc);
   if ($master->{SYSTEM_BUILDER_INFO}{Register_Incoming_Signals}) {
      $master_inhibit = $master->_get_exclusively_named_port_or_its_complement
             ("waitrequest_n");
   }
   return ($master_inhibit);
}




=item I<_get_slave_in_a_cycle()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_slave_in_a_cycle
{
   my $this = shift;
   my $slave_id = shift or &ribbit ("no slave_id");
   my $read_or_write = shift or &ribbit ("read or write");

   return ($this->_make_signal("$slave_id/in_a_${read_or_write}_cycle"));
}



=item I<_registered_wait_states_are_predictable()>

Determine whether registered wait states are "predictable".
They are "predictable" when Avalon can determine the cycle JUUUUST prior to
the cycle when the waitrequest_n signal becomes asserted. 
(it often boils down to: whenever there isn't a peripheral-controlled wait OR
whenever there is a fixed read-latency)

=cut

sub _registered_wait_states_are_predictable
{
   my $this = shift;
   my $master_desc = shift or &ribbit ("no master_d");
   my $slave_id = shift or &ribbit ("no slave_id");
   my $read_or_write = shift or &ribbit ("no r/w");

   my $master = $this->_get_master($master_desc);

   my $master_rw = $this->get_master_read_or_write($master,
                                                   $read_or_write);
   return 1
       unless ($master_rw);

   my ($wait_states) = $this->_get_wait_states($slave_id,$read_or_write);
   my $read_latency  = $this->get_read_latency($slave_id);
   $read_latency     = 0 if ($read_or_write =~ /w/i);




   my $register_incoming_signals =
       $master->{SYSTEM_BUILDER_INFO}{Register_Incoming_Signals};

   if ( $register_incoming_signals &&
       ((!$read_latency && !$wait_states ) ||
        (($wait_states =~ /\D/) && !$read_latency)))
   {
      return 0;
   }
   else
   {
      return 1;
   }
}



=item I<_get_registered_wait_read_data_valid_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_registered_wait_read_data_valid_name
{
   my $this = shift;
   my $master_desc = shift or &ribbit ("no_master_d");
   my $slave_id = shift or &ribbit ("no_slave_id");
   my $master = $this->_get_master($master_desc);

   !$master->_can_handle_read_latency() || &ribbit
       ("$master_desc/SBI/Register_Incoming_Signals set, but master ",
        "is capable of handling read-latency\n");
   my $read_latency = $this->get_read_latency($slave_id);

   my $rdv = $this->get_read_data_valid_signal_name
       ($master_desc, $slave_id);

   my $registered_rdv = "registered_$rdv";
   my $rrdv_rhs;
   my $latent_shift_register =
       $this->_get_read_latency_fifo_is_non_empty_name
           ($master_desc,
            $slave_id);

   return if !$latent_shift_register;

   if ($read_latency > 1)
   {
      $rrdv_rhs = $latent_shift_register."[".($read_latency - 2)."]";
   }
   elsif ($read_latency == 1)
   {
      $rrdv_rhs = $latent_shift_register."_in";
   }
   else
   {
      &ribbit ("slave $slave_id has ",
               "no read latency");
   }

   if ($this->get_and_set_once_by_name
       ({
          thing => "assign",
          name  => "registered rdv signal_name $registered_rdv assignment",
          lhs   => [$registered_rdv, 1,1],
          rhs   => $rrdv_rhs,
       })
       )
   {

      $master->_arbitrator()->sink_signals($rdv);
   }
   return $registered_rdv;
}



=item I<_get_slave_write_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_slave_write_port
{
   my $this = shift;

   my $slave_id = shift or &ribbit ("no slave_id");
   my $slave = $this->_get_slave($slave_id);

   my $shorten;

   my ($port) = $slave->_get_port_or_its_complement("write");

   if ($slave->{SYSTEM_BUILDER_INFO}{Hold_Time} =~ /half/i)
   {
      $shorten = "shorten";
      if ($port)
      {
         my $name = $port->_exclusive_name();


         foreach my $other_slave_id
                    ($this->_get_bridged_slave_ids_with_base_address())
         {
            next if ($other_slave_id eq $slave_id);

            my $other_slave = $this->_get_slave($other_slave_id);
            next if ($other_slave->
            {SYSTEM_BUILDER_INFO}{Hold_Time} =~ /half/i);

            my ($other_write, $negate_port) =
                $other_slave->_get_port_or_its_complement ("write");
            if ($other_write)
            {
               my $other_write_name =
                   $other_write->_exclusive_name();

               &ribbit ("$slave_id has a half cycle wait. ",
                        "$other_slave_id shares the write pin, but ",
                        "does not have a half cycle wait. "
                        )
                   if ($other_write_name eq $name) ;
            }
         }
      }
   }

   my $port_name = $slave->_get_exclusively_named_port_or_its_complement
       ("write", {shorten => $shorten});

   return $port_name;
}



=item I<_make_and_export_qualified_flush_for_master()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _make_and_export_qualified_flush_for_master
{
   my $this = shift;
   my $master_desc = shift or &ribbit ("no master desc");

   my $internal_qualified_master_flush =
       $this->_make_qualified_flush_for_master($master_desc);
   return "" if $internal_qualified_master_flush eq "";

   my $exported_qualified_master_flush =
       "${internal_qualified_master_flush}_exported";

   my $master  = $this->_get_master($master_desc);

   $master->_arbitrator()->get_and_set_once_by_name({
      thing  => "signal",
      name   => $exported_qualified_master_flush,
      width  => 1,
      export => 1,
   });

   $master->_arbitrator()->get_and_set_once_by_name({
      thing  => "assign",
      name   => "The Exported Flushificator",
      lhs    => [$exported_qualified_master_flush => 1, 1],
      rhs    => $internal_qualified_master_flush,
   });

   return $exported_qualified_master_flush;
}



=item I<_make_qualified_flush_for_master()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _make_qualified_flush_for_master
{
   my $this = shift;
   my $master_desc = shift or &ribbit ("no master desc");

   my $master   = $this->_get_master($master_desc);
   my $master_flush =  $master->_get_exclusively_named_port_by_type("flush");

   return "" if $master_flush eq "";

   my $run = $this->_get_master_run($master_desc);
   &ribbit ("$master_desc has no waitrequest") if ($run == 1);

   my $qualified_master_flush =  "${master_flush}_qualified";

   my $d1_run = "${run}_delayed";
   $master->_arbitrator()->get_and_set_once_by_name({
      thing  => "register",
      name   => "run delay",
      d      => $run,
      q      => $d1_run,
      enable => 1,
   });

   $master->_arbitrator()->get_and_set_once_by_name({
      thing => "signal",
      name  => $qualified_master_flush,
      width => 1});

   $master->_arbitrator()->get_and_set_once_by_name({
      thing => "signal",
      name  => $d1_run,
      width => 1,
   });

   $master->_arbitrator()->get_and_set_once_by_name({
      thing  => "assign",
      name   => "The Flushificator",
      lhs    => $qualified_master_flush,
      rhs    => "$master_flush && $d1_run",
   });

   return $qualified_master_flush;
}



=item I<get_slaves_by_master_name_without_bridges()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_slaves_by_master_name_without_bridges
{
   my $this = shift;
   my ($module_name, @master_name_list) =
       $this->project()->_get_master_list_from_description_args (@_);

   my @my_little_slaves = ();


   foreach my $test_mod_name ($this->project()->get_all_module_section_names())
   {
      my $test_mod_ptf = $this->project()->get_module_ptf_by_name($test_mod_name);
      next unless $test_mod_ptf->{SYSTEM_BUILDER_INFO}{Is_Enabled};




      my @test_slave_name_list =
          $this->project()->get_slaves_by_module_name($test_mod_name);

      foreach my $master_name (@master_name_list)
      {
         foreach my $test_slave_name (@test_slave_name_list)
         {
            my $slave_SBI = $this->project()->SBI ("$test_mod_name/$test_slave_name");



            next if
        (!$slave_SBI->{MASTERED_BY}{"$module_name/$master_name"} ||
         $slave_SBI->{MASTERED_BY}{"$module_name/$master_name"}{ADAPTER_MASTER});


            my $bridge_master = $slave_SBI->{Bridges_To};
            if ($bridge_master)
            {
              my $bridge_master_desc = $test_mod_name
                . "/" . $bridge_master;
              my $bridge_master_object = $this->_get_master($bridge_master_desc);

              my $bridge_master_bus_type=
                $bridge_master_object->{SYSTEM_BUILDER_INFO}{Bus_Type};



              if ($bridge_master_bus_type =~ /avalon/i) {
                push (@my_little_slaves,
                     $this->project()->get_slaves_by_master_name($test_mod_name,
                                                      $bridge_master));
              }
            }
            else
            {

               push (@my_little_slaves, "$test_mod_name/$test_slave_name");
            }
         }
      }
   }
   return @my_little_slaves;

}


=item I<get_directly_connected_slaves_by_master_name()>

Get only the first-order slaves or adaptors going to slaves from this master.
will return the slave_ids of directly-connected bridges, adaptors, and slaves
without adaptors or bridges in between.

=cut

sub get_directly_connected_slaves_by_master_name 
{
   my $this = shift;
   my ($master_desc) = (@_);

   my $all_slaves_SBI = 
    $this->project()->get_module_slave_hash(
          ['SYSTEM_BUILDER_INFO', "MASTERED_BY", "$master_desc"]);



   my @return_list = ();
   foreach my $key (sort keys %$all_slaves_SBI) {
     next if (not defined($all_slaves_SBI->{$key}));  # skip if undefined
     next if $all_slaves_SBI->{$key}{'ADAPTER_MASTER'};
     push @return_list, $key;
   }

   return @return_list;
}



=item I<_slave_has_base_address()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _slave_has_base_address
{
   my $this = shift;
   my $slave_id = shift;
   my $slave;
   if ($slave_id)
   {
      $slave = $this->_get_slave($slave_id);
   }
   else
   {
      $slave = $this->_slave();
   }
   my $slave_SBI = $slave->{SYSTEM_BUILDER_INFO};
   my $bridges_to = $slave_SBI->{Bridges_To};
   my $return_this = (exists ($slave_SBI->{Has_Base_Address}))?
       $slave_SBI->{Has_Base_Address}:

           ($bridges_to)? 0:1;
   return $return_this;
}






















sub _do_we_have_enough_control_ports
{
  my $this    = shift;
  my $master  = shift or &ribbit ("no master_desc");
  my $checking_which_function = shift;
  &ribbit (
    "bad parameter '$checking_which_function' (must be 'read' or 'write')"
  ) unless (
    $checking_which_function eq "read" || $checking_which_function eq "write"
  );


  if (! ref ($master))
  {
    $master = $this->_get_master($master);
  }


  my $master_cs =
    $master->_get_exclusively_named_port_or_its_complement ("chipselect");
  my $master_read = 
    $master->_get_exclusively_named_port_or_its_complement ("read");
  my $master_write = 
    $master->_get_exclusively_named_port_or_its_complement ("write");
  my $master_r_wn = 
    $master->_get_exclusively_named_port_or_its_complement ("read_writen");
  my $master_readdata = 
    $master->_get_exclusively_named_port_or_its_complement ("readdata");
  my $master_writedata = 
    $master->_get_exclusively_named_port_or_its_complement ("writedata");
  my $master_data = 
    $master->_get_exclusively_named_port_or_its_complement ("data");
  my $have_data_bus = ($checking_which_function eq "read") ?
    ($master_readdata   || $master_data) :
    ($master_writedata  || $master_data) ;

  my $have_enough_control_ports =  $have_data_bus && (
    (($checking_which_function =~ /read/)  && $master_read)  ||
    (($checking_which_function =~ /write/) && $master_write) ||
    (($master_read || $master_write || $master_r_wn) && $master_cs)
  );
  
  return $have_enough_control_ports ? 1 : 0;
}

sub _do_we_have_enough_control_ports_to_read
{
  my $this = shift;
  return $this->_do_we_have_enough_control_ports(@_, "read");
}
sub _do_we_have_enough_control_ports_to_write
{
  my $this = shift;
  return $this->_do_we_have_enough_control_ports(@_, "write");
}



=item I<get_master_chipselect()>

Access method to get the equivalent master's Avalon chipselect signal.

This may or may NOT be the actual 'chipselect' pin that goes to the master.  If you
want that, you should be using $master->_get_exclusively_named_port_by_type('chipselect');

=cut

sub get_master_chip_select_logic
{
  my $this = shift;
  return $this->get_master_chipselect(@_);
}
sub get_master_chipselect
{
   my $this = shift;
   my $master = shift or &ribbit ("no master_desc");

   if (! ref ($master))
   {
      $master = $this->_get_master($master);
   }

   my $master_cs =
      $master->_get_exclusively_named_port_or_its_complement("chipselect");
   

   if (! $master_cs) {
      my $master_read = $this->get_master_read($master);
      my $master_write = $this->get_master_write($master);
      $master_cs = &or_array($master_read, $master_write);
   }

   return $master_cs ;
}




=item I<get_master_read()>

Access method to get the equivalent master's Avalon read signal.

This may or may NOT be the actual 'read' pin that goes to the master.  If you
want that, you should be using $master->_get_exclusively_named_port_by_type('read');

=cut

sub get_master_read
{
  my $this = shift;
  my $master = shift or &ribbit ("no master");
  my $get_port = shift || 0;   # screw those "async rules". get me the port.
  my $master_desc = $master->get_id();

  return "" unless $this->_do_we_have_enough_control_ports_to_read($master);

  my $master_read = $master->
     _get_exclusively_named_port_or_its_complement ("read");
  my $master_cs_pin = $master->
    _get_exclusively_named_port_or_its_complement ("chipselect");
  if ($master_read && $master_cs_pin) {
    $master_read = &and_array($master_read, $master_cs_pin);
  } 




  my $master_cs;  # we don't want to carelessly try to get chipselect if we




  if (! $master_read) {


    $master_cs = $this->get_master_chipselect ($master);
    my $master_r_wn = $this->get_master_read_writen ($master);
    if ($master_cs && $master_r_wn) {
      $master_read = &and_array($master_r_wn, $master_cs);
    }
  }

  if (! $master_read) {


    my $master_write = $this->get_master_write ($master);
    if ($master_cs && $master_write) {
      my $master_wn = &complement ($master_write);
      $master_read = &and_array($master_wn, $master_cs);
    }
  }

  my $master_SBI              = $master->{SYSTEM_BUILDER_INFO};
  my $master_uses_async_rules = $master_SBI->{Is_Asynchronous};
  if ($master_uses_async_rules && $master_read && ! $get_port) {






    my $async_read = $master_read;


    my $untristated_waitrequest_n = "untristated_waitrequest_n";
    my $async_wait =  "~$untristated_waitrequest_n";


    $master_read = $this->_make_signal("${master_desc}_Avalon_read");
    my $master_run  = $this->_get_master_run ($master_desc);
    my $master_arbitrator = $master->_arbitrator();
    e_signal->new([$master_read,1])->within($master_arbitrator);
    $master_arbitrator->get_and_set_once_by_name ({
        thing       => "register",
        name        => "$master_desc Avalon read signal",
        out         => e_signal->new ({
                name    => $master_read,
                width   => 1,
                export  => 1,
        }),

        sync_reset  => "$master_run && $master_read",



        sync_set    => "$async_read & $async_wait & ~($master_read)",
        priority    => "reset",           # of set/reset, reset is priority
        enable      => 1,
    });

    $this->sink_signals($master_read);
    
  }
  


  return $master_read;
}



=item I<get_master_write()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_master_write
{
  my $this = shift;
  my $master = shift or &ribbit ("no master");
  my $get_port = shift || 0;   # screw those "async rules". get me the port.
  my $master_desc = $master->get_id();

  return "" unless $this->_do_we_have_enough_control_ports_to_write($master);

  my $master_write = $master->
      _get_exclusively_named_port_or_its_complement("write");
  my $master_cs_pin = $master->
    _get_exclusively_named_port_or_its_complement ("chipselect");
  if ($master_write && $master_cs_pin) {
    $master_write = &and_array($master_write, $master_cs_pin);
  }




  my $master_cs;  # we don't want to carelessly try to get chipselect if we




  if (! $master_write) {


    $master_cs = $this->get_master_chipselect ($master);
    my $master_r_wn = $this->get_master_read_writen ($master);
    if ($master_cs && $master_r_wn) {
      $master_write = &and_array(&complement($master_r_wn), $master_cs);
    }
  }

  if (! $master_write) {


    my $master_read = $this->get_master_read ($master);
    if ($master_cs && $master_read) {
      my $master_rn = &complement ($master_read);
      $master_write = &and_array($master_rn, $master_cs);
    }
  }

  my $master_SBI              = $master->{SYSTEM_BUILDER_INFO};
  my $master_uses_async_rules = $master_SBI->{Is_Asynchronous};
  if ($master_uses_async_rules && $master_write && !($get_port) ) {






    my $async_write = $master_write;


    my $untristated_waitrequest_n = "untristated_waitrequest_n";
    my $async_wait =  "~$untristated_waitrequest_n";


    $master_write = $this->_make_signal("${master_desc}_Avalon_write");
    my $master_run  = $this->_get_master_run ($master_desc);
    my $master_arbitrator = $master->_arbitrator();
    e_signal->new([$master_write,1])->within($master_arbitrator);
    $master_arbitrator->get_and_set_once_by_name ({
        thing       => "register",
        name        => "$master_desc Avalon write signal",
        out         => e_signal->new ({
                name    => $master_write,
                width   => 1,
                export  => 1,
        }),

        sync_reset  => "$master_run && $master_write",




        sync_set    => "$async_write & $async_wait & ~($master_write)",
        priority    => "reset",           # of set/reset, reset is priority
        enable      => 1,
    });

    $this->sink_signals($master_write);
  }

  return $master_write;
}



=item I<get_master_read_or_write()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_master_read_or_write
{
   my $this = shift;
   my $master = shift or &ribbit ("no master");
   my $read_or_write = shift or &ribbit ("no row");

   if ($read_or_write =~ /read/i)
   {
      return $this->get_master_read($master);
   }
   else
   {
      return $this->get_master_write($master);
   }
}



=item I<get_master_read_writen()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut


sub get_master_read_writen
{
   my $this = shift;
   my $master = shift or &ribbit ("no master");
   my $master_r_wn = $master->
      _get_exclusively_named_port_or_its_complement ("read_writen");
   return $master_r_wn;
}



=item I<_master_reads_or_writes_slave()>


Checks to make sure both the slave and master can read or write (whichever you
ask of it).  
Doesn't actually check for interconnection.  Assumes if you're calling it, they
must be interconnected! 

=cut

sub _master_reads_or_writes_slave
{
   my $this = shift;
   my $master = shift or &ribbit ("no master");
   my $slave = shift or &ribbit ("no slave");
   my $row = shift or &ribbit ("no read_or_write");

   my $slave_can_row =
       $slave->_get_exclusively_named_port_or_its_complement($row."data")
       || $slave->_get_exclusively_named_port_or_its_complement("data");

   my $master_desc = $master->get_id();
   my $master_can_row = 
      $this->_do_we_have_enough_control_ports($master_desc, $row);

   return ($master_can_row && $slave_can_row);
}

my $master_run_index = 0;


=item I<_add_value_to_master_run()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _add_value_to_master_run
{
   my $this = shift;
   my $master_desc = shift or &ribbit ("no master_d");
   my $cascade_term = shift or &ribbit ("no cascade term");

   my $master_run = $this->_get_master_run($master_desc);
   &ribbit("Master '$master_desc' has no signal of type " .
           "'waitrequest' or 'waitrequest_n' yet must wait sometimes")
       if ($master_run == 1);

   my $master  = $this->_get_master($master_desc);


   my $tmp_master_run = "r_$master_run_index";

   my $cwa = $master->_arbitrator()->get_and_set_thing_by_name
       ({
          lhs      => [$tmp_master_run, 1],
          thing    => "assign",
          name     => "$tmp_master_run master_run cascaded wait assignment",
          no_lcell => $no_lcell,
          cascade  => [$cascade_term],
       });

   my @cascade = @{$cwa->cascade()};
   if (@cascade == 1)
   {


      $master->_arbitrator()->get_and_set_thing_by_name
          ({
             lhs      => $master_run,
             thing    => "assign",
             name     => "cascaded wait assignment",
             no_lcell => $no_lcell,
             cascade  => [$tmp_master_run],
          });
   }

   if (@cascade == 20)
   {
      $master_run_index++;
   }
}



=item I<_make_variable_readlatency_fifos()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut


sub _make_variable_readlatency_fifos
{
   my $this = shift;
   my $master = shift;

   my $slave_id = $this->_get_slave_id();
   my $master_desc = $master->get_id();
   my $slave_name = $slave_id;
   my $master_name = $master_desc;
   $slave_name =~ s/\//_/g;
   $master_name =~ s/\//_/g;

   my $depth = $this->_get_slave($slave_id)->{SYSTEM_BUILDER_INFO}
       ->{Maximum_Pending_Read_Transactions};

   my @slave_starts_reading =
       ('in_a_read_cycle',#$this->_get_slave_in_a_cycle($slave_id, 'read'),
        &complement($this->get_slave_wait
                    ("read", $slave_id)),
        );

   my $master_granted_slave = $this->_get_master_grant_signal_name
       ($master->get_id(),$slave_id);

   my $slave_rdv = $this->_get_slave($slave_id)->
       _get_exclusively_named_port_or_its_complement('readdatavalid');

   my ($move_on_to_next_transaction, $qualified_flush_signal_for_master)  
                   = $this->_make_burstcount_fifos_if_needed($master, 
                                                             $slave_rdv,
                                                             $master_granted_slave,
                                                             $depth,
							     @slave_starts_reading);
   my $fifo_out = $this->get_rdv_fifo_out_name ($master_desc,$slave_id);
   $this->sink_signals($fifo_out);
   $this->get_and_set_once_by_name({
       thing => 'fifo_with_registered_outputs',
       name  => "rdv_fifo_for_$master_name\_to_$slave_name",
       depth => $depth,
       port_map => {
           data_in => $master_granted_slave,
           data_out => $fifo_out,
           write => &and_array(@slave_starts_reading),
           empty => 'open', 
           full => 'open',
           clear_fifo => "1'b0",
           fifo_contains_ones_n => $this->get_rdv_fifo_empty($master_desc,$slave_id),
           read => $move_on_to_next_transaction,
           sync_reset => $qualified_flush_signal_for_master,
       },
   });
}

sub _get_move_on_to_next_transaction
{
  my $this = shift;
  my $slave_id = shift;
  my $signal_name = $this->_make_signal("$slave_id/move_on_to_next_transaction");
  my $thing_name = "unique name for " . $signal_name;
  return ($signal_name, $thing_name);
}

sub _make_burstcount_fifos_if_needed
{
   my $this = shift;
   my $master = shift;
   my $slave_rdv = shift;
   my $master_granted_slave = shift;
   my $depth = shift;
   my @slave_starts_reading = @_;

   my $slave_id = $this->_get_slave_id();
   my $master_desc = $master->get_id();
   my $slave_name = $slave_id;
   my $master_name = $master_desc;
   $slave_name =~ s/\//_/g;
   $master_name =~ s/\//_/g;

   my ($move_on_to_next_transaction, $move_on_to_next_transaction_name) =
     $this->_get_move_on_to_next_transaction($slave_id);




   $this->get_and_set_once_by_name({
       thing => 'assign',
       name => $move_on_to_next_transaction_name,
       lhs => $move_on_to_next_transaction,
       rhs => $slave_rdv
   });
   my $qualified_flush_signal_for_master = 
                  $this->_make_and_export_qualified_flush_for_master($master_desc);

   $qualified_flush_signal_for_master = "1'b0" if $qualified_flush_signal_for_master eq "";

   if ($this->get_master_max_burst_size($master) > 1)
   {
       my $master_burstcount = $this->get_master_burstcount_port($master);

       my $dbs_shift =
            $this->_how_many_bits_of_dynamic_bus_size_are_needed($master_desc,$slave_id); 
       
       my $selected_burstcount = "$slave_name\_selected_burstcount";
       $this->get_and_set_thing_by_name({
               thing => 'mux',
	       name => "the currently selected burstcount for $slave_name",
	       lhs => $selected_burstcount,
	       add_table => [$master_granted_slave, $master_burstcount],


               default => 1,
	   });
       
       my $this_cycle_is_the_last_burst = "$slave_name\_this_cycle_is_the_last_burst";
       my $transaction_burst_count = "$slave_name\_transaction_burst_count";
       my $burstcount_fifo_empty = "$slave_name\_burstcount_fifo_empty";



       my $load_fifo = "$slave_name\_load_fifo";
       my $p0_load_fifo = "p0_" . $load_fifo;

       $this->get_and_set_once_by_name({
	   thing => 'fifo_with_registered_outputs',
           name  => "burstcount_fifo_for_$slave_name",
           depth => $depth,
           port_map => {
               data_in => $selected_burstcount,
               data_out => $transaction_burst_count,




               write => &and_array(@slave_starts_reading, $load_fifo,
                 complement(and_array($this_cycle_is_the_last_burst, $burstcount_fifo_empty))
               ),
               empty => $burstcount_fifo_empty,
               fifo_contains_ones_n => 'open',
               full => 'open',
               clear_fifo => "1'b0",
               read => $this_cycle_is_the_last_burst,
               sync_reset => "1'b0",
           },
       });

       my $max_burst_size = $master->{SYSTEM_BUILDER_INFO}->{Maximum_Burst_Size};
       my $master_burstcount_width = Bits_To_Encode($max_burst_size);                   









       my $current_burst_width = max(0, $dbs_shift) + $master_burstcount_width;

       my $current_burst = "$slave_name\_current_burst";
       e_signal->new({ name => $current_burst, width => $current_burst_width})
               ->within($this);

       my $current_burst_minus_one = "$slave_name\_current_burst_minus_one";
 
       $this->get_and_set_once_by_name({
	   thing => 'assign',
           name => "$slave_name current burst minus one",
           lhs => $current_burst_minus_one,
           rhs => "$current_burst - 1"
       });

       my $transaction_burst_count_after_dbs = $transaction_burst_count;                
       my $selected_burstcount_after_dbs = $selected_burstcount;                        
       if($dbs_shift > 0) # Only for positive DBS. Negative DBS should be all right.    
       {                                                                                
           $transaction_burst_count_after_dbs = "{$transaction_burst_count,  $dbs_shift\'b0}";
           $selected_burstcount_after_dbs = "{$selected_burstcount, $dbs_shift\'b0}";   
       }                                                                                

       my $next_burst_count = "$slave_name\_next_burst_count";
       $this->get_and_set_once_by_name({
	   thing => 'mux',
           name => "what to load in current_burst, for $slave_name",
           lhs => $next_burst_count,
           add_table =>
             [ &and_array(@slave_starts_reading) . " & ~$load_fifo",
                      => $selected_burstcount_after_dbs,



			 &and_array(@slave_starts_reading, $this_cycle_is_the_last_burst, $burstcount_fifo_empty)
			     => $selected_burstcount_after_dbs,
                         $this_cycle_is_the_last_burst => $transaction_burst_count_after_dbs,
                      ],
           default => $current_burst_minus_one,
       });

       $this->get_and_set_once_by_name({
	   thing => 'register',
           name => "the current burst count for $slave_name, to be decremented", 
           in  => $next_burst_count,
           out => $current_burst,
           enable => "$slave_rdv | (~$load_fifo & " . 
                                                  &and_array(@slave_starts_reading) . ")",
       });

       $this->get_and_set_once_by_name({
           thing => 'mux',
           name => 'a 1 or burstcount fifo empty, to initialize the counter',
           add_table =>
                      [
                        "~$load_fifo" => 1,
                        and_array(@slave_starts_reading) . " & $load_fifo" => 1, 


                      ],
           default => "~$burstcount_fifo_empty",
           out => $p0_load_fifo,
       });
 
       $this->get_and_set_once_by_name({
           thing => 'register',
           name => "whether to load directly to the counter or to the fifo",
           in => $p0_load_fifo,
           out => $load_fifo,
           enable => &and_array(@slave_starts_reading) . " & ~$load_fifo | $this_cycle_is_the_last_burst", 
       });

      
       $this->get_and_set_once_by_name({
	   thing => 'assign',
	   name => "the last cycle in the burst for $slave_name",
           lhs => "$this_cycle_is_the_last_burst",
           rhs => "~(|$current_burst_minus_one) & $slave_rdv"
       });

       e_width_conduit->new([
                        $current_burst,
                        $current_burst_minus_one,
                        $transaction_burst_count
			     ])->within($this);

       $this->get_and_set_thing_by_name({
          thing => 'assign',
          name => $move_on_to_next_transaction_name,
          lhs => $move_on_to_next_transaction,
          rhs =>
            "$this_cycle_is_the_last_burst & $load_fifo",
       });
   }
   return ($move_on_to_next_transaction, $qualified_flush_signal_for_master);
}

sub get_rdv_fifo_out_name
{
    my $this = shift;
    my $master_desc = shift;
    my $slave_id = shift;
    return $this->_get_generic_master_slave_signal_name
        ($master_desc, 'rdv_fifo_output_from', $slave_id);
}

sub get_rdv_fifo_empty
{
    my $this = shift;
    my $master_desc = shift;
    my $slave_id = shift;
    return $this->_get_generic_master_slave_signal_name
        ($master_desc, 'rdv_fifo_empty', $slave_id);
}



=item I<_sink_signal_in_master_arbitrator()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _sink_signal_in_master_arbitrator
{
   my $this = shift;
   my $signal = shift;
   my $master_desc = shift;
   my $master = $this->_get_master($master_desc);
   $master->_arbitrator()->sink_signals($signal);
}



=item I<_get_variable_read_latency()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_variable_read_latency
{
   my $this = shift;

   my $slave_id = shift;
   my $simon_says = shift;
   if (!$simon_says)
   {

   }

   my $slave_from_slave_id = $this->_get_slave($slave_id);
   my $this_slave = $this->_slave();

   my $variable_read_latency = $slave_from_slave_id->{SYSTEM_BUILDER_INFO}
   {Maximum_Pending_Read_Transactions};

   if ($variable_read_latency)
   {
      ($slave_from_slave_id->_get_exclusively_named_port_or_its_complement
       ("readdatavalid")) ||
          &ribbit ("SLAVE $slave_id, has ".
                   "Maximum_Pending_Read_Transactions ".
                   "but no readdatavalid pin");
      return $variable_read_latency;
   }
   else
   {
      return 0;
   }
}



=item I<is_burst_master()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub is_burst_master
{
  my $this = shift;
  my $master = shift;

  if (!ref($master))
  {


    $master = $this->_get_master($master);
  }




  my $arb_share_port = $this->get_master_arbitrationshare_port($master);
  return 1 if $arb_share_port;
  


  my $max_burst_size = $master->{SYSTEM_BUILDER_INFO}->{Maximum_Burst_Size};

  return ($max_burst_size eq '') || ($max_burst_size <= 1) ? 0 : 1;
}



=item I<is_burst_slave()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub is_burst_slave
{
  my $this = shift;
  my $slave = shift;

  if (!ref($slave))
  {


    $slave = $this->_get_slave($slave);
  }
  
  my $max_burst_size = $slave->{SYSTEM_BUILDER_INFO}->{Maximum_Burst_Size};

  return ($max_burst_size eq '') || ($max_burst_size <= 1) ? 0 : 1;
}



=item I<get_slave_byteenable()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_slave_byteenable
{
   my $this = shift;
   my $slave = shift;


   my $return = $slave->_get_exclusively_named_port_or_its_complement("byteenable");

   my $slave_id = $slave->get_id();
   my $slave_data_width  = $this->_get_slave_data_width($slave_id);
   my $num_be_bits       = int ($slave_data_width / 8);
   if ($return) {


      e_signal->new ([$return, $num_be_bits, 0, 0, 1])->within ($this);
   } else {


      $return = $this->_get_pretend_byte_enable($slave);
      e_signal->new ([$return, $num_be_bits, 0, 1, 1])->within ($this);
   }
   return $return;
}



=item I<get_slave_writebyteenable()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_slave_writebyteenable
{
   my $this = shift;
   return $this->get_slave_or_adapter_port_of_type
       (@_,"writebyteenable");
}



=item I<get_master_writedata_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_master_writedata_port
{
   my $this = shift;
   my $master = shift;
   my $master_writedata = 
      $master->_get_exclusively_named_port_by_type("writedata");
   my $master_data =
      $master->_get_exclusively_named_port_by_type("data");


   my $master_can_write = $master_writedata || $master_data;
   return unless $master_can_write;

   if (! $master_writedata)
   {

      my $master_SBI        = $master->{SYSTEM_BUILDER_INFO};
      my $master_data_width = $master_SBI->{Data_Width};
      my $master_write      = $this->get_master_write($master);



      $master_write or return;

      $master_writedata = "incoming_$master_data";


      e_signal->new({
        name      => $master_data,
        width     => $master_data_width,
        _is_inout => 1,
        copied    => 1,
      })->within($master->_arbitrator());

      e_signal->new({
        name      => $master_writedata,
        width     => $master_data_width,
        export    => 1,
        copied    => 1,
      })->within($master->_arbitrator());



      $this->sink_signals($master_writedata);

      if ($master->{SYSTEM_BUILDER_INFO}
          {Register_Incoming_Signals})
      {




        &ribbit ("master ".$master->name().". Registered_Incoming_Signals not supported for external masters.");

      } else {
        $master->_arbitrator()->get_and_set_once_by_name({
            thing  => "assign",
            name   => "$master_writedata assignment",
            lhs    => $master_writedata,
            rhs    => $master_data,
        });
      }
   }

   return $master_writedata;
}






=item I<get_master_readdata_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_master_readdata_port
{
   my $this = shift;
   my $master = shift;


   my $master_can_read = $this->_do_we_have_enough_control_ports_to_read($master);
   return unless $master_can_read;

   my $master_readdata = 
        $master->_get_exclusively_named_port_by_type("readdata");
   my $master_data = 
        $master->_get_exclusively_named_port_by_type("data");
   my $master_read = $this->get_master_read($master);
   my $master_SBI  = $master->{SYSTEM_BUILDER_INFO};
   my $master_data_width = $master_SBI->{Data_Width};

   if ($master_readdata)
   {

      $master->_arbitrator()->get_and_set_once_by_name
          ({
              thing => 'export',
              name  => "$master_readdata export",
              expression => $master_readdata,
          });
   } else {




      $master_read or return;

      $master_readdata = "outgoing_$master_data";


      e_signal->new({
        name      => $master_data,
        width     => $master_data_width,
        _is_inout => 1,
        copied    => 1,
      })->within($master->_arbitrator());

      e_signal->new({
        name      => $master_readdata,
        width     => $master_data_width,
        copied    => 1,
      })->within($master->_arbitrator());



      my $drive_bus;
      my $master_oe = 
        $master->_get_exclusively_named_port_or_its_complement('outputenable');
      if ($master_oe) {
        $drive_bus = $master_oe;
      } else {
        $drive_bus = $master_read;
      }

      $master->_arbitrator()->get_and_set_once_by_name({
        thing  => "assign",
        name   => "$master_data tristate assignment",
        lhs    => $master_data,
        rhs    => 
          "($drive_bus) ?  $master_readdata : 
                           {$master_data_width {1\'bz}}",
      });
   }


   if ($master->{SYSTEM_BUILDER_INFO}{Register_Outgoing_Signals})
   {


      my $p1 = "p1_".$master_readdata;
      $master->_arbitrator()->get_and_set_once_by_name({
          thing  => "register",
          name   => "$master_readdata register",
          out    => $master_readdata,
          in     => $p1,
          enable => $master_read, # didn't put "master wait" in logic, because


          fast_out => 1
      });


      e_signal->new({
        name      => $p1,
        width     => $master_data_width,
        copied    => 1,
      })->within($master->_arbitrator());
      my $master_desc = $master->get_id();


      $master->_arbitrator()->get_and_set_once_by_name ({
          thing => "mux",


          name  => "$master_desc readdata mux",
          lhs   => $p1,
          add_table => ["1'b0","$master_data_width\'b1"],
      });

      $master_readdata = $p1;
   }

   return $master_readdata;
}



=item I<get_master_readdatavalid()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_master_readdatavalid
{
   my $this = shift;
   my $master = shift;

   my $port = $master->_get_exclusively_named_port_by_type("readdatavalid");
   if ($port)
   {
      $master->_arbitrator()->get_and_set_once_by_name
          ({
             thing => 'export',
             name  => "$port export",
             expression => $port,
          });
   }
   return $port;
}




=item I<get_slave_or_adapter_port_of_type()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_slave_or_adapter_port_of_type
{
   my $this = shift;
   my $slave = shift || &ribbit ("no slave");
   my $type  = shift;

   return $slave->_get_exclusively_named_port_by_type($type);
}



=item I<get_slave_read_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_slave_read_port
{
   my $this = shift;
   return $this->get_slave_or_adapter_port_of_type(@_,"read");
}



=item I<get_slave_burstcount()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_slave_burstcount
{
   my $this = shift;
   return $this->get_slave_or_adapter_port_of_type(@_,"burstcount");
}



=item I<get_slave_writedata_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_slave_writedata_port
{
   my $this = shift;
   my $slave = shift;
   my $port = $this->get_slave_or_adapter_port_of_type($slave,"writedata");
   if ($port)
   {
      $this->get_and_set_once_by_name
          ({
             thing => 'export',
             name  => "$port export",
             expression => $port,
          });
   }
   return $port;
}



=item I<get_slave_readdata_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_slave_readdata_port
{
   my $this = shift;
   my $slave = shift;
   

   my $slave_can_read = $slave->_get_exclusively_named_port_by_type("readdata") ||
     $slave->_get_exclusively_named_port_by_type("data");
    
   return unless $slave_can_read;


   
   my $slave_readdata =
      $slave->_get_exclusively_named_port_by_type("readdata");

   if (!$slave_readdata)
   {

      my $slave_data =
          $slave->_get_exclusively_named_port_by_type("data");
      my $slave_SBI        = $slave->{SYSTEM_BUILDER_INFO};
      my $slave_data_width = $slave_SBI->{Data_Width};
      
      if ($slave_data)
      {
         e_signal->new({
            name      => $slave_data,
            width     => $slave_data_width,
            _is_inout => 1,
            copied    => 1,
         })->within($this);

         $slave_readdata = "incoming_$slave_data";

         if ($this->_slave->{SYSTEM_BUILDER_INFO}
             {Register_Incoming_Signals})
         {
            $this->get_and_set_once_by_name({
               thing  => "register",
               name   => "$slave_data register",
               out    => $slave_readdata,
               in     => $slave_data,
               enable => 1,
               fast_in => 1
            });
         }
         else
         {
            $this->get_and_set_once_by_name({
               thing  => "assign",
               name   => "$slave_data assignment",
               lhs    => $slave_readdata,
               rhs    => $slave_data,
            });
         }
      }
   }

   return $slave_readdata;
}



=item I<get_slave_address_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_slave_address_port
{
   my $this = shift;
   return $this->get_slave_or_adapter_port_of_type(@_,"address");
}



=item I<get_master_address_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_master_address_port
{
  my $this = shift;
  my $master = shift;

  my $master_address =
    $master->_get_exclusively_named_port_by_type("byteaddress") ||
    $master->_get_exclusively_named_port_by_type("address");

  return $master_address;
}



=item I<get_slave_byteaddress_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_slave_byteaddress_port
{
   my $this = shift;
   return $this->get_slave_or_adapter_port_of_type(@_,"byteaddress");
}



=item I<get_slave_readdatavalid_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_slave_readdatavalid_port
{
   my $this = shift;
   return $this->get_slave_or_adapter_port_of_type(@_,"readdatavalid");
}


=item I<get_read_data_valid_signal_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_read_data_valid_signal_name
{
   my $this = shift;
   my $master_d = shift;
   my $slave_id = shift;

   my $port = $this->_get_read_data_valid_signal_name($master_d,
                                                        $slave_id);
   if ($port)
   {
      $this->get_and_set_once_by_name
          ({
             thing => 'export',
             name  => "$port export",
             expression => $port,
          });
      my $master_arb = $this->_get_master($master_d)->_arbitrator();
      $master_arb->sink_signals($port);
   }
   return $port;
}



=item I<get_read_latency()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_read_latency
{
   my $this = shift;
   my $slave_id = shift;
   return $this->_get_read_latency($slave_id,1);
}



=item I<get_variable_read_latency()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_variable_read_latency
{
   my $this = shift;
   my $slave_id = shift;

   return $this->_get_variable_read_latency($slave_id,1);
}



=item I<get_slave_wait()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_slave_wait
{
   my $this = shift;
   my $read_or_write = shift or &ribbit ("no rw");
   my $slave_id = shift or &ribbit ("no slave_id");
   return $this->_get_slave_wait($read_or_write, $slave_id);
}



=item I<get_arbitration_section()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_arbitration_section
{
   my $this = shift;
   my $master_desc = shift || &ribbit ("no md");

   my $slave       = $this->_slave();
   my $slave_id = $this->_get_slave_id();
   my $Mastered_By = $slave->{SYSTEM_BUILDER_INFO}{MASTERED_BY};

   my $return = $Mastered_By->{$master_desc} || {};
   if (!$return->{priority})
   {
      foreach my $key (keys (%{$Mastered_By}))
      {
         my $value = $Mastered_By->{$key};
         my $Adapter_Master = $value->{ADAPTER_MASTER};
         if ($Adapter_Master eq $master_desc)
         {
            $return = $value;
            last;
         }
      }
   }

   if ($return)
   {
      return $return;
   }
   else
   {
      return {};
   }
}



=item I<_get_slave_aligned_shift()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_slave_aligned_shift
{
   my $this        = shift;
   my $slave_desc = shift or &ribbit ("No slave-desc");
   my $alignment =
       $this->_get_slave($slave_desc)->{SYSTEM_BUILDER_INFO}
   {Address_Alignment};


   if ($alignment =~ /^\d+$/)
   {
      return &log2($alignment);
   }
   else
   {
      return &log2($this->_get_slave_data_width($slave_desc) / 8);
   }
}



=item I<_display_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _display_signals
{
   my $this  = shift;
   my $slave_id = shift;
   my $type_of_transaction = shift;
   my $read_or_write = shift;
   my $port_types = shift;
   my $pending_string = shift;
   my $file_handle = shift;

   my $slave = $this->_get_slave($slave_id);
   my $READ_OR_WRITE = uc($read_or_write);
   my @string = ("$slave_id $type_of_transaction");
   my @variables;

   foreach my $type (@$port_types)
   {
      my $slave_port =
          $slave->_get_exclusively_named_port_by_type($type);
      if ($slave_port)
      {
         push (@string ,"$type := 0x%X");
         push (@variables, $slave_port);
      }
   }

   my $output_string = join (', ',@string);

   if ($pending_string ne '')
   {
      $pending_string = $pending_string.'\n';
   }
   $output_string .= '\n';
   $this->get_and_set_once_by_name
       ({thing => 'process',
         name  => "$slave_id $type_of_transaction monitor",
         tag   => 'simulation',
         contents => 
             [e_if->new
              ({condition => $this->_get_slave_in_a_cycle($slave_id,$read_or_write),
                then => [e_if->new
                    ({condition => $this->_make_begin_xfer(),
                      then      => [e_sim_write->new
                          ({spec_string => $output_string,
                            expressions => \@variables,
                            show_time   => 1,
                            file_handle => $file_handle,
                         })],
                          else      => ($pending_string ne '')? 
                          [e_sim_write->new({spec_string => $pending_string,
                                            file_handle => $file_handle,
                                         })]:[],
                       })]
                    }),
              ],
                    });
}



=item I<log_transactions()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub log_transactions
{
   my $this = shift;
   my $slave_id = shift;

   my $slave = $this->_get_slave($slave_id);

   my $log_transactions = $slave->{SYSTEM_BUILDER_INFO}{Log_Transactions};

   my $file_handle;
   my $file_name;
   if ($log_transactions =~ /^([A-Za-z_](\w|\.)*)$/)
   {
      $file_name = $log_transactions;
      $file_handle = $this->_make_signal($slave_id.'/LOGFILE');
      $this->get_and_set_once_by_name
          ({
             thing => 'sim_fopen',
             name  => "$file_handle log to file",
             file_name => $file_name,
             file_handle => $file_handle,
          })
   }

   if ($log_transactions)
   {
      my @variables;
      my $address_string;

      if ($slave->_get_exclusively_named_port_by_type('writedata'))
      {
         $this->_display_signals(
                                 $slave_id,
                                 'WRITE',
                                 'write',
                                 ['address', 'writedata', 'burstcount'],
                                 '.',
                                 $file_handle);
      }

      if ($slave->_get_exclusively_named_port_by_type('readdata'))
      {
         my @display_signals = qw (flush address burstcount);
         my $pending = '';
         my $latency_enable;
         if ($this->get_read_latency($slave_id))
         {
            $latency_enable = &or_array
                (map {
                   $this->get_read_data_valid_signal_name
                       ($_, $slave_id)
                    } $this->_get_master_descs());
         }
         elsif ($this->get_variable_read_latency($slave_id))
         {
            $latency_enable = $slave->_get_exclusively_named_port_by_type('readdatavalid');
         }
         else
         {
            push (@display_signals, 'readdata');
            $pending = '.';
         }

         $this->_display_signals($slave_id,
                                 'READ',
                                 'read',
                                 \@display_signals,
                                 $pending,
                                 $file_handle
                                 );

         if ($latency_enable)
         {
            $this->get_and_set_once_by_name
                ({thing => 'process',
                  name  => "$slave_id read latency monitor",
                  tag   => 'simulation',
                  contents => 
                      [e_if->new
                       ({condition => $latency_enable,
                         then => [e_sim_write->new
                                  ({spec_string => "    $slave_id returns 0x%X.\\n",
                                    expressions =>
                                        [$this->_get_exclusively_named_port_by_type
                                         ('readdata')],
                                        show_time   => 1,
                                        file_handle => $file_handle,
                                     }),
                                  ]
                               }),
                       ],
                });
         }
      }
   }
}


sub _get_port_width_by_type
{
  my $this = shift;
  my $m_or_s = shift;
  my $type = shift;

  my $width = 1; # default

  my $port_name = 
    $m_or_s->_get_exclusively_named_port_or_its_complement($type);
  $port_name =~ s/^~//;
  my $sig = $m_or_s->_arbitrator()->get_signal_by_name($port_name);

  if ($sig)
  {
    $width = $sig->width();
  }

  return $width;
}



=item I<_heed_wait_assertion()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _heed_wait_assertion
{
   my $this = shift;
   my $master_desc = shift;

   my $master = $this->_get_master($master_desc);


   my $registered_wait =
       $master->{SYSTEM_BUILDER_INFO}{Register_Incoming_Signals};

   return if ($registered_wait);





   my $master_SBI        = $master->{SYSTEM_BUILDER_INFO};
   my $master_uses_async_rules = $master_SBI->{Is_Asynchronous};
   return if ($master_uses_async_rules);

   my $is_active = $this->get_master_chip_select_logic($master_desc);

   my $waiting = $master->_get_exclusively_named_port_by_type('waitrequest');
   foreach my $control_signal qw (address
                                  chipselect
                                  burstcount
                                  byteenable
                                  read
                                  write
                                  writedata
                                  )
   {
      my $port_name = $master->_get_exclusively_named_port_or_its_complement
          ($control_signal);

      next unless ($port_name);


      my $last_port = "${port_name}_last_time";
      my $last_port_width = $this->_get_port_width_by_type($master, $control_signal);

      $master->_arbitrator()->get_and_set_once_by_name
          ({
             thing  => 'register',
             name   => "$port_name check against wait",
             out    => {name => $last_port, width => $last_port_width,},
             in     => $port_name,
             enable => 1,
             tag    => 'simulation',
          });

      $master->_arbitrator()->get_and_set_once_by_name
          ({
             thing  => 'register',
             name   => "$master_desc waited last time",
             out    => "active_and_waiting_last_time",
             in     => &and_array($waiting,$is_active),
             enable => 1,
             tag    => 'simulation',
          });

      my $condition = "active_and_waiting_last_time & ".
          "($port_name != $last_port)";


      if ($control_signal eq 'writedata')
      {
        my $write = $this->get_master_write($master);
        if ($write)
        {
          $condition .= " & $write";
        }
      }
      
      my $then = [
                  e_sim_write->new({show_time => 1,
                                    spec_string =>
                                        "$port_name did not heed wait!!!"}),
                  e_stop->new(),
                  ];

      $master->_arbitrator()->get_and_set_once_by_name
          ({
             thing => 'process',
             name  => "$port_name matches last port_name",
             contents => [e_if->new({condition => $condition,
                                     then => $then,
                                  })],
             tag    => 'simulation',
          });
   }
}



=item I<_nonzero_assertions()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _nonzero_assertions
{
  my $this = shift;
  my $master_desc = shift;
  my $slave_id = shift;

  my $master = $this->_get_master($master_desc);

  my $enable_assertions = "enable_nonzero_assertions";
  $this->get_and_set_once_by_name({
    tag => 'simulation',
    name => "$slave_id enable non-zero assertions",
    thing => 'register',
    out => {name => $enable_assertions, never_export => 1,},
    enable => 1,
    async_value => 0,
    in => "1'b1",
  });
    
  my %ports = (
    burstcount => $this->get_master_burstcount_port($master),
    arbitrationshare => $this->get_master_arbitrationshare_port($master)
  );
  
  my $master_request =
    $this->_get_master_request_signal_name
    ($master_desc, $slave_id);

  for my $port (keys %ports)
  {
    my $signal = $ports{$port};
    next if !$signal;

    my $condition = "$master_request && ($signal == 0)";
    $condition .= " && $enable_assertions";
    my $then = [
      e_sim_write->new({
        show_time => 1,
        spec_string => "$master_desc drove 0 on its '$port' port while accessing slave $slave_id",
      }),
      e_stop->new(),
    ];

    $this->get_and_set_once_by_name({
      thing => 'process',
      name => "$master_desc non-zero $port assertion",

      contents => [
        e_if->new({
          condition => $condition,
          then => $then,
        }),
      ],
      tag => 'simulation',
    });
  }
}



=item I<get_master_burstcount_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_master_burstcount_port
{
   my $this = shift;
   my $master = shift;
   return $master->_get_exclusively_named_port_or_its_complement('burstcount');
}



=item I<get_master_arbitrationshare_port()>

'arbitrationshare' is used to inform arbitrator logic how 
many shares a master gets of a given slave.  This is distinct
from the master's burstcount port (if any).

=cut

sub get_master_arbitrationshare_port
{
   my $this = shift;
   my $master = shift;
   return $master->_get_exclusively_named_port_or_its_complement('arbitrationshare');
}



=item I<get_master_max_burst_size()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_master_max_burst_size
{
   my $this = shift;
   my $master = shift;
   
   my $Maximum_Burst =
       $master->{SYSTEM_BUILDER_INFO}{Maximum_Burst_Size} || 1;

   my $log2 = &log2($Maximum_Burst);
   if (($Maximum_Burst > 2) && 
       ( $log2 != int ($log2))
       )
   {
      my $master_desc = $master->get_id();
      &ribbit(
              "$master_desc Maximum_Burst_Size must be power of 2 ".
              "not $Maximum_Burst\n");
   }
   return $Maximum_Burst;
}



=item I<get_begin_bursttransfer_signal()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_begin_bursttransfer_signal
{
   my $this = shift;
   my $slave_id = shift;

   return $this->_make_signal("$slave_id/beginbursttransfer/internal");
}



=item I<get_arbitration_holdoff()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_arbitration_holdoff
{
   my $this = shift;
   my $slave_id = shift;

   return $this->_make_signal("$slave_id/arbitration_holdoff/internal");
}


=item I<master_is_adapter>

Returns true if $master_desc is an adapter'.

=cut

sub master_is_adapter
{
   my $this = shift;
   my $master_desc = shift;

   my $master = $this->_get_master($master_desc);
   my $module = $master->parent();
   return $module->is_adapter();
}



=item I<master_is_adapter>

Returns true if $master_desc is an adapter which connects to
    $slave_id.
This is useful across tri-state bridges.

=cut

sub master_adapts_to
{
   my $this = shift;
   my $master_desc = shift;
   my $slave_id = shift;

   my $master = $this->_get_master($master_desc);
   my $module = $master->parent();


   my $adapts_to = $master->{SYSTEM_BUILDER_INFO}->{Adapts_To};
   return $module->is_adapter() &&
       (!$adapts_to || ($adapts_to eq $slave_id));
}

=item I<is_single_master_to_single_slave_connection>

In many cases it's interesting to know if a master masters only
one slave.  This routine answers the question.

Trivia: if a master's only slave is a tristate bridge, and there are
multiple tristate slaves beyond that bridge, this routine returns 0. If
there is only a single tristate slave beyond the bridge, this routine returns
1.

Return value: 1 if this slave has only one master, and that master
has only one slave.  Otherwise, false ('').

=cut

sub is_single_master_to_single_slave_connection
{
  my $this = shift;
  my @mbs = $this->_get_master_descs();

  my $ret = (@mbs == 1);
  if ($ret)
  {
    my $master_desc = $mbs[0];
    my @slaves = $this->project()->get_slaves_by_master_name($master_desc);
    $ret = (@slaves == 1);
  }

  return $ret;
}

=back

=cut

=head1 EXAMPLE

Here is a usage example ...

=head1 AUTHOR

Santa Cruz Technology Center

=head1 BUGS AND LIMITATIONS

list them here ...

=head1 SEE ALSO

The base class e_ptf_arbitration_module

=begin html

<A HREF="e_ptf_arbitration_module.html">e_ptf_arbitration_module webpage</A>

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;




