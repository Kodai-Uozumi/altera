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

e_case - description of the module goes here ...

=head1 SYNOPSIS

The e_case class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_case;

use europa_utils;
use e_expression;

use e_thing_that_can_go_in_a_module;
@ISA = qw (e_thing_that_can_go_in_a_module);

use strict;







my %fields = (
              _order => ["switch", 
                         "contents"],
	      _switch => e_expression->new(),
              _switch_sig => e_signal->new(),
	      _updated_contents => {},
	      parallel => "",
	      full     => "",
	      default_sim => 0,
              );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<switch()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub switch
{
   my $this = shift;
   my $switch = $this->_switch(@_);
   if (@_)
   {
      $switch->parent($this);
      if (!$switch->_has_signal())
      {
         my $switch_sig = $this->_switch_sig();
         $switch_sig->name($switch->expression());
         $switch_sig->copied(1);
         $switch_sig->parent($this);
      }
   }
   return $switch;
}



=item I<contents()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub contents
{
    my $this = shift;

    my $updated_contents_hash = $this->_updated_contents();
    if (@_)
    {

       my $contents_hash = shift;
       my @cases = keys (%$contents_hash);
       $this->_switch_sig()->width
           (&Bits_To_Encode(max (@cases, 1)));

       foreach my $case (@cases)
       {
          $updated_contents_hash->{$case} = 
              $this->_make_updated_contents_array
              ($contents_hash->{$case});
       }
    }

    return $updated_contents_hash;
}



=item I<convert_to_assignments()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub convert_to_assignments
{
   my $this = shift;
   my $condition = shift;
   my @conditions = @$condition;  # Make a local copy.

   my $updated_contents_hash = $this->_updated_contents();
   my $default_case = $updated_contents_hash->{default};

   delete $updated_contents_hash->{default};
   my @cases = sort (keys (%$updated_contents_hash));
   my $switch = $this->switch->expression();

   my @source_array = $this->get_source_names();
   foreach my $case (@cases)
   {
      
      my @switch_conditions = @conditions;








      push @switch_conditions, "($switch == $case)";

      foreach my $content (reverse
                           (@{$updated_contents_hash->{$case}}))
      {
         $content->convert_to_assignments(\@switch_conditions);
      }
   }
   if (@$default_case)
   {
      foreach my $content (reverse (@$default_case))
      {
         $content->convert_to_assignments(\@conditions);
      }
   }


   foreach my $case_source (@source_array)
   {
      $this->convert_to_assignment_mux($case_source,
                                       \@conditions,
                                       $case_source);
   }

}



=item I<convert_to_assignment_mux()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub convert_to_assignment_mux
{
   my $this = shift;
   return $this->parent()->convert_to_assignment_mux(@_);
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
    my $this = shift;
    my $indent = shift;

    my $switch = $this->switch->expression();
    my $parallel_case = $this->parallel;
    my $full_case = $this->full;

    my $vs;
    $vs  = "case ($switch)";
    if ($parallel_case || $full_case)
    {
	$vs .= " // synthesis";
	if ($parallel_case)
	{
	    $vs .= " parallel_case";
	}
	if ($full_case)
	{
	    $vs .= " full_case";
	}
    }
    $vs .= "\n\n";

    my $updated_contents_hash = $this->_updated_contents();
    my $default_case = $updated_contents_hash->{default};
    delete $updated_contents_hash->{default};
    my @cases = sort (keys (%$updated_contents_hash));
    my $local_indent = "    ";

    my $switch_signal = $this->parent_module->get_signal_by_name($switch);
    my $switch_width  = $switch_signal->width;

    foreach my $case (@cases)
    {
	my $type = $case;
	if ($type =~ /^[0-9]+$/) {
	    $type = $switch_width."'d".$type;
	}
	$vs .= "$local_indent$type: begin\n";
	my $tab = "$local_indent$local_indent";


	foreach my $updated_contents (@{$updated_contents_hash->{$case}})
	{
	    $vs .= $updated_contents->to_verilog($tab);
	}
	$vs .= "${local_indent}end // $type \n\n";
    }
    if ($default_case) {


	if ($this->default_sim) {
	    $vs .= "${local_indent}// ".$this->parent_module->project->_translate_off."\n\n";
	}
	$vs .= "${local_indent}default: begin\n";
	my $tab = "$local_indent$local_indent";
	foreach my $default_contents (@{$default_case})
	{
	    $vs .= $default_contents->to_verilog($tab);
	}
	$vs .= "${local_indent}end // default\n\n";
	if ($this->default_sim) {
	    $vs .= "${local_indent}// ".$this->parent_module->project->_translate_on."\n";
	}
    }
    $vs .= "endcase // $switch\n";
    $vs =~ s/^/$indent/mg;
    return $vs;
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
    my $this = shift;
    my $indent = shift;

    my $switch = $this->switch()->expression();
    my $parallel_case = $this->parallel;
    my $full_case = $this->full;
    my $vs;
    $vs  = "case $switch is";

    if ($parallel_case || $full_case)
    {
  $vs .= " -- synthesis";
  if ($parallel_case)
  {
      $vs .= " parallel_case";
  }
  if ($full_case)
  {
      $vs .= " full_case";
  }
    }
    $vs .= "\n";

    my $updated_contents_hash = $this->_updated_contents();
    my $default_case = $updated_contents_hash->{default};
    delete $updated_contents_hash->{default};
    my @cases = sort (keys (%$updated_contents_hash));
    my $local_indent = "    ";

    my $switch_signal = $this->parent_module->get_signal_by_name($switch);
    my $switch_width  = $switch_signal->width;

    foreach my $case (@cases)
    {

      my $type = e_expression->new($case)->to_vhdl($switch_width);



  $vs .= "${local_indent}when $type => \n";
  my $tab = "$local_indent$local_indent";
  foreach my $updated_contents (@{$updated_contents_hash->{$case}})
  {
      $vs .= $updated_contents->to_vhdl($tab);
  }
  $vs .= "${local_indent}-- when $type \n\n";
    }

    if(1){



  $vs .= "${local_indent}when others => \n";
  my $tab = "$local_indent$local_indent";
  foreach my $default_contents (@{$default_case})
  {
      $vs .= $default_contents->to_vhdl($tab);
  }
  $vs .= "${local_indent}-- when others \n\n";



    }
    $vs .= "end case; -- $switch\n";
    $vs =~ s/^/$indent/mg;
    return $vs
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
