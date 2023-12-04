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

e_process - description of the module goes here ...

=head1 SYNOPSIS

The e_process class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_process;

use europa_utils;
use e_expression;

use e_thing_that_can_go_in_a_module;
@ISA = qw (e_thing_that_can_go_in_a_module);

use strict;







my %fields = (
              _order => ["asynchronous_contents",
                         "contents"],
              _clock                => e_expression->new ("clk"),
              clock_level           => 1, #1 for rising, 0 for falling,

              _reset                => e_expression->new('reset_n'),
              reset_level           => 0,
              _asynchronous_contents => [],
              _contents             => [],

              _built                => 0,
	      _vhdl_variables       => [],
	      _vhdl_files           => [],
              _reset_default        => "reset_n",
	      _vhdl_fixes           => [],

              output_as_muxes_and_registers => 0,
	      sensitivity_list      => [],
              _user_attributes    => [],
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
   foreach my $default_expression ($this->get_default_expressions())
   {
      $this->$default_expression()->parent($this);
   }
   return $this;
}



=item I<get_default_expressions()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_default_expressions
{
   my $this = shift;
   return qw (_clock _reset);
}



=item I<reset()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub reset
{
   my $this = shift;

   my $reset = $this->_reset();
   if (@_)
   {
      $reset->set(@_);
      $reset->parent($this);
   }

   return $reset;
}



=item I<clock()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub clock
{
   my $this = shift;

   my $clock = $this->_clock();
   if (@_)
   {
      my $clock_val = shift;
      $clock->set($clock_val);
      $clock->parent($this);
      if (!$clock_val)
      {
         $this->reset('');
      }
   }

   return $clock;
}



=item I<a_conts()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub a_conts
{
   my $this = shift;
   return ($this->asynchronous_contents(@_));
}



=item I<conts()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub conts
{
   my $this = shift;
   return ($this->contents(@_));
}
















=item I<fast_output_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub fast_output_names
{
   my $this = shift;

   if (@_)
   {
      my $names = shift;
      if (ref ($names) eq 'ARRAY')
      {
         $this->{_fast_output_names} = {};
         foreach my $name (@$names)
         {
            $this->{_fast_output_names}{$name} = 1;
         }
      }
      else
      {
         return $this->{_fast_output_names}{$names};
      }
   }
   else
   {
      &ribbit ("bad usage of fast_output_names");
   }
}



=item I<fast_enable_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub fast_enable_names
{
   my $this = shift;

   if (@_)
   {
      my $names = shift;
      if (ref ($names) eq 'ARRAY')
      {
         $this->{_fast_enable_names} = {};
         foreach my $name (@$names)
         {
            $this->{_fast_enable_names}{$name} = 1;
         }
      }
      else
      {
         return $this->{_fast_enable_names}{$names};
      }
   }
   else
   {
      &ribbit ("bad usage of fast_enable_names");
   }
}



=item I<fast_input_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub fast_input_names
{
   my $this = shift;

   if (@_)
   {
      my $names = shift;
      if (ref ($names) eq 'ARRAY')
      {
         $this->{_fast_input_names} = {};
         foreach my $name (@$names)
         {
            $this->{_fast_input_names}{$name} = 1;
         }
      }
      else
      {
         return $this->{_fast_input_names}{$names};
      }
   }
   else
   {
      &ribbit ("bad usage of fast_input_names");
   }
}

sub user_attributes_names
{
   my $this = shift;

   if (@_)
   {
      my $names = shift;
      if (ref ($names) eq 'ARRAY')
      {
         $this->{_user_attributes_names} = {};
         foreach my $name (@$names)
         {
            $this->{_user_attributes_names}{$name} = 1;
         }
      }
      else
      {
         return $this->{_user_attributes_names}{$names};
      }
   }
   else
   {
      &ribbit ("bad usage of user_attributes_names");
   }
}



