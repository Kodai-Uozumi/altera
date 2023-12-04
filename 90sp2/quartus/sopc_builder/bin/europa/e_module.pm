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

e_module - description of the module goes here ...

=head1 SYNOPSIS

The e_module class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_module;

use europa_global_project;
use e_module_database;
use europa_utils;

@ISA = ("e_module_database");
use strict;







my %fields = (
              comment               => "",
              _additional_support => 
              {
                 _i_need_a_fixup => "0",
                 _stupid_vhdl_path_needed_for_simulation => "",
              },
              overriding_vhdl_simulation => "",
              _contents              => [],
                _updated_contents     => [],
                do_black_box          => 0,
                do_ptf                => 1, 
                _hdl_generated        => 0,
                _virtual_defs_written => 0,  # for ModelSim virtual defs.

                _discovery_done     => 0,
                _content_hash       => {},# unique content ref cache.
                _updated            => 0,
                _vhdl_string   => [],
                _vhdl_file     => [],
                _explicitly_empty_module => 0,  # Disables some error checking.
                add_user_comments   => 0,
                vhdl_libraries      => 
                {
                  ieee =>
                  {
                    std_logic_1164 => "all",
                    std_logic_arith => "all",
                    std_logic_unsigned => "all",
                  },
                  altera =>
                  {
                    altera_europa_support_lib => "all",
                  }
                },
                _already_declared_components_by_module_name => {},
                _simulation_string => [],
                _synthesis_string  => [],
                _normal_string     => [],
                _compilation_string=> [],

                _attribute_hash => {},
                output_file => "",
                _declared_vhdl_record_names => {},   # for managing VHDL record declarations
                _declared_altera_attribute => 0,
              );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );









=item I<name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub name
{
   my $this = shift;

   if (@_)
   {
      my $old_name = $this->SUPER::name();
      $this->_project()->delete_names
          ($old_name)
              if ($old_name);
      my $new_name = $this->SUPER::name(@_);

      return "" if $new_name eq "";  # Happens at initialization-time.
      $this->_project()->add_module($this);
      return ($new_name);
   }
   return ($this->SUPER::name());
}



=item I<_project()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _project
{
   my $this = shift;

   my $old_project = $this->{_project} || $GLOBAL_PROJECT;

   if (@_ && ($_[0] ne $old_project))
   {

      my $new_project = $this->{_project} = $_[0];

      my $name = $this->name();
      if ($name)
      {
         if ($old_project && ($old_project ne $new_project))
         {
            $old_project->delete_names($name);
         }
         $new_project->add_module($this);
      }
      &ribbit ("modified project after update")
          if (@{$this->_updated_contents()});
      foreach my $content (@{$this->contents})
      {
         $content->project($new_project);
      }
      return ($new_project);
   }
   return ($old_project);
}



=item I<project()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub project
{
  my $this = shift;
  return $this->_project(@_);
}




=item I<add_vhdl_libraries()>

Add 1 or more vhdl libraries to the module.

Libraries are strings like "work.my_package.all".

always three parts.
     one.two.three

=cut


sub add_vhdl_libraries
{
    my $this = shift;
    
    while(my $aLibrary = shift)
    {
        my @parts = split(/\./,$aLibrary,3);
        my $partsCount = scalar(@parts);
        my $libraryHashRef = $this->vhdl_libraries(); # starting point

        $$libraryHashRef{$parts[0]}{$parts[1]} = $parts[2];
    }
}





















=item I<add_attribute()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_attribute
{
   my $this = shift;
   my (@name_value_pairs) = (@_);
   while (@name_value_pairs) 
   {
      my $attrib_name  = shift (@name_value_pairs) 
          or &ribbit ("this can't happen");
      my $attrib_name_value = shift (@name_value_pairs);
      if (!$attrib_name_value)
      {
         &ribbit 
             ("expected an even number of items (name/value pairs)".
              "AND expected second item to be hashref");
      }
      if (ref ($attrib_name_value) ne 'HASH')
      {
         my $mod_name = $this->name();

         $attrib_name_value = {$mod_name => $attrib_name_value};
      }

      foreach my $name (keys (%$attrib_name_value))
      {
         $this->_attribute_hash()->{$attrib_name}{$name} = 
             $attrib_name_value->{$name};
      }
   }
}



=item I<get_all_attribute_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_all_attribute_names
{
   my $this = shift;
   &ribbit ("access-only function") if scalar (@_);
   return sort (keys (%{$this->_attribute_hash()}));
}



=item I<_make_verilog_attribute_string()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _make_verilog_attribute_string
{
   my $this = shift;
   &ribbit ("access-only function") if scalar (@_);
   my @result_strings = ("\n");
   foreach my $attrib_name ($this->get_all_attribute_names())
   {
      my $attrib_hash = $this->_attribute_hash()->{$attrib_name};
      foreach my $name (keys (%$attrib_hash))
      {
         my $attrib_value = $attrib_hash->{$name};
         push (@result_strings, 
               "  /* synthesis $attrib_name = \"$attrib_value\" */ ");
      }
   }
   return join ("", @result_strings);
}





=item I<_make_vhdl_attribute_string()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _make_vhdl_attribute_string
{
   my $this = shift;
   my $filter = shift;

   my $module_name = $this->name();
   my @declaration_strings;
   my @value_strings;
   foreach my $attrib_name ($this->get_all_attribute_names())
   {
      my $attrib_name_value = $this->_attribute_hash()->{$attrib_name};

      my $type = 'string';
      my @value_strings = ();
      foreach my $name (sort (keys (%$attrib_name_value)))
      {
         my $value = $attrib_name_value->{$name};


         if (($value =~ /^true$/i) || 
             ($value =~ /^false$/i))
         {
            $type = "boolean";
         }
         else
         {
            $value = '"'.$value.'"';
         }
         my $thing = 'signal';
         if ($name eq $this->name())
         {
            $thing = 'entity';
         }
         push (@value_strings, 
               "attribute $attrib_name of $name : $thing is $value;\n")
             if ($thing eq $filter);
      }

      if (@value_strings)
      {
        if (!$this->_declared_altera_attribute())
        {
          $this->_declared_altera_attribute(1);
          push @declaration_strings, "attribute $attrib_name : $type;\n";
        }
        push @declaration_strings, @value_strings;
      }
   }
   return ''.join ("", @declaration_strings);
}

















