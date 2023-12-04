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

e_signal_junction_database - description of the module goes here ...

=head1 SYNOPSIS

The e_signal_junction_database class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_signal_junction_database;
use e_object;
@ISA = ("e_object");
use strict;
use europa_utils;








my %fields = (
              _object_list => {},
              _signal_list => {},
              _parent_set  => 0,
              _project_set => 0);

my %pointers = (_parent  => e_signal_junction_database->new(),
                _project => e_project->new());

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<access_methods_for_auto_constructor()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub access_methods_for_auto_constructor
{
   my $this = shift;
   return qw(name parent);
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

      if ($new_name && ($new_name ne $existing_name))
      {
         $this->remove_child_from_parent_object_list()
             if ($existing_name);
         $existing_name = $this->SUPER::name($new_name);
         $this->add_child_to_parent_object_list();
         if ($this->_project_set())
         {
            $this->project()->all_names_hash()
                ->{$new_name}++;
         }
      }
   }
   return $existing_name;
}



=item I<database_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub database_names
{
   return qw (input
              output
              signal
              export
              never_export
              copied
              call_me_if_sig_updates
              );
}



=item I<get_all_signal_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_all_signal_names
{
   my $this = shift;
   return keys (%{$this->_signal_list()});
}



=item I<enough_data_known()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub enough_data_known
{
   my $this = shift;
   return $this->name() && $this->_parent_set();
}



=item I<remove_this_from_parent()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub remove_this_from_parent
{
   my $this = shift;

   if ($this->_parent_set())
   {
      my $existing_parent = $this->parent();
      foreach my $signal ($this->get_all_signal_names())
      {
         foreach my $db_name ($this->database_names())
         {
            if ($this->_signal_list()->{$signal}{$db_name})
            {
               $existing_parent->remove_child_from_signal_list
                   ($this, $signal, $db_name,1);
            }
         }
         if ($this->_object_list()->{$signal})
         {
            $existing_parent->remove_child_from_signal_list
                ($this, $signal, 'object',1);
         }
      }
      my $name = $this->name();
      $existing_parent->remove_child_from_signal_list
          ($this, $name, 'object', 1) if $name;

      $this->remove_child_from_parent_object_list();
   }
}



=item I<add_this_to_parent()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_this_to_parent
{
   my $this = shift;

   my $existing_parent = $this->parent();
   if ($this->_parent_set())
   {
      foreach my $signal ($this->get_all_signal_names())
      {
         foreach my $db_name ($this->database_names())
         {
            if ($this->_signal_list()->{$signal}{$db_name})
            {
               $existing_parent->add_child_to_signal_list
                   ($this, $signal, $db_name,1);
            }
         }
      }
      $this->add_child_to_parent_object_list();
   }
}



=item I<remove_child_from_parent_object_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub remove_child_from_parent_object_list
{
   my $this = shift;
   if ($this->_parent_set())
   {
      my $parent = $this->parent();
      my $name = $this->name();
      $parent->remove_child_from_signal_list
          ($this, $name, 'object', 1) if $name;

      my $object_list = $this->_object_list();
      foreach my $object_name (keys (%$object_list))
      {
         $parent->remove_child_from_signal_list
             ($this, $object_name, 'object');
      }
   }
}



=item I<add_child_to_parent_object_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_child_to_parent_object_list
{
   my $this = shift;
   if ($this->_parent_set())
   {
      my $parent = $this->parent();
      my $name = $this->name();
      $parent->add_child_to_signal_list
          ($this, $name, 'object') if $name;

      my $object_list = $this->_object_list();
      foreach my $object_name (keys (%$object_list))
      {
         $parent->add_child_to_signal_list
             ($this, $object_name, 'object');
      }
   }
}



=item I<document_object()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub document_object
{
   my $this = shift;
   my $object = shift;
   my $object_name = $object->name();

   $this->add_child_to_signal_list
       ($object, $object_name, 'object');
}



=item I<get_object_by_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_object_by_name
{
  my $this = shift;
  my $name = shift; 
  my $type = shift;

  my $object = $this->_object_list()->{$name} || return;
  if ($object->name() ne $name)
  {
     $object = $object->get_object_by_name($name,$type);
  }

  if ($object && $type)
  {
     &ribbit ("$object isn't type $type\n")
         unless $object->isa($type);
  }

  return $object;
}



=item I<project()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub project
{
   my $this = shift;
   my $project = $this->_project(@_);
   if (@_)
   {
      $this->_project_set(1);
   }
   return $project;
}



