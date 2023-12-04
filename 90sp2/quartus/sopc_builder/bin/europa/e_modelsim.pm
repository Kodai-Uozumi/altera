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
package e_modelsim;

@ISA = qw(e_simulator);

=head1 NAME

e_modelsim - setup Modelsim HDL simulation environment

=head1 SYNOPSIS

The e_modelsim class implements the SOPC modelsim simulation
interface and takes care of setting up the simulation environment.
It relies on e_simulator as its base class with e_simulator's methods 
defining the API. Each simulator has its own class wrapper 
around e_simulator and e_modelsim is just one such implementation.

=cut

use strict;
use mk_bsf;
use e_ptf;
use filename_utils;
use format_conversion_utils;
use run_system_command_utils;
use print_command;
use e_simulator;
use europa_utils;
use europa_vhdl_library;

$e_modelsim::VERSION = 1.00;


my %fields = (
              project   => {},
              );

my %pointers = (
               );

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );

=head1 METHODS

=over 4

=cut




=item I<Build_Project()>

Build the Modelsim Project.  This method performs all the Modelsim project
setup procedures required to simulate the  SOPC Builder generated system design.
Among other things, we check that ModelSim is properly installed on your system
and print an error if it is not.
Next we call a series of methods which do the following.  First, we create the
waveform display script wave.do which sets up the signals to display in the
simulation based on signals tagged for display in the system PTF file.
Second, we create simulator setup_sim.do script which is the primary TCL script
providing the command interface and control of the simulation environment.
Third, we create simulator startup modelsim.tcl script
which simply calls setup_sim.do. Last, we create the data files for
the initializing the memories from the MIF files.
Finally, we initialize the actual ModelSim project by creating a TCL script
which invokes the 'project' command.  This script is now run in the ModelSim
vsim executable. We are now ready to run the simulation.
That completes the setup and we return.

=cut


sub Build_Project
{
   my $this = shift;
   &ribbit ("No arguments allowed") if scalar(@_) != 0;
   print STDERR "Building ModelSim Project\n";

   my $sim_project_name = $this->get_sim_project_name();
   my $simulation_directory = $this->simulation_directory();
   my $system_directory = $this->system_directory();

   $this->Create_Waveform_File($simulation_directory);
   $this->Create_Simulator_Do_File($simulation_directory);
   $this->Create_Simulator_Startup_File($simulation_directory);
   $this->Create_Dat_Files($system_directory, $simulation_directory);






   my @modelsim_commands = ("project new . $sim_project_name work",
			    "quit -f"
			   );
   my $do_filename = "create_" . $this->system_name() . "_project.do";
   open  (DOFILE, ">$simulation_directory/$do_filename")
       or &ribbit ("can't open $simulation_directory/$do_filename: $!");
   print  DOFILE join ("\n", @modelsim_commands);
   close (DOFILE);



   my $vsim_exe = $this->get_vsim_exe();
   my $vsim_cmd = $vsim_exe . " -c -do $do_filename";

   Set_External_Command_Visible(0); # run the commands invisibly
   chdir $simulation_directory;
   system($vsim_cmd);

   chdir "..";
}


=item I<Create_Waveform_File(simulation_directory)>

Traverse the system PTF file and add waveforms to the wave.do file
which will be displayed in the simulaion waveform viewer.

=cut


