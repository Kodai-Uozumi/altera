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

e_signal - description of the module goes here ...

=head1 SYNOPSIS

The e_signal class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_signal;

use e_thing_that_can_go_in_a_module;
@ISA = ("e_thing_that_can_go_in_a_module");
use europa_utils;
use strict;







my %fields = (
              width         => 1,
              _export       => 0,
              _never_export => 0,
              depth         => 0, # Set to non-zero for 2-d signals.
              trimmed       => 0,
              __is_inout    => 0,
              _ptf_written  => 0,
              _negated      => 0,
              type          => "",
              copied        => 0,
	      vhdl_declare_only_type => 0,
              declare_one_bit_as_std_logic_vector => 0,
              default_value => '',
              vhdl_record_name => "",
              vhdl_record_type => "",
              );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<_order()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _order
{
   return ["name",
           "width",
           "export",
           "never_export",
           "copied"
           ];
}



=item I<_is_inout()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _is_inout
{
   my $this = shift;
   my $return = $this->__is_inout(@_);
   if (@_ && $return)
   {
      $this->export($return);
   }
   return $return;
}



=item I<access_methods_for_auto_constructor()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub access_methods_for_auto_constructor
{
   my $this = shift;
   return (qw(width export never_export copied depth _is_inout),
           $this->SUPER::access_methods_for_auto_constructor(@_));
}



=item I<new()>

Object constructor

=cut

sub new 
{
   my $this  = shift;

   my ($first_arg) = @_;
   my $self;
   if (&is_blessed($first_arg))
   {
      my $ref = ref($first_arg);
      $self = $ref->new();
      $self->set($first_arg);



      $self->copied(1);
   }
   else
   {
      $self = $this->SUPER::new(@_);
   }

   return $self;
}



=item I<name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub name
{
   my $this = shift;
   my $existing_name = $this->SUPER::name();
   if (@_)
   {
      my $new_name = shift;

      $this->_negated($new_name =~ s/\~//g);
      $new_name =~ s/^\s*(.*?)\s*$/$1/s;

      if ($new_name =~ /\W/)
      {
         &ribbit ("name ($new_name) is no good for a signal\n");
      }

      if ($new_name && ($new_name ne $existing_name))
      {
         $this->remove_this_from_parent();
         $existing_name = $this->SUPER::name($new_name);
         $this->add_this_to_parent();
      }
   }
   return $existing_name;
}





=item I<add_this_to_parent()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_this_to_parent
{
   my $this = shift;
   if ($this->enough_data_known())
   {
      my $name = $this->name();
      $this->add_child_to_parent_signal_list
          ($name, 'signal');

      $this->add_child_to_parent_signal_list
          ($name, 'object');

      if ($this->export())
      {
         $this->add_child_to_parent_signal_list
             ($name, 'export');
      }
      if ($this->never_export())
      {
         $this->add_child_to_parent_signal_list
             ($name, 'never_export');
      }
   }
}



=item I<remove_this_from_parent()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub remove_this_from_parent
{
   my $this = shift;
   if ($this->enough_data_known())
   {
      my $name = $this->name();
      $this->remove_child_from_parent_signal_list
          ($name, 'signal');

      $this->remove_child_from_parent_signal_list
          ($name, 'object');

      if ($this->export())
      {
         $this->remove_child_from_parent_signal_list
             ($name, 'export');
      }
      if ($this->never_export())
      {
         $this->remove_child_from_parent_signal_list
             ($name, 'never_export');
      }

   }
}




=item I<export()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub export
{
   my $this = shift;

   my $return = $this->_export();
   if (@_)
   {
      my $value = shift;
      if ($value ne $return)
      {
         if ($value > 1)
         {
            &goldfish 
                ("export values greater than 1 are no longer ".
                 "supported");
         }
         my $name = $this->name();
         if ($name)
         {
            if ($value)
            {
               $this->add_child_to_parent_signal_list
                   ($name, 'export');
            }
            else
            {
               $this->remove_child_from_parent_signal_list
                   ($name, 'export');
            }
         }
         $return = $this->_export($value);
      }
   }
   return $return;
}



=item I<never_export()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub never_export
{
   my $this = shift;

   my $return = $this->_never_export();
   if (@_)
   {
      my $value = shift;

      if ($value ne $return)
      {
         my $name = $this->name();
         if ($name)
         {
            if ($value)
            {
               $this->add_child_to_parent_signal_list
                   ($name, 'never_export');
            }
            else
            {
               $this->remove_child_from_parent_signal_list
                   ($name, 'never_export');
            }
         }
         $return = $this->_never_export($value);
      }
   }
   return $return;
}






=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
   my $this  = shift;

   my $declare_this_as = shift or 
       &ribbit ("sorry charlie, no declaration statement ");

   my $attribute_string = shift;

   if ($attribute_string)
   {

      $attribute_string =~ s/(ALTERA_IP_DEBUG_VISIBLE\s*=\s*[01])//;
      my $altera_ip_debug_visible = $1;



      if ($attribute_string)
      {
        $attribute_string = ' /* synthesis ALTERA_ATTRIBUTE ='.
            $attribute_string
            . " $altera_ip_debug_visible"
            .' */';
      }
      else
      {

        $attribute_string = " /* synthesis $altera_ip_debug_visible */";
      }
   }
   my $name = $this->name();
   my $width = $this->width();

   my $vs;
   my $depth_string = "";
   if ($this->depth())
   {
      $declare_this_as = "reg"; #sorry, you can only declare 2d array things

      $depth_string = sprintf(" \[%3d\: 0\]", $this->depth() - 1);
   }

   if (($width > 1) || ($this->declare_one_bit_as_std_logic_vector()))
   {
      $vs = sprintf ("%-7s \[%3d\: 0\] %s%s%s;\n",$declare_this_as,$width
                     - 1, $name, $depth_string,$attribute_string);
   }
   else
   {
      $vs = sprintf ("%-17s%s%s%s;\n",$declare_this_as,$name,
                     $depth_string, $attribute_string);
   }
   return ($vs);
}



