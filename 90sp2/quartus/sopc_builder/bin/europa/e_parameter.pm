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

e_parameter - description of the module goes here ...

=head1 SYNOPSIS

The e_parameter class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_parameter;

use europa_utils;

use e_thing_that_can_go_in_a_module;
@ISA = qw (e_thing_that_can_go_in_a_module);

use strict;







my %fields = (
              _order    => [
                            "name", "default", 
                            "vhdl_type"
                            ],
              default   => undef,
              vhdl_type => undef,
              vhdl_default => '',
              );

my %pointers = ();



=item I<type()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub type 
{
   my $this = shift;
   return $this->vhdl_type(@_);
}
&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<value()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub value
{
    my $this  = shift;
    my $class = ref($this) 
	or &ribbit ("this ($this) not understood");

    return ($this->default(@_));
}



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
    my $this  = shift;
    my $class = ref($this) 
	or &ribbit ("this ($this) not understood");

    my $pm = $this->parent(@_);
    $pm->document_object($this);
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
    my $this  = shift;
    my $class = ref($this) 
	or &ribbit ("this ($this) not understood");

    my $indent = shift;

    my $name = $this->name();
    my $value = $this->value();
    $value = "\"$value\""
        if ($this->vhdl_type() =~ /string/i);

    my $vs = $indent."parameter $name = $value\;\n"; 

    return ($vs);
}

=item I<get_vhdl_default()>

gets value for vhdl default.  If not specified, gets normal default value

=cut

sub get_vhdl_default
{
   my $this = shift;

   my $vhdl_default = $this->vhdl_default();
   if ($vhdl_default eq '')
   {
      $vhdl_default = $this->default();
   }

   return $vhdl_default;
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
   my $this  = shift;
   my $class = ref($this) 
       or &ribbit ("this ($this) not understood");

   my $indent = shift;

   my $name = $this->name();
   my $type  = $this->vhdl_type();
   my $value = $this->get_vhdl_default  ();

   my $parent_module = $this->parent_module();

   die $parent_module.": vhdl_type not known for parameter $name"
       unless ($type);

   if ($value ne "")
   {
      $value =~ s/^(.*?)$/\"$1\"/

          if ($this->vhdl_type() =~ /string/i);

      return (join (" : ", 
                    $indent.$name,
                    join (" := ", 
			  $type,
			  $value)
		   )
	     );
   }
   else
   {
      return (join (" : ", 
                    $indent.$name,
                    $type
                    )
              );
   }
}

1;  # Sometimes you've just gotta say '1'.

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
