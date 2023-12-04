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

e_cascade_chain - description of the module goes here ...

=head1 SYNOPSIS

The e_cascade_chain class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_cascade_chain;
use europa_utils;
use e_lcell;
use e_signal;

@ISA = qw (e_thing_that_can_go_in_a_module);

use strict;

my $id_counter = 0;

my %fields = (
              combout              => "",
              regout               => "",
              le_list              => [],
              


              clk               => "clk",
              ena               => "clk_en",
              aclr              => "~reset_n",

              sclr              => "open",
              sload             => "open",

              _built            => 0,
              );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );










=item I<build()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub build 
{
   my $this = shift;
   &ribbit ("didn't expect unexpected arguments") if @_;
   &ribbit ("Hey! Quit that.") if $this->_built();

   $this->_built(1);

   my @result = ();   # Everything we build will go here.



   &ribbit ("No output") unless ($this->combout() || $this->regout());

   my (@LEs)    = (@{$this->le_list()});
   my $casc_len = scalar (@LEs) or &ribbit ("No LEs.");

   my $casc_chain = $this->_unique_name("cascade_chain");


   push (@result, e_signal->new ([$casc_chain => $casc_len - 1]))
       if $casc_len > 1;
   





   my $output_LE = $this->_build_basic_le_from_hash ($LEs[0]);
   $output_LE->port_map ({cascin => "$casc_chain\[0]"}) if $casc_len > 1;
   $output_LE->port_map ({combout => $this->combout()}) if $this->combout();
   if ($this->regout())
   {

      $output_LE->port_map ({regout => $this->regout(),
                             clk    => $this->clk(),
                             aclr   => $this->aclr(),
                             ena    => $this->ena(),
                             sclr   => $this->sclr(),
                             sload  => $this->sload(),   });
      $output_LE->parameter_map ({output_mode => "comb_and_reg"});
   }
   push (@result, $output_LE);



   foreach my $i (1..$casc_len - 2)
   {
      my $middle_LE = $this->_build_basic_le_from_hash($LEs[$i]);
         $middle_LE->port_map ({cascout => "$casc_chain\[$i-1]",
                                cascin  => "$casc_chain\[$i]",});      
      push (@result, $middle_LE);
   }



   if ($casc_len > 1) { 
      my $last_LE = $this->_build_basic_le_from_hash($LEs[$casc_len-1]);
         $last_LE->port_map ({cascout => "$casc_chain\[$casc_len-2]"});
      push (@result, $last_LE);
   }
                      
   return @result;
}



=item I<_port_map_from_le_hash()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _port_map_from_le_hash
{
   my $this = shift;  # Not used.  You may call this statically.
   my $le_hash = shift or &ribbit ("LE-hash argument required.");
   my $pmap = {dataa   => $le_hash->{a},
               datab   => $le_hash->{b},
               datac   => $le_hash->{c},
               datad   => $le_hash->{d},
              };
   $pmap->{combout} = $le_hash->{combout} if $le_hash->{combout};
   return $pmap;
} 



=item I<_build_basic_le_from_hash()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _build_basic_le_from_hash
{
   my $this = shift;  # Not (exactly) used.  You may call this statically.
   my $le_hash = shift or &ribbit ("LE-hash argument required.");
   return 
       e_lcell->new ({port_map => $this->_port_map_from_le_hash ($le_hash),
                      parameter_map => 
                         {lut_mask       => $le_hash->{mask},
                          operation_mode => "normal",
                          output_mode    => "comb",   
                          id             => $id_counter++,
                         },
                       });
}



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
   my $this = shift;
   my $parent = $this->parent(@_);

   return if $this->_built();

   my $pm = $this->parent_module();
   my @things = $this->build();

   map {$_->tag($this->tag())} @things;
   $pm->add_contents (@things);
}

"My friends, no one, not in my situation, can appreciate my feeling of
sadness at this parting. To this place, and the kindness of these
people, I owe everything. Here I have lived a quarter of a century,
and have passed from a young to an old man. Here my children have been
born, and one is buried. I now leave, not knowing when, or whether
ever, I may return, with a task before me greater than that which
rested upon Washington. Without the assistance of the Divine Being who
ever attended him, I cannot succeed. With that assistance I cannot
fail. Trusting in Him who can go with me, and remain with you, and be
everywhere for good, let us confidently hope that all will yet be
well. To His care commending you, as I hope in your prayers you will
commend me, I bid you an affectionate farewell.";





              

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
