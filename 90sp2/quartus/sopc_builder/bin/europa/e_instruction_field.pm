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

e_instruction_field - description of the module goes here ...

=head1 SYNOPSIS

The e_instruction_field class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_instruction_field;
use europa_utils;
use pretty_picture;
use e_pipe_module;
use e_mnemonic;
use e_port;
@ISA = ("e_port");
use strict;


my %all_instruction_fields_by_name = ();

my %known_templates = ();




my %fields = (
              _order         => ["name", "template_name"],
              width          => 0,    # Invalid marker value

              _template_name  => "",   # 'i6v' or 'op5w' or some such.

              );
my %pointers = ();

&package_setup_fields_and_pointers(__PACKAGE__,
                                   \%fields,
                                   \%pointers);



=item I<new()>

Object constructor

=cut

sub new 
{
   my $that = shift;
   my $self = $that->SUPER::new(@_);


   if ((scalar(@_) == 1) && (ref($_[0]) eq __PACKAGE__))
   {

   } else {

      &goldfish ("suspicious attempt to redefine field: ", $self->name())
          if $all_instruction_fields_by_name{$self->name()};
      $all_instruction_fields_by_name{$self->name()} = $self;
   }
   
   $self->validate();
   return $self;
}



=item I<validate()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub validate
{
   my $this = shift;
   &ribbit ("Bad instruction field: ", $this->name()) unless $this->width > 0;
   &ribbit ("Bad instruction field: ", $this->name()) 
       unless $known_templates{$this->template_name()};
}










=item I<parent()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub parent
{
   my $this = shift;
   return $this->SUPER::parent() unless @_;
   my $new_parent = shift;
   &ribbit ("too many arguments") if @_;
   &ribbit ("e_module argument required") 
       unless &is_blessed ($new_parent) && $new_parent->isa("e_module");

   &ribbit ("invalid attempt to add instruction-field ",
            $this->name(), " to non-pipe-module ", 
            $new_parent->name())  
       unless $new_parent->isa("e_pipe_module");

   return $this->SUPER::parent ($new_parent);
}



=item I<get_msb_lsb_width()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_msb_lsb_width 
{
   my $this = shift;

   my $template = "";
   if (ref ($this) eq "") { 

      $template = shift or &ribbit ("missing template-name argument");
   } else {
      &ribbit ("access-only function") if @_;
      $template = $this->template_name();
   }
   return &extract_msb_lsb_width_from_bit_string ($known_templates{$template});
}



=item I<template_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub template_name
{
  my $this      = shift;
  return $this->_template_name() unless @_;

  my $temp_name = shift;
  &ribbit ("too many arguments") if @_;





  return if $temp_name eq "";    
  
  &ribbit ("expected reference to template-name string")
      unless ref ($temp_name) eq "";

  &ribbit ("attempt to redefine template-name for ", $this->name())
      if $this->template_name();

  &ribbit ("unknown instruction field (template): $temp_name")
      unless exists $known_templates{$temp_name};

  my $bit_string        = $known_templates{$temp_name};
  my ($msb,$lsb,$width) = &extract_msb_lsb_width_from_bit_string($bit_string);
  $this->width ($width);

  return $this->_template_name($temp_name);
}



=item I<get_all_instruction_fields()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_all_instruction_fields
{
   my $this = shift;
   &ribbit ("access-only function") if @_;
   &ribbit ("Please call statically") unless ref ($this) eq "";
   return values (%all_instruction_fields_by_name);
}



=item I<direction()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub direction
{
   my $this = shift;
   if (@_) { 
      &ribbit ("can't change the direction of an instruction field") 
          unless $_[0] eq "in";
   }
   return $this->SUPER::direction();
}





































=item I<place_value_as()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub place_value_as
{
   my $this = shift;
   my ($field_name, $value, $do_return_reduction_string) = (@_);
   &ribbit ("Please call statically") unless ref ($this)  eq "";
   &ribbit ("must provide both field-name and value") unless $value;
   &ribbit ("value must be a string") unless ref ($value) eq "";

   my ($msb, $lsb, $width) = 
       e_instruction_field->get_msb_lsb_width($field_name);
   my $top_fill_width = 16 - 1 - $msb;

   my $result = "";
   
   if ($do_return_reduction_string) 
   {
      $result .= ("x" x $top_fill_width) if $top_fill_width > 0;
      $result .= $value;
      $result .= ("x" x $lsb) if $lsb > 0;
           
      $result .= "x" x e_mnemonic->subinstruction_bits();
   } else { 
      $value = "$width\'b$value" if $value =~ /^[01x]+$/;

      my @result_components = ();
      push (@result_components, "$top_fill_width\'b" . ("0" x $top_fill_width))
          if $top_fill_width > 0;
      push (@result_components, $value);
      push (@result_components, "$lsb\'b" . ("0" x $lsb)) if $lsb > 0;

      $result = &concatenate (@result_components);
   }
   return $result;
}



=item I<define_templates()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub define_templates
{
   my $this = shift;
   &ribbit ("Please call this function statically") unless ref ($this) eq "";

   foreach my $format_picture (@_)
   {
      my $line_lists = &build_labelled_lists_from_text_table($format_picture);
      &ribbit ("expected 'bit' line in picture") unless $line_lists->{bit};
      


      while (scalar(@{$line_lists->{bit}})) 
      {
         my $bit_string = shift ( @{$line_lists->{bit}} );





         my ($msb,$lsb)= &extract_msb_lsb_width_from_bit_string ($bit_string);

         foreach my $format_label (keys (%{$line_lists}))
         {
            next if $format_label eq "bit";  # Ignore the 'bit' line.

            my $field_name = shift ( @{$line_lists->{$format_label}} )
                or &ribbit ("no field-name for $format_label ($bit_string)");

            next if $field_name =~ /^\s*-+\s*$/;
            if (exists ($known_templates{$field_name})) 
            { 


               my $old_bit_string = $known_templates{$field_name} ;
               my ($old_msb, $old_lsb) = 
                   &extract_msb_lsb_width_from_bit_string ($old_bit_string);
               &ribbit ("instruction field '$field_name' already defined")
                   unless (($msb == $old_msb) && 
                           ($lsb == $old_lsb)  );
            }
            $known_templates{$field_name} = $bit_string;
         }
      }
   }
}



=item I<implement_logic()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub implement_logic 
{
   my $this = shift;
   my $I    = shift or &ribbit ("expected instruction signal-name");  
   &ribbit ("instruction signal: expected name") unless ref ($I) eq "";
   
   my ($msb, $lsb, $width) = $this->get_msb_lsb_width();

   my $field_signal = e_signal->new ([$this->name(), $width]);


   my $N = $this->parent_module()->get_stage_number();
   my $in_expr = ($width > 1) ? "($I\_$N\[$msb : $lsb])" : "($I\_$N\[$msb])";

   return e_assign->new ([$field_signal, $in_expr]);
   







}

"For great justice.";










=back

=cut

=head1 EXAMPLE

Here is a usage example ...

=head1 AUTHOR

Santa Cruz Technology Center

=head1 BUGS AND LIMITATIONS

list them here ...

=head1 SEE ALSO

The inherited class e_port

=begin html

<A HREF="e_port.html">e_port</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
