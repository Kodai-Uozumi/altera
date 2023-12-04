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

s_nios_custom_instruction_slave_arbitration_module - description of the module goes here ...

=head1 SYNOPSIS

The s_nios_custom_instruction_slave_arbitration_module class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package s_nios_custom_instruction_slave_arbitration_module;

use e_ptf_arbitration_module;
@ISA = ("e_ptf_arbitration_module");
use strict;
use europa_utils;

our $force_export = 1;  # Just used to make signal declarations more readable.




my %fields   = ();
my %pointers = ();





=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
   my $this = shift;



   my $slave_id = $this->_get_slave_id();

   my $slave_SBI         = $this->_master_or_slave()->{SYSTEM_BUILDER_INFO};
   my $master_ref        = $slave_SBI->{MASTERED_BY};

   my @master_ids = (keys %$master_ref) 
       or return; #return if nobody masters me.


   (@master_ids == 1) or &ribbit ("multiple masters (", 
                               join (",",@master_ids),
                               ") master $slave_id");

   my $master_id = $master_ids[0];
   my $master_module = $this->_get_master_module($master_id);
   my $master        = $this->_get_master($master_id);

   foreach my $port (@{$this->_master_or_slave()->_ports()})
   {
      my $type = $port->type() or next;

      next if $type eq "export";
      next if $port->_isa_global_signal();
      next if $this->_type_needs_special_care($type);





      
      $this->_do_generic_wiring($master_id,$port);
   }

   $this->_special_care($master_id);

   $this->SUPER::update();
}





=item I<_do_generic_wiring()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _do_generic_wiring
{
   my $this = shift;
   my ($master_id,$port) = @_;

   my $port_type = $port->type();
   my $master_port = $this->_get_master_port($port_type, $master_id);
   my $slave_port  = $port->_exclusive_name();


   e_assign->new([$slave_port,$master_port])
       ->within($this);
}






=item I<_create_modified_port_type()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _create_modified_port_type
{
   my $this = shift;
   my $port_type = shift;

   my $project = $this->_project() or &ribbit ("no project");
   my $slave_id = $this->_get_slave_id();
   my $slave_inst_type = $project->get_ci_slave_inst_type($slave_id);

   my $modified_port_type;

   if ($slave_inst_type eq "combinatorial") {
      $modified_port_type = "combo_" . $port_type;
   } elsif ($slave_inst_type eq "fixed multicycle" ||
            $slave_inst_type eq "variable multicycle") {
      $modified_port_type = "multi_" . $port_type;
   } else {
      &ribbit("$slave_id has bad slave instruction type of $slave_inst_type");
   }

   return $modified_port_type;
}




=item I<_get_master_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master_port
{
    my $this = shift;
    my $port_type = shift;
    my $master_id = shift;
    my $optional_args = shift;

    my $master = $this->_get_master($master_id);
    my $modified_port_type = $this->_create_modified_port_type($port_type);

    my $master_port =
       $master->_get_exclusively_named_port_or_its_complement($port_type) ||
       $master->_get_exclusively_named_port_or_its_complement(
         $modified_port_type);
   
    if ($optional_args && $optional_args->{required} && !$master_port) {
       &ribbit(
         "Master $master_id requires a $port_type or $modified_port_type port");
    }

    return $master_port;
}



=item I<_type_needs_special_care()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _type_needs_special_care
{
   my $this = shift;
   my $type = shift
    or &goldfish("Unable to determine type of port:".$this->{name}."\n");

   my $ret = 0;

   $ret = 1 if ($type =~ /^result$/i);
   $ret = 1 if ($type =~ /^done(_n)?$/i);
   $ret = 1 if ($type =~ /^fixed_done(_n)?$/i);
   $ret = 1 if ($type =~ /^start(_n)?$/i);
   $ret = 1 if ($type =~ /^reset(_n)?$/i);
   
   return $ret;
}



=item I<_special_care()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _special_care
{
   my $this = shift;
   my $master_id = shift;

   $this->_handle_start_port($master_id);
   $this->_handle_result_port($master_id);
   $this->_handle_done_port($master_id);
   $this->_handle_fixed_done_port($master_id);
   $this->_handle_reset_port($master_id);
}





=item I<_handle_start_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_start_port
{
   my $this = shift;
   my $master_id = shift;

   my $slave = $this->_get_slave();
   my $slave_start_port = 
     $slave->_get_exclusively_named_port_or_its_complement("start");

   if (!$slave_start_port) {

      return;
   }

   my $unary_start_signal = $this->_get_unary_start_signal($master_id) or
     &ribbit("Slave " . $this->_get_slave_id() .
      " missing its unary start port");

   e_assign->new([$slave_start_port, $unary_start_signal])
     ->within($this);
}





