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

e_readmem - description of the module goes here ...

=head1 SYNOPSIS

The e_readmem class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_readmem;

use e_thing_that_can_go_in_a_module;
use e_module;
use e_signal;
use e_expression;
use e_project;
@ISA = ("e_thing_that_can_go_in_a_module");
use europa_utils;
use strict;





my %fields = (
              file         => "",
              mem_variable => "",
              hex_output   => 1,
              );

my %pointers = ();


&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );



=item I<update()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update
{
  my $this = shift;
  $this->parent(@_);
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
  my $this = shift;
  my $indent = shift;

  my $file = $this->file();
  my $mem_variable = $this->mem_variable();

  my $vs = $indent . "\$readmem";
  $vs .= $this->hex_output() ? 'h' : 'b';
  $vs .= qq[("$file", $mem_variable);\n];  

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

  my $vhdl_output_hdl;
  my $vhdl_output_libraries;
  my $vhdl_output_mem_init_code;

  my $libraries_hash = $this->parent_module->vhdl_libraries;


  $libraries_hash->{std}{textio} = "all";



  my $mem_variable = $this->mem_variable();
  my $mem_sig = $this->parent_module()->get_signal_by_name
    ($mem_variable) or &ribbit ("no mem sig found for $mem_variable\n");

  my $depth = $mem_sig->depth()
    or &ribbit ("no depth found for $mem_variable\n");
  my $width = $mem_sig->width()
    or &ribbit ("no depth found for $mem_variable\n");

  my $mem_width_bytes = $width / 8;

  my $file = $this->file();


  my $par_process = $this->parent_process();

  $par_process->vhdl_add_variable ("data_line", "LINE");
  $par_process->vhdl_add_variable ("the_character_from_data_line", "CHARACTER");
  $par_process->vhdl_add_variable ("b_munging_address", "BOOLEAN", "FALSE");
  $par_process->vhdl_add_variable ("converted_number", "NATURAL", 0);
  $par_process->vhdl_add_variable ("found_string_array", "STRING(1 TO 128)");
  $par_process->vhdl_add_variable ("string_index", "NATURAL", 0);
  $par_process->vhdl_add_variable ("line_length", "NATURAL", 0);
  $par_process->vhdl_add_variable ("b_convert", "BOOLEAN", "FALSE");
  $par_process->vhdl_add_variable ("b_found_new_val", "BOOLEAN", "FALSE");
  $par_process->vhdl_add_variable ("load_address", "NATURAL", 0);
  $par_process->vhdl_add_variable ("mem_index", "NATURAL", 0);
  $par_process->vhdl_add_variable ("mem_init", "BOOLEAN", "FALSE");
  $par_process->vhdl_add_file ("memory_contents_file", "TEXT OPEN read_mode IS", $this->file());

  my $quoted_string .= qq[
-- this should convert a hexadecimal string to an integer
FUNCTION convert_string_to_number(string_to_convert : STRING;
      final_char_index : NATURAL := 0)
RETURN NATURAL IS
   VARIABLE result: NATURAL := 0;
   VARIABLE current_index : NATURAL := 1;
   VARIABLE the_char : CHARACTER;

   BEGIN
      IF final_char_index = 0 THEN
         result := 0;
	 ELSE
         WHILE current_index <= final_char_index LOOP
            the_char := string_to_convert(current_index);
            IF    '0' <= the_char AND the_char <= '9' THEN
               result := result * 16 + character'pos(the_char) - character'pos('0');
            ELSIF 'A' <= the_char AND the_char <= 'F' THEN
               result := result * 16 + character'pos(the_char) - character'pos('A') + 10;
            ELSIF 'a' <= the_char AND the_char <= 'f' THEN
               result := result * 16 + character'pos(the_char) - character'pos('a') + 10;
            ELSE
               report \"Ack, a formatting error!\";
            END IF;
            current_index := current_index + 1;
         END LOOP;
      END IF; 
   RETURN result;
END convert_string_to_number;
];



  $this->parent_module->vhdl_add_string($quoted_string);


  $vhdl_output_mem_init_code .= qq[
   -- need an initialization process
   -- this process initializes the whole memory array from a named file by copying the
   -- contents of the *.dat file to the memory array.

   -- find the @<address> thingy to load the memory from this point 
IF(NOT mem_init) THEN
   WHILE NOT(endfile(memory_contents_file)) LOOP

      readline(memory_contents_file, data_line);
      line_length := data_line'LENGTH;


      WHILE line_length > 0 LOOP
         read(data_line, the_character_from_data_line);

	       -- check for the @ character indicating a new address wad
 	       -- if not found, we're either still reading the new address _or_loading data
         IF '\@' = the_character_from_data_line AND NOT b_munging_address THEN
  	    b_munging_address := TRUE;
            b_found_new_val := TRUE; 
	    -- get the rest of characters before white space and then convert them
	    -- to a number
	 ELSE 

            IF (' ' = the_character_from_data_line AND b_found_new_val) 
		OR (line_length = 1) THEN
               b_convert := TRUE;
	    END IF;

            IF NOT(' ' = the_character_from_data_line) THEN
               string_index := string_index + 1;
               found_string_array(string_index) := the_character_from_data_line;
	       b_found_new_val := TRUE;
            END IF;
	 END IF;

     IF b_convert THEN
       converted_number := convert_string_to_number(found_string_array, string_index);
       b_convert := FALSE;
       b_found_new_val := FALSE;
       string_index := 0;

       IF b_munging_address THEN
          load_address := converted_number;
          mem_index := load_address / $mem_width_bytes;
          b_munging_address := FALSE;
       ELSE
	  IF (mem_index < $depth) THEN
	    $mem_variable(mem_index) <= conv_std_logic_vector(converted_number, $mem_variable(mem_index)'LENGTH);
            mem_index := mem_index + 1;
          END IF;
       END IF; 
    END IF;
    line_length := line_length - 1; 
    END LOOP;

END LOOP;
-- get the first _real_ block of data, sized to our memory width
-- and keep on loading.
  mem_init := TRUE;
END IF;
-- END OF READMEM
];

  return($vhdl_output_mem_init_code);

}
1; # One! one wonderful package!  Ah ah ah!

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
