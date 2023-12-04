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

e_sim_write - description of the module goes here ...

=head1 SYNOPSIS

The e_sim_write class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_sim_write;

use e_thing_that_can_go_in_a_module;
use e_module;
use e_signal;
use e_expression;
use e_project;
@ISA = ("e_thing_that_can_go_in_a_module");
use europa_utils;
use strict;

my %fields = (
              _order          => ["spec_string", "expressions", "file_handle"],
              spec_string     => "",
              _expressions     => [],
              show_time       => 0,
              file_handle     => "",
              delay           => 0,
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
   my $this  = shift;
   my $self = $this->SUPER::new(@_);

   $self->tag("simulation");  # Tag for sim-only output.
   return $self;
}



=item I<expressions()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub expressions
{
   my $this = shift;
   my $array_ref = shift;

   my @expression_array = map 
   {
      e_expression->new($_);
   } @$array_ref;

   map {$_->parent($this);} @expression_array;
   $this->_expressions(\@expression_array);
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

  my $vs = $indent;
  if ($this->delay())
  {
     $vs .= '#'.$this->delay().' ';
  }
  $vs .= $file_handle ? "\$fwrite($file_handle, " : "\$write(";


  $vs .= '"';
  if ($this->show_time) {
    $vs .= "%0d ns: ";
  }
  $vs .= $this->spec_string();
  $vs .= '"';


  if ($this->show_time) {
    $vs .= ", \$time";
  }
  my $args = join (", ", map {$_->to_verilog()} @{$this->_expressions()});
  if ($args ne "") {
    $vs .= ", " . $args;
  }
  $vs .= ");\n";
  return $vs;
}



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
   my $this = shift;
   $this->parent(@_);
}



=item I<vhdl_write()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_write
{
   my $this = shift;
   my $indent = shift;
   my $thing_to_write = shift;
   my $line_var = shift;
   my $string = $indent."write($line_var, $thing_to_write);";
   my $delay = $this->delay();
   if ($delay)
   {
      $string .= " after $delay NS";
   }
   return ("$string\n");
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

   my $vs;


   $this->parent_module()->vhdl_libraries()->{std}{textio} = "all";

   my $spec_string_raw = $this->spec_string();




   my @spec_strings = split(/\\n/, $spec_string_raw);


   my $index;
   for ($index = 0; $index < scalar(@spec_strings); $index++) {
      my $is_last_index = ($index == (scalar(@spec_strings) - 1));



      my $add_newline = $is_last_index ? ($spec_string_raw =~ /\\n$/) : 1;

      if ($add_newline) {
         $spec_strings[$index] .= "\\n";
      }
   }

   for ($index = 0; $index < scalar(@spec_strings); $index++) {
       my $spec_string = $spec_strings[$index];
       my $line_var = $this->parent_module()->get_exclusive_name("write_line");
    
       $this->parent_process()->vhdl_add_variable($line_var => "line");
    

       if ($this->show_time && ($index == 0)) {
          $vs .= $this->vhdl_write($indent,
                                "now",
                                $line_var
                                );
          $vs .= $this->vhdl_write($indent,
                                "string\'(\": \")",
                                $line_var
                                );
       }
    

       $spec_string =~ s/\t/     /g;
    

       $spec_string =~ s/\%\%/%/g;
    
       while ($spec_string =~ s/^(.*?)\%(0?)(\S)//s)
       {
          my $zero_present = ($2 ne "");
          my $percent_char = lc($3);
    
          if ($1 ne "") 
          {
              $vs .= $this->vhdl_write($indent,"string\'(\"$1\")", $line_var)
          }
    
          if ($percent_char eq "c")
          {

             $this->parent_module()->
               vhdl_libraries()->{ieee}{std_logic_unsigned} = "all";
    
             my $char_expr = shift @{$this->_expressions()};
             my $char = $char_expr->to_vhdl();
             $vs .= $this->vhdl_write($indent,
                                      "character'val(CONV_INTEGER($char))",
                                      $line_var
                                      );
          } elsif ($percent_char eq "h") {
             my $expr = shift @{$this->_expressions()};
             my $hex = $expr->to_vhdl();
             my $pad = $zero_present ? "pad_none" : "pad_zeros";
             $vs .= $this->vhdl_write($indent,
                                      "to_hex_string($hex, $pad)",
                                      $line_var
                                      );
          } elsif ($percent_char eq "d") {
             my $expr = shift @{$this->_expressions()};
             my $hex = $expr->to_vhdl();
             my $pad = $zero_present ? "pad_none" : "pad_spaces";
             $vs .= $this->vhdl_write($indent,
                                      "to_decimal_string($hex, $pad)",
                                      $line_var
                                      );
          } elsif ($percent_char eq "o") {
             my $expr = shift @{$this->_expressions()};
             my $hex = $expr->to_vhdl();
             my $pad = $zero_present ? "pad_none" : "pad_zeros";
             $vs .= $this->vhdl_write($indent,
                                      "to_octal_string($hex, $pad)",
                                      $line_var
                                      );
          } elsif ($percent_char eq "b") {
             my $expr = shift @{$this->_expressions()};
             my $hex = $expr->to_vhdl();
             my $pad = $zero_present ? "pad_none" : "pad_zeros";
             $vs .= $this->vhdl_write($indent,
                                      "to_binary_string($hex, $pad)",
                                      $line_var
                                      );
          } else {
             &ribbit ("support for \%$percent_char not supported yet\n");
          }
       }




       my $append_this;
       while ($spec_string =~ /\\n$/) {
         chop $spec_string;
         chop $spec_string;
         if ($file_handle) {
            $append_this .= ' & LF';
         } else {
            $append_this .= ' & CR';
         }
       }
    
       $vs .= $this->vhdl_write($indent,
                                "string\'(\"$spec_string\")",
                                $line_var
                                );
    
       $vs .= $this->vhdl_write($indent,
                                "$line_var.all$append_this",
                                ($file_handle || "output")
                                );
       $vs .= "${indent}deallocate ($line_var);\n";
   }

   return ($vs);
}

1; # One! one wonderful package!  Ah ah ah!

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
