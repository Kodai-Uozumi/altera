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

e_test_module - description of the module goes here ...

=head1 SYNOPSIS

The e_test_module class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_test_module;
use e_module;
use europa_utils;

@ISA = ("e_module");
use strict;







my %fields = (
              export_no_signals   => 0,
              add_user_comments   => 1,
              );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<get_internal_signal_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_internal_signal_names
{
   my $this = shift;
   if ($this->export_no_signals())
   {

      return $this->get_signal_names();
   }
   else
   {
      return $this->SUPER::get_internal_signal_names();
   }
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


  if ( ($this->_project()->asic_enabled()) && ($this->_project()->asic_skip_top_level_testbench()) ){
    my $project = $this->_project();
    my $vs = "\n //skip generation of top level testbench\n\n";
    push (@{$project->module_pool()->{verilog}},$vs);
    return;
  }

  my $sys_dir = quotemeta($this->_project()->_system_directory());
  







  my $user_include_code = $this->print_user_code();
  my $vs = $this->_make_verilog_string();
  

  my @included_files = map {s/$sys_dir[\\\/]//sg; $_;}
    $this->_project()->_get_unique_sim_hdl_files();
    
  












   my $my_pli_funny_business;
   $my_pli_funny_business .= "// If user logic components use Altsync_Ram with convert_hex2ver.dll,\n";
   $my_pli_funny_business .= "// set USE_convert_hex2ver in the user comments section above\n\n";
   $my_pli_funny_business .= "// `ifdef USE_convert_hex2ver\n";
   $my_pli_funny_business .= "// `else\n";
   $my_pli_funny_business .= "// `define NO_PLI 1\n";
   $my_pli_funny_business .= "// `endif\n";

  my $project = $this->_project();
  my $quartus_sim_dir_location = $project->_sopc_quartus_dir(). '/eda/sim_lib';

  unshift (@included_files, 
           "$quartus_sim_dir_location/altera_mf.v",
           "$quartus_sim_dir_location/220model.v",
           "$quartus_sim_dir_location/sgate.v"
           );

   my $vs = join ("\n",
                  "//". $this->_project()->_translate_off,
                  "",
                  $user_include_code,
		  $my_pli_funny_business,



                  (map {/\.vh.*$/ ? "\/\/ $_" : "\`include \"$_\""} @included_files),

                  "",
                  $this->project->_get_timescale_directive
                     ("no translate_off"),
                  $vs,
                  "//".$this->project()->_translate_on);

  push (@{$project->module_pool()->{verilog}},$vs);
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

   my $vs = join ("\n","--".$this->_project->_translate_off,
      "",
      $this->_vhdl_make_string(),
      "",
                  "--".$this->_project->_translate_on."\n");

   push (@{$this->_project()->module_pool()->{vhdl}},$vs);
}



=item I<is_output()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub is_output
{
  my $this = shift;

  if ($this->export_no_signals())
  {
    return 0;
  }
  else
  {
    return ($this->SUPER::is_output(@_));
  }
}



=item I<is_input()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub is_input
{
    my $this = shift;
    if ($this->export_no_signals())
    {
      return 0;
    }
    else
    {
      return ($this->SUPER::is_input(@_));
    }
}







=item I<to_ptf()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_ptf
{
  my $this = shift;

  return if ($this->export_no_signals()); #no signals going out mean,

  my $ptf_section = 
      $this->module_ptf()->{SIMULATION}{INSTANTIATIONS};

  $ptf_section->{PORT_WIRING} = {} ;# unless $ptf_section->{PORT_WIRING};
  
  foreach my $port_name ($this->get_port_names()) 
  {
     my $sig_object = $this->get_signal_by_name ($port_name)
         or &ribbit ("port '$port_name' cannot be found.");

    $sig_object->add_to_ptf_section ($ptf_section->{PORT_WIRING});
  }
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

The inherited class e_module

=begin html

<A HREF="e_module.html">e_module</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
