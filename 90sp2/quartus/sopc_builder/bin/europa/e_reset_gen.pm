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

e_reset_gen - description of the module goes here ...

=head1 SYNOPSIS

The e_reset_gen class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_reset_gen;
use e_process;
@ISA = ("e_process");
use strict;
use europa_utils;


my $__HASH_CHARACTER__ = '#';







my %fields = (
              reset_active => 0,
              ns_period    => 300,
              );

my %pointers = (
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
   $this->_reset()->direction('output');
   return $this;
}



=item I<reset_inactive()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub reset_inactive
{
   my $this = shift;
   return 1
       if ($this->reset_active() == 0);
   return 0
       if ($this->reset_active() == 1);

   &ribbit ("illegal value for reset_active, try 0 or 1");
}





=item I<get_ptf_reset_period()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_ptf_reset_period
{
   my $this = shift;


   my $clk_freq =
     $this->parent()->project()->system_ptf()->
       {WIZARD_SCRIPT_ARGUMENTS}->{clock_freq};
   if ($clk_freq)
   {
     my $exact_period = 10e9 / $clk_freq;

     $exact_period = 5 * ceil($exact_period / 5);
     $this->ns_period($exact_period);
   }
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
   my $this = shift;
   my $indent = shift;
   my $reset_name = $this->reset()->expression();
   $this->get_ptf_reset_period();
   my $ns = $this->ns_period();
   my $reset_active = $this->reset_active();
   my $reset_inactive = $this->reset_inactive();

   my $vs = qq
[initial 
  begin
    $reset_name <= $reset_active;
    $__HASH_CHARACTER__$ns $reset_name <= $reset_inactive;
  end
];








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
   my $reset_name = $this->reset()->expression();
   $this->get_ptf_reset_period();
   my $ns = $this->ns_period();
   my $reset_active = $this->reset_active();
   my $reset_inactive = $this->reset_inactive();

   my $vs = qq
[PROCESS
  BEGIN
     $reset_name <= '$reset_active';
     wait for $ns ns;
     $reset_name <= '$reset_inactive'; 
  WAIT;
END PROCESS;
];


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
