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

e_instance - description of the module goes here ...

=head1 SYNOPSIS

The e_instance class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_instance;
use e_expression;
use e_thing_that_can_go_in_a_module;
@ISA = ("e_thing_that_can_go_in_a_module");

use strict;
use europa_utils;





my %fields = (
              __module_name         => "",
              weirdo_vhdl_assignments => [],
              declare_parameters_as_variables => [],
              verilog_override => 0,
              _port_map            => {},
              _port_map_bone_pile  => {},
              _expression_port_map => {},
              _module_set => 0,
              suppress_open_ports => 0,
              );

my %pointers = (
                _module_ref => e_module->dummy(),
                );

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<setup_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub setup_name
{
   my $this = shift;
   my $name = $this->name();
   if (!$name)
   {
      my $project = $this->project();
      my $module_name = $this->_module_name() ||
          $this->module()->name();

      if (!$module_name)
      {
         &ribbit ("no name");
      }
      
      $name = $this->name
          (
           $project->
           get_exclusive_name("the_$module_name")
           );
   }
   return $name;
}








=item I<_module_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _module_name
{
   my $this = shift;
   if (@_)
   {
      my $value = shift;
      if (ref ($value))
      {
         $this->module($value);
         return $this->__module_name();
      }
      else
      {
         return $this->__module_name($value);
      }
   }
   my $module_name = $this->__module_name();
   
   if (!$module_name)
   {
      my $actual_module_name = $this->module()->name();
      if ($actual_module_name)
      {
         return $this->__module_name($actual_module_name);         
      }
   }
   return $module_name
}



=item I<parameter_map()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub parameter_map
{
   my $this = shift;

   if (!defined ($this->{parameter_map}))
   {
      $this->{parameter_map} = {};
   }

   if (@_) { 
      my $incoming_hash = shift;
      &ribbit ("one-and-only argument must be hash-ref") 
          unless (ref ($incoming_hash) eq "HASH") && (scalar(@_) == 0);





      
      foreach my $key (keys (%{$incoming_hash}))
      {
         $this->parameter_map()->{$key} = $incoming_hash->{$key};
      }
   }
   return $this->{parameter_map};
}












=item I<module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub module
{
   my $this  = shift;

   if (@_) {
      my $module_value = shift;
      my $module_ref   = ref ($module_value);

      if ($module_ref eq "") 
      {

         $this->_module_name($module_value);
         if ($this->_project_set())
         {
            $this->project()->set_this_module_when_available
                ($module_value => $this);
         }
      } elsif (&is_blessed($module_value)     &&
               $module_value->isa("e_module")  ) {
         $this->module_ref($module_value);
         $this->_module_name($module_value->name());
         if ($this->_project_set())
         {
            $module_value->project($this->project());
         }
      } else {
         &ribbit
             ("TYPE MISMATCH, $module_value must be module ",
              "name or e_module, not ($module_ref)\n");
      }
   }

   return ($this->module_ref());
}



=item I<module_ref()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub module_ref
{
   my $this = shift;
   my $module_ref = $this->_module_ref(@_);
   $this->_module_set(1);
   if (@_)
   {
      $module_ref->_instantiated_by([
                                     @{$module_ref->_instantiated_by()},
                                     $this]);
      if ($this->_project_set())
      {
         $module_ref->project($this->project);
      }
      $this->update_port_map();
   }
   return $module_ref;
}



=item I<project()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub project
{
   my $this = shift;
   my $project = $this->SUPER::project(@_);
   if (@_)
   {
      if ($this->_module_set())
      {
         $this->_module_ref()->project(@_);
      }
      else
      {
         if ($this->_module_name())
         {
            $project->set_this_module_when_available
                ($this->_module_name() => $this);
         }
      }
   }
   return $project;
}



