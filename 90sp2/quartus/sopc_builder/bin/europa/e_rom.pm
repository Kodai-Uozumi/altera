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

e_rom - description of the module goes here ...

=head1 SYNOPSIS

The e_rom class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_rom;

use europa_utils;

use e_lpm_instance;
@ISA = qw (e_lpm_instance);

use strict;







my %fields =
(
  read_address => "address",
  

  ebi_name          => "lpm_rom_component",
  ebi_module_name   => "lpm_rom",
  ebi_out_port_map  => {qq(q) => qq(q)},

);

my %pointers =
(
);

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
   my $this  = shift;
   my $self  = $this->SUPER::new();
   $self->port_map({
                      address => "address",
                      "q"     => "q",
                   });

   $self->set(@_);


   $self->_create_prototype_module();

   if ($self->Read_Latency() >= 1)
   {
     $self->registered_readaddress(1);
   }
   
   if ($self->Read_Latency() >= 2)
   {
     $self->registered_readdata(1);
   }





   $self->_mem_array_signal()->vhdl_declare_only_type(1);

   return $self;
}



=item I<ebi_in_port_map()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub ebi_in_port_map
{
  my $this = shift;
  
  my $inp = {
    address => $this->_get_rdaddress_name(),
  };
  

  if ($this->registered_readaddress())
  {
    $inp->{inclock} = "clk";
  }
  
  if ($this->registered_readdata())
  {
    $inp->{outclock} = "clk";
  }
  
  return $inp;
}


=item I<ebi_parameter_map()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub ebi_parameter_map
{
  my $this = shift;
  my $esb_imp_word = $this->implement_as_esb() ? "ON" : "OFF";
  
  my $file = qq("UNUSED");
  if ($this->mif_file())
  {
    $file = "\"" . $this->mif_file() . "\"";
  }

  return {
    lpm_width             => $this->mem_data_width(),
    lpm_widthad           => $this->mem_addr_width(),
    lpm_file              => $file,
    lpm_address_control   => 
      $this->registered_readaddress() ? qq("REGISTERED") : qq("UNREGISTERED"),
    lpm_outdata           => 
      $this->registered_readdata() ? qq("REGISTERED") : qq("UNREGISTERED"),
    suppress_memory_conversion_warnings => qq("ON"),    # for Stratix
  };  
}



=item I<add_simulation_objects()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_simulation_objects
{
  my $this   = shift;
  my $module = shift;
  
  $this->SUPER::add_simulation_objects($module);
  


  my @things;



  if ($this->dat_file() || $this->mif_file())
  {
     my $dat_name = $this->dat_file();
        $dat_name = $this->name() . ".dat" unless $dat_name;
     my $ib = e_initial_block->new({
        contents => [
                     e_readmem->new({
                        file         => $dat_name,
                        mem_variable => "mem_array",
                        hex_output   => 1,
                     }),
                     ],
     });
     push @things, $ib;
  }


  map {$_->tag("simulation")} @things;
  
  $module->add_contents(@things);    
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
  my $this = shift;
  my $indent = $_[0];






  $this->update_blind_instance();
  $this->update_mem_depth();
  $this->module()->overriding_vhdl_simulation
    ($this->big_string());
  
  return $this->SUPER::to_vhdl(@_);
}



=item I<update_blind_instance()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub update_blind_instance
{
   my $this   = shift;
   my $module = $this->module();

   my $blind_instance_pm = $this->_blind_instance()->parameter_map();
   my $address_width = $module->get_signal_by_name("address")
       ->width();
   $blind_instance_pm->{lpm_widthad} = $address_width;
   my $data_width = $module->get_signal_by_name("q")
       ->width();
   $blind_instance_pm->{lpm_width} = $data_width;
}



