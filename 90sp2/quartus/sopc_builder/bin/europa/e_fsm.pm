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

e_fsm - description of the module goes here ...

=head1 SYNOPSIS

The e_fsm class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_fsm;
@ISA = qw(e_module);
use europa_all;
use europa_utils;
use strict;

















































































my %fields = (
  TABLE => [],
  name => "unnamed_state_machine",
  OUTPUT_DEFAULTS => {},
  OUTPUT_WIDTHS => {},
  DEBUG => 0,
  start_state => undef,
  GENERATED => 0,
);

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );




=item I<dprint()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub dprint
{
  my $self = shift;
  
  $self->{DEBUG} && print STDERR @_;
}





=item I<_create_flipflop_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _create_flipflop_name
{
  my ($self, $st) = @_;
  
  my $name = $self->{name} . "_$st";
  $self->dprint("_create_flipflop_name returns '$name'\n");
  return $name;
}














=item I<add_state()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_state
{
  my $self = shift;
  my $new_state = shift;

  $self->dprint(ref($self) . "::add_state('$new_state')\n");
  
  if (!defined($new_state))
  {
    ::VppError("e_fsm::add_state() usage error: no new state name.\n");
  }
  
  if (0 >= @_)
  {
    ::VppError("e_fsm::add_state() usage error: no next state info.\n");
  }
  
  while (@_)
  {

    my $listref = shift;
    my @list = @{$listref};
    


    if (3 != @list)
    {
      ::VppError("e_fsm::add_state(): incorrect number of elements in next-state info.\n");
    }
    
    my @compat_list = ($list[0], $new_state, $list[1], $list[2]);
    $self->dprint("\tadding cur: '$new_state'; next: '$list[1]'\n");
    push @{$self->{TABLE}}, \@compat_list;
  }
}
















=item I<add_states()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_states
{
  my $self = shift;
  my $new_state = shift;
  my $num_states = shift;
  my $output_ref = shift;
  my @added_state_list = ();

  if (!defined($new_state) || !defined($num_states) || !defined($output_ref))
  {
    ::VppError("e_fsm::add_states() usage error: no new state name.\n");
  }
  
  if (0 >= @_)
  {
    ::VppError("e_fsm::add_states() usage error: no next state info.\n");
  }
  
  my $state_base_name = $new_state;

  $self->dprint(ref($self) . "::add_states('$new_state')\n");
  
  $self->dprint("adding $num_states states starting with '$new_state'\n");
  
  my $nextstate = $state_base_name;
  for my $i (0 .. $num_states - 1)
  {

    my $curstate =  sprintf("$state_base_name\_%d", $i);
    if (0 == $i)
    {
      $curstate = $state_base_name;
    }
    $nextstate =  sprintf("$state_base_name\_%d", $i + 1);


    my %outputs = %{$output_ref};
    
    $self->add_state(
      $curstate,
      [
      {},
      "$nextstate",
      \%outputs,
      ]
    );
    
    push @added_state_list, $nextstate;
  }


  $self->dprint("adding branch state.\n");
  $self->add_state(
    $nextstate,
    @_
  );

  push @added_state_list, $nextstate;
  


  return wantarray ? @added_state_list : pop(@added_state_list);
}





=item I<add_outputs()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_outputs
{
  my $self = shift;
  my ($state, $input_ref, $output_ref) = @_;
  
  my $success = 0;
  my %inputs = %{$input_ref};

  for my $i (0 .. -1 + @{$self->{TABLE}})
  {
    my $table_ref = $self->{TABLE};
    my $stt_ref = @{$table_ref}->[$i];
    my $curstate = @{$stt_ref}->[1];
    if (!defined($curstate))
    {
      print STDERR "failed to locate curstate at i = $i, state: '$state'\n";
    }
    
    if ($curstate eq $state)
    {
      my $existing_output_ref = @{$stt_ref}->[3];
      

      my $stt_inputs_ref = @{$stt_ref}->[0];
      my %stt_inputs = %{$stt_inputs_ref};

      my $match = 1;
      for my $signal (keys %inputs)
      {
        if (exists($stt_inputs{$signal}))
        {
          if ($stt_inputs{$signal} ne $inputs{$signal})
          {
            $match = 0;
          }
        }
      }
      
      if ($match)
      {


        for my $signal (keys %{$output_ref})
        {
          $existing_output_ref->{$signal} = $output_ref->{$signal};
        }
      }
    }
  }
}



