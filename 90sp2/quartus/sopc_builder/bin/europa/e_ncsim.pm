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
package e_ncsim;

@ISA = qw(e_simulator);

=head1 NAME

e_ncsim - setup Cadence NCSim HDL simulation environment

=head1 SYNOPSIS

The e_ncsim class implements the SOPC NCSim simulation
interface and takes care of setting up the simulation environment.
It relies on e_simulator as its base class with e_simulator's methods 
defining the API. 

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

$e_ncsim::VERSION = 1.00;


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

=over 3

=cut




=item I<Build_Project()>

Build the NCSim Project. 

=cut


sub Build_Project
{
   my $this = shift;
   &ribbit ("No arguments allowed") if scalar(@_) != 0;
   print STDERR "Building NCSim Project\n";

   my $sim_project_name = $this->get_sim_project_name();
   my $simulation_directory = $this->simulation_directory();
   my $system_directory = $this->system_directory();

   $this->Create_Simulation_Env($simulation_directory);
   $this->Create_Waveform_File($simulation_directory);
   $this->Create_Dat_Files($system_directory, $simulation_directory);

   my $ncsim_exe = $this->get_ncsim_exe();

   Set_External_Command_Visible(0); # run the commands invisibly
   chdir $simulation_directory;
   $this->NCSim_Parse();

   chdir "..";
}




sub NCSim_Parse
{
   my $this = shift;
   &ribbit ("Too many arguments") if @_;
   
   my $hdl_arg;
   my $hdl_cmd;

   if ($this->is_vhdl())
   { 
   	$hdl_arg = " -f ncvhdl.args";
     	$hdl_cmd = "ncvhdl ";
           
   }
   else 
   { 
   	$hdl_arg = " -f ncvlog.args";
        $hdl_cmd = "ncvlog";
   }


   my $result = system("$hdl_cmd$hdl_arg");
   if (!$result) { print "Successfully compiled with $hdl_cmd .. \n";}
   else {die "ERROR: Can't compile with $hdl_cmd. Refer to the $hdl_cmd.log \n";} 


   my $result = system("ncelab -f ncelab.args");    
   if (!$result) { print "Elaboration Complete... \n";
   } else {die "ERROR: Can't Elaborate with NCELAB. Refer to the ncelab.log \n";}

}

=item I<Create_Simulation_Env()>

Setup the simulation environment needed by NCSim to run

=cut


