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

e_mux - Multiplexor

=head1 SYNOPSIS

The e_mux class implements a multiplexor with an arbitrary number
of data inputs.  Prioritized input selection may be optionally
configured.

=head1 METHODS

=over 4

=cut

package e_mux;
use e_register;
use e_assign;
@ISA = ("e_assign");
use europa_utils;

use strict;







my %fields = (
              _table => [],
              _type           => "priority",
              _selecto        => e_expression->new(),
              _default        => e_expression->new(),
              _register       => e_register->new(),
              _register_output => 0,
              );

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<selecto()>

Return the _selecto attribute expression.

=cut

sub selecto
{
   my $this = shift;

   my $return = $this->_selecto(@_);
   if (@_)
   {
      $this->type('selecto');
      $return->parent($this);
   }
   return $return;
}



=item I<type()>

Select e_mux type to be either 'or_and' or 'priority'.  Types 'one_hot' and
'priority' are equivalent.

=cut

sub type
{
   my $this = shift;
   my $type = $this->_type(@_);
   if ($type eq 'one_hot')
   {
      $type = 'priority';
   }
   return $type;
}



=item I<default()>

Return the default rhs expression.

=cut

sub default
{
   my $this = shift;

   my $return = $this->_default(@_);
   if (@_)
   {
      $return->parent($this);
   }
   return $return;
}



=item I<_do_rhs()>

The only time this calls _do_rhs is for to_verilog and to_vhdl, so we hack it up
so that it doesn't update the parent and do a lot of unneccesary things.

=cut

sub _do_rhs
{
   my $this = shift;

   my $table_key;
   my $table_value;
   my $type = $this->type();
   my @mux_array;

   my @table = @{$this->table()};
   my @all_keys = ();

   my $default = $this->default()->expression();

   if ($type =~ /small/i)
   {
      if ($default ne '')
      {
         &ribbit ("default not allowed for small muxes");
      }

      if (@table > 3)
      {
         $type = 'or_and';
      }
      else
      {
         $type = 'priority';
      }
   }

   my $inner_operator = $type =~ /^or/i ? "|" : "&";
   my $lhs_width      = $this->lhs()->width();

   my @original_keys;
   while (($table_key,$table_value,@table) = @table)
   {
      $table_key = $table_key->expression();
      $table_value = $table_value->expression();

      push (@original_keys, $table_key);
      if ($type =~ /and/i)  # works for both: "and-or", "or-and"
      {
         if ($table_key eq $table_value) {
            push (@mux_array, "$table_value");
         }
         else  {
            $table_key      = "~$table_key" if $type =~ /^or/i;
            push (@all_keys, $table_key);
            push (@mux_array, 
               "(\{$lhs_width \{$table_key\}\} $inner_operator $table_value)");
         }
         next;
      }

      if (($type =~ /selecto/i) || ($type =~ /priority/i))
      {
         my $selecto = $this->selecto()->expression();
         $table_key = $selecto." == ".$table_key
             if ($type =~ /selecto/);
         if ($table_key)
         {
            push (@mux_array,
                  "($table_key)? $table_value"
                  );
         }
         next;
      }
      &ribbit ("mux type ($type) not supported/understood\n");
   }

   my $register_enable = &or_array(@original_keys);

   if (($type =~ /selecto/i) || ($type =~ /priority/i))
   {
      if ($default eq "")
      {

         my $last_value = pop (@mux_array);
         @table = @{$this->table()};
         my $last_key = pop (@table);
         push (@mux_array, $last_key->expression())
             if ($last_key);
         $register_enable = 1;
      }
      else
      {
         push (@mux_array, $default);
      }
   }
   else #and_or mux
   {


      if ($default ne "")
      {
         my $none_of_the_above = join (" && ", map {"(~($_))"} @all_keys);
         push (@mux_array, 
          "(\{$lhs_width \{$none_of_the_above\}\} $inner_operator $default)");
      }
      my $no_select_value = ($type =~ /^or/ ? "-1" : "0");

      push (@mux_array, $no_select_value)
          unless (@mux_array);
   }
  my $join_with_this = " \:\n"; #for priority or selecto muxes
     $join_with_this = " \|\n" if ($type=~ /^and/i);  # and-select
     $join_with_this = " \&\n" if ($type=~ /^or/i);   # or-select

   my $rhs = join ($join_with_this, @mux_array);
  $this->rhs($rhs);
}


