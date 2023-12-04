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

e_ptf_slave - description of the module goes here ...

=head1 SYNOPSIS

The e_ptf_slave class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_ptf_slave;

@ISA = ("e_thing_that_can_go_in_a_module");
use strict;
use europa_utils;
use e_instance;

use e_ptf_arbitration_module;
use s_known_bus_arbitrators;

use e_ptf_port;






my %fields = (
              _AUTOLOAD_ACCEPT_ALL => 1,
              _ports => [],
              _ports_by_type => {},
              );

my %pointers = (
                _arbitrator => e_ptf_arbitration_module->dummy(),
                );

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<new()>

Object constructor

=cut

sub new
{
   my $this  = shift;
   my $self = $this->SUPER::new(@_);

   $self->_add_ports();

   $self->_set_arbitration_module();
   return $self;
}



=item I<_set_arbitration_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _set_arbitration_module
{
   my $this = shift;
   my $slave_SBI  = $this->{SYSTEM_BUILDER_INFO};

   if (!exists($slave_SBI->{Is_Enabled}))
   {
     $slave_SBI->{Is_Enabled} = 1;
   }
   return if (!$slave_SBI->{Is_Enabled});

   if (!$slave_SBI->{Do_Not_Generate})
   {
      my $bus_type = $this->{SYSTEM_BUILDER_INFO}{Bus_Type} || "avalon";
      $bus_type =~ tr/A-Z/a-z/;

      &goldfish ("obsolete bus type: $bus_type") if $bus_type =~ /^altera/i;

      my $arb_name = e_ptf_arbitration_module->_make_signal
          ($this->parent_module()->name().'/'.$this->name());
      my $string = join ("_",
                         "s", #s for sopc
                         $bus_type,
                         $this->isa("e_ptf_master") ? "master":"slave",
                         "arbitration_module"
                         );

      my $project = $this->project();
      my $arbitrator =$string->new
                         ({
                            name => $arb_name,
                            _master_or_slave => $this,
                            project => $project,
                         });
      $this->_arbitrator($arbitrator);

      if ($bus_type !~ /tristate/)
      {
         my $top = $project->top();
         if (!(&is_blessed ($top) &&
               $top->isa("e_module"))) 
         {
            &ribbit ("confused");
         }
         $arbitrator->sink_signals('clk','reset_n');

         e_instance->new ({module => $arbitrator,
                          port_map => {clk => $this->clock(),
                                       reset_n => $this->reset_n()},
                        })->within($top);
      }
   }


}



=item I<_add_ports()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _add_ports
{
   my $this = shift;


   if (($this->{SYSTEM_BUILDER_INFO}{Is_Enabled} ne '0')
       && (exists ($this->{PORT_WIRING}{PORT}))
      )
   {
      my $project = $this->project();
      foreach my $port_hash ($this->ptf_to_hashes
                             ($this->{PORT_WIRING}{PORT})
                             )
      {
         $port_hash->{parent} = $this;
         $port_hash->{project} = $project;




         next if  ($port_hash->{Is_Enabled} eq '0');

         my $new_port = e_ptf_port->new($port_hash);

         $new_port->_master_or_slave($this);
         $new_port->parent($this);

         push (@{$this->_ports()},$new_port);

         my $type = $new_port->type();
         $this->_ports_by_type()->{$type} = $new_port
             if ($type);
      }
   }
}



=item I<_bus_type()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _bus_type
{
   my $this = shift;
   my $sbi = $this->{SYSTEM_BUILDER_INFO};
   return $sbi->{Bus_Type};
}



=item I<is_adapter()>

Is this an adapter?  It is if it says it is (Is_Adapter) or if it's a test
adapter (Is_Test_Adapter).  Is_Test_Adapter is for use by adapter-like
components which can be manually added, but which are not subject to other
rules that adapters obey (like being automatically deleted and reinserted by
SOPC Builder).

=cut

sub is_adapter
{
   my $this = shift;
   return $this->parent_module()->is_adapter();
}



