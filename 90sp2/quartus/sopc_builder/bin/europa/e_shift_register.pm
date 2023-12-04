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

e_shift_register - description of the module goes here ...

=head1 SYNOPSIS

The e_shift_register class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_shift_register;

use europa_utils;
use e_expression;
use e_assign;
use e_register;
use e_thing_that_can_go_in_a_module;

@ISA = qw (e_thing_that_can_go_in_a_module);

use strict;








my %fields = (
              serial_in            => e_expression->new(),
              serial_out           => e_expression->new(),
              parallel_in          => e_expression->new(),
              parallel_out         => e_expression->new(),
              load                 => e_expression->new(),
              shift_enable         => e_expression->new("1"),

              shift_length         => 0,

              _built               => 0,
              _register            => e_register->new(),
              _mux                 => e_mux->new(),
              _serial_assignment   => e_assign->new(),
              _parallel_assignment => e_assign->new(),
              _parallel_out_signal => e_signal->new(),
              _direction           => 'MSB-first',
              );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<clock()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub clock       {my $this = shift; return $this->_register()->clock      (@_);}


=item I<enable()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub enable      {my $this = shift; return $this->_register()->enable     (@_);}


=item I<async_set()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub async_set   {
    my $this = shift; 
    my $return_value = $this->_register()->async_set  (@_);
    return $return_value;}







=item I<async_value()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub async_value {my $this = shift; return $this->_register()->async_value(@_);}



=item I<sync_set()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub sync_set    {my $this = shift; return $this->_register()->sync_set   (@_);}


=item I<sync_reset()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub sync_reset  {my $this = shift; return $this->_register()->sync_reset (@_);}



=item I<direction()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub direction
{

  my $this       = shift;

  my $return = $this->_direction(@_);
  if (@_)
  {
     my $dir_string = $_[0];

     $dir_string = "LSB-first" if $dir_string =~ /^right$/;
     $dir_string = "MSB-first" if $dir_string =~ /^left$/;

     if ($dir_string) {
        &ribbit ("Illegal shift-register direction: $dir_string",
                 "   Must be 'MSB-first' or 'LSB-first'")
            unless $dir_string =~ /^(M|L)SB-first/i;
     }
  }
  return $return;
}



=item I<build()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub build
{
  my $this = shift;

  return if $this->_built();


  $this->_unique_name ("shift", 
                       $this->parallel_out()->expression(),
                       $this->serial_out()->expression());




  foreach my $member ($this->get_fields()) {
    next unless &is_blessed ($member) && $member->isa("e_expression");
    $member->update();
  }



  &ribbit ("suspicious shift-register with no serial/parallel inputs")
    if ($this->parallel_in()->is_null() && 
        $this->serial_in()->is_null()     );

  &ribbit ("suspicious shift-register with no serial/parallel outputs")
    if ($this->parallel_out()->is_null() && 
        $this->serial_out()->is_null()     );



  &ribbit ("suspicious shift-register with parallel-in but no 'load' signal")
    if (!$this->parallel_in()->is_null() &&
        $this->load()->is_null()           );

  &ribbit ("bad shift-register length: ", $this->shift_length()) 
    if $this->shift_length() < 2;




  $this->parallel_in()->expression("0") if $this->parallel_in()->is_null();
  $this->serial_in()->expression("0")   if $this->serial_in()->is_null();



  my $reg_in_signal  = e_signal->new ({name  => $this->_unique_name() . "_in",
                                       width => $this->shift_length(),
                                     });
  my $reg_out_signal = e_signal->new ({name  => $this->_unique_name() . "_out",
                                      width => $this->shift_length(),
                                     });












  if ( $this->parallel_out()->isa_signal_name())
  {
    $this->_parallel_out_signal({name  => $this->parallel_out()->expression(),
                                 width => $this->shift_length(),
                                });
  }





  my $shiftie_expression = "";
  if ($this->direction() =~ /^lsb/i) {
    my $top = $this->shift_length() - 1;
    $shiftie_expression = &concatenate
      (
       $this->serial_in()->expression(),
       $reg_out_signal->name() . "\[ $top : 1\]",
      );

    $this->_serial_assignment({lhs => $this->serial_out(),
                               rhs => $reg_out_signal->name() . '[0]',
                              });
  } else {
    my $top = $this->shift_length() - 2;
    $shiftie_expression = &concatenate 
      (
       $reg_out_signal->name() . "\[ $top :0\]",
       $this->serial_in()->expression(),
      );

    my $msb = $this->shift_length() - 1;
    $this->_serial_assignment({lhs => $this->serial_out(),
                               rhs => $reg_out_signal->name()."\[$msb\]",
                              });
  }

  $this->_mux({
        lhs    => $reg_in_signal,
        table  => [ ],  # blank table, filled in below.
        default => $reg_out_signal,
        });

  $this->_mux->add_table ($this->load(), $this->parallel_in() )
    if (! $this->load()->is_null()) ;
  $this->_mux->add_table ($this->shift_enable(), $shiftie_expression);


  $this->_register->set({
        name  => $this->name() . "_reg",
        in    => $reg_in_signal,
        out   => $reg_out_signal,
  });

  $this->_parallel_assignment({lhs => $this->parallel_out(),
                               rhs => $reg_out_signal,
                              });

  $this->_built(1);
}



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
   my $this = shift;
   my $parent = $this->parent(@_);

   my $pm = $this->parent_module();
   $this->build();
   $pm->add_contents($this->_register(),
                         $this->_mux(),
                        );

   $pm->add_contents ($this->_parallel_assignment(),
                      $this->_parallel_out_signal(),
                      )
       unless $this->parallel_out()->is_null();

   $pm->add_contents ($this->_serial_assignment())
     unless $this->serial_out()->is_null();
}


1; # Must say 1.

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
