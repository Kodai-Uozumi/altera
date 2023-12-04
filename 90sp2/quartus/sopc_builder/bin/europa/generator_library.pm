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






package generator_library;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(generator_copy_files_and_set_system_ptf
             generator_copy_files
             generator_set_files_in_system_ptf
	     generator_make_module_wrapper
	     generator_begin
	     generator_end
	     generator_get_system_ptf_handle
	     generator_get_class_ptf_handle
	     generator_get_language
	     generator_enable_mode
	     generator_end_read_module_wrapper_string
	     generator_end_write_module_wrapper_string
	     generator_print_verbose
	    );

use wiz_utils;
use europa_all;
use ptf_parse;
use strict;

my $DEBUG_DEFAULT_GEN = 1;



my $generator_hr = {
		     wrapper_args => {
				      make_wrapper => 0,
				      top_module_name => "",
				      simulate_hdl => 1,
				      ports => "",
				     },
		     class_ptf_hr => "",
		     module_ptf_hr => "",
		     system_ptf_hr => "",
		     language => "",
		     external_args => "",
		     external_args_hr => "",
		     project_path_widget => "__PROJECT_DIRECTORY__",
		     generator_mode => "silent",
		    };


sub generator_print_verbose
{
  my ($info) = (@_);

  if($generator_hr->{generator_mode} eq "verbose"){
    print("generator_program_lib: ".$info);
  }
}

sub generator_enable_mode
{
  my ($mode) = (@_);
  $generator_hr->{generator_mode} = $mode;
}

sub generator_get_system_ptf_handle
{ 
  return $generator_hr->{system_ptf_hr};
}

sub generator_get_language
{
  return $generator_hr->{language};
}

sub generator_get_class_ptf_handle
{
  return $generator_hr->{class_ptf_hr};
}

sub default_ribbit
{
  my ($arg) = (@_);
  &ribbit("\n\n--Error: default_gen_lib: $arg\n");  
}


sub _copy_files
{
  my ($dest_dir, $source_dir, @files) = (@_);
  my $function_name;
  

  &default_ribbit("No target dir for function copy_files!")
  unless ($dest_dir ne "");
  
  &default_ribbit("No source dir for function copy_files!")
  unless ($source_dir ne "");

  &default_ribbit("No files for function copy_files!")
  unless (@files != 0);

  

  opendir (SDIR, $source_dir) or 
    &default_ribbit("can't open $source_dir !");
  
  opendir (DDIR, $dest_dir) or
    &default_ribbit("can't open $dest_dir !");
  
  
  foreach my $source_file(@files){



    my $source_subdir = "";
    my $source_filename = $source_file;

    if($source_filename =~ /^(.*)\/(.*)$/)  # break on last slash
    {
      $source_subdir = "/$1"; # embed its leading slash, for concatty
      $source_filename = $2;
    }

    my $source_fullpath = "$source_dir$source_subdir/$source_filename";
    my $dest_fullpath = "$dest_dir/$source_filename";

    &Perlcopy($source_fullpath, $dest_fullpath);
    &generator_print_verbose("Copying file: \"$source_fullpath\""
            . " to \"$dest_fullpath\".\n");
  }

  closedir (SDIR);
  closedir (DDIR);
}


sub get_module_wrapper_arg_hash_from_system_ptf_file
{
  my $module_ptf_hr = $generator_hr->{module_ptf_hr};
  
  my @list_of_sections = ("MASTER","SLAVE","PORT_WIRING");
  my @port_list;
  foreach my $section(@list_of_sections){
    my $number = get_child_count($module_ptf_hr, $section);

    for(my $initial=0; $initial < $number; $initial++){
      
      my $interface_section = get_child($module_ptf_hr, $initial, $section);	
      my $interface_section_name = get_data($interface_section);

      my $port_wiring_section;
      if($section ne "PORT_WIRING"){
	$port_wiring_section = 
	  get_child_by_path($module_ptf_hr, $section." ".$interface_section_name."/PORT_WIRING");	
      }else{
	$port_wiring_section =
	  get_child_by_path($module_ptf_hr, $section);
      }
      my $num_ports = get_child_count($port_wiring_section, "PORT");
      foreach(my $port_count = 0; $port_count < $num_ports; $port_count++){
	my $port = get_child($port_wiring_section, $port_count, "PORT");
	
	my %port_info_struct;
	$port_info_struct{name} = get_data($port);
	$port_info_struct{direction} = get_data_by_path($port, "direction");
	$port_info_struct{width} = get_data_by_path($port, "width");
	
	push(@port_list, \%port_info_struct);
	
      }
    }	
  }
  $generator_hr->{wrapper_args}{ports} = \@port_list;
}


