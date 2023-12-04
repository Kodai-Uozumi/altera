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

package e_adapter_master_y;

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

=item I<_make_read_pending_counter($)>

Takes a string ("low"|"high") makes a counter which counts outstanding
reads and returns a string representing a signal name.  We avoid out
of order reads by inhibiting reads to the other branch when reads are
still outstanding on this one.  Not knowing latency of the branches,
the best thing to do is wait.

A future enhancement is to verify that there is a readable slave
somewhere down the branch.  If not, then we should just return 0.

=cut

sub _make_read_pending_counter($$)
{
   my $this = shift;
   my $low_or_high = shift;

   my $iface_name = "${low_or_high}_downstream";
   my $iface = $this->get_object_by_name($iface_name);
   $iface || &ribbit ("couldnt find $iface_name");

   my $sel  = $iface->get_signal_by_type("chipselect");
   my $read = $iface->get_signal_by_type("read");
   my $wait = $iface->get_signal_by_type("waitrequest");
   my $rdv  = $iface->get_signal_by_type("readdatavalid");





  my $counter = "outstanding_reads_to_$low_or_high\_branch";
  my $addend = "${low_or_high}_addend";

  my $counter_width = 1 + &Bits_To_Encode
      ($iface->max_pending_reads());

  e_signal->new({
     name  => $counter,
     width => $counter_width,
  })->within($this);

  e_signal->new({
     name  => $addend,
     width => $counter_width,
  })->within($this);

  my $read_transaction = 
      "($sel && $read && !$wait)";

  e_register->new({
     comment   => "counter for $low_or_high branch outstanding reads",
     out       => $counter,
     in        => "$counter + $addend",
     enable    => 1
  })->within($this);

  e_mux->new({
     comment => "amount to increment $low_or_high counter",
     lhs     => $addend,
     add_table => 
         ["$read_transaction && !$rdv" =>  1,
          "!$read_transaction && $rdv" => -1,],
     default => 0,
  })->within($this);

   my $read_pending = "${low_or_high}_read_pending";
   e_assign->new({
      comment => "non-zero counter means read is pending",
      lhs => [$read_pending => 1],
      rhs => "|$counter",
   })->within($this);

   return $read_pending;
}

=item I<make_special_assignments($)>

=cut

sub make_special_assignments($)
{
  my $this = shift;





  my $high_downstream_name = "high_downstream";
  my $high_downstream = $this->get_object_by_name($high_downstream_name);
  my $low_downstream_name = "low_downstream";
  my $low_downstream = $this->get_object_by_name($low_downstream_name);
  my $upstream = $this->get_object_by_name("upstream");




  my $high_sel = $high_downstream->get_signal_by_type("chipselect");
  my $low_sel  = $low_downstream ->get_signal_by_type("chipselect");
  my $upstream_sel = $upstream   ->get_signal_by_type("chipselect");

  my $high_read = $high_downstream->get_signal_by_type("read");
  my $low_read  = $low_downstream ->get_signal_by_type("read");
  my $upstream_read = $upstream   ->get_signal_by_type("read");

  my $high_wait = $high_downstream->get_signal_by_type("waitrequest");
  my $low_wait  = $low_downstream ->get_signal_by_type("waitrequest");
  my $upstream_wait = $upstream   ->get_signal_by_type("waitrequest");

  my $upstream_address = $upstream->get_signal_by_type("address");


  e_export->new({expression => $low_sel})->within($this);
  e_export->new({expression => $high_sel})->within($this);
  e_export->new({expression => $low_read})->within($this);
  e_export->new({expression => $high_read})->within($this);




  my $low_read_pending  = $this->_make_read_pending_counter("low");
  my $high_read_pending = $this->_make_read_pending_counter("high");

  my ($range, $value) = $this->get_address_selection($high_downstream_name);
  e_assign->new({
     comment => "select high addresses",
     lhs => $high_sel,
     rhs => &and_array(
       $upstream_sel,
       "(!$upstream_read || !$low_read_pending)",
       "($upstream_address\[$range] == $value)",
     )
  })->within($this);

  ($range, $value) = $this->get_address_selection($low_downstream_name);
  e_assign->new({
     comment => "select low addresses.",
     lhs => $low_sel,
     rhs => &and_array(
       $upstream_sel,
       "(!$upstream_read || !$high_read_pending)",
       "($upstream_address\[$range] == $value)",
    )
  })->within($this);



  my $comment = "wait upstream based upon who is selected.  ".
      "Avalon automatically ands waitrequest with select. So default ".
      "is to wait.";

  e_mux->new({
     comment => $comment,
     lhs => $upstream_wait,
     add_table => [$low_sel  => $low_wait,
                   $high_sel => $high_wait,
                   ],
     default => 1,
  })->within($this);
}

=item I<get_address_selection($$)>

parameter: master interface name (low_downstream, high_downstream)

Return two assignments from the specified WSA section:
$range: a range of address indices, e.g.
  "12"
  "14:10"
($range is suitable for selecting a slice of a signal:
upstream_address[$range].)

$value: the value which occurs in the specified address subrange when the
specified slave is selected, e.g.
  "0"
  "1"
  "0x1F"

($value is specified as a perl constant, i.e. leading 0 -> octal,
leading 0x -> hex, otherwise decimal.)
=cut

sub get_address_selection($$)
{
  my $this = shift;
  my $low_or_high = shift;

  my $range;
  my $value;

  my $WSA =
    $this->project()->system_ptf()->{"MODULE ". $this->name()}->
    {WIZARD_SCRIPT_ARGUMENTS};

  my $range_key = "$low_or_high\_address_range";
  $range = $WSA->{$range_key};
  ribbit("range expression '$range_key' not set") if $range eq '';
  my $value_key = "$low_or_high\_address_value";
  $value = $WSA->{$value_key};
  ribbit("value expression '$value_key' not set") if $value eq '';


  $value = oct($value) if $value =~ /^0/;

  return ($range, $value);
}

=item I<make_default_assignments($)>

Mux all returning signals by branch rdv.
                                
=cut

sub assign_upstream_default
{
   my $this = shift;
   my ($upstream_signal, $downstream_signal, $upstream, $downstream) = @_;

   my $rdv  = $downstream->get_signal_by_type("readdatavalid");
 
   $this->get_and_set_thing_by_name({
     thing => 'mux',
     name => "$upstream_signal mux",
     comment => "mux return values between low and high",
     lhs => $upstream_signal,
     add_table => [$rdv, $downstream_signal], 
   });
}

1;
