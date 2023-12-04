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


























































package e_component;
use e_blind_instance_port;
use e_instance;
use vars qw($AUTOLOAD);	
use e_thing_that_can_go_in_a_module;
@ISA = qw (e_thing_that_can_go_in_a_module);
@ISA = ("e_instance");

use strict;
use europa_utils;







my %fields = (
              _in_port_map => {},
              _out_port_map => {},
	      _inout_port_map => {},
              std_logic_vector_signals => [],
	      _port_default_values => {},
	      _tag => "component",
	      );

my %pointers = ();


&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );







sub port_default_values
{
   my $this = shift;

   my $port_map = $this->_port_default_values();
   if (@_)
   {
      my $num_args = scalar (@_);
      my ($first_arg) =  @_;

      if ($num_args > 1)
      {

         ($num_args % 2 == 0) or 
             &ribbit ("odd number of items for port_map (@_)\n");

         my @set_these = @_;
         my $key;
         my $value;

         while (($key, $value, @set_these) = @set_these)
         {
		 $port_map->{$key} = $value;
		 my $expression = e_expression->new($value);
		 $expression->parent($this);
         }
      }
      elsif (ref ($first_arg) eq "HASH")
      {
         $port_map = $this->_port_default_values(%$first_arg);
      }
      else #first arg is a scalar which points to port map.
      {
         $port_map =  $port_map->{$first_arg};
      }
   }

   return $port_map;
}


sub in_port_map
{
   my $this = shift;

   my $port_map = $this->_in_port_map();
   if (@_)
   {
      my $num_args = scalar (@_);
      my ($first_arg) =  @_;

      if ($num_args > 1)
      {
         my $expression_port_map = $this->_expression_port_map();
         ($num_args % 2 == 0) or 
             &ribbit ("odd number of items for port_map (@_)\n");

         my @set_these = @_;
         my $key;
         my $value;

         while (($key, $value, @set_these) = @set_these)
         {

            $port_map->{$key} = $value;
            my $module_ref = $this->_module_ref();
            my $expression = e_expression->new($value);
	    $expression_port_map->{$key} = $expression;
            $expression->parent($this);
         }
      }
      elsif (ref ($first_arg) eq "HASH")
      {
         $port_map = $this->in_port_map(%$first_arg);
      }
      else #first arg is a scalar which points to port map.
      {
         $port_map =  $port_map->{$first_arg};
      }
   }

   return $port_map;
}

sub inout_port_map
{
   my $this = shift;

   my $port_map = $this->_inout_port_map();

   @_ = %{$port_map};
   if (@_)
   {
      my $num_args = scalar (@_);
      my ($first_arg) =  @_;
      
      if ($num_args > 1)
      {
         my $expression_port_map = $this->_expression_port_map();
         ($num_args % 2 == 0) or 
             &ribbit ("odd number of items for port_map (@_)\n");

         my @set_these = @_;
         my $key;
         my $value;

         while (($key, $value, @set_these) = @set_these)
         {

            $port_map->{$key} = $value;
            my $module_ref = $this->_module_ref();
            my $expression = e_expression->new($value);
	    $expression_port_map->{$key} = $expression;
	    $expression->direction('inout');
            $expression->parent($this);
         }
      }
      elsif (ref ($first_arg) eq "HASH")
      {
         $port_map = $this->inout_port_map(%$first_arg);
      }
      else #first arg is a scalar which points to port map.
      {
         $port_map =  $port_map->{$first_arg};
      }
   }

   return $port_map;
}

sub out_port_map
{
   my $this = shift;

   my $port_map = $this->_out_port_map();
   if (@_)
   {
      my $num_args = scalar (@_);
      my ($first_arg) =  @_;

      if ($num_args > 1)
      {
         my $expression_port_map = $this->_expression_port_map();
         ($num_args % 2 == 0) or 
             &ribbit ("odd number of items for port_map (@_)\n");

         my @set_these = @_;
         my $key;
         my $value;

         while (($key, $value, @set_these) = @set_these)
         {

            $port_map->{$key} = $value;
            my $module_ref = $this->_module_ref();
            my $expression = e_expression->new($value);
            $expression_port_map->{$key} = $expression;
            $expression->direction('output');
            $expression->parent($this);
         }
      }
      elsif (ref ($first_arg) eq "HASH")
      {
         $port_map = $this->out_port_map(%$first_arg);
      }
      else #first arg is a scalar which points to port map.
      {
         $port_map =  $port_map->{$first_arg};
      }
   }

   return $port_map;
}

sub _update_instance
{
   my $this = shift;

   foreach my $port (keys (%{$this->out_port_map()}))
   {
      my $output_port = $this->{out_port_map}->{$port};
      my $expression = e_expression->new
          ($output_port);
      $expression->direction("out");
      my $parent_port_name = $expression->update
          ($this);

      $this->_expression_port_map()->{$port} = $expression;
   }

   foreach my $port (keys (%{$this->in_port_map()}))
   {
      my $input_port = $this->{in_port_map}->{$port};
      my $expression = e_expression->new
          ($input_port);
      $expression->direction("in");
      my $parent_port_name = $expression->update
          ($this);
      $this->_expression_port_map()->{$port} = $expression;
   }
   foreach my $port (keys (%{$this->inout_port_map()}))
   {
      my $inout_port = $this->{inout_port_map}->{$port};
      my $expression = e_expression->new
          ($inout_port);
      $expression->direction("inout");
      my $parent_port_name = $expression->update
          ($this);
      $this->_expression_port_map()->{$port} = $expression;
   }
}


