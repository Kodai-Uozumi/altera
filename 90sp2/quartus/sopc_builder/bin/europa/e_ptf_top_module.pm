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

e_ptf_top_module - based upon e_module ...

=head1 SYNOPSIS

The e_ptf_top_module class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_ptf_top_module;
use e_module;
@ISA = ("e_module");
use strict;
use europa_utils;





my %fields   = ();
my %pointers = ();









=item I<_is_redirected_from_slave()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _is_redirected_from_slave
{
   my $this = shift;
   my $port_name = shift or &ribbit ("no port");

   my $is_redirected_from_slave = 0;

   my @sources = $this->get_signal_sources_by_name
       ($port_name);

   if (@sources == 1)
   {
      my $source = $sources[0];
      if (&is_blessed($source) && $source->isa("e_instance"))
      {
         my $module = $source->module();

         my @mod_sources  = $module->get_signal_sources_by_name
             ($port_name);

         if ($module->isa("e_ptf_slave_arbitration_module") &&
             (@mod_sources == 1)
             )
         {
            my $mod_source = $mod_sources[0];
            if (&is_blessed($mod_source) && 
                $mod_source->isa("e_assign"))
            {
               my $rhs = $mod_source->rhs();
               if ($rhs->isa_signal_name())
               {
                  my $incoming_sig_name = $rhs->expression();
                  if ($module->is_input($incoming_sig_name))
                  {
                     my @incoming_sources = $this->
                         get_signal_sources_by_name($incoming_sig_name);

                     my $comes_from_ptf_module =
                         $this->signal_comes_from_e_ptf_module
                         ($incoming_sig_name);

                     return (1)
                         if ((@incoming_sources == 0) || $comes_from_ptf_module);
                  }
               }
            }
         }
      }
   }
   return (0);
}



=item I<signal_comes_from_e_ptf_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub signal_comes_from_e_ptf_module
{
   my $this = shift;
   my $sig_name = shift;

   my @sources = $this->
       get_signal_sources_by_name($sig_name);

   my $source = $sources[0];
   my $comes_from_ptf_module = 
       (@sources == 1) &&
       $source->isa("e_instance") &&
       $source->module()->isa("e_ptf_module");

   return $comes_from_ptf_module;
}



=item I<signal_goes_to_e_ptf_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub signal_goes_to_e_ptf_module
{
   my $this = shift;
   my $sig_name = shift;

   my @dests = $this->
       get_signal_destinations_by_name($sig_name);

   my $dest = $dests[0];
   my $goes_to_ptf_module = 
       (@dests == 1) &&
       $dest->isa("e_instance") &&
       $dest->module()->isa("e_ptf_module");

   return $goes_to_ptf_module;
}



=item I<wire_defaults()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub wire_defaults
{
   my $this = shift;

   my $project = $this->project();
   my $test_bench_module = $project->test_module();

   foreach my $port ($this->_get_port_names())
   {
      my $sig = $this->get_signal_by_name($port);
      next unless ($sig);

      my $type = $sig->type();
      next unless $type;
      next if ($type eq "export");

      if ($type =~ /^pull/)
      {
        $test_bench_module->get_and_set_once_by_name({
          thing => "pull",
          name  => "$type $port",
          signal => $port,
          pull_type => $type,
        });
        next;
      }
      if ($this->is_output($port))
      {
          if ($type =~ /^out_clk/i)
          {



             $sig->never_export(1);
             next;
          }
          if (($type && $this->signal_comes_from_e_ptf_module($port))
              || $this->_is_redirected_from_slave($port))
          {
             $sig->never_export(1);
             next; 
          }
       }

      if ($this->is_input($port)
          && $type)
      {
         if ($type =~ /^reset/)
         {
            my $ns_period = $this->_get_period();
            $test_bench_module->get_and_set_once_by_name
                ({
                   thing => "reset_gen",
                   name  => "reset gen $port",
                   reset => $port,
                   ns_period => 10 * $ns_period,
                   reset_active => ($type =~ /_n$/) ? 0 : 1,
                });
            next;
         }
         if ($type =~ /^clk((_\w+)?_(\d+)_*(([mk])hz)?)?/i)
         {
            my $freq_number = $3;
            my $multiplier = $5;







            my $clock_source = $project->get_clock_source($port);
            my $clk_name;
            if ($clock_source) {

              $clk_name = $port;
            } else {

              my $parent = $sig->parent_module();
              my @sig_dests = $parent->get_signal_destinations_by_name ($port);
              FIND_PTF_MODULE: foreach my $dest (@sig_dests) {
                next unless $dest->isa("e_instance");
                next unless $dest->module()->isa("e_ptf_module");
                my $mod_name = $dest->module()->name();
                $clk_name = $project->find_clock_domain_by_ptf_module($mod_name);
                last FIND_PTF_MODULE if $clk_name;
              }

              next unless $clk_name;  
              $clock_source =  $project->get_clock_source ($clk_name);
            }


            if ($clock_source =~ /^external$/i) {
              my $ns_period = $this->_get_period
                  ($freq_number, $multiplier, $clk_name);
              $test_bench_module->get_and_set_once_by_name
                  ({
                    thing => "clk_gen",
                    name  => "clk gen $ns_period $port",
                    clk   => $port,
                    ns_period => $ns_period,
                  });
              next;
            }
         }

         if ($this->signal_goes_to_e_ptf_module($port))
         {
            my $default = 0;
            $default = 1 if ($type =~ /\_n$/);

            $this->update_item 
                (
                 e_assign->new
                 ({
                    lhs => $port,
                    rhs => $default,
                    comment => "$port of type $type does not connect to ".
                        "anything so wire it to default ($default)",
                     })
                 );
            next;
         }
      }
   }
}