=item I<attribute_string()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub attribute_string
{
   my $this = shift;
   my $name = shift;

   my @attribute_list = ();

   if ($this->{_fast_output_names}{$name})
   {
      push (@attribute_list, 'FAST_OUTPUT_REGISTER=ON');
   }
   if ($this->{_fast_enable_names}{$name})
   {
      push (@attribute_list, 'FAST_OUTPUT_ENABLE_REGISTER=ON');
   }
   if ($this->{_fast_input_names}{$name})
   {
      push (@attribute_list, 'FAST_INPUT_REGISTER=ON');
   }

   push @attribute_list, $this->user_attributes_elements('\"');


   my $attribute = '';
   if (@attribute_list) {
     $attribute = ' "' .  (join ' ; ', @attribute_list) .  '"' ;
   }
   return $attribute;
}



=item I<convert_to_assignment_mux()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub convert_to_assignment_mux
{
   my $this = shift;
   my ($lhs,$condition,$rhs) = @_;

   my $module = $this->parent_module();



   $this->{_assignment_mux_lhs_list}{$lhs}++;



   my $p1_lhs = $lhs;
   if ($this->clock()->expression())
   {
      $module->get_and_set_once_by_name
          ({
             thing  => 'register',
             name   => "$this $lhs register",
             reset  => '',
             out    => $lhs,
             fast_out => $this->fast_output_names($lhs),
             enable => 1,
          });

      $p1_lhs = "p1_$lhs";
   }

   my $mux = $module->get_and_set_thing_by_name
       ({
          thing => 'mux',
          name  => "$this $lhs mux",
          lhs   => $p1_lhs,
       });
   my @c_array = @$condition;
   if (@c_array)
   {
      my $a = @c_array;
      $mux->add_table
          ([&and_array(@c_array) => $rhs]);
   }
   else
   {
      if ($mux->default->expression() eq '')
      {
         $mux->default($rhs);
      }
   }
}



