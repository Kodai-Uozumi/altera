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

s_nios_custom_instruction_master_arbitration_module - description of the module goes here ...

=head1 SYNOPSIS

The s_nios_custom_instruction_master_arbitration_module class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package s_nios_custom_instruction_master_arbitration_module;

use e_ptf_master_arbitration_module;
@ISA = ("e_ptf_master_arbitration_module");
use strict;
use europa_utils;






my %fields   = ();
my %pointers = ();



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
   my $this = shift;
   $this->_update_name();

   $this->make_select_signals();
   $this->make_unary_start_signals();

   $this->SUPER::update(@_);
}
















=item I<make_select_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_select_signals
{
    my $this = shift;

    my $master = $this->_get_master();
    my $master_id = $this->_get_master_id();

    my ($module_name, $master_name) = split(/\//, $master_id);

    my $project = $this->_project() or &ribbit ("no project");

    my $master_cpu_arch = $project->get_nios_cpu_arch($module_name);

    my @slave_ids = 
       $project->get_slaves_by_master_name($module_name, $master_name);

    foreach my $slave_id (@slave_ids) {
        my $slave = $this->_get_slave($slave_id);
        my $base_addr = $project->get_ci_slave_base_addr($slave_id);
        my $select_signal = $this->_make_signal("$slave_id/_select");
        my $slave_cpu_arch = $project->get_ci_slave_cpu_arch($slave_id);

        if ($slave_cpu_arch ne $master_cpu_arch) {
            &ribbit("$slave_id has CPU arch of $slave_cpu_arch but $master_id is $master_cpu_arch");
        }

        if ($slave_cpu_arch eq "nios") {

            my $master_start_port = 
              $master->_get_exclusively_named_port_or_its_complement("start");
            my $master_start_port_for_slave = 
              $master_start_port . "\[$base_addr\]";

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
                e_assign->new([$select_signal, $master_start_port_for_slave])
                  ->within($this);
                next;
            }



            &ribbit(
              "$slave_id thinks it takes $num_cycles cycles, which is crazy.")
              unless $num_cycles > 1;

            my $master_clk_en = 
              $master->_get_exclusively_named_port_or_its_complement("clk_en")
              or &ribbit ("$master_id has no clk_en port");
            my $master_reset_n =
              $master->_get_exclusively_named_port_or_its_complement("reset_n")
              || $this->_get_reset_n();


            my $slave_reset_n = $this->_make_signal("$slave_id/_ci_reset_n");
            my $slave_cycle_counter = 
              $this->_make_signal("$slave_id/_ci_cycle_counter");






            $this->get_and_set_once_by_name ({
                thing     => "assign",
                name      => "$slave_id local reset_n",
                lhs       => [$slave_reset_n, 1],
                rhs       => $master_reset_n,
            });



            my $reg_width = ($num_cycles - 1);
            my @cycle_counter_input = ($master_start_port_for_slave);
            push (@cycle_counter_input, 
              "$slave_cycle_counter [($reg_width-1):1]" ) 
              unless ($reg_width == 1); 
    
            $this->get_and_set_thing_by_name ({
                thing     => "register",
                name      => "$slave_id multicycle counter",
                q         => [$slave_cycle_counter, $reg_width],
                d         => &concatenate (@cycle_counter_input) ,
                enable    => $master_clk_en,
                async_set => $slave_reset_n,
            });

            $this->get_and_set_thing_by_name ({
                  thing => "assign",
                  name  => "$slave_id multicycle select",
                  lhs   => "$select_signal",
                  rhs   => "$master_start_port_for_slave | 
                              (|$slave_cycle_counter)",
            });
        } elsif ($slave_cpu_arch eq "nios2") {

            my $master_n_port = $this->_get_master_port("n", $slave) or
              &ribbit("$master_id has no n port.");
            my $rhs = $project->get_master_ci_slave_decode_expr(
                         $master_id, $master_n_port, [ $slave_id ]);





            $slave->_arbitrator()->sink_signals($select_signal);
            e_signal->add({name => $select_signal, export => 1, width => 1 })
              ->within($this);
            e_assign->new([$select_signal, $rhs])
              ->within($this);
        } else {
            &ribbit("$slave_id has bad CPU architecture of $slave_cpu_arch");
        }
    }
}
















