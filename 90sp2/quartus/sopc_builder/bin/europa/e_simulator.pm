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
package e_simulator;

use europa_utils;
use filename_utils;

@ISA = qw(e_project);
use strict;

my %fields = (
              ptf_ref   => {},
              );

my %pointers = (
                spaceless_ptf_hash => {},
               );

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );

=head1 NAME

e_simulator - HDL simulator configuration base class for SOPC Builder

=head1 SYNOPSIS

e_simulator is the base class for HDL simulator interfaces
within SOPC Builder. 
The e_modelsim class is one example in the Europa library which
is shipped with the SOPC Builder product.  An examples of a
future class is e_ncsim for the Cadence NC verilog simulator.

=head1 METHODS

=over 4

=cut






=item I<_language()>

Return the HDL implementation and simulation language used by the design.

=cut

sub _language {
   my $this       = shift;
   &ribbit ("too many arguments: access-only method") if @_;
   my $language = $this->{project}->{language};
   return $language;
}


=item I<is_vhdl()>

Calls _language() and returns true if the HDL implementation language is VHDL.

=cut

sub is_vhdl {
   my $this       = shift;
   &ribbit ("too many arguments: access-only method") if @_;
   return ($this->_language() =~ /vhdl/) ? 1:0;
}


=item I<is_verilog()>

Calls _language() and returns true if the HDL implementation language is verilog.

=cut

sub is_verilog {
   my $this       = shift;
   &ribbit ("too many arguments: access-only method") if @_;
   return ($this->_language() =~ /verilog/) ? 1:0;
}


=item I<get_sim_project_name()>

Generate the simulator project name by getting the system name and appending
the suffix _sim to it.

=cut

sub get_sim_project_name {
   my $this = shift;
   my $sim_project_name = $this->system_name() . "_sim";
   return $sim_project_name;
}


=item I<test_bench_name()>

Returns the name of the test-bench module.

=cut

sub test_bench_name {
   my $this = shift;
   &ribbit ("too many arguments: access-only method") if @_;
   return "test_bench";
}


=item I<target_module_name()>

Returns the name of the top module.

=cut

sub target_module_name {
   my $this       = shift;
   &ribbit ("too many arguments: access-only method") if @_;
   my $proj = $this->{project};
   return $proj->{_target_module_name};
}


=item I<system_name()>

Returns the name of the SOPC Builder generated system.

=cut

sub system_name {
   my $this       = shift;
   &ribbit ("too many arguments: access-only method") if @_;
   my $proj = $this->{project};
   return $proj->{_system_name};
}


=item I<system_directory()>

Returns the name of the system directory.

=cut

sub system_directory {
   my $this = shift;
   &ribbit ("too many arguments: access-only method") if @_;
   my $proj = $this->{project};
   return $proj->{__system_directory};
}


=item I<quartus_simulation_directory()>

Returns the SOPC Quartus simulation library path containing Altera primitives.

=cut

sub quartus_simulation_directory {
  my $this  = shift;
  &ribbit ("too many arguments: access-only method") if @_;

  my $proj = $this->{project};

  my $env_quartus_rootdir = $ENV{QUARTUS_ROOTDIR};
  $env_quartus_rootdir =~ s|/$||;

  my $sopc_quartus_dir = 
    $proj->{__sopc_quartus_dir} ||
    $env_quartus_rootdir ||
    $this->get_config_file_parameter("sopc_quartus_dir");

  my $quartus_simulation_dir = "$sopc_quartus_dir\/eda/sim_lib";
  return $quartus_simulation_dir;
}


=item I<quartus_vhdl_altera_directory()>

Returns the VHDL library directory containing altera packages.

=cut

sub quartus_vhdl_altera_directory {
  my $this  = shift;
  &ribbit ("too many arguments: access-only method") if @_;

  my $proj = $this->{project};

  my $env_quartus_rootdir = $ENV{QUARTUS_ROOTDIR};
  $env_quartus_rootdir =~ s|/$||;

  my $sopc_quartus_dir = 
    $proj->{__sopc_quartus_dir} ||
    $env_quartus_rootdir ||
    $this->get_config_file_parameter("sopc_quartus_dir");

  my $quartus_vhdl_altera_dir = "$sopc_quartus_dir\/libraries/vhdl/altera";
  return $quartus_vhdl_altera_dir;
}


=item I<simulation_directory()>

Returns the simulation directory for the current project. If the simulation
directory does not exist it will be created.

=cut

sub simulation_directory {
   my $this = shift;
   my $was_called_statically = ref ($this) eq "";

   my $simdir = "NO directory.";
   if ($was_called_statically) {
      my $sys_dir = shift or ribbit ("?");
      my $sim_dir = shift or ribbit ("?");
      return join ("/",  $sys_dir, $sim_dir."_sim");
   } else {
      &ribbit ("Access-only function") if scalar(@_) != 0;
      $simdir = join ("/",
                      $this->system_directory(),
                      $this->system_name()."_sim"
                      );
   }
   Create_Dir_If_Needed($simdir);
   return $simdir;
}


