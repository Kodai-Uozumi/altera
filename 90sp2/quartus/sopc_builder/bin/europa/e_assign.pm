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

e_assign - description of the module goes here ...

=head1 SYNOPSIS

The e_assign class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_assign;
use europa_utils;
use e_expression;
use e_lcell;
use e_if;
use e_thing_that_can_go_in_a_module;
@ISA = ("e_thing_that_can_go_in_a_module");

use strict;

my %fields = (
              blocking   => 0,
              max_le_terms => 4,
              no_lcell   => 0,
              _lhs_complemented => 0,
              _lhs     => e_expression->new(),
              _rhs     => e_expression->new(),
              _cascade => [],
              sim_delay => 0,
              );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<_order()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _order
{
   return ["lhs","rhs"], 
}










=item I<target()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub target 
{
  my $this  = shift;
  return ($this->lhs(@_));
}



=item I<expression()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub expression
{
  my $this  = shift;
  return ($this->rhs(@_));
}



=item I<out()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub out
{
   my $this = shift;
   return ($this->lhs(@_));
}



=item I<in()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub in
{
   my $this = shift;
   return ($this->rhs(@_));
}



=item I<lhs()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub lhs
{
   my $this = shift;

   my $lhs = $this->_lhs();
   if (@_)
   {
      $lhs->set(@_);
      $lhs->direction('output');
      $lhs->parent   ($this);
   }
   return $lhs;
}



=item I<rhs()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub rhs
{
   my $this = shift;
   my $rhs = $this->_rhs();
   if (@_)
   {
      $rhs->set(@_);
      $rhs->parent($this);
   }
   return $rhs;
}



=item I<cascade()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub cascade
{
   my $this = shift;

   if (@_)
   {
     $this->tag("dont_mind_me"); #we'll stick our hdl in the right

      my $string_array;
      if ((@_ == 1) && (ref ($_[0]) eq "ARRAY"))
      {
         $string_array = $_[0];
      }
      else
      {
         $string_array = \@_;
      }

      my @expr_array;
      foreach my $string (@$string_array)
      {
         my $expr = e_expression->new($string);
         $expr->parent($this);
         push (@expr_array, $expr);
       }

      push (@{$this->_cascade()},@expr_array);
      if (@expr_array)
      {

         $this->_build_rhs_from_cascade();
      }
   }
   return ($this->_cascade());
}




















=item I<cascade_and_array()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub cascade_and_array
{
   my $this = shift;
   my @and_array = (@_)
       or return;

   if (ref ($and_array[0]) eq "ARRAY")
   {
      @and_array = @{$and_array[0]};
   }

   my @good_and_terms;
   foreach my $and_term (@and_array)
   {
      push (@good_and_terms, $and_term)
          if ($and_term ne "")
   }
   my @cascade_array;
   my $max_le_terms = $this->max_le_terms();
   while (@good_and_terms)
   {

       push (@cascade_array,
              join (" & ",
                    splice(@good_and_terms,0,$max_le_terms)
                    )
              );
   }
   $this->cascade(@cascade_array);
}



=item I<_build_rhs_from_cascade()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _build_rhs_from_cascade
{
   my $this = shift;
   my @c = @{$this->cascade()};
   my @and_array = map {$_->expression()} @c;
   my $rhs = &and_array(@and_array);
   $rhs =~ s/\{/\(/g;
   $rhs =~ s/\}/\)/g;

   $this->rhs($rhs);
}



=item I<is_in_process()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub is_in_process
{
   my $this = shift;

   my $parent = $this->parent();
   while (!$parent->isa("e_module"))
   {
      return (1)
          if $parent->isa("e_process");
      $parent = $parent->parent();
   }
   return (0);
}




=item I<is_in_combinational_process()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub is_in_combinational_process
{
   my $this = shift;

   my $parent = $this->parent();
   while (!$parent->isa("e_module"))
   {
      if ($parent->isa("e_process"))
      {
         if ($parent->clock()){
            if ($parent->clock()->expression())
            {
               return (0)
            }
         }
         return (1)
      }
      $parent = $parent->parent();
   }
   return (0);
}




=item I<_make_expressions_decent()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _make_expressions_decent
{
   my $this = shift;

   my $lhs = $this->lhs();
   my $rhs = $this->rhs();

   my $lhs_expr = $lhs->to_verilog();
   my $rhs_expr = $rhs->to_verilog();
















   if ($lhs_expr =~ /\~/)
   {
      $this->_lhs_complemented(1);
      $lhs->{expression} = &complement($lhs_expr);
      $rhs->{expression} = &complement($rhs_expr);
   }
}