=item I<make_unary_start_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_unary_start_signals
{
    my $this = shift;

    my $master = $this->_get_master();
    my $master_id = $this->_get_master_id();

    my ($module_name, $master_name) = split(/\//, $master_id);

    my $project = $this->_project() or &ribbit ("no project");

    my $master_cpu_arch = $project->get_nios_cpu_arch($module_name);

    my @slave_ids = 
       $project->get_slaves_by_master_name($module_name, $master_name);

    foreach my $slave_id (@slave_ids) {
        my $slave = $this->_get_slave($slave_id);

        my $unary_start_signal = 
          $slave->_arbitrator()->_get_unary_start_signal($master_id);
        my $slave_cpu_arch = $project->get_ci_slave_cpu_arch($slave_id);

        if ($slave_cpu_arch ne $master_cpu_arch) {
            &ribbit("$slave_id was generated for a $slave_cpu_arch CPU but $master_id is $master_cpu_arch");
        }

        if ($slave_cpu_arch eq "nios") {
            my $slave_start_port = 
             $slave->_get_exclusively_named_port_or_its_complement("start");



            next unless $slave_start_port;





            my $base_addr = $project->get_ci_slave_base_addr($slave_id);
            my $master_start_port = 
              $master->_get_exclusively_named_port_or_its_complement("start");
            my $master_start_port_for_slave = 
              $master_start_port . "\[$base_addr\]";

            e_assign->new([$unary_start_signal, $master_start_port_for_slave]) 
              ->within($this);
        } elsif ($slave_cpu_arch eq "nios2") {
            my $slave_inst_type = $project->get_ci_slave_inst_type($slave_id);


            if ($slave_inst_type ne "fixed multicycle" &&
                $slave_inst_type ne "variable multicycle") {
                next;
            }



            my $select_signal = $this->_make_signal("$slave_id/_select");

            my $master_start_port = $this->_get_master_port("start", $slave,
              {required=>1});





            $slave->_arbitrator()->sink_signals($unary_start_signal);
            e_signal->add({name => $unary_start_signal, export => 1, 
              width => 1 }) ->within($this);
            e_assign->new(
              [$unary_start_signal, "$select_signal & $master_start_port"])
              ->within($this);

        } else {
            &ribbit("$slave_id has bad CPU architecture of $slave_cpu_arch");
        }
    }
}




=item I<_get_master_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master_port
{
    my $this = shift;
    my $port_type = shift;
    my $slave = shift;
    my $optional_args = shift;

    my $master_id = $this->_get_master_id();
    my $master = $this->_get_master();

    if (!defined($slave->_arbitrator())) {
        &ribbit("Can't find slave arbitration module for $port_type");
    }

    my $modified_port_type = 
        $slave->_arbitrator()->_create_modified_port_type($port_type);

    my $master_port =
       $master->_get_exclusively_named_port_or_its_complement($port_type) ||
       $master->_get_exclusively_named_port_or_its_complement($modified_port_type);
   
    if ($optional_args && $optional_args->{required} && !$master_port) {
       &ribbit("Master $master_id requires a $port_type or $modified_port_type port");
    }

    return $master_port;
}




=item I<_get_master_id()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master_id
{
    my $this = shift;

    return $this->_get_slave_id();
}



=item I<_get_master()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_master
{
   my $this = shift;
   my $master_id = shift || $this->_get_master_id();

   return $this->SUPER::_get_master($master_id);
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

The inherited class e_ptf_master_arbitration_module

=begin html

<A HREF="e_ptf_master_arbitration_module.html">e_ptf_master_arbitration_module</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
