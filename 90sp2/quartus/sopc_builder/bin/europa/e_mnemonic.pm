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



















































package e_mnemonic;

use e_mnemonic_table;
use europa_utils;
require Exporter;
@ISA = qw (e_object Exporter);
@EXPORT = qw(one_hot_code thermometer_encoding);

use strict;






















sub one_hot_code
{
   my ($value, $num_bits) = (@_);
   &ribbit ("num_bits argument missing") unless $num_bits;
   &ribbit ("value out-of-range") unless $value <= $num_bits;
   
   my $result  = "$num_bits\'b";
      $result .= "0" x ($num_bits - $value);
      $result .= "1"                 if $value > 0;
      $result .= "0" x ($value - 1)  if $value > 0;
  
   return $result;
}



















sub thermometer_encoding
{
   my ($value, $num_bits) = (@_);
   &ribbit ("num_bits argument missing") unless $num_bits;
   &ribbit ("value out-of-range") unless $value <= $num_bits;
   
   my $result  = "$num_bits\'b";
      $result .= "0" x ($num_bits - $value);
      $result .= "1" x ($value            );          
  
   return $result;
}


my @list_of_all_mnemonics = ();
my @all_counted_mnemonics = ();





my %fields = (
  _order              => ["name", 
                          "table", 
                          "bit_string", 
                          "num_subinstructions"],

  _table               => e_mnemonic_table->dummy(),
  bit_string          => "",
  num_subinstructions => 1,
  is_subinstruction   => 0,
  downcount_value     => 0,
  highest_brother_sub => 0,
  );

my %pointers = ();

&package_setup_fields_and_pointers(__PACKAGE__,
                                   \%fields,
                                   \%pointers);
sub new 
{
   my $that = shift;
   my $self = $that->SUPER::new(@_);

   $self->validate();

   &ribbit ("Mnemonic not assigned to any sub-table") 
       if $self->table()->isa_dummy();

   push (@list_of_all_mnemonics, $self);
   @all_counted_mnemonics = ();

   $self->construct_my_subinstructions() if $self->num_subinstructions() > 1;
   return $self;
}





sub get_mnemonic_by_name
{
   my $this     = shift;
   my $get_name = shift or &ribbit ("no name to get.");
   &ribbit ("must be called statically") unless ref ($this) eq "";
   
   foreach my $mnem (@list_of_all_mnemonics) {
      return $mnem if $mnem->name() =~ /^\s*$get_name\s*$/i;
   }

   &ribbit ("Cannot find mnemonic named '$get_name'");
}

sub construct_my_subinstructions
{
   my $this = shift;
   &ribbit ("takes no arguments") if @_;

   foreach my $i (0..$this->num_subinstructions()-1)
   {
      e_mnemonic->new 
          ({name                => $this->name()."_$i",
            bit_string          => $this->bit_string(),
            table               => $this->table(),
            is_subinstruction   => 1,
            downcount_value     => $this->num_subinstructions() - 1 - $i,
            highest_brother_sub => $this->num_subinstructions() - 1,
         });
   }
}

sub validate
{
   my $this = shift;
   &ribbit ("function takes no arguments") if @_;
   my $nm = $this->name();
   
   &ribbit ("no table found for mnemonic $nm") unless $this->table();


   my $bits = $this->bit_string() or &ribbit ("no bit string for $nm.");
   &ribbit ("bit string width '$bits' doesn't match table depth for $nm") 
       unless (&Bits_To_Encode($this->table()->depth() - 1) == 
               length ($this->bit_string()));

   &ribbit ("$nm: Bit string '$bits' can only contain '1', '0', or 'x'")
       unless $this->bit_string() =~ /^[10x]+$/;
}