=item I<port_map()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub port_map
{
   my $this = shift;

   my $port_map = $this->_port_map();
   if (@_)
   {
      my $num_args = scalar (@_);
      my ($first_arg) =  @_;

      if ($num_args > 1)
      {
         my $expression_port_map = $this->_expression_port_map();
         ($num_args % 2 == 0) or 
             &ribbit ("odd number of items for port_map (@_)\n");

         my @set_these = @_;
         my $key;
         my $value;

         my $expression_port_map = 
             $this->_expression_port_map();

         my $bone_pile = $this->_port_map_bone_pile();
         while (@set_these)
         {
            my $key = shift (@set_these);
            my $value = shift (@set_these);
            $port_map->{$key} = $value;
         }

         $this->update_port_map();
      }
      elsif (ref ($first_arg) eq "HASH")
      {
         $port_map = $this->port_map(%$first_arg);
      }
      else #first arg is a scalar which points to port map.
      {
         $port_map = $port_map->{$first_arg};
      }
   }

   return $port_map;
}



=item I<add_port_of_direction()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_port_of_direction
{
   my $this = shift;
   my $signal_name = shift;
   my $direction = shift;

   my $e_pm = $this->_expression_port_map();
   my $bone_pile = $this->port_map_bone_pile();
   my $port_map = $this->_port_map();

   my $expression;
   if ($bone_pile->{$signal_name})
   {

      $expression = $bone_pile->{$signal_name};
      $e_pm->{$signal_name} = $expression;
      delete ($bone_pile->{$signal_name});
      $expression->add_this_to_parent();
   }
   elsif ($e_pm->{$signal_name})
   {
      $expression = $e_pm->{$signal_name};
   }
   else
   {

      $expression = e_expression->new($signal_name);
      $e_pm->{$signal_name} = $expression;
   }

   if (defined ($port_map->{$signal_name}))
   {
      $expression->expression($port_map->{$signal_name})
   }



   $port_map->{$signal_name} =
       $expression->expression();

   $expression->conduit_width(1);
   $expression->direction($direction);
   $expression->parent($this);
}



=item I<remove_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub remove_port
{
   my $this = shift;
   my $port_name = shift;

   my $e_pm = $this->_expression_port_map();

   my $expression = $e_pm->{$port_name};
   $expression->remove_this_from_parent();

   $this->port_map_bone_pile($port_name, $expression);
   delete $e_pm->{$port_name};
   delete $this->_port_map()->{$port_name};
}



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
   my $this = shift;

   my $instantiated_module = $this->module();
   my $proj = $this->parent_module()->project();
   if (!$instantiated_module->name())
   {
      my $module_name = $this->_module_name();
      my $module_from_project = $proj
          ->get_module_by_name($module_name)
              or &ribbit
                  ("could not find a module named ",
                   "($module_name) in the project");
      $this->module($module_from_project) ;
   }


   $this->module()->project($proj);
   $this->module()->update();
}






=item I<update_port_map()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update_port_map
{
   my $this = shift;
   if ($this->_module_set())
   {
      my $e_pm = $this->_expression_port_map();
      my $module_ref = $this->module_ref();


      foreach my $output ($module_ref->get_output_names())
      {
         $this->add_port_of_direction($output, 'output');
      }

      foreach my $input ($module_ref->get_input_names())
      {
         $this->add_port_of_direction($input, 'input');
      }


      foreach my $port_name (keys (%$e_pm))
      {
         if (!$module_ref->is_port($port_name))
         {
            $this->remove_port($port_name);
         }
      }
   }
}



=item I<port_map_bone_pile()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub port_map_bone_pile
{
   my $this = shift;

   my $port_map_bone_pile = $this->_port_map_bone_pile();

   if (@_ == 1)
   {
      return $port_map_bone_pile->{$_[0]};
   }
   elsif (@_ > 1)
   {
      ((@_ % 2) == 0) || &ribbit ("@_ confusing\n");
      my $key;
      my $value;

      while (@_)
      {
         $key = shift;
         $value = shift;
         $port_map_bone_pile->{$key} = $value;
      }

   }
   return $port_map_bone_pile;
}



