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

e_std_synchronizer.pm 

=cut


package e_std_synchronizer;
use e_default_module_marker;
use europa_utils;
use e_thing_that_can_go_in_a_module;
@ISA = qw(e_thing_that_can_go_in_a_module);

use strict;

my %fields = (
  data_in          => undef,
  data_out         => undef,
  clock            => undef,
  reset            => undef,
  reset_n          => undef,
  comment          => '',
  depth            => 2,
);

my %pointers = ();

&package_setup_fields_and_pointers(__PACKAGE__,
				   \%fields,
				   \%pointers,
				  );


sub add
{
  my $this = shift;
  my @new_stuff = $this->new(@_);
  e_default_module_marker->add_contents(@new_stuff);
  return @new_stuff;
}

sub write_modules
{
  write_verilog();
  write_vhdl();
}


sub new 
{
  my $this = shift;
  my $self = $this->SUPER::new(@_);

  return ($self->get_contents());
}

sub _make_synchronizer_regs
{
  my $this = shift;
  my ($signals) = @_;

  my $reset_level = 0;
  my $reset = $this->reset_n();
  if ($reset eq '')
  {
    $reset = $this->reset();
    if ($reset ne '')
    {
      $reset_level = 1;
    }
    else
    {
      $reset_level = undef;
    }
  }

  my @signal_list = @$signals;

  my @regs = ();
  for my $i (0 .. -2 + $#signal_list)
  {
    push @regs, {
      comment => $this->comment(),


      out => $signal_list[$i + 1],
      in => $signal_list[$i],
      clock => $this->clock(),
      reset => $reset,
      reset_level => $reset_level,
      enable => "1",

    }
  }



  my $data_out = {

    out => $signal_list[$#signal_list],
    in => $signal_list[$#signal_list - 1],
    clock => $this->clock(),
    reset => $reset,
    reset_level => $reset_level,
    enable => "1",

  };

  push @regs, $data_out;

























  map {$_->{tag} = 'simulation'} @regs;
  return @regs;
}

sub validate
{
  my $this = shift;

  if ($this->depth() < 2)
  {
    ribbit(
      __PACKAGE__ . 
      "::validate(): invalid depth (" . 
      $this->depth() . 
      ")\n"
    );
  }

  if (($this->reset() ne '') && ($this->reset_n() ne ''))
  {
    ribbit(
      __PACKAGE__ . 
      "::validate(): invalid: both reset and reset_n are defined." .
      "\n"
    );
  }

  if (($this->clock() eq ''))
  {
    ribbit(
      __PACKAGE__ . 
      "::validate(): invalid: clock is undefined." .
      "\n"
    );
  }
}

sub get_contents
{
  my $this = shift;
  
  $this->validate();

  my @contents = ();
  my $reset_assignment;
  if ($this->reset())
  {
    my $sig = e_signal->new();
    my $name = $sig->_unique_name("complemented_reset");
    $sig->name($name);

    my $assign = e_assign->new({
      lhs => $sig,
      rhs => complement($this->reset()),
    });
    $reset_assignment = $sig;

    push @contents, $sig;
    push @contents, $assign;
  }
  elsif ($this->reset_n())
  {
    $reset_assignment = $this->reset_n();
  }
  else
  {
    my $sig = e_signal->new();
    my $name = $sig->_unique_name("unused_reset");
    $sig->name($name);
    my $assign = e_assign->new({
      lhs => $sig,
      rhs => "1'b1",
    });
    $reset_assignment = $sig;

    push @contents, $sig;
    push @contents, $assign;
  }

  my $ebi = e_blind_instance->new({
    module => 'altera_std_synchronizer',
    in_port_map => {
      clk => $this->clock(),
      reset_n => $reset_assignment,
      din => $this->data_in(),
    },
    out_port_map => {
      dout => $this->data_out(),
    },
    parameter_map => {
      depth => $this->depth(),
    },
  });

  push @contents, $ebi;

  return @contents;
}

1;

