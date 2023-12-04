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

e_sim_wave_text - description of the module goes here ...

=head1 SYNOPSIS

The e_sim_wave_text class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_sim_wave_text;

use europa_utils;
use e_assign;

@ISA = qw(e_mux);

use strict;

my %fields = (
              _max_length => e_signal->new(),
              tag => 'simulation',
              );

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
   my $self = $this->SUPER::new(@_);

   my $max_sig = $self->_max_length();
   $max_sig->copied(1);
   $max_sig->never_export(1);
   return $self;
}



=item I<lhs()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub lhs
{
   my $this = shift;
   my $return = $this->SUPER::lhs(@_);
   if (@_)
   {
      my $max_length_signal = $this->_max_length();
      $max_length_signal->name(@_);
      $max_length_signal->parent($this);
   }
   return $return;
}



=item I<default()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub default
{
   my $this = shift;

   my $old_default = $this->SUPER::default();
   if (@_)
   {
      my $val = shift;
      $this->max_length($val);
      my $new_default = $this->SUPER::default
          (&str2hex($val));
      return ($new_default);
   }
   return ($old_default);
}



=item I<max_length()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub max_length
{
   my $this = shift;
   if (@_)
   {
      my $val = shift;
      my $length = (split (//s,$val)) * 8;
      my $max_length_signal = $this->_max_length();
      my $old_length = $max_length_signal->width();
      if ($length > $old_length)
      {
         $max_length_signal->width($length);
      }
   }
}


=item I<add_table_ref()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_table_ref
{
   my $this = shift;
       
   my $ref = shift;
   ((@$ref % 2) == 0) || &ribbit ("bad widths in @$ref\n");

   my $index = 1;
   while ($index < @$ref)
   {

      my $val = &str2hex($ref->[$index]);
      $this->max_length($ref->[$index]);
      $ref->[$index] = $val;
      $index += 2;
   }
   return $this->SUPER::add_table_ref($ref);
}





=item I<strpad()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub strpad {
    my $this = shift;
    my $string = shift;
    my $length = shift;
    my $padder = shift;

    if ($padder eq "") {$padder = " ";}
    while ($length > length($string)) {
        $string = $padder.$string;
    }
    return ($string);
}





=item I<get_objdump_table()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_objdump_table
{
    my $this = shift;
    my $objdump = shift;        # name of objdump file array ref

    my ($file, $signal) = @$objdump;

    open (OBJ, $file) || die ("no '$file' objdump: $!\n");
    my %obj_labels;             # obj_labels{address} = "label"
    my $loop = "";              # local loop variable for OBJ lines
    my @label;                  # split loop into label
    my $max_len = 0;            # track max length of "label"
    my $last_line = "";         # last line of file
    while (<OBJ>) {
        $loop = $_;

        if ( $loop =~ /^[0-9a-f]+ .*:/ ) {

            @label = split (/[ <>]/ , $loop);

            $obj_labels{$label[0]} = $label[2];

            $max_len = &max($max_len, length($label[2]));
        }
        $last_line = $loop;     # remember last line.
    }
    

    $max_len = &max($max_len, length("Post-Code"));


    my @tab_list;
    my @keys = keys (%obj_labels);
    my @last_list = split (/:/, $last_line); 
    my $last_addr; # convert leading spaces to leading "0" in first field:
    ($last_addr = $last_list[0]) =~ s/ /0/g;

    $last_addr = $this->strpad($last_addr, length($keys[0]), "0");
    push @tab_list, ("($signal > ".4*length($keys[0])."'h$last_addr)" =>
                     $this->strpad("Post-Code",$max_len,"-"));




    foreach my $k (reverse (sort (@keys))) {

        push @tab_list,
        ("($signal >= ".4*length($k)."'h$k)" =>
         $this->strpad($obj_labels{$k},$max_len));
    }
    

    $this->table(\@tab_list);
    $this->default($this->strpad("Pre-Code",$max_len,"-"));
}

qq{
Upon the clatter of a broken tile
All I had learned was at once forgotten.
Amending my nature is needless;
Pursuing the tasks of everyday life
I walk along the ancient path.
I am not disheartened in the mindless void.
Wherever I go I leave no footprint,
Walking without color or sound. 
 - Chikan Zenji 
};

=back

=cut

=head1 EXAMPLE

Here is a usage example ...

=head1 AUTHOR

Santa Cruz Technology Center

=head1 BUGS AND LIMITATIONS

list them here ...

=head1 SEE ALSO

The inherited class e_mux

=begin html

<A HREF="e_mux.html">e_mux</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