=item I<contents()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub contents
{
  my $this             = shift;
  my $new_contents_ref = shift;
  &ribbit ("Too many arguments") if @_;

  if ($new_contents_ref)
  {
     if (@{$this->_contents()}) {



        &goldfish ("replacing contents for module '", $this->name(), "'\n");
     }


     $this->_content_hash({});
     $this->_contents ([]);


     $this->add_contents(@{$new_contents_ref});  
  }




  if ($this->{contents})
  {
     my $bad_contents = $this->{contents};
     $this->{contents} = '';
     $this->add_contents(@$bad_contents);
  }

  return $this->_contents();
}











=item I<add_contents()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_contents
{
   my $this  = shift;


   foreach my $thing (@_) 
   {

     &ribbit ("$thing is not a valid object to put in a module.\n")
       unless (&is_blessed($thing) &&
               $thing->isa("e_thing_that_can_go_in_a_module") );


     my $id_code = scalar ($thing);
     next if exists ($this->_content_hash()->{$id_code});




     $this->_content_hash()->{$id_code}++;
     $thing->parent($this);
     $thing->project($this->project());
   }


   if ($this->_updated())
   {
      foreach my $thing (@_)
      {
         $this->update_item($thing);
      }
   }
   else
   {
      push (@{$this->contents()}, @_);
   }


   return 1;
}















=item I<_discover_internal_modules()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _discover_internal_modules
{
  my $this           = shift;
  my $parent_project = shift;
  return if ($this->_discovery_done);
  $this->_discovery_done(1);

  foreach my $content (@{$this->contents()}) {
    next unless $content->isa ("e_instance");

    my $candidate = $content->_module_ref();
    next if $candidate->isa_dummy();

    my $candidate_name = $candidate->name();

    next
        if (!$candidate_name);


    my $preexisting =  $parent_project->get_module_by_name($candidate_name);

    &ribbit ("Two different modules with the same name ('", $candidate->name(), "')")
      if ($preexisting && ($preexisting != $candidate));




    $parent_project->add_module($candidate);
    $candidate->_discover_internal_modules($parent_project);
  }
}



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
   my $this  = shift;

   my $contents = $this->contents();
   while (my $content = shift (@$contents))
   {
      $this->update_item($content);
   }

   $this->_updated(1);
}








=item I<update_item()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update_item
{
   my $this = shift;
   my $thing_to_update = shift or &ribbit ("no thing to update");


   $thing_to_update->update($this);
   push (@{$this->_updated_contents()},$thing_to_update);   
}



=item I<_wire_up_sourceless_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _wire_up_sourceless_signals
{
   my $this  = shift;

   foreach my $free_signal ($this->get_signal_names())
   {
      my $module_name = $this->name();
      my @sources = $this->get_signal_sources_by_name
          ($free_signal);

      next if (@sources);
      my $e_sig = $this->get_object_by_name($free_signal);
      next unless ($e_sig);

      my $type  = $e_sig->type();
      next unless ($type);      

      next unless (&is_blessed($e_sig) && 
                   $e_sig->isa("e_self_wiring_signal"));



      my $mux = $e_sig->mux() or next;

      my @mux_table = ();
      foreach my $signal_name ($this->get_signals_by_type($type))
      {
         my @sig_sources = $this->get_signal_sources_by_name
             ($signal_name);

         next if ($signal_name eq $free_signal);
         next unless (@sig_sources);

         my $signal = $this->get_object_by_name($signal_name) or 
             die ("module ",$this->name(),
                  ": no signal known named $signal_name\n");

         my $select_signal = $signal->select()->expression();
         my @signal_path = @{$signal->_select_path()};

         ($select_signal ne "") or 
         die ("module ",$this->name(),
         ": no select signal ($select_signal) known for $signal_name ",
              "of type ($type)\n");
         
         if (@signal_path && ($select_signal =~ /[a-zA-Z_]/))
         {
            my $instance = shift (@signal_path);
            $select_signal = 
                $instance->get_signal_from_instance_path
                    ([@signal_path],$select_signal);
         }

         push (@mux_table, 
               $select_signal => $signal->name(),
               );
      }
      if (@mux_table)
      {
         $mux->set
             ({
                out => $free_signal,
                table => [@mux_table],
             });
         $this->add_contents($mux);
         $this->update();
      }
   }
}







=item I<declare_and_define_external_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub declare_and_define_external_signals
{
  my $this  = shift;

  my $indent = $this->format()->indent;
  my $paragraph = $this->format()->paragraph;

  my $hdl_string = "(\n$indent";
  my @outputs = $this->get_output_names();
  my @inputs = $this->get_input_names();
  if ($this->language() =~ /verilog/i)
  {
     $hdl_string .= join (",\n$indent",@outputs,@inputs).");\n";

     $hdl_string .= $paragraph;

     foreach my $name (@outputs, @inputs)
     {
        my $signal = $this->get_object_by_name($name);

        $hdl_string .= $indent.
            $signal->to_verilog();
     }
  }
  return ($hdl_string);
}








