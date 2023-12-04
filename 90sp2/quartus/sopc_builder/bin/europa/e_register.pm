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

e_register.pm - register instance

=head1 VERSION

1.1

=head1 SYNOPSIS

The e_register class defines a single or multi-bit wide registers.

=head1 DESCRIPTION

=head2 Overview

The e_register has many features. Synchronous and
asynchronous set and reset functionality may optionally
be included as well as data load enable pin.
Timing attributes may also be attached. For false path
timing definitions, we may attach cut_to_timing or cut_from_timing
to cut paths terminating or originating on the e_register data
pin.  We may also define multi-cycle paths terminating on the
e_register data pin.

=head2 Examples

  e_register->new({
		  out     => "data_out",
		  in      => "data_in",
		  clock   => "clk",
		  enable  => "1",
                  reset   => "reset_n",
		  preserve_register => "1"
		 });

=cut

package e_register;
use e_module;
use europa_utils;
use e_assign;

use e_process;
@ISA = qw (e_process);

use strict;

my %fields = (

              fast_in            => 0,
              fast_out           => 0,
              fast_enable        => 0,
              cut_to_timing      => 0,
              cut_from_timing    => 0,
	      multi_cycle_timing => 0,
	      timing_cycles      => 0,
	      max_delay          => 0,
              preserve_register  => 0,
              ip_debug_visible   => 0,
              _delay             => 1,
              _out               => e_expression->new(),
              _in                => e_expression->new(),
              _sync_set          => e_expression->new(),
              _sync_reset        => e_expression->new(),
              _enable            => e_expression->new ("clk_en"),
              _async_value       => e_expression->new("0"),
              _async_set         => e_expression->new(),
              priority           => "reset",
              _set_value         => e_expression->new("-1"),
              in_expr            => '"p$n"."_$out"',
              out_expr           => '"d$n"."_$in"',
              _data_names        => [],
              _updated           => 0,
              _internal_signals_have_been_updated => 0,
              existing_expressions => [],
              assigns            => [],
              _reg_names         => [],
              _source_names      => [],
              );

my %pointers = (_bogus_fast_instance => e_instance->dummy());

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );

=head1 METHODS

=over 4

=cut

sub get_default_expressions
{
   my $this = shift;
   return ($this->SUPER::get_default_expressions(),
           qw (_enable));
}

sub q   #   q == out
{
   my $this = shift;
   return $this->out(@_);
}
sub d   #   d == in
{
   my $this = shift;
   return $this->in(@_);
}

sub a_value
{
   my $this = shift;
   return ($this->async_value(@_));
}






sub edge
{
   my $this = shift;

   my $edge = shift;
   if ($edge =~ /^\s*pos/)
   {
      return ($this->clock_level(1));
   }
   else
   {
      return ($this->clock_level(0));
   }
}

sub async_edge
{
   my $this = shift;

   my $edge = shift;
   if ($edge =~ /^\s*pos/)
   {
      return ($this->reset_level(1));
   }
   else
   {
      return ($this->reset_level(0));
   }
}

sub reset_edge
{
   my $this = shift;
   return ($this->async_edge(@_));
}
sub set_edge
{
   my $this = shift;
   return ($this->async_edge(@_));
}


=item I<async_set()>

async_set sets the reset value in addition to async_set.  Later on
we check whether async_set is defined.  If it is, we set asynchronous
values to $all_ones, else we set asynchronous values to 0.
If we set reset, we undef async_set so that values are set to 0.

=cut

sub async_set
{
   my $this = shift;

   my $as = $this->_async_set();
   if (@_)
   {
      $as->set(@_);
      $this->reset(@_);
      $as->parent($this);
   }
   return ($as);
}

sub reset
{
   my $this = shift;


   $this->_async_set()->set('') if scalar(@_);

   return ($this->SUPER::reset(@_));
}


=item I<depth()>

Sets the depth of back-to-back series registers

=cut

sub depth
{
   my $this = shift;

   return ($this->delay(@_));
}


=item I<out(signal_name)>

Assigns a signal to the the output data pin.

=cut

sub out
{
   my $this = shift;

   my $out = $this->_out();
   if (@_)
   {
      $out->set(@_);
      $out->direction('output');
      $out->parent   ($this);
      $this->update_reg_names();
   }
   return $out;
}


