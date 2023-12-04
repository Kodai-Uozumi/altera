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






















use ptf_parse;
use HDL_parse;

package e_project;
@ISA = ("e_ptf");

=head1 NAME

e_project

=head1 SYNOPSIS

This example is straight from the clock crossing adapter

  use europa_all;
  use strict;

  my $proj = e_project->new(@ARGV);
  my $system_name = $proj->{_system_name};

=head1 DESCRIPTION

The top level thing.  It points to all modules within the project
and points to the top level module.  It also keeps track of project
level stuff like "language" (verilog or vhdl) design_for
(synthesis/simulation) via access to the system PTF file.

=cut

use strict;
use mk_bsf;
use e_ptf;
use filename_utils;
use format_conversion_utils;
use run_system_command_utils;
use print_command;
use europa_utils;

my $year;
{
  my ($sec, $min, $hour, $mday, $mon, $year_offset) = localtime(time);
  $year = $year_offset + 1900;
}
my $copyright_string = <<END_OF_COPYRIGHT_STRING;
Legal Notice: (C)$year Altera Corporation. All rights reserved.  Your
use of Altera Corporation\'s design tools, logic functions and other
software and tools, and its AMPP partner logic functions, and any
output files any of the foregoing (including device programming or
simulation files), and any associated documentation or information are
expressly subject to the terms and conditions of the Altera Program
License Subscription Agreement or other applicable license agreement,
including, without limitation, that your use is for the sole purpose
of programming logic devices manufactured by Altera and sold by Altera
or its authorized distributors.  Please refer to the applicable
agreement for further details.
END_OF_COPYRIGHT_STRING

=head1 METHODS

=over 4
=cut

my $default_module_type = "e_module";
my $top_module_type = $default_module_type;

=item I<new()>

Constructor copied straight out of the tutorial.  Now handles
generator commands

=cut

my %fields = (
              global_copyright_notice => $copyright_string,
              _top                   => "",
              module_hash           => {},
              _unknown_modules_name_hash => {},
              global                => {}, #global_variables go here
              all_names_hash        => {},
              module_pool           => {},
              parameter_module_pool => [],
              design_for            => "synthesis",
              language              => "verilog",
              _device_family        => "APEX20KE",
              check_x               => [],
              _pin_assignment_hash  => {},

              do_setup_quartus_synth => 0,
              do_make_symbol        => 0,
              do_make_sim_project   => 0,
              do_write_ptf          => 1,
              do_make_top_level_instance_wrapper  => 0,


              asic_enabled                     => "",
              asic_skip_top_level_testbench    => "",
              asic_third_party_synthesis       => "",
              asic_synopsys_translate_on_off   => "",
              asic_add_scan_mode_input         => "",


              _system_name          => "",
              __system_directory     => ".",
              __sopc_quartus_dir     => "",
              _sopc_modelsim_dir    => "",
              _sopc_directory       => ".",
              _sopc_lib_path        => "",
              _generate             => "",
              _software_only        => "",
              _bus_only             => "",
              _verbose              => "",
              _module_lib_dir       => "",
              _test_bench_component => "0",
              _projectname          => "",
              _simgen               => "",


              read_wait_states    => 0,
              write_wait_states   => 0,

              _special_modules_added  => 0,


              _begin_comment => "<ALTERA_NOTE> CODE INSERTED BETWEEN HERE",
              _end_comment   => "AND HERE WILL BE PRESERVED </ALTERA_NOTE>",


              _translate_off => "synthesis translate_off",
              _translate_on  => "synthesis translate_on",


              _quartus_translate_off => "synthesis read_comments_as_HDL off",
              _quartus_translate_on  => "synthesis read_comments_as_HDL on",

              user_comment_array => [],
              _a_bloody_simulation_hack => "",














              timescale   => '1ns / 1ps',
              
              



              doing_visible_wrapper_ports => 0,   # to generate VHDL signal list differently each time
              
              );

my %pointers = (
                module_ptf     => {},
                device_specific_ptf => {},
                _test_module    => (bless {}, "e_test_module"),
                );

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );

sub new
{
   my $this  = shift;
   my $self  = $this->SUPER::new();
   $self->build_new(@_);

   return $self;
}



=item I<build_new()>

Constructor is tricky, because you can construct from multiple
types of things.  We put this in a subfunction because that
way inherited classes can use (or override) it, too.
There are three ways to call the constructor:

  1. with a hash of named arguments
  2. with an @ARGV() hash of command-line parameters
  3. with another e_project (we warn you, 'cause it's weird)

=cut

sub build_new
{
  my $this = shift;

   my ($first_arg) = (@_);
   if (ref($first_arg) eq "HASH") {
     $this->set(@_);
   } elsif (&is_blessed($first_arg) && $first_arg->isa("e_project")) {
     &goldfish("Copy-constructor called for e_project.  That's suspicious\n.");
     $this->set(@_);
   } elsif (ref ($first_arg) eq "") {

     $this->handle_args (@_);
   } else {
     &ribbit ("Unrecognized arguments passed to e_project::new()");
   }
}



=item I<handle_args()>

This method handles args as passed in by mk_system_bus.
The following is the generator command copied directly from mk_systembus.pl

   $generator_cmd  = "$$arg{sopc_directory}/bin/iperl ";
   $generator_cmd .= "-I$$arg{sopc_directory}/bin ";
   $generator_cmd .= "$generator_program ";

   here are the args
   $generator_cmd .= " --system_name=$$arg{system_name}";
   $generator_cmd .= " --target_module_name=$mod_name";
   $generator_cmd .= " --system_directory=$$arg{system_directory}";
   $generator_cmd .= " --sopc_directory=$$arg{sopc_directory}";
   $generator_cmd .= " --sopc_lib_path=$$arg{sopc_lib_path}";
   $generator_cmd .= " --generate=1";
   $generator_cmd .= " --verbose=$$arg{verbose}";

=cut

my $handled_args = 0;
sub handle_args
{
   my $this = shift;











   my @commands = @_;
   my %command_hash;
   my $key;
   my $value;
   foreach my $command (@commands)
   {
      next unless ($command =~ /\-\-(\w+)\=(.*)/);

      $key = $1;
      $value = $2;

      $key = "\_".$key;
      $value =~ s/\\|\/$//; # crush directory structures which end with



      $command_hash{$key} = $value;
   }

   if (keys (%command_hash))
   {
      $this->set({%command_hash});


      my $sys_dir = $command_hash{_system_directory};
      my $file = $command_hash{_system_name};

      my $ptf_file = "$sys_dir/$file\.ptf";

      $this->ptf_file($ptf_file)
          if ($sys_dir && $file);


      my $current_ptf_hash = $this->system_ptf();


      if (exists
          ($current_ptf_hash->{WIZARD_SCRIPT_ARGUMENTS}) && exists
          ($current_ptf_hash->{WIZARD_SCRIPT_ARGUMENTS}{hdl_language}))
      {
         $this->language
             ($current_ptf_hash->{WIZARD_SCRIPT_ARGUMENTS}{hdl_language});
      }


      if (exists($current_ptf_hash->{WIZARD_SCRIPT_ARGUMENTS}) &&
          exists($current_ptf_hash->{WIZARD_SCRIPT_ARGUMENTS}{device_family}))
      {
         my $device_family = $current_ptf_hash->{WIZARD_SCRIPT_ARGUMENTS}{device_family};
         $this->device_family($device_family);


         $this->{device_family} = $device_family;
      }


      if (exists($current_ptf_hash->{WIZARD_SCRIPT_ARGUMENTS}) &&
          exists($current_ptf_hash->{WIZARD_SCRIPT_ARGUMENTS}{asic_enabled}))
      {
        $this->asic_enabled($current_ptf_hash->{WIZARD_SCRIPT_ARGUMENTS}{asic_enabled});
        if (exists($current_ptf_hash->{WIZARD_SCRIPT_ARGUMENTS}{asic_skip_top_level_testbench})){
	        $this->asic_skip_top_level_testbench($current_ptf_hash->{WIZARD_SCRIPT_ARGUMENTS}{asic_skip_top_level_testbench});
        }
        if (exists($current_ptf_hash->{WIZARD_SCRIPT_ARGUMENTS}{asic_third_party_synthesis})){
          $this->asic_third_party_synthesis($current_ptf_hash->{WIZARD_SCRIPT_ARGUMENTS}{asic_third_party_synthesis});
        }
        if (exists($current_ptf_hash->{WIZARD_SCRIPT_ARGUMENTS}{asic_synopsys_translate_on_off})){
          $this->asic_synopsys_translate_on_off($current_ptf_hash->{WIZARD_SCRIPT_ARGUMENTS}{asic_synopsys_translate_on_off});
        }
        if (exists($current_ptf_hash->{WIZARD_SCRIPT_ARGUMENTS}{asic_add_scan_mode_input})){
          $this->asic_add_scan_mode_input($current_ptf_hash->{WIZARD_SCRIPT_ARGUMENTS}{asic_add_scan_mode_input});
        }
      }
      


      $this->top();
      
   }



   if ( ($this->asic_enabled()) && ($this->asic_synopsys_translate_on_off()) ) {
     $this->_translate_off ("synopsys translate_off");
     $this->_translate_on ("synopsys translate_on");
   }

   if ( ($this->asic_enabled()) && ($this->asic_third_party_synthesis()) ) {
     $this->_quartus_translate_off ("// quartus read comments as hdl key removed");
     $this->_quartus_translate_on ("// quartus read comments as hdl key removed");
   }

   $handled_args = 1;
}



=item I<system_ptf()>

Return a reference to the SYSTEM ptf-hash.

=cut

sub system_ptf
{
  my $this = shift;

  my $sys_section_name = "SYSTEM " . $this->_system_name();

  if (@_) {


    my $new_sys_hash = shift;
    &ribbit ("system_ptf: too many arguments") if @_;
    ref ($new_sys_hash) eq "HASH" or &ribbit ("expected hash-reference");

    &ribbit ("Cannot set system PTF-hash without system-name")
      unless $this->_system_name() ne "";

    $this->ptf_hash()->{$sys_section_name} = $new_sys_hash;
    return $new_sys_hash;
  }

  &goldfish ("dubious attempt to access system-hash without system name")
    if (($this->_system_name() eq "") && !$handled_args);


  if (scalar keys %{$this->ptf_hash()} == 0) {
    return {};
  }
  my $result = $this->ptf_hash()->{$sys_section_name};

  &goldfish ("No SYSTEM section named \"" . $this->_system_name() . "\"")
    if !$result;

  return $result;
}


=item I<get_all_module_section_names()>

Returns a list of all names of all MODULE names anywhere in
the SYSTEM section of the PTF.  If there is more (or less) than one SYSTEM
section, then it's an error, and you lose.

=cut

sub get_all_module_section_names
{
   my $this = shift;
   &ribbit ("didn't expect unexpected argument") if (@_);

   return keys(%{$this->spaceless_system_ptf()->{MODULE}});
}


=item I<spaceless_module_ptf()>

Return a reference to the spaceless module ptf hash with name of
your choosing.  The default module is the target_module_name.

=cut

