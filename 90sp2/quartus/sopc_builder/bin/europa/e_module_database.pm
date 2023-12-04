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

e_module_database - description of the module goes here ...

=head1 SYNOPSIS

The e_module_database class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_module_database;
use e_object;
use e_signal_junction_database;
@ISA = ("e_signal_junction_database");
use strict;
use europa_utils;








my %fields = (
              module_names     => {},
              signal_types     => {},
              objects          => [],
              _instantiated_by => [],
              _determined_signals => 0,


              _input_port_cache   => {},
              _output_port_cache  => {},
              );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<parent()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub parent
{
   my $this = shift;
   return "";
}



=item I<add_child_to_signal_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_child_to_signal_list
{
   my $this = shift;
   my ($child, $signal_name, $db_name) = @_;

   my @instances = @{$this->_instantiated_by()};
   if (@instances && ($db_name =~ /p(u|or)t$/))
   {
      my $was_input = $this->is_input($signal_name);
      my $was_output = $this->is_output($signal_name);

      $this->SUPER::add_child_to_signal_list(@_);

      my $is_input  = $this->is_input($signal_name);
      my $is_output = $this->is_output($signal_name);




      if (($was_input  && !$is_input) ||
          ($was_output && !$is_output))
      {
         foreach my $instance (@instances)
         {
            $instance->remove_port ($signal_name);
         }
      }

      if ($is_output && !$was_output)
      {
         foreach my $instance (@instances)
         {
            $instance->add_port_of_direction ($signal_name, 'output');
         }
      }

      if ($is_input && !$was_input)
      {
         foreach my $instance (@instances)
         {
            $instance->add_port_of_direction ($signal_name, 'input');
         }
      }
   }
   else
   {
      $this->SUPER::add_child_to_signal_list(@_);
   }
}



=item I<remove_child_from_signal_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub remove_child_from_signal_list
{
   my $this = shift;
   my ($child, $signal_name, $db_name) = @_;

   my @instances = @{$this->_instantiated_by()};

   if (@instances && ($db_name =~ /p(u|or)t$/))
   {
      my $was_input = $this->is_input($signal_name);
      my $was_output = $this->is_output($signal_name);

      $this->SUPER::remove_child_from_signal_list(@_);

      my $is_input  = $this->is_input($signal_name);
      my $is_output = $this->is_output($signal_name);




      if (($was_input  && !$is_input) ||
          ($was_output && !$is_output))
      {
         foreach my $instance (@instances)
         {
            $instance->remove_port ($signal_name);
         }
      }

      if ($is_output && !$was_output)
      {
         foreach my $instance (@instances)
         {
            $instance->add_port_of_direction ($signal_name, 'output');
         }
      }

      if ($is_input && !$was_input)
      {
         foreach my $instance (@instances)
         {
            $instance->add_port_of_direction ($signal_name, 'input');
         }
      }
   }
   else
   {
      $this->SUPER::remove_child_from_signal_list(@_);
   }
}




=item I<add_child_to_parent_signal_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_child_to_parent_signal_list
{
   return;
}



=item I<remove_child_from_parent_signal_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub remove_child_from_parent_signal_list
{
   return;
}



=item I<add_child_to_parent_object_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_child_to_parent_object_list
{
   return;
}



=item I<remove_child_from_parent_object_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub remove_child_from_parent_object_list
{
   return;
}















=item I<get_object_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_object_names
{
   my $this = shift;
   my @filters = @_;
   my @object_names = keys (%{$this->_object_list()});
   my @return_list;

   if (@filters)
   {
      foreach my $filter (@filters)
      {
         foreach my $name (@object_names)
         {
            my $object = $this->_object_list()->{$name};
            push (@return_list, $name)
                if ($object->isa($filter));
         }
      }
      return (@return_list);
   }
   else
   {
      return @object_names;
   }
}



=item I<get_signal_by_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_signal_by_name
{
  my $this = shift;
  my $name = shift;
  &ribbit ("no name") if $name eq "";

  my $sig = $this->get_object_by_name($name, 'e_signal');
  if (&is_blessed($sig) && ($sig->name() ne $name))
  {
     print "sig is $sig\n";
     &ribbit ("$name doesn't match signal name:".$sig->name());
  }
  return $sig;
}













=item I<get_exclusive_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_exclusive_name
{
   my $this = shift;
   my $type = ref($this)
       or &ribbit ("$this is not an object");

   my $project = $this->_project() or &ribbit ("no project");
   return ($project->get_exclusive_name(@_));
}













=item I<is_output()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub is_output
{
  my $this = shift;

  my $name = shift or &ribbit ("no name");

  my $signal_db = $this->_signal_list()->{$name} || return 0;
  return 
      $signal_db->{never_export}? 0:
      $signal_db->{export}? 1:
      !$signal_db->{input} && $signal_db->{output};
}



=item I<get_output_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_output_names
{
  my $this  = shift;

  my @return_array;
  foreach my $name ($this->get_signal_names())
  {
     push (@return_array, $name)
         if ($this->is_output($name));
  }

  return (@return_array);
}












=item I<is_input()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub is_input
{
  my $this = shift;
  my $name = shift or &ribbit ("no name");

  my $signal_db = $this->_signal_list()->{$name} || return 0;
  return 
      $signal_db->{never_export}? 0:
      $signal_db->{export}? 0:
      !$signal_db->{output} && $signal_db->{input};
}



=item I<get_input_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_input_names
{
  my $this = shift;

   my @return_array;
   foreach my $name ($this->get_signal_names())
   {
      push (@return_array,$name)
          if ($this->is_input($name));
   }

   return (@return_array);
}