=item I<verilog_declare_internal_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub verilog_declare_internal_signals
{
  my $this  = shift;
  
  my $indent = shift;

  my $type;
  my $declaration_string;





  foreach my $name (sort ($this->get_output_names(),
                    $this->get_internal_signal_names()
                    ))
  {
     my $source_thing = $this;
     my @sources      = $this->flatten_sources($name);
     $type = "wire";
     my @attribute_strings;
     foreach my $source (@sources)
     {
        if ($source->declare_verilog_register($name))
        {
           $type = "reg";
        }
        push (@attribute_strings, 
              $source->attribute_string($name));
     }
    my $signal = $this->get_object_by_name($name) or &ribbit 
         ("sorry bub, no signal for $name has been specified");

     my $attribute_string = join (';', grep {$_;} @attribute_strings);
     $declaration_string .= $indent . 
         $signal->to_verilog($type, $attribute_string);
  }

  $declaration_string .= $this->print_user_code
      ("//  add your signals and additional architecture here");
  return $declaration_string;
}



=item I<_get_sizeof_biggest_port_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_sizeof_biggest_port_name
{
   my $this = shift;

   my $max_name_size = 1;
   foreach my $port ($this->_get_port_names())
   {
      my @size = split (//,$port);
      $max_name_size = @size
          if (@size > $max_name_size);
   }
   return ($max_name_size);
}










=item I<get_internal_signal_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_internal_signal_names
{
  my $this = shift;

  my @return_array;
  foreach my $name ($this->get_signal_names())
  {
     my @connections = 
         ($this->get_signal_sources_by_name($name),
          $this->get_signal_destinations_by_name($name));

     push (@return_array,$name)
         if (!($this->is_input($name)) &&
             !($this->is_output($name)) &&
             @connections
	     );
  }
  return sort (@return_array);
}











=item I<final_update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub final_update
{
   my $this = shift;


   $this->_check_signals_existence();
}



=item I<_check_signals_existence()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _check_signals_existence
{
   my $this = shift;

   my @warn_array;
   foreach my $name ($this->get_signal_names())
   {
      my $sig = $this->get_object_by_name($name);
      if (!$sig)
      {
         push 
             (@warn_array, 
              "  SIGNAL ($name) NOT DEFINED, ASSUMING DEFAULT SIGNAL");

         e_signal->new
             ({
                name => $name,
                parent => $this,
             });
      }
   }

   if ((@warn_array) && $this->project()->_verbose())
   {
      my $warn_string = join ("\n",
                              "MODULE ".$this->name().":",
                              @warn_array);
      warn "$warn_string\n\n\n";
   }
}



=item I<_declare_verilog_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _declare_verilog_module
{
   my $this = shift;
   my $inhibited_sigs = shift;

   my $indent = "  ";

   my $vs = $this->string_to_verilog_comment("",$this->comment);

   my $module_name = $this->name();
   my $module_declaration = "module $module_name ";
   my $port_parenthesis_indent = " " x length($module_declaration);
   
   $vs .= "$module_declaration";

   my $port_group_hash = $this->_organize_ports_into_named_groups
       ($inhibited_sigs);

   my @sorted_group_names = sort(keys(%{$port_group_hash}));
   if (@sorted_group_names) {
      $vs .= "(\n$port_parenthesis_indent$indent";
      while (@sorted_group_names)
      {
         my $group_name = shift (@sorted_group_names);
         $vs .= "// $group_name\n$port_parenthesis_indent$indent ";
         my @port_list = map {$_->name()} @{$port_group_hash->{$group_name}};
         my $port_string = 
             join (",\n$port_parenthesis_indent$indent ", sort(@port_list));

         $port_string .= ",\n\n$port_parenthesis_indent$indent"
             if @sorted_group_names;

         $vs .= $port_string;
      }
      $vs .= "\n$port_parenthesis_indent)";
   }

   my @output_ports = sort ($this->get_output_names());
   my @input_ports  = sort ($this->get_input_names());

   $vs .= $this->_make_verilog_attribute_string();
   $vs .= "\;\n\n";
   

   my @parameters = $this->get_object_names("e_parameter");
   foreach my $parameter (@parameters)
   {
      $vs .= $this->get_object_by_name($parameter)->to_verilog($indent);
   }
   $vs .= "\n\n"
       if (@parameters);



   foreach my $port (@output_ports)
   {
      my $signal = $this->get_object_by_name($port);
      &ribbit ("'$port' is not a signal\n") 
        unless (&is_blessed($signal) && $signal->isa("e_signal"));

      if ($signal->_is_inout())
      {
         $vs .= $indent.
             $signal->to_verilog("inout");
      }
      else
      {
         $vs .= $indent.
             $signal->to_verilog("output");
      }
   }


   foreach my $port (@input_ports)
   {
      my $signal = $this->get_object_by_name($port) or 
          &ribbit ("no signal known for name $port in module $module_name\n");
      $vs .= $indent.
          $signal->to_verilog("input");
   }
   $vs .= "\n";
   return ($vs);
}












=item I<emit_hdl_neutral_files()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub emit_hdl_neutral_files
{
   my $this = shift;

}   



=item I<_verilog_make_black_box_simulation_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _verilog_make_black_box_simulation_module
{
   my $this = shift;
   my $contents = shift or &ribbit ("no contents");

   my $module_name = $this->name();
   my $indent = "  ";
   my $vs = $this->_declare_verilog_module();


   $vs .= 
         join 
             ("\n$indent",
              "\n$indent//The synthesis tool sees nothing of what is inside of this module",
              "//because of the translate off statements.  We can safely embed",
              "//simulation contents of the black box in the",
              "//translate_off/translate_on sections.  Compilation stuff lives in a",
              "//separate file in this directory called $module_name.v",
              "",
              "// ".$this->_project()->_translate_off,
              "",
              );
   $vs .= $contents;
   $vs .= "\n// ".$this->_project()->_translate_on();
   $vs .= "\nendmodule\n\n";
   return ($vs);
}



=item I<simulation_strings()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub simulation_strings
{
   my $this = shift; 
   my $array_ref = $this->_simulation_string();

   push (@$array_ref,@_);
   return (@$array_ref);
}



=item I<synthesis_strings()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub synthesis_strings
{
   my $this = shift;
   my $array_ref = $this->_synthesis_string();

   push (@$array_ref,@_);
   return (@$array_ref);
}



=item I<normal_strings()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub normal_strings
{
   my $this = shift;
   my $array_ref = $this->_normal_string();

   push (@$array_ref,@_);
   return (@$array_ref);
}



=item I<compilation_strings()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub compilation_strings
{
   my $this = shift;
   my $array_ref = $this->_compilation_string();

   push (@$array_ref,@_);
   return (@$array_ref);
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
  my $this = shift;
  return if ($this->_hdl_generated());
  $this->_hdl_generated(1);

  my $vs = "\n// turn off superfluous verilog processor warnings \n";
  $vs .= "// altera message_level Level1 \n";  
  $vs .= "// altera message_off 10034 10035 10036 10037 10230 10240 10030 \n\n";
  $vs .= $this->_make_verilog_string();

  my $file = $this->output_file();
  if ($file)
  {
    $file .= '.v';

    my $project = $this->_project();
    my $full_file_name =
      join('/', $project->_system_directory(), $file);
      
    $this->to_file($full_file_name, $vs, "verilog");



    my $hdl_info = $this->_project()->module_ptf()->{HDL_INFO};
    my $existing_file = $hdl_info->{Synthesis_HDL_Files};
    if($existing_file)
    {
       $existing_file = $existing_file.", ";
    }
    $hdl_info->{Synthesis_HDL_Files} = $existing_file.$full_file_name;
  }
  else
  {
    push (@{$this->_project()->module_pool()->{verilog}}, $vs);
  }
}



=item I<_make_verilog_string()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _make_verilog_string
{
  my $this = shift;

  $this->final_update();
  my $indent = "  ";


  $this->_tagged_hdl_strings ("dont_mind_me", "verilog", $indent);

  my $sim_only_content = join('',
    $this->simulation_strings(
      $this->_tagged_hdl_strings ("simulation", "verilog", $indent)
    )
  );
  my $synth_only_content = join('',
    $this->synthesis_strings(
      $this->_tagged_hdl_strings ("synthesis", "verilog", $indent)
    )
  );
  my $compilation_only_content = join('',
    $this->_tagged_hdl_strings("compilation", "verilog", $indent)
  );
  my $normal_content = join('',
    $this->normal_strings(
      $this->_tagged_hdl_strings("normal", "verilog", $indent)
    )
  );

  my $system_vs = join ("\n",
    $this->_declare_verilog_module() .
    $this->verilog_declare_internal_signals($indent),
  );  


  if ($normal_content) 
  {
    $system_vs .= $normal_content,
  }


  if ($sim_only_content) 
  {
    $system_vs .= "\n//". $this->_project()->_translate_off ."\n";
    $system_vs .= "//////////////// SIMULATION-ONLY CONTENTS\n";
    $system_vs .= $sim_only_content;
    $system_vs .= "\n//////////////// END SIMULATION-ONLY CONTENTS\n";
    $system_vs .= "\n//". $this->_project()->_translate_on ."\n";
  }



  if ($compilation_only_content) 
  {
    if ( ($this->project()->asic_enabled()) && ($this->project()->asic_third_party_synthesis()) ){
      $system_vs .= $compilation_only_content;
    } else {
      $compilation_only_content =~ s/\/\/.*//mg;
      $compilation_only_content =~ s/^/\/\//mg;
      $system_vs .= "//".$this->project()->_quartus_translate_on()."\n". $compilation_only_content;
      $system_vs .= "//".$this->project()->_quartus_translate_off()."\n";
    }
  }

  $system_vs .= "\nendmodule\n\n";

  return $system_vs;    
}




=item I<_get_tagged_updated_contents()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_tagged_updated_contents
{
  my $this = shift;
  my $tag = shift;
  &ribbit ("Requires one argument") if $tag eq "" or @_;
  &ribbit ("Bad tag: $tag") 
    unless e_thing_that_can_go_in_a_module->tag_is_recognized($tag);

  my @result = ();
  foreach my $content (@{$this->_updated_contents()})
  {
    push (@result, $content) if $content->tag() eq $tag;
  }

  return @result;
}



=item I<_tagged_hdl_strings()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _tagged_hdl_strings
{
  my $this = shift;
  my $tag  = shift;
  my $language = shift;
  my $indent   = shift;
  &ribbit ("bad args") if $tag eq "" or $language eq "" or !defined $indent or @_;
  &ribbit ("unrecognized tag: $tag") 
    unless e_thing_that_can_go_in_a_module->tag_is_recognized($tag);


  my @string_list = ();
  my @tagged_contents = $this->_get_tagged_updated_contents($tag);
  foreach my $content (@tagged_contents) {




    next if $content->isa("e_signal");
    next if $content->isa("e_expression");
    next if $content->isa("e_parameter");

    if (     $language =~ /verilog/i) {
      push (@string_list, $content->to_verilog($indent));
    } elsif ($language =~ /vhdl/i) {
      push (@string_list, $content->to_vhdl($indent));
    } else {
      &ribbit ("lost language: $language");
    }
  }
  return @string_list;
}



=item I<vhdl_declare_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_declare_module
{
   my $this = shift;
   my $entity_or_component = shift or 
       &ribbit ("please specify if module is component or entity\n");

   my $inhibited_sigs = shift;

   my $entity_name = $this->name();

   my $port_indent = " " x 2;

   my $vs; #vhdl string
   
   my $entity = "$entity_or_component $entity_name is ";
   $vs .= "$entity\n";
   my $entity_length = "  ".(" " x length($entity_or_component));
   $port_indent = $entity_length .(" " x (length("port (")));
   my $generic_indent = $entity_length .(" " x length("generic ("));

   my @parameters = sort ($this->get_object_names("e_parameter"));
   if (@parameters)
   {
      $vs .= "${entity_length}generic (\n";
      my @parameter_out;
      foreach my $parameter (sort (@parameters))
      {
         push (@parameter_out, 
               $this->get_object_by_name($parameter)->to_vhdl
               ($generic_indent)
               );
      }
      $vs .= join (";\n",@parameter_out);
      $vs .= "\n$generic_indent\)\;\n";
   }
   
   my $port_group_hash = $this->_organize_ports_into_named_groups
       ($inhibited_sigs);

   my @sorted_group_names = sort(keys(%{$port_group_hash}));
   if (@sorted_group_names) {
      $vs .= "${entity_length}port (\n$port_indent";
      while (@sorted_group_names)
      {
         my $group_name = shift (@sorted_group_names);
         $vs .= "-- $group_name\n$port_indent ";
         my @port_list = 
            map {$_->to_vhdl("  ")} @{$port_group_hash->{$group_name}};
         my $port_string = 
             join (";\n$port_indent ", sort(@port_list));

         $port_string .= ";\n\n$port_indent"
             if @sorted_group_names;

         $vs .= $port_string;
      }
      $vs .= "\n$port_indent);\n";
   }

   $vs .= $this->_make_vhdl_attribute_string('entity') unless ($entity_or_component eq "component"); 
   $vs .= "end $entity_or_component $entity_name\;\n";
   
   return ($vs);
}



=item I<_declare_vhdl_libraries()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _declare_vhdl_libraries
{
   my $this = shift;
   my $lib_hash = $this->vhdl_libraries();

   my $lib_string;
   foreach my $lib (sort (keys (%$lib_hash)))
   {

     $lib_string .= "library $lib;\n";

     if(ref($lib_hash->{$lib}) eq ''){
       my $thing_to_use = $lib_hash->{$lib};
       $lib_string .= "use ${lib}.${thing_to_use};\n";
     }else{
       foreach my $use_this (sort (keys (%{$lib_hash->{$lib}})))
	 {
	   $lib_string .= 
	      "use $lib.$use_this";
           my $third_part = $lib_hash->{$lib}{$use_this};
           if($third_part ne "")
           {
             $lib_string .= ".$third_part;\n";
           } else
           {
             $lib_string .= ";\n";
           }
         }
     }
     $lib_string .= "\n";
   }
   return ($lib_string);
}



=item I<to_file()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_file
{
   my $this = shift;
   my ($absolute_file_name,
       $string,
       $language) = @_;

   open (NOT_ALTERA_FILEHANDLE, "> $absolute_file_name") or 
       &ribbit ("unable to open $absolute_file_name ($!)\n");

   my $comment = $this->_project()->global_copyright_notice();
   if ($language =~ /vhdl/i)
   {
      print NOT_ALTERA_FILEHANDLE $this->string_to_vhdl_comment("",$comment);
   }
   elsif ($language =~ /verilog/i)
   {
      print NOT_ALTERA_FILEHANDLE $this->string_to_verilog_comment("", $comment);
   }
   else
   {
      &ribbit ("language $language not known\n");
   }   

   print NOT_ALTERA_FILEHANDLE $string;
   close (NOT_ALTERA_FILEHANDLE);
}






=item I<vhdl_add_string()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_add_string
{
  my $this = shift;
  push (@{$this->_vhdl_string()},@_);
}



=item I<vhdl_add_file()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_add_file
  {
  my $this = shift;
  push (@{$this->_vhdl_file()},[@_]);
}



=item I<_vhdl_get_component_string()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _vhdl_get_component_string
{
   my $this = shift;   
   my $operation = shift;

   my $component_list;

   foreach my $uc ($this->_get_tagged_updated_contents($operation))
   {
     $component_list .=
       $uc->vhdl_declare_component_if_needed()
	 if ($uc->can("vhdl_declare_component_if_needed"));
   }

   return $component_list;
}



=item I<_vhdl_declare_internal_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _vhdl_declare_internal_signals
{
   my $this = shift;
   my $indent = shift;
   my $type = shift;
   my $internal_signal_list;
   my $entity_length = "  ".(" " x length("entity"));
   my $port_indent   = $entity_length .(" " x (length("port (")));

   foreach my $internal_signal 
       (sort ($this->get_internal_signal_names()))
   {
      my $signal = $this->get_signal_by_name($internal_signal)
          or &ribbit ("could not find an internal signal ($internal_signal)\n");

      if($type ne ""){
	if($signal->tag() eq $type){
	  $internal_signal_list .= 
	    $indent . $signal->to_vhdl($port_indent).";\n";
	}
      }else{
	$internal_signal_list .= 
	  $indent . $signal->to_vhdl($port_indent).";\n";
      }
   }
   return ($internal_signal_list);
}



=item I<_vhdl_make_black_box_compilation_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _vhdl_make_black_box_compilation_module
{
   my $this = shift;
   ($this->do_black_box()) or return;
   my $indent = shift || "  ";
   my @compilation_only_strings;
   my $entity_name = $this->name();

   if(!$this->_explicitly_empty_module())
   {
     @compilation_only_strings =
       $this->_tagged_hdl_strings ("compilation", "vhdl", $indent);

     my $internal_signal_list = $this->_vhdl_declare_internal_signals($indent);
     my $component_list = $this->_compilation_component_strings();

     my @normal_strings = 
         $this->_tagged_hdl_strings("normal", "vhdl", $indent);




     my $bbvs;
     $bbvs .= $this->_declare_vhdl_libraries().
         $this->vhdl_declare_module("entity");
     $bbvs .= "\n\narchitecture europa of $entity_name is\n";
     $bbvs .= $component_list;
     $bbvs .= $internal_signal_list;
     $bbvs .= "\nbegin\n\n";
     $bbvs .= join ("", @compilation_only_strings,@normal_strings);
     $bbvs .= "end europa\;\n\n";
     $bbvs =~ s/\-\-.*//mg;
     $bbvs =~ s/^/\-\-/mg;

     $bbvs = "--".$this->project()->_quartus_translate_on."\n".$bbvs;
     $bbvs .= "--".$this->project()->_quartus_translate_off."\n";

     
     push (@{$this->_project()->module_pool()->{vhdl}},$bbvs);     
   }
}



=item I<_vhdl_make_black_box_simulation_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _vhdl_make_black_box_simulation_module
{
   my $this     = shift;
   my $contents = shift;

   my $libs        = $this->_declare_vhdl_libraries();
   my $entity_name = $this->name();

   my $simvs; 
   $simvs .= "--". $this->project()->_translate_off ."\n\n";
   $simvs .= $libs.$this->vhdl_declare_module("entity");
   $simvs .= "\n\narchitecture europa of $entity_name is\n";
   $simvs .= $this->_simulation_component_strings(). 
     $this->_normal_component_strings();
   $simvs .= $this->_vhdl_declare_internal_signals();

   if($this->overriding_vhdl_simulation() ne ""){
     $simvs .= $this->overriding_vhdl_simulation();
   }else{
     $simvs .= join ("",@{$this->_vhdl_string()});
     $simvs .= "\nbegin\n\n";
     $simvs .= $contents;
   }
   $simvs .= "end europa\;\n\n";

   $simvs .= "--". $this->project()->_translate_on ."\n\n";
   push (@{$this->_project()->module_pool()->{vhdl}},$simvs);
}



=item I<_vhdl_make_string()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _vhdl_make_string
{
   my $this = shift;
   $this->final_update();

   my $entity_name = $this->name();
   my $port_indent = " " x 2;

   my $indent = "  ";
   $this->_vhdl_update_output_pins();
   $this->_tagged_hdl_strings ("dont_mind_me", "vhdl", $indent);

   my $user_libraries  = $this->print_user_code("--add your libraries here");
   my $user_signals_and_components    = $this->print_user_code
       ("--add your component and signal declaration here");
   my $user_guts    = $this->print_user_code
       ("--add additional architecture here");

   my @sim_only_strings = $this->simulation_strings
     (
      $this->_tagged_hdl_strings 
      ("simulation", "vhdl","    ")
     );
   

   my @synth_only_strings = $this->synthesis_strings
     (
      $this->_tagged_hdl_strings ("synthesis", "vhdl","    ")
     );
   
   my @compilation_only_strings = $this->compilation_strings
     (
      $this->_tagged_hdl_strings("compilation", "vhdl", "    ")
     );


   my @normal_strings = $this->normal_strings
     (
      $this->_tagged_hdl_strings ("normal", "vhdl", $indent)
     );
   





   my $internal_signal_list_normal = $this->_vhdl_declare_internal_signals($indent, "normal");
   my $internal_signal_list_simulation = $this->_vhdl_declare_internal_signals($indent, "simulation");
   if($internal_signal_list_simulation){
     $internal_signal_list_simulation = "\n--".$this->project()->_translate_off."\n".
       $internal_signal_list_simulation . 
	 "\n--".$this->project()->_translate_on."\n";
   }

   my $internal_signal_list_compilation = $this->_vhdl_declare_internal_signals($indent, "compilation");
   if($internal_signal_list_compilation){
     $internal_signal_list_compilation =~ s/\-\-.*//mg;
     $internal_signal_list_compilation =~ s/^/\-\-/mg;
     $internal_signal_list_compilation = "\n--".$this->project()->_quartus_translate_on."\n".
       $internal_signal_list_compilation .
	 "\n--".$this->project()->_quartus_translate_off."\n";
   };

   my $internal_signal_list = $internal_signal_list_normal . 
       $internal_signal_list_simulation . 
       $internal_signal_list_compilation . 
       $user_signals_and_components;
   
   $this->_normal_component_strings($this->_vhdl_get_component_string("normal"));
   $this->_simulation_component_strings($this->_vhdl_get_component_string("simulation"));
   $this->_synthesis_component_strings($this->_vhdl_get_component_string("synthesis"));
   $this->_compilation_component_strings($this->_vhdl_get_component_string("compilation"));

   my $synthesis_and_compilation_string = $this->_synthesis_component_strings();

   if ($synthesis_and_compilation_string)
   {
      $synthesis_and_compilation_string =
          $this->project()->_quartus_translate_on()."\n".
          $synthesis_and_compilation_string.
          $this->project()->_quartus_translate_off()."\n";
      $synthesis_and_compilation_string =~ s/\-\-.*//mg;
      $synthesis_and_compilation_string =~ s/^/\-\-/mg;
   }

   my $simulation_strings = $this->_simulation_component_strings();
   if ($simulation_strings)
   {
      $simulation_strings = '--'.$this->project()->_translate_off()."\n".
          $simulation_strings.
          '--'.$this->project()->_translate_on()."\n";
   }

   my $component_list = join("",
                             $this->_vhdl_get_component_string('component'),
                             $this->_normal_component_strings, 
                             $simulation_strings,
                             $synthesis_and_compilation_string);


   my $vs;
   $vs .= $this->string_to_vhdl_comment("",$this->comment);


   my $project = $this->project();
   $project->doing_visible_wrapper_ports(1);
   $vs .= $this->vhdl_declare_module("entity");
   $project->doing_visible_wrapper_ports(0);    # and clear it.

   $vs .= "\n\narchitecture europa of $entity_name is\n";
   $vs .= $component_list;
   $vs .= $internal_signal_list;
   $vs .= $this->_make_vhdl_attribute_string('signal');
   my @variables = @{$this->_vhdl_string()};

   foreach my $var (@variables)
     {
       $vs .= "$indent$var\n";
     }





   my $libs = $this->_declare_vhdl_libraries()
       .$user_libraries;

   $vs = $libs . $vs;

   my $simulation_variable;
   $vs .= "\nbegin\n\n";


   $vs .= join ("", @normal_strings);

   
   if (@synth_only_strings) 
   {
     &ribbit("There are no synthesis strings allowed, only compilation!\n");
   }  

   if (@sim_only_strings) 
   {
      if ($this->do_black_box())
      {
         $this->_vhdl_make_black_box_simulation_module
             (
              join ("", 
                    (@sim_only_strings,
		     @normal_strings)
		   )
              );
       }
      else
      {
	$vs .= "--" . $this->project()->_translate_off ."\n";
	$vs .= join ("",@sim_only_strings);
	$vs .= "--" . $this->project()->_translate_on ."\n";
      }
   }

   if((!$this->do_black_box()))
   {

     if(@compilation_only_strings){
       my $cs = join("", @compilation_only_strings);

       $cs =~ s/\-\-.*//mg;
       $cs =~ s/^/\-\-/mg;
       $cs = "--".$this->project()->_quartus_translate_on."\n".$cs;
       $cs .= "--".$this->project()->_quartus_translate_off."\n";
       $vs .= $cs;
     }
   }

   $this->_vhdl_make_black_box_compilation_module();

   $vs .= $user_guts."\n";
   $vs .= "end europa\;\n\n";

   if($this->do_black_box()){
     $vs = "";
   }

   return ($vs);
}



=item I<_normal_component_strings()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _normal_component_strings
{
   my $this = shift;
   if (@_)
   {
      $this->{_normal_component_strings} .= $_[0];
   }
   return $this->{_normal_component_strings};
}



=item I<_simulation_component_strings()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _simulation_component_strings
{
   my $this = shift;
   if (@_)
   {
      $this->{_simulation_component_strings} .= $_[0];
   }
   return $this->{_simulation_component_strings};
}



=item I<_compilation_component_strings()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _compilation_component_strings
{
   my $this = shift;
   if (@_)
   {
      $this->{_compilation_component_strings} .= $_[0];
   }
   return $this->{_compilation_component_strings};
}



=item I<_synthesis_component_strings()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _synthesis_component_strings
{
   my $this = shift;
   return $this->_compilation_component_strings(@_);
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
   my $this = shift;
   return if ($this->_hdl_generated());
   $this->_hdl_generated(1);

   my $vs = "\n-- turn off superfluous VHDL processor warnings \n";
   $vs .= "-- altera message_level Level1 \n";  
   $vs .= "-- altera message_off 10034 10035 10036 10037 10230 10240 10030 \n\n";      
   $vs .= $this->_vhdl_make_string();

   my $file = $this->output_file();
   if ($vs)
   {
      if ($file)
      {
         $file .= '.vhd';

         my $project = $this->_project();
         my $full_file_name =
             join('/', $project->_system_directory(), $file);
         
         $this->to_file($full_file_name, $vs, "vhdl");



         my $hdl_info = $this->_project()->module_ptf()->{HDL_INFO};
         my $existing_file = $hdl_info->{Synthesis_HDL_Files};
         if($existing_file)
         {
            $existing_file = $existing_file.", ";
         }
         $hdl_info->{Synthesis_HDL_Files} =
             $existing_file.$full_file_name;
      }
      else
      {
         push (@{$this->_project()->module_pool()->{vhdl}},$vs);
      }
   }
   $this->tag_mr_ptf();
}













=item I<_vhdl_update_output_pins()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _vhdl_update_output_pins
{
   my $this = shift;

   foreach my $output_name (sort ($this->get_output_names()))
   {

      my $rename =
          $this->get_signal_destinations_by_name($output_name);


      foreach my $source ($this->flatten_sources($output_name))
      {
         if ($source->isa("e_instance"))
         {
            $rename = 1;
            last;
         }
      }

      if ($rename)
      {
         my $internal_output_name = $this->get_exclusive_name
             ("internal_$output_name");




         my $output_signal = $this->get_signal_by_name($output_name);
         next if ($output_signal->_is_inout());

         $output_signal->export(1); #keep it an output signal
         e_signal->new 
	 ({ name => $internal_output_name,
	    width => $output_signal->width(),
	    export => 0,
	    never_export => 1,
	    declare_one_bit_as_std_logic_vector => 
                $output_signal->declare_one_bit_as_std_logic_vector,
	 })->within($this);

         $this->rename_node($output_name, $internal_output_name);
         my $assign = e_assign->new({
                               comment => "vhdl renameroo for output signals",
                               lhs     => $output_name,
                               rhs     => $internal_output_name,
                            });

         $assign->parent($this);
         $this->update_item($assign);
      }
   }
}















=item I<to_ptf()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_ptf
{
  my $this = shift;

  return unless ($this->do_ptf());
  my $ptf_section = $this->_project()->module_ptf();

  if ($this->_project()->_test_bench_component()) {
      $ptf_section = $ptf_section->{SIMULATION};
  }
  
  foreach my $content (@{$this->_updated_contents} ) {
      $content->to_ptf($ptf_section);
  }
  



  return if ($this->_project()->top() ne $this);
  foreach my $value (values (%{$ptf_section->{PORT_WIRING}}))
  {
     $value->{Is_Enabled} = 0;
  }

  foreach my $port_name ($this->_get_port_names()) 
  {
     my $sig_object = $this->get_signal_by_name ($port_name)
         or &ribbit ("port '$port_name' cannot be found.");
     $sig_object->add_to_ptf_section ($ptf_section->{PORT_WIRING});
  }
}



=item I<_get_io_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_io_signals 
{
  my $this         = shift;
  my $input_output = shift;
  &ribbit ("expected 'input' or 'output'") 
      unless $input_output =~ /^(input)|(output)$/;
  &ribbit ("too many arguments") if scalar (@_) != 0;
  
  my @result = ();
  my @name_list = (($input_output eq "input") ? 
                   $this->get_input_names()   :
                   $this->get_output_names()  ); 

  foreach my $port_name (@name_list) {
    my $sig_object = $this->get_signal_by_name ($port_name)
      or &ribbit ("port '$port_name' cannot be found.");

    push (@result, $sig_object);
  }

  my $n = scalar(@result);


  return @result;
}



=item I<get_input_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_input_signals
{
  my $this = shift;
  &ribbit ("access function only.") if scalar (@_);
  return $this->_get_io_signals("input");
}



=item I<get_output_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_output_signals
{
  my $this = shift;
  &ribbit ("access function only.") if scalar (@_);
  return $this->_get_io_signals("output");
}



=item I<get_port_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_port_signals
{
  my $this = shift; 
  my @result = ($this->get_input_signals(),
                $this->get_output_signals());
  my $n = scalar (@result);
  print STDERR "get_port_signals: $n ports\n";
  
  return @result;
}



=item I<_get_signal_width()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_signal_width
{
  my $this = shift;
  my $signal_name = shift;
  
  ribbit("One argument required") if $signal_name eq "" or @_;
  
  my $sig = $this->get_object_by_name($signal_name);

  return 1 if !$sig;
  
  ribbit("I didn't find no signal '$signal_name' in ", $this->name()) if ($sig eq "");
  
  return $sig->width();
}



=item I<get_and_set_thing_by_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_and_set_thing_by_name
{
   my $this  = shift;
   my $hash  = shift or &ribbit ("no hash");
   my $name = $hash->{name} or &ribbit ("no name");
   my $thing  = $hash->{thing} or &ribbit ("no thing");

   delete $hash->{thing};



   my $e_thing = $this->get_object_by_name("$name");

   if (!$e_thing)  #make $e_thing if it does not exist.
   {
      $e_thing = "e_${thing}"->new
          ($hash);

      $this->add_contents($e_thing);
      $this->document_object($e_thing);
   }
   else
   {
      delete $hash->{name};
      $e_thing->set($hash);
   }

   return ($e_thing);
}



=item I<get_and_set_once_by_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_and_set_once_by_name
{
   my $this  = shift;
   my $hash  = shift or &ribbit ("no hash");
   my $name = $hash->{name} or &ribbit ("no name");
   my $thing  = $hash->{thing} or &ribbit ("no thing");

   delete $hash->{thing};



   my $e_thing = $this->get_object_by_name("$name");

   if (!$e_thing)  #make $e_thing if it does not exist.
   {
      $e_thing = "e_${thing}"->new
          ($hash);

      $this->add_contents($e_thing);
      $this->document_object($e_thing);
      return ($e_thing);
   }
   return;
}




=item I<print_user_code()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub print_user_code 
{
   my $this = shift;
   if ($this->add_user_comments())
   {
      return ($this->project()->print_user_code(@_));
   }
   else
   {
      return "";
   }
}








=item I<tag_mr_ptf()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub tag_mr_ptf()
{
  my $this=shift;


  if(  $this->_additional_support()->{_i_need_a_fixup} eq "1")
  {

    my $parent_module = $this->parent_module();

    my $ptf_path = $this->_project()->system_ptf()->{"MODULE ".$this->name()};
    my $sim = $ptf_path->{SIMULATION}->{MODELSIM}->{SETUP_COMMANDS};
    my $replacement_string = $this->_additional_support->{_stupid_vhdl_path_needed_for_simulation};

    $ptf_path->{SIMULATION}->{Fix_Me_Up} = $replacement_string;

  }
}




















=item I<_organize_ports_into_named_groups()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _organize_ports_into_named_groups
{
   my $this = shift;
   my $inhibited_signals = shift || [];

   my @inputs  = sort {$a->name() cmp $b->name()} $this->get_input_signals();
   my @outputs = sort {$a->name() cmp $b->name()} $this->get_output_signals();

   my %inhibited_signal_hash = map {$_ => 1} @$inhibited_signals;

   my @new_inputs;
   foreach my $input (@inputs)
   {
       push (@new_inputs, $input)
           unless $inhibited_signal_hash{$input->name()};
   }

   my @new_outputs;
   foreach my $output (@outputs)
   {
       push (@new_outputs, $output)
           unless $inhibited_signal_hash{$output->name()};
   }

   my $group_hash = {};
   push (@{$group_hash->{"inputs:"}},  @new_inputs) if @new_inputs;
   push (@{$group_hash->{"outputs:"}}, @new_outputs)if @new_outputs;
   return $group_hash;
}



=item I<sink_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub sink_signals
{
   my $this = shift;

   my @signals = @_;

   my $line_number = __LINE__;
   
   my @table = map {$_, $_} @signals;

   $this->get_and_set_thing_by_name
       ({

          name => "sink mux for $this, see e_module line number $line_number\n",
          lhs  => "32'd$line_number", #got to have something in lhs, use

          thing => 'mux',
          tag   => 'dont_mind_me', #hide the mux
          add_table => \@table,
       });
}






=item I<get_modelsim_list_info()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_modelsim_list_info
{
  return ();
}



















=item I<identify_signal_widths()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub identify_signal_widths
{
   my $this = shift;

   $this->SUPER::identify_signal_widths();
   

   foreach my $content (@{$this->_updated_contents()})
   {
      next unless $content->isa ("e_instance");
      $content->identify_signal_widths();
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
  my $command_list = [];   # stores gathered tcl contents 

  foreach my $content (@{$this->_updated_contents()})
  {
    next unless ($content->can("get_tcl_commands"));
    my $command = $content->get_tcl_commands();

    if ($command) {
      push @$command_list, @$command;
    }
  }
  return $command_list;
}







sub declared_vhdl_record_names
{
    my $this = shift;
    my $record_name = shift;
    my $return = $this->_declared_vhdl_record_names()->{$record_name}++;
    return $return;
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

The inherited class e_module_database

=begin html

<A HREF="e_module_database.html">e_module_database</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
