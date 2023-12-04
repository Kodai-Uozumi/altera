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

s_ahb_slave_arbitration_module - description of the module goes here ...

=head1 SYNOPSIS

The s_ahb_slave_arbitration_module class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package s_ahb_slave_arbitration_module;

use e_ptf_slave_arbitration_module;
@ISA = ("e_ptf_slave_arbitration_module");
use strict;
use europa_utils;
use e_mux;

my $do_global_hready = 0;






my %fields   = (
      next_master_number  => 0,
);
my %pointers = ();

my $no_lcell = 1;

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );




=item I<_type_needs_special_care()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _type_needs_special_care
{
   my $this = shift;
   my $type = shift or &ribbit ("no type\n");

   my $return = 0;

   $return = 1 if ($type =~ /^irq/i);
   $return = 1 if ($type =~ /^hwdata$/i);
   $return = 1 if ($type =~ /^hrdata$/i);
   $return = 1 if ($type =~ /^hsel$/i);
   $return = 1 if ($type =~ /^hburst$/i);
   $return = 1 if ($type =~ /^hready/i);
   $return = 1 if ($type =~ /^hresp/i);
   $return = 1 if ($type =~ /^htrans/i);
   $return = 1 if ($type =~ /^reset/i);
   return ($return);
}



=item I<_slave_specific_special_care()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _slave_specific_special_care
{
   my $this = shift;
   $this->_master_arbitration_logic();   

   $this->_handle_hmaster      ();

   foreach my $slave_id ($this->_get_bridged_slave_ids())
   {
      $this->_handle_reset_and_reset_request ($slave_id);
      if ($this->_slave_has_base_address($slave_id))
      {
        $this->_identify_bursts              ($slave_id);
      }
      my @masters = $this->_get_irq_slave_masters($slave_id);
      foreach my $master_desc (@masters)
      {
         $this->_handle_irq($master_desc,$slave_id);
      }
   }
}



=item I<_master_specific_special_care()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _master_specific_special_care
{
   my $this = shift;

   my $master_desc = shift or &ribbit ("no md");
   $this->_handle_hgrant       ($master_desc);

   foreach my $slave_id ($this->_get_bridged_slave_ids())
   {
      if ($this->_slave_has_base_address($slave_id))
      {
         $this->_make_requests       ($master_desc,$slave_id);
         $this->_handle_hready       ($master_desc,$slave_id);
         $this->_handle_hmastlock    ($master_desc,$slave_id);
         $this->_handle_hsel         ($master_desc,$slave_id);
         $this->_handle_hburst       ($master_desc,$slave_id);
         $this->_handle_hrdata       ($master_desc,$slave_id);
         $this->_handle_hwdata       ($master_desc,$slave_id);
         $this->_handle_hresp        ($master_desc,$slave_id);
         $this->_handle_htrans       ($master_desc,$slave_id);
      }

   }
}






=item I<_get_slave_id()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_slave_id
{
  my $this = shift;
  my $slave_name  = $this->_master_or_slave()->name();
  my $module_name = $this->_master_or_slave()->parent_module()->name();

  return ("$module_name/$slave_name");
}

















=item I<_handle_hresp()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_hresp
{
  my $this = shift;

  my $master_desc = shift or &ribbit ("no master_d");
  my $slave_id    = shift or &ribbit ("no slave_id");
  my $master      = $this->_get_master($master_desc);
  my $slave       = $this->_get_slave($slave_id);

  my $slave_hresp = 
      $slave->_get_exclusively_named_port_or_its_complement("hresp")
          or &ribbit ("slave $slave_id does not have an hresp signal");
  my $master_hresp = 
      $master->_get_exclusively_named_port_or_its_complement("hresp")
          or &ribbit ("master $master_desc does not have an hresp signal");
  my $master_is_active = 
    $master->_arbitrator()->get_signal_name_by_type ("active_transaction");
  my $master_was_active = 
      $master->_arbitrator()->_make_signal($master_desc .  "_was_active");
  my $master_should_pause_for_error = 
    $master->_arbitrator()->make_signal_of_type ("pause_for_error");

  $master->_arbitrator()->get_and_set_once_by_name
      ({
          thing => "register",
          name  => "d1 $master_should_pause_for_error register",
          q     => "d1_" . $master_should_pause_for_error,
          d     => $master_should_pause_for_error,
          enable  => "1",
      });








  $master->_arbitrator()->get_and_set_once_by_name
      ({
          thing => "mux",
          name  => "mux $master_hresp",
          lhs   => $master_hresp,
          table => [$master_should_pause_for_error => "2'b01",
             "d1_". $master_should_pause_for_error => "2'b01",
          ],
          default => "2'b00",
      });

  my $select_request = $this->_get_master_request_signal_name
      ($master_desc,$slave_id);
  my $master_has_valid_request = 
    $master->_arbitrator()->make_signal_of_type ("has_valid_request");
  $master->_arbitrator()->get_and_set_thing_by_name
      ({
          thing => "mux",
          type  => "and-or",
          name  => "mux $master_has_valid_request",
          lhs   => $master_has_valid_request,
          add_table_ref => [$select_request, $select_request],
          comment => "true if access decodes as valid slave",
      });

  $master->_arbitrator()->get_and_set_once_by_name
      ({
          thing     => "register",
          name      => "$master_should_pause_for_error register",
          q         => $master_should_pause_for_error,
          sync_reset=> $master_should_pause_for_error, 
          sync_set  => "($master_is_active) & ~($master_has_valid_request)",
          priority  => "reset",
          enable    => "1",
      });


  my $select_was_granted = "d1_" . $this->_get_master_grant_signal_name
       ($master_desc,$slave_id);
  $master->_arbitrator()->get_and_set_thing_by_name
      ({
          thing => "mux",
          name  => "mux $master_hresp",
          lhs   => [$master_hresp, 2, 1],
          add_table_ref => [$select_was_granted, $slave_hresp],
          comment => "data-phase mux of slave's hresp, with special cases",
      });
}
































