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

e_blind_instance - description of the module goes here ...

=head1 SYNOPSIS

The e_blind_instance class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_blind_instance;
use e_blind_instance_port;
use e_instance;
@ISA = ("e_instance");

use strict;
use europa_utils;







my %fields = (
              _in_port_map => {},
              _out_port_map => {},
	      _inout_port_map => {},
              use_sim_models => 0,
              std_logic_vector_signals => [],
	      _port_default_values => {},
	      generate_component_package => 0,
	      generate_inline_component_declaration => 1,
	      _use_vlog_rtl_param => 0,
	      _use_generated_component => 1,
	      );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub module
{
   my $this = shift;
   return $this->_module_name(@_);
}



=item I<add_signals_to_port_map()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_signals_to_port_map
{
   my $this = shift;
   my $direction = shift;
   my $set_this  = shift;
   my @set_these = @$set_this;

   my $expression_port_map = $this->_expression_port_map();
   (@set_these % 2 == 0) or 
       &ribbit ("odd number of items for port_map (@_)\n");

   my $key;
   my $value;

   while (($key, $value, @set_these) = @set_these)
   {
      my $expression = $expression_port_map->{$key};
      if (!$expression)
      {
         $expression = e_expression->new();
         $expression->direction($direction);
         $expression->parent($this);

         $expression_port_map->{$key} = $expression;
         $this->setup_port_map_expression($key);
      }

      $expression->expression($value);

      my $port_map = $this->port_map();


      $port_map->{$key} = $expression->expression();
   }
}



=item I<setup_port_map_expression()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub setup_port_map_expression
{


   return;
}



=item I<in_port_map()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub in_port_map
{
   my $this = shift;

   my $in_port_map = $this->_in_port_map();
   if (@_)
   {
      my $num_args = scalar (@_);
      my ($first_arg) =  @_;

      if ($num_args > 1)
      {
         my @set_these = @_;
         $this->add_signals_to_port_map
             ('input', \@set_these);
         my $key;
         my $value;
         while (($key, $value, @set_these) = @set_these)
         {
            $in_port_map->{$key} = $value;
         }
      }
      elsif (ref ($first_arg) eq "HASH")
      {
         $in_port_map = $this->in_port_map(%$first_arg);
      }
      else #first arg is a scalar which points to port map.
      {
         $in_port_map =  $in_port_map->{$first_arg};
      }
   }

   return $in_port_map;
}



=item I<inout_port_map()>


=cut

sub inout_port_map
{
   my $this = shift;

   my $inout_port_map = $this->_inout_port_map();
   if (@_)
   {
      my $num_args = scalar (@_);
      my $first_arg = $_[0];
      if ($num_args > 1)
      {
         ($num_args % 2 == 0) or 
             &ribbit ("odd number of items for port_map (@_)\n");

         my @set_these = @_;
         $this->add_signals_to_port_map
             ('output', \@set_these);
         my $key;
         my $value;
         while (($key, $value, @set_these) = @set_these)
         {
            $inout_port_map->{$key} = $value;
         }
      }
      elsif (ref ($first_arg) eq "HASH")
      {
         $inout_port_map = $this->inout_port_map(%$first_arg);
      }
      else #first arg is a scalar which points to port map.
      {
         $inout_port_map =  $inout_port_map->{$first_arg};
      }
   }

   return $inout_port_map;
}



=item I<out_port_map()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub out_port_map
{
   my $this = shift;

   my $out_port_map = $this->_out_port_map();
   if (@_)
   {
      my $num_args = scalar (@_);
      my ($first_arg) =  @_;

      if ($num_args > 1)
      {
         my @set_these = @_;
         $this->add_signals_to_port_map
             ('output', \@set_these);
         my $key;
         my $value;
         while (($key, $value, @set_these) = @set_these)
         {
            $out_port_map->{$key} = $value;
         }
      }
      elsif (ref ($first_arg) eq "HASH")
      {
         $out_port_map = $this->out_port_map(%$first_arg);
      }
      else #first arg is a scalar which points to port map.
      {
         $out_port_map =  $out_port_map->{$first_arg};
      }
   }

   return $out_port_map;
}



=item I<identify_inout_signal()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub identify_inout_signal
{
   my $this = shift;
   my $signal_name  = shift;

   my $hash = $this->_inout_port_map();
   my %reverse = reverse %$hash;
   my $signal_is_inout = $reverse{$signal_name} ne '';

   if ($signal_is_inout)
   {
     my $parent_signal = $this->parent()->get_signal_by_name($signal_name);
     $parent_signal->_is_inout(1);
     return $parent_signal;
   }
   


   return ();
}



=item I<set_module_project()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub set_module_project
{
   my $this = shift;
   return;
}