sub spaceless_module_ptf
{
   my $this = shift;
   my $module = shift || $this->_target_module_name();
   $module or &ribbit ("no module ($module)(",
                       $this->_target_module_name(),
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


=item I<get_module_ptf_by_name()>

=cut

sub get_module_ptf_by_name
{
   my $this = shift;
   return ($this->spaceless_module_ptf(@_));
}


=item I<get_slaves_by_module_name()>

So.. you know the name of a module, and you want to know the
names of all it's slaves.  Good for you.  Call this function.
It returns a list of strings, giving the interface names for all
slave sections for the indicated module name.

=cut

sub get_slaves_by_module_name
{
   my $this = shift;
   my $module_name = shift || &ribbit ("module-name required");
   &ribbit ("Too many arguments") if (@_);

   my $mod_ptf = $this->get_module_ptf_by_name($module_name);
   return $this->get_enabled_slaves($mod_ptf, 'SLAVE');
}


=item I<get_mastes_by_module_name()>

It returns a list of strings, giving the interface names for all
master sections for the indicated module name.

=cut

sub get_masters_by_module_name
{
   my $this = shift;
   my $module_name = shift || &ribbit ("module-name required");
   &ribbit ("Too many arguments") if (@_);

   my $mod_ptf = $this->get_module_ptf_by_name($module_name);
   return $this->get_enabled_slaves($mod_ptf, 'MASTER');
}


=item I<get_enabled_slaves()>

=cut

sub get_enabled_slaves
{
   my $this = shift;
   my ($mod_ptf, $slave_or_master) = @_;

   my @all_slaves = keys (%{$mod_ptf->{$slave_or_master}});
   my @enabled_slaves = ();

   foreach my $slave (@all_slaves)
   {
      my $slave_sbi = 
          $mod_ptf->{$slave_or_master}{$slave}{SYSTEM_BUILDER_INFO};
      push (@enabled_slaves, $slave)
          unless (($slave_sbi->{Is_Enabled} eq '0') ||
                  ($mod_ptf->{SYSTEM_BUILDER_INFO}{Is_Enabled} eq '0')
                  );
   }

   return @enabled_slaves;
}


=item I<builder_version()>

Returns the system-bulder version as a number.
deals with multiple decimal points like "1.1.1"

=cut

sub builder_version
{
  my $this = shift;
  &ribbit ("access-only function") if @_;

  my $version = $this->system_ptf()->{System_Wizard_Version};
  return $version
    unless $version =~ /^(\d+\.\d+)\.(.*)$/;


  my $good_num = $1;
  my $bad_num  = $2;
  $bad_num =~ s/\.//smgi;

  return $good_num + $bad_num / 100;
}


=item I<_target_module_name(module)>

Returns the name of the top module i.e. the module which instantiates
this module.  Setting this also sets top.

=cut

sub _target_module_name
{
   my $this       = shift;
   my ($mod_name) = @_;
   &ribbit ("too many arguments") if scalar(@_) > 1;

   if (@_ && ($mod_name ne ""))
   {
      $this->top($mod_name);
      $this->{_target_module_name} = $mod_name;
   }
   return $this->{_target_module_name};
}


=item I<_skip_down_ptf path()>

like its superior, except that we stick module_pointer hash in 
{SYSTEM $system}->{MODULE $top}-> and we stick global hash in 
{SYSTEM $system}->{MODULE $top}->{WIZARD_SCRIPT_ARGUMENTS}

=cut

sub _skip_down_ptf_path
{
    my $this = shift;
    my $ptf_hash = shift or &ribbit ("no ptf_hash");
    my $ptf_path = shift or &ribbit ("no ptf path");

    my $sys_hash = $this->ptf_hash()->{"SYSTEM ".$this->_system_name};
    my $module_pointer = "MODULE ".$this->_target_module_name();

    while (my $stone = shift (@$ptf_path))
    {



       if (!exists $ptf_hash->{$stone})
       {
           if (($ptf_hash == $sys_hash) &&
               ($stone eq "$module_pointer"))
           {
              $ptf_hash->{$stone} = $this->module_ptf();
           }
           else
           {
              if (($ptf_hash == $this->module_ptf()) &&
                  ($stone eq "WIZARD_SCRIPT_ARGUMENTS"))
              {
                 $ptf_hash->{$stone} = $this->global();
              }
              else
              {
                 $ptf_hash->{$stone} = {};
              }
           }
       }
       $ptf_hash = $ptf_hash->{$stone};
    }
    return ($ptf_hash);
}


sub top_module_type
{
  my $this = shift;
  if (@_)
  {
    $top_module_type = shift;
  }
  
  return $top_module_type;
}

=item I<_automatically_create_new_top_module()>

If someone asks for our top() module, and we don't have one
yet, we scramble around and try to make one.  How nice of us.
Generally, this just involves a call to e_module->new().
UNLESS...

A derived (child) class wants its top-module to be something
grander and more wonderful than an e_module.  For example,
our child "e_ptf_project" has higher aspirations, and wants
to have an "e_ptf_top_module" object as its top-module instead of
a lowly "e_module."  If it wants that, then it needs to override
this function.

They may be my guest.

=cut

sub _automatically_create_new_top_module
{
   my $this = shift;
   my $name = shift || &ribbit ("Required argument 'name' missing.");
   &ribbit ("too many arguments") if scalar(@_) != 0;

   my $top_module = $top_module_type->new({name => $name, project => $this,});
   $this->top_module_type($default_module_type);
   return $top_module;
}


=item I<top()>

May be set to e_module or a name that refers to an e_module
returns e_module corresponding to top

=cut

sub top
{
  my $this  = shift;
  
  my $set_value_was_string = 0;
  if (@_) {
    my ($new_mod) = shift;   # May be either a module-ref or a

    &ribbit ("too many arguments") if @_;

    my $new_module_name = $new_mod;      # Assume it's a string...
    $set_value_was_string = 1;
    

    if (&is_blessed ($new_mod) && $new_mod->isa ("e_module")) {
        $new_module_name = $new_mod->name();   # Write-down its name.
        $this->add_module($new_mod);           # Make sure it's in the project.
        $set_value_was_string = 0;
    }


    return $this->top() if $new_module_name eq "";

    $this->{_target_module_name} = $new_module_name;
    $this->_top($new_module_name);
    

  }


  my $top_module_name = $this->get_top_module_name();

  if ($this->module_hash() &&
      $this->module_hash()->{$top_module_name})
  {
    return $this->module_hash()->{$top_module_name};
  }
  else
  {




     if ($top_module_name && !$set_value_was_string)
     {
        my $new_mod =
            $this->_automatically_create_new_top_module($top_module_name);
        return ($new_mod);
     }
     else
     {
        return undef;
     }
  }
}


=item I<get_top_module_name()>

Return the given top module name, unless _test_bench_component is set.

=cut

sub get_top_module_name
{
    my $this = shift;
    my $top_module_name = $this->_top();
    if ($this->_test_bench_component) {
        $top_module_name .= "_test_component";
    }
    return $top_module_name;
}


=item I<test_module()>

Creates the test module using add_module() and returns it.

=cut

sub test_module
{
   my $this = shift;

   $this->add_module(@_);
   return $this->_test_module(@_);
}


=item I<add_module()>

When you add a module to the project via $project->add_module(), it
does two things.  First, it keeps a list of the modules by name in
the project.  This allows you to call a module by name when
instantiating instead of calling it by referring to an e_module.  It
also sets the modules _project field to $project.

=cut

sub add_module
{
   my $this  = shift;
   my $class = ref($this) or &ribbit ("$this is not a ref");

   foreach my $mod (@_)
   {
      &is_blessed($mod) && $mod->isa("e_module")
          or &ribbit ("$mod not a module\n");

      my $name = $mod->name() or &ribbit ($mod->identify(),"has no name");

      my $preexisting = $this->module_hash()->{$name};
      &ribbit ("$this, two modules have the same name ($name)\n")
        if ($preexisting && ($preexisting ne $mod));

      my $all_names_hash = $this->all_names_hash();
      $this->module_hash()->{$name} = $mod;
      $all_names_hash->{$name}++;

      map {$all_names_hash->{$_}++;}
      (keys (%{$mod->_object_list()}));
      $mod->_project($this);


      my $objects_which_want_to_know_about_this_module =
          $this->_unknown_modules_name_hash()->{$name} || [];

      foreach my $object
          (@$objects_which_want_to_know_about_this_module)
      {
         $object->module($mod);
      }
      delete $this->_unknown_modules_name_hash()->{$name};
   }

   return (@_);
}


=item I<modules()>

Returns a hash of all instantiated modules.

=cut

sub modules()
{
   my $this = shift;
   &ribbit ("access-only function") if @_;
   return values (%{$this->module_hash()});
}

sub add_modules
{
   my $this  = shift;
   my $class = ref($this) or &ribbit ("$this is not a ref");
   return ($this->add_module(@_));
}

sub add_new_module
{
   my $this = shift;
   foreach my $hash (@_)
   {
      my $ref = ref ($hash);
      $ref eq "HASH" or &ribbit ("$hash must be a hash reference");
      $this->add_module(e_module->new($hash));
   }
}
sub add_new_modules
{
   my $this = shift;
   $this->add_new_module(@_);
}

sub set_this_module_when_available
{
   my $this = shift;
   my ($name, $instance) = @_;

   my $existing_module = $this->module_hash()->{$name};
   if ($existing_module)
   {
      $instance->module($existing_module);
   }
   else
   {
      push (@{$this->_unknown_modules_name_hash()->{$name}}, $instance);
   }
}


=item I<make_new_private_module()>

Let's suppose you're making a peripheral of type P named "the_P".
Further suppose all  Ps have a (parameterized) submodule inside
them called "SubUnit_X".  Great.  Your europa code will make a new
e_module object whose "name" is "SubUnit_X", fill it up with
goodies, and write it all out to HDL.

That's great, until your project includes another P-type
peripheral named "the_other_P."  Guess what happens now?  During
europa-generation of "the_other_P", it, too, will create an
e_module object which is also called "SubUnit_X," and it will also
define this module's contents (which may or may not be different
from the original) and write its definition out to HDL.

Then Quartus (or Leo, or ModelSim, or anyone else) comes along and
tries to read-in your design files.  Lo and behold!  You have two
definitions for the module "SubUnit_X."  You are bad.  Game over.

This function gets around that by adding a module with a
"private" (guaranteed-noninterfering) name to the current project.
It does this by sticking the project's _target_module_name() onto
the root-name you pass in. It further ensures uniqueness by
adding numbers to the module name, if necessary.

The name you pass-in is used as the root name.
This function news-in an e_module object, adds it to the project,
and hands it back to you as its one return-value.  If you're curious
about the name it got, you can ask by calling its name() function.

=cut

my %private_name_scorecard = ();

sub private_module_name
{
   my $this = shift;
   my $root_name = shift or &ribbit ("root-name argument required.");

   my $name_without_number = 
       $root_name . "_which_resides_within_" . $this->_target_module_name();

   my $number = $private_name_scorecard{$name_without_number};
   $private_name_scorecard{$name_without_number}++;

   return $number ? $name_without_number . "_$number" : $name_without_number;
}

sub make_new_private_module
{
   my $this = shift;

   my $mod_name = $this->private_module_name(@_);

   my $mod = e_module->new ({name => $mod_name});
   $this->add_module ($mod);
   return $mod;
}


=item I<get_exclusive_name>

Returns a name that is not in use that is as close as possible to
the name given in as an input.

=cut

sub get_exclusive_name
{
   my $this  = shift;
   &is_blessed ($this) or &ribbit ("$this is not blessed\n");

   my $name = shift or &ribbit ("no name input");
   $name =~ s/^\s*(.*?)\s*$/$1/s;

   while ($this->all_names_hash()->{$name})
   {
      my $index = 0;
      if ($name =~ s/(\d+)$//)
      {
         $index = $1;
      }
      $name .= ++$index;
   }


   $this->all_names_hash()->{$name}++;
   return ($name);
}

sub delete_names
{
   my $this = shift;

   foreach my $name (@_)
   {
      delete ($this->module_hash()->{$name});
      delete ($this->all_names_hash()->{$name});
   }
}


=item I<_add_ram_and_rom_modules()>

You'd think that you'd want to add these in the new method.
Unfortunately, it causes a nasty recursive loop in use that I really
don't understand.  Since I've spend an entire DAY not understanding,
I've reached the point where I don't care any more and wish to get
on with my life.

=cut

sub _add_special_modules
{
   my $this = shift;


   return if ($this->_special_modules_added());
   $this->_special_modules_added(1);


   $this->add_new_module
       ({
          name => "dffe",
          contents => 
              [
               e_port->news
               ([ena  => 1,"in"],
                [clrn => 1,"in"],
                [prn  => 1,"in"],
                [d    => 1,"in"],
                [clk  => 1,"in"],
                [q    => 1,"out"]
                )
               ],
          _hdl_generated => 1,
          do_black_box => 1,
      });

   return;
}

{ # Functions and variables pertaining to wrapping and instantiation of 



  my @apex20k_master_port_list = qw(
    aclr
    cascin
    cascout
    cin
    clk
    combout
    cout
    dataa
    datab
    datac
    datad
    ena
    regout
    sclr
    sload
  );








sub add_signatured_apex20k_blind_instance
{
  my $this = shift;
  my $port_map = shift or ribbit("Need a port map\n");
  my $unused_port_tag = shift or ribbit("Need an 'unused port tag'\n");



  for my $port_name (keys %$port_map)
  {
    ribbit("unexpect apex20k port '$port_name'\n")
      if !grep {/$port_name/} @apex20k_master_port_list;
  }


  my $sig = 0;
  for my $port_name (sort keys %$port_map)
  {
    $sig <<= 1;
    $sig |= 1 if ($port_map->{$port_name} ne $unused_port_tag);
  }

  my $module_name = sprintf("%s_hidden_lcell_%X", $this->top()->name(), $sig);

  if (not $this->get_module_by_name($module_name))
  {

    $this->add_new_module(
      $this->make_signatured_apex20k_blind_instance($sig)
    );
  }
  return $module_name;
}

sub make_signatured_apex20k_blind_instance
{
  my $this = shift;
  my $sig = shift;



  my $index = 1;
  my @particular_port_list =
    grep
    {
      my $use_it = $sig & $index;
      $index <<= 1;
      $use_it;
    } reverse @apex20k_master_port_list;




  my %in_port_map = map {if (!/out$/) {($_ => $_)} else {()} } @particular_port_list;
  my %out_port_map = map {if (/out$/) {($_ => $_)} else {()} } @particular_port_list;


  my @port_descriptors = map {
    {
      name => $_,
      width => 1,
      direction => /out$/ ? 'output' : 'input',
      vhdl_default => $_ eq 'dataa' ? 0 : 1,
    }
  } @particular_port_list;

  my $particular_apex_instance_name =
    sprintf("%s_hidden_lcell_%X", $this->top->name(), $sig);
  my $wrapped_lcell_name = 'apex20k_lcell';


  my $sim_input;
  my $sim_output;
  for (keys %in_port_map)
  {
    $sim_input = $_;
    last;
  }

  for (keys %out_port_map)
  {
    $sim_output = $_;
    last;
  }

  return
  (
    {
      do_black_box => 1,
      output_file => $particular_apex_instance_name,
      name => $particular_apex_instance_name,
      vhdl_libraries => 
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
        },
      },
      contents => [
        e_assign->new({




          comment => " This module is a placeholder.  The assignment is never executed",
          tag => "simulation",
          lhs => $sim_output,
          rhs => $sim_input,
        }),
        e_blind_instance->new({
          tag => 'compilation',
          name => "the_$wrapped_lcell_name",
          module => $wrapped_lcell_name,
          in_port_map => \%in_port_map,
          out_port_map => \%out_port_map,
          parameter_map =>
          {
            operation_mode => 'operation_mode',
            output_mode => 'output_mode',
            packed_mode => 'packed_mode',
            lut_mask => 'lut_mask',
            power_up => 'power_up',
            cin_used => 'cin_used',
          },
        }),
        e_port->news(@port_descriptors),
        e_parameter->news(
          [qw(operation_mode counter STRING )],
          [qw(output_mode comb_and_reg STRING )],
          [qw(packed_mode false STRING )],
          [qw(lut_mask ffff STRING )],
          [qw(power_up low STRING )],
          [qw(cin_used false STRING )],
        ),
      ],
    }
  );

}

} # End of signatured-apex20k block.



=item I<update()>

=cut

sub update
{
   my $this  = shift;

   my $top = $this->top();

   $this->_add_special_modules();
   (&is_blessed ($top) &&
    $top->isa("e_module"))
       or &ribbit ("top ($top) is not a module");






   my $do_log = &validate_parameter ({hash    => $this->SYS_WSA(),
                                      name    => "do_log_history",
                                      type    => "boolean",
                                      default => "0",
                                     });
   e_object->do_log_history($do_log);


   $top->update();
}

sub identify_signal_widths
{
   my $this = shift;
   my $test_module = $this->test_module();
   my $top = $this->top();
   if (!$test_module->isa_dummy())
   {
      $test_module->update();
      $test_module->identify_signal_widths();
   }
   else
   {
      $top->identify_signal_widths();
   }
   $top->identify_inout_signals();
}


=item I<get_module_by_name()>

Returns an e_module based upon name.  If name is e_module, then it
just returns the e_module.  If name is a ref, it looks up e_module
in the module_hash which is indexed by names

=cut

sub get_module_by_name
{
   my $this  = shift;
   my $name = shift or &ribbit ("no module_name");
   return ($name)
       if (&is_blessed($name) && $name->isa("e_module"));

   return ($this->module_hash()->{$name});
}


=item I<is_system()>

Some projects are just modules, others are entire systems.
Want to find out which?  Just call this function.

=cut

sub is_system()
{
   my $this = shift;
   ribbit ("Access-only function") if @_;
   return (($this->_target_module_name() eq $this->_system_name()) &&
           ($this->_target_module_name() ne ""                   )  );
}


=item I<hdl_output_filename()>

Get the name (with path) of the HDL-file we're going to generate.

=cut

sub hdl_output_filename
{
   my $this  = shift;
   &ribbit ("access-only function") if @_;
   my $name = join ("/", 
                    $this->_system_directory(),
                    $this->_target_module_name());

   $name .= "_test_component" if ($this->_test_bench_component);
   $name .= ".vhd" if $this->language() =~ /vhdl/i;
   $name .= ".v"   if $this->language() =~ /verilog/i;
   return $name;
}


=item I<_get_verilog_megafunction_header()>

This inserts a comment at the top of the SOPC generated verilog
file which Quartus uses to associate a block diagram symbol with
the wizard which generated the verilog code.  Clicking on the
symbol in the Quartus block diagram editor brings up the wizard
if this comment exists, otherwise the verilg code is opened in 
an editor.

=cut

sub _get_verilog_megafunction_header
{
  my $this = shift;

  my $header = <<EOH;
megafunction wizard: %Altera SOPC Builder%
GENERATION: STANDARD
VERSION: WM1.0

EOH

  return $this->string_to_verilog_comment("", $header);
}


=item I<get_VHDL_megafunction_header()>

This inserts a comment at the top of the SOPC generated VHDL
file which Quartus uses to associate a block diagram symbol with
the wizard which generated the VHDL code.  Clicking on the
symbol in the Quartus block diagram editor brings up the wizard
if this comment exists, otherwise the verilg code is opened in 
an editor.

=cut

sub get_vhdl_megafunction_header
{
  my $this = shift;



  my $header = <<EOH;
megafunction wizard: %Altera SOPC Builder%
GENERATION: STANDARD
VERSION: WM1.0

EOH

  return $this->string_to_vhdl_comment("", $header);
}


=item I<device_family()>

Return device family name.

=cut

sub device_family
{
   my $this = shift;
   return $this->_device_family(@_) unless @_;

   my ($lingo, @unexpected_stuff) = (@_);
   &ribbit ("expected exactly one argument") 
       if (!$lingo || @unexpected_stuff);

   if ($lingo !~ /^(APEXII)|(APEX20K)|(APEX20KE)|(APEX20KC)|(EXCALIBUR_ARM)|(EXCALIBUR_MIPS)|(MERCURY)|(ACEX1K)|(FLEX10K)|(FLEX10KA)|(FLEX10KB)|(FLEX10KE)|(STRATIX)|(STRATIXGX)|(CYCLONE)|(CYCLONEII)|(CYCLONEIII)|(MAXII)|(STRATIXII)|(STRATIXIIGX)|(STRATIXIII)|(STRATIXIV)|(ARRIAII)|(TARPON)/i) {
      &dwarn ("Unrecognized output device_family '$lingo'. Using APEX20KE.\n");
      $lingo = "APEX20KE";
   }

   return $this->_device_family($lingo);
}


