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

e_thing_that_can_go_in_a_module - description of the module goes here ...

=head1 SYNOPSIS

The e_thing_that_can_go_in_a_module class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_thing_that_can_go_in_a_module;



use e_default_module_marker;
use e_signal_junction_database;
@ISA = ("e_signal_junction_database");
use strict;
use europa_utils;

my $unique_name_counter;
my %recognized_tags = (normal              => 1,
                       synthesis           => 1,
                       simulation          => 1,
                       compilation         => 1,   
                       dont_mind_me        => 1,
                       component           => 1,
                      );







my %fields = (


              indent          => "  ",
              paragraph       => "\n\n",
             );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );










=item I<comment()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub comment 
{
   my $this = shift;

   my $comment = $this->SUPER::comment(@_);

   if (!$comment)
   {
      my $name = $this->name();
      $comment = "$name, which is an ". ref ($this)
          if ($name);
   }



   $comment =~ s/(ARRAY|HASH)\(0x[0-9A-Fa-f]+\)/$1()/g;

   return $comment;
}



=item I<_direct_copy_repair()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _direct_copy_repair
{
  my $this = shift;
  $this->SUPER::_direct_copy_repair();




}



=item I<tag()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub tag
{
  my $this = shift;
  if (!defined ($this->{tag}))
  {
     $this->{tag} = 'normal';
  }

  &ribbit ("Too many arguments") if scalar @_ > 1;
  if (@_) {
    my ($tag) = (@_);
    &ribbit ("unrecognized tag: $tag") unless $this->tag_is_recognized($tag);



    if($tag eq "synthesis"){
       $tag = 'compilation';
    }
    return $this->{tag} = $tag;
  }
  return $this->{tag};
}



=item I<tag_is_recognized()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub tag_is_recognized
{
  my $this = shift;
  my $test_tag = shift;
  &ribbit ("Required one argument") if $test_tag eq "" || @_;
  return $recognized_tags{$test_tag};
}





=item I<obsolete_only()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub obsolete_only
{
  my $this = shift; 
  my $what = shift;
  &goldfish ("obsolete: $what");
  if (@_) {
    $_[0] ? $this->tag($what) : $this->tag("normal");
  }
  return $this->tag() eq $what;
}



=item I<synthesis_only()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub synthesis_only
{
  my $this = shift;
  return $this->obsolete_only("synthesis");
}



=item I<simulation_only()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub simulation_only 
{
  my $this = shift;
  return $this->obsolete_only("simulation");
}



=item I<compilation_only()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub compilation_only
{
  my $this = shift;
  return $this->obsolete_only("compilation");
}



=item I<add()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add
{
  my $this = shift;
  my $self = $this->new(@_);
  e_default_module_marker->add_contents ($self);
  return $self;
}



=item I<adds()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub adds
{
  my $this = shift;
  my @result = ();
  foreach my $constructor_args (@_) {
    push (@result, $this->add($constructor_args));
  }
  return @result;
}



=item I<parent_process()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub parent_process
{
   my $this = shift;
   my $par_process = $this->parent();

   while (!$par_process->isa("e_process"))
   {
      $par_process = $par_process->parent();
      &ribbit ("could not find a parent process for $this\n")
          if ($par_process->isa("e_module"));
   }
   return ($par_process);
}




=item I<within()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub within
{
   my $this = shift;

   if (@_)
   {
      my $parent_module = shift;
      if (!(&is_blessed ($parent_module) && $parent_module->isa("e_module"))) 
      {
         &ribbit ( "($parent_module) is not an e_module \n",
                   "tried to 'within'\n");
      }
      $parent_module->add_contents($this);
   }
   else
   {
      &ribbit ("within called with no arguments, ",
               "must be called with a module as the only argument\n");
   }
   return ($this);
}












=item I<_unique_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _unique_name
{

  my $this = shift;


  return $this->{_unique_name} if $this->{_unique_name};


  my @name_parts = ("un",@_, $this->name(), $unique_name_counter++);


  $this->{_unique_name} = join ("x", @name_parts);


  $this->{_unique_name} =~ s/[^a-zA-Z0-9_]/_/smg;
  return $this->{_unique_name};
}



=item I<_get_field_values()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_field_values
{
   my $this = shift;
   my @values;
   foreach my $field ($this->get_fields())
   {
      if (ref ($this->$field()) eq "ARRAY")
      {
         push (@values, @{$this->$field()});
         next;
      }
      if (ref ($this->$field()) eq "HASH")
      {
         push (@values, (values (%{$this->$field()})));
         next;
      }
      push (@values, $this->$field());
   }

   return (@values);
}



=item I<document_object()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub document_object
{
   my $this = shift;
   my $pm = $this->parent_module();
   return ($pm->document_object(@_));
}



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
   my $this = shift;
   $this->parent(@_);
  return;
}









=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
  my $this  = shift;
  my $indent = shift;
  my $text_stuff = "";

  if ($this->comment() ne "")
  {
    $text_stuff = $this->string_to_verilog_comment($indent, $this->comment());
  }

  return ($text_stuff);
}









=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
  my $this   = shift;
  my $indent = shift;
  my $text_stuff = "";
  $text_stuff = $this->string_to_vhdl_comment($indent, $this->comment())
      if (defined($this->comment()) and $this->comment());
  my $return_string = $text_stuff;
  return ($return_string);
}












=item I<to_ptf()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_ptf 
{  

}



=item I<vhdl_declare_component_if_needed()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_declare_component_if_needed
{

   return;
}



=item I<declare_verilog_register()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub declare_verilog_register
{
   return 0;
}














=item I<_make_updated_contents_array()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _make_updated_contents_array 
{
  my $this  = shift;
  my $contents_list_ref = shift;
  if (ref ($contents_list_ref) ne 'ARRAY')
  {
     &ribbit ("need to pass array here\n");
  } 

  my @contents_list = @$contents_list_ref;

  my $updated_contents_array = [],



  my $first;
  my $second;
  while (@contents_list)
  {
    my $first = shift (@contents_list);
    if (!&is_blessed($first)) 
    {
      my $assign;
      if (ref($first) eq "ARRAY") { # already an e_assign array?

        $assign = e_assign->new($first);
      } else {  # make into e_assign array
        my $second = shift (@contents_list);

        (!&is_blessed($second)) 
            or &ribbit ("mismatched assignments ($first,$second)");
        $assign = e_assign->new([$first,$second]);
      }
      $assign->parent($this);
      push (@$updated_contents_array, $assign);
    }
    else
    {
      $first->parent($this);
      push (@$updated_contents_array, $first);		
    }
  }
  return $updated_contents_array;
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

The inherited class e_signal_junction_database

=begin html

<A HREF="e_signal_junction_database.html">e_signal_junction_database</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