=item I<_handle_hready()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_hready
{
  my $this = shift;

  my $master_desc = shift or &ribbit ("no master_d");
  my $slave_id    = shift or &ribbit ("no slave_id");
  my $slave       = $this->_get_slave($slave_id);
  my $master      = $this->_get_master($master_desc);

  my $top = $this->project->top();

  my $slave_hreadyo = 
      $slave->_get_exclusively_named_port_or_its_complement("hreadyo");
  $slave_hreadyo or &ribbit ("No hready output signals for slave $slave_id");






  my $slave_hreadyo_to_master = $slave_hreadyo . "_to_master";
  $this->get_and_set_thing_by_name
        ({
            thing => "assign",
            name  => "$slave_hreadyo_to_master assignment",
            lhs   => [$slave_hreadyo_to_master, 1, 1, 0, 0],
            rhs   => "$slave_hreadyo",
        });

  my $master_hready = 
      $master->_get_exclusively_named_port_or_its_complement("hready");
  $master_hready or &ribbit ("No hready signals for master $master_desc");


  unless ($master->parent_module()->
          {SYSTEM_BUILDER_INFO}{Instantiate_In_System_Module})
  {
     e_signal->new([$master_hready, 1, 1])
         ->within($top);
  }

  my $select_request = $this->_get_master_request_signal_name
      ($master_desc,$slave_id);
  my $select_granted = $this->_get_master_grant_signal_name
      ($master_desc,$slave_id);
  my $slave_requested_but_not_granted = "$select_request & ~($select_granted)";
  my $master_requested_but_not_granted = 
      $this->_make_signal($master_desc .  "_requested_but_not_granted");
  my $master_should_pause_for_error =
      $master->_arbitrator()->get_signal_name_by_type ("pause_for_error")
      or &ribbit ("Can't find 'pause_for_error' signal");



  $master->_arbitrator()->get_and_set_thing_by_name
        ({
            thing => "mux",
            type  => "and_or", # 0 if nobody selected
            name  => "$master_requested_but_not_granted mux",
            lhs   => $master_requested_but_not_granted,
            add_table_ref => 
                [$slave_requested_but_not_granted,
                $slave_requested_but_not_granted],
        });
  if ($do_global_hready) {
      $top->get_and_set_thing_by_name
            ({
                thing => "mux",
                type  => "or_and", #hready if nobody selected
                name  => "global hready sources mux",
                lhs   => "global_hready",
                add_table_ref => 
                    [$slave_hreadyo_to_master, $slave_hreadyo_to_master],
            });

      $master->_arbitrator()->get_and_set_once_by_name
            ({
                thing => "assign",
                name  => "$master_hready (master hready) assignment",
                lhs   => [$master_hready, 1, 1],
                rhs   => "global_hready && ~($master_requested_but_not_granted)"
                        ." && ~($master_should_pause_for_error)",
            });
  } else { # arbitrated master hready
      my $master_address_phase_hready = $master_hready . "_from_address_phase";
      my $master_data_phase_hready = $master_hready . "_from_data_phase";
      my $data_phase_select_granted = "d1_" . $select_granted;
      $master->_arbitrator()->get_and_set_thing_by_name
          ({
              thing => "mux",
              type  => "or_and", # 1 if nobody selected
              name  => "$master_address_phase_hready mux",
              lhs   => $master_address_phase_hready,
              add_table_ref => 
                  [$select_granted, $slave_hreadyo_to_master],
          });
      $master->_arbitrator()->get_and_set_thing_by_name
          ({
              thing => "mux",
              type  => "or_and", # 1 if nobody selected
              name  => "$master_data_phase_hready mux",
              lhs   => $master_data_phase_hready,
              add_table_ref => 
                  [$data_phase_select_granted, $slave_hreadyo_to_master],
          });









      $master->_arbitrator()->get_and_set_once_by_name
          ({
              thing => "assign",
              name  => "$master_hready (master hready) assignment",
              lhs   => [$master_hready, 1, 1],
              rhs   => " ($master_data_phase_hready) "
                      ." && ($master_address_phase_hready) "
                      ." && ~($master_requested_but_not_granted)"
                      ." && ~($master_should_pause_for_error)",
          });
  }





  my $slave_hreadyi = 
      $slave->_get_exclusively_named_port_or_its_complement("hreadyi");
  if ($slave_hreadyi) {
    if ($do_global_hready) {
      $this->get_and_set_thing_by_name
          ({
            thing => "assign",
            name  => "$slave_hreadyi (slave hready in) mux",
            lhs   => [$slave_hreadyi, 1, 1],
            rhs   => "global_hready",
          });
    } else {

      my $slave_address_phase_hreadyi = $slave_hreadyi . "_from_address_phase";
      my $slave_data_phase_hreadyi = $slave_hreadyi . "_from_data_phase";
      my $data_phase_select_granted = "d1_". $select_granted;
      $this->get_and_set_thing_by_name
          ({
              thing => "mux",
              type  => "or_and", # 1 if nobody selected
              name  => "$slave_address_phase_hreadyi mux",
              lhs   => $slave_address_phase_hreadyi,
              add_table_ref => 
                  [$select_granted, $master_hready],
          });
      $this->get_and_set_thing_by_name
          ({
              thing => "mux",
              type  => "or_and", # 1 if nobody selected
              name  => "$slave_data_phase_hreadyi mux",
              lhs   => $slave_data_phase_hreadyi,
              add_table_ref => 
                  [$data_phase_select_granted, $master_hready],
          });

      $this->get_and_set_once_by_name
          ({
              thing => "assign",
              name  => "$slave_hreadyi (slave hready in) assignment",
              lhs   => [$slave_hreadyi, 1, 1],
              rhs   => " ($slave_data_phase_hreadyi) "
                      ." && ($slave_address_phase_hreadyi) ",
          });
    } # if do_global_hready
  } # if slave_hreadyi

}