=item I<in(signal_name)>

Assigns a signal to the the input data pin.

=cut

sub in
{
   my $this = shift;

   my $in = $this->_in();
   if (@_)
   {
      $in->set(@_);
      $in->parent   ($this);
      $this->update_reg_names();
   }
   return $in;
}

sub delay
{
   my $this  = shift;
   my $delay = $this->_delay(@_);
   if (@_)
   {
      $this->update_reg_names();
   }
   return $delay;
}

sub sync_set
{
   my $this = shift;

   my $sync_set = $this->_sync_set();
   if (@_)
   {
      $sync_set->set(@_);
      $sync_set->parent   ($this);
      $this->update_reg_names();
   }
   return $sync_set;
}

sub sync_reset
{
   my $this = shift;

   my $sync_reset = $this->_sync_reset();
   if (@_)
   {
      $sync_reset->set(@_);
      $sync_reset->parent ($this);
      $this->update_reg_names();
   }
   return $sync_reset;
}


=item I<enable(signal_name)>

Assigns the signal to the data load enable pin.  If this is a constant '1', 
then data loading is always enabled.

=cut

sub enable
{
   my $this = shift;

   my $enable = $this->_enable();
   if (@_)
   {
      $enable->set(@_);
      $enable->parent($this);
   }
   return $enable;
}


=item I<async_value(value)>

Assigns the value of the register upon asynchronous reset. By default its 0.

=cut

sub async_value
{
   my $this = shift;

   my $async_value = $this->_async_value();
   if (@_)
   {
      $async_value->set(@_);
      $async_value->parent($this);
   }
   return $async_value;
}

sub set_value
{
   my $this = shift;

   my $set_value = $this->_set_value();
   if (@_)
   {
      $set_value->set(@_);
      $set_value->parent($this);
   }
   return $set_value;
}

sub update_reg_names
{
   my $this = shift;

   if ($this->out()->expression() ||
        $this->in()->expression())
   {
      $this->build_reg_names ();
      return;
   }
}

sub build_reg_names
{
   my $this = shift;

   my $out = $this->out()->expression();
   my $in  = $this->in()->expression();

   my @reg_names;
   my @source_names;


   my $n        = $this->delay() || 1;
   my $delay    = $n;
   my $name_gen_expr = $this->out_expr();
   my $no_sync_set_reset = ($this->sync_set()->expression()   eq "") &&
                           ($this->sync_reset()->expression() eq "")  ;
   if (($in eq "") && $no_sync_set_reset)
   {
      $name_gen_expr = $this->in_expr();
      $in = eval ($name_gen_expr);
      &ribbit 
      ("Error evaluating out_expr ($name_gen_expr): ($@)")
      if ($in eq "");

   }
   else
   {
      if ($out eq "")
      {
         $out = eval ($name_gen_expr);
         &ribbit 
             ("Error evaluating out_expr ($name_gen_expr): $@") 
                 if ($out eq "");


      }

      if (!$this->in()->isa_signal_name())
      {
         $name_gen_expr = $this->in_expr();
      }
   }

   if ($out  eq "") {
      &ribbit ("Register with no output name:", $this->identify(),
               "In-value is: $in\n",
               "parent is: ", $this->parent()->name(), "\n");
   }

   push (@source_names, $in);
   my $i;
   my $out_expr = $this->out_expr();

   for ($i = 1; $i < $delay; $i++)
   {
      $n = $i;
      $n = $delay - $i if (!$this->in()->isa_signal_name);

      my $reg_name = eval ($name_gen_expr);
      &ribbit ("Error evaluating out_expr ($out_expr): $@") if $@;
      push (@reg_names,    $reg_name);
      push (@source_names, $reg_name);
   }

   push (@reg_names, $out);

   my $assigns = $this->assigns();

   foreach my $i (0 .. ($delay - 1))
   {
      if (!$assigns->[$i])
      {
         $assigns->[$i] = e_assign->new();
      }
      $assigns->[$i]->set ({lhs => $reg_names[$i],
                            rhs => $source_names[$i],
                            parent => $this,
                            conduit_width_if_appropriate => ()});
  }
   my $additional_assigns = @$assigns - $i;
   if ($additional_assigns)
   {
      my @dead_assigns = splice (@{$this->assigns()},
                                 $delay);

      foreach my $da (@dead_assigns)
      {
         $da->remove_this_from_parent();
      }
   }
   $this->_reg_names(\@reg_names);
   $this->_source_names(\@source_names);
}