=item I<_handle_result_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_result_port
{
   my $this = shift;
   my $master_id = shift;

   my $slave_id = $this->_get_slave_id();
   my $select_signal = $this->_make_signal("$slave_id/_select");
   my $port_type = "result";
   my $master_port = $this->_get_master_port($port_type, $master_id, 
     {required=>1});
   my $slave = $this->_get_slave();
   my $slave_port = 
     $slave->_get_exclusively_named_port_or_its_complement($port_type) or
       &ribbit("$slave_id has no $port_type port");

   my $master = $this->_get_master($master_id);
   my $master_arbitrator = $master->_arbitrator();



   $master_arbitrator->get_and_set_thing_by_name
       ({
          thing => "mux",
          name  => "$master_port mux",
          lhs   => $master_port,
          add_table_ref => [$select_signal => $slave_port],
          type  => "and_or",
       });
}











=item I<_handle_done_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_done_port
{
   my $this = shift;
   my $master_id = shift;

   my $slave_id = $this->_get_slave_id();
   my $project = $this->_project() or &ribbit ("no project");


   if ($project->get_ci_slave_cpu_arch($slave_id) eq "nios") { return };

   my $master = $this->_get_master($master_id);
   my $master_arbitrator = $master->_arbitrator();
   my $select_signal = $this->_make_signal("$slave_id/_select");
   my $slave = $this->_get_slave();
   my $slave_done_port = 
     $slave->_get_exclusively_named_port_or_its_complement("done");

   my $ci_inst_type = $project->get_ci_slave_inst_type($slave_id);
   if ($ci_inst_type eq "combinatorial") {
       if ($slave_done_port) {
            &ribbit("Slave " . $this->_get_slave_id() .
              " can't have a done port because it is combinatorial");
       }
       return;
   }

   my $master_done_port = $this->_get_master_port("done", $master_id, 
     {required=>1});
   my $modified_done_type = $this->_create_modified_port_type("done");

   if ($ci_inst_type eq "fixed multicycle") {


       if ($slave_done_port) {
            &ribbit("Slave " . $this->_get_slave_id(). 
              " can't have a done port because it is fixed multicycle");
       }

       my $unary_start_signal = $this->_get_unary_start_signal($master_id) ||
         &ribbit("$slave_id missing its unary start port");


       $slave_done_port = $this->_make_signal("$slave_id/done");

       my $master_clk_en = $this->_get_master_port("clk_en", $master_id, 
         {required=>1});
       my $slave_reset_n = $this->_get_reset_n();

       my $num_cycles;


       my $slave_module_WSA =
         $slave->parent_module()->{WIZARD_SCRIPT_ARGUMENTS};
       if ($slave_module_WSA) {
           $num_cycles = $slave_module_WSA->{ci_cycles};
       }

       if (!defined($num_cycles)) {
           my $slave_SBI = $slave->{SYSTEM_BUILDER_INFO} or
              &ribbit ("$slave_id has no SYSTEM_BUILDER_INFO section.");
           $num_cycles = $slave_SBI->{ci_cycles};
       }

       if (!defined($num_cycles)) {
           &ribbit ("$slave_id has no idea how many cycles it takes.");
       }

       if ($num_cycles == 1) {

            $this->get_and_set_once_by_name ({
                thing     => "assign",
                name      => "$slave_id done assign",
                lhs       => [$slave_done_port, 1, $force_export],
                rhs       => $unary_start_signal,
            });
       } elsif ($num_cycles == 2) {

            $this->get_and_set_once_by_name ({
                thing     => "register",
                name      => "$slave_id done delay",
                q         => [$slave_done_port, 1, $force_export],
                d         => $unary_start_signal,
                enable    => $master_clk_en,
                async_set => $slave_reset_n,
            });
       } else {


            my $start_cnt = $num_cycles - 2;
            my $cnt_sz = Bits_To_Encode($start_cnt);

            my $done_counter_output = 
              $this->_make_signal("$master_id/_ci_done_counter");
            my $counter_active_output = 
              $this->_make_signal("$master_id/_ci_counter_active");



            $this->get_and_set_once_by_name ({
                thing     => "register",
                name      => "$slave_id active",
                q         => [$counter_active_output, 1],
                d         => "$unary_start_signal ? 
                                1'b1 : 
                                ($counter_active_output & ~$slave_done_port)",
                enable    => "$master_clk_en",
                async_set => $slave_reset_n,
            });
            



            $this->get_and_set_once_by_name ({
                thing     => "register",
                name      => "$slave_id done counter",
                q         => [$done_counter_output, $cnt_sz],
                d         => 
                  "$unary_start_signal ? $start_cnt : $done_counter_output-1",
                enable    => "$master_clk_en & 
                                ($unary_start_signal | $counter_active_output)",
                async_set => $slave_reset_n,
                async_value => $start_cnt,
            });
            

            $this->get_and_set_once_by_name ({
                  thing => "assign",
                  name  => "ci done zero detect",
                  lhs   => ["$slave_done_port", 1, $force_export],
                  rhs   => "$done_counter_output == 0",
            });
       }
   } elsif ($ci_inst_type eq "variable multicycle") {


       if (!$slave_done_port) {
            &ribbit(
              "$slave_id needs a done port because it is variable multicycle");
       }
   } else {
       &ribbit("Bad custom instruction type $ci_inst_type for $slave_id");
   }


   $master_arbitrator->get_and_set_thing_by_name
       ({
          thing => "mux",
          name  => "$modified_done_type mux",
          lhs   => $master_done_port,
          add_table_ref => [$select_signal => $slave_done_port],
          type  => "and_or",
       });
}







