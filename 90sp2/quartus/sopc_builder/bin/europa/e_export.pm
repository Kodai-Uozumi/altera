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

e_export - description of the module goes here ...

=head1 SYNOPSIS

The e_export class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_export;
use europa_utils;
use e_expression;
@ISA = ("e_expression");

use strict;

my %fields = (
              );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );




=item I<set()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub set
{
  my $this  = shift;
  my $in = shift;
  return if ($in eq '');

  my $p_hash;

  if (ref ($in) eq "ARRAY")
  {
     my @order = @{$this->_order()} or &ribbit 
         ("unable to set based upon array ref, no _order has been ",
          "specified");

     foreach my $input (@$in)
     {
        my $ord = shift (@order);
        $p_hash->{$ord} = $input;
     }
  }
  elsif (ref ($in) eq "HASH") {
    $p_hash = $in;

  }
  elsif (&is_blessed($in) && $in->isa(ref ($this)))
  {
     my @field_list = $this->access_methods_for_auto_constructor();

     foreach my $one_field (@field_list)
     {
        $p_hash->{$one_field} = $in->$one_field();
     }
  }
  else
    {
      &ribbit ("I am sorry, please rephrase what you are setting ",
               "in the form of a hash, array reference, or like object.");
     }

  my $function;
  foreach $function (keys (%$p_hash))
  {
     $this->$function($$p_hash{$function});
  }
  $this->isa_dummy(0);
  return $this;
}



=item I<direction()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub direction
{
   return 'export';
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
   return;
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
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

The inherited class e_expression

=begin html

<A HREF="e_expression.html">e_expression</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