=item I<_sopc_lib_path()>

Returns the full path to the SOPC simulation libraries.

=cut

sub _sopc_lib_path {
   my $this       = shift;
   &ribbit ("too many arguments: access-only method") if @_;
   my $sopc_lib_path = $this->{project}->{_sopc_lib_path};
   return $sopc_lib_path;
}


=item I<sopc_directory()>

Returns the SOPC Builder installation directory path.

=cut

sub sopc_directory {
   my $this       = shift;
   &ribbit ("too many arguments: access-only method") if @_;
   my $sopc_directory = $this->{project}->{_sopc_directory};
   return $sopc_directory;
}


=item I<sopc_builder_config()>

Returns the full path to the SOPC Builder setup configuration file .sopc_builder.

=cut

sub sopc_builder_config {
   my $this       = shift;
   &ribbit ("too many arguments: access-only method") if @_;
   return $this->sopc_directory() . "/.sopc_builder";
}


=item I<get_config_file_parameter(parameter_name)>

Returns a parameter value from the .sopc_builder configuration file.

=cut

sub get_config_file_parameter {
   my $this      = shift;
   my $parameter = shift;
   &ribbit ("too many arguments") if @_;

   my $sopc_builder_config_file = $this->sopc_builder_config();
   my $config_ptf   = &ptf_parse::new_ptf_from_file($sopc_builder_config_file);
   my $parameter_value = &ptf_parse::get_data_by_path($config_ptf, $parameter);
   return $parameter_value;
}


=item I<modules()>

Returns a hash of all modules in the SOPC Builder generated system.

=cut

sub modules {
   my $this = shift;
   &ribbit ("too many arguments: access-only method") if @_;
   return values (%{$this->{project}->{module_hash}});
}


=item I<get_ptf_module_list()>

Returns an array of Europa e_ptf_module objects, one for each module that has
a corresponding MODULE section in the system PTF file. Each e_ptf_module element
is a hash containing everything you ever wanted to know about the given module.

=cut

sub get_ptf_module_list {
   my $this = shift;
   &ribbit ("too many arguments: access-only method") if @_;
   my @result = ();
   foreach my $mod ($this->modules()) {
      push (@result, $mod) if ($mod->isa("e_ptf_module") &&
                               $mod->{SYSTEM_BUILDER_INFO}{Is_Enabled});
   }
   return @result;
}


=item I<_simulation_ptf_section()>

This PTF access function returns a reference to the target_modules's
SIMULATION section which holds information about the signals to be displayed
in the simulation waveform viewer.

=cut


sub _simulation_ptf_section {
   my $this = shift;
   my $module_name = shift or $this->{project}->{_target_module_name};

   my $module_ptf = $this->spaceless_module_ptf($module_name);
   &ribbit ("module ptf does not exist") if (!$module_ptf);


   my $result = $module_ptf->{SIMULATION};
   if (!$result) {
      $module_ptf->{SIMULATION} = {};
      $result = $module_ptf->{SIMULATION};
   }
   return $result;
}


=item I<get_module_signals(module)>

Return the list of signals in a module to display.

=cut


sub get_module_signals {
   my $this = shift;
   my $mod_name = shift;

   &ribbit ("too many arguments") if @_;
   my $sim_section = $this->_simulation_ptf_section($mod_name);
   my $sig_section = $sim_section->{DISPLAY}{SIGNAL};
   return $sig_section;
}

sub get_divider_tag {
   my $this = shift;
   my $mod_name = shift;

   &ribbit ("too many arguments") if @_;
   my $sim_section = $this->_simulation_ptf_section($mod_name);
   my $divider_tag = $sim_section->{Fix_Me_Up};
   return $divider_tag;
}




sub spaceless_module_ptf {
   my $this = shift;
   my $module = shift or
     $this->{project}->{_target_module_name};

   $module or
     &ribbit ("no module ($module)(",
	      $this->{project}->{_target_module_name},
	      ")\n");

   my $ptf_section = $this->spaceless_system_ptf()->{MODULE}{$module}
     or &ribbit ("couldn't find module $module\n".
		 "Possible modules include ",
		 join (", ",keys
		       (%{$this->spaceless_system_ptf()->{MODULE}})
		      )
		);
   return ($ptf_section);
}


=item I<interactive_simulation_IO(module_name, direction)>

Returns a hash reference containing information on interactive input or output
files.

=cut