=item I<get_clock_hash>

returns a hash keyed by clock name.  Value is frequency in Hz.

=cut

sub get_clock_hash
{
   my $this = shift;

   return $this->project()->get_clock_hash();
}



=item I<_get_period(number, multiplier, port_name)>

Return the clock frequency for the port_name.

=cut

sub _get_period
{
   my $this = shift;
   my ($number,$multiplier,$port_name) = @_;

   if ($number)
   {
      if ($multiplier =~ /m/i)
      {
         $number *= 1e6;
      }
      elsif ($multiplier =~ /k/i)
      {
         $number *= 1e3;
      }
   }
   else
   {
      if ($port_name)
      {
         $number = $this->project()->get_clock_frequency($port_name);
         if (!$number)
         {
            $number = $this->project()->get_clock_frequency($port_name);
         }


         if(!$number)
         {
            $number = 333333000;
            warn "unable to determine clock frequency for $port_name\n";
            warn "defaulting to $number\n";
         }
      }
      else #reset case here
      {


         my @clocks = map {
               $_ =~ /CLOCK\s*(\w+)/;
            } keys (%{$this->get_clock_hash()});
         my @clock_freqs = map {
              $this->project()->get_clock_frequency($_);
            } @clocks;
         $number = &min(@clock_freqs) || 33333000;
      }
   }
   my $ns_period = int (1e9/$number + .5);
   return ($ns_period);
}



=item I<_organize_ports_into_named_groups()>

This code organizes the e_ptf_top's ports according to what
internal e_ptf_module they come from.

This code right here used to be the bulk of the code from
e_project::MakeSymbol.

But it has utility beyond mere symbols!

=cut

