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

e_lpm_base - description of the module goes here ...

=head1 SYNOPSIS

The e_lpm_base class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_lpm_base;
use e_blind_instance;
use europa_utils;

@ISA = ('e_blind_instance');
use strict;

my %fields = ();

my %pointers = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<vhdl_declare_component()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_declare_component
{
   &ribbit ("overload this with your vhdl declaration");
}



=item I<set_port_map_defaults()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub set_port_map_defaults
{
   return;
}



=item I<set_parameter_map_defaults()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub set_parameter_map_defaults
{
   return;
}



=item I<new()>

Object constructor

=cut

sub new
{
   my $this = shift;
   $this = $this->SUPER::new();
   $this->_parse_component_from_vhdl_component_declaration
       ();

   $this->set_port_map_defaults();
   $this->set_parameter_map_defaults();
   $this->set(@_);
   return $this;
}





=item I<_parse_component_from_vhdl_component_declaration()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _parse_component_from_vhdl_component_declaration
{
   my $this = shift;
   my $string = $this->vhdl_declare_component();

   if ($string =~ /^\s*COMPONENT\s+(\w+)\s+
       GENERIC\s*\(\s*(.*?)\s*\)\s*\;\s*
       PORT\s*\(\s*(.*?)\s*\)\s*\;\s*
       END\s+COMPONENT/six)
   {
      my ($module_name, $parameter_string, $port_string) = 
          ($1,$2,$3);

      $this->module($module_name);

      my @parameters = split (/\s*\;\s*/s, $parameter_string);
      foreach my $parameter (@parameters)
      {
         my ($name, $type, $default) = split 
             (/\s*\:\s*/s, $parameter);

         $default =~ s/^\=\s*(\S*)\s*$/$1/s;
         if ($default ne '')
         {
            $this->parameter_map({$name => $default});
         }
      }

      my @ports = split (/\s*\;\s*/s, $port_string);
      foreach my $port (@ports)
      {
         $this->_process_port($port);
      }
   }
   else
   {
      &ribbit ("couldn't parse $string");
   }
}



=item I<_process_port()>

Called for each port identified in the VHDL component declaration.
Adds this port to the object's port lists.

=cut

sub _process_port
{
   my $this = shift;
   my $port = shift;

   if ($port =~ /^\s*(.*?)\s*\:\s*
       (IN|OUT|INOUT)\s+
       (STD_LOGIC_VECTOR|STD_LOGIC)
       \s*(\(\s*(\w+)\s*(\-\s*1\s*)?DOWNTO\s+0\s*\))?
       \s*(\:\=\s*(\S+))?
       /six
       )
   {
      my (
          $name_string,
          $direction,
          $type, 
          $vector_width, $msb, $minus_one, 
          $default
          ) = ($1,$2,$3,$4,$5,$6,$8);

      $direction = lc ($direction);
      my @names = split (/\s*\,\s*/s,$name_string);
      my @force_these_names_to_std_logic_vector;

      foreach my $name (@names)
      {




         my $name_appears_in_default_instance = 
             ($direction ne 'in') || ($default eq '');

         push (@force_these_names_to_std_logic_vector, $name)
             if ($type =~ /vector$/i);











         my $add_name_to_width_conduit_vector = 
             ($minus_one) && ($msb =~ /\D/);

         my $redirected_port_map_name =
             ($name_appears_in_default_instance)?
             $name : "open";

         my $port_map_name = $direction."_port_map";

         $this->$port_map_name
             ($name => $redirected_port_map_name);

         if ($add_name_to_width_conduit_vector)
         {
            push (@{$this->{_width_conduit_by_parameter_name}{$msb}},
                  $name);

            $this->_expression_port_map()->{$name}->conduit_width(1);
         }

      }




      push (@{$this->std_logic_vector_signals()},
            @force_these_names_to_std_logic_vector);
   }
   else
   {
      &ribbit ("couldn't parse $port string $port\n");
   }
}








=item I<find_linked_signals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub find_linked_signals
{
   my $this = shift;
   my $signal_name = shift;
   my $remove_conduit_width = shift;

   my @std_logic_vector_signals = @{$this->std_logic_vector_signals()};


   if (grep {$_ eq $signal_name} @std_logic_vector_signals)
   {
      my $parameter_width_hash = $this->{_width_conduit_by_parameter_name};

      foreach my $width_name 
          (keys (%$parameter_width_hash))
      {
         my @signal_list = @{$parameter_width_hash->{$width_name}};
         if (grep {$_ eq $signal_name} @signal_list)
         {
            if ($remove_conduit_width)
            {
               map{$this->_expression_port_map()->{$_}->conduit_width(0)}
               @signal_list;
            }

            return @signal_list;
         }
      }
   }
}



=item I<make_linked_signal_conduit_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_linked_signal_conduit_list
{
   my $this = shift;
   my $port_name = shift;

   my $port_map = $this->port_map();
   my %reverse_map = reverse (%$port_map);

   my $signal_name = $reverse_map{$port_name};

   if (!$signal_name)
   {
       &ribbit ("No signal for $port_name\n" .%reverse_map);
   }

   my @signal_list = $this->find_linked_signals($signal_name,1);



   my %exclusive_name;
   foreach my $signal (@signal_list)
   {
      my $port_mapped_name = $port_map->{$signal};

      $port_mapped_name =~ s/^([A-Za-z_]\w*)(\[\d+\])?$/$1/;

      next unless ($port_mapped_name =~ /^[A-Za-z_]\w*$/);
      $exclusive_name{$port_mapped_name}++;
      delete ($exclusive_name{$port_name});
   }
   my @exclusive = keys (%exclusive_name);

   my $parent_module = $this->parent_module();
   return map 
   {$parent_module->
        make_linked_signal_conduit_list($_);}
   @exclusive;
}









=item I<set_autoparameters()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub set_autoparameters
{
   my $this = shift;
   my $parameter_width_hash =
       $this->{_width_conduit_by_parameter_name};

   my $parent_module = $this->parent_module();

   foreach my $parameter (keys(%$parameter_width_hash))
   {
      my $max_width = 0;
      foreach my $signal_name 
          (@{$parameter_width_hash->{$parameter}})
      {
         my $mapped_signal = $this->port_map($signal_name);
         my $expression = $this->_expression_port_map->{$signal_name};
         my $expression_width = $expression->width();
         if ($expression_width > $max_width)
         {
            $max_width = $expression_width;
         }
      }
      $this->parameter_map({$parameter => $max_width});
   }
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
   my $this = shift;
   $this->set_autoparameters();
   return $this->SUPER::to_verilog(@_);
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
   my $this = shift;
   $this->set_autoparameters();
   return $this->SUPER::to_vhdl(@_);
}






=item I<port_map()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub port_map
{
   my $this = shift;
   
   if (@_)
   {
      if (@_ == 1)
      {
         return $this->SUPER::port_map(@_);
      }
      else
      {
         my $key;
         my $value;

         my @set_these = @_;
         (@set_these % 2 == 0) || &ribbit ("bad number @set_these");
         while (($key, $value, @set_these) = @set_these)
         {
            if ($this->in_port_map($key) ne '') {
               $this->in_port_map($key => $value);
            }
            elsif ($this->out_port_map($key) ne '') {
               $this->out_port_map($key => $value);
            }
            elsif ($this->inout_port_map($key) ne '') {
               $this->inout_port_map($key => $value);
            } else {
               &ribbit ("key ($key) isn't in the in-, out-, or inout-port map, so I don't feel safe adding ($value) to it");
            }
         }
      }
   }
   return $this->SUPER::port_map();
}
__PACKAGE__->DONE();

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