sub interactive_simulation_IO {
  my $this = shift;
  my $mod_name = shift;
  my $direction = shift;
  &ribbit ("too many arguments") if @_;

  my $int_section;

  if ($direction =~ /output/i) {
    $int_section = $this->spaceless_module_ptf($mod_name)->{SIMULATION}{INTERACTIVE_OUT};
  } elsif ($direction =~ /input/i) {
    $int_section = $this->spaceless_module_ptf($mod_name)->{SIMULATION}{INTERACTIVE_IN};
  } else {
    ribbit 'interactive_simulation_IO argument must be "input" or "output"';
  }
}




sub spaceless_system_ptf {
   my $this = shift;
   &ribbit ("too many arguments: access-only method") if @_;

   my @systems = keys (%{$this->{project}->spaceless_ptf_hash()->{SYSTEM}});
   (@systems == 1) or 
     &ribbit ("too many systems (@systems)\n");

   my $ptf_section = $this->{project}->spaceless_ptf_hash()->{SYSTEM}
   {$systems[0]} or &ribbit ("no system");
   return ($ptf_section);
}


=item I<signal_display_is_enabled(module_name)>

Returns true or false depending on whether or not this module has signal 
display enabled.

=cut

sub signal_display_is_enabled {
  my $this = shift;
  my $module_name = shift;
  return
    $this->spaceless_module_ptf($module_name)->{SYSTEM_BUILDER_INFO}{Is_Enabled};
}


=item I<signal_display_is_empty(module_name)>

Returns true or false on depending on whether or not this module has any 
signals to be displayed.

=cut

sub signal_display_is_empty {
  my $this = shift;
  my $module_name = shift;

  my $sim_section = $this->_simulation_ptf_section($module_name);
  my $sig_section = $sim_section->{DISPLAY}{SIGNAL};

  return (values(%{$sig_section})) ? 0:1;
}


=item I<signal_lists_for_display(module_name)>

Returns a list of signals to be displayed for the module.

=cut

sub signal_list_for_display {
  my $this = shift;
  my $module_name = shift;

  my $sim_section = $this->_simulation_ptf_section($module_name);
  my $sig_section = $sim_section->{DISPLAY}{SIGNAL};
  my @signal_display_list = sort(keys (%{$sig_section}));
  return @signal_display_list;
}


=item I<signal_display_section(module_name)>

Returns a signal display section for a particular signal in a module.

=cut

sub signal_display_section {
  my $this = shift;
  my $module_name = shift;

  my $sim_section = $this->_simulation_ptf_section($module_name);
  my $sig_section = $sim_section->{DISPLAY}{SIGNAL};
  return $sig_section;
}


=item I<signal_display_name(module_name, signal_name)>

Returns a signal name to be displayed for the module.

=cut

sub signal_display_name {
  my $this = shift;
  my $module_name = shift;
  my $signal_name =shift;

  my $this_signal_section =
    $this->signal_display_section($module_name)->{$signal_name};

  my $name = $this_signal_section->{name};
  return $name;
}


=item I<signal_display_radix(module_name, signal_name)>

Returns the signal radix to be displayed for the module.

=cut

sub signal_display_radix {
  my $this = shift;
  my $module_name = shift;
  my $signal_name =shift;

  my $this_signal_section =
    $this->signal_display_section($module_name)->{$signal_name};

  my $radix = $this_signal_section->{radix};
  return $radix;
}


=item I<signal_display_format(module_name, signal_name)>

Returns the signal format to be displayed for the module.

=cut

sub signal_display_format {
  my $this = shift;
  my $module_name = shift;
  my $signal_name =shift;

  my $this_signal_section =
    $this->signal_display_section($module_name)->{$signal_name};

  my $format = $this_signal_section->{format};
  return $format;
}


=item I<signal_display_is_conditional(module_name, signal_name)>

Returns true if the signal is conditionally displayed.

=cut

sub signal_display_is_conditional {
  my $this = shift;
  my $module_name = shift;
  my $signal_name =shift;

  my $this_signal_section =
    $this->signal_display_section($module_name)->{$signal_name};

  my $conditional = $this_signal_section->{conditional};
  return ($conditional) ? 1:0;
}


=item I<signal_display_is_suppressed(module_name, signal_name)>

Returns true if the signal display is suppressed.

=cut

sub signal_display_is_suppressed {
  my $this = shift;
  my $module_name = shift;
  my $signal_name =shift;

  my $this_signal_section =
    $this->signal_display_section($module_name)->{$signal_name};

  my $suppressed = $this_signal_section->{suppress};
  return $suppressed;
}


=item I<hdl_output_filename()>

Get the name (with path) of the HDL-file we're going to generate.

=cut

sub hdl_output_filename {
   my $this  = shift;
   &ribbit ("too many arguments: access-only method") if @_;

   my $proj = $this->{project};
   my $name = join ("/", 
                    $this->system_directory(),
                    $this->target_module_name());

   $name .= "_test_component" if ($proj->_test_bench_component);
   $name .= ".vhd" if $this->_language() =~ /vhdl/i;
   $name .= ".v"   if $this->_language() =~ /verilog/i;
   return $name;
}


