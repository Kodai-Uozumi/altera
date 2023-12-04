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

e_object - description of the module goes here ...

=head1 SYNOPSIS

The e_object class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_object;
use europa_utils;

use strict;
use vars qw($AUTOLOAD);  # it's a package global

my $indent;
my $log_history_p = 0;
my %construction_tally = ();






  my %fields = 
      (
       name               => "",
       _AUTOLOAD_ACCEPT_ALL => 0,
       comment            => "",
       _creation_history  => '',
       isa_dummy => 1,
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
   my $ref = ref($this) || $this;
   my $self = bless ({},$ref);

   $self->set(@_);

   return $self;
}














=item I<do_log_history()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub do_log_history{my $this = shift; ($log_history_p) = (@_);}










=item I<dummy()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub dummy
{
  my $this  = shift;
  my $class = ref($this) || $this;

  return (bless {}, $class);
}










=item I<news()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub news
{
   my $this  = shift;
   my $class = ref($this) || $this;

   my @inputs = @_;

   my @outputs;
   foreach my $in (@inputs)
   {
      push (@outputs, $class->new($in));
   }

   return @outputs;
}

my $blab = 0;


=item I<blab()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub blab 
{
  my $this = shift;
  if (@_) {  $blab = shift};
  return $blab;
}

my %construction_tally = ();



=item I<print_construction_report()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub print_construction_report
{
  print STDERR "Construction history:\n";
  foreach my $class (keys(%construction_tally)) {
    printf STDERR "%9d %s\n", $construction_tally{$class}, $class;
  }
}








=item I<_common_member_setup()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _common_member_setup
{
  my $this     = shift;
  my $fields   = shift or &ribbit ("No fields.");
  my $pointers = shift or &ribbit ("No pointers (pass empty hash).");

  ref ($pointers) eq "HASH" or die ("YELL!\n");

  my $class_name = ref($this);
  warn ("creating a $class_name\n") if e_object->blab();


  my($element);
  foreach $element (keys %{$fields}) {
      $this->{_permitted}->{$element} = $fields->{$element};
    }

  foreach $element (keys %{$pointers}) {
    $this->{_pointers}->{$element} = $pointers->{$element};
  }







  @{$this}{keys %{$pointers}} = values %{$pointers};

  foreach $element (keys %{$this->{_permitted}}) {



    $this->$element($this->{_permitted}->{$element});
  }


  no strict 'refs';
  my $glob = $class_name.'::';
  my $p = $glob.'get_pointers';
  my $f = $glob.'get_fields';

  if (!defined(&$p) && !defined(&$f))
  {
     print "$this uses old new method\n";
     my $get_fields = sub 
     {
        my $this = shift;

        my @return_array =  (keys (%{$this->{_permitted}}));
        return (@return_array);
     };

     my $get_pointers = sub 
     {
        my $this = shift;

        my @return_array =  (keys (%{$this->{_pointers}}));
        return (@return_array);
     };

     *$p = $get_pointers;
     *$f = $get_fields;
     use strict 'refs';
  }
  my @pointers  = $this->get_pointers();
  print "pointers are @pointers\n";

  my @fields  = $this->get_fields();
  print "fields are @fields\n";
  return $this;
}














































=item I<_direct_copy_repair()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _direct_copy_repair
{
  &ribbit ("e_object::_direct_copy_repair called.  You must override.");
}












=item I<identify()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub identify
{
  my $this  = shift;

  my $id_string = "\n\n---------------------------------------\n";

  if ($this->can("name") && $this->name())
  {
     my $name = $this->name();
     $id_string .= "NAME: ($name)\n";
  }
  $id_string .= $this->_creation_history();
  $id_string .= "\n---------------------------------------\n";
  return $id_string;
}








=item I<copy_this()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub copy_this
{
   my $this  = shift;

   my $thing_to_copy    = shift;
   my $do_copy_pointers = shift;
   my $type = ref($thing_to_copy);

   if ($type eq "SCALAR")
   {
      my $new_thing = $$thing_to_copy;
      return (\$new_thing);
   }
   if ($type eq "ARRAY")
   {
      my @new_thing = @$thing_to_copy;
      return (\@new_thing);
   }
   if ($type eq "HASH")
   {
      my %new_thing = %$thing_to_copy;
      return (\%new_thing);
   }







   return ($thing_to_copy);
}



=item I<empty_array()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub empty_array
{
   return ();
}