sub _organize_ports_into_named_groups
{
   my $this = shift;







   my %port_section_hash = ();
   my @sys_port_names = ($this->get_input_names(),
                         $this->get_output_names());

   foreach my $sys_port_name (@sys_port_names) 
   {
      my $port_obj = $this->get_signal_by_name($sys_port_name);



      my @all_connections = 
          ($this->get_signal_sources_by_name($sys_port_name),
           $this->get_signal_destinations_by_name($sys_port_name));

      my @ptf_module_connections = ();

      foreach my $connection (@all_connections) 
      {
         if ($connection->isa("e_ptf_instance"))
         {
            push (@ptf_module_connections, $connection);
         }
         elsif ($connection->isa("e_instance"))
         {

            my $mod = $connection->module();

            if ($mod->isa("e_ptf_arbitration_module"))
            {
               my $ms = $mod->_master_or_slave();
               my $routes_to = $ms->parent_module();
               my $sbi = $routes_to->{SYSTEM_BUILDER_INFO};
               if ((!$sbi->{Instantiate_In_System_Module}) ||
                    ($sbi->{Is_Bridge}))
               {
                  push (@ptf_module_connections, $connection);
               }
            }
         }

         if ($this->project()->language() =~ /vhdl/i)
         {



            if ($connection->isa("e_assign") &&
                $connection->
                get_signal_sources_by_name($sys_port_name)
                )
            {
               my @rhs_sigs = $connection->rhs()->
                 _get_all_signal_names_in_expression();
               if (@rhs_sigs == 1)
               {
                  my $rhs = $rhs_sigs[0];
                  my @rhs_sources = 
                      $this->
                          get_signal_sources_by_name($rhs);

                  if (@rhs_sources == 1)
                  {
                     my $connection = $rhs_sources[0];
                     if ($connection->isa("e_ptf_instance"))
                     {
                        push (@ptf_module_connections,
                              $connection);
                     }
                     elsif ($connection->isa("e_instance"))
                     {
                        my $mod = $connection->module();

                        if ($mod->isa("e_ptf_arbitration_module"))
                        {
                           my $ms = $mod->_master_or_slave();
                           my $routes_to = $ms->parent_module();
                           my $sbi = $routes_to->{SYSTEM_BUILDER_INFO};
                           if ((!$sbi->{Instantiate_In_System_Module}) ||
                               ($sbi->{Is_Bridge}))
                           {
                              push (@ptf_module_connections, $connection);
                           }
                        }
                     }
                  }
               }
            }
         }
      }












      if (($sys_port_name eq "reset_n") || 
          ($port_obj->type() =~ /^clk/) ||
          ($port_obj->type() =~ /^out_clk/) ) 
      {
         push (@ptf_module_connections, 1,2,3,4);
      }

      if (!@ptf_module_connections)
      {
         print STDERR "Warning: " . 
             "suspicious signal '$sys_port_name' at system top ",
             "level.\n";
      }



      if (scalar(@ptf_module_connections) == 1)
      {
         my $home_instance = shift (@ptf_module_connections);
         my $section_name = $home_instance->name();
         push (@{$port_section_hash{$section_name}}, $port_obj);
      } else {
         push (@{$port_section_hash{"1) global signals:"}}, $port_obj);
      }
   }
   return \%port_section_hash;
}



=item I<make_reset_synchronizer()>

Construct the reset synchronizer. Asynchronously asserted and synchronously
deasserted behaviour.

=cut

sub make_reset_synchronizer
{
  my $this = shift;
  my ($clock, $reset_for_clock_domain) = @_;

  if ( ($this->project()->asic_enabled()) && ($this->project()->asic_add_scan_mode_input()) ){

    my $comment_string = "reset is asserted asynchronously and deasserted synchronously\n";
    $comment_string .= "Use normal_reset_n signal for normal mode reset. Then use scan_mode to mux reset_n and normal_reset_n";

    if ($this->get_and_set_once_by_name({
      thing => 'synchronizer',
      comment => $comment_string,
      name =>  $this->name() . "_reset_${clock}_domain_synch",
      port_map => {
       clk   =>  $clock,
       data_out    => "normal_reset_n",
       data_in     => "1'b1",
       reset_n  => "scan_mode ? reset_n : reset_n_sources"
      },
    }))
    {
      $this->make_reset_n_sources_mux(0);
      e_assign->new({
        comment => "Add scan_mode to switch normal and scan mode resets",
        lhs => $reset_for_clock_domain,
        rhs => "scan_mode ? reset_n : normal_reset_n",
      })->within($this);


      foreach my $module (keys %{$this->project()->spaceless_system_ptf()->{MODULE}}) {
        if ( $this->project()->spaceless_system_ptf()->{MODULE}->{$module}->{class} eq "altera_nios2" ) {

          e_assign->new({
            comment => "scan_mode to switch normal and scan mode resets",
            lhs => "clrn_to_the_$module",
            rhs => "scan_mode ? reset_n : normal_clrn_to_the_$module",
          })->within($this);
        } elsif ( $this->project()->spaceless_system_ptf()->{MODULE}->{$module}->{class} eq "altera_avalon_jtag_uart" ) {

          e_assign->new({
            comment => "scan_mode to switch normal and scan mode resets",
            lhs => "clrn_to_the_$module",
            rhs => "scan_mode ? reset_n : normal_clrn_to_the_$module",
          })->within($this);
        }
      }
    }

  } else {
    if ($this->get_and_set_once_by_name({
      thing => 'synchronizer',
      comment => "reset is asserted asynchronously and deasserted synchronously",
      name =>  $this->name() . "_reset_${clock}_domain_synch",
      suppress_da => [qw(R101)],
      port_map => {
       clk   =>  $clock,
       data_out    => "$reset_for_clock_domain",
       data_in     => "1'b1",
       reset_n  => "reset_n_sources"
      },
    }))
    {
      $this->make_reset_n_sources_mux(0);
    }
  }
}