=item I<get_next_state()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_next_state
{
  my $self = shift;
  my ($state, $input_ref) = @_;

  my %inputs = %{$input_ref};

  


  




  



  my @next_state = ();
  
  my @table = @{$self->{TABLE}};
  for my $i (0 .. -1 + @table)
  {
    my @stt = @{$table[$i]};
    
    ($stt[1] ne $state) and next;
    


    my %stt_inputs = %{$stt[0]};
    
    my $match = 1;
    for my $signal (keys %inputs)
    {
      if (exists($stt_inputs{$signal}))
      {
        if ($stt_inputs{$signal} ne $inputs{$signal})
        {
          $match = 0;
        }
      }
    }
    
    if ($match)
    {
      push @next_state, $stt[2];
    }
  }
  
  if (0 == @next_state)
  {
    return undef;
  }
  
  if (1 != @next_state)
  {
    ::VppError("Too many matches in get_next_state\n");
  }
  
  return $next_state[0];
}



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
  my ($self) = @_;


  if (!$self->{GENERATED})
  {
    $self->{GENERATED} = 1;












    my %state_value = ();  





    my %state_predecessors = ();




    my %state_successors = ();

    my $state_value = 0;



    my %inputs = ();
    my %outputs = ();
    

    for my $st_ref (@{$self->{TABLE}})
    {
      my $curstate = $st_ref->[1];
      my $nextstate = $st_ref->[2];

      my %input_assignments = %{$st_ref->[0]};
      my %output_assignments = %{$st_ref->[3]};


      @{\%inputs}{keys %input_assignments} = values %input_assignments;
      @{\%outputs}{keys %output_assignments} = values %output_assignments;

      if (!exists($state_value{$curstate}))
      {
        $state_value{$curstate} = $state_value++;  
      }

      if (!exists($state_value{$nextstate}))
      {
        $state_value{$nextstate} = $state_value++;  
      }


      my @pred_list;
      if (!exists($state_predecessors{$nextstate}))
      {
        @pred_list = ();
      }
      else
      {
        @pred_list = @{$state_predecessors{$nextstate}};
      }


      push @pred_list, [$curstate, $st_ref->[0]];
      $state_predecessors{$nextstate} = \@pred_list;




      my @succ_list;
      my $succ_list_ref;
      if (!exists($state_successors{$curstate}))
      {
        @succ_list = ();
      }
      else
      {
        $succ_list_ref = $state_successors{$curstate};
        @succ_list = @$succ_list_ref;
      }

      push @succ_list, $nextstate;
      $state_successors{$curstate} = \@succ_list;

    }





    for my $input_signal_name (keys %inputs)
    {
      
      $self->add_contents(
        e_port->new({
          name => $input_signal_name,
          direction => "input",
        })
      );
    }
    




    @{\%outputs}{keys %{$self->{OUTPUT_DEFAULTS}}} =
      values %{$self->{OUTPUT_DEFAULTS}};
    for my $output_signal_name (keys %outputs)
    {
      $self->add_contents(
        e_port->new({
          name => $output_signal_name,
          direction => "output",
          width => $self->{OUTPUT_WIDTHS}->{$output_signal_name},
        })
      );
    }
      




    for my $st (sort {$state_value{$a} <=> $state_value{$b}} keys %state_value)
    {
      my $state_flipflop_Q = $self->_create_flipflop_name($st);


      $self->dprint(" reg $state_flipflop_Q;\n");
    }








    for my $st (sort {$state_value{$a} <=> $state_value{$b}} keys %state_value)
    {




      my @pred_list = @{$state_predecessors{$st}};



      if ((0 == @pred_list) and ($st ne $self->{start_state}))
      {
        ::VppError("state '$st' has no predecessors");
      }


      my @succ_list = @{$state_successors{$st}};
      if (0 == @succ_list)
      {
        ::VppError("state '$st' has no successors");
      }



      $self->dprint("\n // State '$st': $state_value{$st}\n");
      $self->dprint(" // predecessors:\n");



      my @ff_d_terms = ();


      my $comment = "";
      for my $pred_el_ref (@pred_list)
      {
        my @pred_el = @{$pred_el_ref};


        my $term = "(" . $self->_create_flipflop_name($pred_el[0]) . " == 1)";

        $self->dprint(" //   $pred_el[0]: (");


        my %input_hash = %{$pred_el[1]};


        my @print_terms = ();
        for my $input_var (keys %input_hash)
        {
          $term .= " & ($input_var == $input_hash{$input_var})";
          push @print_terms, "$input_var == $input_hash{$input_var}";
        }

        $self->dprint(join " and ", @print_terms);
        $self->dprint(");\n");

        $term = "(" . $term . ")";        
        push @ff_d_terms, $term;
      }
      my $state_flipflop_Q = $self->_create_flipflop_name($st);
      my $input_expr = join " |\n", @ff_d_terms;

      my $this_state = e_register->new({
        comment => " Transitions into state '$st'.",
        name => $st,
        out => e_signal->new({name => $state_flipflop_Q, width => 1,}),
        in => $input_expr,



        async_value => ($st eq $self->{start_state}) ? 1 : 0,
      });


      $self->add_contents($this_state);
      $self->dprint("added state $state_flipflop_Q to fsm\n");
    }





















    my %output_values = ();

    for my $st_ref (@{$self->{TABLE}})
    {
      my $curstate = $st_ref->[1];
      my $nextstate = $st_ref->[2];
      my %output_assignments = %{$st_ref->[3]};




      my $output_name;
      for $output_name (keys %output_assignments)
      {
        my @assignments = ();

        if (exists($output_values{$output_name}))
        {


          @assignments = @{$output_values{$output_name}};
        }

        push @assignments,
          [$curstate,
          $output_assignments{$output_name},
          $st_ref->[0]];

        $output_values{$output_name} = \@assignments;
      }
    }



    for my $output_name (sort keys %output_values) 
    {
      my @mux_table = ();
      my @assignments = @{$output_values{$output_name}};

      $self->dprint("working on output '$output_name'\n");













      my %transition = ();
      for my $oa_ref (@assignments)
      {

        my $state_name = $self->_create_flipflop_name(@$oa_ref->[0]);
        my $state = @$oa_ref->[0];


        my %input_hash = %{@$oa_ref->[2]};
        my $output_value = @$oa_ref->[1];

        if (!exists($transition{$state}))
        {
          $transition{$state} = [];
        }

        push @{$transition{$state}}, [\%input_hash, $output_value];
      }




      for my $state (sort keys %transition)
      {

        my @list = grep {$state eq @{$_}->[1]} @{$self->{TABLE}};
        my $can_crush = 1;





        my $last_output = undef;
        if ((0 + @list) == (0 + @{$transition{$state}}))
        {

          my $io_pair;
          for $io_pair (@{$transition{$state}})
          {
            my @list_io_pair = @{$io_pair};
            my %input_hash = %{$list_io_pair[0]};
            my $output_value = $list_io_pair[1];

            if (!defined($last_output))
            {
              $last_output = $output_value;
            }
            else
            {
              if ($last_output ne $output_value)
              {
                $can_crush = 0;
              }
            }
          }
        }
        else
        {
          $can_crush = 0;
        }

        if ($can_crush)
        {

          if (1 != (0 + @{$transition{$state}}))
          {

            $self->dprint("crushing output '$output_name' in state '$state'\n");

            $transition{$state} = [];
            push @{$transition{$state}}, [{}, $last_output];
          }
        }
      }

      for my $state (sort keys %transition)
      {
        my $state_name = $self->_create_flipflop_name($state);

        $self->dprint("looking at state '$state_name'\n");

        for my $io_pair (@{$transition{$state}})
        {
          my @list_io_pair = @{$io_pair};
          my %input_hash = %{$list_io_pair[0]};
          my $output_value = $list_io_pair[1];

          my $this_expression = "($state_name";

          for my $input (sort keys %input_hash)
          {
            $this_expression .= " && ($input == $input_hash{$input})";
          }
          $this_expression .= ")";
          push @mux_table, $this_expression;

          $self->dprint("mux_table gets '$this_expression'\n");
          push @mux_table, $output_value;
          $self->dprint("mux_table gets '$output_value'\n");
        }
      }

      my $muxtype = "priority";
       

      if (!exists($self->{OUTPUT_DEFAULTS}->{$output_name}))
      {
        $muxtype = "and-or";
      }
      else
      {
        my $default = $self->{OUTPUT_DEFAULTS}->{$output_name};
        
        $default =~ s/^[\d\']*[bodhBODH]//;
        
        if ($default !~ /[^0]+/)
        {
          $muxtype = "and-or";
        }
      }

      my $this_mux = e_mux->new({
        lhs => e_signal->new({
          name => $output_name,
          width => $self->{OUTPUT_WIDTHS}->{$output_name},
        }),
        type => $muxtype,
        table => \@mux_table,
      });
     



      if (($muxtype ne "and-or") and
        exists($self->{OUTPUT_DEFAULTS}->{$output_name}))
      {
        $this_mux->default($self->{OUTPUT_DEFAULTS}->{$output_name});
      }

      $self->add_contents($this_mux);





      delete $self->{OUTPUT_DEFAULTS}->{$output_name};
    }



    for my $output_name (keys %{$self->{OUTPUT_DEFAULTS}})
    {

      $self->dprint(" assign $output_name = $self->{OUTPUT_DEFAULTS}->{$output_name};\n");
      my $this_assignment = e_assign->new({
        comment => " Output $output_name has a constant value.",
        lhs => e_signal->new(["$output_name"]),
        rhs => "$self->{OUTPUT_DEFAULTS}->{$output_name}",
      });

      $self->add_contents($this_assignment);
    }
  }
  

  $self->SUPER::update();
}

qq{
The time has come to say goodnight, 
My how time does fly. 
We've had a laugh, perhaps a tear, 
and now we hear goodbye. 

I really hate to say goodnight, 
for times like these are few. 
I wish you love and happiness, 
In everthing you do. 

The time has come to say goodnight, 
I hope I've made a friend. 
And so we'll say "May God bless you," 
Until we meet again. 

~~ Red Skelton ~~ 
};



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