=item I<copy()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub copy
{
  my $this  = shift;

  my $class = ref($this) or &ribbit ("copy: requires object reference");
  return $class->new ($this);
}











=item I<convert_to_new_class()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub convert_to_new_class
{
  my $source  = shift;
  my $source_class = ref($source) || &ribbit ("no source");
  my $destination = shift;
  my $destination_class = ref($destination) || &ribbit ("no destination");

  return ($source)
      if ($source_class eq $destination_class);

  foreach my $key ($destination->get_fields())
  {
     $destination->$key($source->copy_this($source->$key()));
  }

  return $destination;
}



















=item I<set()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub set
{
  my $this  = shift;
  my $in = shift;
  return if ($in eq '');

  my $p_hash;

  if (ref ($in) eq "ARRAY")
  {
     my @order = @{$this->_order()} or &ribbit 
         ("unable to set based upon array ref, no _order has been ",
          "specified");

     foreach my $input (@$in)
     {
        my $ord = shift (@order);
        $p_hash->{$ord} = $input;
     }
  }
  elsif (ref ($in) eq "HASH") {
    $p_hash = $in;

  }
  elsif (&is_blessed($in) && $in->isa(ref ($this)))
  {
     my @field_list = $this->access_methods_for_auto_constructor();

     foreach my $one_field (@field_list)
     {
        $p_hash->{$one_field} = $in->$one_field();
     }
  }
  else
    {
      &ribbit ("I am sorry, please rephrase what you are setting ",
               "in the form of a hash, array reference, or like object.");
     }

  my $function;
  foreach $function (keys (%$p_hash))
  {
     $this->$function($$p_hash{$function});
  }
  $this->isa_dummy(0);
  return $this;
}



=item I<access_methods_for_auto_constructor()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub access_methods_for_auto_constructor
{
   my $this = shift;
   return ($this->get_fields(), $this->get_pointers());
}








=item I<string_to_vhdl_comment()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub string_to_vhdl_comment
{
   my $this = shift;

   my $indent = shift;
   my $comment = shift || return;

   my $single_line_comment = '--';
   $comment = $indent.$single_line_comment.$comment;
   $comment =~ s/\n\s*(?=\S)/\n$indent$single_line_comment/sg;

   return("$comment\n");
}








=item I<string_to_verilog_comment()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub string_to_verilog_comment
{
   my $this = shift;

   my $indent = shift;
   my $comment = shift || return;

   my $single_line_comment = '//';
   $comment = $indent.$single_line_comment.$comment;
   $comment =~ s/\n\s*(?=\S)/\n$indent$single_line_comment/sg;

   return("$comment\n");
}




=item I<debug_to_string()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub debug_to_string
{
   my $this = shift;

   my $level = shift  || 0;
   my $indent = shift || "";
   my $value = shift or return();

   $level--
       if ($level);

   my $rs;
   if ($level)
   {
      if (&is_blessed($value) && $value->isa("e_object"))
      {
         $rs .= $value->debug
             (
              $level,
              "$indent  "
              );

         return ($rs);
      }
      
      if (ref ($value) eq "ARRAY")
      {
         my $index = 0;
         foreach my $key (@$value)
         {
            $rs .= $indent." $index \-\>  $key\n";
            $rs .= $this->debug_to_string
                (
                 $level,
                 $indent."  ",
                 $key
                 );
            $index++;
         }
         return ($rs);
      }
      
      if (ref($value) eq "HASH")
      {
         foreach my $key (%$value)
         {
            $rs .= "$indent$key \-\> $value->{$key}\n";
            $rs .= $this->debug_to_string
                (
                 $level,
                 $indent."  ",
                 $value->{$key}
                 );
         }
         return ($rs);
      }
   }
   return;
}



=item I<debug()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub debug
{
   my $this = shift;

   my $level = shift;
   my $indent = (shift or "");
   my $return_string;
   if ($level)
   {
      foreach my $field ($this->get_fields(),
                         $this->get_pointers())
      {
         my $value = ($this->{$field});
         $return_string .= "$indent$field \-\> $value\n";
         $return_string .= $this->debug_to_string(
                                                  $level,
                                                  $indent."  ",
                                                  $value
                                                  );
      }
   }
   return ($return_string);
}



























