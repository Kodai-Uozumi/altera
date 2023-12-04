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

e_if - description of the module goes here ...

=head1 SYNOPSIS

The e_if class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_if;

use europa_utils;
use e_expression;

use e_thing_that_can_go_in_a_module;
@ISA = ("e_thing_that_can_go_in_a_module");
use strict;







my %fields = (
              _order    => ["condition", "then", "else"],
              _condition => e_expression->new(),
              _then      => [],
              _else      => [],
              _updated_then_contents  => [],
              _updated_else_contents  => [],
              );

my %pointers = (
              );

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<elsif()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub elsif {
  my $this  = shift;
  my $elsif_contents_ref = shift;

  my $if_to_add = e_if->new ($elsif_contents_ref);
  $this->else([$if_to_add]);
}



=item I<condition()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub condition
{
   my $this = shift;
   my $condition = $this->_condition(@_);
   if (@_)
   {
      $condition->parent($this);
   }
   return $condition;
}



=item I<then()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub then
{
   my $this = shift;

   if (@_)
   {
      my $then = $this->_then
          ($this->_make_updated_contents_array(@_));

      return $then;
   }
   return $this->_then();
}



=item I<else()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub else
{
   my $this = shift;

   if (@_)
   {
      my $else = $this->_else
          ($this->_make_updated_contents_array(@_));
   }
   return $this->_else();
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
  my $this  = shift;
  my $class = ref($this) or &ribbit ("this ($this) not understood");

  my $indent = shift;

  my $incremental_indent = $this->indent();
  
  my $paragraph = "\n\n\n";
  my $vs = "";
  $vs .= $this->string_to_verilog_comment($indent, $this->comment);


  if (($this->condition()->expression() ne ''))
  {
     $vs .= $indent."if (".$this->condition()->to_verilog().
         ")\n";
  }
  else
  {
     $vs .= "${indent}if (1)\n";
  }

  my @then = @{$this->then()};
  my @else = @{$this->else()};

  my $then_indent = $indent.$incremental_indent;

  if (@then || @else)
  {
     my $thing_indent = $indent.($incremental_indent x 2);

     my $use_begin_end = 1;  # Assume we'll do begin/end.












     if (@then == 1)
     {


       if (!$then[0]->isa("e_if") or 0 == @else)
       {
         $use_begin_end = 0;
       }
     }
     
     my $then_vs;
     foreach my $t (@then)
     {
        $then_vs .= $t->to_verilog($thing_indent);
     }

     if ($then_vs =~ /^\s*$/s) {
        $use_begin_end = 1;
     }

     if ($use_begin_end) {$vs .= $then_indent."begin\n";}
     else                {$thing_indent = $then_indent;}

     $vs .= $then_vs;

     if ($use_begin_end) {$vs .= $then_indent."end\n";}
     
     if (@else)
     {
        $vs .= $indent."else ";
        my $thing_indent = $indent.($incremental_indent x 2);

        my $use_begin_end = (scalar (@else) > 1);

        if ($use_begin_end) {$vs .= "\n${then_indent}begin\n";}
        else
        { 
           if ($else[0]->isa("e_if"))
           {

              $thing_indent = $indent;    
           }
           else
           {
              $vs .= "\n";
              $thing_indent = $then_indent;
           }
        }

        foreach my $e (@else)
        {
           $vs .= $e->to_verilog($thing_indent);
        }

        if ($use_begin_end){$vs .= $then_indent."end\n";}
     }
  }
  else
  {
     print "creation history: ".$this->{_creation_history}."\n";
     &ribbit 
         ("suspicious if statement with no contents you got there in $this");
  }
  $vs =~ s/\belse[ ]+/else /g;
  return ($vs);
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
  my $this  = shift;
  my $class = ref($this) or &ribbit ("this ($this) not understood");

  my $indent = shift;
  my $isa_elsif = shift;

  my $incremental_indent = $this->indent();
  
  my $paragraph = "\n\n\n";
  my $vs;

  if (!$isa_elsif)
  {
     $vs .= $this->string_to_vhdl_comment($indent, $this->comment);
     $vs .= $indent.
         "if ";
  }

  if ($this->condition()->expression())
  {
     $vs .= $this->condition()->to_vhdl("boolean").
         " then \n";
  }
  else
  {
     $vs .= "true then \n";
  }

  my @then = @{$this->then()};
  my @else = @{$this->else()};

  my $then_indent = $indent.$incremental_indent;

  if (@then || @else)
  {
     foreach my $t (@then)
     {
        $vs .= $t->to_vhdl($indent.($incremental_indent x 1));
     }
     if (@else)
     {
        my $only_if = $else[0];
        if ((@else == 1) && ($only_if->isa("e_if")))
        {
           $vs .= $this->string_to_vhdl_comment($indent,$only_if->comment);
           $vs .= $indent."elsif ".
               $only_if->to_vhdl($indent,"boolean");
        }
        else
        {
           $vs .= $indent."else\n";
           foreach my $e (@else)
           {
              $vs .= $e->to_vhdl($indent.($incremental_indent x 1));
           }
        }
     }
     $vs .= $indent."end if;\n"
         unless ($isa_elsif);
  }
  else
  {
     &ribbit ("suspicious if statement with no contents you got there
  in $this");
  }
  return ($vs);
}



=item I<convert_to_assignments()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub convert_to_assignments
{
   my $this = shift;
   my $previous_condition = shift;

   my $cond_expression = $this->condition()->expression();

   my @then_condition = (@$previous_condition,
                         $cond_expression
                         );

   my @else_condition = (@$previous_condition,
                         &complement($cond_expression)
                         );

   foreach my $then (reverse (@{$this->_updated_then_contents()}))
   {
      $then->convert_to_assignments(\@then_condition);
   }
   foreach my $else (reverse (@{$this->_updated_else_contents()}))
   {
      $else->convert_to_assignments(\@else_condition);
   }









}



=item I<convert_to_assignment_mux()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub convert_to_assignment_mux
{
   my $this = shift;
   return $this->parent()->convert_to_assignment_mux(@_);
}




=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
  my $this = shift;
  my $parent = shift;


  
  for my $thing (@{$this->then()}, @{$this->else()})
  {

    $thing->parent($this);
  }
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