sub generator_make_module_wrapper
{
  my ($simulate_hdl, $top_module_name) = (@_);

  &default_ribbit("generator_make_module_wrapper: no arg0 passed in for simulate_hdl\n")
    if($simulate_hdl eq '');

  &default_ribbit("generator_make_module_wrapper: no arg1 passed in for top_module_name\n")
    unless($top_module_name);

  $generator_hr->{wrapper_args}{simulate_hdl} = $simulate_hdl;
  $generator_hr->{wrapper_args}{top_module_name} = $top_module_name;
  $generator_hr->{wrapper_args}{make_wrapper} = 1;

}



sub _generator_make_module_wrapper	
{
  
  my $wrapper_args = $generator_hr->{wrapper_args};
  my $no_black_box = $wrapper_args->{simulate_hdl};
  my $top_module_name = $wrapper_args->{top_module_name};
  my $language = $generator_hr->{language};
  my @external_args = @{$generator_hr->{external_args}};
  my $module_ptf_hr = $generator_hr->{module_ptf_hr};


  my $project = e_project->new(@external_args);
  my $top = $project->top();
  

  my @ports;
  
  foreach my $port_hash(@{$wrapper_args->{ports}}){
    my $porto = e_port->new({
			     name => $port_hash->{name},
			     width => $port_hash->{width},
			     direction => $port_hash->{direction},
			    });
    push(@ports, $porto);
  }
  $top->add_contents(@ports);
  
  my $top_instance;
  $top_instance = e_module->new({
				 name => $top_module_name,
				 contents =>  [@ports],
				 do_black_box => 0,
				 do_ptf => 0,
				 _hdl_generated => 1,
				 _explicitly_empty_module => 1,
				});

  $top->add_contents (
		      e_instance->new({
				       module => $top_instance,
				      }),
		     );
  
  $project->top()->do_ptf(0);
  $project->do_write_ptf(0);
  
  
  my $module_file = $project->_target_module_name().".v";
  $module_file = $project->_target_module_name().".vhd"
    if($language eq "vhdl");

  $module_file = $generator_hr->{project_path_widget}."/".$module_file;
  &generator_set_files_in_system_ptf("Synthesis_HDL_Files", ($module_file));
  $project->output();



  if($no_black_box eq "0")
  {
    my $black_project = e_project->new(@external_args);
    $black_project->_target_module_name($top_module_name);
    my $black_top = $black_project->top();



    $black_top->add_contents(@ports);
    my $black_top_instance;
    $black_top_instance = e_module->new({
				   name => $wrapper_args->{top_module_name}."_bb",
				   contents =>  [@ports],
				   do_black_box => 1,
				   do_ptf => 0,
				   _hdl_generated => 0,
				   _explicitly_empty_module => 1,
				  });
    
    $black_top->add_contents (
			e_instance->new({
					 module => $black_top_instance,
					}),
		       );




    $black_project->top()->do_ptf(0);
    $black_project->do_write_ptf(0);

    my $black_module_file = $black_project->_target_module_name().".v";
    $black_module_file = $black_project->_target_module_name().".vhd"
      if($language eq "vhdl");


    $black_module_file = $generator_hr->{project_path_widget}."/".$black_module_file;
    &generator_set_files_in_system_ptf("Simulation_HDL_Files", ($black_module_file));




    $black_project->output();
  }

}







