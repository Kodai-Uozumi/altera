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

s_ahb_master_arbitration_module - description of the module goes here ...

=head1 SYNOPSIS

The s_ahb_master_arbitration_module class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package s_ahb_master_arbitration_module;

use e_ptf_master_arbitration_module;
@ISA = ("e_ptf_master_arbitration_module");
use strict;
use europa_utils;
use e_mux;






my %fields   = (
    irq_number_hash   => {},
);
my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );









=item I<add_irq()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_irq
{
   my $this = shift;
   my $slave_id = shift or &ribbit ("no slave id");
   my $irq_port   = shift or &ribbit ("No irq port");
   my $irq_number = shift;
   if ($irq_number eq ''){&ribbit ("No irq number");}

   my $master = $this->_master_or_slave()
      or &ribbit ("Unable to find master associated with ".$this->name());
   my $master_desc = $master->get_id();



   my $master_irq_arbitration_scheme = 
      $master->{SYSTEM_BUILDER_INFO}->{Irq_Scheme} ;
   if ($master_irq_arbitration_scheme eq "") {


      $master_irq_arbitration_scheme = "individual_requests";
   }

   if ($master_irq_arbitration_scheme 
                  =~ /individual_requests/i) {
      $this->add_irq_to_irq_bus ($slave_id, $irq_port, $irq_number);
   } elsif ($master_irq_arbitration_scheme 
                  =~ /priority_code$/i) {
      &ribbit ("$master_irq_arbitration_scheme not yet implemented");
   } elsif ($master_irq_arbitration_scheme 
                  =~ /Five_bit_priority_code_and_1_individual/i) {
      &ribbit ("$master_irq_arbitration_scheme not yet implemented");
   } else {
      &ribbit ("Unrecognized master irq arbitration scheme");
   }

   return;
}








=item I<add_irq_to_irq_bus()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_irq_to_irq_bus
{
   my $this = shift;
   my $slave_id = shift   or &ribbit ("no slave id");
   my $irq_port   = shift or &ribbit ("No irq port");
   my $irq_number = shift;
   if ($irq_number eq ''){&ribbit ("No irq number");}


   
   my $master_arbitrator = $this;
   my $master = $this->_master_or_slave()
      or &ribbit ("Unable to find master associated with ".$this->name());
   my $master_desc = $master->get_id();
   my $master_irq =
       $master->_get_exclusively_named_port_by_type("irq")
           or return;

   my ($master_irq_sig,$negate_port) = 
       $master->_get_port_or_its_complement ("irq");

   if (!$master_irq_sig)
   {
      return;
   }
   
   my $master_irq_map = $master->{SYSTEM_BUILDER_INFO}{IRQ_MAP};
   my $irq_hash = $this->irq_number_hash();
   if (scalar(keys(%$irq_hash)) == 0) {

      if ($master_irq_map)
      {
        $irq_hash = $master_irq_map;
        foreach my $key (sort (keys (%$irq_hash))) {
          $irq_hash->{$key} =~ s/^N\/C$/1\'b0/;
        }

      } else {



      }
   }

   my $rhs;
   if ($master_irq_map)
   {

      foreach my $key (keys (%$master_irq_map))  {
        if ($irq_hash->{$key} eq  $slave_id) {
          $irq_hash->{$key} = $irq_port;
        }
      }
      my @irq_order = map {$irq_hash->{$_}}
         sort (keys (%$irq_hash));
      $rhs = "{". join (", ",reverse(@irq_order)) ."}";
   }
   else
   {
      $irq_hash->{$irq_number} = $irq_port
          if ($irq_number =~ /^\d+$/);

      my @port_order = map {$irq_hash->{$_}}
         sort {$a <=> $b} (keys (%$irq_hash));

      while (@port_order <
      $master_irq_sig->width()) {push (@port_order, "1'b0");}

      my @irq_order = splice (@port_order, 0, $master_irq_sig->width());

      foreach my $remaining_port (@port_order)
      {
         $this->get_and_set_thing_by_name({
           thing => "mux",
           lhs   => ["dummy_sink", 1, 0, 1],
           name  => "dummy sink",
           type  => "and_or",
           add_table => [$remaining_port,
                         $remaining_port],
        });
      }

      $rhs = "{".join (", ",@irq_order)."}";
   }
   $this->get_and_set_thing_by_name
      ({
          thing     => "assign",
          name      => "irq bus",
          lhs       => "$master_irq",
          rhs       => $rhs,
   });
   return;
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

The inherited class e_ptf_master_arbitration_module

=begin html

<A HREF="e_ptf_master_arbitration_module.html">e_ptf_master_arbitration_module</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
