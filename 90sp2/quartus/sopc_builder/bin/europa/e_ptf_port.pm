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

e_ptf_port - description of the module goes here ...

=head1 SYNOPSIS

The e_ptf_port class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_ptf_port;

use e_port;
@ISA = ("e_port");

use europa_utils;
use strict;







my %fields = (
              _AUTOLOAD_ACCEPT_ALL => 1,
              __exclusive_name      => "",
              _do_not_rename       => 0,
              is_shared            => 0,
              _pin_assignment       => "",
              );



my %pointers = (
                _master_or_slave     => (bless {}, "e_ptf_slave"),
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
   my $this = shift;
   $this = $this->SUPER::new(@_);

   my $pm = $this->parent_module();
   if ($pm->{SYSTEM_BUILDER_INFO}{Wire_Test_Bench_Values})
   {
      my $project = $pm->project();
      my $test_module = $pm->project()->test_module();
      my $default = $this->test_bench_value();
      if ($default ne '')
      {
         my $pm_name = $pm->name();
         my $comment = 
             "default value specified in MODULE $pm_name ptf port section";
         e_assign->new({lhs => $this->_exclusive_name(),
                        rhs => $default,
                        comment => $comment,
                     })
             ->within($test_module);
      }
   }



   my $record = $this->vhdl_record_name();
   if ($record)
   {
     $this->name($record.'_'.$this->name());
   }
   $this->vhdl_record_name(""); # gone
   $this->vhdl_record_type(""); # gone

   return $this;
}



=item I<_exclusive_name()>

exclusive name renames the port based upon the module and
slave/master name.  This naming scheme stays with the port so
that it is easy for us to use the port's system name when generating
system level logic.

=cut