=item I<get_depth()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_depth
{
   my $this = shift;
   return($this->depth());
}



=item I<_vhdl_get_direction()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _vhdl_get_direction
{
   my $this = shift;

   my $name = $this->name() or &goldfish ("no name for $this\n");
   my $parent_module = $this->parent_module();
   if (!$parent_module)
   {
      &ribbit ("no parent module defined for $name\n");
   }

   my $dir = "";
   if ($parent_module->is_output($name))
   {
      $dir = "OUT";
      $dir = "INOUT"
          if ($this->_is_inout());
   }
   if ($parent_module->is_input($name))
   {
      $dir = "IN";
   }
   return ($dir);
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
   my $this  = shift;
   my $indent = shift;

   my $name = $this->name() or &ribbit ("no name for $this\n");
   my $width = $this->width();
   my $direction = $this->_vhdl_get_direction();
   my $vhdl_record_type = $this->vhdl_record_type();
   my $vhdl_record_name = $this->vhdl_record_name();
   






   
   my $doing_visible_wrapper_ports = $this->project()->doing_visible_wrapper_ports();
   if($doing_visible_wrapper_ports && $vhdl_record_type)
   {

      my $visible_wrapper_name = $vhdl_record_name . "." . $name;
      $visible_wrapper_name =~ tr/\./_/;
      $name = $visible_wrapper_name;
      
      $vhdl_record_name = "";
      $vhdl_record_type = "";
   }




   my $std_logic = "STD_LOGIC";

   my $vs = ${indent};
   my $depth = $this->depth();
   if ($depth)
   {
      my $type =
          $this->parent_module()->get_exclusive_name("mem_type");

      if ($this->vhdl_declare_only_type())
      {
         $type = "$name";
         $vs .= "TYPE $type is ARRAY( ".($depth - 1)." DOWNTO 0) of ${std_logic}_VECTOR(";
         $vs .= ($width - 1)." DOWNTO 0)";
      }
      else
      {
         $vs .= "TYPE $type is ARRAY( ".($depth - 1)." DOWNTO 0) of ${std_logic}_VECTOR(";
         $vs .= ($width - 1)." DOWNTO 0);\n";
         $vs .= "${indent}signal $name : $type";  #parent will put semicolon on end of this line.
      }

   }
   elsif ($vhdl_record_type)
   {
   	  






      
      if (!$this->parent_module()->declared_vhdl_record_names($vhdl_record_name))
      {
        $vs.= "signal $vhdl_record_name : $vhdl_record_type";
      }
      else
      {
        $vs.= "-- ($name already part of $vhdl_record_name)";   
      }
   }
   else
   {
      $vs .= "signal ";
      if (($width > 1) ||
          ($this->declare_one_bit_as_std_logic_vector())
          )
      {
         $vs .= "$name : $direction ${std_logic}_VECTOR (".
             ($width - 1)." DOWNTO 0)";
      }
      else
      {
         $vs .= "$name : $direction $std_logic";
      }       
   }
   return ($vs);
}
















my %compatible_type = 
    (
     read_n  => "readn",
     write_n => "writen",
     reset_n => "resetn",
     );



=item I<add_to_ptf_section()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_to_ptf_section
{
   my $this = shift;
   my $ptf_section = shift;
   my $type = shift;

   return if $this->_ptf_written();

   ref ($ptf_section) eq "HASH" or &ribbit("expected reference to PTF (hash).");


   my $own_section = $ptf_section->{"PORT " . $this->name()} || {};
   my $direction = $this->_get_ptf_direction_string_after_update();
   return unless $direction;
   $own_section->{Is_Enabled} = "1";
   $own_section->{direction} = $direction;
   $own_section->{width}     = $this->width();
   $own_section->{type}      = $type if $type;
   $own_section->{default_value} = $this->default_value()
       if ($this->default_value() ne '');
   $ptf_section->{"PORT " . $this->name()} = $own_section;

   $this->_ptf_written(1);
}

















=item I<_get_ptf_direction_string_after_update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_ptf_direction_string_after_update
{
   my $this = shift;
   my $mod = $this->parent_module() or &ribbit ("No parent.");
   $this->name() ne "" or &ribbit ("unnamed signal is port. One beer, please.");

   return "input"  if $mod->is_input ($this->name());
   return "inout"  if $this->_is_inout();
   return "output" if $mod->is_output ($this->name()) ;

   return '';
}



=item I<get_signal_from_signal_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_signal_from_signal_list
{
   my $this = shift;
   return $this;
}




=item I<esf_node_options()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub esf_node_options 
{
  my $this = shift;
  my $options = shift;

  foreach my $key (keys %$options) {
    $this->{ESF_ATTRIBUTES}{OPTIONS_FOR_INDIVIDUAL_NODES_ONLY}{$key} = 
      $options->{$key} ; 
  }
  return ($this->{ESF_ATTRIBUTES}{OPTIONS_FOR_INDIVIDUAL_NODES_ONLY});
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

The inherited class e_thing_that_can_go_in_a_module

=begin html

<A HREF="e_thing_that_can_go_in_a_module.html">e_thing_that_can_go_in_a_module</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
