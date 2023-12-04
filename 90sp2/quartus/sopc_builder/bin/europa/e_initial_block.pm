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

e_initial_block - description of the module goes here ...

=head1 SYNOPSIS

The e_initial_block class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_initial_block;
use e_thing_that_can_go_in_a_module;
@ISA = qw (e_process);

use europa_utils;
use strict;







my %fields = (
	     );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<clock()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub clock
{
   my $this = shift;
   if (@_)
   {
      my $clock = shift;
      if ($clock)
      {
         &ribbit ("initial block has no clock");
      }
   }
}



=item I<reset()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub reset
{
   &ribbit ("initial block has no reset");
}



=item I<get_default_expressions()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_default_expressions
{
   my $this = shift;
   return qw ();
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
  my $this = shift;
  my $indent = shift;

  my $vs = "initial\n";

  my $multiline = @{$this->contents()} > 1;

  if ($multiline)
  {
    $vs .= $indent . "begin\n";
  }

  for (@{$this->contents()})
  {
    $vs .= $_->to_verilog($indent x 2);
  }

  if ($multiline)
  {
    $vs .= $indent . "end\n";
  }

  return $vs;
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
  my $this = shift;
  my $indent = shift;

  my $new_indent = "  ".$indent;


  my @variables = @{$this->_vhdl_variables()};

  my $vs;

























  foreach my $content (@{$this->contents()})
  {
     $vs .= $content->to_vhdl($new_indent."  ");
  }

  $vs = $indent."process\n".
    $this->vhdl_dump_variables().
    $this->vhdl_dump_files().
    "\n".
    "${new_indent}begin\n".$vs;


  $vs .= "${new_indent}wait;\n".
      "${indent}end process;\n";  


  return $vs;
}







=item I<vhdl_add_variable()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_add_variable
{
  my $this = shift;

  push (@{$this->_vhdl_variables()},[@_]);

}



=item I<vhdl_add_file()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_add_file
  {
  my $this = shift;
  push (@{$this->_vhdl_files()},[@_]);

}



qq
{
"My dog's got no nose!" 
"That's too bad. How does he smell?" 
"Terrible!" 
};

=back

=cut

=head1 EXAMPLE

Here is a usage example ...

=head1 AUTHOR

Santa Cruz Technology Center

=head1 BUGS AND LIMITATIONS

list them here ...

=head1 SEE ALSO

The inherited class e_process

=begin html

<A HREF="e_process.html">e_process</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
