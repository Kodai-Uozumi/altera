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

e_custom_instruction_master - description of the module goes here ...

=head1 SYNOPSIS

The e_custom_instruction_master class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_custom_instruction_master;

use e_custom_instruction_slave;
@ISA = ("e_custom_instruction_slave");
use strict;



=item I<new()>

Object constructor

=cut

sub new 
{
  my $this  = shift;

  my $self = $this->SUPER::new(@_);

  $self->{section_name} = "MASTER";

  return $self;
}



=item I<recognized_types()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub recognized_types
{
  my $this = shift;


  my @known_sigs = $this->SUPER::recognized_types();


  push (@known_sigs, 
          "combo_dataa",
          "combo_datab",
          "combo_result",
          "combo_n",
          "combo_a",
          "combo_b",
          "combo_c",
          "combo_readra",
          "combo_readrb",
          "combo_writerc",
          "combo_ipending",
          "combo_status",
          "combo_estatus",
          "multi_dataa",
          "multi_datab",
          "multi_result",
          "multi_n",
          "multi_a",
          "multi_b",
          "multi_c",
          "multi_readra",
          "multi_readrb",
          "multi_writerc",
          "multi_start",
          "multi_done",
          "multi_fixed_done",
          "multi_ipending",
          "multi_status",
          "multi_estatus",
       );

  return @known_sigs;
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

The inherited class e_custom_instruction_slave

=begin html

<A HREF="e_custom_instruction_slave.html">e_custom_instruction_slave</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