sub make_reset_n_sources_mux
{
  my $this = shift;
  my $resetrequest = shift;


   if ($this->get_and_set_once_by_name
       ({
          thing  => "mux",
          name   => "reset sources mux",
          lhs    => "~reset_n_sources",
          type   => "and_or",
          add_table => ["~reset_n", "~reset_n"],
       }))
   {

      e_signal->new({
         name => 'reset_n',
         type => 'reset_n',
      })->within($this);
   }

   if ($resetrequest ne '')
   {
      $this->get_and_set_thing_by_name
       ({
          thing  => "mux",
          name   => "reset sources mux",
          add_table => [$resetrequest,
                        $resetrequest]
       });
   }
}













{
my $exclusive_namers = undef;
sub exclusive_namers_sort
{
  if (!defined $exclusive_namers)
  {
    ribbit("Internal error: " .
      "failed to initialize exclusive_namers cache before sorting contents\n");
  }






  my $a_module = $a->can("__module_name") ? $a->__module_name() : "";
  my $b_module = $b->can("__module_name") ? $b->__module_name() : "";

  my $a_is_a_slave = 0;
  if (
    $a->can("_module_ref") &&
    $a->_module_ref()->can("_master_or_slave")
  )
  {
    if (!$a->_module_ref()->_master_or_slave()->isa("e_ptf_master"))
    {
      $a_is_a_slave = 1;
    }
  }
  my $b_is_a_slave = 0;
  if (
    $b->can("_module_ref") &&
    $b->_module_ref()->can("_master_or_slave")
  )
  {
    if (!$b->_module_ref()->_master_or_slave()->isa("e_ptf_master"))
    {
      $b_is_a_slave = 1;
    }
  }

  my $akey = (grep {$a_module eq $_} @$exclusive_namers) ? 1 : 0;
  my $bkey = (grep {$b_module eq $_} @$exclusive_namers) ? 1 : 0;

  return 
    ($akey <=> $bkey) || 
    ($b_is_a_slave <=> $a_is_a_slave) || 
    ($a_module cmp $b_module);
}

sub _find_exclusive_namers
{
  return scalar @{$exclusive_namers} if (defined $exclusive_namers);
  $exclusive_namers = [];

  my %exclusive_namers_hash = ();




  my $this = shift;
  my $sys_ptf = $this->_project()->system_ptf();
  for my $module (keys %$sys_ptf)
  {
    next if ($module !~ /^MODULE (\S+)/);
    my $component_name = $1;

    my $mod_ptf = $sys_ptf->{$module};
    my $exc;
    if (
      $mod_ptf->{SIMULATION} &&
      $mod_ptf->{SIMULATION}->{PORT_WIRING} &&
      $mod_ptf->{SIMULATION}->{PORT_WIRING}->{"PORT reset_n"} &&
      ($exc = $mod_ptf->{SIMULATION}->{PORT_WIRING}->{"PORT reset_n"}->{__exclusive_name}) &&
      $exc eq 'reset_n')
    {

      $exclusive_namers_hash{$component_name} = 1;
      {
        my $proj;
        my $mod;


        if(($proj = $this->_project()) &&
          ($mod = $proj->get_module_by_name($component_name)))
        {
          for my $interface_type (qw(MASTER SLAVE))
          {
            for my $interface_name (sort keys %{$mod->{$interface_type}})
            {
              my $arb_module_name = $component_name . "_" . $interface_name;
              $exclusive_namers_hash{$arb_module_name} = 1;
            }
          }
        }
      }
    }
  }

  push @$exclusive_namers, sort keys %exclusive_namers_hash;
}
}


sub sort_contents_by_exclusive_namers
{
  my $this  = shift;



  $this->_find_exclusive_namers();
  
  my $contents = $this->_contents();
  $this->_contents([
    sort exclusive_namers_sort @$contents
  ]);
}

sub update
{
  my $this = shift;



  if ($this->_find_exclusive_namers())
  {
    $this->sort_contents_by_exclusive_namers();
  }

  $this->SUPER::update(@_);
}

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