sub Create_Waveform_File
{
   my $this = shift;
   my $simulation_directory = shift;

   &ribbit ("Too many arguments") if @_;

   my $do_filename = "virtuals.do";

   open  (DOFILE, ">$simulation_directory/$do_filename")
       or &ribbit ("can't open $simulation_directory/$do_filename: $!");

   my @module_list = $this->get_ptf_module_list();
   my @modelsim_commands = $this->get_sim_commands();

   print DOFILE join ("\n", @modelsim_commands);
   print DOFILE "\n";

   close (DOFILE);



   my $wave_filename = "wave_presets.do";
   my $list_filename = "list_presets.do";

   open  (WAVEFILE, ">$simulation_directory/$wave_filename")
       or &ribbit ("can't open $simulation_directory/$wave_filename: $!");
   open  (LISTFILE, ">$simulation_directory/$list_filename")
       or &ribbit ("can't open $simulation_directory/$list_filename: $!");

   my @wave_do_cmds;
   my $wave_do_cmd;

   my @list_do_cmds;
   push(@list_do_cmds, "onerr {resume}");
   push(@list_do_cmds, "add list -bin /test_bench/clk");

   foreach my $mod (@module_list) {
      my $mod_name    = $mod->name();

      next if (!$this->signal_display_is_enabled($mod_name) ||
	       $this->signal_display_is_empty($mod_name));

      push (@wave_do_cmds, "# Display signals from module $mod_name");
      push (@wave_do_cmds, "add wave -noupdate -divider {$mod_name}");

      my $divider_tag = $this->get_divider_tag($mod_name);

      my @signal_display_list = $this->signal_list_for_display($mod_name);
      foreach my $sig_key (@signal_display_list) {
	 my $name = $this->signal_display_name($mod_name, $sig_key);

	 if($divider_tag eq "") {
	   $name =~ s|__FIX_ME_UP__\/|$divider_tag|sg;
	 } else {
	   $name =~ s|__FIX_ME_UP__|$divider_tag|sg;
	 }

	 my $radix = $this->signal_display_radix($mod_name, $sig_key);
	 my $format = $this->signal_display_format($mod_name, $sig_key);
	 $format = "Literal" if !$format && $radix;
	 $format = "Logic"   if !$format;

         my $list_radix = $radix;
         $list_radix = 'binary' unless $list_radix;
         $list_radix =~ s/^(...).*/$1/;



	 if ($this->signal_display_is_conditional($mod_name, $sig_key)) {
	   next unless $mod->is_port($name);
	 }




	 next if $this->signal_display_is_suppressed($mod_name, $sig_key);



         $wave_do_cmd = "add wave -noupdate";

         if ($format =~ /divider/i) {
            $wave_do_cmd .= " -divider \{$name\}";
         } else {
            $wave_do_cmd .= " -format $format";
            $wave_do_cmd .= " -radix $radix" if $radix;
            $wave_do_cmd .= " /test_bench/DUT/the_$mod_name/$name";

            push(@list_do_cmds, "add list -$list_radix /test_bench/DUT/the_$mod_name/$name");
         }
         push (@wave_do_cmds, $wave_do_cmd);
      }
      push (@wave_do_cmds, "\n");
   }

   push (@wave_do_cmds, "configure wave -justifyvalue right");
   push (@wave_do_cmds, "configure wave -signalnamewidth 1");
   push (@wave_do_cmds, "TreeUpdate [SetDefaultTree]");

   push(@list_do_cmds, "configure list -usestrobe 0");
   push(@list_do_cmds, "configure list -strobestart {0 ps} -strobeperiod {0 ps}");
   push(@list_do_cmds, "configure list -delta none");
   push(@list_do_cmds, "configure list -usegating 1");
   push(@list_do_cmds, "configure list -gateexpr { /test_bench/clk'rising }");


   print WAVEFILE join("\n", @wave_do_cmds);
   print LISTFILE join("\n", @list_do_cmds);

   close (WAVEFILE);
   close (LISTFILE);
}












sub initial_modelsim_setup_string {
   my $this = shift;

   my $both_setup;
   my $oem_setup;
   my $full_setup;

   my $quartus_sim_dir_location = $this->quartus_simulation_directory();

   my $quartus_vhdl_altera_directory = $this->quartus_vhdl_altera_directory();

   my $system_directory = $this->system_directory();

   if ($this->is_vhdl()) {
      my @vmap_libraries = qw(
        altera 
        stratixiv_hssi 
        arriaii_hssi
        stratixiv_pcie_hip
        arriaii_pcie_hip
      );
      my $vmap_string = join("\n", 
        map {
          sprintf("%svmap %s%swork", (' ' x 23), $_, (' ' x (21 - length($_))))
        } @vmap_libraries
      );
      $both_setup .= "vlib work\n$vmap_string";

      $oem_setup .= qq[
                       vcom -93 -explicit $quartus_vhdl_altera_directory/altera_europa_support_lib.vhd
		       ];
      $full_setup .= qq[
                       vmap lpm                  work
                       vmap altera_mf            work
                       vmap sgate_pack           work
                       vmap sgate                work
                       vmap stratixiigx_hssi     work
                       vmap arriagx_hssi         work
                       vmap stratixgx_hssi       work
                       vmap altgxb_lib           work
                       vcom -93 -explicit $quartus_vhdl_altera_directory/altera_europa_support_lib.vhd
                       vcom -93 -explicit $quartus_sim_dir_location/altera_mf_components.vhd
                       vcom -93 -explicit $quartus_sim_dir_location/altera_mf.vhd
                       vcom -93 -explicit $quartus_sim_dir_location/220pack.vhd
                       vcom -93 -explicit $quartus_sim_dir_location/220model.vhd
                       vcom -93 -explicit $quartus_sim_dir_location/sgate_pack.vhd
                       vcom -93 -explicit $quartus_sim_dir_location/sgate.vhd
                       ];
   } else {
      my $simulation_directory  = $this->simulation_directory();

      $full_setup = qq[
                       vmap lpm_ver       work
                       vmap altera        work
                       vmap altera_mf_ver work
                       vmap sgate_ver     work
                       ];
   }
   $full_setup = "alias _init_setup {$both_setup$full_setup}";
   $oem_setup  = "alias _init_setup {$both_setup$oem_setup}";   

   my $is_oem = _is_oem_modelsim_version();
   return
       _pe_vs_oem_version_comment() .
       "if { $is_oem } {".
       "\n $oem_setup } else {".
       "\n $full_setup } \n\n";
}