=item I<to_ptf()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_ptf
{
    my $this = shift;
    $this->SUPER::to_ptf(@_);
    my $module = $this->module();

    return $module->to_ptf(@_);
}

sub _get_toplevel_inst_info
{
  my $this = shift;
  my $suffix = shift;
  my $dir = $this->module()->project()->_system_directory();

  my $module_name = $this->_module_name();
  my $instance_name = $module_name . "_inst";
  my $file_name = $dir . "/" . $instance_name . $suffix;
  return ($file_name, $module_name, $instance_name);
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
   my $this  = shift;
   my $indent = shift;

   $this->_module_to_verilog();

   my $incremental_indent = $this->indent();

   my $comment = $this->comment();
   
   my $module = $this->module() or 
       &ribbit ("$this does not have a module associated with it");

   my $module_name = $module->name() or &ribbit 
       ("module $module has no name associated with it\n");

   my @ports = sort($module->_get_port_names());
   return unless @ports;
   my $instance_name = $this->setup_name();

   my $vs;
   $vs .= $this->string_to_verilog_comment($indent, $comment) if ($comment);
   $vs .= $indent.
       "$module_name $instance_name\n".
           "$indent$incremental_indent\(\n";

   my $p_port_map = $this->_expression_port_map();

   my @port_list;
   my $port_string_width = $module->_get_sizeof_biggest_port_name();

   foreach my $port (@ports) 
   {
      my $xform = $p_port_map->{$port};
      if ($xform eq "")
      {



         $xform = e_expression->new($port);

      }

      my $verilog = $xform->to_verilog();

      if ($this->port_map($port) =~ /^open$/i)
      {
         if ($this->suppress_open_ports())
         {
            next;
         }
         $verilog = "";
      }
         push (@port_list, sprintf 
               ("$indent$incremental_indent  \.".
                "%-${port_string_width}s (%s)",
                $port, $verilog)
               );
   }

   $vs .= join (",\n", @port_list)."\n";
   $vs .= "$indent$incremental_indent\)\;\n";

   $vs .= $this->_verilog_defparam($indent);
   $vs .= "\n";

   if ($this->name() eq 'DUT')
   {
      $this->_print_toplevel_inst(
        $vs, 
        '.v', 
      );
   }

   return ($vs);
}



=item I<_verilog_defparam()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _verilog_defparam
{
   my $this = shift;
   my $indent = shift;


   my $def_param = $this->parameter_map();
   my @parameters = sort (keys %{$def_param});
   my $vs;
   my $instance_name = $this->name();

   if ((@parameters) && !@{$this->declare_parameters_as_variables()}) 
   {
      my $module = $this->module();
      my $module_name = $module->name();
      
      $vs .= "${indent}defparam ";
      my $dp_string;
	foreach my $parameter (sort (@parameters))
	  {

         my $e_param = $module->get_object_by_name($parameter)
             or &ribbit 
               ("could not find parameter $parameter in module $module_name");
         my $value = $$def_param{$parameter};

         $value =~ s/\"//g;







         $value = "\"$value\""
             if ($e_param->type() =~ /^STRING$/i
             or $e_param->type() =~ /^STD_LOGIC_VECTOR/i);
         $dp_string .= "$instance_name\.$parameter ".
             "\= $value\,\n$indent".(" " x 9);
      }
      

      $dp_string =~ s/\,\s*$/\;\n/s;

      $vs .= $dp_string;
   }
   return ($vs);
}

