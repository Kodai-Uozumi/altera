#Copyright (C)1991-2003 Altera Corporation
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


my $VERSION = "6.0"; # This is a version string, not a number. 6.0 == 6.0.0, for example.

################
# mk_systembus.pl
#
# This Perl-script is the "business end" of the 
# Nios System Bus Wizard.  The Wizard itself is a GUI-layer
# which quizzes the user and passes his(her) choices 
# along to this very script.
#
# The kind of user socket we build depends on the
# parameters we get. The parameters are "named arguments," 
# Named arguments are one long comma-delimited string, 
# a list of 'normal' command-line arguments, or any combination
# of both (we just smash all the command-line arguments together
# into one long string anyhow).  
# 
# The comma-delimited elements have the form:
#      <arg_name> = <value>.
#
# For a list of all the argument-names and their allowed values,
# see the table below.
#
use wiz_utils;
use mk_custom_sdk;

use europa_all;
use europa_ptf;
use strict;
use build_komodo_proj; 
use build_debug_proj; 

# not yet ready for prime-time.
# use build_epic_proj;

# A global hash to hold database information from mk_custom_sdk.pm.
# See calls to &find_all_component_dirs, &get_class_ptf, &find_component_dir.
my $g_mk_custom_sdk_state = {};

#sub Generate_PBM_And_System
#{
#   eval {e_ptf_project->new(@_)
#             ->output()};
#
#   return ($@);
#}


################################################################
# Mk_SystemBus
#
# Executes all the functions of the System Bus MegaWizard.
# All the peripherals (and nios-cores) that this uses must have 
# already been built by the other "Mk" functions.
# 
# Because this function takes listref  and hashref arguments,
# it doesn't use PARSE_NAMED_ARGS.
#
# We could probably clean up nearly all of this.
# This function takes, as its arguments:
#

my $Mk_SystemBus_Doc=<<END_OF_DOCUMENTATION_STRING ;
# LONG NAME     SHORT NAME    DEFAULT       DESCRIPTION
# -----------------------------------------------------------------------
   mainmem_module  --none--   --none--     SDK will target programs here.
   skip_synth      --none--   0            *boolean* do synth or not?
   hdl_language    hdl        verilog      *(verilog|vhdl|ahdl)* for wrapper.
   device_family   --none--   APEX20KE     target device (chip) family.
   compiler        --none--   quartus      *(max\+plus2|quartus)* P&R tool
   clock_freq      clk_f      33333300     Input clock rate in Hz.
   do_build_sim    sim        0            *boolean* do make system sim?
   do_optimize     optimize   1            *boolean* assume optimized HDL?
   leo_flatten     flatten    1            *boolean* Leo's hier-flatten option
   leo_area        area       0            *boolean* Leo optimize for area.
   software_only   --none--   0            *boolean* only rebuild sw code.
   bus_only        bo         0            *boolean* only rebuild PBM,system
   generate_hdl    --none--   1            *boolean* Make HDL files.

   Principal_Tri_State_Data_Bus --none-- --none--  Direct-to-CPU Fast I/O

# These arguments are used to build the custom SDK.  We have to tolerate
# them here, even though we don't use them
   mainmem_module    --none--   --none--     Where to put programs.
   datamem_module    --none--   --none--     Where to put variables/stack.
   gdbcomm_module    --none--   --none--     Debug on this uart.
   maincomm_module   --none--   --none--     Yak on this uart.
   germs_monitor_id  --none--   --none--     Print this at boot-time.
   sopc_quartus_dir  --none--   --none--     Where Quartus lives
   projectname       --none--   --none--     Name of Quartus project file   
   asp_debug         --none--   0            Run with MSVS.net?
   already_running_mk_system_bus --none-- 0  passed in by parent mksystem
#                                            to avoid infinite loops

