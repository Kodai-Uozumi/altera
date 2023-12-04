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

e_ptf_instance - description of the module goes here ...

=head1 SYNOPSIS

The e_ptf_instance class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_ptf_instance;
use e_instance;
@ISA = ("e_instance");

use strict;
use europa_utils;







my %fields   = ();
my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<module_ref()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub module_ref
{
   my $this = shift;
   my $module_ref = $this->_module_ref(@_);
   $this->_module_set(1);
   if (@_)
   {
      $module_ref->_instantiated_by([
                                     @{$module_ref->_instantiated_by()},
                                     $this]);
      if ($this->_project_set())
      {
         $module_ref->project($this->project);
      }
      $this->_port_update();
      $this->update_port_map();
   }
   return $module_ref;
}



=item I<_port_update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _port_update
{
   my $this = shift;

   $this->port_map({});




   my $instantiated_module = $this->module();
   my @outputs = $instantiated_module->get_output_names();
   my @inputs  = $instantiated_module->get_input_names();

   my $mod = $this->module()->name();

   my @gargantuan_port_map;
   foreach my $port_name (@outputs,@inputs)
   {
      my $port = $this->module()->get_object_by_name($port_name);

      if (!$port)
      {
         &ribbit ("cannot find object $port_name\n");
      }

      my $exclusive_port_name;
      if ($port->can("_exclusive_name"))
      {
         $exclusive_port_name = $port->_exclusive_name() or &ribbit
             ("no exclusive port name for port \"@{[$port->name()]}\" ". 
             "in module \"@{[$this->module()->name()]}\"\n");
      }
      else
      {
         $exclusive_port_name = $port_name;
      }
      my $shift_port_left =
          $port->amount_to_left_shift_connection();
      my $port_msb = $port->width() - 1;

      if ($shift_port_left)
      {
         $exclusive_port_name .= "[".($port_msb + $shift_port_left).
             ": $shift_port_left]";
      }
          
      push (@gargantuan_port_map, 
            $port_name => $exclusive_port_name
            );
   }
   $this->port_map(@gargantuan_port_map);
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