my $decoder_ring_hr = {
			quartus_only => {
					 copy => 1,
					 copy_to => "project",
					 ptf_set => 0,
					},
			simulation_only => {
					    copy => 1,
					    copy_to => "simulation",
					    ptf_set => 1,
					    ptf_section => "Simulation_HDL_Files",
					   },
			simulation_and_quartus => {
						   copy => 1,
						   copy_to => "project",
						   ptf_set => 1,
						   ptf_section => "Synthesis_HDL_Files",
						  }, 
		       precompiled_simulation_files => {
							copy => 0,
							ptf_set => 1,
							ptf_section => "Precompiled_Simulation_Library_Files",
						       },
		      };




sub generator_copy_files_and_set_system_ptf
{
  my ($hdl_section, @file_list) = (@_);

  my $ptf_path_prefix = "";  
  my $external_args_hr = $generator_hr->{external_args_hr};
  my @new_file_array;


  my $decoder_hash = $decoder_ring_hr->{$hdl_section};
  &default_ribbit("generator_copy_files_and_set_system_ptf: No understood HDL section passed in for first arg\n")
    unless($decoder_ring_hr->{$hdl_section} ne "");

  &generator_print_verbose("generator_copy_files_and_set_system_ptf: copying files for section ".$hdl_section."\n");


  my @new_file_array;





  if($decoder_hash->{copy}){
    my $copy_to_location;
    my $copy_from_location;

    if($decoder_hash->{copy_to} eq "project"){
      $copy_to_location = $external_args_hr->{system_directory};
    }elsif($decoder_hash->{copy_to} eq "simulation"){
      $copy_to_location = $external_args_hr->{system_sim_dir};
    }else{
      &default_ribbit("generator_copy_files_and_set_system_ptf: No understood copy files to location\n");
    }

    $copy_from_location = $external_args_hr->{class_directory};
    @new_file_array = &generator_copy_files($copy_to_location, $copy_from_location, @file_list);
  }else{
    @new_file_array = @file_list;
  }	


  if($decoder_hash->{ptf_set}){

    if($decoder_hash->{copy_to} eq "project"){
      foreach my $file(@new_file_array){
        $file = $generator_hr->{project_path_widget}."/".$file;
      }
    }
    &generator_print_verbose("generator_copy_files_and_set_system_ptf: setting system PTF file in section ".$hdl_section."\n");
    if($decoder_hash->{ptf_section} eq "Precompiled_Simulation_Library_Files"){
      @new_file_array = map{$external_args_hr->{class_directory}."/".$_} @new_file_array;
    }
    &generator_set_files_in_system_ptf($decoder_hash->{ptf_section}, @new_file_array);
  }
}










sub generator_set_files_in_system_ptf
{
  my ($hdl_section, @list_of_files) = (@_);

  my $file_list = join(",", @list_of_files);
  my $previous_data;  

  &generator_print_verbose("setting HDL_INFO/".$hdl_section." in system PTF file with ".$file_list."\n");
  my $previous_data = &get_data_by_path($generator_hr->{module_ptf_hr}, "HDL_INFO/".$hdl_section);  
  if($previous_data){
    $file_list = $previous_data . ", $file_list"; # spr 132177

  }
  &set_data_by_path($generator_hr->{module_ptf_hr}, "HDL_INFO/".$hdl_section, $file_list);
}









sub generator_copy_files
{
  my ($target_directory, $source_directory, @list_of_files) = (@_);

  my @new_file_array;

  foreach my $file_name(@list_of_files){
    if($file_name =~ /\*\.*/){
      $file_name =~ s/\*/$1/;
      my @found_list = &_find_all_dir_files_with_ext($source_directory, $file_name);
      push(@new_file_array, @found_list);
    }else{
      &generator_print_verbose("Copying: ".$file_name."\n");
      push(@new_file_array, $file_name);
    }
  }

  &_copy_files($target_directory, $source_directory, @new_file_array);
  return @new_file_array;
}



sub _find_all_dir_files_with_ext
{
  my ($dir,
      $ext) = (@_);

  opendir (DIR, $dir) or
    &default_ribbit("can't open $dir !");
  
  my @all_files = readdir(DIR);
  my @new_file_list; 
 
  
  foreach my $file (@all_files){
    if($file =~ /^.*($ext)$/){
      push(@new_file_list, $file);
    }
  }

  return @new_file_list;
}









