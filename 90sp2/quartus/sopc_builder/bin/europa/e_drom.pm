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

e_drom - description of the module goes here ...

=head1 SYNOPSIS

The e_drom class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_drom;
use _e_auto_file_read;
use e_expression;
use e_thing_that_can_go_in_a_module;
@ISA = ("e_instance");

use strict;
use europa_utils;





my %fields = (
              tag => "simulation",
              dat_name => undef,
              mutex_name => undef,
	      interactive=> 0,
              rom_size   => 1024,
              poll_rate => 100,
              readmemb => 0,
              );

my %pointers = (
                _module_ref => e_module->dummy(),
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
   my $this  = shift;
   my $self = $this->SUPER::new(@_);
   $self->set_up_module();
   return $self;
}



=item I<set_up_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub set_up_module
{
    my $this = shift;
    my $name = $this->name or &ribbit ("No name");


    my $module = e_module->new
        ({ name  => "${name}_module",

           contents => [ 
                         e_port->news
                         ( 
                           [ "clk" ], # defaults to width 1 input
                           [ "reset_n" ],
                           [ "incr_addr" ],
                           [ "new_rom", 1, "output" ],
                           [ "safe", 1, "output" ],
                           ),
                         e_port->new
                         (
                          { 
                              name => "q",
                              width => 8,
                              copied => 1,
                              direction => "output",
                          },
                          ),

                         e_parameter->new
                         (
                          {
                              name => "POLL_RATE",
                              default => $this->poll_rate(),
                              vhdl_type => "integer",
                          },
                          ),
                         e_assign->new
                         (
                          {
                              lhs => "q",
                              rhs => "mem_array\[address\]",
                              tag => "simulation",
                          },
                          ),

                         e_signal->news
                         (
                          {
                              name => "mem_array",
                              depth => $this->rom_size(),
                              width => 8,
                              copied => 1,
                          },
                          { 
                              name => "mutex",
                              depth=> 2,
                              width=> 32,
                          },
                          ),


                         e_signal->new
                         ({
                             name => "num_bytes",
                             width => 32,
                             export => $this->readmemb,
                             never_export => ($this->readmemb ? 0 : 1),
                         }),

                         e_signal->news
                         (
                          {
                              name => "mutex_handle",
                              width=> 32,
                          },
                          {
                              name => "poll_count",
                              width=> 32,
                          },
                          {
                              name => "address",
                              width=> &Bits_To_Encode($this->rom_size()),
                          },
                          ),
                         e_register->new
                         (
                          {
                              out => "new_rom",
                              in  => "pre",
                              enable=> 1,
                              delay=> 10,
                              tag => "simulation",
                          }
                          ),

                         
                         _e_auto_file_read->new
                         (
                          {
                              dat_name => $this->dat_name,
                              mutex_name=>$this->mutex_name,
			      interactive=>$this->interactive,
                              readmemb => $this->readmemb,
                              addrbits => &Bits_To_Encode($this->rom_size()),
                          }
                          ),
                         ]
                         });
    
    $this->module($module);
    
} # set_up_module


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