=item I<_handle_hsel()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_hsel
{
  my $this = shift;

  my $master_desc = shift or &ribbit ("no master_d");
  my $slave_id    = shift or &ribbit ("no slave_id");
  my $slave         = $this->_get_slave($slave_id);

  my $hsel_port = 
      $slave->_get_exclusively_named_port_or_its_complement("hsel");

  my $master_q_req = $this->_get_master_qualified_request_signal_name
      ($master_desc,$slave_id);
  $this->get_and_set_thing_by_name
        ({
            thing => "mux",
            type  => "and-or",
            name  => "$hsel_port mux",
            lhs   => [$hsel_port, 1, 1],
            add_table_ref => [$master_q_req, $master_q_req],
        });
}










=item I<_handle_hburst()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_hburst
{
  my $this = shift;

  my $master_desc = shift or &ribbit ("no master_d");
  my $master      = $this->_get_master($master_desc);
  my $slave_id    = shift or &ribbit ("no slave_id");
  my $slave       = $this->_get_slave($slave_id);

  my $master_hburst = 
      $master->_get_exclusively_named_port_or_its_complement("hburst")
    or &goldfish("master $master_desc without required hburst port");



  my $slave_hburst_port = 
    $slave->_get_exclusively_named_port_or_its_complement("hburst")
    || $this->make_signal_of_type ("hburst", 3);
  my $slave_previous_master_hburst = 
    $this->make_signal_of_type ("previous_master_hburst", 3);

  my $select_granted = 
    $this->_get_master_grant_signal_name ($master_desc,$slave_id);
  my $last_select_granted = 
    $this->_get_master_grant_signal_name ($master_desc,$slave_id);

  $this->get_and_set_thing_by_name
    ({
        thing     => "mux",
        name      => "mux $slave_hburst_port",
        lhs       => [$slave_hburst_port, 3, 1],
        add_table => [$select_granted,
                      $master_hburst],
    });
  $this->get_and_set_thing_by_name
    ({
        thing     => "mux",
        name      => "$slave_id copy of hburst port of last master",
        lhs       => $slave_previous_master_hburst,
        add_table => ["d1_".$select_granted,
                      $master_hburst],
    });
}