=item I<table()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub table
{
   my $this = shift;

   my $return = $this->_table();
   if (@_)
   {
      foreach my $table (@{$return})
      {
         $table->remove_this_from_parent();
      }
      $this->_table([]);
      $this->add_table(@_);
   }
   return $return;
}







=item I<add_table()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_table
{
   my $this = shift;
   if ((@_ == 1) && (ref($_[0]) eq "ARRAY"))
   {
      $this->add_table_ref($_[0]);
   }
   else
   {
      $this->add_table_ref([@_]);
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
   my $return = $this->_table();

   ((@$ref % 2) == 0) || &ribbit 
       ("mux table @$ref does not have even number of entries\n");
   foreach my $in (@$ref)
   {
      my $expression = e_expression->new($in);
      $expression->parent($this);
      push (@$return, $expression);
   }

   if (@$ref)
   {
      $this->update_register;
   }
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
   my $this = shift;
   $this->_do_rhs();
   my $mux_vs = $this->SUPER::to_verilog(@_);
   my $register = $this->register();
   if ($register)
   {
      $mux_vs .= $register->to_verilog(@_);
   }

   return ($mux_vs);
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
   my $this = shift;
   $this->_do_rhs();
   my $mux_vs = $this->SUPER::to_vhdl(@_);
   my $register = $this->register();
   if ($register)
   {
      $mux_vs .= $register->to_vhdl(@_);
   }

   return ($mux_vs);
}


=item I<register()>

Adds a register to the e_mux output.

=cut

sub register
{
   my $this = shift;

   my $register = $this->_register();
   if (@_)
   {
      my $val = shift;

      if (ref ($val) eq 'HASH')
      {
         $this->_register_output(1);
         $this->_register()->set($val);
         $this->update_register();
      }
      elsif ($val =~ /^\d+$/)
      {
         $this->register({delay => $val});
      }
   }

   if ($this->_register_output())
   {
      $register->parent($this);
      return $register;
   }
   else
   {
      $register->parent('');
      return 0;
   }
}



=item I<update_register()>

If we've set e_mux to have a register output then by default it is always
enabled. We can override that and explicitly tell the register when to load.

=cut

sub update_register
{
   my $this = shift;

   my $register = $this->register();
   if ($register)
   {



      my $table = $this->_table();
      my @table_copy = @$table;
      if (@table_copy)
      {
         my $enable;
         my $default_expression = $this->default()->expression();
         if ($default_expression eq '')
         {
            my @enable_or_array;
            my $key; my $value;
            while (($key,$value,@table_copy) = @table_copy)
            {
               my $selecto = $this->selecto()->expression;
               my $key_expression = $key->expression();
               if ($selecto)
               {
                  $key_expression = "($selecto == $key_expression)";
               }
               push (@enable_or_array, $key_expression);
            }
            $enable = &or_array(@enable_or_array);
         }
         else
         {
            $enable = 1;
         }
         $register->enable($enable);
      }



      my @reg_sources = @{$register->_source_names()};
      my $register_in = $reg_sources[0];

      my $lhs = $this->lhs()->expression();
      if ($register_in ne $lhs)
      {
         $register->out($lhs);

         my @reg_sources = @{$register->_source_names()};
         my $register_in = $reg_sources[0];

         $this->lhs($register_in);
      }
   }
}



=item I<lhs()>

Assign the e_mux output signal.

=cut

sub lhs
{
   my $this = shift;

   if (@_)
   {
      $this->SUPER::lhs(@_);
      $this->update_register();
   }

   return $this->SUPER::lhs();
}


=item I<make_linked_signal_conduit_list()>

Method copied from e_signal_junction_database ...

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

=back

=cut

=head1 EXAMPLE

Here is an example of a simple four input mux instantiation.

my $data_mux = e_mux->new({
                	   lhs => e_signal->new({
                	                         name => "data_mux_out",
                	                         width => $data_width,
                	                         never_export => 1
                	                       }),
                	   table => [
                	             $sel_0 => $data_0,
                	             $sel_1 => $data_1,
                	             $sel_2 => $data_2,
                	             $sel_3 => $data_3
                	            ]
                         });

=head1 AUTHOR

Santa Cruz Technology Center

=head1 BUGS AND LIMITATIONS

list them here ...

=head1 SEE ALSO

The inherited class e_assign

=begin html

<A HREF="e_assign.html">e_assign</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
