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

e_adapter - description of the module goes here ...

=head1 SYNOPSIS

The e_adapter class is an abstract base class for adapters.

=head1 METHODS

=over 4

=cut

package e_adapter_slave_y;

use europa_utils;
use e_avalon_adapter_interface;
use e_avalon_adapter_master;
use e_avalon_adapter_slave;

@ISA = ("e_adapter");
use strict;

my %fields = (
);

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );

sub _get_a_granted_signal_name
{
  return "a_granted_this_time";
}

sub _get_b_granted_signal_name
{
  return "b_granted_this_time";
}

=item I<_get_grant_signals($)>

Makes arbitration logic to determine if a is granted this time.
Returns verilog logic string.
 
=cut

sub _get_grant_signals($_)
{
  my $this = shift;



  my $a_upstream = $this->get_object_by_name("a_upstream");
  my $b_upstream = $this->get_object_by_name("b_upstream");
  my $downstream = $this->get_object_by_name("downstream");




  my $downstream_select = $downstream->get_signal_by_type("chipselect");
  my $downstream_wait = $downstream->get_signal_by_type("waitrequest");
  my $downstream_ack = &complement($downstream_wait);
  my $a_sel = $a_upstream->get_signal_by_type("chipselect");
  my $b_sel = $b_upstream->get_signal_by_type("chipselect");

  my $a_arblock = $a_upstream->get_signal_by_type("arbiterlock2");
  my $b_arblock = $b_upstream->get_signal_by_type("arbiterlock2");




  my $a_granted_this_time = $this->_get_a_granted_signal_name();
  my $b_granted_this_time = $this->_get_b_granted_signal_name();










  $this->get_and_set_once_by_name({
    name => "a grant register",
    thing => "register",
    enable => "~downstream_waitrequest || (~a_upstream_chipselect & ~b_upstream_chipselect)",
    out => $a_granted_this_time,
    in =>
      "~$a_sel ? 0 : " . # no request, so no grant
      "$a_sel & ~$b_sel ? 1 : " . # requesting and b isn't
      "$a_granted_this_time & $a_arblock ? 1 : " . # granted and arblock
      "~$a_granted_this_time & ~$b_granted_this_time ? 1 : " . # bias to a when both request
      "~$a_granted_this_time & ~$b_arblock ? 1 : " . # a's turn unless b arblock
      "0",
  });

  $this->get_and_set_once_by_name({
    name => "b grant register",
    thing => "register",
    enable => "~downstream_waitrequest || (~a_upstream_chipselect & ~b_upstream_chipselect)",
    out => $b_granted_this_time,
    in =>
      "~$b_sel ? 0 : " . # no request, no grant
      "$b_sel & ~$a_sel ? 1 : " . # b requests, a doesn't
      "$b_granted_this_time & $b_arblock ? 1 : " . # granted and arblock
      "~$a_granted_this_time & ~$b_granted_this_time ? 0 : " . # bias to a when both request
      "~$b_granted_this_time & ~$a_arblock ? 1 : " . # b's turn unless a arblock
      "0",
  });

  return ($a_granted_this_time, $b_granted_this_time);
}

=item I<make_special_assignments($)>

Generates Logic to yield arbiterlock downstream
                                 
=cut

