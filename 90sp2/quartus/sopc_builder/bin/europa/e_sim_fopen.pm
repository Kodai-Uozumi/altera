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

e_sim_fopen - description of the module goes here ...

=head1 SYNOPSIS

The e_sim_fopen class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_sim_fopen;
use e_thing_that_can_go_in_a_module;
@ISA = qw (e_initial_block);

use europa_utils;
use strict;







my %fields = (
              file_name       => "",
              file_handle     => "",
	     );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<new()>

Object constructor

=cut

sub new
{
  my $this = shift;

  my $return = $this->SUPER::new(@_);

  $return->tag("simulation");

  return $return;
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
  my $this = shift;
  my $indent = shift;

  my $file_handle = $this->file_handle;
  my $file_name = $this->file_name;

  my $vs .= qq[
reg [31:0] $file_handle; // for \$fopen
initial  
begin
  $file_handle = \$fopen(\"$file_name\");
];

  foreach my $content (@{$this->contents}) {
    $vs .= $content->to_verilog("  ");
  }

  $vs .= "end\n";

  $vs =~ s/^/$indent/mg;

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

  my $file_handle = $this->file_handle;
  my $file_name = $this->file_name;

  $this->parent_module->vhdl_add_string("file $file_handle : TEXT ;\n");

  my $contents_str;

  foreach my $content (@{$this->contents}) {
    $contents_str .= $content->to_vhdl();
  }

  my $vs = qq[
process is
  variable status : file_open_status; -- status for fopen
];

  $vs .= $this->vhdl_dump_variables();
  $vs .= $this->vhdl_dump_files();

  $vs .= qq[
begin  -- process
  file_open(status, $file_handle, \"$file_name\", WRITE_MODE);
  $contents_str
  wait;                               -- wait forever
end process;
];

  $vs =~ s/^/$indent/mg;

  return $vs;
}

qq
{
"Open Sesame!" 
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

The inherited class e_initial_block

=begin html

<A HREF="e_initial_block.html">e_initial_block</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