sub does_match_x_regexp
{
   my $this     = shift;
   my $x_regexp = shift or &ribbit ("missing x-regexp argument");
   &ribbit ("regexp-argument [", $x_regexp, "] must be a string") 
       unless ref ($x_regexp) eq "";

   return 0 if $this->num_subinstructions() > 1;

   $x_regexp =~ s/x$/.*/;   # x's at the end match any # of chars.

   $x_regexp =~ s/x/.*/;    # x's in the middle match 1 or more.







   my $big_brother = $this->highest_brother_sub();
   $x_regexp =~ s/_n$/_$big_brother/;
   return $this->name() =~ /^$x_regexp$/;
}








sub count_all_mnemonics
{
   my $this = shift;
   &ribbit ("access-only") if @_;
   return scalar (@all_counted_mnemonics) if @all_counted_mnemonics;
   my  $count = 0;
   foreach my $mnem (@list_of_all_mnemonics)
   {
      next if $mnem->num_subinstructions() > 1;
      $count++;
      push (@all_counted_mnemonics, $mnem);
   }
   return $count;
}

sub get_all_counted_mnemonics
{
   return @all_counted_mnemonics;
}









sub table
{
   my $this = shift;
   if (@_) 
   {
      my $arg = shift;
      &ribbit ("too many arguments") if @_;
      my $value = "";
      if (ref($arg) eq "")
      {

         $value = e_mnemonic_table->get_table ($arg) 
             or &ribbit ("no such table: $arg");
      } else {
         $value = $arg;
      }
      &ribbit ("expected a table of some kind") 
          unless ref ($value) eq "e_mnemonic_table";

      $this->_table ($value);
   }
   return $this->_table ();
}









sub unimplement
{
   my $this = shift;
   my (@x_regexps) = (@_);
   &ribbit ("must be called statically") unless ref ($this) eq "";
   
   foreach my $x_regexp (@x_regexps) {
      next if $x_regexp eq "";
      my @matches = e_mnemonic->get_matching_mnemonics($x_regexp);
      foreach my $mnemonic (@matches) {
         $mnemonic->is_implemented (0);
      }
   }
}









sub get_mnemonic_list
{
   my $ignored_this = shift;
   &ribbit ("access-only function") if @_;
   return @list_of_all_mnemonics;
}










sub max_num_subinstructions
{
   my $this = shift;
   &ribbit ("must be called statically") unless ref ($this) eq "";
   &ribbit ("unexpected argument") if @_;

   my @num_subs = ();
   foreach my $mnem (e_mnemonic->get_mnemonic_list())
   {
      push (@num_subs, $mnem->num_subinstructions());
   }
   return max (@num_subs);
}

sub subinstruction_bits
{
   my $this = shift;
   my $biggest_sub_num = $this->max_num_subinstructions(@_);
   
   return max (&Bits_To_Encode ($biggest_sub_num - 1), 1);
}