=item I<big_string()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub big_string
{
  my $this = shift;





  my $mem_type =$this->_mem_array_signal()->name();
  my $mem_variable = "mem_array";
  my $mem_sig = $this->module()->get_signal_by_name
    ($mem_variable) or &ribbit ("no mem sig found for $mem_variable\n");


  $mem_variable = "Marc_Gaucherons_Memory_Variable";
  my $depth = $mem_sig->depth()
    or &ribbit ("no depth found for $mem_variable\n");
  my $width = $mem_sig->width()
    or &ribbit ("no depth found for $mem_variable\n");

  my $mem_width_bytes = $width / 8;
  my $mem_width_nibbles = $width /4;
  my $file;

  if ($this->dat_file() || $this->mif_file())
  {
     my $dat_name = $this->dat_file();
        $dat_name = $this->name() . ".dat" unless $dat_name;
     $file = $dat_name;
  }

  my $process_dependent_variable = "address";
  my $address = "address";
  my $other_variables;
  my $other_process;

  my $address_width = $this->mem_addr_width();
  my $address_msb   = $address_width - 1;
  if ($this->registered_readaddress())
   {
     $process_dependent_variable = "clk";
     if($address_width > 1){
       $other_variables = 
	 'VARIABLE d1_address : STD_LOGIC_VECTOR ('.$address_msb.' DOWNTO 0) := (others => \'0\');';
     }else{
       $other_variables = 
	 'VARIABLE d1_address : STD_LOGIC;';
     }
     $address = "d1_address";
     $other_process = qq[
			 IF clk'event AND clk = '1' THEN
                            d1_address := address;
                         END IF;
                        ];
   }

   my $read_process;
   if($address_width eq ""){
     $read_process =  'q <= '.$mem_variable.'(CONV_INTEGER('.$address.'));';
   }else{
     $read_process =  'q <= '.$mem_variable.'(CONV_INTEGER(UNSIGNED('.$address.')));';
   }
   

   my $memory_initialization_routines;
   if($file eq ""){
     $memory_initialization_routines = "";
   }else{
     $memory_initialization_routines = qq[
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
               report "Ack, a formatting error!";
            END IF;
            current_index := current_index + 1;
         END LOOP;
      END IF; 
   RETURN result;
END convert_string_to_number;


 FUNCTION convert_string_to_std_logic(value : STRING; num_chars : INTEGER; mem_width_bits : INTEGER)
 RETURN STD_LOGIC_VECTOR is			   
     VARIABLE conv_string: std_logic_vector((mem_width_bits + 4)-1 downto 0);
     VARIABLE result : std_logic_vector((mem_width_bits -1) downto 0);
     VARIABLE curr_char : integer;
              
     BEGIN
     result := (others => '0');
     conv_string := (others => '0');
     
          FOR I IN 1 TO num_chars LOOP
	     curr_char := num_chars - (I-1);

             CASE value(I) IS
               WHEN '0' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0000";
               WHEN '1' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0001";
               WHEN '2' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0010";
               WHEN '3' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0011";
               WHEN '4' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0100";
               WHEN '5' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0101";
               WHEN '6' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0110";
               WHEN '7' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "0111";
               WHEN '8' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1000";
               WHEN '9' =>  conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1001";
               WHEN 'A' | 'a' => conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1010";
               WHEN 'B' | 'b' => conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1011";
               WHEN 'C' | 'c' => conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1100";
               WHEN 'D' | 'd' => conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1101";
               WHEN 'E' | 'e' => conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1110";
               WHEN 'F' | 'f' => conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "1111";
               WHEN ' ' => EXIT;
               WHEN HT  => exit;
               WHEN others =>
                  ASSERT False
                  REPORT "function From_Hex: string """ & value & """ contains non-hex character"
                       severity Error;
                  EXIT;
               END case;
            END loop;

          -- convert back to normal bit size
          result(mem_width_bits - 1 downto 0) := conv_string(mem_width_bits - 1 downto 0);

          RETURN result;
        END convert_string_to_std_logic;
];}

my $memory_process;

if($file eq ""){
  $memory_process = qq[
  $memory_initialization_routines

begin

   process ($process_dependent_variable) -- MG
    $other_variables
    variable $mem_variable : $mem_type; -- MG
    
    begin

    $read_process 


    $other_process
    end process;
  ];
}else{
  $memory_process = qq[
$memory_initialization_routines

begin

   -- Data read is asynchronous.

   process ($process_dependent_variable) -- MG
    VARIABLE data_line : LINE;
    VARIABLE the_character_from_data_line : CHARACTER;
    VARIABLE b_munging_address : BOOLEAN := FALSE;
    VARIABLE converted_number : NATURAL := 0;
    VARIABLE found_string_array : STRING(1 TO 128);
    VARIABLE string_index : NATURAL := 0;
    VARIABLE line_length : NATURAL := 0;
    VARIABLE b_convert : BOOLEAN := FALSE;
    VARIABLE b_found_new_val : BOOLEAN := FALSE;
    VARIABLE load_address : NATURAL := 0;
    VARIABLE mem_index : NATURAL := 0;
    VARIABLE mem_init : BOOLEAN := FALSE;
    $other_variables
    FILE memory_contents_file : TEXT OPEN read_mode IS "$file";  
    variable $mem_variable : $mem_type; -- MG
    
    begin
   -- need an initialization process
   -- this process initializes the whole memory array from a named file by copying the
   -- contents of the *.dat file to the memory array.

   -- find the \@<address> thingy to load the memory from this point 
IF(NOT mem_init) THEN
   WHILE NOT(endfile(memory_contents_file)) LOOP

      readline(memory_contents_file, data_line);
      line_length := data_line'LENGTH;


      WHILE line_length > 0 LOOP
         read(data_line, the_character_from_data_line);

	       -- check for the \@ character indicating a new address wad
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
       IF b_munging_address THEN
          converted_number := convert_string_to_number(found_string_array, string_index);    
          load_address := converted_number;
          mem_index := load_address;
          -- mem_index := load_address / $mem_width_bytes;
          b_munging_address := FALSE;
       ELSE
	  IF (mem_index < $depth) THEN
	    $mem_variable(mem_index) := convert_string_to_std_logic(found_string_array, string_index, $width);
            mem_index := mem_index + 1;
          END IF;
       END IF; 
       b_convert := FALSE;
       b_found_new_val := FALSE;
       string_index := 0;
    END IF;
    line_length := line_length - 1; 
    END LOOP;

END LOOP;
-- get the first _real_ block of data, sized to our memory width
-- and keep on loading.
  mem_init := TRUE;
END IF;
-- END OF READMEM
    $read_process 

    $other_process
    end process;
];
};

return($memory_process);
};


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

The inherited class e_lpm_instance

=begin html

<A HREF="e_lpm_instance.html">e_lpm_instance</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