END_OF_DOCUMENTATION_STRING
#
################################################################
sub Mk_SystemBus(@)
{
    &checkEuropaVersion();
    
    # |
    # | short circuit for --version and --help
    # |
    &doVersionAndHelp(@_);

    #
    #
    my ($arg, $user_defined, $db_Sys, $db_PTF_File) 
        = &Process_Wizard_Script_Arguments ($Mk_SystemBus_Doc,  @_);


    #
    # the class-ptf-finding-apparatus needs to know about the
    # system directory, since .sopc_builder/install.ptf
    # is next to yourSystem.ptf.
    #

    $$g_mk_custom_sdk_state{system_directory} = $$arg{system_directory};

    #If asp_debug is set in SYSTEM/WSA, then rerun mk_systembus with
    #MSVS.net.  Set already_running_mk_system_bus to 1 to avoid
    #infinite loop
    if ($arg->{asp_debug} && !$arg->{already_running_mk_system_bus})
    {
       my @includes = map {"-I".$_} @INC;

       my @args = @_;
       push (@args, '--already_running_mk_system_bus=1');
       my @gc = (
                      "perl", @includes,
                      __FILE__,
                      @args
                      );
       #print("Running ASP .NET debugger for $name\n");

        &create_debug_project(\@gc);
        
        # This will block until the debugger exits.
        if(&check_dot_net_install($arg)){
           &launch_debug_project($arg);
        }
       exit(0);
    }

    # if komodo_debug is set in SYSTEM/WSA, then rerun mk_systembus with perl
    # in debug mode.  If properly set up, this process will be able to attach
    # to an open komodo IDE.
    if ($arg->{komodo_debug} && !$arg->{already_running_mk_system_bus})
    {
       my @includes = map {"-I".$_} @INC;

       my @perl_exe = (&find_debugger_perl_location($arg) , "-d");
       my @args = @_;
       push (@args, '--already_running_mk_system_bus=1');
       my @gc = (
                      @perl_exe, @includes,
                      __FILE__,
                      @args
                      );

       &Progress ("Komodo debug requested for top level module.\n".
            "Please open Komodo and receive Remote Debugger Connection.\n".
            "SOPC Builder will continue to respawn the process until ".
            "it returns no errorcode.\n");

       my $error_code;
       do {
         $error_code = &System_Win98_Safe (\@gc);
       } while ($error_code != 0);
       exit($error_code);
    }


    # Here's the way we integrate with EPIC debugging at this point.  If you
    # have epic_debug, then we create the project definition file (.project)
    # and eclipse' launch configuration files (.launch).  we do not actually
    # run these programs.  We expect the user to import this pre-canned project
    # into their Eclipse environment.
    #
    if ($arg->{epic_debug} && !$arg->{already_running_mk_system_bus})
    {
       my @args = @_;
       push (@args, '--already_running_mk_system_bus=1');
       &Progress ("Eclipse project file created in project directory");
       my $generator_program = $$arg{sopc_directory}."/bin/mk_systembus.pl";
       my $system_name = $$arg{system_name};
       &build_eclipse_project_file ($system_name, $generator_program, $arg);
       &build_eclipse_includepath_file  ($system_name, $arg);
       &build_eclipse_launch_file ($system_name, $generator_program , $arg, (join ' ',@args));
       &Progress ("Eclipse launch file created for ".$$arg{system_name});
    }

    # read in config file
    my $config_file = &ptf_parse::new_ptf_from_file($$arg{sopc_directory} . "/.sopc_builder");

    my $sys_name = $$arg{system_name};          # too handy to pass
                                                # up.

   # we expect $SOPC_PERL from environment to be set
   # we let --sopc_perl=<SOPC_PERL> override this
   # we fall back on legacy-style sopc_builder/bin perl

    $ENV{SOPC_PERL} = $$arg{sopc_perl} || $ENV{SOPC_PERL};

   # we expect on Quartus's cygwin/bin
   # we allow $SOPC_SHELL from environment to be set
   # we let --sopc_shell=<dir with sh> override this
   my $shell_dir = $ENV{QUARTUS_ROOTDIR} . "/bin/cygwin/bin";
   $shell_dir = $ENV{SOPC_SHELL} if ($ENV{SOPC_SHELL} ne "");
   $shell_dir = $$arg{sopc_shell} if ($$arg{sopc_shell} ne "");
    if ($shell_dir eq "")
    {
        $shell_dir = &ptf_parse::get_data_by_path($config_file, "sopc_cygwin_dir") . "/bin";
    }
    $ENV{SOPC_SHELL} = $shell_dir;
    
    my $base_file_name = join ("/",
                               $$arg{system_directory},
                               "$sys_name");
    
    my $ptf_file_name = $base_file_name.".ptf";
    
    #|#
    #|# call (pre) generation hook
    #|#
    if ($config_file)
    {
        my $gen_hook = 
            &ptf_parse::get_data_by_path($config_file, "sopc_generate_hook");
        if ($gen_hook)
        {
            &Set_External_Command_Visible(0);
            if (&Run_Command_In_Unix_Like_Shell($$arg{sopc_directory}, 
                                                $gen_hook,$ptf_file_name) != 0)
            {
                ribbit "\nGeneration hook terminating.\n";
            }
            &Set_External_Command_Visible(1);
        }
    } else {
        print "No .sopc_builder configuration file(!)\n";
    }
    
    my $sdk_directory_list;
    
    my $error_message = &mk_custom_sdk(
                     \$sdk_directory_list,
                     "--projectname=$$arg{projectname}",
                     "--sopc_directory=$$arg{sopc_directory}",
                     "--system_directory=$$arg{system_directory}",
                     "--system_name=$$arg{name}",
                     "--sopc_lib_path=$$arg{sopc_lib_path}",
                     "--software_only=$$arg{software_only}"
                     );
    # NOTE: mk_custom_sdk will have modified sdk_directory_list with its
    #       list of sdk directories (potentially)

    my %generated_file_list;
    if (ref ($sdk_directory_list) eq "ARRAY")
    {
       %generated_file_list = (@$sdk_directory_list);
    }

    $generated_file_list{$ptf_file_name} = "SOPC Builder database";
    $generated_file_list{$base_file_name."_generation_script"} =
    "System Generation Script";

    die "$error_message\n"
        if ($error_message);
		     
    &Progress ("Starting generation for system: $sys_name.");

    # SPR 148561.  Delete the placeholder contents file, if it
    # exists.  If it's needed, it will be regenerated.  This is
    # necessary to handle the case where a memory which previously
    # generated a warning has been deleted.
    my $contents_file =
      e_project->get_placeholder_warning_file_absolute_path(
        e_project->simulation_directory($$arg{system_directory},
          $$arg{system_name}));

    unlink $contents_file;

    $error_message = &Run_Generator_Programs 
        ($arg, 
         $db_Sys, 
         $db_PTF_File
         );

    # print "Generators Done; Errors = '$error_message'\n";

    $error_message = &Run_Test_Generator_Programs 
        ($arg, 
         $db_Sys, 
         $db_PTF_File
         ) if (!$error_message);

    # print "Test Generators Done; Errors = '$error_message'\n";


    # Run system bus generator program as a separate process.
    if (!$error_message
        && !$$arg{software_only}
        && $$arg{generate_hdl}
        && !$$arg{system_modules_to_generate}) {
       ###############
       # otherwise its smooth sailing
       &Progress ("Making arbitration and system (top) modules.");
       my @perl_exe = ("$ENV{SOPC_PERL}/bin/perl") ;
       my $do_komodo_debug = $arg->{komodo_debug};
       if ($do_komodo_debug) {
         @perl_exe = (&find_debugger_perl_location($arg) , "-d");
       }
       my @include_generator_cmd;
       foreach my $ink (@INC)
       {
        push @include_generator_cmd,"-I$ink";
       }

       my @gc = (@perl_exe,@include_generator_cmd,"$$arg{sopc_directory}/bin/generate_pbm_and_system.pl",@ARGV);

       # actually run the command.
       my $error_code;
       my $komodo_launch_failed;
       my $fail_count = 0;
       my $give_up;
       if ($do_komodo_debug) {
          do {
            $error_message = &System_Win98_Safe (\@gc);
            $komodo_launch_failed = ($error_message != 0);
            $fail_count++ if $komodo_launch_failed;
            $give_up = ($fail_count > 2);
          } while ($komodo_launch_failed && !($give_up));
          if ($give_up) {
            # Restore STDOUT and STDERR to their original values.
            open STDOUT, ">&OLDOUT" or 
              die "Can't restore STDOUT to OLDOUT: $!";
            open STDERR, ">&OLDERR" or 
              die "Can't restore STDERR to OLDERR: $!";

            &Progress ("After many tries, I gave up trying to start the Komodo debug process\n"
            ."The (debug) generation command was : @gc\n\n"
            ."The error is : $error_message\n\n"
            ."Possible causes: \n"
            ."a) you don't have the komodo debugger open,\n"
            ."   solution: open the komodo debugger\n"
            ."b) there is a syntax error in your Perl code\n"
            ."   solution: rerun WITHOUT debugging. The syntax error should be reported normally. \n"
            );
            die;
          };
          &Progress ("Komodo debug finished. Continuing.\n");
       } else {
          $error_message = &System_Win98_Safe (\@gc);
       }


       my $top_hdl = "$base_file_name.v";
       $top_hdl .= "hd"
           if ($$arg{hdl_language} =~ /hdl/i);
       $generated_file_list{$top_hdl} = "System HDL Model";

       $generated_file_list{"${base_file_name}_sim"} = 
           "HDL Simulation Directory"
           if ($$arg{do_build_sim});
    }

    if ($$arg{software_only}) 
    {
       my $ptf_manipulation_artifice = 
           e_ptf->new ({ptf_file => $ptf_file_name});

       $ptf_manipulation_artifice->Create_Dat_Files
           ($$arg{system_directory},
            e_project->simulation_directory($$arg{system_directory},
                                            $$arg{system_name}       ));
    }                                         

    &Clean_Up_PTF($ptf_file_name);
    die "$error_message\n"
        if ($error_message);

    &Progress ("Completed generation for system: $sys_name.");
    &Progress ("THE FOLLOWING SYSTEM ITEMS HAVE BEEN GENERATED:");
    print join ("\n",
                map {"  $generated_file_list{$_} : $_ ";} 
                sort (keys (%generated_file_list)));
    print "\n\n";

    ###############
    # Java code searches for the following string to figure out if it's
    # done, so don't change it.
    &Progress ("SUCCESS: SYSTEM GENERATION COMPLETED.");
}