=item I<_make_lcell_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _make_lcell_module
{
   my $this = shift;
   my $language = shift or &ribbit ("no language");
   my $indent = shift;

   my $pm = $this->parent_module();

   my @cascades = @{$this->cascade()};
   my @lcells;

   my $last_cascade;

   my $inversion_assignment;
   while (@cascades)
   {
      my $cascade = shift (@cascades);
      my ($result,$d,$c,$b,$a) = $cascade->make_lcell_expression();

      my $lcell = e_lcell->new ({tag => "synthesis"});

      $lcell->parameter_map()->{lut_mask} = $result;
      $lcell->parameter_map()->{operation_mode} = "normal";
      $lcell->parameter_map()->{output_mode} = "comb";

      $lcell->port_map (dataa => $a)
          if ($a); 
      $lcell->port_map (datab => $b)
          if ($b); 
      $lcell->port_map (datac => $c)
          if ($c); 
      $lcell->port_map (datad => $d)
          if ($d);

      $lcell->port_map(cascin => $last_cascade)
          if ($last_cascade);

      if (@cascades)
      {

         $last_cascade =
             $pm->get_exclusive_name("casc");
         e_signal->new([$last_cascade => 1,0,1])
             ->within($pm);
         $lcell->port_map(cascout => $last_cascade);
      }
      else
      {
         my $lhs = $this->lhs->expression();
         if ($this->_lhs_complemented())
         {

            $last_cascade =
                $pm->get_exclusive_name("casc");
            e_signal->new([$last_cascade => 1,0,1])
                ->within($pm);
            $lcell->port_map(combout => $last_cascade);
            $inversion_assignment = e_assign->new
                ({
		  tag => "synthesis",
		  lhs => $lhs,
		  rhs => &complement($last_cascade),
                });
         }
         else
         {
            $lcell->port_map(combout => $lhs);
         }
      }
      push (@lcells, $lcell);
      push (@lcells, $inversion_assignment)
          if ($inversion_assignment);
    }
   $pm->add_contents(@lcells);
}



=item I<_reduce_cascade_logic()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _reduce_cascade_logic
{
   my $this = shift;
   my $cascade_expressions = shift;




































}


=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
  my $this   = shift;
  my $indent = shift;

  $this->_make_expressions_decent();
  my $lhs = $this->lhs()->to_verilog();
  my $rhs = $this->rhs()->to_verilog();



  my $preamble;
  my $assignment;
  if ($this->is_in_process())
  {
     $preamble   = "";
     if ($this->is_in_combinational_process())
     {
        $assignment = " \= ";
     }
     else
     {
        $assignment = " \<\= ";
     }
  }
  else
  {
     $preamble   = "assign ";
     $assignment = " \= ";
  }

  if ($this->sim_delay()) {
     $preamble   .= "#".$this->sim_delay()." ";
  }

  my $lhs_stuff = "";
  


  if ($this->comment() ne "")
  {
    $lhs_stuff = $this->string_to_verilog_comment($indent, $this->comment());
  }

  $lhs_stuff .= $indent.$preamble.$lhs.$assignment;
  
  my $subsequent_indent = $indent.$indent;#" " x length($lhs_stuff);
  my $new_line = "";
  $new_line = "\n"
      if (($rhs =~ s/\n\s*/\n$subsequent_indent/g) ||
          $this->comment());

  my $return_string = $lhs_stuff.$rhs.";\n$new_line";

  if (@{$this->cascade()})
  {     
     my $pm = $this->parent_module();
     my $wsa = $pm->project()->spaceless_system_ptf()->
     {WIZARD_SCRIPT_ARGUMENTS};
     my $device_family = $wsa->{device_family};
     if (($device_family =~ /apex/i) &&
         !$this->no_lcell())
     {
        $this->_make_lcell_module("verilog",$indent);
        $pm->simulation_strings($return_string);
        return;
     }
     else
     {
        $pm->normal_strings($return_string);
     }
  }
  else
  {
     return ($return_string);
  }
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
  my $this  = shift;

  my $indent = shift;

  $this->_make_expressions_decent();

  my $lhs = $this->lhs()->to_vhdl();
  my $rhs = $this->rhs();
  $rhs->de_ambigiousize(1)
    if ($lhs =~ /\,/);

  my $rhs_vhdl = $this->rhs()->to_vhdl($this->lhs->vhdl_type, $this->lhs->vhdl_variable_type);

  my $assignment = ' <= '; 

  my $lhs_stuff = "";
  $lhs_stuff = $this->string_to_vhdl_comment($indent, $this->comment())
      if (defined($this->comment()) and $this->comment());

  my $delay_vhdl = "";
  if ($this->sim_delay()) {
     my $timescale_directive = $this->parent_module()->project()->timescale();

     $timescale_directive =~ /^\s*(10{0,2})\s*(s|ms|us|ns|ps|fs)\s*\/.*$/;
     my $base_delay = $1;
     my $timescale= $2;
     my $delay = $base_delay * $this->sim_delay();
     $delay_vhdl = " after ".$delay." ".$timescale." ";
     $assignment .= ' transport '; 
  }

  $lhs_stuff .= $indent.$lhs.$assignment;
  my $subsequent_indent = " " x length($lhs_stuff);

  my $new_line;
  $new_line = "\n"
      if ($rhs_vhdl =~ s/\n\s*/\n$subsequent_indent/g);

  my $return_string = $lhs_stuff.$rhs_vhdl.$delay_vhdl.";\n$new_line";
  if (@{$this->cascade()})
  {     
     my $pm = $this->parent_module();
     my $wsa = $pm->project()->spaceless_system_ptf()->
     {WIZARD_SCRIPT_ARGUMENTS};
     if (($wsa->{device_family} =~ /apex/i) &&
         !$this->no_lcell)
     {
        $this->_make_lcell_module("vhdl",$indent);
        $pm->simulation_strings($return_string);
        return;
     }
     else
     {
        $pm->normal_strings($return_string);
     }
  }
  else
  {
     return ($return_string);
  }
}



