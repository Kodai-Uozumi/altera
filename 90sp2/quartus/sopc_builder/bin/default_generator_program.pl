 ################################################################
 # default_generator_program.pl
#Copyright (C)2001-2003 Altera Corporation
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
#
#
#
 # Suppose a user has a plain-old Verilog (or VHDL) module--no
 # Vpp, parameterization, or generation about it.
 #
 # Suppose they want to include this design into an Avalon system
 # module.  They are perfectly willing to fill oFt a "class.ptf" file
 # which describes their ports and sundry System-parameters
 # (e.g. Hold_Time).  But they don't want to write a whole generator
 # program--they just want to use their "thing".
 #
 # If the component's class.ptf  file gives "" (or "--default--") as
 # the "generator_program", then the SOPC-Builder calls THIS VERY
 # PROGRAM (default_generator_program.pl) -as if- it was the user's
 # generator program.  This saves the Authors of simple
 # SOPC-components the drudgery of writing their own "generator_program."
 #
 # And what wonderful things do we do on the author's behalf?
 #
 #   1) Generate a renaming-wrapper.
 #   2) Copy implementation-files into project-directory.
 #   3) Arrange for some files to be synthesized (if appropriate or asked).
 #
 # **** Making a Renaming Wrapper
 #
 # The user will have defined a module named, for example,
 # jthingwizard (who knows--they -might- name it that!).
 # But, in the SOPC-Builder table, they want to add
 # one of those "jthingwizard" things named "my_inst."
 # So we create a new module named "my_inst" (with
 # exactly the same ports as "jthingwizard") which contains
 # one instance of "jthingwizard" and nothing else.
 # The almost-pointless (but totally required) "my_inst"
 # module is the -renaming wrapper-.
 #
 # When we build the renaming-wrapper, we can either instantiate the
 # user's module directly, or we can instantiate it as a black-box.
 # This all depends on whether they want us to synthesize it or not.
 # often they will, but sometimes they won't.  If you don't explicitly
 # say so, this program will try to make an intelligent guess about
 # black-boxing based on the types of files found in the class-directory.
 # If you have nothing but a schematic, for example, then clearly you
 # want a black-box.
 #
 # It is only possible to build a renaming wrapper if:
 #    a) The users' "class.ptf" file describes -all- ports.
 #    b) The top-level module name is known.
 #
 # (a) is entirely up to you.  If you don't describe each-and-every
 # port in your "class.ptf"-file, then this function simply will not
 # work.
 #
 # We try to help you with (b) by making an educated guess.  If you
 # don't specifically say what your top-level module is, we just
 # assume it's the same as the class-name (what else would it be,
 # after all?).
 #
 #
 # **** Copying Implementation Files
 #
 # Every component must be implemented -somehow-.  We start off with
 # the default asssumption that the top-module of this component is
 # named the same as the component directory ("jthingwizard" in the
 # above example) and is implemented in an HDL, BDF, or EDF-file of
 # the same name.  Unless told otherwise, we search for such a file in
 # the components' directory, and then copy it blindly into the
 # project directory for the system-under-construction.  In fact,
 # by default, we copy -all- desgin files from the component-directory into
 # the project-directory, whether you need them or not (if you didn't
 # need them, after all, what were they doing in the component directory?).
 #
 # Alternatively, the user can supply a list of files-to-be copied
 # and, separately, files-to-be-synthesized.
 #
 # **** Altering default behavior.
 #
 # Suppose the top-level module -isn't- the same as the
 # component-directory name, or -isn't- implemented in a file
 # of the same name.  Or, suppose you -don't- want us to try
 # synthesizing your file, but you want it to be a black-box instead.
 # well, then.  You'd have to override the behavior or this program
 # somehow.  (You could, of course, write your own generator program,
 # but we'll see how far we can get you before we ask you to bail
 # out).
 #
 # Your "class.ptf" file can contain a section named
 # DEFAULT_GENERATOR, in which you can supply directions to this
 # program.  Here is an example DEFAULT_GENERATOR function
 # demonstrating all the available parameters:
 #
 #     DEFAULT_GENERATOR
 #     {
 #        top_module_name      = "my_tippie_toppie";
 #        black_box_files      = "summit.edf, blickman.bsf";
 #        synthesis_files      = "toppo.v, submod1.v, libx.vhd";
 #        black_box            = "0";
 #     }
 #
 # Seems pretty clear to me what all these things are, so I'll spare
 # you the pain of suffering through an English description.
 #
 # All the filenames are given relative to the class-directory
 # (or as absolute full pathnames, your choice).
 #
 ################################################################