sub _is_oem_modelsim_version
{
  return '[ string match "*ModelSim ALTERA*" [ vsim -version ] ]';
}

sub _pe_vs_oem_version_comment
{
  return 
  "\n# ModelSimPE and OEM have different requirements".
  "\n# regarding how they simulate their test bench.".
  "\n# We account for that here.\n";
}



=item I<Create_Simulator_Do_File(simulation_directory)>

Create the Modelsim setup_sim.do script file which sets up the simulation.

=cut

sub Create_Simulator_Do_File {
    my $this = shift;
    my $simulation_directory =shift;

    &ribbit ("Too many arguments") if @_;

    my $proj = $this->{project};
    my $do_filename = "setup_sim.do";

    open  (DOFILE, ">$simulation_directory/$do_filename")
      or &ribbit ("can't open $simulation_directory/$do_filename: $!");

    my $sopc_hdl_file = $this->hdl_output_filename();
    my $sopc_hdl_file_nopath = $this->target_module_name();
    my $test_bench_name  = $this->test_bench_name();
    my $sopc_dir = $this->sopc_directory();

    my $TCL_CODE = <<TCL_SIM;
    set sopc "$sopc_dir"
    set sopc_perl "$ENV{SOPC_PERL}"
    echo "Sopc_Builder Directory: \$sopc";
TCL_SIM

    my @sim_library_file_list = $this->get_unique_files
        ("Precompiled_Simulation_Library_Files");

    my @vmapped_sim_library_list;
    my @compiled_sim_library_list;

    my @modified_sim_library_file_list;

    my $vmapped_sim_libraries;
    my $compiled_sim_libraries;
    my $library_name;


    my $init_cmd = $this->initial_modelsim_setup_string();
    my $s_cmd;
    my $vsim_alias;

    my @sim_library_name_list = $this->get_unique_files("Simulation_Library_Names");

    foreach my $library_name (@sim_library_name_list)
    {
      &ribbit("VHDL library list contains \"work\" which is already used by the project!\n")
	  if $library_name =~ /^work$/i;
      push(@vmapped_sim_library_list, "vmap $library_name work\n");
    }

    if($this->is_vhdl())
    {

      my @vhdl_sim_source_files = $this->get_unique_files("Simulation_HDL_Files");

      foreach my $vhdl_sim_source_file_and_path(@vhdl_sim_source_files)
      {
        my $vhdl_sim_source_file;
        $vhdl_sim_source_file_and_path =~ /^.*\/(.*)$/;

        $vhdl_sim_source_file = $1;

        if($vhdl_sim_source_file eq "altera_mf_components.vhd")
        {
	  push(@vmapped_sim_library_list,
	       "vmap altera_mf_components work\n",
	       "vmap altera_mf work\n"
 	     );
        }
        elsif($vhdl_sim_source_file eq "220pack.vhd")
        {
	  push(@vmapped_sim_library_list,
	       "vmap LPM_COMPONENTS work\n"
	      );
        }
      }
      foreach my $vhdl_sim_library_and_path (@sim_library_file_list)
      {
         push(@compiled_sim_library_list, "vcom -93 -explicit $vhdl_sim_library_and_path -force_refresh\n");
      }
      $vmapped_sim_libraries = join("", @vmapped_sim_library_list);
      $compiled_sim_libraries = join("", @compiled_sim_library_list);



















      my @hdl_file_list = ($this->_get_unique_sim_hdl_files(), $sopc_hdl_file);
      map {s|^\./|../|} @hdl_file_list;

     $s_cmd .= "_init_setup\n"; #defined in initial_modelsim_setup_string
     $s_cmd .= $vmapped_sim_libraries;
     $s_cmd .= $compiled_sim_libraries;


      foreach (@hdl_file_list) 
      {
	if (/\.vhdl?$/ || /\.vho$/) {
	  $s_cmd .= "vcom -93 -explicit $_\n";
	} else {
	  $s_cmd .= "vlog +incdir+.. $_\n";
	}
      }
      $s_cmd .= "_vsim\n";
      $s_cmd .= "do virtuals.do\n";
      $s_cmd .= "set StdArithNoWarnings 1\n";

      $vsim_alias = $this->vsim_alias($test_bench_name);
    }
    elsif($this->is_verilog())
    {
      my $Lf;
      my $vhdl_entity_included;

      foreach my $verilog_sim_library_and_path (@sim_library_file_list)
      {
	push (@compiled_sim_library_list, "vlog $verilog_sim_library_and_path  -refresh;");
	$verilog_sim_library_and_path =~ /(\w+)\.v$/;
	$library_name = $1;
	my $library_file_name = $1 . ".v";
	push(@modified_sim_library_file_list, $library_name);
	push(@vmapped_sim_library_list, "vmap $library_name work\n");
      }
      my $Lf = " -Lf ".join(" -Lf ",@modified_sim_library_file_list)." "
         if (@modified_sim_library_file_list);
      my $compiled_sim_libraries = join("",@compiled_sim_library_list)
         if(@compiled_sim_library_list);
      my $vmapped_sim_libraries = join("",@vmapped_sim_library_list)
         if(@vmapped_sim_library_list);

      my @pli_files = $this->get_unique_files("PLI_Files");
      my $pli = "-pli ".join(" -pli",@pli_files)." "
         if (@pli_files);

      my @inc_files = $this->get_unique_files("ModelSim_Inc_Path");
      push @inc_files, "..";
      my $inc = join(" ", map {"+incdir+$_"} @inc_files) if @inc_files;

      my @hdl_file_list = ($this->_get_unique_sim_hdl_files(), $sopc_hdl_file);
      map {s|^\./|../|} @hdl_file_list;

      $s_cmd .= "vlib work;\n";
      $s_cmd .= "_init_setup\n";


      foreach (@hdl_file_list)
      {
	if (/\.vhdl?$/ || /\.vho$/) {
	  $s_cmd .= "vcom -93 -explicit $_\n";
	  $vhdl_entity_included = 1;
	}
      }
      if ($vhdl_entity_included) 
      {
	$s_cmd .= "set StdArithNoWarnings 1\n";
      }
      $s_cmd .= "$vmapped_sim_libraries \n";
      $s_cmd .= "$compiled_sim_libraries \n";
      $s_cmd .= "vlog $inc ../$sopc_hdl_file_nopath.v;\n";
      $s_cmd .= "_vsim;\n";
      $s_cmd .= "do virtuals.do\n";

      $vsim_alias = $this->vsim_alias("$Lf$pli$test_bench_name");
   }
   else
   {
      &ribbit ("unknown HDL language");
   }
   print DOFILE $TCL_CODE;
   print DOFILE $init_cmd;
   print DOFILE $vsim_alias;









   if ($this->SYS_WSA()->{do_modelsim_list})
   {
      print DOFILE "alias writelist \"write list -events modelsim_list.list\"\n";
      $s_cmd .= "; do modelsim_list.do";
   }

   print DOFILE
     "alias test_contents_files {" .
       "if {[ file exists \"contents_file_warning.txt\" ]} { " .
         "set ch [open \"contents_file_warning.txt\" r];  " .
         "while { 1 } { " .
           "if ([eof \$ch]) {break}; " .
           "gets \$ch line; " .
           "puts \$line; " .
         "}; ".
         "close \$ch; " .
       "} " .
     "}\n";

   $s_cmd .= "; test_contents_files";

   print DOFILE "alias s \"$s_cmd\"\n";
   my $gen_script_name = $this->system_name()."_generation_script";


   my $sopc_dir = "\$sopc";
   my $sopc_perl = "\$sopc_perl";
   my $r_cmd  = "exec $sopc_perl/bin/perl";
      $r_cmd .= " -I $sopc_dir/bin/perl_lib";
      $r_cmd .= " -I $sopc_dir/bin";
      $r_cmd .= " $sopc_dir/bin/run_command_in_unix_like_shell.pl";
      $r_cmd .= " $sopc_dir {";
      $r_cmd .= " cd ../"."; ";
      $r_cmd .= " ./$gen_script_name ";
      $r_cmd .= " } ";

   print DOFILE "alias r \"$r_cmd\"\n";


   print DOFILE "alias c \"echo {Regenerating memory contents.\n (This may take a moment)...}; restart -f; $r_cmd --software_only=1\"\n";


   print DOFILE "alias w \"do wave_presets.do\"\n";


   print DOFILE "alias l \"do list_presets.do\"\n";


   my @alias_help = ();
   my @aliases = ();
   my $alias_name = "";
   my $OS = $^O;
   my $bat_filename = "";
   my @bat_io_files = ();
   my $bat_exe = "";
   my $bat_win = "";

   my @module_list = $this->get_ptf_module_list();

   foreach my $mod (@module_list) {
      my $mod_name    = $mod->name();
      my $int_section = $this->interactive_simulation_IO($mod_name, "output");

      foreach my $int_key (sort(keys (%{$int_section}))) {
         my $this_int_section = $int_section->{$int_key};
         my $enabled = $this_int_section->{enable};

         my @exe = split(/ /,$this_int_section->{exe});
         if ($enabled) {
            $bat_filename = $mod_name."_".$int_key.".bat";
            @bat_io_files = ( # go get list of files to be I/O
               $mod_name.$this_int_section->{file},

            );


            $bat_exe = $this_int_section->{exe};
            if ($OS =~ /win/i) {  # match 'MSWin32' or 'cygwin'
               $bat_win = 
                   "\@ start \"$bat_io_files[$#bat_io_files]\" cmd /t:06 /c";
               $bat_exe = "%1%/".$bat_exe if ($exe[0] eq "perl");
            } else {
               $bat_win =
                   "xterm -T $mod_name -n $mod_name -fg yellow -bg black -e";
               $bat_exe = "\$1/".$bat_exe if ($exe[0] eq "perl");
            }
            open (BATFILE, ">$simulation_directory/$bat_filename")
               or &ribbit ("can't open $simulation_directory/$bat_filename: $!");
            print BATFILE "$bat_win $bat_exe @bat_io_files\n";
            close (BATFILE);

            if (0 == (chmod 0755,"$simulation_directory/$bat_filename")) {
                &goldfish ("can't set execute mode on $simulation_directory/$bat_filename");
            }

            $alias_name = $mod_name."_".$int_key;
            push (@aliases,
                  "alias $alias_name \"./$bat_filename \$sopc_perl/bin &\"\n");
            push (@alias_help,
                  "echo @@   $alias_name  -- display interactive output window for $mod_name\n");
         }
      }

      my $int_section = $this->interactive_simulation_IO($mod_name, "input");
      foreach my $int_key (sort(keys (%{$int_section})))
      {
         my $this_int_section = $int_section->{$int_key};
         my $enabled = $this_int_section->{enable};

         my @exe = split (/ /,$this_int_section->{exe});
         my $bat_win_name;
         if ($enabled)
         {
            $bat_filename = $mod_name."_".$int_key.".bat";
            @bat_io_files = ( # go get list of files to be I/O
               $mod_name.$this_int_section->{mutex},
               $mod_name.$this_int_section->{file},
               $mod_name.$this_int_section->{log},

            );


            $bat_exe = $this_int_section->{exe};
            if ($bat_exe =~ /nios2-terminal/)
            {  # be special:
                @bat_io_files = ();
                $bat_win_name = $bat_exe;
            }
            else
            {
                $bat_win_name = $bat_io_files[$#bat_io_files];
            }
            if ($OS =~ /win/i)
            {  # match 'MSWin32' or 'cygwin'
               $bat_win = 
                   "\@ start \"$bat_win_name\" cmd /t:02 /c";
               $bat_exe = "%1%/".$bat_exe if ($exe[0] eq "perl");
            }
            else
            {
               $bat_win =
                   "xterm -T $mod_name -n $mod_name -fg green -bg black -e";
               $bat_exe = "\$1/".$bat_exe if ($exe[0] eq "perl");
            }
            open (BATFILE, ">$simulation_directory/$bat_filename")
               or &ribbit ("can't open $simulation_directory/$bat_filename: $!");
            print BATFILE "$bat_win $bat_exe @bat_io_files\n";
            close (BATFILE);

            if (0 == (chmod 0755,"$simulation_directory/$bat_filename")) {
                &goldfish ("can't set execute mode on $simulation_directory/$bat_filename");
            }

            $alias_name = $mod_name."_".$int_key;
            push (@aliases,
                  "alias $alias_name \"./$bat_filename \$sopc_perl/bin &\"\n");
            push (@alias_help,
                  "echo @@   $alias_name  -- display interactive input window for $mod_name\n");
         }
      }
   }

   print DOFILE "@aliases";


   print DOFILE <<END_OF_DOFILE_HELP;
alias h \"
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@
echo @@        $do_filename
echo @@
echo @@   Defined aliases:
echo @@
echo @@   s  -- Load all design (HDL) files.
echo @@           re-vlog/re-vcom and re-vsim the design.
echo @@
echo @@   c  -- Re-compile memory contents.
echo @@          Builds C- and assembly-language programs
echo @@          (and associated simulation data-files
echo @@          such as UART simulation strings) for
echo @@          refreshing memory contents.
echo @@          Does NOT re-generate hardware (HDL) files
echo @@          ONLY WORKS WITH LEGACY SDK (Not the Nios IDE)
echo @@
echo @@   w  -- Sets-up waveforms for this design
echo @@          Each SOPC-Builder component may have
echo @@          signals 'marked' for display during
echo @@          simulation.  This command opens a wave-
echo @@          window containing all such signals.
echo @@
echo @@   l  -- Sets-up list waveforms for this design
echo @@          Each SOPC-Builder component may have
echo @@          signals 'marked' for listing during
echo @@          simulation.  This command opens a list-
echo @@          window containing all such signals.
echo @@
END_OF_DOFILE_HELP

   print DOFILE "@alias_help\necho @@\n" if (@alias_help);
   print DOFILE "echo @@   h  -- print this message \n";
   print DOFILE "echo @@\n";

   if($this->is_vhdl()) {
     print DOFILE "echo @@ ***Special VHDL settings***\n";
     print DOFILE "echo @@    StdArithNoWarnings=1 in s command\n";
   }
   print DOFILE "echo @@\"\n";


   print DOFILE "\nh\n";

   close (DOFILE);
}



=item I<Create_Simulator_Startup_File(simulation_directory)>

Create the modelsim.tcl startup file which simply calls the setup_sim.do script.
We check whether this file already exists, and if so we donnot overwrite it.

=cut

sub Create_Simulator_Startup_File {
   my $this = shift;
   my $simulation_directory = shift;
   &ribbit ("Too many arguments") if @_;

   my $startup_filename = "modelsim.tcl";


   return if -e "$simulation_directory/$startup_filename";
   open  (DOFILE, ">$simulation_directory/$startup_filename")
       or &ribbit ("can't open $simulation_directory/$startup_filename: $!");
   print DOFILE "do setup_sim.do\n";
   close (DOFILE);
}


=item I<vsim_alias()>

Alias the ModelSim vsim command to account for whether we have an OEM or
a ModelSimPE license.  The startup command is slightly different and we
hide that here.

=cut

sub vsim_alias {
   my $this = shift;
   my $test_bench_name = shift;

   my @libs = $this->get_libraries();

   my $oem_string = join (' -L ', '', @libs);


   my $prefix_vsim_command = 'alias _vsim {vsim -t ps +nowarnTFMPC ';

   my $oem_vsim_command = $prefix_vsim_command .
                          $oem_string .
                          " " .
                          $test_bench_name .
                          ' } ';
   my $full_vsim_command = $prefix_vsim_command .
                           $test_bench_name .
                           ' } ';
   my $is_oem = _is_oem_modelsim_version();
   return
       _pe_vs_oem_version_comment() .
       "if { $is_oem } {".
       "\n $oem_vsim_command } else {".
       "\n $full_vsim_command } \n\n";
}


=item I<get_vsim_exe()>

Returns modelsim's vsim executable, path and all.  If there
is no path to prepend, perhaps because the .sopc_builder is missing
or because there is no sopc_modelsim_dir assignment, then 'vsim' will
be returned, which will work if vsim is in the path.

=cut

sub get_vsim_exe
{
    my $this        = shift;

    my $modelsim_dir = $this->{project}->{_sopc_modelsim_dir} or
      $this->get_config_file_parameter("sopc_modelsim_dir");

    if ($modelsim_dir ne "") {
      return $modelsim_dir . "/vsim";
    }
    return "vsim";
}


=back

=cut

=head1 SEE ALSO

The inherited class e_simulator

=begin html

<A HREF="e_simulator.html">e_simulator</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation

=cut

1;