sub Clean_Up_PTF
{
   my $file = shift;
   my $ptf = e_ptf->new({ptf_file => $file});

   ###############
   # NB. we should really be able to do this from e_ptf.  The
   # object demarcation_lines aren't completely correct here.

   my $replace_this = 0;
   my $ptf_hash = $ptf->ptf_hash();
   while (exists $ptf_hash->{__REPLACE__THIS__})
   {
      $replace_this++;
      $ptf->ptf_hash
          ($ptf_hash->{__REPLACE__THIS__});
      delete $ptf_hash->{__REPLACE__THIS__};
      $ptf_hash = $ptf->ptf_hash();
   }

   $ptf->ptf_to_file();
}


###########################3
# Get_All_Component_Dirs
#
# dvb, 2001 august 23
#
# With apologies, since I know there's
# top experts working on this problem
# at this very moment...
#
# This routine returns a list reference to
# each and every directory found under any of
# the directories in the $$arg{sopc_lib_path}.
#
# These can ALL be available INC paths for
# generator programs. How do we avoid name collisions?
# I don't know. Probably should order the list
# such that you get your own .pm before someone
# elses. Please feel free to rewrite
# this more correctly. Gah.
#

sub Get_All_Component_Dirs
{
   my $res = find_all_component_dirs($g_mk_custom_sdk_state);

   # Translate DOS-style slashes, since these dirs may find
   # their way into @INC in some generator program.
   map {s/\\/\//g} @$res;
   
   return $res;
}


################################################################
# Run_Generator_Programs
#
# Given (a reference to) the PTF "SYSTEM" section and (a reference to)
# the %arg-hash, we have enough information to run through all the
# system's sub-modules and run their respective generator-programs
# (as-listed in their "class.ptf" file), if any.
#
# For modules that don't explicitly list a generator-program, we run
# the "default_generator_program," on their behalf.  Other modules may
# specifically request that no generator program be run at all.
#
# This function returns a list of all "enabled" modules in the system.
# This list includes the master.
#
################################################################
sub Run_Generator_Programs
{
  my ($arg, $db_Sys, $db_PTF_File) = (@_);

  my @module_name_list = ();
  my @bridge_name_list = ();
  
  # A list for the names of skipped-generation modules.
  # Save it for printout at the end.
  my @skipped_modules;

  my %generator_cmds;

  my $num_children     = get_child_count($db_Sys);

  my $comma_separated_modules_string 
      = $arg->{system_modules_to_generate};
  my @modules_to_generate = split (/\:/, $comma_separated_modules_string);
  
  for (my $child_index = 0; 
       $child_index < $num_children;
       $child_index++
       ) 
  {
     my $db_Module = &get_child ($db_Sys, $child_index);
     next unless get_name ($db_Module) eq "MODULE";

     # Don't waste our time on disabled modules.

     next if !&PTF_Get_Boolean_Data_By_Path ($db_Module,
                                             "SYSTEM_BUILDER_INFO/Is_Enabled");

     my $mod_name = &get_data ($db_Module);
     
     next if (@modules_to_generate &&
              !(grep {$mod_name eq $_} @modules_to_generate));

     # Skip generation for modules which use the sooper-secret
     # don't-generate-me value.
     if (&get_data_by_path($db_Module,
                           "SYSTEM_BUILDER_INFO/Do_Not_Generate") ||
         (&get_data_by_path($db_Sys,
                            "WIZARD_SCRIPT_ARGUMENTS/Do_Not_Generate")
          )
         )
     {
        #Adapters will get generated no matter what
        unless (&get_data_by_path
                ($db_Module,
                 "SYSTEM_BUILDER_INFO/Is_Adapter")
                )
        {
           push @skipped_modules, $mod_name;
           next;
        }
     }

     # Open-up this module's "class.ptf" file.
     my $module_class = &PTF_Get_Required_Data_By_Path
         ($db_Module, "class", "No class specified for module: $mod_name");
     
     my $db_Class_File =
       get_class_ptf($g_mk_custom_sdk_state, $module_class);
     my $module_lib_dir =
       find_component_dir(
         $g_mk_custom_sdk_state,
         $db_Class_File,
         $module_class
       );

     my $db_Module_Class = 
         &PTF_Get_Required_Child_By_Path
         ($db_Class_File, "CLASS",
          "Bad or corrupt 'class.ptf' file for module $mod_name");

     my $lib_generator_program = &get_data_by_path 
         ($db_Module_Class, "ASSOCIATED_FILES/Generator_Program");

     # This subroutine runs one of two types of generator-programs
     # for each module: either the traditional "Generator_Program"
     # (which we just extracted above) or the newfangled
     # Software_Rebuild_Program", which we run if the magical argument
     # "software_only" is set. 
     if ($$arg{software_only}) {
        $lib_generator_program = &get_data_by_path 
            ($db_Module_Class, "ASSOCIATED_FILES/Software_Rebuild_Program");
        
        # No default rebuild-program.  If you don't have one, then
        #  YOU DON'T HAVE ONE.
        $lib_generator_program = "--none--" unless $lib_generator_program;
     }

     # If the user has un-checked the "Generate HDL" option in the 
     # wizard, we do a preseto-changeo here and pretend their
     # generator program is "none".  Note that we leave their generator
     # program alone if we're in "software only" mode.
     $lib_generator_program = "--none--" 
         if !($$arg{generate_hdl}) && !($$arg{software_only});

     # If the library component didn't specify a generator program,
     # then give it the generic (default) one:
     #
     my $generator_program = "$module_lib_dir/$lib_generator_program";

     if (($lib_generator_program eq ""              ) ||
         ($lib_generator_program =~ /^--default--$/i) )
     {
        $generator_program =
            "$$arg{sopc_directory}/bin/default_generator_program.pl";
     }

     if (($lib_generator_program !~ /^--none--$/i)) 
     {
        # for now, complain bitterly if the generator program is not
        # apparently a Perl-script:
        #
        $generator_program =~ /\.(p[lm])$/ or return ("
        Illegal Generator program '$generator_program' for $module_class:
             Generator programs must be perl-scripts or modules.\n");

        my $extension = $1;
        my $component_dirs_list_ref = Get_All_Component_Dirs($arg);
        my $a_component_dir;
        my @include_generator_cmd;

        my @component_libs = split(/\s*,\s*/s, &get_data_by_path($db_Module_Class, "ASSOCIATED_FILES/Generator_Libraries"));
        my @absolute_component_libs = map {$module_lib_dir."/$_";}@component_libs;
        for my $ink (@INC,@absolute_component_libs,$module_lib_dir)
        {
            push(@include_generator_cmd,"-I$ink");
        }

        # pass in all (!) component directories.
        # NOTE: the only known dependancy on passing ALL dirs: ASMI needs SPI
        # SHOULD: pass only module_lib_dir and other dependencies as specified
        #         by the module (perhaps in its CLASS definition)
        foreach $a_component_dir (@$component_dirs_list_ref)
        {
           push(@include_generator_cmd,"-I$a_component_dir");
        }

        my @generator_cmd;
        push @generator_cmd ,        "--system_name=$$arg{system_name}";
        push @generator_cmd , "--target_module_name=$mod_name";
        push @generator_cmd ,   "--system_directory=$$arg{system_directory}";
        push @generator_cmd ,     "--sopc_directory=$$arg{sopc_directory}";
        push @generator_cmd ,      "--sopc_lib_path=$$arg{sopc_lib_path}";
        push @generator_cmd ,           "--generate=1";
        push @generator_cmd ,            "--verbose=$$arg{verbose}";
        push @generator_cmd ,      "--software_only=$$arg{software_only}";
        push @generator_cmd ,     "--module_lib_dir=$module_lib_dir";
        push @generator_cmd ,   "--sopc_quartus_dir=$arg->{sopc_quartus_dir}";
        push @generator_cmd ,        "--projectname=$$arg{projectname}";

        if ($extension eq 'pl')
        {
           # Here's the way we integrate with EPIC debugging at this point.
           # If you have epic_debug, then we create the project definition
           # file (.project) and eclipse' launch configuration files
           # (.launch).  we do not actually run these programs.  We expect the
           # user to import this pre-canned project into their Eclipse
           # environment.
           #
           if ($arg->{epic_debug})
           {

             &build_eclipse_project_file ($mod_name, $generator_program, $arg);
             &build_eclipse_includepath_file  ($mod_name, $arg);
             &build_eclipse_launch_file ($mod_name, $generator_program, $arg, @generator_cmd);
             &Progress ("Eclipse launch file created for ".$mod_name);
           }
           my $do_komodo_debug = &get_data_by_path
                    ($db_Module, "WIZARD_SCRIPT_ARGUMENTS/komodo_debug");
           my @perl_exe = ("$ENV{SOPC_PERL}/bin/perl");
           if ($do_komodo_debug) {
              @perl_exe = (&find_debugger_perl_location($arg) , "-d");
           }
           # redefine the generator command to include the full Perl call.
           @generator_cmd  = (@perl_exe,
               @include_generator_cmd,
               $generator_program,
               @generator_cmd);

           if ($$arg{verbose})
           {
              foreach my $var(keys (%{$arg}))
              {
                 printf($var." = ".$$arg{$var}."\n");
              } 	
              printf("module_lib_dir = ".$module_lib_dir."\n");
              printf("******\n");
           }

           if (&get_data_by_path
               ($db_Module,
                "SYSTEM_BUILDER_INFO/Is_Bridge")
               )
           {
              push (@bridge_name_list,$mod_name);
           }
           else
           {
              # Special time-saving option: only generate "the bus",
              # not any of the internal modules:
              push (@module_name_list,$mod_name) unless $$arg{bus_only};
           }
           $generator_cmds{$mod_name} = \@generator_cmd;
           print(".");
        }
        elsif ($extension eq 'pm')
        {
           no strict;
           unshift (@INC, $module_lib_dir.'/');
           my $pm = $module_class.'.pm';
           require $pm;
           my @commands = @generator_cmd;
           &Progress ("\nRunning Generator Program for $mod_name");
#debugShowCommand(@commands);
           &{$module_class.'::hdl_generate'}(@commands);
           shift (@INC);
        }
     }
  }
     print("\n");

  ###############
  # bridge generator commands get run last because they may need to know
  # slave ports.  Because of the need to know ports, we should be
  # more clever with bridges than we are.  This might not handle the
  # case where a bridge links to another bridge.  Since we only have
  # one type of bridge now (tri-state), this shouldn't be a problem.

  # All generator output will be redirected to this file.
  my $gen_log_fname = get_gen_log_fname($$arg{system_directory});

  # Save copies of STDOUT and STDERR filedescriptors in preparation for below.
  open OLDOUT, ">&STDOUT" or die "Can't save STDOUT: $!";
  open OLDERR, ">&STDERR" or die "Can't save STDERR: $!";

  foreach my $name (@module_name_list,
                    @bridge_name_list
                    )
  {
     my @gc = @{$generator_cmds{$name}};

     # Time to make a decision about whether we're going to run the
     # generator program or the ASP Debugger w/ .NET.
     my $sys_ptf = $$arg{system_directory}."/".$$arg{system_name}.".ptf";
     my $sys_ptf_ref = &ptf_parse::new_ptf_from_file($sys_ptf);

     my $asp_debug = &ptf_parse::get_data_by_path($sys_ptf_ref,
     "SYSTEM $$arg{system_name}/MODULE $name/WIZARD_SCRIPT_ARGUMENTS/asp_debug");
     
#     print "$name: asp_debug: $asp_debug\n";
     
     if($asp_debug ne "1"){
        &Progress ("Running Generator Program for $name");
#debugShowCommand(\@gc);
#debugINC();

        my $do_system_komodo_debug = &ptf_parse::get_data_by_path($sys_ptf_ref,
        "SYSTEM $$arg{system_name}/WIZARD_SCRIPT_ARGUMENTS/komodo_debug");
        my $do_module_komodo_debug = &ptf_parse::get_data_by_path($sys_ptf_ref,
        "SYSTEM $$arg{system_name}/MODULE $name/WIZARD_SCRIPT_ARGUMENTS/komodo_debug");
        if ($do_module_komodo_debug) {
          &Progress ("Komodo debug requested for this module.\n".
                "Please open Komodo and receive Remote Debugger Connection.\n".
                "SOPC Builder will continue to respawn the process until ".
                "it returns no errorcode.\n");
        }

        # Redirect STDOUT and STDERR to log file.
        # Doesn't work with Komodo debug.
        if (not $do_system_komodo_debug) {
          open STDOUT, '>', $gen_log_fname or 
            die "Can't redirect STDOUT to $gen_log_fname: $!";
          open STDERR, ">&STDOUT" or 
            die "Can't dup STDOUT to STDERR: $!";
        }

        select STDERR; $| = 1;  # make unbuffered
        select STDOUT; $| = 1;  # make unbuffered

        # Run generator command with STDOUT and STDERR redirected to a log file
        # so that the generator is guaranteed to always eventually exit.
        # This is done because if the user hits stop in the SOPC Builder
        # generation window, the normal stdout/stderr disappears and
        # the generator program will hang forever waiting for its
        # print messages to be displayed.
        my $error_code;
        my $komodo_launch_failed;
        my $fail_count = 0 ;
        my $give_up;
        if ($do_module_komodo_debug) {
          do {
            $error_code = &System_Win98_Safe (\@gc);
            $komodo_launch_failed = ($error_code != 0);
            $fail_count++ if $komodo_launch_failed;
            $give_up = ($fail_count > 2);
          } while ($komodo_launch_failed && !($give_up));
          if ($give_up) {
            # Restore STDOUT and STDERR to their original values.
            open STDOUT, ">&OLDOUT" or 
              die "Can't restore STDOUT to OLDOUT: $!";
            open STDERR, ">&OLDERR" or 
              die "Can't restore STDERR to OLDERR: $!";

            &Progress ("After many tries, I gave up trying to start the Komodo debug process\n"
            ."The (debug) generation command was : @gc\n\n"
            ."The error is : $error_code\n\n"
            ."Possible causes: \n"
            ."a) you don't have the komodo debugger open,\n"
            ."   solution: open the komodo debugger\n"
            ."b) there is a syntax error in your Perl code\n"
            ."   solution: rerun WITHOUT debugging. The syntax error should be reported normally. \n"
            );
            die;
          };
          &Progress ("Komodo debug finished. Continuing.\n");
        } else {
#print "yyy win99 ahoy\n";
#debugShowCommand(@gc);
          $error_code = &System_Win98_Safe (\@gc);
#print "yyy win99 done\n";
        }

        # Restore STDOUT and STDERR to their original values.
        if (not $do_system_komodo_debug) {
          open STDOUT, ">&OLDOUT" or 
            die "Can't restore STDOUT to OLDOUT: $!";
          open STDERR, ">&OLDERR" or 
            die "Can't restore STDERR to OLDERR: $!";
        }

        # Display all contents of the log file.
        if (open(GEN_LOG_DISPLAY, $gen_log_fname)) {
            while (<GEN_LOG_DISPLAY>) {
                print;
            }
            close(GEN_LOG_DISPLAY);
        }

        # Empty the log file for the next generator.
        unlink($gen_log_fname);

        if ($error_code != 0)
        {
           return ("
          Error: Generator program 
                 for module '$name' did NOT run successfully.\n".
                   "generator cmd was '@gc'\n");
        }
     }
     else
     {
        print("Running ASP .NET debugger for $name\n");

        &create_debug_project(\@gc);
        
        # This will block until the debugger exits.
        if(&check_dot_net_install($arg)){
           &launch_debug_project($arg);
        }
     }   
  }

  # Print the list of skipped modules now, to make it more likely
  # to be noticed.
  if (@skipped_modules) {
#     print STDERR 
#         "\nWARNING:\n",
#         (map {"Skipping generation of module '$_'\n"} @skipped_modules),
#         "\n\n";
  };

  #return @module_name_list;
  return (0);
} # &Run_Generator_Programs

sub Run_Test_Generator_Programs
{
  my ($arg, $db_Sys, $db_PTF_File) = (@_);

  my @module_name_list = ();
  my @bridge_name_list = ();
  
  # A list for the names of skipped-generation modules.
  # Save it for printout at the end.
  my @skipped_modules;

  my %generator_cmds;

  my $num_children     = get_child_count($db_Sys);

  my $comma_separated_modules_string 
      = $arg->{system_modules_to_generate};
  my @modules_to_generate = split (/\:/, $comma_separated_modules_string);
  
  for (my $child_index = 0; 
       $child_index < $num_children;
       $child_index++
       ) 
  {
     my $db_Module = &get_child ($db_Sys, $child_index);
     next unless get_name ($db_Module) eq "MODULE";

     # Don't waste our time on disabled modules.

     next if !&PTF_Get_Boolean_Data_By_Path ($db_Module,
                                             "SYSTEM_BUILDER_INFO/Is_Enabled");

     my $mod_name = &get_data ($db_Module);
     
     next if (@modules_to_generate &&
              !(grep {$mod_name eq $_} @modules_to_generate));

     # Skip generation for modules which use the sooper-secret
     # don't-generate-me value.
     if (&get_data_by_path($db_Module,
                           "SYSTEM_BUILDER_INFO/Do_Not_Generate") ||
         (&get_data_by_path($db_Sys,
                            "WIZARD_SCRIPT_ARGUMENTS/Do_Not_Generate")
          )
         )
     {
        #bridges will get generated no matter what you say.
        unless (&get_data_by_path
                ($db_Module,
                 "SYSTEM_BUILDER_INFO/Is_Bridge")
                )
        {
           push @skipped_modules, $mod_name;
           next;
        }
     }

     # Open-up this module's "class.ptf" file.
     my $module_class = &PTF_Get_Required_Data_By_Path
         ($db_Module, "class", "No class specified for module: $mod_name");

     my $db_Class_File =
       get_class_ptf($g_mk_custom_sdk_state, $module_class);
     my $module_lib_dir =
       find_component_dir(
         $g_mk_custom_sdk_state,
         $db_Class_File,
         $module_class
       );

     my $db_Module_Class = 
         &PTF_Get_Required_Child_By_Path
         ($db_Class_File, "CLASS",
          "Bad or corrupt 'class.ptf' file for module $mod_name");

     my $lib_generator_program = &get_data_by_path 
         ($db_Module_Class, "ASSOCIATED_FILES/Test_Generator_Program");

     # This subroutine runs one of two types of generator-programs
     # for each module: either the traditional "Test_Generator_Program"
     # (which we just extracted above) or the newfangled
     # Software_Rebuild_Program", which we run if the magical argument
     # "software_only" is set. 
     if ($$arg{software_only}) {
         $lib_generator_program = "--none--";
     }

     # If the user has un-checked the "Generate HDL" option in the 
     # wizard, we do a preseto-changeo here and pretend their
     # generator program is "none".  Note that we leave their generator
     # program alone if we're in "software only" mode.
     $lib_generator_program = "--none--" 
         if !($$arg{generate_hdl}) && !($$arg{software_only});

     # If the library component didn't specify a generator program,
     # then give it the generic (default) one:
     #

     if ($lib_generator_program eq "")
     {
         $lib_generator_program = "--none--";
     }
     
     my $generator_program = "$module_lib_dir/$lib_generator_program";
     
     if (($lib_generator_program !~ /^--none--$/i)) 
     {
        # for now, complain bitterly if the generator program is not
        # apparently a Perl-script:
        #
        $generator_program =~ /\.pl$/ or return ("
        Illegal Generator program '$generator_program' for $module_class:
             Generator programs must be perl-scripts.\n");

        my $component_dirs_list_ref = Get_All_Component_Dirs($arg);
        my $a_component_dir;

        my @perl_exe = "$ENV{SOPC_PERL}/bin/perl" ;
        my $do_komodo_debug = &get_data_by_path
                ($db_Module, "WIZARD_SCRIPT_ARGUMENTS/komodo_debug");
        if ($do_komodo_debug) {
          @perl_exe = (&find_debugger_perl_location($arg) , "-d");
          #$ENV{PERLDB_OPTS}= "RemotePort=127.0.0.1:9001";
        }
        my @generator_cmd  = @perl_exe;

        my @component_libs = split(/\s*,\s*/s, &get_data_by_path($db_Module_Class, "ASSOCIATED_FILES/Generator_Libraries"));
        my @absolute_component_libs = map {$module_lib_dir."/$_";}@component_libs;
        # pass in all (!) component directories.
        # NOTE: the only known dependancy on passing ALL dirs: ASMI needs SPI
        # SHOULD: pass only module_lib_dir and other dependencies as specified
        #         by the module (perhaps in its CLASS definition)
        foreach my $ink (@INC,@absolute_component_libs,$module_lib_dir,@$component_dirs_list_ref)
        {
            push(@generator_cmd,"-I$ink");
        }

        push(@generator_cmd , "$generator_program");
        push(@generator_cmd ,        "--system_name=$$arg{system_name}");
        push(@generator_cmd , "--target_module_name=$mod_name");
        push(@generator_cmd ,   "--system_directory=$$arg{system_directory}");
        push(@generator_cmd ,     "--sopc_directory=$$arg{sopc_directory}");
        push(@generator_cmd ,      "--sopc_lib_path=$$arg{sopc_lib_path}");
        push(@generator_cmd ,           "--generate=1");
        push(@generator_cmd ,            "--verbose=$$arg{verbose}");
        push(@generator_cmd ,      "--software_only=$$arg{software_only}");
        push(@generator_cmd ,     "--module_lib_dir=$module_lib_dir");
        push(@generator_cmd ,   "--sopc_quartus_dir=$arg->{sopc_quartus_dir}");
        push(@generator_cmd ,        "--projectname=$$arg{projectname}");
        push(@generator_cmd ,  "--test_bench_component=1");

        if ($$arg{verbose})
        {
           foreach my $var(keys (%{$arg}))
           {
              printf($var." = ".$$arg{$var}."\n");
           } 	
           printf("module_lib_dir = ".$module_lib_dir."\n");
           printf("******\n");
        }

        if (&get_data_by_path
            ($db_Module,
             "SYSTEM_BUILDER_INFO/Is_Bridge")
            )
        {
           push (@bridge_name_list,$mod_name);
        }
        else
        {
           # Special time-saving option: only generate "the bus",
           # not any of the internal modules:
           push (@module_name_list,$mod_name) unless $$arg{bus_only};
        }
        $generator_cmds{$mod_name} = \@generator_cmd;
        print(".");
     }
  }
     print("\n");

  ###############
  # bridge generator commands get run last because they may need to know
  # slave ports.  Because of the need to know ports, we should be
  # more clever with bridges than we are.  This might not handle the
  # case where a bridge links to another bridge.  Since we only have
  # one type of bridge now (tri-state), this shouldn't be a problem.

  foreach my $name (@module_name_list,
                    @bridge_name_list
                    )
  {
     my @gc = @{$generator_cmds{$name}};

 # Time to make a decision about whether we're going to run the
 # generator program or the ASP Debugger w/ .NET.
     
     
     my $sys_ptf = $$arg{system_directory}."/".$$arg{system_name}.".ptf";
     my $sys_ptf_ref = &ptf_parse::new_ptf_from_file($sys_ptf);

     my $asp_debug = &ptf_parse::get_data_by_path($sys_ptf_ref,
     "SYSTEM $$arg{system_name}/MODULE $name/WIZARD_SCRIPT_ARGUMENTS/asp_debug");
     
#     print "$name: asp_debug: $asp_debug\n";
     
     # TODO: add komodo_debug functionality to Test Generator program, too.
     # Just never got around to this.   I'd steal identical code from the
     # Generator Program section.
     if($asp_debug ne "1"){
        &Progress ("Running Test Generator Program for $name");
        my $error_code = &System_Win98_Safe (\@gc);
        if ($error_code != 0)
        {
           return ("
          Error: Test Generator Program 
                 for module '$name' did NOT run successfully.\n".
                   "generator cmd was '@gc'\n");
        }
     }
     else
     {
        print("Running ASP .NET debugger for $name\n");

        &create_debug_project(\@gc);
        
        # This will block until the debugger exits.
        if(&check_dot_net_install($arg)){
           &launch_debug_project($arg);
        }
     }   
  }

  # Print the list of skipped modules now, to make it more likely
  # to be noticed.
  if (@skipped_modules) {
#     print STDERR 
#         "\nWARNING:\n",
#         (map {"Skipping generation of module '$_'\n"} @skipped_modules),
#         "\n\n";
  };

  #return @module_name_list;
  return (0);
} # &Run_Test_Generator_Programs

# Find the name of a log file for the generators and return it.
sub get_gen_log_fname
{
    my $system_dir = shift;

    my $max_attempts = 100;
    my $base = $system_dir . "/gen_log_";
    my $extension = ".txt";
    my $suffix;

    # Delete any left-over log files from before.
    for ($suffix = 0; $suffix < $max_attempts; $suffix++) {
        my $log_fname = $base .  $suffix . $extension;

        # Try to unlink old log file in case it exists.
        unlink($log_fname);
    }

    # Find unique log file name.
    for ($suffix = 0; $suffix < $max_attempts; $suffix++) {
        my $log_fname = $base .  $suffix . $extension;

        # Skip files that already exist.
        if (open(GET_GEN_LOG, "<$log_fname")) {
            close(GET_GEN_LOG);
            next;
        }

        # Make sure it can be open for write.
        if (open(GET_GEN_LOG, ">$log_fname")) {
            # It worked so return the file name after closing and emptying.
            close(GET_GEN_LOG);
            unlink($log_fname);
            return $log_fname;
        }
    }

    if ($suffix == $max_attempts) {
        die "mk_systembus.pl: Can't find available filename for generator output log (tried $max_attempts variations of ${base}${extension})";
    }
}




sub checkEuropaVersion()
{
    my $europaVersion = $europa_all::VERSION;
    $europaVersion = "unknown" if $europaVersion eq "";

    if($europaVersion ne $VERSION)
    {
        my $msg = "installation error: mk_systembus.pl version $VERSION does not match europa_all.pm version $europaVersion";
        ribbit($msg);
    }
}



sub doVersionAndHelp(@)
{
    my (@args) = (@_);
    my %switches = ptf_parse::ptf_parse_args(@args);

    my $help = ptf_parse::ptf_get_switch(\%switches,"help");
    my $version = ptf_parse::ptf_get_switch(\%switches,"version");

    if($help)
    {
        print $0,"\n";
        print
        print $Mk_SystemBus_Doc;
        exit 0;
    }

    if($version)
    {
        print $VERSION,"\n";
        exit 0;
    }
}


sub debugINC()
{
    print "INC is:\n";
    foreach my $x (@INC)
    {
        print "      ...$x...\n";
    }
    print "\n\n";
}
sub debugShowCommand(@)
{
    my (@command) = (@_);
    print "command is:\n";
    foreach my $x (@command)
    {
        print "      ...$x...\n";
    }
    print "\n\n";
}



################################################################ 
# Execution begins here
################################################################

&Mk_SystemBus (@ARGV);