=item I<parent()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub parent 
{
   my $this = shift;

   my $existing_parent = $this->_parent();
   if (@_)
   {
      my $new_parent = shift;
      if ($new_parent eq '')
      {
         $this->remove_this_from_parent();
         $this->_parent_set(0);
      }
      elsif (!$this->_parent_set() ||
             ($new_parent && ($existing_parent ne $new_parent))
             )
      {
         $this->remove_this_from_parent();
         $existing_parent = $this->_parent($new_parent);
         $this->_parent_set(1);
         $this->add_this_to_parent();
      }
   }
   if (!$this->_parent_set())
   {
      $existing_parent = '';
   }
   return $existing_parent;
}




=item I<add_child_to_signal_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_child_to_signal_list
{
   my $this = shift;
   my ($child, $signal_name, $db_name) = @_;

   (@_ >= 3) or &ribbit ("bad args (@_)\n");

   my $array;
   if ($db_name eq 'object')
   {
      if (!$this->_object_list()->{$signal_name})
      {
         $this->_object_list()->{$signal_name} = $child;
         $this->add_child_to_parent_signal_list
             ($signal_name, $db_name);
      }
   }
   else
   {
      my $array = $this->_signal_list()->{$signal_name}{$db_name};

      if ($db_name =~ /export$/)
      {


         my $opposite_export = ($db_name =~ /^never_/)? 'export' : 
             'never_export';

         my $opposite_array = $this->_signal_list()->
         {$signal_name}{$opposite_export};

         if ($opposite_array)
         {


            unless (grep {$_ eq $child} @$opposite_array)
            {
               return;
            }
         }
         
      }



      if (!$array)
      {
         push (@{$this->_signal_list()->{$signal_name}{$db_name}},
               $child);

         $this->add_child_to_parent_signal_list
             ($signal_name, $db_name);
      }
      elsif (!(grep {$_ eq $child} @$array))
      {
         push (@$array, $child);
      }
   }
}



=item I<add_child_to_parent_signal_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_child_to_parent_signal_list
{
   my $this = shift;
   $this->parent()->add_child_to_signal_list($this, @_)
       if ($this->_parent_set());
}



=item I<get_signal_from_signal_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_signal_from_signal_list
{
   my $this = shift;
   my $signal_name = shift;
   my $signals = $this->_signal_list()->{$signal_name}{signal}
   || &ribbit ("$this, no signal for $signal_name\n");

   my @return;
   foreach my $signal (@$signals)
   {
      push (@return, $signal->get_signal_from_signal_list($signal_name));
   }
   return @return;
}




=item I<remove_child_from_signal_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub remove_child_from_signal_list
{
   my $this = shift;
   my ($child, $signal_name, $db_name, $quiet) = @_;

   ($signal_name && $db_name) or &ribbit ("bad args (@_)\n");

   my $array;
   if ($db_name eq 'object')
   {
      delete $this->_object_list()->{$signal_name};
      $this->remove_child_from_parent_signal_list($signal_name,
                                                  $db_name,
                                                  $quiet);
   }
   else
   {
      if ($signal_name !~ /^[A-Za-z]\w*$/s)
      {
         &ribbit ("$signal_name is not a good signal name\n");
      }

      my $signal_hash = $this->_signal_list()->{$signal_name};
      $array = $signal_hash->{$db_name};

      if (!$array)
      {
         return;
      }
      my $old_array_size = @$array;
      @$array = grep {$_ ne $child} @$array;









      if (!@$array)
      {
         delete $signal_hash->{$db_name};
         if (!keys (%$signal_hash))
         {
            delete $this->_signal_list()->{$signal_name};
         }
         $this->remove_child_from_parent_signal_list($signal_name,
                                                     $db_name,
                                                     $quiet);
      }
   }
}



=item I<remove_child_from_parent_signal_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub remove_child_from_parent_signal_list
{
   my $this = shift;
   $this->parent()->remove_child_from_signal_list($this, @_)
       if ($this->_parent_set());
}









=item I<get_signal_sources_by_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_signal_sources_by_name
{
   my $this = shift;  
   my $name = shift;
   
   my $array = $this->_signal_list()->{$name}{output} || [];
   return @$array;
}










=item I<get_signal_destinations_by_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_signal_destinations_by_name
{
   my $this = shift;  
   my $name = shift;
   
   my $array = $this->_signal_list()->{$name}{input} || [];
   return @$array;
}