=item I<port_map()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub port_map
{



   

   
   my $this = shift;
   return $this->SUPER::port_map(@_);
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
  my $this  = shift;

  my $indent = shift;

  my $incremental_indent = $this->indent();

  my $module_name = $this->_module_name();

  my $instance_name = $this->name() || 
      $this->parent_module()->get_exclusive_name("the_".$module_name);

  my $vs = $indent.
      "$module_name $instance_name\n".
          "$indent$incremental_indent\(\n";

  my @port_list;
  foreach my $port (sort (keys (%{$this->_expression_port_map()})))
  {
     my $xform = $this->_expression_port_map()->{$port};
     push (@port_list, "$indent$incremental_indent  \.$port (".
           $xform->to_verilog().
           ")");
  }

  $vs .= join (",\n", @port_list)."\n";
  $vs .= "$indent$incremental_indent\)\;\n";
  $vs .= "\n";

  my $def_param = $this->parameter_map();
  my @parameters = keys %{$def_param};
  if (@parameters) {
    $vs .= "${indent}defparam ";
    my $dp_string;
    foreach my $parameter (sort (@parameters)) {
       $dp_string .= "$instance_name\.$parameter ".
           "\= $$def_param{$parameter}\,\n$indent".(" " x 9);
    }


    $dp_string =~ s/\,\s*$/\;\n/s;

    $vs .= $dp_string;
  }
  $vs .= "\n";


  return ($vs);
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
  my $this  = shift;

  my $indent = shift;

  my $incremental_indent = $this->indent();

  my $module_name = $this->_module_name() or 
    ("module has no name associated with it\n");

  my $instance_name = $this->name() || 
      $this->parent_module()->get_exclusive_name("the_".$module_name);

  my $library_declaration = "";#"entity work\."

  my $vs = $indent.
      "$instance_name : $library_declaration$module_name\n";#(europa)\n"

  my $port_indent = "$indent$incremental_indent$incremental_indent";

  my $p_port_map = $this->port_map();

  my @port_list;


   my $def_param = $this->parameter_map();
   my @parameters = sort (keys (%{$def_param}));
   if (@parameters) {
      $vs .= "$indent${incremental_indent}generic map\(\n";

      $vs .= "$port_indent";
      my @parameter_list;

      foreach my $parameter (@parameters) {
         push (@parameter_list, "$parameter \=\> $def_param->{$parameter}");
      }
      $vs .= join (",\n$port_indent",@parameter_list);
      $vs .= "\n$indent$incremental_indent\)\n";
   }

  foreach my $port (sort(keys (%{$this->_expression_port_map()})))
  {
     my $xform = $this->_expression_port_map()->{$port};
     my $xform_vhdl = $xform->to_vhdl();
     if (grep {$_ eq $port} @{$this->std_logic_vector_signals()})
     {
        if ($xform->width() == 1)
        {
           if ($xform->direction() =~ /^out/)
           {
              $port = $port.'(0)';
           }
           else
           {
              $xform_vhdl = 'A_TOSTDLOGICVECTOR('.
                  $xform_vhdl. ')';
           }
        }
     }
     push (@port_list, "$indent$incremental_indent  $port => $xform_vhdl");
  }
  $vs .= "$indent${incremental_indent}port map\(\n$port_indent";
  $vs .= join (",\n$port_indent", @port_list)."\n";
  $vs .= "$indent$incremental_indent\)\;\n";
  $vs .= "\n";


  if ($this->use_sim_models())
  {
     my $parent_module = $this->parent_module();
     $parent_module->vhdl_libraries()->{altera_mf} = 'all';
     $parent_module->vhdl_libraries()->{lpm} = 'all';
  }
  
  return ($vs);
}



=item I<to_ptf()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_ptf
{
   my $this = shift;
   return;
}



=item I<vhdl_declare_component_if_needed()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_declare_component_if_needed
{
   my $this = shift;
   my $pm = $this->parent_module();
   my $module_name = $this->_module_name() or 
       ("module has no name associated with it\n");

   my $vs;

   my $tag = $this->tag();

   my $declared_components_hash = $pm->
       _already_declared_components_by_module_name();

   my $existing_tag = $declared_components_hash->{$module_name};

   if(!$this->_use_generated_component() ||
      ($existing_tag eq 'normal') || ($existing_tag eq $tag)
      )
   {
      return;
   }
   else
   {
      $declared_components_hash->{$module_name} = $tag;

      return ($this->vhdl_declare_component());
   }
}