sub set_module_project
{
   my $this = shift;
   return;
}

sub port_map
{
  my $this = shift;
   return $this->SUPER::port_map(@_);
}


sub vhdl_declare_component
{
  my $this  = shift;
  my $module_name = $this->_module_name() or 
       ("module has no name associated with it\n");
  my $vs = "  component $module_name is\n";
  
  my $internal_vs = $this->_figure_out_generic_map();
  $internal_vs   .= $this->_figure_out_port_map();
  $internal_vs    =~ s/\n/\n    /g;
  $vs .= "$internal_vs\n  end component $module_name;\n";

  return ($vs);
}

sub _figure_out_generic_map
{
   my $this = shift;
   my $pm_hash = $this->parameter_map();
   my @pm_keys = sort (keys (%$pm_hash));

   return unless (@pm_keys);

   my $vs = "GENERIC (\n  ";
   my @parameter_declarations;

   foreach my $key (sort (@pm_keys))
   {
      my $value = $pm_hash->{$key};
      my $type = ($value =~ /^\d+$/)? "NATURAL": "STRING";

      push (@parameter_declarations,
            e_parameter->new
            ({
               name      => $key,
               vhdl_type => $type,
               parent    => $this,
            })->to_vhdl()
            );
   }
   $vs .= join (";\n    ", @parameter_declarations);
   $vs .= "\n  );\n";

   return ($vs);
}

sub _figure_out_port_map
{
   my $this = shift;

   my $out_hash = $this->out_port_map();
   my @out_ports = sort (keys (%$out_hash));

   my $in_hash = $this->in_port_map();
   my @in_ports = sort (keys (%$in_hash));
   

   my $def_hash = $this->_port_default_values();
   my @def_name = sort (keys (%$def_hash));
   my @def_vals = sort (values (%$def_hash));


   my $inout_hash = $this->inout_port_map();
   my @inout_ports = sort (keys (%$inout_hash));
   
   
   if (@in_ports or @out_ports or @inout_ports)
   {
      my @port_declarations;
      foreach my $out (@out_ports)
      {

	      my $width = -2;
	      my $i = 0;
	      foreach my $defName (@def_name)
	      {
		      if( $defName eq $out )
		      {
			      $width = @def_vals[$i];

		      }
		      $i++;
	      }

         my $is_slv_bit = grep {$_ eq $out}
         @{$this->std_logic_vector_signals()};
	 if ($width == -2)
	 {
		 $width = $this->_expression_port_map()->{$out}->width();
	 }
         push (@port_declarations,
               e_blind_instance_port->new
               ({name      => $out,
                 width     => $width, 
                 direction => "out",
                 declare_one_bit_as_std_logic_vector => 
                     $is_slv_bit,
               })->to_vhdl()
               );
      }
      foreach my $in (@in_ports)
      {
	      

	      my $width = -2;
	      my $i = 0;
	      foreach my $defName (@def_name)
	      {
		      if( $defName eq $in )
		      {
			      $width = @def_vals[$i];

		      }
		      $i++;
	      }

         my $is_slv_bit = grep {$_ eq $in}
         @{$this->std_logic_vector_signals()};
	 if ($width == -2)
	 {
		 $width = $this->_expression_port_map()->{$in}->width();
	 }
         push (@port_declarations,
               e_blind_instance_port->new
               ({name      => $in,
                 width     => $width, 
                 direction => "in",
                 declare_one_bit_as_std_logic_vector => 
                     $is_slv_bit,
               })->to_vhdl()
               );
      }
      foreach my $inout (@inout_ports)
      {

	      my $width = -2;
	      my $i = 0;
	      foreach my $defName (@def_name)
	      {
		      if( $defName eq $inout )
		      {
			      $width = @def_vals[$i];

		      }
		      $i++;
	      }

         my $is_slv_bit = grep {$_ eq $inout}
         @{$this->std_logic_vector_signals()};
	 if ($width == -2)
	 {
		 $width = $this->_expression_port_map()->{$inout}->width();
	 }
         push (@port_declarations,
               e_blind_instance_port->new
               ({name      => $inout,
                 width     => $width, 
                 direction => "inout",
                 declare_one_bit_as_std_logic_vector => 
                     $is_slv_bit,
               })->to_vhdl()
               );
      }
      my $vs = "PORT (\n";
      $vs .= join (";\n    ", @port_declarations);
      $vs .= "\n  );";
      return ($vs);
   }









}

sub determine_biggest_non_copied_signals
{
   return;
}

sub update
{
   my $this = shift;
   $this->parent(@_);
   return;
}
__PACKAGE__->DONE();