=item I<_handle_htrans()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_htrans
{
  my $this = shift;

  my $master_desc = shift or &ribbit ("no master_d");
  my $master      = $this->_get_master($master_desc);
  my $slave_id    = shift or &ribbit ("no slave_id");
  my $slave       = $this->_get_slave($slave_id);

  my $master_htrans = 
      $master->_get_exclusively_named_port_or_its_complement("htrans")
    or &ribbit("master $master_desc without required htrans port");

  my $slave_htrans_port = 
    $slave->_get_exclusively_named_port_or_its_complement("htrans")
    or &ribbit("slave $slave_id without required htrans port");
  my $slave_previous_master_htrans = 
    $this->make_signal_of_type ("previous_master_htrans", 2);

  my $select_granted = 
    $this->_get_master_grant_signal_name ($master_desc,$slave_id);
  my $last_select_granted = 
    $this->_get_master_grant_signal_name ($master_desc,$slave_id);

  $this->get_and_set_thing_by_name
    ({
        thing     => "mux",
        name      => "mux $slave_htrans_port",
        lhs       => [$slave_htrans_port, 2, 1],
        add_table => [$select_granted,
                      $master_htrans],
    });
  $this->get_and_set_thing_by_name
    ({
        thing     => "mux",
        name      => "$slave_id copy of htrans port of last master",
        lhs       => $slave_previous_master_htrans,
        add_table => ["d1_".$select_granted,
                      $master_htrans],
    });
}

















=item I<_identify_bursts()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _identify_bursts
{
  my $this = shift;

  my $slave_id    = shift or &ribbit ("no slave_id");
  my $slave       = $this->_get_slave($slave_id);

  my $slave_htrans = 
    $slave->_arbitrator->get_signal_name_by_type ("previous_master_htrans")
    or &ribbit("slave $slave_id without required previous_master_htrans port");
  my $slave_hburst = 
    $slave->_arbitrator->get_signal_name_by_type ("previous_master_hburst")
    or &ribbit("slave $slave_id without required previous_master_hburst port");

  my $slave_hready = 
    $slave->_get_exclusively_named_port_or_its_complement("hreadyi")
      or &ribbit ("No hreadyi signal for slave $slave_id");
  my $slave_hsel = 
    $slave->_get_exclusively_named_port_or_its_complement("hsel")
      or &ribbit ("No hsel signal for slave $slave_id");

  my $slave_is_in_burst = $this->make_signal_of_type ("continuing_burst", 1, 0);
  my $rhs = "(($slave_htrans\[0]) & ($slave_hburst != 3\'b000))" .
            " & $slave_hsel";
  $this->get_and_set_once_by_name
    ({
      thing => "assign",
      name  => "$slave_id is in a burst transaction",
      lhs   => $slave_is_in_burst,
      rhs   => $rhs, 
    });

  $this->sink_signals($slave_is_in_burst);

}


































=item I<_handle_hgrant()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_hgrant
{
   my $this = shift;

   my $master_desc = shift or &ribbit ("no master_d");
   my $master = $this->_get_master($master_desc);

   my $hgrant_port = 
       $master->_get_exclusively_named_port_or_its_complement("hgrant")
      or &ribbit ("No hgrant signal for master $master_desc");
   my $hbusreq_port = 
       $master->_get_exclusively_named_port_or_its_complement("hbusreq")
      or &ribbit ("No hbusreq signal for master $master_desc");
   my $hready_port = 
       $master->_get_exclusively_named_port_or_its_complement("hready")
      or &ribbit ("No hready signal for master $master_desc");
   my $htrans_port = 
       $master->_get_exclusively_named_port_or_its_complement("htrans")
      or &ribbit ("No htrans signal");
   my $hlock_port = 
       $master->_get_exclusively_named_port_or_its_complement("hlock");

   my $hgrant_enable = $hready_port ;




   if ($hlock_port ne "") {
      $hgrant_enable .= " & ~($hgrant_port & $hlock_port)";
   }

   my $master_is_active =  # exported because it's needed for slave-side arb
      $master->_arbitrator()->make_signal_of_type ("active_transaction", 1, 1);
   $master->_arbitrator()->get_and_set_once_by_name
      ({
        thing => "assign",
        name  => "$master_desc does an active transaction",
        lhs   => $master_is_active,
        rhs   => "$htrans_port\[1] & $hgrant_port",
      });








   my $found_other_masters ; 
   $found_other_masters =  # if exists already, don't worry about it.
      ($this->get_object_by_name("hgrant port for $master_desc")) ? 1 : 0;

   my @slaves_list =
     $this->project()->get_slaves_by_master_name ($master_desc);

   while (($found_other_masters == 0) & (scalar (@slaves_list > 0))) {
      my $slave_id_to_test = shift (@slaves_list) ;
      next if ($this->_slave_has_base_address($slave_id_to_test) == 0); 
      my @master_descs = $this->_get_master_descs();
      if (scalar (@master_descs) > 1) {
          $found_other_masters = 1;
      }
   }

   if ($found_other_masters == 0) {
      $master->_arbitrator()->get_and_set_once_by_name
          ({
            thing => "assign",
            name  => "hgrant port for $master_desc",
            lhs   => [$hgrant_port, 1, 1],
            rhs   => "1'b1",
          });
   } else { #  other masters.  you need to hbusreq before hgrant.
      $master->_arbitrator()->get_and_set_once_by_name
          ({
            thing => "register",
            name  => "hgrant port for $master_desc",
            q     => [$hgrant_port, 1, 1],
            d     => "($hbusreq_port) | ($master_is_active)",
            enable  => $hgrant_enable ,
          });
   }
}

















