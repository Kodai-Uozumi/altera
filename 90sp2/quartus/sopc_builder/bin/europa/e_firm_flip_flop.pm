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

e_firm_flip_flop - description of the module goes here ...

=head1 SYNOPSIS

The e_firm_flip_flop class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_firm_flip_flop;
use e_instance;
use e_register;
@ISA = ("e_instance");

use strict;
use europa_utils;

my $index = 0;




my %fields = (
              fast_in  => 0,
              fast_out => 0,
              port_map => {clk_en => 1},
              reset_level => e_expression->new(),
              );

my %pointers = (
                _module_ref => e_module->new
                ({
                   contents => 
                       [
                        e_port->news([clrn   => 1, "input"],
                                     [clk_en => 1, "input"],
                                     [prn    => 1, "input"],
                                     ),
                        ],
                    }),
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
   $self->_set_up_module();

   return $self;
}



=item I<set_ports()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub set_ports
{
   my $this      = shift;
   my $port_hash = shift;

   my $d = $port_hash->{d} or &ribbit ("no d");
   my $q = $port_hash->{q} or &ribbit ("no q");

   if ($q =~ s/\~//)
   {
      $this->port_map(prn => "reset_n");
      $this->port_map(clrn => 1);
      $d = &complement($d);
   }
   else
   {
      $this->port_map(clrn => "reset_n");      
      $this->port_map(prn => 1);
   }

   $this->port_map(d => $d, 
                   q => $q);

}



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
   my $this = shift;
   my $parent = $this->parent(@_);

   my $mod_name = $this->parent_module()->_project()->top()->name()
       ."__dffe_".$index++;

   $this->_module_ref()->name($mod_name);

   $this->SUPER::update();
}



=item I<_set_up_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _set_up_module
{
   my $this = shift;

   my $module = $this->_module_ref();

   $module->add_contents
       (
        e_port->new([prn => 1, "input"]),
        e_register->new
        ({
           tag   => "simulation",
           reset => "clrn",
           in    => "d",
           out   => "q",
        })
        );

   $module->do_black_box(1);
}



=item I<_add_compilation_to_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _add_compilation_to_module
{
   my $this = shift;


   my $q = $this->_module_ref()->get_signal_by_name("q") 
       or &ribbit ("no q found\n");
   my $q_msb = $q->width() - 1;

   my $fast_in = $this->fast_in();
   my $fast_out = $this->fast_out();

   $fast_in && $fast_out && &ribbit 
       ("cannot have fast in and fast out settings");

   my @esf_options;

   foreach my $j (0 .. $q_msb)
   {
      my $name = "dffe_$j";

      my $ebi = e_blind_instance->new
          ({
             tag          => "compilation",
             name         => $name ,
             module       => "dffe",
             in_port_map  => 
             {
                ena => "clk_en",
                clrn => "clrn",
                prn  => "prn",
                d    => $q_msb ? "d[$j]":"d",
             },
             out_port_map => 
             {q      => $q_msb ? "q[$j]":"q"},
          });

      $ebi->update($this->_module_ref());
      push (@{$this->_module_ref()->_updated_contents()},
            $ebi
            );

      push (@esf_options, "$name : FAST_OUTPUT_REGISTER = ON\n")
          if ($fast_out);

      push (@esf_options, "$name : FAST_INPUT_REGISTER = ON\n")
          if ($fast_in);
   }

   my $indent = "        ";

   if (@esf_options)
   {
      my $esf_string  = join ("$indent",
                              "OPTIONS_FOR_INDIVIDUAL_NODES_ONLY\n",
                              "{\n  ",
                              join ("  ",@esf_options),
                              "}\n"
                              );

      my $pm = $this->parent_module();
      my $mod_name = $this->_module_ref()->name();
      my $name = $this->_module_ref->name() 
          or &ribbit ("$this, no name $pm, $mod_name\n");

      my $file_name = "$name\.esf";
      my $absolute_file_name = join ('/',
                                     $this->parent_module()->_project()->_system_directory(),
                                     $file_name
                                     );
      
      open (ESF_FILE, "> $absolute_file_name") or 
          &ribbit ("unable to open $absolute_file_name ($!)\n");
      print ESF_FILE $esf_string;
      close (ESF_FILE);
   }
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
   my $this = shift;

   $this->_add_compilation_to_module();
   return ($this->SUPER::to_verilog(@_));
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
   my $this = shift;

   $this->_add_compilation_to_module();
   return ($this->SUPER::to_vhdl(@_));
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
