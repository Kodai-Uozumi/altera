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

e_pull - description of the module goes here ...

=head1 SYNOPSIS

The e_pull class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_pull;
use e_expression;
use e_process;
@ISA = ("e_thing_that_can_go_in_a_module");
use strict;
use europa_utils;


my $__HASH_CHARACTER__ = '#';







my %fields = (
              signal => undef,
              pull_type => 'pullup',
              );

my %pointers = (
               );

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
   my $indent = shift;

   my $sig = $this->signal();

   my $vs = $this->pull_type() . "($sig);\n\n";


   $vs =~ s/^/$indent/mg;
   return ($vs);
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
   my $this = shift;
   my $indent = shift;

   my $sig = $this->signal();
   my $value = "''";
   {
     $this->pull_type eq 'pullup' and do {$value = "'H'"; last;};
     $this->pull_type eq 'pulldown' and do {$value = "'L'"; last;};
   }
   
   my $vs = 
"PROCESS
BEGIN
  $sig <= $value;  
WAIT;
END PROCESS;
\n\n";



   $vs =~ s/^/$indent/mg;
   return ($vs);
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

The inherited class e_thing_that_can_go_in_a_module

=begin html

<A HREF="e_thing_that_can_go_in_a_module.html">e_thing_that_can_go_in_a_module</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