=item I<_handle_hmastlock()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_hmastlock
{
   my $this = shift;

   my $master_desc = shift or &ribbit ("no master_d");
   my $slave_id    = shift or &ribbit ("no slave_id");

   my $slave         = $this->_get_slave($slave_id);
   my $master = $this->_get_master($master_desc);

   my $slave_hmastlock = 
      $this->_get_exclusively_named_port_by_type ("hmastlock");
   $slave_hmastlock or return ;


   $this->get_and_set_once_by_name
      ({
          thing => "mux",
          name  => "$slave_hmastlock mux",
          lhs   => [$slave_hmastlock, 1, 1, 0],
          default       => "1'b0",
      });

   my $hlock_port = 
      $master->_get_exclusively_named_port_or_its_complement("hlock") ;
   $hlock_port or return;   # if no hlock port, don't have to worry.

   my $select_granted = $this->_get_master_grant_signal_name
       ($master_desc,$slave_id);


   $this->get_and_set_thing_by_name
       ({
          thing => "mux",
          name  => "$slave_hmastlock mux",
          lhs   => $slave_hmastlock,
          add_table_ref => [$select_granted, $hlock_port],
       });


}















=item I<_handle_hmaster()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_hmaster
{
   my $this = shift;




   my $slave         = $this->_master_or_slave();
   my $slave_id      = $slave->parent_module()->name()."/".$slave->name();

   my $slave_hmaster = 
      $slave->_get_exclusively_named_port_or_its_complement("hmaster") 
     or return;
      
   foreach my $master_desc (sort ($this->_get_master_descs())) {
      my $master = $this->_get_master($master_desc);
      my $master_number = $this->next_master_number; 
      $this->next_master_number($master_number + 1); 

      $master->_get_master_number
          ($master_desc,$slave_id, $master_number);

      my $select_granted = $this->_get_master_grant_signal_name
          ($master_desc,$slave_id);

      $this->get_and_set_thing_by_name
          ({
              thing => "mux",
              name  => "$slave_hmaster mux",
              lhs   => $slave_hmaster,
              add_table_ref => [$select_granted, $master_number],
          });
   }
}








=item I<_handle_hwdata()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_hwdata
{
   my $this = shift;
   my $master_desc = shift or &ribbit ("no md");
   my $slave_id    = shift or &ribbit ("no slave_id");

   my $master      = $this->_get_master($master_desc);
   my $slave       = $this->_get_slave($slave_id);

   my $master_hwdata =
       $master->_get_exclusively_named_port_by_type
           ("hwdata");
   my $master_hwrite =
       $master->_get_exclusively_named_port_by_type
           ("hwrite");
           
   ($master_hwrite && $master_hwdata) or return;

   $master->_arbitrator()->get_and_set_thing_by_name({
      thing => "mux",
      lhs   => ["dummy_sink", 1, 0, 1],
      name  => "dummy sink",
      type  => "and_or",
      add_table => [$master_hwdata,
                    $master_hwdata],
   });

   my $hwdata_port = $slave->_get_exclusively_named_port_by_type("hwdata");
   $hwdata_port or return;

   my $select_granted = "d1_" . $this->_get_master_grant_signal_name
       ($master_desc,$slave_id);

   $this->get_and_set_thing_by_name
       ({
          thing => "mux",
          name  => "$hwdata_port mux",
          lhs   => $hwdata_port,
          add_table_ref => [$select_granted,
                            $master_hwdata],
       });
}