sub combine_reduction_strings
{
   my $this = shift;   # unused.  You may call this statically.
   my $result_string = shift;
   my @result_chars = split (//, $result_string);
   foreach my $input_string (@_)
   {
      &ribbit ("can't combine reduction strings of differing widths",
               "\n '$result_string'  and '$input_string'\n")
          if length ($input_string) != length($result_string);
      my @input_chars = split (//, $input_string);
      foreach my $i (0..scalar (@result_chars) -1)
      {
         my $a = $result_chars[$i];
         my $b = $input_chars [$i];

         &ribbit ("bit $i conflict '$result_string' and '$input_string'")
             if ($a !~ /x/i) && ($b !~ /x/i);

         $result_chars[$i] = $b if $b !~ /x/i;
      }
   }
   return join ("", @result_chars);
}   















sub get_matching_mnemonics_guts
{
   my $this = shift;
   my $include_unimplemented_mnemonics = shift;
   my (@x_regexps) = (@_);
   @x_regexps or &ribbit ("missing x-regexp argument");
   
   &ribbit ("must be called statically") unless ref ($this) eq "";

   my @match_list = ();
   foreach my $x_regexp (@x_regexps) 
   {
      &ribbit ("x-regexp argument [", $x_regexp, "] must be a string") 
          unless ref($x_regexp) eq ""; 
      
      foreach my $mnemonic (e_mnemonic->get_mnemonic_list()) 
      {
         next if (!$include_unimplemented_mnemonics && 
                  !$mnemonic->is_implemented()       );
         push (@match_list, $mnemonic) 
             if ($mnemonic->does_match_x_regexp($x_regexp));
      }
   }
   return @match_list;
}

sub get_matching_mnemonics 
{ 
   my $this = shift;
   return $this->get_matching_mnemonics_guts (0, @_);
}

sub is_valid_regexp
{
   my $this = shift;
   return 0 if scalar ($this->get_matching_mnemonics_guts(1, @_)) == 0;
   return 1;
}



























sub make_match_expression
{
   my $this = shift;
   my $I    = shift or &ribbit ("expected instruction signal-name");  
   &ribbit ("instruction signal: expected name") unless ref ($I) eq "";
   my $S    = shift;  # May or may not have this.

   my ($op_msb, $op_lsb, $op_width) 
       = e_instruction_field->get_msb_lsb_width ($this->table()->field());




   &ribbit ("suspiciously-narrow opcode for ",$this->name()) if $op_width < 2;

   my @and_terms = ();
   push (@and_terms, $this->table()->make_match_expression($I));

   my $opcode = $this->bit_string();
   &ribbit ("strange.  Expected $op_width bits in opcode, got '$opcode'")
       unless length ($opcode) == $op_width;
   
   my @opcode_bits = split (//, $opcode);
   my $i_index = $op_msb;
   foreach my $op_bit (@opcode_bits)
   {
      push (@and_terms, " $I\[$i_index]") if $op_bit =~ /1/;
      push (@and_terms, "~$I\[$i_index]") if $op_bit =~ /0/;
      $i_index--;
   }
     
   if ($this->is_subinstruction() && $S)
   {
      my $sub_encoding = $this->downcount_value();
      my $n_sub_bits = &Bits_To_Encode($this->highest_brother_sub());
      foreach my $sub_bit (0..$n_sub_bits-1) 
      {
         if ($sub_encoding % 2) { 
            push (@and_terms, " $S\[$sub_bit]") ;
         } else {
            push (@and_terms, "~$S\[$sub_bit]") ;
         }
         $sub_encoding >>= 1;
      }
   }
   return "(".join(" && ", @and_terms).")";
}   
















sub make_opcode_display_module
{
   my $this = shift;
   my ($Opt, $project) = (@_);

   my $module = 
       e_module->new ({name => $Opt->{name}."_opcode_display_unit",
		       _additional_support => 
		       {
			_i_need_a_fixup => "1",
		       },
		      });
   $project->add_module($module);
   my $marker = e_default_module_marker->new ($module);

   e_port->add(["instruction", 16, "in"]);

   my $mnem_width = &Bits_To_Encode(scalar (@list_of_all_mnemonics) - 1);

   my @mux_table = ();
   my @ordered_name_list = ();
   my $ordinal_number = 0;
   foreach my $mnem (@list_of_all_mnemonics)
   {
      next if     $mnem->is_subinstruction();  # Top-level only, please.
      next unless $mnem->is_implemented();

      my $match_expr = $mnem->make_match_expression("instruction");
      push (@mux_table, "($match_expr)",  $mnem_width."'d".$ordinal_number);
      push (@ordered_name_list, $mnem->name());
      $ordinal_number++;
   }

   e_mux->add 
       ({lhs   => e_signal->new({name         => "opcode",
                                 width        => $mnem_width,
                                 never_export => 1,            }),
         table => \@mux_table,
         tag   => "simulation",
      });

   my $SIM_SECTION = $project->module_ptf()->{SIMULATION};

   my $cpu_name = $Opt->{name};
   my $type_cmd_string  = "virtual type { ";
   $type_cmd_string .= join (" ", @ordered_name_list);
   $type_cmd_string .= " } $cpu_name\_nios_opcode_type";
   
   $SIM_SECTION->{MODELSIM}{TYPES}{type1} = $type_cmd_string;

   return $module;
}












sub is_implemented
{
   my $this = shift;
   if (ref ($this) eq "")
   {
      my @match_list  = e_mnemonic->get_matching_mnemonics_guts (1, @_);
      foreach my $match (@match_list) {
         return 1 if $match->is_implemented();
      }
      return 0;   # I guess nobody matched.
   } else {
      $this->{is_implemented} = shift if (@_);
      if (!defined $this->{is_implemented})
      {
         $this->{is_implemented} = 1;
      }
      return $this->{is_implemented};
   }
}

sub display_as_opcodes
{
   my $this = shift;
   my ($Opt, $project, $module, $sig) = (@_);



   &ribbit ("sorry, this only works for signals in the top-module")
       unless ($project->top() == $module);
   
   $module->_additional_support()->{_i_need_a_fixup}="1";

   $module->add_contents
       (e_instance->new ({module   => $Opt->{name}."_opcode_display_unit",
                          name     => "$sig\_display",
                          port_map => {instruction => $sig},
                          tag      => "simulation",
                       })
        );





   my $SIM_SECTION = $project->module_ptf()->{SIMULATION};
   $SIM_SECTION->{Fix_Me_Up} = "";


   my $sig_cmd  = "virtual signal { ";
      $sig_cmd .= "__MODULE_PATH__/__FIX_ME_UP__/$sig\_display/opcode\[6:0\]";
      $sig_cmd .= " } $sig\_opcode_bits";

   my $cpu_name = $Opt->{name};
   my $func_cmd  = "virtual function { ($cpu_name\_nios_opcode_type) ";
      $func_cmd .= "__MODULE_PATH__/__FIX_ME_UP__/$sig\_display/$sig\_opcode_bits";
      $func_cmd .= " } $sig\_opcode";

   
   $SIM_SECTION->{MODELSIM}{SETUP_COMMANDS}{"$sig\_vsig"} = $sig_cmd;
   $SIM_SECTION->{MODELSIM}{SETUP_COMMANDS}{"$sig\_vfn"}  = $func_cmd;
}       












sub get_full_bitstring
{
   my $this = shift;
   my $mnem_name = shift or &ribbit ("missing mnemonic-name argument");
   &ribbit ("Please call statically") unless ref ($this) eq "";
   my $do_return_reduction_string = shift or "0";



   my $mnem = "";
   foreach my $test_mnem (@list_of_all_mnemonics) {
      $mnem = $test_mnem, last if $test_mnem->name() eq $mnem_name;
   }
   &ribbit ("name '$mnem_name' doesn't match any mnemonics") unless $mnem;

   my @or_terms = ();
   push (@or_terms, $mnem->table()->
         get_full_bitstring($do_return_reduction_string));
   push (@or_terms, 
         e_instruction_field->place_value_as ($mnem->table()->field(), 
                                              $mnem->bit_string(),
                                              $do_return_reduction_string));
   
   my $result = "";
   if ($do_return_reduction_string) { 
      push (@or_terms, $mnem->subinstruction_bitstring());
      $result  = $this->combine_reduction_strings (@or_terms);
   } else {
      $result = join (" | ", @or_terms);
      $result =~ s/x/0/sg;   # We treat x's as zeroes 
   }
   return $result;
}

sub subinstruction_bitstring
{
   my $this = shift;
   &ribbit ("access-only function") if @_;
   return "x" x (16 + e_mnemonic->subinstruction_bits())
       unless $this->is_subinstruction();

   my $n_bits = e_mnemonic->subinstruction_bits();
   my $n_sub_bits = &Bits_To_Encode($this->highest_brother_sub());
   my $val = $this->downcount_value();
   my $result = "";
   for my $i (0..$n_sub_bits-1)
   {
      my $next_lsb = $val % 2;
      $result .= "$next_lsb";
      $val = int ($val/2);
   }
   $result .= "x" x ($n_bits - $n_sub_bits);


   $result = join ("", reverse(split (//, $result)));

   $result = ("x" x 16) . $result;
   return $result;
}
   
"Make your time.";