sub make_special_assignments
{
  my $this = shift;



  my $a_upstream = $this->get_object_by_name("a_upstream");
  my $b_upstream = $this->get_object_by_name("b_upstream");
  my $downstream = $this->get_object_by_name("downstream");

  my $a_select = $a_upstream->get_signal_by_type('chipselect');
  my $b_select = $b_upstream->get_signal_by_type('chipselect');

  my $a_read = $a_upstream->get_signal_by_type('read');
  my $b_read = $b_upstream->get_signal_by_type('read');
  
  my $downstream_arblock = $downstream->get_signal_by_type("arbiterlock2");

  my ($a_granted_this_time, $b_granted_this_time) =
    $this->_get_grant_signals();

  my $a_arblock = $a_upstream->get_signal_by_type("arbiterlock2");
  my $b_arblock = $b_upstream->get_signal_by_type("arbiterlock2");










  e_assign->new({
    lhs => $downstream_arblock,
    rhs => 
      "($a_granted_this_time & ($a_arblock | $b_select)) | " .
      "($b_granted_this_time & $b_arblock)", 
  })->within($this);

  my $a_wait = $a_upstream->get_signal_by_type('waitrequest');
  my $b_wait = $b_upstream->get_signal_by_type('waitrequest');
  my $d_wait = $downstream->get_signal_by_type('waitrequest');

  e_assign->new({
      lhs => $a_wait,
      rhs => "$d_wait || ~$a_granted_this_time",
  })->within($this);

  e_assign->new({
      lhs => $b_wait,
      rhs => "$d_wait || ~$b_granted_this_time",
  })->within($this);


  my $downstream_read = $downstream->get_signal_by_type("read");
  e_export->new({expression => $downstream_read})->within($this);



  my $downstream_select = $downstream->get_signal_by_type("chipselect");
  e_assign->new({
    lhs => {name => $downstream_select, export => 1,},
    rhs => "$a_granted_this_time & $a_select | $b_granted_this_time & $b_select",
  })->within($this);

  my $downstream_ack = &complement($downstream->get_signal_by_type("waitrequest"));
  my $downstream_readdatavalid = $downstream->get_signal_by_type("readdatavalid");

  my $a_readdatavalid = $a_upstream->get_signal_by_type('readdatavalid');
  my $b_readdatavalid = $b_upstream->get_signal_by_type('readdatavalid');
  my $a_read = $a_upstream->get_signal_by_type('read');
  my $b_read = $b_upstream->get_signal_by_type('read');




  my $fifo_depth =
    max($a_upstream->max_pending_reads(), $b_upstream->max_pending_reads());

  my $a_rdv_term;
  my $b_rdv_term;
  if ($fifo_depth)
  {
    my $read_fifo = $downstream_readdatavalid;
    my $max_burstcount = max(
      $a_upstream->get_port_width_by_type('burstcount'),
      $b_upstream->get_port_width_by_type('burstcount'),
    );

    my $slave_starts_reading = "slave_starts_reading";
    $this->get_and_set_once_by_name({
        thing => 'assign',
        name => $slave_starts_reading,
        lhs => $slave_starts_reading,
        rhs =>  &and_array($downstream_read, $downstream_select, $downstream_ack),
    });
    if ($max_burstcount > 1)
    {
      my $downstream_burstcount = $downstream->get_signal_by_type("burstcount");
      e_export->new({expression => $downstream_burstcount})->within($this);

       my $slave_name = $this->name();
       my $depth = $fifo_depth;
       my $slave_rdv = $downstream_readdatavalid;



       my $this_cycle_is_the_last_burst = "$slave_name\_this_cycle_is_the_last_burst";
       my $transaction_burst_count = "$slave_name\_transaction_burst_count";
       my $burstcount_fifo_empty = "$slave_name\_burstcount_fifo_empty";
       my $load_fifo = "$slave_name\_load_fifo";
       my $p0_load_fifo = "p0_" . $load_fifo;

       $this->get_and_set_once_by_name({
         thing => 'signal',
         name => $transaction_burst_count,
         width => $max_burstcount,
       });

       $this->get_and_set_once_by_name({
	   thing => 'fifo_with_registered_outputs',
           name  => "burstcount_fifo_for_$slave_name",
           depth => $depth,
           port_map => {
               data_in => $downstream_burstcount,
               data_out => $transaction_burst_count,




               write => &and_array($slave_starts_reading, $load_fifo,
                 complement(and_array($this_cycle_is_the_last_burst, $burstcount_fifo_empty))
               ),
               empty => $burstcount_fifo_empty,
               fifo_contains_ones_n => 'open',
               full => 'open',
               clear_fifo => "1'b0",
               read => $this_cycle_is_the_last_burst,
               sync_reset => "1'b0",
           },
       });

       my $current_burst = "$slave_name\_current_burst";
       my $current_burst_minus_one = "$slave_name\_current_burst_minus_one";
 
       $this->get_and_set_once_by_name({
	   thing => 'assign',
           name => "$slave_name current burst minus one",
           lhs => {name => $current_burst_minus_one, width => $max_burstcount, },
           rhs => "$current_burst - 1"
       });

       my $next_burst_count = "$slave_name\_next_burst_count";
       $this->get_and_set_once_by_name({
	   thing => 'mux',
           name => "what to load in current_burst, for $slave_name",
           lhs => {name => $next_burst_count, width => $max_burstcount, },
           add_table =>
             [ "$slave_starts_reading & ~$load_fifo"
                      => $downstream_burstcount,




                         "$slave_starts_reading & $this_cycle_is_the_last_burst & $burstcount_fifo_empty"
                             => $downstream_burstcount,
                         $this_cycle_is_the_last_burst => $transaction_burst_count,
                      ],
           default => $current_burst_minus_one,
       });

       $this->get_and_set_once_by_name({
           thing => 'register',
           name => "the current burst count for $slave_name, to be decremented",
           in  => $next_burst_count,
           out => {name => $current_burst, width => $max_burstcount, },
           enable => "$slave_rdv | (~$load_fifo & $slave_starts_reading)",
       });

       $this->get_and_set_once_by_name({
           thing => 'mux',
           name => 'a 1 or burstcount fifo empty, to initialize the counter',
           add_table =>
                      [
                        "~$load_fifo" => 1,
                        "$slave_starts_reading & $load_fifo" => 1, 


                      ],
           default => "~$burstcount_fifo_empty",
           out => $p0_load_fifo,
       });
 
       $this->get_and_set_once_by_name({
           thing => 'register',
           name => "whether to load directly to the counter or to the fifo",
           in => $p0_load_fifo,
           out => $load_fifo,
           enable => "$slave_starts_reading & ~$load_fifo | $this_cycle_is_the_last_burst", 
       });

       $this->get_and_set_once_by_name({
	   thing => 'assign',
	   name => "the last cycle in the burst for $slave_name",
           lhs => "$this_cycle_is_the_last_burst",
           rhs => "~(|$current_burst_minus_one) & $slave_rdv"
       });

       $read_fifo = "$this_cycle_is_the_last_burst & $load_fifo"; # move_on_to_next_transaction
    }

    e_fifo_with_registered_outputs->new({
      name => $this->name() . "_readdatavalid_fifo",
      depth => $fifo_depth,
      port_map => {
        data_in => $a_granted_this_time,
        write => $slave_starts_reading,
        read => $read_fifo,
        sync_reset => "1'b0",
        clear_fifo => "1'b0",
        fifo_contains_ones_n => 'open',
      },
    })->within($this);
  
    $a_rdv_term = "data_out";
    $b_rdv_term = "~data_out";

    $this->sink_signals('empty', 'full');
  }
  else
  {
    $a_rdv_term = "($a_granted_this_time & $a_read & $a_select & $downstream_ack)";
    $b_rdv_term = "($b_granted_this_time & $b_read & $b_select & $downstream_ack)";
  }

  e_assign->new({
    lhs => $a_readdatavalid,
    rhs => "$downstream_readdatavalid & $a_rdv_term"
  })->within($this);
  e_assign->new({
    lhs => $b_readdatavalid,
    rhs => "$downstream_readdatavalid & $b_rdv_term"
  })->within($this);



  $this->get_and_set_once_by_name({
    name => "only one grant at a time",
    thing => 'process',
    tag => 'simulation',
    contents => [
      e_if->new({
        condition => and_array($a_granted_this_time, $b_granted_this_time),
        then => [
          e_sim_write->new({
            spec_string => $this->name() . ": $a_granted_this_time, $b_granted_this_time are active simultaneously.",
            show_time => 1,
          }),
          e_stop->new(),
        ],
      }),
    ],
  });
}

=item I<make_default_assignments($)>

Muxes downstream signals by which upstream iface is granted.
                                 
=cut

sub assign_downstream_default
{
   my $this = shift;
   my ($downstream_signal, $upstream_signal, $downstream, $upstream) = @_;

   my ($a_granted_this_time) = $this->_get_grant_signals();

   my $mux = $this->get_and_set_thing_by_name({
     thing => 'mux',
     name => "$downstream_signal mux",
     comment => "mux $downstream_signal between a and b",
     lhs => $downstream_signal,
   });

   my $this_is_a_upstream =
     $upstream eq $this->get_object_by_name('a_upstream');
   if ($this_is_a_upstream)
   {
     $mux->add_table([$a_granted_this_time, $upstream_signal]);
   } 
   else
   {
      $mux->default($upstream_signal);
   }
}

1;