=item I<vhdl_declare_component()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_declare_component
{
   my $this = shift;
   my $module_name = $this->_module_name() or 
       ("module has no name associated with it\n");
   my $vs = "  component $module_name is\n";
   my $internal_vs = $this->_figure_out_generic_map();
   $internal_vs   .= $this->_figure_out_port_map();
   $internal_vs    =~ s/\n/\n    /g;
   $vs .= "$internal_vs\n  end component $module_name;\n";

   if($this->generate_component_package())
   {
      my $output_file = $this->parent_module()->project()->_system_directory().$this->module()."_pack";
      my $package_name = $this->module()."_pack";
      my $output_string;
      
      $output_string = "library ieee;\nuse ieee.std_logic_1164.all;\n
			 use ieee.std_logic_unsigned.all;\nuse ieee.numeric_std.all;\n\n
			 package $package_name is\n\n";
      
      $output_string .= $vs."\n\n\n end $package_name;";
      open (GENERATE_PACKAGE, "> $output_file.vhd")
          or &ribbit ("Could not open $output_file ($!)\n");
      print GENERATE_PACKAGE $output_string;
      close (GENERATE_PACKAGE);
   }

   $vs = '' unless ($this->generate_inline_component_declaration());

   return ($vs);
}



=item I<_figure_out_generic_map()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _figure_out_generic_map
{
   my $this = shift;
   my $pm_hash = $this->parameter_map();
   my @pm_keys = sort (keys (%$pm_hash));

   return unless (@pm_keys);

   my $vs = "GENERIC (\n  ";
   my @parameter_declarations;

   foreach my $key (sort (@pm_keys))
   {
      my $value = $pm_hash->{$key};
      my $type = ($value =~ /^\d+$/)? "NATURAL": "STRING";

      push (@parameter_declarations,
            e_parameter->new
            ({
               name      => $key,
               vhdl_type => $type,
               parent    => $this,
            })->to_vhdl()
            );
   }
   $vs .= join (";\n    ", @parameter_declarations);
   $vs .= "\n  );\n";

   return ($vs);
}



=item I<_figure_out_port_map()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _figure_out_port_map
{
   my $this = shift;

   my $out_hash = $this->out_port_map();
   my @out_ports = sort (keys (%$out_hash));

   my $in_hash = $this->in_port_map();
   my @in_ports = sort (keys (%$in_hash));

   my $inout_hash = $this->inout_port_map();

   my $map = $this->_expression_port_map();
   my @in_ports  = grep {$map->{$_}->is_destination()} keys(%$map);
   my @out_ports = grep {$map->{$_}->is_source()} keys (%$map);
       
   if (@in_ports,@out_ports)
   {
      my @port_declarations;
      foreach my $out (@out_ports)
      {
         my $is_slv_bit = grep {$_ eq $out}
         @{$this->std_logic_vector_signals()};

         my $width = $this->_expression_port_map()->{$out}->width();
         my $direction = $inout_hash->{$out}? "inout":"out";
         push (@port_declarations,
               e_blind_instance_port->new
               ({name      => $out,
                 width     => $width, 
                 direction => $direction,
                 declare_one_bit_as_std_logic_vector => 
                     $is_slv_bit,
               })->to_vhdl()
               );
      }
      foreach my $in (@in_ports)
      {
         my $is_slv_bit = grep {$_ eq $in}
         @{$this->std_logic_vector_signals()};

         my $width = $this->_expression_port_map()->{$in}->width();
         push (@port_declarations,
               e_blind_instance_port->new
               ({name      => $in,
                 width     => $width, 
                 direction => "in",
                 declare_one_bit_as_std_logic_vector => 
                     $is_slv_bit,
               })->to_vhdl()
               );
      }
      my $vs = "PORT (\n";
      $vs .= join (";\n    ", @port_declarations);
      $vs .= "\n  );";
      return ($vs);
   }
   else
   {
      my $module_name = $this->_module_name() or 
          ("module has no name associated with it\n");

      &goldfish ("$module_name has a blind_instance with no ports at
      all\n");
      return;
   }
}



=item I<determine_biggest_non_copied_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub determine_biggest_non_copied_signals
{
   return;
}



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
   my $this = shift;
   $this->parent(@_);
   return;
}

=item I<get_tcl_commands()>

This subroutine is run after the entire database has been created and fleshed
out, the HDL spat out, and everything else done.  
It queries all objects for content to add to the quartus-run tcl file(s).

=cut

sub get_tcl_commands
{
  my $this  = shift;

  return; 
}

__PACKAGE__->DONE();

=back

=cut

=head1 EXAMPLE

Here is a usage example ...

=head1 AUTHOR

Santa Cruz Technology Center

=head1 BUGS AND LIMITATIONS

list them here ...

=head1 SEE ALSO

The inherited class e_instance

=begin html

<A HREF="e_instance.html">e_instance</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