=item I<_where_should_i_put_stuff()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _where_should_i_put_stuff
{
   my $this = shift;
   my $sbi = $this->{SYSTEM_BUILDER_INFO};

   my $here = $this->_arbitrator();
   if ($sbi->{Bus_Type} =~ /tristate/)
   {
      my @masters = keys (%{$sbi->{MASTERED_BY}});
      my $pm_name = $this->parent_module()->name();
      ribbit ($pm_name."/".$this->name()," 
              is of type tristate which may only be ",
              "mastered by one master")
          if (@masters > 1);

      my $master_desc = $masters[0];
      my ($master_module,$master_name) = split
          (/\//, $master_desc);
      
      my $master = $this->_arbitrator()->_get_master
          ($master_desc);
      my $master_sbi = $master->{SYSTEM_BUILDER_INFO};
      my $slave_name = $master_sbi->{Bridges_To};

      if ($slave_name)
      {
         $here = $this->_arbitrator()->_get_slave
             ("$master_module/$slave_name")->_arbitrator();
      }
   }
   return ($here);
}



=item I<_get_port_or_its_complement()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_port_or_its_complement
{
  my $this = shift;
   my $type = shift or &ribbit ("no type");
   my $port = $this->_ports_by_type()->{$type};

   my $negate_port;
   if (!$port)
   {
      $negate_port = 1;
      if ($type =~ s/\_n$//)
      {
         $port = $this->
             _ports_by_type()->{$type};
      }
      else
      {
         $port = $this->
             _ports_by_type()->{$type."_n"};
      }
   }
  return ($port,$negate_port);
}



=item I<_get_exclusively_named_port_or_its_complement()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_exclusively_named_port_or_its_complement
{
   my $this = shift;
   my $type = shift or &ribbit ("no type");
   my $hash = shift;

   my $shorten = $hash->{shorten};

   my ($port,$negate_port) = 
       $this->_get_port_or_its_complement ($type);

   my $return_this;
   if ($port)
   {
      my $port_name  = $port->_exclusive_name(); 
      my $port_width = $port->width(); 

      $return_this = $port_name;
      $return_this = &complement($return_this)
          if ($negate_port);




      my $complement_type = $type;
      unless ($complement_type =~ s/_n$//)
      {
         $complement_type .= "_n";
      }

      my $where_to_put_stuff = 
          $this->_where_should_i_put_stuff();

      if ($port->_is_inout() 

        )
      {
         e_signal->new({name  => $return_this, 
                        width => $port_width,
                        copied => 1,
                        _is_inout => 1,
                     })
             ->within($where_to_put_stuff);
         return ($return_this) ;
      }
      if ($this->isa("e_ptf_master"))
      {
         e_signal->new([$return_this, $port_width, 0,0,1])
            ->within($where_to_put_stuff);
         my $module_is_in_system_module = eval ( 
              $this->parent_module()->
                {SYSTEM_BUILDER_INFO}{Instantiate_In_System_Module});
         if (!($module_is_in_system_module) && $port->is_output())  {
            $where_to_put_stuff->sink_signals($return_this);
         }
         return ($return_this) ;
      }

      my $export = 0;
      my $registered = 0;

      my $register_incoming_signals =
          $where_to_put_stuff->_master_or_slave()
              ->{SYSTEM_BUILDER_INFO}{Register_Incoming_Signals};

      my $register_outgoing_signals =
          $where_to_put_stuff->_master_or_slave()
              ->{SYSTEM_BUILDER_INFO}{Register_Outgoing_Signals};




      if($port->is_output()) #output from slave means input to arbitrator
      {
         my $across_bridge = ($where_to_put_stuff ne
                              $this->_arbitrator());

         if ($hash->{register_slave_outputs_across_bridge} &&
                 ($across_bridge))
         {
            my $out = "d1_$port_name";
            $where_to_put_stuff->get_and_set_once_by_name
                ({
                   thing  => "register",
                   async_value  => ($negate_port ?  "1" : "0"),
                   name   => "first $type $return_this register",
                   in     => [$port_name, $port->width(), 0, 0, 1],
                   out    => [$out, $port->width, 0, 0, 1],
                   enable => 1,
                   fast_in => $hash->{fast_in} || 0,
                });
            $out = &complement($out)
                if ($negate_port);
            $return_this = $out;
         }
         else 
         {
            my $out = "${port_name}_from_sa";
            $where_to_put_stuff->get_and_set_once_by_name
                ({
                   thing => "assign",
                   name  => "assign $out = $port_name so that symbol knows where to ".
                       "group signals which may go to master only",
                   lhs   => {name   => $out, 
                             width  => $port_width,
                             copied => 1,
                             type   => $type},
                       
                   rhs => [$port_name, $port_width],
                });

            $out = &complement($out)
                if ($negate_port);
            $return_this = $out;
         }
      }
      else #port is output from arbitrator to slave
      {
         if ($where_to_put_stuff ne $this->_arbitrator())
         {
            $return_this = "p1_".$port_name;
            $return_this = &complement($return_this)
                if ($negate_port);



         }

         foreach my $other_port (@{$this->_ports()})
         {
            $export = 0;
            next unless $other_port->is_input();



            my $lhs = "";
            $lhs = $other_port->_exclusive_name() if ($type eq
                                                $other_port->type());
            $lhs = &complement($other_port->_exclusive_name())
                if ($complement_type eq $other_port->type());

            next if ($lhs eq $return_this);

            if ($lhs)
            {
               if (($where_to_put_stuff ne $this->_arbitrator()) &&
                   $register_outgoing_signals)
               {
                  my $name = "$lhs of type $type to $return_this";
                  if ($shorten)
                  {
                     my $lhs_local = "${lhs}_local";
                     my $shortened_mask = "${lhs}_mask";
                     $where_to_put_stuff->get_and_set_once_by_name
                         ({
                            name  => "shortening pos_edge $name",
                            thing => "register",
                            enable => 1,
                            in    => $return_this,
                            out   => $lhs_local,
                         });

                     $where_to_put_stuff->get_and_set_once_by_name
                         ({
                            name  => "shortening neg_edge $name",
                            thing => "register",
                            clock_level => 0,
                            enable => 1,
                            in    => $lhs_local,
                            out   => $shortened_mask, 
                         });

                     $where_to_put_stuff->get_and_set_once_by_name
                         ({
                            name  => "shortening assignment $name",
                            thing => "assign",
                            lhs   => "$lhs",
                            rhs   => &and_array
                                ($lhs_local,&complement($shortened_mask)),
                         });

                     $where_to_put_stuff->add_contents
                         (
                          e_signal->news([$shortened_mask,1],
                                         [$lhs_local,1])
                          );
                  }
                  else
                  {
                     $where_to_put_stuff->get_and_set_once_by_name
                         ({
                            name  => $name,
                            thing => "register",
                            out   => $lhs,
                            in    => $return_this,
                            enable => 1,
                            fast_out => 1,
                         });
                  }
               }
               else
               {

                  next if ($lhs eq $return_this); 

                  if ($where_to_put_stuff->get_and_set_once_by_name
                      ({
                         name  => "assign lhs $lhs of type $type to $return_this",
                         thing => "assign",
                         lhs   => $lhs,
                         rhs   => $return_this,
                      })
                      )
                  {

                     $export = 1;
                  }
               }
               e_signal->new([$lhs, $other_port->width(), 0, 0, 1])
                             ->within($where_to_put_stuff);
            }
            if ($export)
            {
               my ($other_port,$negate) =
                   $this->_get_port_or_its_complement
                       ($type) or &ribbit 
                           ("could not find port of type $type $return_this");

               e_signal->new([$other_port->_exclusive_name(),
                              $other_port->width(),
                              1,0,0]
                             )->within($where_to_put_stuff);
            }
         }
      }
      e_signal->new([$return_this, $port->width(),0,0,1])
        ->within($where_to_put_stuff);
      return ($return_this);
   }
   else
   {
      return "";
   }
}



=item I<_get_exclusively_named_port_by_type()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_exclusively_named_port_by_type
{
   my $this = shift;
   return ($this->_get_exclusively_named_port_or_its_complement(@_));
}



=item I<_get_port_name_by_type()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_port_name_by_type
{
   my $this = shift;
   my $type = shift or &ribbit ("no type");

   my $complement_type = $type;
   unless ($complement_type =~ s/_n$//)
   {
      $complement_type .= "_n";
   }

   my $port = $this->_ports_by_type()->{$type};
   my $complement = 0;
   unless ($port)
   {
      $port = $this->_ports_by_type()->{$complement_type};
      $complement = 1;
   }

   if ($port)
   {
      my $port_name = $port->name();
      if ($complement)
      {
         return (&complement($port_name));
      }
      else
      {
         return ($port_name);
      }
   }
   else
   {
      return;
   }
}



=item I<project()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub project
{
   my $this = shift;
   my $arb_module = $this->_arbitrator();
   $arb_module->project(@_)
       unless ($arb_module->isa_dummy());
   return ($this->SUPER::project(@_));
}



=item I<make_memory_model()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_memory_model
{
   my $this = shift;
   my $sbi = $this->{SYSTEM_BUILDER_INFO};

   my $outputenable = $this->_get_port_name_by_type("outputenable");
   my $byteenable   = $this->_get_port_name_by_type("byteenable");
   my $select       = $this->_get_port_name_by_type("chipselect");
   my $address      = $this->_get_port_name_by_type("address");
   my $write        = $this->_get_port_name_by_type("write");
   my $read         = $this->_get_port_name_by_type("read");
   my $data         = $this->_get_port_name_by_type("data");
   my $clk          = $this->_get_port_name_by_type("clk");

   my $pm = $this->parent_module();

   $data && $address && ($write || $read)
       or return; #no point in continuing.

   my $data_width = $this->SYSTEM_BUILDER_INFO()->{Data_Width};
       
   my $tmp_data_width = $data_width;

   my $address_e_signal = $this->_ports_by_type()->{address};
                  
                  
   my @reverse_msbs;
   while ($tmp_data_width)
   {
      push (@reverse_msbs, $tmp_data_width - 1);
      $tmp_data_width = $tmp_data_width - 8;
   }

   my $index;
   my @msbs = reverse (@reverse_msbs);
   my $lsb = 0;
   my $project = $pm->project();

   my $Read_Latency = $sbi->{Read_Latency} || 0;

   my @q_array;
   e_signal->new([logic_vector_gasket => $data_width])->within ($pm);
   e_assign->new
       ({lhs => "logic_vector_gasket", 
         rhs => $data,
         tag => "simulation",
      })->within($pm);
      
   foreach my $i (0..(scalar(@reverse_msbs) - 1))
   {
      my $msb = $msbs[$i];
      e_assign->new({lhs => ["data_$i" => 8],
                     rhs => "logic_vector_gasket\[$msb:$lsb]",
                     tag => "simulation",
                     })->within($pm);

      e_signal->new(["q_$i" => 8])
       ->within($pm);

      unshift (@q_array,"q_$i");

      my $pm_name = $pm->name();



      my $basename = (@reverse_msbs > 1) ? "${pm_name}_lane$i" : "${pm_name}";
      my $ram = e_ram->new({
         name         => "${pm_name}_lane$i",
         mif_file     => $basename . ".mif",
         dat_file     => $basename . ".dat",
         Read_Latency => $Read_Latency,
         tag          => "simulation",
      })->within($this->parent_module());

      my $wren;
      my @wrenlist = ($select, $write);
      my @selectlist = ($select);
      if ($byteenable)
      {

         push @wrenlist, "$byteenable\[$i\]";
         push (@selectlist, "$byteenable\[$i\]");
      }
      $wren = &and_array(@wrenlist);
      



      my $wrclock = ($clk)? $clk : (&complement($write));
      



      my $wren = ($clk)? 
        &and_array(@wrenlist) : &and_array(@selectlist);
  
      $ram->port_map
          (
           wren      => $wren,
           data      => "data_$i",
           q         => "q_$i",
           wrclock   => $wrclock,
           wraddress => "$address",
           rdaddress => "$address",
           );



      $lsb = $msb + 1;
   }

   my $oe = $outputenable || $read;
   e_assign->new({lhs => $data, 
                  rhs => &and_array($select, $oe).
                      "? ".&concatenate(@q_array).
                          ": \{$data_width\{1\'bz\}\}",
                  tag => "simulation",        
                  })->within($pm);
}



=item I<get_id()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_id
{
  my $this = shift;
  my $parent_name = $this->parent_module()->name()  
    or &ribbit ("slave/master parent has no name");
  my $name = $this->name()  
    or &ribbit ("slave/master has no name");
  return $parent_name . "/" . $name;
}




=item I<is_bridge()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub is_bridge
{
   my $this = shift;

   my $return_value = $this->{SYSTEM_BUILDER_INFO}{Bridges_To};
   return ($return_value);

}



=item I<to_esf()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_esf
{
  my $this = shift;
  my $return_hash = shift;

  foreach my $slave_port (@{$this->_ports()}) {
    $slave_port->to_esf($return_hash);
  }
  return ($return_hash);
}



=item I<clock_source>

returns the name of the clock source associated with the slave.
=cut

sub clock_source
{
   my $this = shift;
   return $this->{SYSTEM_BUILDER_INFO}{Clock_Source} || $this->parent()->clock_source();
}



=item I<get_clock_hash>

returns a hash keyed by clock name.  Value is frequency in Hz.
=cut

sub get_clock_hash
{
   my $this = shift;
   return $this->parent()->get_clock_hash(@_);
}



=item I<get_clock_frequency>

returns a hash keyed by clock name.  Value is frequency in Hz.
=cut

sub get_clock_frequency
{
   my $this = shift;
   return $this->parent()->get_clock_frequency(@_);
}



=item I<clock()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub clock
{
   my $this = shift;
   my $sbi = $this->{SYSTEM_BUILDER_INFO};

   my $parent = $this->parent_module();
   my $clock_source = $parent->augment_clock_name($sbi->{Clock_Source}) ||
   $parent->clock();

   if (!$clock_source)
   {
      &ribbit ($this->get_id()."no clock source found");
   }

   return $clock_source;
}



=item I<reset()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub reset
{
   my $this = shift;
   return $this->clock()."_reset";
}



=item I<reset_n()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub reset_n
{
   my $this = shift;
   return $this->reset()."_n";
}



=item I<get_tcl_commands>

Just descends to the ports and calls get_tcl_commands on them.

=cut

sub get_tcl_commands
{
  my $this  = shift;
  my $command_list = [];   # stores gathered tcl contents 

  foreach my $port (@{$this->_ports()})
  {
    next unless ($port->can("get_tcl_commands"));
    my $command = $port->get_tcl_commands();

    if ($command) {
      push @$command_list, @$command;
    }
  }
  return $command_list;
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

The inherited class e_thing_that_can_go_in_a_module

=begin html

<A HREF="e_thing_that_can_go_in_a_module.html">e_thing_that_can_go_in_a_module</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
