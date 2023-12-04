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









































package e_mnemonic_table;
use e_object;
use europa_utils;
@ISA = qw (e_object);
use strict;

my %all_tables = ();





my %fields = (
   field            => "",
   base_bit_string  => "",
   );

my %pointers = (
                _within_table     => e_mnemonic_table->dummy(),
);

&package_setup_fields_and_pointers(__PACKAGE__,
                                   \%fields,
                                   \%pointers);

sub _order
{
   return ["name", "field", "within_table", "base_bit_string"];
}

sub new 
{
   my $that = shift;
   my $self = $that->SUPER::new(@_);


   
   if ((scalar(@_) == 1) && (ref($_[0]) eq __PACKAGE__))
   {

   } else {

      &goldfish ("suspicious attempt to redefine table: ", $self->name())
          if (e_mnemonic_table->get_table($self->name()));
      $all_tables{$self->name()} =  $self;
   }

   return $self;
}

sub depth
{
   my $this = shift;
   &ribbit ("access-only function") if @_;
   my ($toss_msb, $toss_msb, $depth) 
       = e_instruction_field->get_msb_lsb_width ($this->field());
   return 2**$depth;
}

sub within_table
{
   my $this = shift;

   if (@_)
   {
      my ($arg, @other_stuff) = (@_);
      &ribbit ("too many arguments") if @other_stuff;


      if (ref($arg) eq "") 
      {
         if ($arg ne "") {
            my $outer_table = e_mnemonic_table->get_table ($arg);
            &ribbit ("no such table: $arg") unless $outer_table;
            return $this->_within_table ($outer_table);
         }
      } else {
         return $this->_within_table ($arg) 
             unless $arg->isa_dummy();
      }
   }
   
   return $this->_within_table();
}

sub get_table
{
   my $this = shift;
   scalar (@_) or &ribbit ("missing table-name argument"); 
   my $table_name = shift;
   &ribbit ("too many arguments") if @_;
   
   &goldfish ("Suspicious non-static call to get_table")
       unless ref ($this) eq "";

   return $all_tables{$table_name};
}












sub make_match_expression
{
   my $this = shift;
   return () if $this->within_table()->isa_dummy();
   my $I    = shift or &ribbit ("expected instruction signal-name");  
   &ribbit ("instruction signal: expected name") unless ref ($I) eq "";

   my ($op_msb, $op_lsb, $op_width) 
    = e_instruction_field->get_msb_lsb_width ($this->within_table()->field());




   &ribbit ("suspiciously-narrow opcode for ",$this->name()) if $op_width < 2;



   my @and_terms = ();
   push (@and_terms, $this->within_table()->make_match_expression());


   my $opcode = $this->base_bit_string();
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
   return "(".join (" && ", @and_terms).")";
}










sub get_full_bitstring
{
   my $this = shift;
   my $do_return_reduction_string = shift;
   &ribbit ("access-only function") if @_;
   return () if $this->within_table->isa_dummy();

   my ($op_msb, $op_lsb, $op_width) 
    = e_instruction_field->get_msb_lsb_width ($this->within_table()->field());

   my @or_terms = ();
   push (@or_terms, $this->within_table->get_full_bitstring());
   push (@or_terms, 
         e_instruction_field->place_value_as ($this->within_table()->field(), 
                                              $this->base_bit_string(),
                                              $do_return_reduction_string));

   my $result = "";
   if ($do_return_reduction_string) { 
      $result = e_mnemonic->combine_reduction_strings (@or_terms);
   } else {
      $result = join (" || ", @or_terms);
      $result =~ s/x/0/sg;   # We treat x's as zeroes 
   }
   return $result;
}

"What is truth?";