sub Create_Simulation_Env
{
   my $this = shift;
   my $simdir      = shift;
   &ribbit ("Too many arguments") if @_;

   my $comp_cmd;		# Executable for compilation
   my $hdl_comp;		# Name of the compiler argument file
   my $hdlfile = "hdl.var";
   my $cdsfile = "cds.lib";

   if ( $this->is_vhdl() )
   { 
	$hdl_comp = "ncvhdl.args";
	$comp_cmd = "ncvhdl";
   } else { 
  	$hdl_comp = "ncvlog.args";
    	$comp_cmd = "ncvlog";
   }
	  
  open(NC_FILE, ">$simdir/$hdl_comp")
	 or &ribbit ("Can't open ${simdir}/$hdl_comp: $!");

  open(HDL_FILE, ">$simdir/$hdlfile")
	 or &ribbit ("Can't open ${simdir}/$hdlfile: $!");

  open(CDS_FILE, ">$simdir/$cdsfile")
	 or &ribbit ("Can't open ${simdir}/$cdsfile: $!");


  my $WSA = $this->SYS_WSA();
  my $family_name = $WSA->{device_family};
                  
  my $hdlcontents  = "softinclude \${CDS_INST_DIR}/tools/inca/files/hdl.var \n" ;
     $hdlcontents .= "Define WORK work \n";
     $hdlcontents .= "Define VHDL_SUFFIX (.vhd, .vht, .vhdl, .vho) \n";

  my $cdscontents  = "softinclude \${CDS_INST_DIR}/tools/inca/files/cds.lib \n" ;
     $cdscontents .= "Define work ./ncsim_work \n";
     $cdscontents .= "Define altera_vhdl_support  ./ncsim_work \n";
     $cdscontents .= "Define altera_mf_components ./ncsim_work \n";
     $cdscontents .= "Define lpm_components       ./ncsim_work \n";
     $cdscontents .= "Define $family_name         ./ncsim_work \n";
     $cdscontents .= "Define lpm                  ./ncsim_work \n";
     $cdscontents .= "Define altera_mf            ./ncsim_work \n";
     $cdscontents .= "Define sgate_pack           ./ncsim_work \n";
     $cdscontents .= "Define sgate                ./ncsim_work \n";

  print CDS_FILE "$cdscontents";
  print HDL_FILE "$hdlcontents";
       
  close (CDS_FILE);
  close (HDL_FILE);


  &Create_Dir_If_Needed("$simdir/ncsim_work");
  


  my $hdl_file    = $this->hdl_output_filename();      # file name of the target HDL module
  my $s_cmd;	                                       # set the command for compiler argument
  my $init_cmd = $this->initial_ncsim_setup();         # Initial command & files for compiler argument
  print NC_FILE $init_cmd;

  if($this->is_vhdl()) 
  {
      my @vhdl_file_list = $this->get_unique_files("Simulation_HDL_Files");
      my @vhdl_file_list_synth = $this->get_unique_files("Synthesis_HDL_Files");
      map {s|^__PROJECT_DIRECTORY__|..|} @vhdl_file_list_synth;
      map {s|^\./|..\/|} @vhdl_file_list;
      my  $synth_hdl_file;
      foreach $synth_hdl_file ( @vhdl_file_list_synth )
      {
	      my @tmp = grep (/$synth_hdl_file/, @vhdl_file_list);
	      if ( $#tmp  != 0 )
	      {
		      push @vhdl_file_list, $synth_hdl_file;
	      }
      }
      foreach my $vhdl_file(@vhdl_file_list) {$s_cmd .= "$vhdl_file \\\n";}     
  }


  $s_cmd .= $hdl_file; #INCLUDE THE SYSTEM HDL FILE AS THE LAST FILE TO BE ADDED

  print NC_FILE "$s_cmd\n";
  close (NC_FILE);

}



sub initial_ncsim_setup
{
   my $this = shift;
   my $nc_setup;
   my $quartus_sim_dir_location = $this->quartus_simulation_directory();
   my $system_directory = $this->system_directory();

   my $lib_name;

   if ($this->is_vhdl())
   {
	$nc_setup  = "-Messages -Nostdout -Nocopyright -v93 ";
	$nc_setup .= "-smartorder -update -logfile ncvhdl.log -Nowarn DLNCML -Nowarn UNXPCL \\\n";
	$nc_setup .= "$system_directory/altera_vhdl_support.vhd \\\n";
	$nc_setup .= "$quartus_sim_dir_location/altera_mf_components.vhd  \\\n".
        	     "$quartus_sim_dir_location/altera_mf.vhd  \\\n".
                     "$quartus_sim_dir_location/220pack.vhd  \\\n".
                     "$quartus_sim_dir_location/220model.vhd  \\\n".
                     "$quartus_sim_dir_location/sgate_pack.vhd  \\\n".
                     "$quartus_sim_dir_location/sgate.vhd  \\\n";
   } else {
	$nc_setup  = "-Messages -Nostdout -Nocopyright ";
	$nc_setup .= " -update -Nowarn DLNCML -logfile ncvlog.log  \\\n";
	$nc_setup .= "-incdir ..  \\\n";
   }
   return "$nc_setup";
}



=item I<Create_Waveform_File(simulation_directory)>

Traverse the system PTF file and add waveforms to the wave.do file
which will be displayed in the simulation waveform viewer.

=cut


sub Create_Waveform_File
{
  my $this = shift;
  my $simulation_directory = shift;

  &ribbit ("Too many arguments") if @_;

  my $language = $this->_language();
  my $simdir      = $simulation_directory;
  my $hdl_file;	 
  my $bench_top; # Top level of the testbench for VHDL or Verilog Top
  my $SimScope;

  if ($this->is_vhdl() )
  {  
	$SimScope = ":" ; # define seperator for simulation hierarchy scopes
	$bench_top = "";
	$hdl_file = "ncvhdl.args";
  } 
  else 
  { 
	$SimScope = "." ;
	$bench_top = $this->test_bench_name();
	$hdl_file = "ncvlog.args";
  }
	  
  open(ELAB_FILE, ">$simdir/ncelab.args")
     or &ribbit ("Can't open ${simdir}/ncelab.args: $!");

  open(SIM_FILE, ">$simdir/ncsim.args")
     or &ribbit ("Can't open ${simdir}/ncsim.args: $!"); 

  open(WAVEFORM_FILE, ">$simdir/ncsim_input.tcl")
     or &ribbit ("Can't open ${simdir}/ncsim_input.tcl: $!");
  
  

  if ( $this->is_vhdl() )
  {

	print ELAB_FILE (" -Messages -v93 -access +rwc -logfile ncelab.log");
	print ELAB_FILE (" -Nowarn CUDEFB -Nowarn DLNCML -update");
	print ELAB_FILE (" -snapshot testbench work.test_bench:europa \n");
  } else 
  {

	print ELAB_FILE (" -Messages -access +rwc -Nowarn DLNCML -snapshot testbench work.test_bench:module \n");
  }
  close(ELAB_FILE);


  print SIM_FILE (" -Messages -Nowarn DLNCML -logfile ncsim.log");
  print SIM_FILE (" -input ncsim_input.tcl -gui testbench \n");	  
  close(SIM_FILE);


  my $system_shm = $this->system_name().".shm";

  print WAVEFORM_FILE ("alias . run \n") ;
  print WAVEFORM_FILE ("alias x exit \n\n") ;
  print WAVEFORM_FILE (" echo \"Creating Simulation database...\"\n") ;
  print WAVEFORM_FILE ("database -open -shm $system_shm \n");
  print WAVEFORM_FILE ("scope -set [lindex [scope -tops] end] \n");            
      
  my $mod;
  foreach $mod ($this->get_ptf_module_list()) 
  {
	my $mod_name    = $mod->name();
	next if (!$this->signal_display_is_enabled($mod_name) ||
		$this->signal_display_is_empty($mod_name));
	my @signal_display_list = $this->signal_list_for_display($mod_name);
	my $divider_tag = $this->get_divider_tag($mod_name);

	print WAVEFORM_FILE ("\n") ;
	print WAVEFORM_FILE (" echo \"Probing simulation signals for module: $mod_name\" \n") ;

	my $sig_key;
        foreach $sig_key (@signal_display_list) 
	{

		next if $this->signal_display_is_suppressed($mod_name, $sig_key);
		next if ( $this->signal_display_is_conditional($mod_name, $sig_key));
	        my $name = $this->signal_display_name($mod_name, $sig_key);
		my $signal_display_format = $this->signal_display_format($mod_name, $sig_key);

		if($divider_tag eq "") 
		{
			$name =~ s|__FIX_ME_UP__\/|$divider_tag|sg;
		} else 
		{
			$name =~ s|__FIX_ME_UP__|$divider_tag|sg;
		}

		if ( $name =~ m/\// )
		{
			$name =~ s|\/|\.|sg;
	 	}
	 
		if ($this->signal_display_is_conditional($mod_name, $sig_key)) {
			next unless $mod->is_port($name);
   		}

		if ($signal_display_format eq 'divider') {
		} elsif ($signal_display_format eq 'literal') {
		} else 
		{
			my $temp_path = $bench_top.$SimScope."DUT".$SimScope."the_".$mod_name.$SimScope."$name" ;
			print WAVEFORM_FILE "probe -create $temp_path ";
			print WAVEFORM_FILE " -database $system_shm -waveform \n";
		}
		my $signal_radix = $this->signal_display_radix($mod_name, $sig_key);

	}

	close (WAVEFILE);
   }
}


=item I<get_ncsim_exe()>

Returns NCSim's executable, path and all.  If there
is no path to prepend, perhaps because the .sopc_builder is missing
or because there is no sopc_ncsim_dir assignment, then 'vsim' will
be returned, which will work if vsim is in the path.

=cut

sub get_ncsim_exe
{
    my $this        = shift;

    my $sim_dir = $this->{project}->{_sopc_simulator_dir} or
      $this->get_config_file_parameter("sopc_simulator_dir");

    if ($sim_dir ne "") {
      return $sim_dir . "/ncsim";
    }
    return "ncsim";
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