=item I<ptf_to_hashes()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub ptf_to_hashes
{
   my $this = shift;
   my $fields = shift or &ribbit 
       ("no ptf fields to convert to object");

   my @return_hashes;
   foreach my $name (sort (keys (%$fields)))
   {
      my $value = $fields->{$name};
      $value->{name} = $name;
      push (@return_hashes, 
            $value);
   }
   return (@return_hashes);
}



=item I<ptf_to_hash()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub ptf_to_hash
{
   my $this = shift;
   my @hashes = $this->ptf_to_hashes(@_);
   return ($hashes[0]);
}



























=item I<AUTOLOAD()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub AUTOLOAD 
{
  my $this = shift;

  my $reffo = ref($this);
  &goldfish ("You may have called an unknown function ($AUTOLOAD).\n",
             "  Did you 'use' the right modules?") if !$reffo;
  my $type = $reffo || $this;


  my $name = $AUTOLOAD;
  $name =~ s/.*://;   # strip fully-qualified portion

  return if $name eq "DESTROY";

  if (exists $this->{_permitted}->{$name}  ||
      exists $this->{_pointers}->{$name}    )
  {



    return ($this->{$name}) unless scalar(@_); 













    if (exists $this->{_pointers}->{$name}) {
      my $value = shift;
      my $pointer_thing = $this->{_pointers}->{$name};
      my $allowed_type  = ref ($pointer_thing);

      if (&is_blessed($pointer_thing)) {

        &ribbit ("Pointer-member $name must be set from a '$allowed_type'-ref")
          unless (&is_blessed($value) && $value->isa($allowed_type));
      } else {

        &ribbit ("Pointer-member $name must be set from a'$allowed_type'-ref")
          unless ($allowed_type eq ref ($value));
      }

      $this->{$name} = $value;
      return ($this->{$name});  # DONE.
    }


     &ribbit ("no _permitted member '$name' found (THIS CAN'T HAPPEN)")
       unless exists ($this->{_permitted}->{$name});

     my $permitted_thing = $this->{_permitted}->{$name};




     if (&is_blessed ($permitted_thing)) {
       my $member_type = ref ($permitted_thing);
       $this->{$name} = $member_type->new (@_);
       return ($this->{$name});  # DONE
     }








     my $value = shift;
     $this->{$name} = e_object->copy_this($value);
     return ($this->{$name});
  }




  if ($this->_AUTOLOAD_ACCEPT_ALL())
    {
      if (@_)
        {
          my $value = shift;
          $this->{$name} = $value;
        }

      if (!exists $this->{$name})
      {


      }
      return ($this->{$name});
    }
  else
    {
       &is_blessed($this) or &ribbit ("$this is not blessed\n");
       my $known_fields   = "\n " . join ("\n ", sort ($this->get_fields()));
       my $known_pointers = "\n " . join ("\n ", sort ($this->get_pointers()));
       my $keys = "\n " . join("\n ", sort(keys(%$this)));
       my $isa_dummy = $this->isa_dummy();
       
      
      &ribbit ("In object '$this->{name}' of class $type: can't access `$name' field\n",
               "known fields are: $known_fields\n",
               "known pointers are: $known_pointers\n",
               "keys: $keys\n",
               "by the way, this object is ", $isa_dummy ? "" : "not ", "a dummy\n",
              );
    }
}



=item I<handle_array()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub handle_array
{
   my $this = shift;
   my $array = shift;
   if (@_)
   {
      push (@$array, @_);
   }
   return $array;
}



=item I<handle_hash()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub handle_hash
{
   my $this = shift;
   my $hash = shift;
   my @args = @_;
   my $arg_number = @args;

   if (!defined ($hash))
   {
      &ribbit ("hash not defined\n");
   }
   if ($arg_number == 1)
   {
      return $hash->{$args[0]};
   }
   elsif ($arg_number == 0)
   {
      my %new_hash = %$hash;
      return \%new_hash;
   }
   elsif (($arg_number % 2) == 0)
   {
      my $key;
      my $value;

      while (($key,$value,@args) = @args)
      {
         if (ref ($value) eq "ARRAY")
         {
            push (@{$hash->{$key}}, @$value);
         }
         else
         {
            $hash->{$key} = $value;
         }
      }
   }
   else
   {
      &ribbit ("illegal number of arguments to hash",
               "($arg_number)");
   }
   return $hash;
}



=item I<DONE()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub DONE
{
   my $this = shift;

   return 1;
}



=item I<done()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub done
{
   return shift->DONE(@_);
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



=begin html



=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