sub generator_begin
{
  my @external_args = (@_);

  my  ($external_args_hr, 
       $temp_user_defined, 
       $temp_db_Module, 
       $temp_db_PTF_File) = Process_Wizard_Script_Arguments("", @external_args);
  
  &generator_print_verbose("generator_begin: initializing\n");

  $generator_hr->{external_args_hr} = $external_args_hr;
  $generator_hr->{external_args} = \@external_args;


  $generator_hr->{class_ptf_hr} = new_ptf_from_file($external_args_hr->{class_directory}."/class.ptf");


  $generator_hr->{system_ptf_hr} = new_ptf_from_file($external_args_hr->{system_directory}."/".$external_args_hr->{system_name}.".ptf");
  $generator_hr->{module_ptf_hr} = &get_child_by_path($generator_hr->{system_ptf_hr}, "SYSTEM $external_args_hr->{system_name}/MODULE $external_args_hr->{target_module_name}");
  my $class_name = get_data_by_path($generator_hr->{module_ptf_hr}, "class");


  $generator_hr->{language} = get_data_by_path($generator_hr->{system_ptf_hr}, "SYSTEM $external_args_hr->{system_name}/WIZARD_SCRIPT_ARGUMENTS/hdl_language");


  &get_module_wrapper_arg_hash_from_system_ptf_file();



  &delete_child($generator_hr->{module_ptf_hr}, "HDL_INFO");

  return $generator_hr->{module_ptf_hr};
}	









sub generator_end
{

  if($generator_hr->{wrapper_args}{make_wrapper}){
    &_generator_make_module_wrapper();
  }

  
  my $external_args_hr = $generator_hr->{external_args_hr};
  my $ptf_file_name = $external_args_hr->{system_directory}."/".$external_args_hr->{system_name}.".ptf";
  &generator_print_verbose("generator_end: writing PTF file ".$external_args_hr->{system_name}.".ptf to ".$external_args_hr->{system_directory}."\n");

  default_ribbit("Cannot write PTF file ".$ptf_file_name."!\n")
    unless(&write_ptf_file($generator_hr->{system_ptf_hr}, $external_args_hr->{system_directory}."/".$external_args_hr->{system_name}.".ptf"));  
}

sub generator_end_read_module_wrapper_string
{
   my $language = &generator_get_language();
   my $ls;

   if($language =~ /vhdl/){
     $ls = ".vhd";
   }elsif($language =~ /verilog/){
     $ls = ".v";
   }else{
     &ribbit("generator_end_read_module_wrapper_string invoked with unkown language");
   }
   my $system_dir = $generator_hr->{external_args_hr}->{system_directory};
   my $module_name = $generator_hr->{external_args_hr}->{target_module_name};

   my $file = $system_dir."/".$module_name.$ls;
   &generator_print_verbose("generator library reading file into string: $file\n");

   open (FILE,"<$file") or ribbit "cannot open file ($file) ($!)\n";
   my $return_string;
   while (<FILE>)
   {
      $return_string .= $_;
   }
   close (FILE);
   return($return_string);
}

sub generator_end_write_module_wrapper_string
{
   my $string = shift or ribbit "no string specified\n";

   my $language = &generator_get_language();
   my $ls;

   print $language;

   if($language =~ /vhdl/){
     $ls = ".vhd";
   }elsif($language =~ /verilog/){
     $ls = ".v";
   }else{
     &ribbit("generator_end_read_module_wrapper_string invoked with unkown language");
   }
   my $system_dir = $generator_hr->{external_args_hr}->{system_directory};
   my $module_name = $generator_hr->{external_args_hr}->{target_module_name};

   my $file = $system_dir."/".$module_name.$ls;
   &generator_print_verbose("generator library writing string into file: $file\n");

   open (FILE,">$file") or ribbit "cannot open file ($file) ($!)\n";
   print FILE $string;
   close (FILE);
}

return 1;
