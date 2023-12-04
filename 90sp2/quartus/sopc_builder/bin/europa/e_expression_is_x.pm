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

e_expression_is_x - description of the module goes here ...

=head1 SYNOPSIS

The e_expression_is_x class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_expression_is_x;

use europa_utils;
use e_signal;

use e_expression;
@ISA = qw (e_expression);

use strict;

my %fields = ();
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
   my $return = 
       '^('.
       $this->SUPER::to_verilog(@_)
       .") === 1'bx";

   return $return;
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
   my $this = shift;
   my $force_to_type = shift;
   my $vhdl_string = $this->SUPER::to_vhdl();
   
   my $width = $this->vhdl_type();
   if ($width == 1)
   {
      $vhdl_string = "is_x(std_ulogic($vhdl_string))";
   }
   elsif ($width > 1)
   {
      $vhdl_string = "is_x($vhdl_string)";
   }
   else
   {
      &ribbit ("crazy width $width for is_x");
   }
   

   if ($force_to_type > 1)
   {
      &ribbit ("you crazy, converting is_x to a vector???");
   }
   elsif ($force_to_type == 1)
   {
     $vhdl_string = "A_WE_StdLogic($vhdl_string, '1','0')";
   }
   
   return $vhdl_string;
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

The inherited class e_expression

=begin html

<A HREF="e_expression.html">e_expression</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