sub _exclusive_name
{
   my $this = shift;

   my $assignedName = shift; # null, if used as getter
   if($assignedName)
   {

      $this->{__exclusive_name} = $assignedName;
      return $assignedName;
   }

   my $exclusive_name = $this->__exclusive_name();
   if ($exclusive_name)
   {
      return ($exclusive_name);
   }

   return $this->__exclusive_name ($this->name())
       if ($this->_do_not_rename());

   my @names;
   my $pm = $this->parent_module() or 
       &ribbit ("no parent_module");

   my $pm_name = $pm->name() or 
       &ribbit ("no name for parent module");

   my $port_name = $this->name();
   my $type = $this->{type};
   $type = ""
       if ($type eq "export");

   my $provenance;

   if ($this->_is_inout())
   {
      $provenance = "_to_and_from_the_";
   }
   elsif ($this->export())
   {
      $provenance = "_from_the_";
   }
   else
   {
      $provenance = "_to_the_";
   }

   if (!$type)
   {
     $exclusive_name = $port_name.$provenance.$pm_name;
   }
   elsif (!$pm->{SYSTEM_BUILDER_INFO}{Instantiate_In_System_Module})
   {
      if ($this->is_shared())
      {
         &ribbit ("Chipselect not allowed to be shared.") 
            if ($type =~ /^chipselect/);


         my $slave = $this->parent();
         my $slave_name = $slave->name();
         (&is_blessed($slave) && $slave->isa("e_ptf_slave"))
             or &ribbit ("$pm_name/$port_name ",
                         "only slave ports may be shared");
         
         my $sbi = $slave->{SYSTEM_BUILDER_INFO};
         my $master_ref = $sbi->{MASTERED_BY}
         or &ribbit 
             ("slave $slave_name is not mastered by anyone");

         my @masters = keys (%$master_ref);
         (@masters == 1) or &ribbit 
             ("$pm_name/$slave_name/$port_name: ",
              "shared ports may only be in a slave which ",
              "has one master");

         my ($master_module,$master_name) = split 
             (/\//,
              $masters[0]);
         $type =~ s/_n$/n/;
         
         $exclusive_name = "${master_module}_${type}";
         $exclusive_name = "${master_module}_${port_name}_${type}" 
            if ($type =~ /^always[01]$/i);
      }
      else #not shared;
      {
         unless ($provenance =~ s/^to_the/from_the/)
         {
            $provenance =~ s/^from_the/to_the/;
         }
         $exclusive_name = $port_name.$provenance.$pm_name;
         my $slave = $this->parent();
         if ($slave->isa("e_ptf_slave")) {
            my @slaves = keys (%{$pm->{SLAVE}}) ;
            my @masters = keys (%{$pm->{MASTER}}) ;
            my $actual_slave_count = 0;
            foreach my $s (@slaves)
            {
               my $slave_SBI = $pm->{SLAVE}{$s}{SYSTEM_BUILDER_INFO};
               $slave_SBI->{Is_Enabled} = 1
                   unless (exists($slave_SBI->{Is_Enabled}));
               next unless ($slave_SBI->{Is_Enabled});

               $actual_slave_count++;
            }
            foreach my $s (@masters)
            {
               my $master_SBI = $pm->{MASTER}{$s}{SYSTEM_BUILDER_INFO};
               $master_SBI->{Is_Enabled} = 1
                   unless (exists($master_SBI->{Is_Enabled}));
               next unless ($master_SBI->{Is_Enabled});
               $actual_slave_count++;
            }

            if ($actual_slave_count > 1){
                my $slave_name = $slave->name();
                $exclusive_name .= "_".$slave_name;
            }
         }
      }
   }
   else
   {

      $pm_name =~ s/\_+/\_/g;

      push (@names, $pm_name);

      my $slave  = $this->_master_or_slave() 
          or &ribbit ("no slave/master set");
       


      if ($this->_master_or_slave()->isa_dummy())
      {
         $exclusive_name = $port_name.$provenance.$pm_name;




      }
      else
      {
         my $slave_name = $slave->name() 
             or &ribbit ("no slave name");
         $slave_name    =~ s/\_+/\_/g;

         push (@names, $slave_name);
         
         my $name = $port_name;
         $name    = $type if ($type);
         $exclusive_name = join ("_",@names,$name);
         $exclusive_name =~ s/\s+/\_/g;
         $exclusive_name =~ s/\_+/\_/g;
      }
   }

   my $clock = $this->parent()->clock();
   if ($type eq 'clk')
   {
      $exclusive_name = $clock;
   }
   elsif ($type eq 'out_clk')
   {



      unless ($this->parent_module()->isa('e_ptf_module')) {
        &ribbit ("
            out_clk-type port $port_name is coming from an unexpected source.
            out_clks can come from e_ptf_modules, but nothing else.
            Reasons why this might be happening: 
              - out_clk is being made from bus logic?
        ");
      }
      my $module = $this->parent();
      my $module_name = $module->name();
      my $temp = $pm_name.'_'.$port_name;
      $exclusive_name = 
         $this->parent_module()->augment_out_clock_name($temp);
      e_ptf_slave_arbitration_module->make_outclk_connection(
         $this->parent->project(),
         $exclusive_name,
      );
   }
   elsif (($type eq 'reset_n') && $this->parent()->isa('e_module'))
   {
     $exclusive_name = $this->parent()->reset_n();
     $this->parent->project()->top()->make_reset_synchronizer(
       $clock,
       $exclusive_name,
     );
   }
   elsif (($type eq 'reset') && $this->parent()->isa('e_module'))
   {
     $exclusive_name = $this->parent()->reset();



     $this->parent->project()->top()->get_and_set_once_by_name
      ({
         thing  => "assign",
         name   => "complemented " . $this->parent()->reset_n(),
         lhs    => $exclusive_name,
         rhs    => complement($this->parent()->reset_n()),
      });
     
     $this->parent->project()->top()->make_reset_synchronizer(
       $clock,
       $this->parent()->reset_n(),
     );
   }
   else
   {
      $exclusive_name = $type
          if ($this->_isa_global_signal);
   }
   return ($this->__exclusive_name($exclusive_name));
}



=item I<_isa_global_signal()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _isa_global_signal
{
   my $this = shift;
   
   my $type = $this->type() or return(0);
   


   return (0) if ($type eq 'clk_en' || $type eq 'clken');
   
   return (1)
       if (($type =~ /^clk/i) || ($type =~ /^out_clk/)) ;




   return (0);
}



=item I<to_esf()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_esf
{
  my $this = shift;
  my $return_hash = shift;

  if ($this->{ESF_ATTRIBUTES}) {
    foreach my $option (keys %{$this->{ESF_ATTRIBUTES}}) {
      foreach my $setting (keys %{$this->{ESF_ATTRIBUTES}{$option}}) {
        my $string = $this->_exclusive_name() 
              .  " : "
              . $setting
              .  " = "
              . $this->{ESF_ATTRIBUTES}{$option}{$setting};
        push (@{$return_hash->{$option}} , $string );
      }
    }
  }

  return ($return_hash);
}



=item I<amount_to_left_shift_connection()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub amount_to_left_shift_connection
{
   my $this = shift;
   my $slave = $this->_master_or_slave;

   if (!$slave->isa_dummy())
   {
      if (!$slave->isa('e_ptf_master'))
      {
         my $slave_SBI = $slave->{SYSTEM_BUILDER_INFO};
         if ($slave_SBI->{Bus_Type} =~
             /_tristate$/i)
         {
            if ($slave_SBI->{Is_Memory_Device})
            {
               if ($this->type() =~ /^address(_n)?$/)
               {
                  my $data_width =
                      $slave->{SYSTEM_BUILDER_INFO}{Data_Width};

                  my $return = ($data_width > 16)? 2:
                  ($data_width > 8)? 1:
                  0;
                  return $return;
               }
            }
         }
      }
   }
   return 0;
}




=item I<pin_assignment()>

The access function for setting and returning the pin assignment for this port.
You'd think that setting a pin assignment would be a simple matter, but, in
fact, it can come from many sources.  This pin_assignment is how you may assign
pins through europa.  It does NOT directly read/write to the Quartus database,
therefore Quartus will always be able to do something else (or ignore these
assignments) at a later point in the flow. 

The order of precedence for setting the pin assignment through europa is:
- set in the ptf on a per-board level.  this method will take precedence over
  all other assignment methods.
    PORT_WIRING 
    {
        PORT port_name
        {
          BOARD_COMPONENT name_of_board_class
          {
              pin_assignment = "PIN_E21";
          }
        }
    }
- set explicitly by/to an object by a europa call to this subroutine, with
  location passed in.  
- set in the ptf is a global assignment, as in: 
    PORT_WIRING 
    {
        PORT port_name
        {
          pin_assignment = "PIN_E21";
        }
    }


=cut

sub pin_assignment
{
  my $this = shift;
  my $location = shift;
  my $return_value;



  if ($location) {
    $this->_pin_assignment($location);
  }









  if (my $ptf = $this->project()->system_ptf()) {
    my $board_class = $ptf->{WIZARD_SCRIPT_ARGUMENTS}->{board_class};
    my $board_pin_assignment =
      $this->{BOARD_COMPONENT}{$board_class}{pin_assignment};

    if ($board_pin_assignment) {
      $this->_pin_assignment($board_pin_assignment);
    }
  }

  $return_value = $this->_pin_assignment();
  return $return_value;

}

sub get_tcl_commands
{
  my $this  = shift;
  my @tcl_command;

  if (my $assignment = $this->pin_assignment()) {
    my $name = $this->_exclusive_name();

    my $lsb = $this->lsb() || 0;
    @tcl_command = $this->project()->tcl_add_pins($assignment, $name, $lsb);
  }

  return \@tcl_command;
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

The inherited class e_port

=begin html

<A HREF="e_port.html">e_port</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