=item I<get_all_signal_names_that_go_from_a_to_b()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_all_signal_names_that_go_from_a_to_b
{
   my $this = shift;
   my $a = shift or &ribbit ("no a");
   my $b = shift or &ribbit ("no b");

   &ribbit ("a ($a) is illegal type")
       unless (&is_blessed($a) && $a->isa("e_thing_that_can_go_in_a_module")
               && (!($a->isa("e_signal"))));

   &ribbit ("b ($b) is illegal type")
       unless (&is_blessed($b) && $b->isa("e_thing_that_can_go_in_a_module")
               && (!($b->isa("e_signal"))));


   my @signal_names = $this->get_object_names("e_signal");



   my @signals_from_a;

   foreach my $sig (@signal_names)
   {
      my @sources = $this->get_signal_sources_by_name($sig);

      foreach my $source (@sources)
      {
         if ($source == $a)
         {
            push (@signals_from_a, $sig);
            last;
         }
      }
   }




   my @signals_from_a_to_b;

   foreach my $sig (@signals_from_a)
   {
      my @destinations = $this->get_signal_destinations_by_name($sig);
      foreach my $dest (@destinations)
      {
         if ($dest == $b)
         {
            push (@signals_from_a_to_b, $sig);
            last;
         }
      }
   }
   return (@signals_from_a_to_b);
}




=item I<parent_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub parent_module
{
   my $this = shift;

   if (!$this->_parent_set())
   {
      &ribbit ("end of the line and no parent module");
   }
   return $this->parent()->parent_module();
}



=item I<debug_signal_junctions()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub debug_signal_junctions
{
   my $this = shift;
   my $type = ref($this)
       or &ribbit ("$this is not an object");

   my $return_string;
   $return_string .= $this->name()."  ($this) \n";

   foreach my $name ($this->get_signal_names())
   {
      $return_string .= $this->_debug_signal_junction($name);
   }

   return ($return_string);
}



=item I<_debug_signal_junction()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _debug_signal_junction
{
   my $this = shift;

   my $name = shift or &ribbit ("no name");

   my @destinations = 
       $this->get_signal_destinations_by_name($name);
   my @sources = $this->get_signal_sources_by_name($name);

   my $source_string =      "    sources      -> ".join (",",@sources);
   my $destination_string = "    destinations -> ".join (",",@destinations);

   my $return_string;
   $return_string .= "  name -> $name\n";
   $return_string .= "$destination_string\n";
   $return_string .= "$source_string\n";

   return ($return_string);
}



=item I<get_destination_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_destination_names
{
   my $this = shift;
   my $signal_hash = $this->_signal_list();
   return grep {$signal_hash->{$_}{input} &&
                    @{$signal_hash->{$_}{input}}
             } keys (%$signal_hash);
}



=item I<get_source_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_source_names
{
   my $this = shift;
   my $signal_hash = $this->_signal_list();
   return grep {$signal_hash->{$_}{output} &&
                    @{$signal_hash->{$_}{output}}
             } keys (%$signal_hash);
}










=item I<get_signal_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_signal_names
{
   my $this = shift;
   my @names = keys (%{$this->_signal_list()});
   my @modified_names = grep {$_} @names;
   return sort (@modified_names);
}



=item I<rename_node()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub rename_node
{
   my $this = shift;
   my ($old,$new) = @_;

   my @sources = $this->get_signal_sources_by_name     ($old);
   my @dests   = $this->get_signal_destinations_by_name($old);

   foreach my $thing (@sources,@dests)
   {
      $thing->rename_node(@_);
   }
}



=item I<flatten_sources()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub flatten_sources
{
   my $this = shift;
   my $name = shift or &ribbit ("no name");

   my @sources = $this->get_signal_sources_by_name($name);
   foreach my $source (@sources)
   {
      push (@sources, $source->flatten_sources($name));
   }
   return (@sources);
}







=item I<make_linked_signal_conduit_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_linked_signal_conduit_list
{
   my $this = shift;
   my $signal_name = shift;

   my $call_me = $this->_signal_list()->{$signal_name}{call_me_if_sig_updates};
   return () unless $call_me;

   my @conduit_list;
   
   while (@$call_me)
   {
	   my $child = shift (@$call_me);
      push (@conduit_list, 
            $child->make_linked_signal_conduit_list
            ($signal_name));
   }
   return @conduit_list;
}



=item I<identify_inout_signal()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub identify_inout_signal
{
   my $this = shift;
   my $sig  = shift;
   my @sources = $this->get_signal_sources_by_name($sig);
   my @signals;
   foreach my $source (@sources)
   {
      push (@signals, $source->identify_inout_signal($sig));
   }
   return @signals;
}



=item I<check_x()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub check_x
{
   my $this = shift;
   my $signal_name = shift;

   my @signal_outputs =
       $this->get_signal_sources_by_name($signal_name);

   foreach my $signal_output (@signal_outputs)
   {
      $signal_output->check_x($signal_name);
   }
}



=item I<attribute_string()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub attribute_string
{
   my $this = shift;
   my $signal_name = shift;

   my @signal_outputs =
       $this->get_signal_sources_by_name($signal_name);

   my @strings;
   foreach my $signal_output (@signal_outputs)
   {
      push (@strings, 
            $signal_output->attribute_string($signal_name));
   }
   return @strings;
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

The inherited class e_object

=begin html

<A HREF="e_object.html">e_object</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