=item I<convert_to_assignments()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub convert_to_assignments
{
   my $this = shift;
   my $condition = shift;

   my $lhs = $this->lhs()->expression();
   my $rhs = $this->rhs()->expression();

   $this->convert_to_assignment_mux
       ($lhs, $condition, $rhs);
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



=item I<conduit_width_if_appropriate()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub conduit_width_if_appropriate
{
   my $this = shift;
   my $conduit_width = shift;
   my $lhs = $this->lhs();
   my $rhs = $this->rhs();

   if ($lhs->isa_signal_name() && 
       $rhs->isa_signal_name())
   {
      $lhs->conduit_width(1);
      $rhs->conduit_width(1);
   }
   else
   {
      $lhs->conduit_width(0);
      $rhs->conduit_width(0);
   }
}



=item I<make_linked_signal_conduit_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_linked_signal_conduit_list
{
   my $this = shift;
   my $signal_name = shift;

   my $lhs = $this->lhs;
   my $rhs = $this->rhs;
   my $lhs_expression = $lhs->expression();
   my $rhs_expression = $rhs->expression();

   my $parent_module = $this->parent_module();
   my $linked_expression;
   if ($lhs_expression eq $signal_name)
   {
      $linked_expression = $rhs_expression;
   }
   elsif ($rhs_expression eq $signal_name)
   {
      $linked_expression = $lhs_expression;
   }
   else
   {
      &ribbit ("sig: $signal_name doesn't match ".
               "lhs: $lhs_expression or rhs: $rhs_expression\n");
   }


   $lhs->conduit_width(0);
   $rhs->conduit_width(0);

   return ($parent_module->make_linked_signal_conduit_list
           ($linked_expression));
}



=item I<check_x()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub check_x
{
   my $this = shift;
   my $signal_name = shift;

   my $sig_list = $this->_signal_list()->{output};

   if (!$sig_list->{$signal_name})
   {
      my @sig_list = sort (keys (%{$sig_list}));
      &ribbit ("$signal_name isn't in sig list (@sig_list)\n");
   }
   my $lhs = $this->lhs()->expression();

   my @hits = ($lhs =~ /\b($signal_name\s*\[.*?\])/sg);

   my $parent_module = $this->parent_module();
   foreach my $hit (@hits)
   {
      $hit =~ s/\s+//sg;

      my $check_x = $parent_module->get_and_set_once_by_name
          ({
             thing => "e_process_x",
             name  => "check x for $hit",
             check_x => $hit,
           });


      if ($check_x) #if nobody has set this check x before
      {

         foreach my $dest ($this->get_destination_names())
         {
            $parent_module->check_x($dest);
         }
      }
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
