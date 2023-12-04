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

e_lcell - description of the module goes here ...

=head1 SYNOPSIS

The e_lcell class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_lcell;
use europa_utils;

use e_instance;
use e_module;
@ISA = qw (e_instance);

use strict;







my $unused_port_tag = 'open';

my %fields = (
              );


my $id_counter = 1;
my %pointers = ();
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
   $this = $this->SUPER::new();
   $this->set({
              port_map          => 
              {
                 clk     => $unused_port_tag,
                 dataa   => $unused_port_tag,
                 datab   => $unused_port_tag,
                 datac   => $unused_port_tag,
                 datad   => $unused_port_tag,
                 aclr    => $unused_port_tag,
                 sclr    => $unused_port_tag,
                 sload   => $unused_port_tag,
                 ena     => $unused_port_tag,
                 cin     => $unused_port_tag,
                 cascin  => $unused_port_tag,
                 combout => $unused_port_tag,
                 regout  => $unused_port_tag,
                 cout    => $unused_port_tag,
                 cascout => $unused_port_tag,
              }, 
              parameter_map => 
              {
                 operation_mode => "counter",
                 output_mode    => "comb_and_reg",
                 packed_mode    => "false",
                 lut_mask       => "ffff",
                 power_up       => "low",
                 cin_used       => "false",
              },
              module => 'apex20k_lcell',
           });

   $this->set(@_);
   return $this;
}



=item I<parameter_map()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub parameter_map
{
   my $this = shift;
   
   if (@_)
   {
     my $h = shift;
     



     my $hash;
     for my $key (keys %$h)
     {




       my $val = $h->{$key};

       if ($key eq 'lpm_type' and $val =~ /yeager/i)
       {

         $this->module('yeager_lcell');



         next;
       }
       

       next if $key eq 'lpm_type';
       

       next if $key eq 'id';
       


       if ($val !~ /^".*"$/)
       {
         $val = qq("$val");
       }
       
       $hash->{$key} = $val;
     }
     return $this->SUPER::parameter_map($hash);
   }
   
   return $this->SUPER::parameter_map();
}



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
  my $this = shift;
  my $parent = $this->parent(@_);

  my $project = $this->parent_module()->project();


  my $module_name =
    $project->add_signatured_apex20k_blind_instance(
      $this->port_map(),
      $unused_port_tag
    );


  $this->module($module_name);
  $this->SUPER::update(@_);
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

The inherited class e_instance

=begin html

<A HREF="e_instance.html">e_instance</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
