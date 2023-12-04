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

e_clk_gen - description of the module goes here ...

=head1 SYNOPSIS

The e_clk_gen class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_clk_gen;
use e_expression;
use e_process;
@ISA = ("e_process");
use strict;
use europa_utils;


my $__HASH_CHARACTER__ = '#';







my %fields = (
              _clk => e_expression->new("clk"),
              ns_period => 30,
              );

my %pointers = (
               );

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<clk()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub clk
{
   my $this = shift;
   my $clk = $this->_clk();
   if (@_)
   {
      $clk->set(@_);
      $clk->direction('output');
      $clk->parent($this);
   }
   return $clk;
}



=item I<_ns_timescale_multiplier()>

References the current timescale, and returns a multiplier to convert the base
period. 

Example: 
If the current timescale is "1ps", then it would return 1000. (1ns=1000ps).
If the current timescale is "1s", then it would return 0.000000001 (1ns=0.000000001s).

=cut

sub _ns_timescale_multiplier
{
  my $this = shift;
  my $timescale_directive =  shift || $this->project()->timescale();
  my ($base_delay, $timescale) = $this->split_timescale($timescale_directive);


  my $base_multi;
  if ($timescale =~ /^s/)   { $base_multi = 0.000000001; }
  elsif($timescale =~ /^ms/){ $base_multi = 0.000001; }
  elsif($timescale =~ /^us/){ $base_multi = 0.001; }
  elsif($timescale =~ /^ns/){ $base_multi = 1; }
  elsif($timescale =~ /^ps/){ $base_multi = 1000; }
  elsif($timescale =~ /^fs/){ $base_multi = 1000000; }

  my $multiplier = $base_multi / $base_delay;
  return $multiplier;
}



=item I<split_timescale()>

Given a timescale, separates passed-in timescale into 2-element list of (base,
time unit).

=cut

sub split_timescale
{
  my $this = shift;
  my $timescale_directive = shift or &ribbit ("no timescale provided");
  $timescale_directive =~ /^\s*(\d+)\s*(s|ms|us|ns|ps|fs)\s*\/.*$/;
  return ($1, $2);
}



=item I<convert_ns_period_to_local_timescale_delay()>

Given a ns period (simple number), it converts it into a string based on the
current timescale. Needed by VHDL to specify in absolute terms how long a delay
is.

=cut

sub convert_ns_period_to_local_timescale_delay
{
  my $this = shift;
  my $ns_period = shift || $this->ns_period();
  my $timescale_directive = $this->project()->timescale();
  my ($base_delay, $timescale) = $this->split_timescale($timescale_directive);
  my $ns_conversion = $this->_ns_timescale_multiplier($timescale_directive);


  my $delay = $ns_period * $ns_conversion * $base_delay;
  return "$delay $timescale";
}



=item I<convert_ns_period_to_local_timescale_ticks()>

Returns a number representing the period according to the local timescale.
Verilog needs to express periods as units in terms things in terms of the local
timescale. 

You are NOT allowed to set the period with this method, because most
likely a project and parent are not associated with this e_clk_gen, so we
won't be able to fetch the current timescale, so we won't be able to
figure out the correct period<->ns_period calculations. 

=cut

sub convert_ns_period_to_local_timescale_ticks
{
  my $this = shift;
  my $ns_period = shift || $this->ns_period();
  my $timescale_directive = $this->project()->timescale();
  my $ns_conversion = $this->_ns_timescale_multiplier($timescale_directive);
  my $number = $ns_period * $ns_conversion;
  return $number;
}




=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
   my $this = shift;
   my $indent = shift;
   
   my $clk_name = $this->clk()->expression();



   my $ns_period = $this->ns_period();
   my $ns = $this->convert_ns_period_to_local_timescale_ticks($ns_period);
   my $half_ns = &ceil($ns/2 - .5);

   my $vs =
"initial
  $clk_name = 1'b0;
always
  $__HASH_CHARACTER__$half_ns $clk_name <= ~$clk_name;

";

  if ($half_ns != int(($ns/2) + .5)) {
    my $half_ns_plus_one = int(($ns/2) + .5);

    $vs =
"initial
  $clk_name = 1'b0;
always
   if ($clk_name == 1'b1) 
  $__HASH_CHARACTER__$half_ns $clk_name <= ~$clk_name;
   else 
  $__HASH_CHARACTER__$half_ns_plus_one $clk_name <= ~$clk_name;

";
      
  } else {

  }







   $vs =~ s/^/$indent/mg;
   return ($vs);
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
   my $this = shift;
   my $indent = shift;

   my $clk_name = $this->clk()->expression();
   my $ns = $this->ns_period();
   my $half_ns = ceil($ns/2 - .5);

   my $half_ns_str = 
      $this->convert_ns_period_to_local_timescale_delay($half_ns);

   my $vs = 
"process
begin
  $clk_name <= '0';
  loop
     wait for $half_ns_str;
     $clk_name <= not $clk_name;
  end loop;
end process;
";

  if ($half_ns != int(($ns/2) + .5)) {
    my $half_ns_plus_one = int(($ns/2) + .5);

    my $half_ns_plus_one_str =
        $this->convert_ns_period_to_local_timescale_delay($half_ns_plus_one);

    $vs =
"process
begin
  $clk_name <= '0';
  loop
     if ($clk_name = '1') then
        wait for $half_ns_str;
        $clk_name <= not $clk_name;
     else
        wait for $half_ns_plus_one_str;
        $clk_name <= not $clk_name;
     end if;
  end loop;
end process;
";
  } else {

  }


   $vs =~ s/^/$indent/mg;
   return ($vs);
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

The inherited class e_process

=begin html

<A HREF="e_process.html">e_process</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
