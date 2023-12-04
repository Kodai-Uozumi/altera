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

e_edge_detector - description of the module goes here ...

=head1 SYNOPSIS

The e_edge_detector class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_edge_detector;

use europa_utils;
use e_expression;
use e_assign;
use e_register;
use e_thing_that_can_go_in_a_module;

@ISA = qw (e_thing_that_can_go_in_a_module);

use strict;











my %fields = (
              _out         => e_expression->new(),
              _built       => 0,
              _edge_type   => "rising",
              _register    => e_register->new(),
              _edge_detect => e_assign->new(),
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
   $this = $this->SUPER::new(@_);
   $this->_register()->parent($this);
   $this->_edge_detect()->parent($this);
   return $this;
}



=item I<out()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub out
{
   my $this = shift;
   my $out = $this->_out(@_);
   if (@_)
   {
      $out->parent($this);
   }
   return $out;
}



=item I<edge()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub edge
{
  my $this = shift;


  if (!(@_)) { return $this->_edge_type()};

  my $etype = shift or &ribbit("no edge-type specified");

  &ribbit ("unknown edge type: $etype")
    unless $etype =~ /(rising)|(falling)|(any)/smig;

  return ($this->_edge_type($etype));
}




=item I<clock()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub clock
{
  my $this = shift;
  return $this->_register()->clock(@_);
}



=item I<enable()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub enable
{
  my $this = shift;
  return $this->_register()->enable(@_);
}



=item I<async_set()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub async_set
{
  my $this = shift;
  return $this->_register()->async_set(@_);
}



=item I<in()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub in 
{

  my $this = shift;
  if (!defined ($this->{in}))
  {
     $this->{in} = e_expression->new();
  }

  my $in_expr = $this->{in};

  if (@_)
  {
     $in_expr->set(@_);
     $this->_unique_name($in_expr->expression());
  }

  return $in_expr;
}



=item I<build()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub build
{
  my $this = shift;

  return if $this->_built();




  foreach my $member ($this->get_fields()) {
    next unless &is_blessed ($member) && $member->isa("e_expression");
    $member->update($this);
  }




  my $d_sig_name = "delayed_" . $this->_unique_name();

  $this->_register()->in ($this->in());
  $this->_register()->out($d_sig_name);
  $this->_register()->name($d_sig_name);




  my $in_expr_text = $this->in()->expression();

  $this->_edge_detect()->lhs ($this->out());
  my $rhs_expr;
  if       ($this->edge() =~ /rising/i)  {
    $rhs_expr = " ($in_expr_text) & ~($d_sig_name)";
  } elsif  ($this->edge() =~ /falling/i) {
    $rhs_expr = "~($in_expr_text) &  ($d_sig_name)";
  } elsif  ($this->edge() =~ /any/i)     {
    $rhs_expr = " ($in_expr_text) ^  ($d_sig_name)";
  }
  $this->_edge_detect()->rhs ($rhs_expr);





  $this->_built(1);
}






=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
   my $this = shift;
   my $parent = $this->parent(@_);

   $this->build();












}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
   my $this = shift;
   my $indent = shift;

   return (
           $this->string_to_verilog_comment($indent, $this->comment()).
           $this->_register()->to_verilog($indent).
           $this->_edge_detect()->to_verilog($indent)
           );

}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
   my $this = shift;
   my $indent = shift;

   return (
           $this->string_to_vhdl_comment($indent, $this->comment()).
           $this->_register()->to_vhdl($indent).
           $this->_edge_detect()->to_vhdl($indent)
           );

}

1;   # Must say 1

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