=item I<is_port()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub is_port
{
  my $this = shift;
  my $name = shift or &ribbit ("no name");
  return (($this->is_output($name)) || ($this->is_input ($name)));
}



=item I<_get_port_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_port_names
{
   my $this = shift;
   return ($this->get_output_names(),
           $this->get_input_names ());
}



=item I<get_port_names()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_port_names
{
   my $this = shift;
   return $this->_get_port_names(@_);
}



=item I<parent_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub parent_module
{
   my $this = shift;
   return $this;
}



=item I<get_port_direction_by_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_port_direction_by_name
{
   my $this = shift;
   my $sig_name = shift;
   &ribbit ("too many arguments") if @_;
   

   return "input" if $this->is_input($sig_name);
   


   &ribbit ("$sig_name is not a port on module ",$this->name())
       unless $this->is_output($sig_name);
   

   my $sig = $this->get_signal_by_name ($sig_name) 
       or die ("no such signal: $sig_name");
   return "inout" if $sig->_is_inout();


   return "output";
}



=item I<determine_biggest_non_copied_signal()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub determine_biggest_non_copied_signal
{
   my $this = shift;
   my $signal_name = shift;

   my $signal_list = $this->_signal_list();
   my $signal_array = $signal_list->{$signal_name}
   ->{signal} || [];

   my $best_signal;
   if (@$signal_array)
   {
      my @only_signals = 
          map {
             $_->get_signal_from_signal_list($signal_name)
              } @$signal_array;
      
      $best_signal = shift (@only_signals);
      foreach my $signal (@only_signals)
      {
         if (
             (!$signal->copied() && $best_signal->copied()) ||
             ( $signal->width()   > $best_signal->width())
             )
         {
            $best_signal = $signal;
         }
      }

      @$signal_array = ($best_signal);
   }
   else
   {
      $best_signal = e_signal->new({name => $signal_name,
                                    copied => 1});
      $best_signal->parent($this);
      $signal_list->{$signal_name}{signal} = [$best_signal];
   }
   $this->_object_list()->{$signal_name} = $best_signal;
   return $best_signal;
}



=item I<get_updated_instances()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_updated_instances
{
   my $this = shift;
   if (!defined $this->{_updated_instances})
   {
      my @instances;
      foreach my $content (@{$this->_updated_contents()})
      {
         if ($content->isa('e_instance'))
         {
            push (@instances, $content);
         }
      }
      $this->{_updated_instances} = \@instances;
   }
   return $this->{_updated_instances};
}



=item I<identify_signal_widths()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub identify_signal_widths
{
   my $this = shift;

   my $signal_list = $this->_signal_list();
   my @signals = $this->get_signal_names();
   
   foreach my $signal_name (@signals)
   {
      my @signal_conduit_list = $this->make_linked_signal_conduit_list
          ($signal_name);

      my $max_width = 1;
      my $type = '';
      foreach my $sig (@signal_conduit_list)
      {
         my $width = $sig->width();
         if ($width > $max_width)
         {
            $max_width = $width;
         }
         if (!$type)
         {
            $type = $sig->type();
         }
      }

      if ($type)
      {
         map {$_->type($type);$_->width($max_width) if ($_->copied());}
         @signal_conduit_list;
      }
      else
      {
         map {$_->width($max_width) if ($_->copied());}
         @signal_conduit_list;
      }
   }   

   foreach my $instance (@{$this->get_updated_instances()})
   {
      $instance->identify_signal_widths();
   }
}   



=item I<make_linked_signal_conduit_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_linked_signal_conduit_list
{
   my $this = shift;
   my ($signal_name) = @_;

   my @signal_list = (
                      $this->determine_biggest_non_copied_signal
                      ($signal_name)
                      );

   if ($this->is_port($signal_name))
   {

      foreach my $instance (@{$this->_instantiated_by()})
      {
         my $expression = $instance->_expression_port_map()
             ->{$signal_name};

         if (!$expression)
         {
            &ribbit ("No expression for $signal_name\n");
         }
         if ($expression->isa_signal_name() &&
             $expression->conduit_width())
         {
            my $remapped_signal = $expression->expression();
            $expression->conduit_width(0);
            push (@signal_list, $instance->parent_module()
                  ->make_linked_signal_conduit_list($remapped_signal));
         }
      }
   }
   return (@signal_list, 
           $this->SUPER::make_linked_signal_conduit_list(@_));
}



=item I<identify_inout_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub identify_inout_signals
{
   my $this = shift;
   foreach my $output ($this->get_output_names())
   {
      my @signals = $this->identify_inout_signal($output);
      foreach my $sig (@signals)
      {
         if ($sig->_is_inout())
         {
            map {$_->_is_inout(1);} @signals;
            last;
         }
      }
   }
}



=item I<identify_inout_signal()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub identify_inout_signal
{
   my $this = shift;
   my $signal_name = shift;

   return ($this->get_object_by_name($signal_name),
           $this->SUPER::identify_inout_signal($signal_name));
}



=item I<check_x()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub check_x
{
   my $this = shift;
   my $signal_name = shift;
   
   if ($this->is_input($signal_name))
   {
      my @instances = @{$this->_instantiated_by()};
      if (@instances)
      {
         foreach my $instance (@instances)
         {
            my $renamed_port = $instance->port_map($signal_name);
            if (!$renamed_port)
            {
               &ribbit ("no port for $signal_name\n");
            }
            $instance->parent_module()->check_x($renamed_port);
         }
      }
      else
      {
         $this->get_and_set_once_by_name
          ({
             thing => "e_process_x",
             name  => "check x for $signal_name",
             check_x => $signal_name,
           });
      }
   }
   else
   {
      $this->SUPER::check_x($signal_name);
   }
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