=item I<_handle_hrdata()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_hrdata
{
   my $this = shift;
   my $master_desc = shift or &ribbit ("no md");
   my $slave_id    = shift or &ribbit ("no slave_id");

   my $master      = $this->_get_master($master_desc);
   my $slave       = $this->_get_slave($slave_id);

   my $master_hrdata =
       $master->_get_exclusively_named_port_by_type
           ("hrdata") or return;
   my $master_hrdata_lost_arb_reg_name = $master_hrdata . "_lost_arb_reg";

   my $hrdata_port = $slave->_get_exclusively_named_port_by_type("hrdata");
   $hrdata_port or return;






   my $data_select_granted = "d1_" . $this->_get_master_grant_signal_name
       ($master_desc,$slave_id);
   my $data_width = $this->_get_master_data_width($master_desc);



   $master->_arbitrator()->get_and_set_once_by_name
       ({
          thing => "register",
          name  => "$master_hrdata lost-arbitration register",
          q     => [$master_hrdata_lost_arb_reg_name, $data_width, 0, 1],
          d     => [$master_hrdata, $data_width, 1],
          enable=> $data_select_granted,
       });
   $master->_arbitrator()->get_and_set_once_by_name
       ({
          thing => "mux",
          name  => "$master_hrdata mux",
          lhs   => $master_hrdata,
          default => $master_hrdata_lost_arb_reg_name,
       });
   $master->_arbitrator()->get_and_set_thing_by_name
       ({
          thing => "mux",
          name  => "$master_hrdata mux",
          lhs   => $master_hrdata,
          add_table_ref => [$data_select_granted, $hrdata_port],
       });
}




=item I<_make_requests()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _make_requests
{
   my $this = shift;

   my $master_desc = shift or &ribbit ("no master_d");
   my $slave_id    = shift or &ribbit ("no slave_id");
   my $slave         = $this->_get_slave($slave_id);
   my $requests_name = $this->_get_master_request_signal_name
       ($master_desc, $slave_id);

   my $master = $this->_get_master($master_desc);

   my $slave_SBI   = $slave->{SYSTEM_BUILDER_INFO};
   my $device_base = ($slave_SBI->{Base_Address});
   $device_base    = eval ($device_base)
       unless ($device_base eq "N/A");

   my $master_is_active = 
      $master->_arbitrator()->get_signal_name_by_type ("active_transaction");

   $device_base ne "" || &ribbit 
       ("$slave_id, no device_base (Base_Address = $device_base)");

   my $rhs;
   if ($device_base eq "N/A")
   {
      $rhs = $master_is_active || 1;
   }
   else
   {
      exists $slave_SBI->{Address_Width}
      or &ribbit ("No 'Address_Width' specified for slave $slave_id");

      my $slave_a_bits = $slave_SBI->{Address_Width};
      my $num_ignored_bits = $slave_a_bits;

      my $master_address      = $master->_ports_by_type()->{haddr}
        or &ribbit ("no master address port for $master_desc");
      my $master_address_name = $master_address->_exclusive_name();

      my $master_width  = $master_address->width();
      my $master_msb    = $master_width - 1;




      if ($master_msb < $num_ignored_bits)
      {
         $rhs = 1;
      }
      else
      {
         my $padded_zeroes = ($num_ignored_bits == 0) ? "" :
                ", ".$num_ignored_bits."\'b0";
         $rhs = "{$master_address_name \[$master_msb : $num_ignored_bits\] ".
            $padded_zeroes."} == $master_width\'h".
                sprintf("%x",$device_base);
      }


      $rhs = "($rhs) & $master_is_active";
      
   }
   



   e_assign->new
       ({
          within => $this,
          lhs    => [$requests_name, 1, 1],
          rhs    => $rhs,
       });










   
   $this->_make_request_qualifications
       ($master_desc, $slave_id);
}


=item I<_make_request_qualifications()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _make_request_qualifications
{
   my $this=shift;
   my $master_desc   = shift or &ribbit ("no master_d");
   my $slave_id      = shift or &ribbit ("no slave_id");

   my $master = $this->_get_master($master_desc);

   my $requests_name = $this->_get_master_request_signal_name
       ($master_desc,$slave_id);

   my $qualified_requests_name =
       $this->_get_master_qualified_request_signal_name
           ($master_desc,$slave_id);
   $this->get_and_set_once_by_name
        ({
            name  => "$master_desc qualified request",
            thing => "assign",
            lhs   => $qualified_requests_name,
            rhs   => $requests_name,
        });
}



=item I<_master_arbitration_logic()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _master_arbitration_logic
{
   my $this = shift;

   $this->_slave_has_base_address() or return;


   $this->_handle_numerator_arbitration();
}