=item I<get_libraries()>

Returns a list of Altera libraries required to compile the simulation model.

=cut

sub get_libraries {
   my $this = shift;

   my @libs;

   if ($this->is_vhdl()) {
      @libs = qw (lpm altera altera_mf sgate);
   } else {



      @libs = qw (
          lpm_ver
          sgate_ver
          altera_mf_ver
          altgxb_ver
          stratixiigx_hssi_ver
          stratixgx_ver
          stratixgx_gxb_ver
          stratixiigx
          altera_ver
          stratixiii_ver
          stratixii_ver
          cycloneii_ver
          cycloneiii_ver
          stratixiv_hssi_ver
          arriaii_ver
          arriaii_pcie_hip_ver
          arriaii_hssi_ver
      );
   }
}


=item I<get_unique_files(file_types)>

Returns a list of unique simulation files based on the file_type argument. Some
example argument values are: 'ModelSim_Inc_Path',
'Simulation_HDL_Files', 'Precompiled_Simulation_Library_Files', 'PLI_Files'.

=cut

sub get_unique_files
{
   my $this = shift;
   my @file_types = @_;

   my $module_ref = $this->spaceless_system_ptf()->{MODULE};
   my @modules = keys %$module_ref;
   my @include_files;

   my %file_already_included;

   foreach my $file_type (@file_types)
   {
      foreach my $module (@modules)
      {
         next unless ($module_ref->{$module}{SYSTEM_BUILDER_INFO}{Is_Enabled});

         my $found_files  =
             $module_ref->{$module}{HDL_INFO}{$file_type};

         foreach my $new_file (split (/\s*\,\s*/s,$found_files))
         {
            push (@include_files, $new_file)
                unless ($file_already_included{lc($new_file)}++);
         }
      }
   }

   return (@include_files);
}


=item I<SYS_WSA()>

Get the Wizard Script Arguments (WSA for short) from the PTF hash table.

=cut

sub SYS_WSA {
  my $this = shift;
  if (@_) {
    &ribbit ("WSA is just an access function.  No arguments allowed");
  }
  my $system_ptf = $this->system_ptf();
  if (!$system_ptf) {
    return undef;
  }
  my $result = $this->system_ptf()->{WIZARD_SCRIPT_ARGUMENTS};
  if (!$result) {
    &goldfish ("system exists, but no WSA. system_ptf = ".%{$system_ptf});
  }
  return $result;
}



sub system_ptf {
  my $this = shift;

  my $proj = $this->{project};
  my $sys_section_name = "SYSTEM " . $this->system_name();

  if (@_) {
    my $new_sys_hash = shift;
    &ribbit ("system_ptf: too many arguments") if @_;
    ref ($new_sys_hash) eq "HASH" or &ribbit ("expected hash-reference");

    &ribbit ("Cannot set system PTF-hash without system-name")
      unless $this->system_name() ne "";

    $proj->{ptf_hash}->{$sys_section_name} = $new_sys_hash;
    return $new_sys_hash;
  }

  &goldfish ("dubious attempt to access system-hash without system name")
    if (($this->system_name() eq ""));

  return $proj->ptf_hash()->{$sys_section_name};
}


=item I<get_sim_commands()>

Get anything in a modules' setup commands section.
Ignore the assignment names, only the values matter.
Substitute the module's instance name for "__MODULE_PATH__"

=cut

sub get_sim_commands {
  my $this = shift;

  my @type_section_contents;
  my @command_section_contents;
  my @module_list = $this->get_ptf_module_list();

  foreach my $mod (@module_list) {
      my $mod_name    = $mod->name();
      my $sim_section = $this->_simulation_ptf_section($mod_name);

      next if (!$this->signal_display_is_enabled($mod_name));

      push (@type_section_contents,
            values(%{$sim_section->{MODELSIM}{TYPES}}));

      my $hackola = $sim_section->{Fix_Me_Up};

      foreach my $cmd (values (%{$sim_section->{MODELSIM}{SETUP_COMMANDS}})) {
         $cmd =~ s|__MODULE_PATH__|/test_bench/DUT/the_$mod_name|sg;

	 if($hackola eq "") {
	   $cmd =~ s|__FIX_ME_UP__\/|$hackola|sg;
	 } else {
	   $cmd =~ s|__FIX_ME_UP__|$hackola|sg;
	 }
	 push (@command_section_contents, $cmd);
       }
   }
  my @sim_commands;
  push @sim_commands, @type_section_contents;
  push @sim_commands, @command_section_contents;
  return @sim_commands;
}

=back

=cut

=head1 SEE ALSO

=begin html

<A HREF="e_project.html">e_project</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation

=cut

1;