use wiz_utils;
use europa_all;
use strict;

my $DEBUG = 0;
################################################################
# Default_Generator
#
# Implements the default generator as a callable function.
#
################################################################ 
sub Default_Generator
{
  my (@args) = (@_);
  my ($arg, $user_defined, $db_Module, $db_PTF_File) =
    &Process_Wizard_Script_Arguments ("", @args);

  my @simulation_files_list;  
  my (@section_names_that_have_port_wiring) = ("MODULE/MASTER", "MODULE/SLAVE", "MODULE"); 


  my $ref_to_pw;
  my @e_ports;

  &Progress ("Default Generator Program for: $$arg{name}.");

  ### Build Module
  my $project = e_project->new(@args);
  my $module_name = $project->_target_module_name();
  my $module_ref = $project->spaceless_system_ptf()->{MODULE};
  my $module_name_ref = $project->spaceless_system_ptf()->{MODULE}{$module_name};  
  my $project_path = $project->_system_directory();
  my $library_path = $project->_module_lib_dir();
  my $sim_path     = $project_path."/".$project->_system_name()."_sim";

  ### If the default generator is run first, then there may not be a simulation directory.
  ### Create it.
  &Create_Dir_If_Needed($sim_path);

   my $e_ptf_thing1 = e_ptf->new();
   $e_ptf_thing1->ptf_file($library_path."/class.ptf");
   &ribbit("Could not find library component for $$arg{name}!\n
            The component is not intalled on this system!\n")	
	if(!$e_ptf_thing1);	
   my $class_hr = $e_ptf_thing1->spaceless_ptf_hash();
   
  my $name = $class_hr->{CLASS};
  my @array = keys (%$name);
  my $class_name = $array[0];

  my $class_name = $module_name_ref->{class};
  &ribbit("Could not find class assignment in class.ptf, found $class_name\n")
    if(!$class_name);
  my $default_hr = $class_hr->{CLASS}{$class_name}{DEFAULT_GENERATOR};  

  ## process all of the default generator args
  my $opt = &validate_default_generator_options($class_hr);
  my $top = $project->top();
  
  # add the ports to the system module
  # do the master sections 
  my @e_ports;
  foreach my $section_name(keys(%{$module_name_ref->{MASTER}}))
    {
      my $ref_to_pw = $module_name_ref->{MASTER}{$section_name}{PORT_WIRING};
      push(@e_ports,@{&create_e_ports_from_port_wiring_section($ref_to_pw)});
    }	

  # do the slave sections
  foreach my $section_name(keys(%{$module_name_ref->{SLAVE}}))
    {
      $ref_to_pw = $module_name_ref->{SLAVE}{$section_name}{PORT_WIRING};
      push(@e_ports,@{&create_e_ports_from_port_wiring_section($ref_to_pw)});
    }	

  # do the rest of the ports
  $ref_to_pw = $module_name_ref->{PORT_WIRING};
  push(@e_ports, @{&create_e_ports_from_port_wiring_section($ref_to_pw)})
    if($ref_to_pw);  


  # whoopee... we now have the ports... make the 
  $top->add_contents(@e_ports);



  my $top_instance;
      $top_instance = e_module->new({
				     name => $opt->{top_module_name},
				     contents =>  [@e_ports],
				     do_black_box => 0,
				     do_ptf => 0,
				     _hdl_generated => 1,
				     _explicitly_empty_module => 1,
				    });


  my $top_instance_filename;
  if($opt->{black_box} eq "1")
  {
     # Note: this code may be broken or irrelevant.  -Aaron
     $top_instance->do_black_box(1);
     if ($project->language =~ /verilog/)
     {
        $top_instance->_hdl_generated(0);
        $top_instance_filename =
            $opt->{top_module_name}."_black_box_module";
	$top_instance->output_file($top_instance_filename);	
        $top_instance_filename .= ".v";
     }
  }

  $top->add_contents (
		      e_instance->new({
				       module => $top_instance,
				      }),
		     );

  ## if the user has set a specific set of synthesis files they want for their
  ## language, then respect the setting...
  ## only VHDL and Verilog are supported.
  my $language = $project->language();
  print("Language is: $language\n")
      if ($DEBUG);
  &ribbit("No HDL language set for project!")
    if($language eq "");

  ## clear out the ptf sections corresponding to the peripheral
   $project->module_ptf()->{HDL_INFO}{Synthesis_HDL_Files} = "";
   $project->module_ptf()->{HDL_INFO}{Synthesis_HDL_Files} = "";

  ## copy the user specified files over to the system directory
  ## new feature... support the distinction of verilog and vhdl files

  $opt->{synthesis_files} = ""
      if ($opt->{synthesis_files} eq "default");
  $opt->{$language."_synthesis_files"} = ""
      if ($opt->{$language."_synthesis_files"} eq "default");

  $opt->{Synthesis_Only_Files} = ""
      if ($opt->{Synthesis_Only_Files} eq "default");
  $opt->{$language."_Synthesis_Only_Files"} = ""
      if ($opt->{$language."_Synthesis_Only_Files"} eq "default");


  my $synthesis_files_to_copy = "";
  if(!($opt->{black_box} eq "1")){
    $synthesis_files_to_copy = $opt->{$language."_synthesis_files"} ||
      $opt->{synthesis_files} ||
      (($language eq "verilog")? "*.v" : "*.vhd");
  }

  print("Synthesis files to copy: $synthesis_files_to_copy\n")
	if($DEBUG);
  my @synthesis_list = &copy_files_from_dir_to_dir
      ($library_path,$project_path,$synthesis_files_to_copy);


  # now get precompiled libraries
  my @precompiled_sim_libraries = &getPrecompiledSimulationModels($opt, $language);
  
  if($language eq "vhdl"){
    foreach my $precompiled_sim_lib (@precompiled_sim_libraries){
      $top->parent_module()->vhdl_libraries()->{$precompiled_sim_lib} = 'all';
    }
  }
  



  my @final_precompiled_library_path = map{$library_path."/".$_;}@precompiled_sim_libraries;
  $project->module_ptf()->{HDL_INFO}{Precompiled_Simulation_Library_Files} = join(",", @final_precompiled_library_path);  

  # now get synthesis_only_files
  my @synthesis_only = &getSynthesisOnlyFiles($opt, $language);
  &copy_files_from_dir_to_dir($library_path,$project_path,join(",", @synthesis_only));

  #change things around if black box.  
  if ($opt->{black_box})
  {
     #don't synthesize something which is a black box.
     if ($top_instance_filename) #aka verilog
     {
       if ($opt->{Precompiled_Simulation_Library_Files} ne "default")
       {
         @synthesis_list = ();
         push (@synthesis_only, $top_instance_filename);
       }
       else
       {
         #@synthesis_list = ($top_instance_filename);
	 push(@simulation_files_list, $top_instance_filename);
       }
     }
     else
     {
        @synthesis_list = (); #aka vhdl
     }
  }



  #we need to defer committing the synthesis_only_files list until we 
  #have made up our mind regarding the top_instance_filename
  $project->module_ptf()->{HDL_INFO}{Synthesis_Only_Files} = join (", ",
    map
    {
      "__PROJECT_DIRECTORY__/".$_;
    }@synthesis_only);

  my @final_synthesis_list;
  foreach my $synth_elem (@synthesis_list)
  {
     print("synthesis elem: $synth_elem\n") if ($DEBUG);
     push(@final_synthesis_list, "__PROJECT_DIRECTORY__/".$synth_elem);
  }
   ## don't forget the module file to synthesize
   my $module_file = $module_name.".v";
   $module_file = $module_name.".vhd"
   	if($language eq "vhdl"); 
   push(@final_synthesis_list, "__PROJECT_DIRECTORY__/".$module_file);   
   my $total_synthesis_files = join(",", @final_synthesis_list);

   print("synthesis files: $total_synthesis_files\n")
     if($DEBUG);

   $project->top()->do_ptf(0);
   $project->do_write_ptf(0);
   $project->module_ptf()->{HDL_INFO}{Synthesis_HDL_Files} = $total_synthesis_files;
						       
  ## move any black box files over...
  ## DONT put them into the system PTF file
  my $black_box_files = $opt->{black_box_files};
  $black_box_files = ""
      if ($black_box_files eq "default");

  $black_box_files = $black_box_files ||
      "*.tdf,*.edf,*.bdf,*.bsf,*.vqm,*.mif";

  my @black_box_list = &copy_files_from_dir_to_dir
      ($library_path,$project_path,$black_box_files);
  
    ## copy any simulation files over to the directory
    $opt->{simulation_files} = ""
      if ($opt->{simulation_files} eq "default");
    $opt->{$language."_simulation_files"} = ""
      if ($opt->{$language."_simulation_files"} eq "default");
  

    my $simulation_files = "";


    $simulation_files = $opt->{$language."_simulation_files"} ||
                        $opt->{"simulation_files"};

    print("simulation_files: $simulation_files\n")
      if($DEBUG);


#     if($opt->{simulation_files} ne "default")
#     {
#       $simulation_files = $opt->{simulation_files};
#       $simulation_files = "*.v,*.vhd"
# 	if($opt->{simulation_files} eq "");
#       print("simulation_files: $simulation_files\n")
# 	if($DEBUG);
#     }
#     else
#     {
#       $simulation_files = "";
#     }  
 

   push(@simulation_files_list,&copy_files_from_dir_to_dir($library_path,$sim_path,$simulation_files));

   my @final_simulation_file_list = map
   {
     "__PROJECT_DIRECTORY__/".$project->_system_name()."_sim/".$_;
   } @simulation_files_list;
  
  $project->module_ptf()->{HDL_INFO}{Simulation_HDL_Files} = join(",", @final_simulation_file_list);

  my $section_name = "${language}_Sim_Model_Files";
  my $section = $opt->{$section_name};
     $section = "" if ($section eq "default");

  my @section_files_list =
      &copy_files_from_dir_to_dir($library_path,$sim_path,$section);
  my @final_section_file_list = map
  {
     "__PROJECT_DIRECTORY__/".$project->_system_name()."_sim/".$_;
  } @section_files_list;
  $project->module_ptf()->{HDL_INFO}{$section_name} = join (", ",@final_section_file_list);

  $project->ptf_to_file();
  $project->output();
}

sub create_e_ports_from_port_wiring_section()
{
  my ($module_port_wiring_ref) = (@_);
  my @return_listy;

  foreach my $porty_name(keys(%{$module_port_wiring_ref->{PORT}}))
  {
    my $named_porty_ref = $module_port_wiring_ref->{PORT}{$porty_name};
#    print("port_name: $porty_name, width: $named_porty_ref->{width}\n");
    my $porto = e_port->new({
			     name => $porty_name,
			     width => $named_porty_ref->{width},
			     direction => $named_porty_ref->{direction},
			    });
    push(@return_listy, $porto);  
  }
  return(\@return_listy);
}




sub validate_default_generator_options()
{
  (my $class_hash) = (@_);
  my @list = keys %{$class_hash->{CLASS}};
  die("More than one CLASS section found in class.ptf\n")
    if(@list != 1);
  
  my $class_name = $list[0];
  my %opt_hash;   
  

  my $def_gen_hash = $class_hash->{CLASS}{$class_name}{DEFAULT_GENERATOR};


  ## find the right subsection for the HDL language of choice
  ## if a section with the correct language is present, use that... otherwise


  if($def_gen_hash)
  { 
  ## get the top module name first:
  ## if the user has not specified a top_module_name, then they get the default class name
    my $top_module_name = $def_gen_hash->{top_module_name};
    $opt_hash{top_module_name} = &validate_and_get_setting($def_gen_hash, "top_module_name", "string",1);
    $opt_hash{top_module_name} = $class_name
      if($opt_hash{top_module_name} eq "");  
    
    $opt_hash{black_box} = &validate_and_get_setting($def_gen_hash, "black_box", "bool", 1);
    $opt_hash{synthesis_files} = &validate_and_get_setting($def_gen_hash, "synthesis_files", "string",1);
    $opt_hash{black_box_files} = &validate_and_get_setting($def_gen_hash, "black_box_files", "string",1);
    $opt_hash{verilog_synthesis_files} = &validate_and_get_setting($def_gen_hash, "verilog_synthesis_files", "string",1);
    $opt_hash{vhdl_synthesis_files} = &validate_and_get_setting($def_gen_hash, "vhdl_synthesis_files", "string",1);
    $opt_hash{simulation_files} = &validate_and_get_setting($def_gen_hash, "simulation_files", "string",1);
    $opt_hash{verilog_simulation_files} = &validate_and_get_setting($def_gen_hash, "verilog_simulation_files", "string",1);
    $opt_hash{vhdl_simulation_files} = &validate_and_get_setting($def_gen_hash, "vhdl_simulation_files", "string",1);
    $opt_hash{Precompiled_Simulation_Library_Files} = &validate_and_get_setting($def_gen_hash, "Precompiled_Simulation_Library_Files", "string",1);
    $opt_hash{Synthesis_Only_Files} = &validate_and_get_setting($def_gen_hash, "Synthesis_Only_Files", "string",1);
    $opt_hash{vhdl_Synthesis_Only_Files} = &validate_and_get_setting($def_gen_hash, "vhdl_Synthesis_Only_Files", "string",1);
    $opt_hash{verilog_Synthesis_Only_Files} = &validate_and_get_setting($def_gen_hash, "verilog_Synthesis_Only_Files", "string",1);
    
    foreach my $language ("verilog","vhdl")
    {
       my $section = "${language}_Sim_Model_Files";
       $opt_hash{$section} =
           &validate_and_get_setting($def_gen_hash, $section,
                                     "string",1);
    }

    $opt_hash{default_generator_found} = "1";
  }
  else 
  {
    $opt_hash{top_module_name} = $class_name;
    $opt_hash{black_box} = "1";
    $opt_hash{black_box_files} = "default";
    $opt_hash{verilog_synthesis_files} = "default";
    $opt_hash{vhdl_synthesis_files} = "default";
    $opt_hash{vhdl_simulation_files} = "default";
    $opt_hash{verilog_simulation_files} = "default";
    $opt_hash{vhdl_Sim_Model_Files} = "default";
    $opt_hash{verilog_Sim_Model_Files} = "default";
    $opt_hash{default_generator_found} = "default";
    $opt_hash{Precompiled_Simulation_Library_Files} = "default";
    $opt_hash{Synthesis_Only_Files} = "default";
    $opt_hash{vhdl_Synthesis_Only_Files} = "default";
    $opt_hash{verilog_Synthesis_Only_Files} = "default";

  }

  return \%opt_hash;
}

sub validate_and_get_setting()
{
  my ($hash_to_level, $name, $type, $optional, $default) = (@_);
  my $return_string;

  if(&test_for_existence($hash_to_level, $name) == 1)
    {

      $return_string = (
	     &validate_parameter({hash     => $hash_to_level,
				  name     => $name,
				  type     => $type,
				  optional => $optional,
				  default  => $default,
				 })
	    );
    }
  else
    {
       $return_string ="default";
    }
  print("option: $name is $return_string\n")
    if($DEBUG);
  
  return $return_string;
}


sub test_for_existence()
{
  my ($hash_to_level, $name) = (@_);
   
  return 1
    if(exists $hash_to_level->{$name});

  return 0;
}


sub copy_files_from_dir_to_dir()
{
  my ($source_dir, $target_dir, $files) = (@_);

  my @file_list = split(/\s*\,\s*/, $files);
  my @files_to_copy;

  opendir (DIR, $source_dir) or &ribbit
      ("can't open $source_dir ($!)\n");

  foreach my $filename(@file_list) 
  {
     if($filename =~ /\*\.(.*?)$/)
     {
        my $extension = $1;
        foreach my $file (readdir(DIR))
        {
           next unless $file =~ /\.$extension$/;
           push (@files_to_copy, $file);
        }	
     }
     else
     {
        push (@files_to_copy, $filename);
     }
  }

  foreach my $filename (@files_to_copy)
  {
    &Perlcopy($source_dir."/".$filename, $target_dir."/".$filename);
  }

  
  closedir (DIR);
  return(@files_to_copy);
}


sub getPrecompiledSimulationModels()
{
  my ($opt, $language) = (@_);
  my @precompiled_path_array;
 
  # This deals with simulation library files for dudes with only a model (and no source)
  # This operation doesn't copy over any of the simulation files, but rather, just sets a pointer to the 
  # simulation library (which is relative to the component directory)
  my $precompiled_path = $opt->{Precompiled_Simulation_Library_Files};


  if (($precompiled_path =~ /^\s*work\s*$/i) ||
      ($precompiled_path =~ /[\\\/]work\s*$/i))
    {
      &ribbit("Precompiled_simulation_Library_Files cannot be set to \"work\", used by the main project\n");
    }

  if($precompiled_path ne "default"){	
    printf("--DEBUG: Getting simulation_libs from: $precompiled_path\n")
      if($DEBUG);
    @precompiled_path_array = split(/\s*\,\s*/, $precompiled_path);
#    my @final_precompiled_library_path = map{ 
#      $library_path."/".$_;
#    } split(/\s*\,\s*/, $precompiled_path);
  }
  return @precompiled_path_array;
}


sub getSynthesisOnlyFiles()
{
  my ($opt, $language) = (@_);
  my @Synthesis_Only_Files_Array = ();	
  my $Synthesis_Only_Files = $opt->{$language."_Synthesis_Only_Files"} ||
                          $opt->{Synthesis_Only_Files};
  print("Synthesis Only files to copy: $Synthesis_Only_Files\n")
	if($DEBUG);
  @Synthesis_Only_Files_Array = split(/\s*\,\s*/, $Synthesis_Only_Files); 
  return(@Synthesis_Only_Files_Array);
}


# ################################################################
# ################################################################
# ###
# ###     Execution starts here.
# ###
# ################################################################
# ################################################################

&Default_Generator (@ARGV);