sub _print_toplevel_inst
{
  my $this = shift;
  my ($vs, $hdl_suffix,) = @_;

  my ($file_name, $module_name, $instance_name) =
    $this->_get_toplevel_inst_info($hdl_suffix);
  $vs =~ s/Set us up the Dut/Example instantiation for system '$module_name'/m;





  $vs =~ s/DUT/$instance_name/m;

  if (open(FILE, ">$file_name"))
  {
    print FILE $vs;
    close FILE;
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
   my $params_ok = shift;


   my $def_param = $this->parameter_map();
   my @parameters = keys (%{$def_param});  

   my $incremental_indent = $this->indent();

   my $module = $this->module() or 
       &ribbit ("$this does not have a module associated with it");

   $this->_module_to_vhdl();
   my @ports = sort($module->_get_port_names());
   return unless @ports;

   my $module_name = $module->name() or &ribbit 
       ("module $module has no name associated with it\n");

   my $instance_name = $this->setup_name();




   my $comment = $this->comment();

   my $vs;
   $vs .= $this->string_to_vhdl_comment($indent, $comment) if ($comment);
   $vs .= $indent.
       "$instance_name : $module_name";   

   $vs .= "\n";

   my $port_indent = "$indent$incremental_indent$incremental_indent";


   my $def_param = $this->parameter_map();
   my @parameters = sort (keys (%{$def_param}));
   if (@parameters) {
      $vs .= "$indent${incremental_indent}generic map\(\n";

      $vs .= "$port_indent";
      my @parameter_list;

      my %do_not_quote = map {$_ => 1}
	@{$this->declare_parameters_as_variables()};

      foreach my $parameter (sort (@parameters))
      {

         my $e_param = $module->get_object_by_name($parameter)
             or &ribbit 
                 ("no such parameter $parameter in $module_name");
         my $value = $def_param->{$parameter};
         $value =~ s/\"//g;
         $value = "\"$value\""
             if (($e_param->type() =~ /^STRING$/i
               or $e_param->type() =~ /^STD_LOGIC_VECTOR/i) # see other dvb2004 note about STRING
		       && !$do_not_quote{$parameter});
         push (@parameter_list, "$parameter \=\> $value");
      }
      $vs .= join (",\n$port_indent",@parameter_list);
      $vs .= "\n$indent$incremental_indent\)\n";
   }

   my $p_port_map = $this->_expression_port_map();

   my @port_list;
   $vs .= "$indent${incremental_indent}port map\(\n$port_indent";

   my $suppress_open_ports = $this->suppress_open_ports();
   foreach my $output (sort ($module->get_output_names())) {
      my $xform = $$p_port_map{$output};

      unless ($suppress_open_ports && 
              ($this->port_map($output) eq 'open'))
      {
          push (@port_list, 
                $this->vhdl_match_output_port_widths($output,$xform) 
                );
      }
   }

   foreach my $input (sort ($module->get_input_names ())) 
   {
      my $xform = $$p_port_map{$input};

      unless ($suppress_open_ports && 
              ($this->port_map($input) eq 'open'))
      {
          push (@port_list, 
                $this->vhdl_match_input_port_widths($input,$xform)
                );
      }
   }     
   $vs .= join (",\n$port_indent", @port_list)."\n";
   $vs .= "$indent$incremental_indent\)\;\n";
   
   $vs .= "\n";
   

   foreach my $var (@{$this->weirdo_vhdl_assignments()})
   {
     $vs .= $var->to_vhdl($indent);
   }
   $vs .= "\n";

   if ($this->name() eq 'DUT')
   {
      $this->_print_toplevel_inst(
        $vs, 
        '.vhd', 
      );
   }
   return ($vs);
}



=item I<_module_to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _module_to_vhdl
{
   my $this = shift;
   my $module = $this->module();
   if (!($module->_hdl_generated())) 
   {
      if ($this->verilog_override())
      {
         $this->project->first_explicitly_verilog_module
             ($module);
         $module->to_verilog();
      }
      else
      {
         $module->to_vhdl();
      }

   }
}



=item I<_module_to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _module_to_verilog
{
   my $this = shift;
   my $module = $this->module();
   if (!($module->_hdl_generated())) {
      $module->to_verilog();
   }

}



=item I<vhdl_match_output_port_widths()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_match_output_port_widths
{
   my $this  = shift;

   my ($output, $what_output_wires_to) = @_;
   my @port_list;
   
   my $signal = $this->module()->get_signal_by_name($output);
   my $vhdl_record_name = $signal->vhdl_record_name();
   
   


   
   my $dotted_output = $output;
   my $vhdl_expr_prefix = "";
   if($vhdl_record_name)
   {


      $dotted_output = "$vhdl_record_name.$dotted_output";
      $vhdl_expr_prefix = $vhdl_record_name . ".";
      $vhdl_expr_prefix =~ tr/\./_/;
   }
   
   my $signal_width = $signal->width();
   my $signal_is_vector = 
       $signal->declare_one_bit_as_std_logic_vector();

   my $vhdl_expr;       # = $what_output_wires_to->to_vhdl();
   my $expression_type; # = $what_output_wires_to->vhdl_type();

   my $output_sig = $this->module()->get_signal_by_name($output)
     or &ribbit ("big problemo, no signal named $output");

   my $output_type;
   $output_type = "stdulogic"
     if ($output_sig->_is_inout());

   if (!$what_output_wires_to)
     {
       if ($this->port_map($output) =~ /^open$/)
	 {
	   push (@port_list, "$dotted_output => open");	   
	 }
       else
	 {
	   &ribbit ($this->name(),"never saw output map for $output\n");
	 }
     }
   else
     {
       $vhdl_expr = $what_output_wires_to->to_vhdl();
       $expression_type = $what_output_wires_to->vhdl_type();

       if (($expression_type eq "boolean") ||
	   ($signal_width <= $expression_type) ||
	   $output_type
	  )
	 {

	   $vhdl_expr =
               $what_output_wires_to->to_vhdl($signal_width,$output_type);

           if ($signal_is_vector && ($signal_width == 1))
           {
              $dotted_output .= '(0)';
           }
	   push (@port_list, "$dotted_output => $vhdl_expr_prefix$vhdl_expr");
	 }
       else
	 {
	   my $msb = $signal_width - 1;
	   my $expression_msb = $expression_type - 1;

	   if ($expression_msb == 0) {

	     push (@port_list, 
		   "$dotted_output ($msb DOWNTO $expression_type) => open",
		   "$dotted_output (0)     => $vhdl_expr_prefix$vhdl_expr"
		  );
	   } elsif ($msb == 0) {
             push (@port_list, "$dotted_output => open");
           } else {

	     push (@port_list, 
		   "$dotted_output ($msb DOWNTO $expression_type) => open",
		   "$dotted_output ($expression_msb DOWNTO 0)     => $vhdl_expr_prefix$vhdl_expr"
		  );
	   }
	 }
     }
   return (@port_list);
}



=item I<vhdl_match_input_port_widths()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_match_input_port_widths
{
   my $this  = shift;
   my @port_list;

   my ($input,$what_wires_to_input) = @_;

   my $module;
   $module = $this->module()
       or &ribbit ("$this, no module ($module)\n");
   my $signal = $module->get_signal_by_name($input);
   my $input_statement;

   my $vhdl_record_name = $signal->vhdl_record_name();
   


   
   my $dotted_input = $input;
   my $vhdl_expr_prefix = "";
   if($vhdl_record_name)
   {


      $dotted_input = "$vhdl_record_name.$dotted_input";
      $vhdl_expr_prefix = $vhdl_record_name . ".";
      $vhdl_expr_prefix =~ tr/\./_/;
   }


   if(!$what_wires_to_input)
     {
       if ($this->port_map($input) =~ /^open$/)
	 {
	   push (@port_list, "$dotted_input => open");
	 }
       else
	 {
	   &ribbit ($this->name(),"never saw input map for $input\n");
	 }
    }
   else
     {
       if ($signal)
	 {
	   my $signal_width = $signal->width();
	   my $resolved_bad_sig = $this->vhdl_resolved_naughty_module_inputs
                      ($what_wires_to_input, $signal_width, $module);

	   if ($resolved_bad_sig)
	     {
	       $input_statement = $resolved_bad_sig;
	     }
	   else
	     {
	       $input_statement = $what_wires_to_input->to_vhdl($signal_width);
	     }

           if (($signal_width == 1) &&
               $signal->declare_one_bit_as_std_logic_vector())
           {
              $dotted_input.= '(0)';
           }
               


        }
       else
	 {
	   my $module_name = $module->name();
	   my $error_string = qq
	     [
	      $input is not declared in $module_name. 
              Ports need to be declared in order to match port widths.
	     ];
	   $error_string =~ s/^\s*//mg;
	   &goldfish ($error_string); 

	   $input_statement = $what_wires_to_input->to_vhdl();

	 }
       push(@port_list, "$dotted_input => $vhdl_expr_prefix$input_statement");
     }
   return (@port_list);
}



=item I<get_signal_from_instance_path()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_signal_from_instance_path
{
   my $this  = shift;
   &is_blessed($this) or
       &ribbit ("this ($this) not understood");

   my $sp_ref = shift or &ribbit ("no sp_ref");
   my $signal_name = shift or &ribbit ("no signal_name");

   my @signal_path = @$sp_ref;

   my $parent = $this->parent();
   my $name = $this->name();

   if (scalar (@signal_path)) {
      my $child = shift (@signal_path);
      $signal_name = $child->get_signal_from_instance_path
          ([@signal_path], $signal_name);
   }





   my $module = $this->module();


   my $instantiated_signal_object =
       $this->module()->get_object_by_name($signal_name)
           or &ribbit ("signal ($signal_name) does not exist in module ",
                       $module->name(),"\n","known signals are\n",
                       join ("\n",$module->get_signal_names()));


   my @outputs = $module->get_output_names();
   my @inputs  = $module->get_input_names ();

   foreach my $port (@outputs, @inputs) {
      if ($port eq $signal_name) {
         my $port_map = $this->port_map();

         if ($port_map->{$port} ne "") {
            $port = $port_map->{$port};
         }

         return ($port);
      }
   }




   $instantiated_signal_object->export(1);


   if ($parent->get_object_by_name($signal_name)) {
      my $exclusive_name = $this->parent->_project()
          ->get_exclusive_name($name."_".$signal_name);
      $this->port_map()->{$signal_name} = $exclusive_name;
      $signal_name = $exclusive_name;


   }


   $this->_copy_signal_to_parent($instantiated_signal_object,
                                 $signal_name,
                                 "out"
                                 );

   my $parent_check = $parent->get_object_by_name
       ($signal_name) or &ribbit ("could not find $signal_name in ",
                                  $parent->name(),"\n");

   return ($signal_name);
}



=item I<project()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub project
{
   my $this = shift;

   my $return = $this->SUPER::project(@_);
   if (@_)
   {
      $this->set_module_project(@_);
   }
   return $return;
}



=item I<set_module_project()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub set_module_project
{
   my $this = shift;

   my $mod = $this->module();
   $mod->project(@_)
       unless ($mod->isa_dummy());
}




=item I<vhdl_declare_component_if_needed()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_declare_component_if_needed
{
   my $this = shift;
   my $pm = $this->parent_module();

   my $module = $this->module();

   my $tag = $this->tag();

   my $declared_components_hash = $pm->
       _already_declared_components_by_module_name();

   my $module_name = $module->name();
   my $existing_tag = $declared_components_hash->{$module_name};

   if(($existing_tag eq 'normal') || ($existing_tag eq $tag))
   {
      return;
   }
   else
   {
      $declared_components_hash->{$module_name} = $tag;
      my @inhibited_sigs;
      if ($this->suppress_open_ports())
      {
          my $port_map = $this->port_map();
          foreach my $port (keys %{$port_map})
          {
              if ($port_map->{$port} eq 'open')
              {
                  push (@inhibited_sigs, $port);
              }
          }
      }
      return $module->vhdl_declare_module("component", 
                                          \@inhibited_sigs)."\n";
   }
}



=item I<vhdl_resolved_naughty_module_inputs()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_resolved_naughty_module_inputs
{
  my $this = shift;
  my $what_wires_here = shift;
  my $width = shift;
  my $module = shift;

  my $pm = $this->parent_module();
  my $vhdl_input_statement = $what_wires_here->to_vhdl();
  
  if($vhdl_input_statement !~ /^\s*(\w+|'[01]'|"[01]{2,}")\s*$/ )
  { 
    my $new_signal_name =
      $pm->get_exclusive_name("module_input");

    my $new_signal = e_signal->new([$new_signal_name, $width, 0, 1]);

    $new_signal->tag($this->tag());
    $pm->update_item($new_signal);

    my $new_assignment =  e_assign->new({
					 lhs => $new_signal,
					 rhs => $what_wires_here,
					});

    $new_assignment->update($this);

    push(@{$this->weirdo_vhdl_assignments()}, $new_assignment);
    
    

    return ($new_signal_name);
  }  
  return;
}




=item I<get_modelsim_list_info()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_modelsim_list_info
{
  my $this = shift;
  ribbit if not $this;
  my $mod = $this->module();
  ribbit if not $mod;

  return $mod->get_modelsim_list_info();
}



=item I<determine_biggest_non_copied_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub determine_biggest_non_copied_signals
{
   my $this = shift;
   return $this->_module_ref()->determine_biggest_non_copied_signals(@_);
}



=item I<get_module_port_names_which_match_signal()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_module_port_names_which_match_signal
{
   my $this = shift;
   my $signal_name = shift;
   my @ports;
   foreach my $port (keys %{$this->port_map()})
   {
      if ($this->port_map($port) eq $signal_name)
      {
         push (@ports, $port);
      }
   }
   return @ports;
}



=item I<make_linked_signal_conduit_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_linked_signal_conduit_list
{
   my $this = shift;
   my $signal_name = shift;

   my $instanced_module = $this->_module_ref() 
       || &ribbit ("no instance module\n");

   my $instantiated_module_signal;

   my @linked_signals;
   my @ports;
   foreach my $port ($this->get_module_port_names_which_match_signal
                     ($signal_name))
   {
      my $expression = $this->_expression_port_map()->{$port};

      if (!$expression)
      {




         next;
         &ribbit ("No expression for $port\n");
      }
      $expression->conduit_width(0);
      push (@ports,$port);
   }

   return map
   {$instanced_module->
        make_linked_signal_conduit_list
        ($_)} @ports;
}



=item I<identify_signal_widths()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub identify_signal_widths
{
   my $this = shift;

   foreach my $expr (values (%{$this->port_map_bone_pile()}))
   {
      $expr->conduit_width(0);
   }
   $this->_module_ref()->identify_signal_widths();
}



=item I<identify_inout_signal()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub identify_inout_signal
{
   my $this = shift;
   my $signal_name  = shift;

   my @signals;
   my $module = $this->module();
   foreach my $port ($this->get_module_port_names_which_match_signal
                     ($signal_name))
   {
      push (@signals, $module->identify_inout_signal($port));
   }
   return @signals;
}



=item I<check_x()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub check_x
{
   my $this = shift;
   my $signal_name = shift;

   my $module = $this->module();
   foreach my $port ($this->get_module_port_names_which_match_signal
                     ($signal_name))
   {
      $module->check_x($port);
   }
}



=item I<get_tcl_commands()>

This subroutine is run after the entire database has been created and fleshed
out, the HDL spat out, and everything else done.  
It queries all objects for content to add to the quartus-run tcl file(s).

=cut

sub get_tcl_commands
{
  my $this  = shift;
  return $this->module()->get_tcl_commands();
}

__PACKAGE__->DONE;

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