=item I<_handle_numerator_arbitration()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_numerator_arbitration
{
   my $this = shift;
   my $slave_SBI         = $this->_master_or_slave()->{SYSTEM_BUILDER_INFO};


   my $slave = $this->_master_or_slave();

   my $module_to_put_logic = $this;#->_where_should_i_put_this();

   my $master_ref        = $slave_SBI->{MASTERED_BY} ||
       $slave_SBI->{Is_Mastered_By};

   my @masters = ($this->_get_master_descs());
   if (@masters == 1)
   {
      my @slave_ids = $this->_get_bridged_slave_ids();
      foreach my $slave_id (@slave_ids)
      {
         my $master_grant =
             $this->_get_master_grant_signal_name
                 ($masters[0],$slave_id);

         my $master_qualified_request =
             $this->_get_master_qualified_request_signal_name
                 ($masters[0],$slave_id);
         my $master   = $this->_get_master($masters[0]);
         my $master_hready = 
             $master->_get_exclusively_named_port_or_its_complement("hready");
         $master_hready or &ribbit ("No hready signals for master $masters[0]");
         
         my $data_phase_grant = "d1_".$master_grant;
         my $data_phase_grant_enable = 
            ($do_global_hready) ? "global_hready" : $master_hready;   

         $this->get_and_set_once_by_name ({
                thing   => "assign",
                name    => "$master_grant assignment",
                comment => "master granted when requested",
                lhs     => [$master_grant,1,1], 
                rhs     => $master_qualified_request,
         });
         $this->get_and_set_once_by_name ({
                thing   => "register",
                name    => "$data_phase_grant assignment",
                comment => "delayed master grant",
                out     => [$data_phase_grant,1,1], 
                in      => $master_grant,
                enable  => $data_phase_grant_enable,
         });
      }
      return;
   }


   my %numerators;
   foreach my $master_desc (@masters)
   {
      my $priority = $master_ref->{$master_desc}{priority};






      my $numerator_key = $priority;
      while ($numerators{$numerator_key})
      {
         $numerator_key .= " ";
      }
      $numerators{$numerator_key} = $master_desc;
   }



   
   my $i = 0;
   my $numerator;
   foreach my $smallest_number_left 
       (sort {$a <=> $b} (keys (%numerators)))
   {
      my $master_desc = $numerators{$smallest_number_left};
      my $my_master   = $this->_get_master($master_desc);
      my $denominator = 0;
      foreach my $n (keys %numerators)
      {
         $denominator += eval ($n);
      }

      delete ($numerators{$smallest_number_left});

      my $arbitration_shift_register_length = $denominator;

      ($smallest_number_left, $arbitration_shift_register_length)
          = $this->_gcd
              ($smallest_number_left, 
               $arbitration_shift_register_length
               );

      my @slave_ids = $this->_get_bridged_slave_ids();
      foreach my $slave_id (@slave_ids)
      {
         my $master_request = 
             $this->_get_master_request_signal_name
                 ($master_desc,$slave_id);

         my $master_qualified_request = 
             $this->_get_master_qualified_request_signal_name
                 ($master_desc,$slave_id);

         my $master_grant =
             $this->_get_master_grant_signal_name
                 ($master_desc,$slave_id);
         my @other_master_descs = (values %numerators);

         if (@other_master_descs)
         {


            my $max_count      = $arbitration_shift_register_length - 1;
            my $num_count_bits = &Bits_To_Encode($max_count);

            $module_to_put_logic->get_and_set_once_by_name
                ({
                   name  => "arbitration next grant $i assignment",
                   thing => "assign",
                   lhs   => ["next_grant_$i", $num_count_bits],
                   rhs   => "(grant_$i == $max_count) ? 0 : (grant_$i + 1)",
                });

            my @other_qualified_master_requests = map
            {$this->_or_all_master_qualified_request_signal_names($_)}
            @other_master_descs;

            my $slave_readyo = 
                $slave->_get_exclusively_named_port_or_its_complement("hreadyo");
            $module_to_put_logic->get_and_set_once_by_name
                ({
                   thing       => "register",
                   name        => "arbitration next grant $i register",
                   out         => ["grant_$i" => $num_count_bits],
                   in          =>  "next_grant_$i",
                   async_value => 0,
                   enable      => $slave_readyo . 
                       " & $master_qualified_request & \n(".
                           join (" |\n",
                                 @other_qualified_master_requests
                                 )
                               ."\n)",
                   comment     => 
                       "$master_desc gets granted $smallest_number_left\n".
                           "out of $arbitration_shift_register_length times ".
                               "contention occurs",    
                 });




            my $my_turn = $this->_make_signal
              ("${master_desc}_s_turn_at_$slave_id");

            $module_to_put_logic->get_and_set_once_by_name
                ({
                   thing       => "register",
                   name        => "${master_desc} wins $slave_id ".
                                  "at begin_xfer",
                   out         => [$my_turn => 1,0],
                   in          => "(grant_$i < $smallest_number_left)",
                   enable      => "1'b1",
                });









            my $my_master_request           = $this->_get_master_request_signal_name($master_desc,$slave_id);
            my $my_master_qualified_request = $master_qualified_request;

            my $my_master_grant =
                $this->_get_master_grant_signal_name($master_desc, $slave_id);
            my $my_master_hready = 
                $my_master->_get_exclusively_named_port_or_its_complement("hready");
            $my_master_hready or &ribbit ("No hready signals for master $master_desc");

            my $my_data_phase_grant = "d1_" . $my_master_grant;
            my $my_data_phase_grant_enable = 
                ($do_global_hready) ? "global_hready" : $my_master_hready;   






            foreach my $omd (@other_master_descs)
            {
               my $other_master = $this->_get_master($omd);
               foreach my $their_slave_id (@slave_ids)
               {
                  my $their_master_grant =
                      $this->_get_master_grant_signal_name($omd,$their_slave_id);
                  my $their_master_qualified_request =
                      $this->_get_master_qualified_request_signal_name
                          ($omd,$their_slave_id);
                  my $their_master_request =
                      $this->_get_master_request_signal_name
                          ($omd,$their_slave_id);
                  my $their_master_hready = 
                      $other_master->_get_exclusively_named_port_or_its_complement("hready");
                  $their_master_hready or &ribbit ("No hready signals for master $master_desc");

                  my $their_data_phase_grant = "d1_" . $their_master_grant;
                  my $their_data_phase_grant_enable = 
                      ($do_global_hready) ? "global_hready" : $their_master_hready;   




                  my @in_a_transfer_terms;  
                  push @in_a_transfer_terms, "~$slave_readyo";


                  my $slave_in_burst =  
                    $slave->_arbitrator()->
                        get_signal_name_by_type("continuing_burst");
                  push @in_a_transfer_terms, $slave_in_burst;
                  my $not_in_a_transfer = "~".
                      &or_array (@in_a_transfer_terms);

                  $this->get_and_set_thing_by_name
                      ({
                         thing   => "assign",
                         name    => "$my_master_grant granted",
                         lhs     => [$my_master_grant => 1, 1],
                         no_lcell => $no_lcell,
                         cascade => [qq($my_master_qualified_request &
                                        (\!$their_master_qualified_request | 
                                         (
                                          {($not_in_a_transfer)? 
                                               $my_turn : $my_data_phase_grant
                                                }
                                          )
                                         )
                                        )
                                     ],

                          });


                  $this->get_and_set_once_by_name ({
                          thing   => "register",
                          name    => "$my_data_phase_grant register granted",
                          out     => [$my_data_phase_grant,1,1], 
                          in      => $my_master_grant,
                          enable  => $my_data_phase_grant_enable,
                  });


                  $this->get_and_set_thing_by_name
                      ({
                         thing   => "assign",
                         name    => "$their_master_grant granted",

                         lhs     => [$their_master_grant => 1, 1],
                         no_lcell => $no_lcell,

                         cascade => [qq($their_master_qualified_request &
                                        (\!$my_master_qualified_request | 
                                         (
                                          {($not_in_a_transfer)? 
                                               (\!$my_turn) : $their_data_phase_grant
                                                }
                                          )
                                         )
                                        )
                                     ],
                          });

                  $this->get_and_set_once_by_name ({
                         thing => "register",
                         name  => "$their_data_phase_grant register granted",
                         out   => ["$their_data_phase_grant" => 1,1],
                         in    => $their_master_grant,
                         enable  => $their_data_phase_grant_enable,
                  });
               }  # end of foreach other masters' slaves' ids.    
            }   # end of foreach other master description ($omd)
         }
      }
      $i++;
   }
}



=item I<_get_hmastlock_signal_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_hmastlock_signal_name
{
  my $this = shift;
  my $slave_id = shift or &ribbit ("No slave id");
  my $slave = $this->_get_slave($slave_id);
  my $return_this = 
      $slave->_get_exclusively_named_port_or_its_complement("hmastlock")
        ||
      $this->_make_signal("hmastlock_for_$slave_id");
  return $return_this;
}; 









=item I<_get_bridged_slave_ids()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_bridged_slave_ids
{
   my $this = shift;
   return ($this->_get_slave_id());
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

The inherited class e_ptf_slave_arbitration_module

=begin html

<A HREF="e_ptf_slave_arbitration_module.html">e_ptf_slave_arbitration_module</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