sub rename_node
{
   my $this = shift;
   my ($old,$new) = @_;
   my $return = $this->SUPER::rename_node(@_);
   foreach my $reg (@{$this->_reg_names()},
                    @{$this->_source_names()})
   {
      $reg =~ s/\b$old\b/$new/g;
   }
   return $return;
}

sub build_process
{
   my $this = shift;
   my $async_value = $this->async_value()->expression();


   my @sync_reset_contents;
   my @sync_set_contents;
   my @sync_dq_contents = @{$this->assigns()};

   my @reg_names = @{$this->_reg_names};
   my @source_names = @{$this->_source_names};

   if ($this->delay() == 0)
   {
      $this->reset('');
      $this->clock('');
      $this->enable(1);
   }

   foreach my $reg_name (@reg_names)
   {

      if ($this->reset()->expression())
      {
         $this->asynchronous_contents  
             ([
               @{$this->asynchronous_contents()},
               e_assign->new
               ({
                  lhs => $reg_name,
                  rhs => $async_value,
               }),
               ]);
      }
      if ($this->sync_reset()->expression())
      {
         push (@sync_reset_contents,
               e_assign->new
               ({
                  lhs => $reg_name,
                  rhs => 0,
               })
               );
      }

      if ($this->sync_set()->expression())
      {
         my $set_value = $this->set_value()->expression();
         push (@sync_set_contents,
               e_assign->new
               ({
                  lhs => $reg_name,
                  rhs => $set_value,
               })
               );
      }
   }

























   my @hi_pri_contents      = @sync_set_contents;
   my @lo_pri_contents      = @sync_reset_contents;

   my $hi_pri_condition     = $this->sync_set();#->expression();
   my $lo_pri_condition     = $this->sync_reset();#->expression();

   my $synchronous_contents = [];

   my @method_call = ($this, 'contents');

   my $enable = $this->enable()->expression();
   if (($enable ne '1') && ($enable ne "1'b1"))
   {
      my $enable_if = e_if->new({condition => $enable});
      $this->method_call(@method_call,
                         $enable_if);
      @method_call = ($enable_if, 'then');
   }

   if ($this->priority() =~ /reset/i) {

     my @tmp          = @lo_pri_contents;
     @lo_pri_contents = @hi_pri_contents;
     @hi_pri_contents = @tmp;

     my $tmp           = $lo_pri_condition;
     $lo_pri_condition = $hi_pri_condition;
     $hi_pri_condition = $tmp;
   }

   my $hi_pri_if;
   if (@hi_pri_contents) {
      $hi_pri_if =  e_if->new 
       ({
         condition => $hi_pri_condition,
         then      => [@hi_pri_contents],
         else      => [],
        });

     $this->method_call(@method_call, $hi_pri_if);

     @method_call = ($hi_pri_if, 'else');
   }

   my $lo_pri_if;
   if ((@lo_pri_contents)) {
      $lo_pri_if =  e_if->new 
       ({
         condition => $lo_pri_condition,
         then      => [@lo_pri_contents],
         else      => [],
        });

     $this->method_call(@method_call, $lo_pri_if);

     @method_call = ($lo_pri_if, 'else');
   }

   unless ((@sync_set_contents || @sync_reset_contents) &&
           ($this->in()->expression eq ''))
   {
      $this->method_call(@method_call, @sync_dq_contents);
   }
}

sub method_call
{
   my $this = shift;
   my $thing = shift;
   my $method = shift;
   my @value = @_;

   $thing->$method(\@value);
}

sub to_verilog
{
   my $this = shift;
   my $vs;
   $this->build_process();
   $vs = $this->SUPER::to_verilog(@_);
   return ($vs);
}