=item I<_handle_fixed_done_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_fixed_done_port
{
   my $this = shift;
   my $master_id = shift;

   my $slave = $this->_get_slave();
   my $slave_id = $this->_get_slave_id();
   my $project = $this->_project() or &ribbit ("no project");


   if ($project->get_ci_slave_cpu_arch($slave_id) eq "nios") { return };

   my $slave_fixed_done_port = 
     $slave->_get_exclusively_named_port_or_its_complement("fixed_done");
   
   if (!$slave_fixed_done_port) { return; }

   my $ci_inst_type = $project->get_ci_slave_inst_type($slave_id);
   if ($ci_inst_type ne "fixed multicycle") {
       &ribbit("Slave " . $this->_get_slave_id() .
          " can't have a fixed_done port because it isn't fixed multicycle");
   }


   my $slave_done_port = $this->_make_signal("$slave_id/done");

   e_assign->new([$slave_fixed_done_port,$slave_done_port])
       ->within($this);
}



=item I<_handle_reset_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_reset_port
{
   my $this = shift;
   my $master_id = shift;


   my $global_reset_n = $this->_get_reset_n();
   my $slave_reset_n_rhs = $global_reset_n;

   my $master = $this->_get_master($master_id);



   foreach my $port (@{$master->_ports()}) {
      if ($port->type eq "reset" || $port->type eq "reset_n") {

         my $port_name = $port->_exclusive_name();         
         if ($port->type eq "reset") {
            $port_name = &complement($port_name);
         }

         if ($port->is_input()) {

            $master->_arbitrator()->get_and_set_once_by_name ({
                thing     => "assign",
                name      => "$port_name local reset_n",
                lhs       => $port_name,
                rhs       => $global_reset_n,
            });
         } else {

            $slave_reset_n_rhs = $port_name;
         }
      }
   }

   my $slave_id = $this->_get_slave_id();
   my $slave = $this->_get_slave();
   my $slave_reset_n =
      $slave->_get_exclusively_named_port_or_its_complement("reset_n");

   if ($slave_reset_n) {
      $this->get_and_set_once_by_name ({
         thing     => "assign",
         name      => "$slave_id local reset_n",
         lhs       => $slave_reset_n,
         rhs       => $slave_reset_n_rhs,
      });
   }
}



=item I<_get_unary_start_signal()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_unary_start_signal
{
   my $this = shift;
   my $master_id = shift or &ribbit ("no md");
   my $master      = $this->_get_master($master_id);
   my $slave_id = $this->_get_slave_id();

   return 
     $this->_get_generic_master_slave_signal_name($master_id, "start",
       $slave_id);
}



=item I<_get_generic_master_slave_signal_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_generic_master_slave_signal_name
{
   my $this = shift;
   my $master_id = shift or &ribbit ("no master desc");
   my $identity = shift or &ribbit ("no id");
   my $slave_id = shift or &ribbit ("no slave id");

   return ($this->_make_signal("$master_id/$identity/$slave_id"));
}



=item I<_get_master_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master_module
{
   my $this = shift;
   my $master_id = shift;

   my ($module_name, $master_name) = split (/\//, $master_id);

   $module_name or &ribbit ("$master_id has no module name");

   my $project = $this->_project() or &ribbit ("no project");

   my $master_module = $project->get_module_by_name($module_name) or 
       &ribbit ("($project), known modules include ",
                join ("\n", keys (%{$project->module_hash()})),
                "\n",
                $this->name(),
                " no master module declared for $module_name\n"
                );

   return ($master_module);
}



=item I<_get_master()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master
{
   my $this = shift;
   my $master_id = shift;

   my ($module_name, $master_name) = split (/\//, $master_id);

   $module_name or &ribbit ("$master_id doesn't have a module name");

   my $master_module = $this->_get_master_module($master_id);

   my $master = $master_module->get_object_by_name($master_name)
       or &ribbit ("No master could be found for $master_id. ".
                   "Known names include ",
                   $master_module->get_object_names(),"\n");

   return ($master);
}



=item I<_get_slave()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_slave
{
   my $this = shift;
   my $slave_id = shift || $this->_get_slave_id();

   return $this->SUPER::_get_slave($slave_id);
}



=item I<_get_reset_n()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_reset_n
{
    my $this = shift;

    return "reset_n";
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

The inherited class e_ptf_arbitration_module

=begin html

<A HREF="e_ptf_arbitration_module.html">e_ptf_arbitration_module</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