=item I<declare_verilog_register()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub declare_verilog_register
{
   my $this = shift;
   my $name = shift;
   if (0)#$this->fast_output_names($name) && $this->output_as_muxes_and_registers())
   {
      return 0;
   }
   else
   {
      return 1;
   }
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
   my $this  = shift;
   my $class = ref($this) or &ribbit ("this ($this) not understood");

   my @contents = @{$this->contents()} or
       &ribbit ("no contents in process $this, pretty suspicious");

   my @asy_contents = @{$this->asynchronous_contents()};


   my $indent = shift;

   my $vs = $this->string_to_verilog_comment($indent,$this->comment());
   my $incremental_indent = $this->indent();

   my $clock = $this->clock()->to_verilog();
   my $reset = $this->reset()->to_verilog();



   if (!$clock)
   {
       my @a_signals = @{$this->sensitivity_list()};
       if (!@a_signals)
       {
	   @a_signals = sort ($this->get_destination_names());
       }

       $vs .= $indent."always \@(";
       $vs .= join (" or ",@a_signals);
   }
   else
   {
       my $clock_edge;
       
       if ($this->clock_level() eq "none")
       {
	   $clock_edge = "";
       }
       else
       {
	   $clock_edge = $this->clock_level() ? "posedge": "negedge";
       }
       
       my $reset_edge = ($this->reset_level())? "posedge": "negedge";
       
       $vs .= $indent."always \@($clock_edge $clock";
       
       $vs .= " or $reset_edge $reset"
	   if ($reset && @asy_contents);
   }

   $vs .= "\)\n";
   $vs .= "$indent${incremental_indent}begin\n";

   if (@asy_contents)
   { 



      my $if_statement = e_if->new
          ({
             condition => "$reset \=\= ".$this->reset_level(),
             _then      => [@asy_contents],
             _else      => [@contents],
          });

      $if_statement->parent($this);

      $vs .= $if_statement->to_verilog
          ($indent.($incremental_indent x 2));
   }
   else
   {
      $this->reset('');
      foreach my $content (@contents)
      {
         $vs .= $content->to_verilog($indent.($incremental_indent x 2));
      }
   }
   $vs .= "$indent${incremental_indent}end\n";  
   $vs .= $this->paragraph;

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

   my $vs = $this->string_to_vhdl_comment($indent,$this->comment());
   my $incremental_indent = $this->indent();

   my $clock = $this->clock()->to_vhdl();
   my $reset_expr = $this->reset();
   my $r_p = $reset_expr->parent();

   my $reset = $this->reset()->to_vhdl();

   my $tempy;

   if($clock =~ /(["'])(\d+)(['"])/)
   {
     my $pm = $this->parent_module();
     my $new_name = $pm->get_exclusive_name("clock_input");
     my $new_signal =  e_signal->new([$new_name, $this->clock()->width(),0,1]);
     my $new_assignment = e_assign->new({
					 lhs => $new_signal,
					 rhs => $this->clock,
					 tag => $this->tag(),
					});

     $new_assignment->update($this);
     $clock = $new_name;

     push(@{$this->_vhdl_fixes()},$new_assignment->to_vhdl());
   }

   if($reset =~ /(["'])(\d+)(['"])/)
   {
     my $pm = $this->parent_module();
     my $new_name = $pm->get_exclusive_name("reset_input");
     my $new_signal =  e_signal->new([$new_name, $this->reset()->width(),0,1]);
     my $new_assignment = e_assign->new({
					 lhs => $new_signal,
					 rhs => $this->reset,
					 tag => $this->tag(),
					});

     $new_assignment->update($this);
     $reset = $new_name;
     push(@{$this->_vhdl_fixes()},$new_assignment->to_vhdl());
   }

   my @condition_list = @{$this->sensitivity_list()};
   push (@condition_list, $this->clock()->
         _get_all_signal_names_in_expression());

   my @contents = @{$this->contents()} or
       &ribbit ("no contents in process $this, pretty suspicious");

   my @asy_contents = @{$this->asynchronous_contents()};

   my $name = $this->name();

   my $clock_level = $this->clock_level();
   my $reset_level = $this->reset_level();
   my $contents_vs;
   if (@asy_contents && $reset)
   {
      push (@condition_list, $this->reset()->
            _get_all_signal_names_in_expression());

      $contents_vs .= "$indent${incremental_indent}if $reset = '$reset_level' then\n";

      foreach my $asy_content (@asy_contents)
      {
	$contents_vs .= $asy_content->to_vhdl($indent.($incremental_indent
                                                  x 2));
      }
   }
   else
   {
      $this->reset('');
   }

   if ($clock)
   {
      if (@asy_contents && $reset)
      {
         $contents_vs .= "$indent${incremental_indent}".
             "elsif $clock\'event and $clock = '$clock_level' then\n";
      }
      else
      {
         $contents_vs .= "$indent${incremental_indent}".
             "if $clock\'event and $clock = '$clock_level' then\n";
      }
   }
   else
   {


       @condition_list = sort ($this->get_destination_names());

   }

   foreach my $content (@contents)
   {
      $contents_vs .= $content->to_vhdl($indent.($incremental_indent x 2));
   }

      $contents_vs .= "$indent${incremental_indent}end if\;\n"
          if ($clock || $reset);

   $vs .= $indent;
   $vs .= "process ";
   $vs .= "(".join (", ",@condition_list).")"
       if (@condition_list);
   $vs .= "\n";
   $vs .= $this->vhdl_dump_variables($indent);
   $vs .= $this->vhdl_dump_files($indent);
   $vs .= "${indent}begin\n";
   $vs .= "$contents_vs\n";
   $vs .= "${indent}end process\;";  
   $vs .= $this->paragraph();
   $vs .= $this->vhdl_dump_fixes();










   my %attributes = ();
   my @all_signals_with_attributes = (
     keys (%{$this->{_fast_output_names}}),
     keys (%{$this->{_user_attributes_names}})
   );

   map {$attributes{$_} = []} (@all_signals_with_attributes);


   for my $signal (keys (%{$this->{_fast_output_names}}))
   {
      push @{$attributes{$signal}}, 'FAST_OUTPUT_REGISTER=ON';
   }

   for my $signal (keys (%{$this->{_user_attributes_names}}))
   {
      for my $user_attr ($this->user_attributes_elements('""'))
      {
        push @{$attributes{$signal}}, $user_attr;
      }
   }



   for my $signal_with_attributes (keys %attributes)
   {
     my $user_attributes = join(" ; ", @{$attributes{$signal_with_attributes}});
     $this->parent_module()->add_attribute(
       ALTERA_ATTRIBUTE => {$signal_with_attributes => $user_attributes}
     );
   }

   return $vs;
}