sub to_vhdl
{
   my $this = shift;
   $this->build_process();

   my @timing_attributes;
   push @timing_attributes, '-to ""*""'   if $this->cut_to_timing();
   push @timing_attributes, '-from ""*""' if $this->cut_from_timing();


   my @attributes_list;
   push @attributes_list,'{'.((join ' ', @timing_attributes).'} CUT=ON')
     if ($this->cut_from_timing() || $this->cut_to_timing());


   my $max_delay = $this->max_delay();
   if ($max_delay =~ /(\d+)\s*(n|p)s/ && $1 != 0) {
     my $time_units = $2 . "s";
     push @attributes_list, "MAX_DELAY=$1$time_units";
   }
   push @attributes_list, 'FAST_OUTPUT_REGISTER=ON' if $this->fast_out();
   push @attributes_list, 'FAST_INPUT_REGISTER=ON'  if $this->fast_in();
   push @attributes_list, 'FAST_OUTPUT_ENABLE_REGISTER=ON' 
     if $this->fast_enable();

   push @attributes_list, 'PRESERVE_REGISTER=ON' if $this->preserve_register();

   my $timing_cycles = $this->timing_cycles;
   if ($this->multi_cycle_timing() && $timing_cycles>1) {
     push @attributes_list, "MULTICYCLE=$timing_cycles";
   }

   push @attributes_list, $this->user_attributes_elements('""');


   my $attribute = '';
   if (@attributes_list) {
     $attribute = (join ' ; ', @attributes_list) ;
   }


   if ($attribute)
   {
      my (@outs) = $this->out()->_get_all_signal_names_in_expression();
      map 
      {
         $this->parent_module()->add_attribute
             (ALTERA_ATTRIBUTE => {$_ => $attribute});
      } @outs;
   }

   if ($this->ip_debug_visible())
   {
      my (@outs) = $this->out()->_get_all_signal_names_in_expression();
      map 
      {
         $this->parent_module()->add_attribute
             (ALTERA_IP_DEBUG_VISIBLE => {$_ => 'true'});
      } @outs;
   }

   my $vs = $this->SUPER::to_vhdl(@_);
   return $vs;
}


=item I<attribute_string(attribute)>

Collects the set of synthesis or timing analyzer attributes on the e_register
instance and attaches these to the instance in the proper format for HDL.

=cut

sub attribute_string
{
   my $this = shift;
   my $name = shift;
   my @outs = $this->out()->_get_all_signal_names_in_expression();
   if (grep {$_ eq $name} @outs)
   {
      my @timing_attributes;
      push @timing_attributes, '-to \"*\"'   if $this->cut_to_timing();
      push @timing_attributes, '-from \"*\"' if $this->cut_from_timing();

      my @quoted_attributes;
      push @quoted_attributes,'{'.((join ' ', @timing_attributes).'} CUT=ON')
        if ($this->cut_from_timing() || $this->cut_to_timing());


      my $max_delay = $this->max_delay();
      if ($max_delay =~ /(\d+)\s*(n|p)s/ && $1 != 0) {
	my $time_units = $2 . "s";
	my $max_delay_attribute = 'MAX_DELAY=' .
	                          '\"'.
				  "$1$time_units".
	                          '\"';
	push @quoted_attributes, $max_delay_attribute;
      }
      push @quoted_attributes, 'FAST_OUTPUT_REGISTER=ON' if $this->fast_out();
      push @quoted_attributes, 'FAST_INPUT_REGISTER=ON'  if $this->fast_in();
      push @quoted_attributes, 'FAST_OUTPUT_ENABLE_REGISTER=ON'
        if $this->fast_enable();
      push @quoted_attributes, 'PRESERVE_REGISTER=ON'
        if $this->preserve_register();

      my $timing_cycles = $this->timing_cycles;
      if ($this->multi_cycle_timing() && $timing_cycles>1) {
	push @quoted_attributes, "MULTICYCLE=$timing_cycles";
      }

      push @quoted_attributes, $this->user_attributes_elements('\"');


      my $attribute = '';
      if (@quoted_attributes) {
        $attribute = ' "' .  (join ' ; ', @quoted_attributes) .  '"' ;
      }

      if ($this->ip_debug_visible())
      {


        $attribute .= "ALTERA_IP_DEBUG_VISIBLE = 1";
      }
      return $attribute;
   }
   else
   {
      return ''
   }
}

=back

=cut

=head1 BUGS AND LIMITATIONS

=head1 SEE ALSO

e_process.pm

=head1 AUTHOR

SCTC

=head2 History

=head1 COPYRIGHT

Copyright (c) 2001-2005, Altera Corporation. All Rights Reserved.

=cut

1;