sub _get_begin_comment
{
   my $this = shift;
   my $language = $this->language();

   my $comment_string;
   $comment_string = "//" 
       if ($language =~ /verilog/i);

   $comment_string = "--" 
       if ($language =~ /vhdl/i);

   &ribbit ("language '$language' not known")
       unless ($comment_string);

   return $comment_string." ".$this->_begin_comment();
}

sub _get_end_comment
{
   my $this = shift;
   my $language = $this->language();

   my $comment_string;
   $comment_string = "//" 
       if ($language =~ /verilog/i);

   $comment_string = "--" 
       if ($language =~ /vhdl/i);

   &ribbit ("language '$language' not known")
       unless ($comment_string);

   return $comment_string." ".$this->_end_comment();
}


sub _get_user_code
{
   my $this = shift;

   my $file = $this->hdl_output_filename();


   open (IN_FILE, "<$file") or return;

   my $begin_comment = $this->_get_begin_comment();
   my $end_comment   = $this->_get_end_comment();

   my $file_contents;
   while (<IN_FILE>)
   {
      $file_contents .= $_;
   }
   close (IN_FILE);

   while ($file_contents =~ s/^.*?$begin_comment(.*?)$end_comment//s)
   {
      push (@{$this->user_comment_array()},
            $1
            )
   }
}

sub print_user_code
{
   my $this = shift;
   my $default = shift;
   my $guts = shift (@{$this->user_comment_array()});
   my $return = "\n\n".$this->_get_begin_comment().
       (($guts)? $guts: "\n$default\n").
           $this->_get_end_comment()."\n\n";

   return ($return);
}

sub first_explicitly_verilog_module
{
   my $this = shift;
   if (@_)
   {
      $this->{first_explicitly_verilog_module} = 
          $this->{first_explicitly_verilog_module} || 
          $_[0]->name;
   }
   my $return = $this->{first_explicitly_verilog_module}
   || '';

   return  $return;
}


=item I<output()>

Generate the HDL code.  If we're processing a top level system module
then create the generation script which launches the generators
for all instantiated components and adapters.  The top level script,
mk_systembus.pl calls the generation script. We also create the Quartus
block diagram symbol.
In addition, if simulation setup is enabled then we determine
which HDL simulator should be used and setup the simulation environment
through that simulator's configuration class.

=cut

sub output
{
   my $this  = shift;
   my $output_to_buffer = shift;

   my $top = $this->top();
   if (!$top)
   {

     if (@_)
     {
       $this->top(@_);
     }
     else
     {


       &ribbit ("No top module was specified.");
     }

     $top = $this->top();
   }

   $top->isa("e_module") or &ribbit ("No top module ('$top' is not a module)");

   if ($this->do_write_ptf() && !$this->_test_bench_component())
   {
      $this->module_ptf()->{HDL_INFO}{Synthesis_Only_Files} = "";
      $this->module_ptf()->{HDL_INFO}{Synthesis_HDL_Files}  = "";
      $this->module_ptf()->{HDL_INFO}{Simulation_HDL_Files} = "";
      $this->module_ptf()->{HDL_INFO}{Precompiled_Simulation_Library_Files} = "";
   }




   my $edf = $this->_system_directory() .
     '/' .
     $this->_target_module_name() .
     ".edf";
   if (-e $edf)
   {
     print STDERR "Deleting edif file '$edf'\n";
     unlink $edf;
   }


   $this->_get_user_code();

   &Progress ("updating ",$top->name()) if $this->_verbose();
   $this->update();
   &Progress ("done updating ",$top->name()) if $this->_verbose();
   my $comment = "";
   $this->identify_signal_widths();

   my $test_module = $this->test_module();

   foreach my $x (@{$this->check_x()})
   {
      my ($module,$net) = split (/\//s,$x);
      if (!($module && $net))
      {
         &ribbit ("bad form $x");
      }
      $this->get_module_by_name($module)->check_x($net);
   }

   if ($this->language() =~ /vhdl/) #.v becomes .vhd
   {
      if ($this->do_make_symbol())
      {


         $comment .= $this->get_vhdl_megafunction_header();
      }
      $comment .= $this->string_to_vhdl_comment
          ("",$this->global_copyright_notice());

      $this->top()->to_vhdl();
      unless ($test_module->isa_dummy())
      {
         $test_module->to_vhdl();
      }
   }
   else
   {
      if ($this->do_make_symbol())
      {


         $comment .= $this->_get_verilog_megafunction_header();
      }

      $comment .= $this->string_to_verilog_comment
          ("",$this->global_copyright_notice());

      $this->top()->to_verilog();
      unless ($test_module->isa_dummy())
      {
         $test_module->to_verilog();
      }
   }

   my $output_file = $this->hdl_output_filename();

   $this->_update_ptf($output_file);

   my $output_string;
   $output_string .= $comment;

   if ($this->language() =~ /verilog/i)
   {
       $output_string .= $this->_get_timescale_directive();
   } 

   $output_string .= join ("\n",@{$this->module_pool()->{$this->language()}});








   $this->top()->emit_hdl_neutral_files($this);

   my $top_name = $this->top()->name();

   if ($this->do_make_symbol()) {
     &Progress ("Generating Quartus symbol for top level: $top_name");
     $this->Make_Symbol();
   }

   $this->Create_Generation_Script() if $this->is_system();

   if($this->language() =~ /vhdl/)
   {
     my @additional_verilog = @{$this->module_pool()->{verilog} || []};
     if (@additional_verilog)
     {
        unshift (@additional_verilog, $this->string_to_verilog_comment
                 ("",$this->global_copyright_notice()));

        my $verilog_output_file = $this->_system_directory().'/'.
            $this->first_explicitly_verilog_module().'.v';

        open (NOT_ALTERA_FILEHANDLE, "> $verilog_output_file")
            or &ribbit ("Could not open $verilog_output_file\n");
        print NOT_ALTERA_FILEHANDLE join ("\n",@additional_verilog);
        close NOT_ALTERA_FILEHANDLE;
     }
   }

   my $sys_dir = $this->_system_directory();
   my $file = $this->_system_name();
   my $ptf_file = "$sys_dir/$file\.ptf";
   $this->ptf_file($ptf_file)
     if ($sys_dir && $file);

   my $simulator_configuration;

   if ($this->is_system() &&
       $this->do_make_sim_project()) {
     my $sopc_directory = $this->{_sopc_directory};
     my $sopc_builder_config = $sopc_directory . "/.sopc_builder";

     $sopc_builder_config =~ s/(\w):(\w.*)/$1:\\$2/;

     my $config_file = &ptf_parse::new_ptf_from_file($sopc_builder_config);







     my $hdl_simulator = $ENV{SOPC_HDL_SIMULATOR}
       || &ptf_parse::get_data_by_path($config_file, "sopc_hdl_simulator")
       || $this->{WIZARD_SCRIPT_ARGUMENTS}->{hdl_simulator}
       || "modelsim";

     &Progress("Running setup for HDL simulator: $hdl_simulator\n");

     my $simulator_class = 'e_' . $hdl_simulator;
     my $simulator_class_file = $simulator_class . '.pm';
     require $simulator_class_file or ribbit("failed loading $simulator_class");
     $simulator_configuration = $simulator_class->new({project => $this});
   }


   if ($this->do_make_sim_project() &&
       &validate_parameter ({hash    => $this->SYS_WSA(),
			      name    => "do_build_sim",
			      type    => "boolean",
			      default => "1",
			     })
      ) {
     $simulator_configuration->Build_Project();
   }

   $this->setup_quartus_synthesis()
     if ($this->do_setup_quartus_synth());


   if ($output_to_buffer) {
     return $output_string;
   }
   else {

      open (NOT_ALTERA_FILEHANDLE, "> $output_file")
          or &ribbit ("Could not open $output_file ($!)\n");
      print NOT_ALTERA_FILEHANDLE $output_string; 
      close (NOT_ALTERA_FILEHANDLE);
      &Progress ("output file ($output_file) created\n") if $this->_verbose();
   }
}


=item I<_doctor_written_ptf_values()>

As a full citizen of the "e_ptf"-club, we get to override this function
to add our own outgoing-filter on PTF-assignments that get written
into the final file.

As it happens, we do have a filter.  We want to replace all 
occurrances of the absolute path to the system directory
($this->system_directory) with the literal words:

__SOPC_BUILDER_SYSTEM_DIRECTORY__

The next time we read-in the PTF-file, we substitute 
the above string with the actual run-time-discovered system
directory name, whatever it may be.

This keeps our projects nice and portable.

=cut

my $PTF_SYS_DIR_TOKEN = "__PROJECT_DIRECTORY__";
sub _doctor_written_ptf_values
{
   my $this = shift;
   my $assignment_name = shift;
   my $original_value  = shift;

   &ribbit ("Two arguments required") 
        if $assignment_name eq "" && $original_value eq "";

   my $value = $original_value;   # Most of the time, it is!

   my $sys_dir = $this->_system_directory();
   $sys_dir =~ s|\\|/|g;

   $sys_dir =~ s|/$||;
   $sys_dir = quotemeta ($sys_dir);

   my $test_value = $value;
   $test_value =~ s|\\|/|sg;





   $test_value = ",$test_value";
   if ($test_value =~ s|(\,\s*)$sys_dir|$1$PTF_SYS_DIR_TOKEN|isg) {
      $value = $test_value;
      $value =~ s/^\,//;    # Get rid of that tricky comma we stuck there.
   }

   if (($sys_dir !~ /^./) &&  ($value =~ /$sys_dir/i)) { 
      print STDERR 
          "Warning: absolute path in PTF-assignment '$assignment_name'.\n";
      print STDERR "Project may not be portable.\n";
   }



   return $this->SUPER::_doctor_written_ptf_values($assignment_name, $value);
}


sub _doctor_incoming_ptf_file_string
{
   my $this = shift;
   my $raw_file_string = shift;

   my $sys_dir = $this->_system_directory();
   $raw_file_string =~ s/$PTF_SYS_DIR_TOKEN/$sys_dir/sg;
   return $this->SUPER::_doctor_incoming_ptf_file_string($raw_file_string);
}

sub _update_ptf
{
   my $this = shift;
   my $output_file = shift or &ribbit ("no output file");

   my $synthesis_file_tag = 'Synthesis_HDL_Files';
   if ($this->_simgen())
   {

      $output_file =~ s/(\.vh)d$/$1/;
      $output_file .= 'o';
   }

   my $current_synth_files = 
       $this->module_ptf()->{HDL_INFO}{$synthesis_file_tag};

   if ($current_synth_files !~ /$output_file/i) {
      $this->module_ptf()->{HDL_INFO}{$synthesis_file_tag} = 
          ($current_synth_files eq "") ?      $output_file 
          : join( ", ", $current_synth_files, $output_file);
   }


   $this->top()->to_ptf();
   $this->ptf_to_file()
       if ($this->do_write_ptf());

}


=item I<SBI()>

Frou-frou alias for something you could do in a more
fundamental (but more cumbersome) way.

"SBI" is the colloquial acronym for the "SYSTEM_BUILDER_INFO"
section of a module's PTF-file.  People might like a convenient way
to access their project's (target-module) SBI-section.

Here it is.

Returns a hash-ref which points directly at the target-module's 
SYSTEM_BUILDER_INFO section in our in-memory PTF database.
Modifications to this hash are ignored (not written to the PTF
-file on output, contrary to what you might suppose).  If you need
to modify the PTF-file, use e_project::system_ptf().

These days, modules can have more than one SBI section, so you have
to say which one you want.  There's a 'top-level' SBI section in a
module, and then there can be an SBI-section inside each
MASTER or SLAVE section (i.e. inside each interface).  So, when you
ask for -the- SBI section, you have to say which one you mean.  You
specify by giving the formal name of the interface (which, sorry,
you have to know) and whether or not it's a MASTER or SLAVE (default
is SLAVE).

=cut

sub SBI
{
  my $this = shift;
  my $result = $this->_find_and_get_ptf_section_amongst_interfaces 
      ("SYSTEM_BUILDER_INFO", @_);
  &goldfish("SBI not found") if !$result;

  return $result;
}


=item I<WSA()>

Frou-frou alias for something you could do in a more
fundamental (but more cumbersome) way.

"WSA" is the colloquial acronym for the "WIZARD_SCRIPT_ARGUMENTS"
section of a module's PTF-file.  People might like a convenient way
to access their project's (target-module) WSA-section.

Here it is.

Returns a hash-ref which points directly at the target-module's 
WIZARD_SCRIPT_ARGUMENTS section in our in-memory PTF database.
Modifications to this hash are ignored (not written to the PTF
-file on output, contrary to what you might suppose).  If you need
to modify the PTF-file, use e_project::system_ptf().

=cut

sub WSA
{
  my $this = shift;
  my $module_name = shift || $this->_target_module_name();
  return $this->_find_and_get_ptf_section_amongst_interfaces 
      ("WIZARD_SCRIPT_ARGUMENTS", "$module_name/");
}

sub _find_and_get_ptf_section_amongst_interfaces
{
  my $this = shift;
  my $section_name = shift or &ribbit ("no section to find.");
  my ($interface_name, $master_or_slave) = (@_);
  $master_or_slave = "SLAVE" if $master_or_slave eq "";
  &ribbit ("must specify MASTER or SLAVE sub-section")
    unless $master_or_slave =~ /^(MASTER)|(SLAVE)$/;







  my $module_name = $this->_target_module_name();
  if ($interface_name =~ m|^(.+)/(.*)$|) {
     $module_name    = $1;
     $interface_name = $2;
  }

  my $mod_ptf = $this->get_module_ptf_by_name($module_name)
      or &ribbit ("can't find ptf-section for module '$module_name'");


  return $mod_ptf->{$section_name} if $interface_name eq "";

  return $mod_ptf->{$master_or_slave}{$interface_name}{$section_name};
}

sub SYS_WSA
{
  my $this = shift;
  if (@_) {
    &ribbit ("WSA is just a frou-frou access function.  No arguments allowed");
  }
  my $system_ptf = $this->system_ptf();
  if ((!$system_ptf) || (scalar keys %{$system_ptf} == 0)) 
  {

    return undef;
  }
  my $result = $this->system_ptf()->{WIZARD_SCRIPT_ARGUMENTS};
  if (!$result) {
    &goldfish ("system exists, but no WSA. system_ptf = ".%{$system_ptf});
  }
  return $result;
}


=item I<get_max_slave_read_latency(module_name, master_port_name1, master_port_name2, ...)>

Return the maximum read latency of all slaves mastered by the
given module name and master port(s).

=cut

sub get_max_slave_read_latency
{
  my $this = shift;
  my ($module_name, @master_ports) = @_;

  (@master_ports == 1) or &ribbit ("only one master port please");

  my ($only_master) = @master_ports;
  my (@slave_names) = $this->get_slaves_by_master_name (@_);

  my @read_latencies = ();
  my $m_name = "$module_name/$only_master";
  my $master_bus_type = $this->spaceless_system_ptf()->{MODULE}
  {$module_name}{MASTER}{$only_master}{SYSTEM_BUILDER_INFO}{Bus_Type}
  or &ribbit ("master $m_name, no Bus_Type");

  foreach my $slave_name (@slave_names)
  {
     my $slave_SBI = $this->SBI($slave_name);
     my $read_latency = $slave_SBI->{Read_Latency} ||
         $slave_SBI->{Maximum_Pending_Read_Transactions};

     $read_latency += 2 if ($slave_SBI->{Bus_Type} ne
                            $master_bus_type);

     push (@read_latencies, 0 + $read_latency);
  }
  my $max_rl = max(@read_latencies);
  return $max_rl;
}




=item I<_get_master_list_from_description_args()>

These are built-in utility functions.
You use them to help you write functios which take 
master- or slave-descriptions as arguments.

This function can take a variety of different kinds of arguments
and give you the same derivative information.  For example,
you can call the "get_slaves_by_master_name" function
with three different descriptions of the master:

  my @slaves = get_slaves_by_master_name("the_nios/data_master");
  my @slaves = get_slaves_by_master_name("the_nios" "data_master");
  my @slaves = get_slaves_by_master_name("the_nios");

These functions translate any of the above interface-description
argument-styles into:

  - a module-name.
  - a list of interface-names.

=cut

sub _get_master_list_from_description_args
{
   my $this = shift;
   return $this->_get_interface_list_from_description_args ("MASTER", @_);
}

sub _get_slave_list_from_description_args
{
   my $this = shift;
   return $this->_get_interface_list_from_description_args ("SLAVE", @_);
}

sub _get_interface_list_from_description_args
{
   my $this = shift;

   my $MASTER_or_SLAVE  = shift;
   my $module_name = shift || $this->_target_module_name() or &ribbit ("!");
   my $interface_name = shift;

   $MASTER_or_SLAVE =~ /^(MASTER)|(SLAVE)$/i or 
       &ribbit ("first arg must be the word 'MASTER' or 'SLAVE'");


   if ($module_name =~ m|^(.*)/(.*)$|) { 
      &ribbit ("nice try.  Too many interface-names.") if $interface_name;
      $module_name = $1;
      $interface_name = $2;
   }

   my $module_ptf = $this->get_module_ptf_by_name ($module_name);

   my @interface_name_list =  $interface_name  ? ($interface_name) : 
                             $this->get_enabled_slaves
                             ($module_ptf, $MASTER_or_SLAVE);

   return ($module_name, @interface_name_list);
}


=item I<_get_sbi_boolean_list()>

For each module, look up a value in its sbi section.  Do not
traverse the master and slave subsections.

Return value is:

  in list context, a list of list refs of the form:
  ( [modulename1, class1, value1], [modulename2, class2, value2], ... )

  in scalar context, the number of true values found.

=cut

sub _get_sbi_boolean_list
{
  my $this = shift;
  my $sbi_value_name = shift;

  my @values = ();

  my $module_ref = $this->spaceless_system_ptf()->{MODULE};
  my @modules = keys %$module_ref;

  foreach my $module (@modules)
  {

    next unless $module_ref->{$module}{SYSTEM_BUILDER_INFO}{Is_Enabled};

    my $m = $module_ref->{$module};

    push @values,
      [$module, $m->{class}, $m->{SYSTEM_BUILDER_INFO}->{$sbi_value_name}];
  }

  return @values if (wantarray);
  return scalar(grep {$_->[1]} @values);
}


=item I<get_slaves_by_master_name()>

This function will pass-back a LIST of STRINGS.  The strings
are fully-qualified interface names a-la "the_avalon_uart/s1".
The list will include, of course, a string for each individual
slave-interface which is mastered by the entity you described
in your arguments.

If you passed-in (1) a module-name and a master-name, then 
the list includes all slaves mastered by that-and-only-that master.

If you passed-in (2) just a module name, then the list includes
all slaves mastered by -any- of the master ports on that module.

If you passed-in (3) nothing, then it's just like you passed-in 
the "_target_module_name()" for this project, and life proceeds 
per case (2).

(secret:  If you pass-in only one argument with a slash in it,
then it presumes case (1).

THIS FUNCTION RECURSES THROUGH BRIDGES and gives you names of --all--
leaf-slaves that are connected to you, wherever they may lie.   The
names of the slave-sections which are parts of the bridges themselves
are not included. 

=cut

sub get_slaves_by_master_name
{
   my $this = shift;
   my ($module_name, @master_name_list) = 
       $this->_get_master_list_from_description_args (@_);

   return $this->_get_slaves_mastered_by_master_name 
        ($module_name, \@master_name_list, 1);
}

sub get_directly_connected_slaves_by_master_name
{
   my $this = shift;
   my ($module_name, @master_name_list) = 
       $this->_get_master_list_from_description_args (@_);

   return $this->_get_slaves_mastered_by_master_name 
        ($module_name, \@master_name_list, 0);
}


sub _get_slaves_mastered_by_master_name 
{
   my $this = shift;
   my $module_name = shift;
   my $master_name_list = shift;
   my $recurse_through_bridges = shift ;

   my @my_little_slaves = ();


   foreach my $test_mod_name ($this->get_all_module_section_names())
   {
      my $test_mod_ptf = $this->get_module_ptf_by_name($test_mod_name);
      next unless $test_mod_ptf->{SYSTEM_BUILDER_INFO}{Is_Enabled};




      my @test_slave_name_list = 
          $this->get_slaves_by_module_name($test_mod_name);

      foreach my $master_name (@{$master_name_list}) 
      {
         foreach my $test_slave_name (@test_slave_name_list) 
         {
            my $slave_SBI = $this->SBI ("$test_mod_name/$test_slave_name");
            my $master_by = $slave_SBI->{MASTERED_BY};
            my $is_connected = 0;

            foreach my $master_connection (keys (%$master_by))
            {
               my $adapter_master = $master_by->{$master_connection}{ADAPTER_MASTER};
               if ($adapter_master)
               {
                  if (grep {$_ eq "$module_name/$master_name"} keys %$adapter_master)
                  {
                     $is_connected = 1;
                     last;
                  }
               }
               elsif ($master_connection eq "$module_name/$master_name")
               {
                  $is_connected = 1;
                  last;
               }
            }

            next unless $is_connected;
            next if ($slave_SBI->{Is_Enabled} eq '0');

            my $bridge_master = $slave_SBI->{Bridges_To};
            my $has_base_address = (exists ($slave_SBI->{Has_Base_Address}))?
                $slave_SBI->{Has_Base_Address}: (($bridge_master)? 0:1);
            if ($bridge_master && !($has_base_address) 
                  && $recurse_through_bridges) 
            {
               push (@my_little_slaves, 
                     $this->get_slaves_by_master_name($test_mod_name, 
                                                      $bridge_master));
            } 
            else 
            { 

               push (@my_little_slaves, "$test_mod_name/$test_slave_name");
            }
         }
      }
   }
   return @my_little_slaves;
}



=item I<get_data_width_by_interface_name()>

You pass-in a description of a master-or-slave interface, 
and this thing will tell you the data-width for that interface.

=cut

sub get_interface_data_width
{
   my $this = shift;
   my $MASTER_or_SLAVE = shift || "SLAVE";
   my ($module_name, $interface_name, @other_interfaces) = 
       $this->_get_interface_list_from_description_args($MASTER_or_SLAVE, @_);
   &ribbit ("you must specify one of the several ports on $module_name")
       if (@other_interfaces);
   &ribbit ("no module name") unless $module_name;
   &ribbit ("no interface name") unless $interface_name;

   return 
    $this->SBI("$module_name/$interface_name", $MASTER_or_SLAVE)->{Data_Width};
}



=item I<get_master_data_width()>

=cut

sub get_master_data_width
{
   my $this = shift;
   return $this->get_interface_data_width("MASTER", @_);
}



=item I<get_slave_data_width()>

=cut

sub get_slave_data_width
{
   my $this = shift;
   return $this->get_interface_data_width("SLAVE", @_);
}

sub _get_unique_hdl_files
{
   my $this = shift;

   my $module_ref = $this->spaceless_system_ptf()->{MODULE};
   my @modules = keys %$module_ref;
   my @include_files;

   my %file_already_included;

   push (@include_files, $this->_get_unique_files("Synthesis_HDL_Files"));
   return (@include_files);
}

sub _get_unique_files
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

sub _get_unique_sim_hdl_files
{
   my $this = shift;

   my $module_ref = $this->spaceless_system_ptf()->{MODULE};
   my @modules = keys %$module_ref;
   my @include_files;

   my %file_already_included;

   my $language = $this->language();
   my $Language = $language;
   $Language =~ s/^v/V/;
   my $language_section = "$language\_Sim_Model_Files";
   my $Language_section = "$Language\_Sim_Model_Files";

   return ($this->_get_unique_files($language_section,
                                    $Language_section,
                                    "Simulation_HDL_Files",
                                    "Synthesis_HDL_Files"));
}



=item I<simulation_directory()>

Returns the name of the simulation directory for the current
project.

=cut

sub simulation_directory
{
   my $this = shift;
   my $was_called_statically = ref ($this) eq "";


   my $simdir = "NO directory.";
   if ($was_called_statically) {
      my $sys_dir = shift or &ribbit ("?");
      my $sim_dir = shift or &ribbit ("?");
      return join ("/",  $sys_dir, $sim_dir."_sim");
   } else {
      &ribbit ("Access-only function") if scalar(@_) != 0;
      $simdir = join ("/",
                      $this->_system_directory(),
                      $this->_system_name()."_sim"
                      );
   }





   &Create_Dir_If_Needed($simdir);
   return $simdir;
}


sub print_debug
{
  my $this = shift;
  my ($string) = (@_);
  
  printf($string);
}



=item I<get_quartus_file_name()>

Return the Quartus project file name.
Preference is given to files with extension ".qpf".
Failing that, the old-fashioned ".quartus" is sought.

=cut

sub get_quartus_file_name
{
    my $this = shift;
    my $proj;
     if (opendir DIR, "./")
     {
       my @files = readdir DIR;
       closedir DIR;
       my @qpfs = grep {/\.qpf$/i} @files;
       my @quartus = grep {/\.quartus$/i} @files;

       if (1 != @qpfs && 1 != @quartus)
       {
         if (1 != @qpfs)
         {
           print_debug("Expected 1 .qpf project file, found ",
             0 + @qpfs, ": \n");
           if (0 == @qpfs)
           {
             print_debug("... no .qpf project files!\n");
           }
           else 
           {
             print_debug(join("; ", @qpfs), "\n");
           }
         }

         if (1 != @quartus)
         {
           print_debug("Expected 1 quartus project file, found ",
             0 + @quartus, ": \n");
           if (0 == @qpfs)
           {
             print_debug("... no project quartus files!\n");
           }
           else 
           {
             print_debug(join("; ", @quartus), "\n");
           }
         }
         return;
       }



       for my $q (\@qpfs, \@quartus)
       {
         if (1 == @$q)
         {


           $proj = $q->[0];
           last;
         }
       }
     }
    return $proj;
}

sub tcl_add_file
{
  my $this = shift;
  my ($file_type, $file_name) = @_;

  my $string = "set_global_assignment -name $file_type $file_name\n";
  return ($string);
}

sub tcl_add_pins
{
  my $this = shift;
  my ($pins, $name, $lsb) = @_;

  $lsb += 0; # force lsb to be a number
  
  my @strings = ();
  my @pin_array = split (/\,/s,$pins); 
  my $vector_index = $lsb;
  foreach my $pin (@pin_array)
  {



          if ($pin =~ /^$/) {
            $vector_index++;
            next;
          }


	  if ($pin =~ /^\s*[A-Z]*\d+\s*$/) {
	    $pin = "PIN_".$pin; 
	  }

	  if ($pin !~ /^\s*PIN_[A-Z]*\d+\s*$/) {
	    &goldfish ("tcl_add_pins: unknown format '$pin' for pin $name.  Expecting format of PIN_[letter][number]");
	  }
	  $name or 
	    &goldfish ("tcl_add_pins: $pin assigned without a name");
	  my $string_name = $name;
	  if (@pin_array > 1)
	  {
	  	$string_name .= "[$vector_index]";
	  }
	  my $string = "set_location_assignment $pin -to $string_name\n";
	  push (@strings, $string);
	  $vector_index++;
  }
  return (@strings);
}

sub build_tcl_header
{
  my $this = shift;
  my $string; 

  my $warning = "# Caution: this file may be regenerated by SOPC Builder.  User edits will be lost.\n";
  $string .= $warning;
  my $quartus_project_name = get_quartus_file_name();
  my $quartus_project_name_with_path = $this->_system_directory()."/".$quartus_project_name;



  $string .= qq[project_open -current_revision "$quartus_project_name_with_path"]."\n";
  return $string;
}

sub build_tcl_footer
{
  my $this = shift;
  my $string; 


  $string = qq[project_close]; 
  return $string;
}

sub run_tcl_script
{
  my $this = shift;
  my $tcl_script = shift;

  my @quartus_tcl_command_line;
  my $error_code;

  my $quartus_directory = $this->get_quartus_rootdir();



  @quartus_tcl_command_line = ( qq[$quartus_directory/bin/quartus_sh],
        "-t",
        $tcl_script );

  printf("@quartus_tcl_command_line" . "\n\n");

  open (ABRAHAM_LINCOLN_STEALTH, "");
  close ABRAHAM_LINCOLN_STEALTH;
  my $error_code = &System_Win98_Safe (\@quartus_tcl_command_line);
  open (ABRAHAM_LINCOLN_NO_STEALTH, "");
  close ABRAHAM_LINCOLN_NO_STEALTH;

  return $error_code;
}


sub get_quartus_rootdir
{
  my $this = shift;


  my $quartus_directory = $ENV{QUARTUS_ROOTDIR};

  if ($quartus_directory eq '')
  {
    die("error: environment variable 'QUARTUS_ROOTDIR' is not assigned.\n");
  }


  $quartus_directory =~ s|/$||;

  return $quartus_directory;
}

sub make_top_level_instance_wrapper
{
  my $this = shift;

  my $wrapper_module = e_module->new({
    name => $this->name()."_inst",
    comment => "",
    contents => [
      e_instance->new({
        name => $this->name(),
        module => $this->top(),
        comment => "this is a wrapper file",
      }),
    ]
  });

  $wrapper_module->to_vhdl();
}


=item I<setup_quartus_synthesis()>

Setup the Quartus synthesis project.

=cut

sub setup_quartus_synthesis
{
  my $this = shift;
  my $WSA              = $this->SYS_WSA();
  my $sys_name         = $this->_system_name();
  my $system_directory = $this->_system_directory();
  my $quartus_project_name = get_quartus_file_name();
  my $language = $this->language();
  my $tcl_script_contents="";
  my $tcl_script_string = "";


  my @imported_hdl_files;
  push(@imported_hdl_files, $this->_get_unique_files("Imported_HDL_Files"));
  foreach my $file_and_path (@imported_hdl_files){
    $tcl_script_string .= $this->tcl_add_file("SOURCE_FILE", $file_and_path);
  }

  if($WSA->{Run_Through_Compilation}){
    $quartus_project_name =~ s|.quartus||sg;

    $tcl_script_string .= 
qq[if {![project cmp_exists $quartus_project_name]} {
   puts "project $quartus_project_name does not exist.  Cannot run through to compile!"      
      } else {
   project set_active_cmp $quartus_project_name
   puts "Attempting to compile project $quartus_project_name!"
   cmp start 
   while {[cmp is_running] == 1} {
      after 5000  
      puts "running"   
   }
}]."\n";
    }






  my @object_tcl_command_list;
  my @module_array = values (%{$this->module_hash()});
  foreach my $module (@module_array)
  {
    push (@object_tcl_command_list, 
          grep {$_ ne ''} @{$module->get_tcl_commands()});
  }
  
  push (@object_tcl_command_list, $this->get_system_level_pin_assignments());
  
  my $object_tcl_commands = join (";\n", ($tcl_script_string, @object_tcl_command_list));



  if ($object_tcl_commands ne '')
  {
    $tcl_script_contents = 
      $this->build_tcl_header() .
      $object_tcl_commands .
    $this->build_tcl_footer();
  }
  my $tcl_file = "${sys_name}_setup_quartus.tcl";


  if($tcl_script_contents ne ""){
    open (TCL, ">$tcl_file")
      || die "Couldn't open $tcl_file ($!)\n";
    print TCL $tcl_script_contents;
    close (TCL);



    if($WSA->{do_not_source_tcl}){
      &Progress ("PTF setting: Do_Not_Source_TCL set.");
      &Progress ("Not running quartus_cmd $tcl_file!");
    }else{
      &Progress ("Setting up Quartus with $tcl_file");
      $this->run_tcl_script($tcl_file);
    }
  }


  my @imported_tcl_files;
  push(@imported_tcl_files, $this->_get_unique_files("Imported_TCL_Files"));
  foreach my $file_and_path (@imported_tcl_files){
    $this->run_tcl_script($file_and_path);
  }
}





sub get_system_level_pin_assignments
{
    my $this = shift;
    my $wsa = $this->spaceless_system_ptf()->{WIZARD_SCRIPT_ARGUMENTS};
    my $board_class = $wsa->{board_class};

    my @return;

    my $hash = $wsa->{CLOCKS}{CLOCK};
    my @clocks = (keys (%$hash));
    foreach my $clock_name (@clocks)
    {
      my $value = $hash->{$clock_name}{BOARD_COMPONENT}{$board_class}{pin_assignment};

      $value = $hash->{$clock_name}{pin_assignment} if !$value; # try simple assignment, too!

      if ($value ne '')
      {
        my $clock_source = $hash->{$clock_name}{source};
        my $node_name;
        if ($clock_source eq "External") {
          $node_name = $this->augment_clock_name($clock_name);
        } else {

          $node_name = $clock_name;
        }
        push (@return, "set_location_assignment PIN_$value -to $node_name ;");
      }
	}

    my $hash = $wsa->{RESETS}{RESET};
    my @resets = (keys (%$hash));
    foreach my $reset_name (@resets)
    {
      my $value = $hash->{$reset_name}{BOARD_COMPONENT}{$board_class}{pin_assignment};

      $value = $hash->{$reset_name}{pin_assignment} if !$value; # try simple assignment, too!

      if ($value ne '')
      {
        push (@return, "set_location_assignment PIN_$value -to $reset_name ;");
      }
	}
	
    return @return;
}


















my %Leonardo_Device_Family_Decoder_Ring = 
    (
     APEXII           => "apexii",
     APEX20K          => "apex20",
     APEX20KE         => "apex20e",
     APEX20KC         => "apex20c",
     EXCALIBUR_ARM    => "excalibur_arm",
     EXCALIBUR_MIPS   => "excalibur_mips",
     MERCURY          => "mercury",
     ACEX1K           => "acex1",
     FLEX10K          => "flex10",
     FLEX10KA         => "flex10a",
     FLEX10KB         => "flex10b",
     FLEX10KE         => "flex10e",
     STRATIX          => "stratix",
     STRATIXGX        => "stratix",
     CYCLONE          => "stratix",  # just a place holder.
     );

sub Run_Leonardo
{
   my $this = shift;
   my @input_file_list = ($this->_get_unique_hdl_files(),
                          $this->_get_unique_files("Synthesis_Only_Files"));
   
   my $sys_name         = $this->_system_name();
   my $system_directory = $this->_system_directory();

   my $WSA              = $this->SYS_WSA();


   my $tcl_file    =
       "$system_directory/$sys_name\_leonardo_tcl_script.tcl";
   my $command_file =
       "$system_directory/$sys_name\_leonardo_commands.cmd";
   
   my $target = 
       $Leonardo_Device_Family_Decoder_Ring{$WSA->{device_family}};
   
   die "ERROR Run_Leonardo NULL TARGET! ($WSA->{device_family}) does not map!\n"
       if ($target eq "");
   
   my $hierarchy_option = $WSA->{leo_flatten} ? "hierarchy_flatten"  :
       "hierarchy_auto" ;
   my $optimize_option = $WSA->{leo_area}     ? "area"  :
       "delay" ;

   my $freq_in_MHz = ($WSA->{clock_freq})/1000000; # note, need not be int.   
   my $system_name_hdl = ($this->language() =~ /verilog/) ? $sys_name.".v" : $sys_name.".vhd";


   my $pass_option = "pass={1}";

   if (exists $WSA->{leo_pass}) {
       $pass_option = $WSA->{leo_pass};
   }

   my $LEO_CMD_FILE_TAIL=<<END_OF_TAIL;
-product=ls1
-target=$target
-macro
-$optimize_option
-max_frequency=$freq_in_MHz
-effort standard
-$hierarchy_option
-enable_dff_map_optimize
END_OF_TAIL

   if ($pass_option) {
     $LEO_CMD_FILE_TAIL .= "-$pass_option\n";
   }

    open (LEO_CMD, ">$command_file")
        or die ("ERROR: couldn't open $command_file: $!");

   print LEO_CMD join ("\n",
                       @input_file_list,

                       "$system_name_hdl",
                       "$sys_name.edf",
                       "-module=$sys_name",
                       $LEO_CMD_FILE_TAIL
                       );
   close (LEO_CMD);

   my $sopc_directory = $this->_sopc_directory() 
     or &ribbit ("No sopc_directory specified.  Can't run spectrum.\n");
   my $spectrum_bin_dir = "$sopc_directory/bin/spectrum/bin";
   $spectrum_bin_dir .= "/win32" if ($^O =~ /(MSWin|cygwin)/i);
   my $spectrum_command = "$spectrum_bin_dir/spectrum";
   my @spectrum_command_line = 
    ($spectrum_command , "-command_file=$command_file");

   if (1) # $WSA->{skip_synth})
   {
      print STDERR "
         Nios system module $sys_name *not synthesized*
         You must synthesize this module before you can place
         and route in Quartus.\n";
   } else {
      &Progress ("Launching synthesis tool with (@spectrum_command_line)");

      open (ABRAHAM_LINCOLN_STEALTH, "");
      close ABRAHAM_LINCOLN_STEALTH;
      my $error_code = &System_Win98_Safe (\@spectrum_command_line);
      open (ABRAHAM_LINCOLN_NO_STEALTH, "");
      close ABRAHAM_LINCOLN_NO_STEALTH;

      if ($error_code == 2) {
         die "
       Leonardo Spectrum was unable to run due to a bad 
       or nonexistant license file.
       Be sure that you have a valid license to run
       the \"Altera OEM\" version of Leonardo Spectrum.
       You can obtain a license from \"www.altera.com\".\n";
      }
      if ($error_code == 1) {
         die "
       Leonardo Spectrum did *not* run successfully.
       Spectrum has reported an error in a design file.

       You must resynthesize this module before you can place
       and route in Quartus.\n";
      }
      if ($error_code != 0) {
         die "
       Leonardo Spectrum did *not* run successfully.
       Spectrum quit because of an unknown error: $error_code.

       You must resynthesize this module before you can place
       and route in Quartus.\n";
      }
      &Progress ("Spectrum Done.");
   }
}




=item I<Make_Symbol()>

It's nice, sometimes, to make a .bsf-file (Quartus symbol).  This
is done, in general, for system-projects (not individual module
projects).

Mr. Ferrucci wrote a very nice Perl program that generates a
bsf-file from a simple description of all the ports.
Here's what Mr. Ferrucci expects:
   A list of "segments", where each segment is:
     A string of comma-separated port-descriptions, each of which is:
       A "|"-separated string with three values:  Name, width, direction.

You can specify a perfectly-good symbol with only one segment, but
Mr. Ferrucci does us the kind courtesy of drawing a dotted-line 
in between the segments if there are more than one.  That's the only
difference between a list of "segments" and one big segment.

The segments are drawn in the order they appear in this description,
top-to-bottom, with inputs on the left and outputs (+inouts) on the right.
Within any segment, the ports are sorted alphabetically.

=cut

sub Make_Symbol
{
   my $this = shift;
   my $system_mod = $this->top() 
       or &ribbit ("No top module for symbol");

   my $top_name = $system_mod->name();
   my %port_section_hash = 
       %{$system_mod->_organize_ports_into_named_groups()};




   my @new_port_names;
   my %new_port_info;

   my @symbol_segments = ();
   foreach my $segment_name (sort(keys(%port_section_hash))) {
      my @port_list = @{$port_section_hash{$segment_name}};
      my @port_desc_list = ();

      foreach my $port_obj (@port_list) {
         my $port_name = $port_obj->name();
         my $width = $port_obj->width();
         my $direction = $system_mod->get_port_direction_by_name($port_name);
         push (@port_desc_list, 
               join (" | ", $port_name, $width, $direction));


         push (@new_port_names, $port_name);
         $new_port_info{$port_name}{width} = $width;
         $new_port_info{$port_name}{direction} = $direction;
      }
      push (@symbol_segments, join (",\n", @port_desc_list));
   }


   my $bsf_filename = sprintf ("%s/%s.bsf", 
                               $this->_system_directory(),
                               $top_name
                               );

   my $need_to_regenerate = 1;
   if (-e $bsf_filename)
   {




      my $existing = &HDL_parse::HDL_Get_Module_Info_From_File
          (file => $bsf_filename);
      my $mod_hash = $existing->{$top_name};

      my @old_port_names = sort (keys (%$existing));
      my @new_port_names = sort (@new_port_names);

      if (@new_port_names == @old_port_names)
      {
         $need_to_regenerate = 0;
         foreach my $new_port_name (@new_port_names)
         {
            my $old_port_name = shift (@old_port_names);

            if (($old_port_name ne $new_port_name) ||

                ($existing->{$old_port_name}{width} != 
                 $new_port_info{$new_port_name}{width}) ||

                ($existing->{$old_port_name}{direction} ne
                 $new_port_info{$new_port_name}{direction})
                )
            {
               $need_to_regenerate = 1;
               last;
            }
         }

      }
   }

   if ($need_to_regenerate)
   {
      &Progress("Generating Symbol $bsf_filename");
      my $bsf_contents = &Generate_BSF ($this->_system_name(), @symbol_segments);

      open (BSFOUT, "> $bsf_filename") or die
          "Generate_Symbol: Couldn't open $bsf_filename for output. $!";
      print BSFOUT $bsf_contents;
      close BSFOUT;
   }
   else
   {
      &Progress("Symbol $bsf_filename already exists, no need to regenerate");
   }
}

















my %caller_record;

sub _system_directory
{
   my $this = shift;

   return ($this->__system_directory(@_));
}

=item I<_sopc_quartus_dir()>

    Now when set, also creates device_specific_ptf which is an e_ptf
    object.  This gets automatically called by handle_args


=cut

sub _sopc_quartus_dir
{
   my $this = shift;
   my $return = $this->__sopc_quartus_dir(@_);
   if (@_)
   {


      my $device_specific_ptf = $return;
      if ($device_specific_ptf)
      {
         $device_specific_ptf =~ s|\\|\/|g;
         $device_specific_ptf .= '/' unless ($device_specific_ptf =~
                                             m|\/$|);
         $device_specific_ptf .= 'sopc_builder/bin/sopc_devices.ptf';
         if (-e $device_specific_ptf)
         {
            $this->device_specific_ptf(e_ptf->new({ptf_file =>
                                                       $device_specific_ptf}));
         }
      }
   }
   return $return;
}

sub to_esf 
{
  my $this = shift;


}






sub get_cpu_arch
{
    my $this = shift;
    my $module_name = shift;

    my $cpu_arch = $this->spaceless_system_ptf()->{MODULE}
        {$module_name}{WIZARD_SCRIPT_ARGUMENTS}{CPU_Architecture}
        or &ribbit("$module_name has no CPU_Architecture entry in PTF file.");

    return $cpu_arch;
}


sub get_nios_cpu_arch
{
    my $this = shift;
    my $module_name = shift;

    my $cpu_arch = $this->get_cpu_arch($module_name);

    if ($cpu_arch eq "nios_16" || $cpu_arch eq "nios_32") {
        return "nios";
    } elsif ($cpu_arch eq "nios2") {
        return "nios2";
    } else {
        &ribbit("$module_name isn't a Nios CPU");
    }
}











sub get_ci_slave_cpu_arch
{
    my $this = shift;
    my $slave_id = shift;

    my ($module_name, $slave_name) = split('/', $slave_id);


    my $base_addr_str = $this->spaceless_system_ptf()->{MODULE}
        {$module_name}{WIZARD_SCRIPT_ARGUMENTS}{Base_Address};

    if (!defined($base_addr_str)) {
        $base_addr_str = $this->spaceless_system_ptf()->{MODULE}
          {$module_name}{SLAVE}{$slave_name}{SYSTEM_BUILDER_INFO}
          {Base_Address};
    }
    
    if (!defined($base_addr_str)) {
        &ribbit("$slave_id has no Base_Address entry in PTF file.");
    }
    
    if ($base_addr_str =~ /^[a-z_]+\d+$/i) {
        return "nios";   # Nios I
    } elsif ($base_addr_str =~ /^0x[0-9a-f]+$/i) {
        return "nios2";   # Nios II
    } else {
        &ribbit(
          "$slave_id Base_Address entry of $base_addr_str format is bad.");
    }
}



sub get_ci_slave_base_addr
{
    my $this = shift;
    my $slave_id = shift;

    my ($module_name, $slave_name) = split('/', $slave_id);


    my $base_addr_str = $this->spaceless_system_ptf()->{MODULE}
        {$module_name}{WIZARD_SCRIPT_ARGUMENTS}{Base_Address};

    if (!defined($base_addr_str)) {
        $base_addr_str = $this->spaceless_system_ptf()->{MODULE}
          {$module_name}{SLAVE}{$slave_name}{SYSTEM_BUILDER_INFO}
          {Base_Address};
    }

    if (!defined($base_addr_str)) {
        &ribbit("$slave_id has no Base_Address entry in PTF file.");
    }



    $base_addr_str =~ s/^[a-z_]+(\d+)$/$1/i;

    return eval($base_addr_str);
}



sub get_ci_slave_address_width
{
    my $this = shift;
    my $slave_id = shift;

    my ($module_name, $slave_name) = split('/', $slave_id);

    my $address_width_str = $this->spaceless_system_ptf()->{MODULE}
        {$module_name}{SLAVE}{$slave_name}{SYSTEM_BUILDER_INFO}
        {Address_Width}
        || "0";

    return eval($address_width_str);
}



sub get_ci_slave_top_addr
{
    my $this = shift;
    my $slave_id = shift;

    my ($module_name, $slave_name) = split('/', $slave_id);

    my $address_width = $this->get_ci_slave_address_width($slave_id);
    my $num_addrs = 0x1 << $address_width;

    return $this->get_ci_slave_base_addr($slave_id) + $num_addrs - 1;
}







sub get_ci_slave_inst_type
{
    my $this = shift;
    my $slave_id = shift;

    my ($module_name, $slave_name) = split('/', $slave_id);

    my $cpu_arch = $this->get_ci_slave_cpu_arch($slave_id);

    if ($cpu_arch eq "nios") {




        my $ci_cycles = $this->spaceless_system_ptf()->{MODULE}
            {$module_name}{WIZARD_SCRIPT_ARGUMENTS}{ci_cycles};

        if (!defined($ci_cycles)) {
          $ci_cycles = 
            $this->spaceless_system_ptf()->{MODULE}{$module_name}{SLAVE}
              {$slave_name}{SYSTEM_BUILDER_INFO}{ci_cycles};
        }

        if (!defined($ci_cycles)) {
            &ribbit(
              "$slave_id has no ci_cycles entry in the SBI or WSA section");
        }

        if ($ci_cycles < 1) {
            &ribbit("$slave_id ci_cycles of $ci_cycles is an illegal value");
        }

        return ($ci_cycles == 1) ? "combinatorial" : "fixed multicycle";
    } elsif ($cpu_arch eq "nios2") {



        my $ci_inst_type = $this->spaceless_system_ptf()->{MODULE}
            {$module_name}{WIZARD_SCRIPT_ARGUMENTS}{ci_inst_type};

        if (!defined($ci_inst_type)) {
            $ci_inst_type = 
              $this->spaceless_system_ptf()->{MODULE}{$module_name}{SLAVE}
                {$slave_name}{SYSTEM_BUILDER_INFO}{ci_inst_type};
        }

        if (!defined($ci_inst_type)) {
            &ribbit(
              "$slave_id has no ci_inst_type entry in the WSA or SBI section");
        }

        if ($ci_inst_type ne "combinatorial" && 
            $ci_inst_type ne "fixed multicycle" &&
            $ci_inst_type ne "variable multicycle") {
            &ribbit(
              "$slave_id ci_inst_type of $ci_inst_type is an illegal value");
        }

        return $ci_inst_type;
    } else {
        &ribbit("$slave_id has unknown CPU architecture of $cpu_arch");
    }
}





sub get_master_ci_bits_to_decode
{
    my $this = shift;
    my $master_id = shift;


    my @slave_ids = $this->get_slaves_by_master_name($master_id);

    if (scalar(@slave_ids) < 2) {


        return 0;
    }
   


    my $max_top_addr = -1;


    foreach my $slave_id (@slave_ids) {
        my $top_addr = $this->get_ci_slave_top_addr($slave_id);

        if ($top_addr > $max_top_addr) {
            $max_top_addr = $top_addr;
        }
    }

    return Bits_To_Encode($max_top_addr);
}







sub get_master_ci_slave_decode_expr
{
    my $this = shift;
    my $master_id = shift;
    my $n_field = shift;
    my $slave_ids = shift;

    my ($module_name, $master_name) = split(/\//, $master_id);


    if (scalar(@$slave_ids) == 0) {
        return "1'b0";
    }

    my $addr_decode_bits = $this->get_master_ci_bits_to_decode($master_id);

    if ($addr_decode_bits == 0) {

        return "1'b1";
    }

    my @sub_compares;

    foreach my $slave_id (@$slave_ids) {

        my $base_addr = $this->get_ci_slave_base_addr($slave_id);
        my $address_width = $this->get_ci_slave_address_width($slave_id);
        my $msb = $addr_decode_bits - 1;
        my $lsb = $address_width;
        my $padded_zeroes = ($lsb == 0) ? "" : ", " . $lsb. "\'b0";

        push(@sub_compares,
          "{$n_field \[$msb:$lsb\] " .
          $padded_zeroes . 
          "} == ${addr_decode_bits}\'h" .
          sprintf("%x",$base_addr));
    }

    return &::or_array(@sub_compares);
}




sub get_quartusdir_makefile_prefix
{
  return 'QUARTUS_PROJECT_DIR';
}

sub get_simdir_makefile_prefix
{
  return 'SIMDIR';
}

sub resolve_contents_info_file
{
  my $this = shift;
  my $filename = shift;

  my $qdir_pfx = get_quartusdir_makefile_prefix();
  my $qdir = $this->__system_directory();
  $filename =~ s/$qdir_pfx/$qdir/g;

  my $simdir_pfx = get_simdir_makefile_prefix();
  my $simdir = $this->simulation_directory();
  $filename =~ s/$simdir_pfx/$simdir/eg;

  return $filename;
}


sub get_placeholder_warning_filename
{
  return "contents_file_warning.txt";
}


sub get_placeholder_warning_file_absolute_path
{
  my $this = shift;
  my $was_called_statically = ref ($this) eq "";

  my $simdir;
  if ($was_called_statically) {
    $simdir = shift;
  } else {
    $simdir = $this->simulation_directory();
  }

  return "$simdir/" .
    e_project->get_placeholder_warning_filename();
}

sub get_placeholder_warning_filename_for_makefile
{
  my $this = shift;

  return
    '$(' . $this->get_simdir_makefile_prefix() . ')' .
    "/" .
    $this->get_placeholder_warning_filename();
}

sub update_placeholder_warning_file
{
  my $this = shift;
  my $options = shift;





  my %modules;
  my $marker_file = $this->get_placeholder_warning_file_absolute_path();
  if (open MARKER_FILE, "$marker_file")
  {

    while (<MARKER_FILE>)
    {

      if (/^\t(.*)$/)
      {
        $modules{$1} = 1;
      }
    }
    close MARKER_FILE;
  }

  if ($options->{action} eq 'add')
  {
    $modules{$options->{name}} = 1;
  }
  elsif ($options->{action} eq 'delete')
  {
    delete $modules{$options->{name}};
  }
  else
  {
    ribbit("unexpected action '$options->{action}'\n");
  }

  if (keys %modules)
  {
    open MARKER_FILE, ">$marker_file" ||
      ribbit("Can't open '$marker_file' for write.\n");

    print MARKER_FILE
      "\nWarning: simulation may not function properly until valid contents files\n" .
      "are created for the following memory modules:\n\n";

    for my $mod (sort keys %modules)
    {

      print MARKER_FILE "\t$mod\n";
    }

    print MARKER_FILE "\n" .
      "If this is a Nios II processor system, you can create valid contents files\n" . 
      "for these memories by building a software project using the Nios II IDE or\n" .
      "the Nios II Command-Line Tools.  See the Nios II Software Developer's\n" .
      "Handbook for more details.\n";
    close MARKER_FILE;
  }
  else
  {

    unlink $marker_file;
  }
}































sub make_placeholder_contents_files
{
  my ($this, $Opt) = @_;

  ribbit("expected e_project") if ref($this) ne 'e_project';
  ribbit("expected hash reference") if ref($Opt) ne 'HASH';

  my $wsa = $this->system_ptf()->{"MODULE $Opt->{name}"}->{WIZARD_SCRIPT_ARGUMENTS};
  my $ptf_contents_string = $wsa->{contents_info};
  my %ptf_contents_info;
  my $eval_string = "\%ptf_contents_info = qw($ptf_contents_string);";
  eval($eval_string);
  if ($@)
  {
    ribbit("eval of '$eval_string' failed; $@\n");
  }



  my %contents_info;
  for my $key (keys %ptf_contents_info)
  {
    my $resolved_key = $this->resolve_contents_info_file($key);
    $contents_info{$resolved_key} = $ptf_contents_info{$key};
  }

  my %new_contents_info;

  for my $file_hr ($Opt->{hdl_contents_file}, $Opt->{sim_contents_file})
  {
    next if !defined $file_hr;

    ribbit "unexpected target type '$file_hr->{target}'\n"
      if (!grep {$_ eq $file_hr->{target}} (qw(mif dat hex)));

    my $addr_low = $Opt->{Base_Address};
    $addr_low = oct($addr_low) if ($addr_low =~ /^0/);
    my $addr_high = $Opt->{Address_Span};
    $addr_high = oct($addr_high) if ($addr_high =~ /^0/);
    $addr_high += $addr_low - 1;



    my_srand($addr_low);

    my $data = {};
    if ($file_hr->{target} ne 'dat')
    {

      $data = make_memory_contents_hash( 
        $addr_low,
        $addr_high,
        $Opt->{set_rand_contents} ? \&make_rand_byte_data : \&make_byte_data
      );
    }
    for my $lane (0 .. -1 + @{$file_hr->{targets}})
    {
      my $contents_file_record = $file_hr->{targets}->[$lane];
      my $contents_file = $contents_file_record->{full_path};

      next if !$contents_file;



      my %memory_contents = %$data;













      my $safe_to_overwrite_placeholder =

        !-e $contents_file ||


        exists $contents_info{$contents_file} &&
        (get_mtime($contents_file) eq $contents_info{$contents_file});

      if (!$safe_to_overwrite_placeholder)
      {
        $this->update_placeholder_warning_file({
          name => $Opt->{name}, action => 'delete',
        });
        next;
      }

      ribbit("Can't open file '$contents_file' for write")
        if (!open FILE, ">$contents_file");











      my $string = '';
      if ($file_hr->{target} ne 'dat')
      {

        my $num_bytes = $Opt->{make_individual_byte_lanes} ? 1 : $Opt->{Data_Width} / 8;

        my $mem_depth = $Opt->{make_individual_byte_lanes} ? $Opt->{Address_Span} / $Opt->{Data_Width} * 8: $Opt->{Address_Span} / $num_bytes;
        my $record_size = sprintf("%02X", $num_bytes);
        my $data = '00' x $num_bytes;
        my $type = '00';
        my $address;

        for ($address=0; $address < $mem_depth; $address ++){
          my $address_str = sprintf("%04X", $address);
            

          my $record_str = $record_size . $address_str . $type . $data;
          my $checksum = 0;

          for (my $offset = 0; $offset < length ($record_str); $offset += 2){
            my $nibble = substr ($record_str, $offset, 2);
            $checksum += hex $nibble;
          }

          my $checksum_str = sprintf ("%02X", (-$checksum & 0xFF));
    
          $string .= ':' . $record_size . $address_str . $type . $data. $checksum_str. "\n";
        }


        $string .= ":00000001ff\n";
      }

      print FILE $string;
      close FILE;



      my $modify_time = get_mtime($contents_file);





      $new_contents_info{$contents_file_record->{contents_info_path}} = $modify_time;

      $this->update_placeholder_warning_file({
        name => $Opt->{name}, action => 'add',
      });
    }
  }




  for (keys %new_contents_info)
  {
    $ptf_contents_info{$_} = $new_contents_info{$_};
  }



  my $contents_info;
  map {$contents_info .= "$_ $ptf_contents_info{$_} "} keys %ptf_contents_info;
  $wsa->{contents_info} = $contents_info;
}

sub make_memory_contents_hash
{
  my ($addr_low, $addr_high, $data_sub) = @_;
  my $data = {};

  for (my $i = $addr_low; $i <= $addr_high; $i++)
  {
    $data->{$i} = &$data_sub($i);
  }

  return $data;
}

sub get_mtime
{
  my $filename = shift;
  my (
    $dev,
    $ino,
    $mode,
    $nlink,
    $uid,
    $gid,
    $rdev,
    $size,
    $atime,
    $mtime,
    $ctime,
    $blksize,
    $blocks,
  ) = stat $filename;
  return $mtime;
}

sub make_byte_data
{
  my $byte_addr = shift;
  return 0;
}

{

  my $next = 0xFF;
  sub make_rand_byte_data
  {
    my $bit = (!!($next & 8) ^ !!($next & 0x10) ^ !!($next & 0x20) ^ !!($next & 0x80)) ? 1 : 0;
    $next = 0xFF & (($next << 1) | $bit);

    return $next;
  }

  sub my_srand
  {
    my $seed = shift;
    $seed &= 0xFF;
    $seed = 0xFF if (0 == $seed);
    $next = $seed;
  }
}

sub extract_lane
{
  my ($data_ref, $num_lanes, $lane) = @_;
  my %contents;

  my @byte_addresses = sort {$a <=> $b} keys %$data_ref;
  for (my $i = 0; $i < @byte_addresses; $i += $num_lanes)
  {
    $contents{$byte_addresses[$i / $num_lanes]} = $data_ref->{$byte_addresses[$i + $lane]};
  }
  return %contents;
}





















sub get_PERL5LIB_for_make
{
  my $this = shift;
  ribbit "no project!" if !$this;

  my $qrd = '$(QUARTUS_ROOTDIR)';

  return 
    "PERL5LIB=$qrd/sopc_builder/bin/perl_lib:" .
    "$qrd/sopc_builder/bin/europa:" .
    "$qrd/sopc_builder/bin:; export PERL5LIB; ";
}

sub get_cpu_reset_address
{
  my ($this, $master) = @_;

  my $master_wsa = $this->WSA($master);
  ribbit("no master wsa for '$master'") if !$master;


  my $reset_offset = $master_wsa->{reset_offset};
  ribbit("no reset offset for master '$master'") if !$reset_offset;


  my $reset_slave = $master_wsa->{reset_slave};
  ribbit("no reset slave for master '$master'") if !$reset_offset;

  my $reset_slave_sbi = $this->SBI($reset_slave, 'SLAVE');
  ribbit("no sbi section for reset slave for master '$master'")
    if !$reset_slave_sbi;

  my $reset_base = $reset_slave_sbi->{Base_Address};

  map {$_ = oct if /^0/} ($reset_offset, $reset_base);

  return sprintf("0x%X", $reset_base + $reset_offset);  
}

sub get_my_cpu_masters_through_bridges
{
  my $this = shift;
  my $master_module = shift;
  my $bridge_slave = shift;

  return $this->get_my_masters_through_bridges(
    $master_module,
    $bridge_slave,
    1, # cpu_only_please
    0, # give_full_interface_names
    1, # traverse_opaque_bridges
  );
}

sub get_my_masters_through_bridges
{
  my $this = shift;
  my $module = shift;
  my $slave_name = shift;
  my $cpu_only_please = shift;
  my $give_full_interface_names = shift;
  my $traverse_opaque_bridges = shift;
  my $visited_masters = shift;

  $visited_masters = {} if !defined($visited_masters);

  my @master_list;



  my $slave_interface = "$module/$slave_name";
  if (defined($visited_masters->{$slave_interface}))
  {
    ribbit(__PACKAGE__ . "::get_my_masters_through_bridges: recursion loop on slave '$slave_interface'\n");
  }
  $visited_masters->{$slave_interface} = 1;

  my $slave_sbi = $this->SBI($slave_interface);
  my @master_interfaces = map {/MASTERED_BY/i ? keys %{$slave_sbi->{$_}} : ()} keys %$slave_sbi;

  for my $master_interface (@master_interfaces)
  {
    my ($master_module, $master_name) = split('/', $master_interface);

    my $master_SBI = $this->SBI($master_interface, 'MASTER');
    my $bridge_slave = $master_SBI->{Bridges_To} || 
      ($traverse_opaque_bridges && $master_SBI->{Opaque_Bridges_To});
    if ($bridge_slave)
    {

      my @masters_of_this_bridge = $this->get_my_masters_through_bridges(
        $master_module,
        $bridge_slave,
        $cpu_only_please,
        $give_full_interface_names,
        $traverse_opaque_bridges,
      );

      push @master_list, @masters_of_this_bridge;
    }
    else
    {
      if ($cpu_only_please)
      {
        my $module_sbi = 
          $this->system_ptf()->{"MODULE $master_module"}->{SYSTEM_BUILDER_INFO};

        if (!$module_sbi || !$module_sbi->{Is_CPU})
        {
          next;
        }
      }

      push @master_list, $master_interface;
    }
  }

  if ($give_full_interface_names)
  {
    return @master_list;
  }
  else
  {




    my %master_modules = map {s|/.*$||; ($_, 1)} @master_list;
    return keys %master_modules;
  }
}






































sub do_makefile_target_ptf_assignments
{
  my ($this, $slave_name, $targetref, $options) = @_;
  

  my $ptf_module_name = $this->_target_module_name();
  my $module_ptf = $this->system_ptf()->{"MODULE $ptf_module_name"};
  my $wsa = $module_ptf->{WIZARD_SCRIPT_ARGUMENTS};
  
  my $do_build_sim = $this->system_ptf()->{WIZARD_SCRIPT_ARGUMENTS}->{do_build_sim};


  delete $wsa->{MAKE};
  

  if (0 == @$targetref)
  {



    delete $wsa->{contents_info};
    
    return;
  }



  $options->{target_info} = {};

  my $sbi = $module_ptf->{SYSTEM_BUILDER_INFO};
  my $slave_sbi = $this->SBI("$ptf_module_name/$slave_name");
  my $slave_wsa =
    $this->system_ptf()->{"MODULE $ptf_module_name"}->{"SLAVE $slave_name"}->
      {WIZARD_SCRIPT_ARGUMENTS};
      
  my $default_class = $module_ptf->{class};
  

  $options = {} if !defined $options;
  $options->{name} = $this->_target_module_name()
    if !defined $options->{name};
  $options->{class} = $default_class if
    !defined $options->{class};
  $options->{num_lanes} = 1 if
    !defined $options->{num_lanes};
  $options->{is_epcs} = $options->{class} eq 'altera_avalon_epcs_flash_controller'
    if !defined $options->{is_epcs};
  $options->{lang} = $this->system_ptf()->{WIZARD_SCRIPT_ARGUMENTS}->{hdl_language}
    if !defined $options->{lang};
  
  for (qw(Data_Width Is_Big_Endian Address_Span Base_Address Address_Width))
  {
    $options->{$_} = $slave_sbi->{$_}
      if !defined $options->{$_};
  }


  my $endian_option = $options->{Is_Big_Endian} ? "--big-endian-mem" : "";
  


  if ($options->{Address_Span} eq '')
  {
    $options->{Address_Span} = 2**$options->{Address_Width} * $options->{Data_Width} / 8;
  }
  

  my $refdes = $slave_wsa->{flash_reference_designator};
  


  if (!defined $refdes)
  {
    $refdes = $slave_wsa->{cfi_flash_refdes};
    $slave_wsa->{flash_reference_designator} = $refdes;
    delete $slave_wsa->{cfi_flash_refdes};
  }


  $wsa->{MAKE} = {};
  my $wsa_make = $wsa->{MAKE};



  $wsa_make->{"TARGET delete_placeholder_warning"} = {};
  $wsa_make->{"TARGET delete_placeholder_warning"}->{$ptf_module_name} = {
    Command1 => "rm -f @{[$this->get_placeholder_warning_filename_for_makefile()]}",
    Is_Phony => 1,
    Target_File => 'do_delete_placeholder_warning',
  };









  if (grep {/^flashfiles$/} @$targetref)
  {
    my $flashtarget_macro_tmp1 = uc($options->{name}) . "_FLASHTARGET_TMP1";
    my $flashtarget_macro_tmp2 = uc($options->{name}) . "_FLASHTARGET_ALT_SIM_PREFIX";
    my $flashtarget_macro = uc($options->{name}) . "_FLASHTARGET";
 
    my $sim_warning_prefix = 'RUN_ON_HDL_SIMULATOR_ONLY_';
    $wsa_make->{MACRO}->{$flashtarget_macro_tmp1} = "\$(ALT_SIM_OPTIMIZE:1=$sim_warning_prefix)";
    $wsa_make->{MACRO}->{$flashtarget_macro_tmp2} = '$(' . "$flashtarget_macro_tmp1:0=" . ')';
    $options->{flashtarget} = '$(' . $flashtarget_macro_tmp2 . ')' . "$options->{name}.flash";
  }


  my $announce_intention = '@echo Post-processing to create $(notdir $@)';
  my $simdir = '$(' . $this->get_simdir_makefile_prefix() . ')';
  my $create_simdir_if_necessary =
    "if [ ! -d $simdir ]; then mkdir $simdir ; fi";
  
  for my $target (@$targetref)
  {
    $target eq 'flashfiles' and do {



      my @master_list = $this->get_my_cpu_masters_through_bridges(
          $ptf_module_name,
          $slave_name
        );

      my $boot_copier_key = 'Boot_Copier';
      $boot_copier_key .= '_EPCS' if $options->{is_epcs};
      $boot_copier_key .= '_BE' if $options->{Is_Big_Endian};
      my $boot_copier_macro = uc($boot_copier_key);

      for my $master (@master_list)
      {
        $wsa_make->{"MASTER $master"} = {};



        my $cpu_specific_make_section = $wsa_make->{"MASTER $master"};
        my $cpu_wsa = $this->WSA($master);




        my $boot_copier =
          $cpu_wsa->{$boot_copier_key} ||
          "warning_no_Boot_Copier_found_in_component_$master";

        my $component_class =
          $this->system_ptf()->{"MODULE $master"}->{class};
          

        my $cpu_reset_address = $this->get_cpu_reset_address($master);
        $cpu_specific_make_section->{MACRO}->{CPU_RESET_ADDRESS} =
          $cpu_reset_address;
        $cpu_specific_make_section->{MACRO}->{$boot_copier_macro} = $boot_copier;
        $cpu_specific_make_section->{MACRO}->{CPU_CLASS} = $component_class;
        if ($options->{is_epcs})
        {

          my $boots_from_epcs = 0;
          if (oct($options->{Base_Address}) == oct($cpu_reset_address))
          {
            $boots_from_epcs = 1;
          }
          $cpu_specific_make_section->{MACRO}->{BOOTS_FROM_EPCS} = $boots_from_epcs;
        }
      }

      $wsa_make->{"TARGET flashfiles"} = {};
      $wsa_make->{"TARGET flashfiles"}->{$ptf_module_name} = {};
      my $hr = $wsa_make->{"TARGET flashfiles"}->{$ptf_module_name};
      $hr->{Dependency} = '$(ELF)';
      $hr->{Target_File} = $options->{flashtarget};
      my $base = $slave_sbi->{Base_Address};
      $base = oct($base) if $base =~ /^0/;
      
      my @commands = ($announce_intention);


      my $elf2flash_command = "elf2flash " .
        "--input=\$(ELF) " .
        "--flash=$refdes " .
        "--boot=\$(DBL_QUOTE)\$(shell \$(DBL_QUOTE)\$(QUARTUS_ROOTDIR)/sopc_builder/bin/find_sopc_component_dir\$(DBL_QUOTE) \$(CPU_CLASS) \$(QUARTUS_PROJECT_DIR))/\$($boot_copier_macro)\$(DBL_QUOTE) " .
        "--outfile=$options->{flashtarget} " .
        '--sim_optimize=$(ALT_SIM_OPTIMIZE) '
        ;


      if ($options->{is_epcs})
      {



        $elf2flash_command .=
          "--epcs " .
          "--base=0x0 " .
          "--end=0x7FFFFFFF "
        ;
      }
      else
      {


        $elf2flash_command .=
          "--base=@{[sprintf('0x%X', $base)]} " .
          "--end=@{[sprintf('0x%X', $base + $wsa->{Size} - 1)]} " .
          "--reset=\$(CPU_RESET_ADDRESS) "
        ;  
      }
      push @commands, $elf2flash_command;


      makefile_conditionalize_on(\@commands, 'BOOTS_FROM_EPCS') if ($options->{is_epcs});

      my $command_number = 1;
      for (@commands)
      {
        $hr->{"Command$command_number"} = $_;
        $command_number++;
      }
      next
    };

    $target eq 'dat' and do {

      if (!$do_build_sim)
      {
        $this->make_sim_contents_apology($wsa_make, $ptf_module_name, $simdir, $create_simdir_if_necessary);
        next;
      }

      $wsa_make->{MACRO}->{PAD_DAT_FILES} = "--pad=0";
      $wsa_make->{"TARGET dat"} = {};
      $wsa_make->{"TARGET dat"}->{$ptf_module_name} = {};
      my $sim_file_info;

      my $sim_file_dependency = '$(ELF)';
      $sim_file_info->{targets} = [];

      if ($options->{is_epcs})
      {











        $sim_file_info = {
          target => 'dat',
          make_path_prefix => "$simdir/",
          contents_info_path_prefix => $this->get_simdir_makefile_prefix() . "/",
          full_path_prefix => $this->simulation_directory() . "/",
          dependency => $sim_file_dependency,
        };

        my $stub = $options->{name};
        my $dat = "$stub.dat";
        my %target_hash;
        $target_hash{ptf_key} = $stub;
        $target_hash{make_path} = $sim_file_info->{make_path_prefix} . $dat;
        $target_hash{contents_info_path} = $sim_file_info->{contents_info_path_prefix} . $dat;
        $target_hash{full_path} = $sim_file_info->{full_path_prefix} . $dat;





        my $register_offset = $wsa->{register_offset};
        if ($register_offset eq '')
        {
          ribbit("no register offset!\n");
        }

        my $addr_high =
          sprintf("0x%X", oct($options->{Base_Address}) + oct($register_offset) - 1);

        my $command = "elf2dat " .
          "--infile=\$(ELF) " .
          "--outfile=$target_hash{make_path} " .
          "--base=$options->{Base_Address} " .
          "--end=$addr_high " .
          "\$(PAD_DAT_FILES) " .
          "--width=$options->{Data_Width} " .
          $endian_option;

        $target_hash{commands} = [$announce_intention, $command, ];

        $sim_file_info->{targets} = [\%target_hash];
      }
      else
      {




        if (defined($options->{flashtarget}))
        {
          $sim_file_dependency = $options->{flashtarget};
          $options->{is_from_flash} = 1;
        }

        $sim_file_info = {
          target => 'dat',
          make_path_prefix => "$simdir/",
          contents_info_path_prefix => $this->get_simdir_makefile_prefix() . "/",
          full_path_prefix => $this->simulation_directory() . "/",
          dependency => $sim_file_dependency,
        };

        if ($options->{make_individual_byte_lanes})
        {
          for my $lane (0 .. -1 + $options->{num_lanes})
          {
            my $stub = $options->{name} . "_lane$lane";
            my $dat = "$stub.dat";
            my $hex = "$stub.hex";
            my $file =
              join ("\n",'',
                '`ifdef NO_PLI',
                qq("$dat"),
                '`else',
                qq("../$stub.hex"),
                "\`endif\n");

            if ($this->language() =~ /vhdl/i)
            {
              $file = qq("../$stub.hex");
            }

            my $make_path = $sim_file_info->{make_path_prefix} . $dat;
            my $contents_info_path = $sim_file_info->{contents_info_path_prefix} . $dat;

            my %target_hash = (
              init_file => $file,
            );


            $target_hash{ptf_key} = $stub;
            $target_hash{make_path} = $make_path;
            $target_hash{contents_info_path} = $contents_info_path;
            $target_hash{full_path} = $sim_file_info->{full_path_prefix} . $dat;
            push @{$sim_file_info->{targets}}, \%target_hash;
          }
        }

        my $stub = $options->{name};
        my $dat = "$stub.dat";
        my $hex = "$stub.hex";
        my $make_path = $sim_file_info->{make_path_prefix} . $dat;
        my $contents_info_path = $sim_file_info->{contents_info_path_prefix} . $dat;
        my $file;
        $file = join ("\n",'',
          '`ifdef NO_PLI',
          qq("$dat"),
          '`else',
          qq("../$hex"),
          "\`endif\n");

        if ($this->language() =~ /vhdl/i)
        {
          $file = qq("../$stub.hex");
        }
        my %target_hash = (
          init_file => $file,
        );

        my $lanes_arg =
          '--create-lanes=' . (0 + $options->{make_individual_byte_lanes});

        my $addr_high =
          sprintf("0x%X", oct($options->{Base_Address}) + $options->{Address_Span} - 1);
        my $command = "elf2dat " .
          "--infile=\$(ELF) " .
          "--outfile=$make_path " .
          "--base=$options->{Base_Address} " .
          "--end=$addr_high " .
          "\$(PAD_DAT_FILES) " .
          "$lanes_arg " .
          "--width=$options->{Data_Width} " .
          $endian_option;



        if ($options->{is_from_flash})
        {
          $command = "flash2dat " .
            "--infile=$options->{flashtarget} " .
            "--outfile=$make_path " .
            "--base=$options->{Base_Address} " .
            "--end=$addr_high " .
            "\$(PAD_DAT_FILES) " .
            "$lanes_arg " .
            "--width=$slave_sbi->{Data_Width} " .
            "--relocate-input=$options->{Base_Address} " .
            $endian_option;
        }

        $target_hash{ptf_key} = $stub;
        $target_hash{make_path} = $sim_file_info->{make_path_prefix} . $dat;
        $target_hash{contents_info_path} = $sim_file_info->{contents_info_path_prefix} . $dat;
        $target_hash{full_path} = $sim_file_info->{full_path_prefix} . $dat;
        $target_hash{commands} = [$announce_intention, $command];

        push @{$sim_file_info->{targets}}, \%target_hash;
      }



      $wsa_make->{"TARGET dat"} = {};
      my $ptf_hr = $wsa_make->{"TARGET dat"};

      for my $file_record (@{$sim_file_info->{targets}})
      {



        next if !defined($file_record->{commands});

        $ptf_hr->{$file_record->{ptf_key}} = {};
        my $h = $ptf_hr->{$file_record->{ptf_key}};
        $h->{Dependency} = "$sim_file_info->{dependency}";
        $h->{Target_File} = $file_record->{make_path};

        $h->{Command1} = $create_simdir_if_necessary;
        my $command_number = 2;
        for (@{$file_record->{commands}})
        {
          $h->{"Command$command_number"} = $_;
          $command_number++;
        }
      }



      $this->make_placeholder_contents_files({
        name => $ptf_module_name,
        Base_Address => $slave_sbi->{Base_Address},
        Address_Span => $slave_sbi->{Address_Span},
        Data_Width   => $slave_sbi->{Data_Width},
        set_rand_contents => 0,
        make_individual_byte_lanes => $options->{make_individual_byte_lanes},
        num_lanes => $options->{num_lanes},
        sim_contents_file => $sim_file_info,
      });

      $options->{target_info}->{dat} = $sim_file_info;
      next
    };

    $target eq 'hex' and do {
      my $file_info = {
        target => 'hex',
        dependency => '$(ELF)',
      };

      $file_info->{targets} = [];

      if ($options->{is_epcs})
      {
        if (!$do_build_sim)
        {
          $this->make_sim_contents_apology($wsa_make, $ptf_module_name, $simdir, $create_simdir_if_necessary);
          next;
        }

        $file_info->{make_path_prefix} = "$simdir/";
        $file_info->{contents_info_path_prefix} = $this->get_simdir_makefile_prefix() . "/";
        $file_info->{full_path_prefix} = $this->simulation_directory() . "/";

        my $stub = $options->{name};
        my $ext = "$stub.hex";
        my %target_hash;
        $target_hash{ptf_key} = $stub;
        $target_hash{make_path} = $file_info->{make_path_prefix} . $ext;
        $target_hash{contents_info_path} = $file_info->{contents_info_path_prefix} . $ext;
        $target_hash{full_path} = $file_info->{full_path_prefix} . $ext;





        my $register_offset = $wsa->{register_offset};
        if ($register_offset eq '')
        {
          ribbit("no register offset!\n");
        }

        my $addr_high =
          sprintf("0x%X", oct($options->{Base_Address}) + oct($register_offset) - 1);

        my $create_lanes = "--create-lanes=0";
        $create_lanes = '--create-lanes=1'
          if $options->{make_individual_byte_lanes};

        my $command = "elf2hex " .
          "\$(ELF) $options->{Base_Address} " .
          "$addr_high " .
          "--width=$options->{Data_Width} " .
          "$target_hash{make_path} " .
          "$create_lanes " .
          $endian_option;

        $target_hash{commands} = [$create_simdir_if_necessary, $announce_intention, $command];

        push @{$file_info->{targets}}, \%target_hash;
      }
      else
      {

        $file_info->{make_path_prefix} = '$(' . $this->get_quartusdir_makefile_prefix() . ")/";
        $file_info->{contents_info_path_prefix} = $this->get_quartusdir_makefile_prefix() . "/";
        $file_info->{full_path_prefix} = $this->__system_directory() . "/";

        if ($options->{make_individual_byte_lanes})
        {
          for my $lane (0 .. -1 + $options->{num_lanes})
          {
            my $stub = $options->{name} . "_lane$lane";
            my $file = "$stub.hex";
            my $make_path = $file_info->{make_path_prefix} . $file;
            my $contents_info_path = $file_info->{contents_info_path_prefix} . $file;


















            push @{$file_info->{targets}}, {
              ptf_key => $stub,
              init_file => qq("$file"),
              make_path => $make_path,
              contents_info_path => $contents_info_path,
              full_path => $file_info->{full_path_prefix} . $file,

            };
          }
        }


        my $command;

        my $create_lanes = "--create-lanes=0";
        $create_lanes = '--create-lanes=1'
          if $options->{make_individual_byte_lanes};

        my $stub = $options->{name};
        my $file = "$stub.hex";
        my $make_path = $file_info->{make_path_prefix} . $file;
        my $contents_info_path = $file_info->{contents_info_path_prefix} . $file;





        {

          my $addr_high =
            sprintf("0x%X", oct($options->{Base_Address}) + $options->{Address_Span} - 1);
          $command = "elf2hex " .
            "\$(ELF) $options->{Base_Address} " .
            "$addr_high " .
            "--width=$options->{Data_Width} " .
            "$make_path " .
            "$create_lanes " .
            $endian_option;
        }

        push @{$file_info->{targets}}, {
          ptf_key => $stub,
          init_file => qq("$file"),
          make_path => $make_path,
          contents_info_path => $contents_info_path,
          full_path => $file_info->{full_path_prefix} . $file,
          commands => [$announce_intention, $command],
        };
      }
      
      $wsa_make->{"TARGET hex"} = {};
      my $ptf_hr = $wsa_make->{"TARGET hex"};
      for my $file_record (@{$file_info->{targets}})
      {



        next if !defined($file_record->{commands});

        $ptf_hr->{$file_record->{ptf_key}} = {};
        my $h = $ptf_hr->{$file_record->{ptf_key}};
        $h->{Dependency} = $file_info->{dependency};
        $h->{Target_File} = $file_record->{make_path};

        my $command_number = 1;
        for (@{$file_record->{commands}})
        {
          $h->{"Command$command_number"} = $_;
          $command_number++;
        }
      }
      $this->make_placeholder_contents_files(
        {
          name => $ptf_module_name,
          Base_Address => $slave_sbi->{Base_Address},
          Address_Span => $slave_sbi->{Address_Span},
          Data_Width   => $slave_sbi->{Data_Width},
          set_rand_contents => 0,
          make_individual_byte_lanes => $options->{make_individual_byte_lanes},
          num_lanes => $options->{num_lanes},
          hdl_contents_file => $file_info,
        }
      );

      $options->{target_info}->{hex} = $file_info;
      next
    };

    $target eq 'programflash' and do {



      next
    };

    $target eq 'sym' and do {

      if (!$do_build_sim)
      {
        $this->make_sim_contents_apology($wsa_make, $ptf_module_name, $simdir, $create_simdir_if_necessary);
        next;
      }

      my $target = "$simdir/$options->{name}.sym";

      $wsa_make->{"TARGET sym"} = {};
      my $hr = $wsa_make->{"TARGET sym"}->{$ptf_module_name} = {};
      $hr->{Dependency} = '$(ELF)';
      $hr->{Target_File} = $target;
      $hr->{Command1} = $create_simdir_if_necessary;
      $hr->{Command2} = $announce_intention;
      $hr->{Command3} = 'nios2-elf-nm -n $(ELF) > ' . $target;

      next;
    };

    ribbit("Don't know how to build makefile target '$target'");
  }
  return;
}

sub make_sim_contents_apology
{
  my $this = shift;
  my $wsa_make = shift;
  my $ptf_module_name = shift;
  my $simdir = shift;
  my $create_simdir_if_necessary = shift;

  my $target_ptf = 'TARGET sim';
  $wsa_make->{$target_ptf} = {};

  my $section = $wsa_make->{$target_ptf}->{$ptf_module_name} = {};
  my $dummy_file = "$simdir/dummy_file";

  $section->{Dependency} = '$(ELF)';
  $section->{Target_File} = "$dummy_file";
  $section->{Command1} = $create_simdir_if_necessary;
  $section->{Command2} = "\@echo " .
    "Hardware simulation is not enabled for the target SOPC Builder system. " .
    "Skipping creation of hardware simulation model contents and simulation " .
    "symbol files. \\(Note: This does not affect the instruction set simulator.\\)";
  $section->{Command3} = "touch $dummy_file";
}

sub PLI_Files
{
   my $this = shift;
   my @pli_files;
   foreach my $mod ($this->get_ptf_module_list())
   {
      push (@pli_files,
            split (/\s*,\s*/s,
                   $mod->{SIMULATION}{MODELSIM}{PLI_Files})
            );
   }
   return @pli_files;
}





















sub makefile_conditionalize_on
{
  my ($lr, $macro) = @_;



  map {s/\@echo/echo/} @$lr;
  my $cmd = "\@if [ \$($macro) -eq 1 ]; then " . join(' ; ', @$lr) . " ; fi";

  @$lr = ($cmd);
}


=item I<get_clock_hash>

Returns the whole clock hash. The caller is responsible for knowing the
structure of the clock hash.

=cut

sub get_clock_hash
{
   my $this = shift;
   return $this->system_ptf->{WIZARD_SCRIPT_ARGUMENTS}{CLOCKS};
}



=item I<get_user_selectable_clocks>

Returns array of user-selectable clocks.

=cut

sub get_user_selectable_clocks
{
   my $this = shift;
   my $clock_hash = shift || $this->get_clock_hash();
   my @user_selectable_clocks;
   
   my @clocks = map {
             $_ =~ /CLOCK\s*(\w+)/;
           } keys (%{$clock_hash});
   foreach my $clock_name (@clocks) {
     my $is_clock_source = $clock_hash->{"CLOCK $clock_name"}{"Is_Clock_Source"};
     if ( ! $is_clock_source == "1" ) {
     	  push (@user_selectable_clocks, $clock_name);
     }
   }
   return @user_selectable_clocks;
}



=item I<get_source_clocks>

Returns array of internal source clocks.  

=cut

sub get_source_clocks
{
   my $this = shift;
   my $clock_hash = shift || $this->get_clock_hash();
   my @source_clocks;
   
   my @clocks = map {
             $_ =~ /CLOCK\s*(\w+)/;
           } keys (%{$clock_hash});
   foreach my $clock_name (@clocks) {
     my $is_clock_source = $clock_hash->{"CLOCK $clock_name"}{"Is_Clock_Source"};
     if ( $is_clock_source == "1" ) {
     	  push (@source_clocks, $clock_name);
     }
   }
   return @source_clocks;
}






=item I<get_clock_attribute>

Inputs: 
  1- (required) either a clock domain name (eg. "clk2") or a clock name
      ("clk_clk2"). 
  2- (optional) attribute that you're looking for.

Returns an attribute associated with a clock domain, or nothing if that
attribute (or clock domain) does not exist. 

If no attribute is passed in, returns a hash of all attributes derived from the
clock hash, or nothing if that clock/clock domain does not exist.

=cut

sub get_clock_attribute
{
   my $this = shift;
   my $clock_name = shift; 
   my $attribute = shift;
   my $clock_hash = $this->get_clock_hash(); 
   my $domain_name = $this->find_clock_domain_by_clock_name($clock_name) || 
      return "";
   my $clock_domain_hash = $clock_hash->{"CLOCK $domain_name"}; 
   if ($attribute && $clock_domain_hash) {
      return $clock_domain_hash->{$attribute};
   } else {
      return $clock_domain_hash;
   }
}



=item I<get_module_clock_frequency()>

Return clock frequency constraint for this module.

=cut

sub get_module_clock_frequency
{
   my $this = shift;
   my $clock_source = $this->module_ptf()->{SYSTEM_BUILDER_INFO}{Clock_Source};
   my $clock_freq = $this->get_clock_frequency($clock_source) ||

      &goldfish ("Clock $clock_source does not have a clock frequency");
   return $clock_freq;
}



=item I<get_clock_frequency()>

Return clock frequency constraint for a given clock.  Returns nothing if clock
does not exist.

=cut

sub get_clock_frequency
{
   my $this = shift;
   my $clock_name = shift;
   my $clock_freq = $this->get_clock_attribute($clock_name,"frequency");
   return $clock_freq;
}



=item I<get_clock_source()>

Return clock source for a given clock.  This is most probably "external" or the
name of the pll clock that feeds it.
Returns nothing if clock does not exist.

=cut

sub get_clock_source
{
   my $this = shift;
   my $clock_name = shift;
   my $clock_source = $this->get_clock_attribute($clock_name,"source");
   return $clock_source;
}



=item I<find_clock_domain_by_ptf_module()>

Given a ptf module name, finds the clock domain assigned to this ptf module.
Returns the clock name (domain) associated with that module.   Returns
an empty string if clock does not exist, or it can not determine what clock the
ptf module is on.

=cut

sub find_clock_domain_by_ptf_module {
  my $this = shift;
  my $module_name = shift || &ribbit ("module name required");
  my $mod_sbi = 
    $this->system_ptf()->{"MODULE $module_name"}->{SYSTEM_BUILDER_INFO};
  $mod_sbi or return "";
  my $assigned_clock_source = $mod_sbi->{Clock_Source};
  return $assigned_clock_source;
}




=item I<find_clock_domain_by_clock_name()>

Given a clock name, figure out what clock domain it belongs to. 
At this point, you may say "duh", but maybe this will be a more convoluted
equivalency check in the future. 

A clock may have a name starting with "clk_" or maybe it doesn't.  
Callers may provide either one of the exclusive name or the domain name.
Recursively check for clock domain by incrementally taking out "clk_" from the clock name.

=cut

sub find_clock_domain_by_clock_name
{
   my $this = shift;
   my $clock_name = shift;
   
   my $clock_hash = $this->get_clock_hash(); 
   
   if ($clock_hash->{"CLOCK $clock_name"}) {
   	 return $clock_name;
   } else {
   	 if ( $clock_name =~ s/^clk_//i ) {
     		return $this->find_clock_domain_by_clock_name($clock_name);
     	} else {
     		return "";
     	}
   }
}



=item I<augment_clock_name()>

Given that a port or signal name, what name would you give this if it were a
clock?

given e.g. "p0/s1/c0", change into "clk_p0_s1_c0";

=cut

sub augment_clock_name
{
   my $this = shift;   
   my $clk_name = shift || return;
   
   
   my @clocks = $this->get_user_selectable_clock();
	
	

   $clk_name =~ s/[\/\\]/_/g;

   
   if (@clocks > 1)
   {
      return "clk_$clk_name";
   }
   else
   {
      return $clk_name;
   }
}



=item I<augment_out_clock_name()>

Given that a port or signal name, what name would you give this if it were an
out_clk?

=cut

sub augment_out_clock_name
{
   my $this = shift;   
   my $name = shift || return;


   $name =~ s/[\/\\]/_/g;
   
   return "out_clk_$name";
}


=item I<is_hardcopy_compatible()>

If this project needs to be generated in a manner compatible with hardcopy
(e.g. no initialized RAMs), return 1. Otherwise (default case), return 0.

=cut

sub is_hardcopy_compatible
{
   my $this = shift;
  
   if (!defined($this->SYS_WSA())) {
        &ribbit ("The system WSA hash is missing");
   }

   return $this->SYS_WSA()->{hardcopy_compatible} ? 1 : 0;
}

sub _get_timescale_directive
{
   my $this = shift;
   my $no_translate_off = shift;








   my $timescale = $this->timescale() || &goldfish ("nonexistant timescale");
   my $time = "`timescale $timescale\n";

   if ($no_translate_off)
   {
      return $time;
   }
   else
   {
      return "// ". $this->_translate_off ."\n".
          $time.
              "// ". $this->_translate_on ."\n";
   }
}



=item I<generation_script_filename()>

Get the name (with path) of the HDL-file we're going to generate.

=cut

sub generation_script_filename
{
   my $this  = shift;
   &ribbit ("access-only function") if @_;
   my $name = join ("/", 
                    $this->_system_directory(),
                    $this->_system_name()."_generation_script",
                    );
   return $name;
}


=item I<Create_Generation_Script()>

generate the command line system Perl generation script

=cut


sub Create_Generation_Script {
  my $this = shift;
  &ribbit ("Too many arguments") if @_;
  &Progress ("Creating command-line system-generation script: "
	     .$this->generation_script_filename());

  my $sys_command;
  my $update_ptf_cmd;

  my @sys_command_list;

  push @sys_command_list, "$ENV{SOPC_PERL}/bin/perl";
  push @sys_command_list, "-I\$sopc_builder/bin";
  push @sys_command_list, "-I\$sopc_builder/bin/perl_lib";
  push @sys_command_list, "-I\$sopc_builder/bin/europa";
  push @sys_command_list, "\$sopc_builder/bin/mk_systembus.pl";
  push @sys_command_list, "--sopc_directory=\$sopc_builder";
  push @sys_command_list, "--sopc_perl=$ENV{SOPC_PERL}";
  push @sys_command_list, "--sopc_lib_path=\"$this->{_sopc_lib_path}\"";
  push @sys_command_list, "--target_module_name=$this->{_target_module_name}";
  push @sys_command_list, "--system_directory=".$this->_system_directory();
  push @sys_command_list, "--system_name=$this->{_system_name}";
  push @sys_command_list, "--project_name=$this->{_projectname}";
  push @sys_command_list, "--sopc_quartus_dir=$this->{_sopc_quartus_dir}";
  push @sys_command_list, "\$1";

  $sys_command = join(" ", @sys_command_list);

  my @update_ptf_command_list;

  push @update_ptf_command_list, "\n$ENV{SOPC_PERL}/bin/perl";
  push @update_ptf_command_list, "-I\$sopc_builder/bin";
  push @update_ptf_command_list, "-I\$sopc_builder/bin/perl_lib";
  push @update_ptf_command_list, "-I\$sopc_builder/bin/europa";
  push @update_ptf_command_list, "\$sopc_builder/bin/ptf_update.pl";
  push @update_ptf_command_list, $this->_target_module_name() . ".ptf";
  push @update_ptf_command_list, "\n\n";

  $update_ptf_cmd = join(" ", @update_ptf_command_list);

   my $scriptfile = $this->generation_script_filename();
   open  (DOFILE, "> $scriptfile") or &ribbit ("can't open $scriptfile: $!");
   print DOFILE "#!/bin/sh\n";
   print DOFILE $update_ptf_cmd;
   print DOFILE "$sys_command\n";
   close DOFILE;
}

=item I<set_sim_wave_signals($signals, $module)>

Throw a list of signals and dividers into a module's simulation
section in the ptf.  
parameters:
- $signals: a list ref of signals and dividers in the order in which
they should appear.
- $module (optional): the module in question.  Defaults to e_project::top().

The elements of @$signals are either single words representing a signal
(e.g. "address", "writedata") or divider specifiers of the form "Divider
<divider_name>".

=cut

sub set_sim_wave_signals($$;$)
{
  my $this = shift;
  my $signals = shift;
  my $module = shift || $this->top();
  


  my @bus_signals = qw(
    address
    data$
  );
  
  my $module_name = $module->name();
  my $sys_ptf = $this->system_ptf();
  my $mod_ptf = $sys_ptf->{"MODULE $module_name"};
  $mod_ptf->{SIMULATION} = {} if (!defined($mod_ptf->{SIMULATION}));
  $mod_ptf->{SIMULATION}->{DISPLAY} = {} if (!defined($mod_ptf->{SIMULATION}->{DISPLAY})); 
  
  my $sig_ptf = $mod_ptf->{SIMULATION}->{DISPLAY};

  my $signum = 0;
  my $tag;
  for my $sig (@$signals)
  {
    my $tag = to_base_26($signum++);
    my $radix;
    my $format;
    my $name;
    
    if ($sig =~ /Divider\s*(.*)/)
    {
      $name = $1;
      $format = 'Divider';
      $radix = '';
    }
    else
    {
      $name = $sig;
      $radix = 'hexadecimal';
      $format = 'Logic';
      if (grep {$sig =~ /$_/} @bus_signals)
      {
        $format = 'Literal';
      }
    }

    $sig_ptf->{"SIGNAL $tag"} = {name => $name, radix => $radix, format => $format};
  }
}

=back

=cut

=head1 SEE ALSO

The inherited class e_ptf

=begin html

<A HREF="e_ptf.html">e_ptf</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2004 Altera Corporation

=cut

1;