=item I<vhdl_dump_variables()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_dump_variables
  {
    my $this = shift;
    my $indent = shift;
    my $vs;

   my @variables = @{$this->_vhdl_variables()};

   foreach my $var (@variables)
     {
       $vs .= "$indent";
       $vs .= "VARIABLE $$var[0] : $$var[1]";
       $vs .= " := $$var[2]"
	 if ($$var[2] ne "");
       $vs .= ";\n";
     }
    return ($vs);
}



=item I<vhdl_dump_files()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_dump_files
  {
    my $this = shift;
    my $indent = shift;
    my $vs;

   my @files = @{$this->_vhdl_files()};

   foreach my $var (@files)
     {
       $vs .= "$indent";
       $vs .= "FILE $$var[0] : $$var[1]";
       $vs .= " \"".$$var[2]."\""
	 if ($$var[2] ne "");
       $vs .= ";\n";
     }


    return ($vs);
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



=item I<vhdl_add_variable()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_add_variable
{
  my $this = shift;

  push (@{$this->_vhdl_variables()},[@_]);
}



=item I<vhdl_dump_fixes()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_dump_fixes
{
  my $this=shift;
  my $vs;
  my @fixes = @{$this->_vhdl_fixes()};

  $vs = join("\n", @fixes);

  return $vs;
}



=item I<contents()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub contents
{
   my $this = shift;
   my $contents;

   $contents = $this->_contents(@_);

   foreach my $content (@{$_[0]})
   {
      $content->parent($this);
   }

   return $contents;
}



=item I<asynchronous_contents()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub asynchronous_contents
{
   my $this = shift;
   my $asynchronous_contents;

   $asynchronous_contents = $this->_asynchronous_contents
       (@_);

   foreach my $content (@{$_[0]})
   {
      $content->parent($this);
   }

   return $asynchronous_contents;
}


































sub user_attributes
{
  my $this = shift;

  my $values = $this->_user_attributes(@_);


  ribbit("e_register::user_attributes(): must be a list reference")
    if (ref($values) ne 'ARRAY');

  for my $val (@$values)
  {

    ribbit("e_register::user_attributes(): list must contain hash references only")
      if (ref($val) ne 'HASH');







    my @iff_keys = qw(attribute_name attribute_operator attribute_values);
    my $key_count = 0;
    for my $key (@iff_keys)
    {
      $key_count++ if (defined($val->{$key}));
    }
    if ( ($key_count != @iff_keys) || grep {!defined $val->{$_}} (@iff_keys))
    {
      ribbit(
        "e_register::user_attributes(): list element hash references " .
        "must contain keys 'attribute_name', 'attribute_operator', " .
        "'attribute_values' and only those keys"
      );
    }


    if (
      ref($val->{attribute_values}) ne 'ARRAY' || 
      @{$val->{attribute_values}} == 0
    )
    {
      ribbit("e_register::user_attributes(): 'attribute_values' element must be
      a list reference");
    }
  }

  return $values;
}

sub user_attributes_elements
{
  my $this = shift;
  my $lang_specific_quote = shift;

  my @attr = ();
  for my $user_attr (@{$this->user_attributes()})
  {
    my $name = $user_attr->{attribute_name};
    my $op = $user_attr->{attribute_operator};
    my @values = @{$user_attr->{attribute_values}};



    my $quote = '';
    $quote = $lang_specific_quote if (@values > 1);
    my $suppression = "$name$op$quote" .  join(",", @values) . "$quote";
    push @attr, $suppression;
  }
  return @attr;
}




=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
  my $this = shift;
  
  $this->SUPER::update(@_);

  for my $thing (@{$this->contents()}, @{$this->asynchronous_contents()})
  {

    $thing->parent($this);
    

    $thing->update($this);
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
