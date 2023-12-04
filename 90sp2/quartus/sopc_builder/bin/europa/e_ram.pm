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

e_ram - description of the module goes here ...

=head1 SYNOPSIS

The e_ram class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_ram;

use europa_utils;

use e_lpm_instance;
@ISA = qw (e_lpm_instance);

use e_blind_instance;

use strict;







my %fields =
(

  ebi_name          => "lpm_ram_dp_component",
  ebi_module_name   => "lpm_ram_dp",
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

   $self->port_map
       ({
          wren      => "wren"     ,
          wrclock   => "wrclock"  ,
          data      => "data"     ,  
          rdaddress => "rdaddress",
          wraddress => "wraddress",
          q         => "q"        ,
          rdclken   => "1'b1"    ,  # Default value.
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



=item I<_create_prototype_module()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _create_prototype_module
{
   my $this = shift;
   my $module = $this->SUPER::_create_prototype_module(@_);
   $module->add_contents 
       (e_width_conduit->news([qw (rdaddress wraddress)],
                              [qw (q data)]),
        );

   return $module;
}



=item I<ebi_in_port_map()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub ebi_in_port_map
{
  my $this = shift;
 
  my $map_and_a_flashlight = {
     wren => "wren",
     wrclock => "wrclock",
     data => "data",
     rdaddress => $this->_get_rdaddress_name(),
     wraddress => "wraddress",
     rdclken => $this->rdclken(),
  };

  $map_and_a_flashlight->{rdclock} = $this->get_rdclock_name()
      if $this->registered_readaddress or $this->registered_readdata();
  
  return $map_and_a_flashlight;
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
  if ($this->mif_file() && !$this->project()->is_hardcopy_compatible())
  {
    $file = "\"" . $this->mif_file() . "\"";
  }

  return {
    lpm_rdaddress_control =>
      $this->registered_readaddress() ? qq("REGISTERED") : qq("UNREGISTERED"),
    lpm_outdata           => 
      $this->registered_readdata() ? qq("REGISTERED") : qq("UNREGISTERED"),
    lpm_width             => $this->mem_data_width(),
    lpm_widthad           => $this->mem_addr_width(),
    lpm_file              => $file,
    lpm_hint              => qq("USE_EAB=$esb_imp_word"),
    lpm_indata            => qq("REGISTERED"),
    lpm_wraddress_control => qq("REGISTERED"),
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



  my @things = ();

  my @contents;
  if ($this->dat_file() || $this->mif_file())
  {
     my $dat_name = $this->dat_file();
        $dat_name = $this->name() . ".dat" unless $dat_name;
     my $readmem =  e_readmem->new({
                          file         => $dat_name,
                          mem_variable => "mem_array",
                          hex_output   => 1,
                       });

     my $language = $this->parent_module()->project()->language();
     if ($language =~ /vhdl/i)
     {
     e_signal->new([memory_has_been_read => 1,0,1])
         ->within($module);

     $this->_mem_array_signal()->vhdl_declare_only_type(1);
     push (@contents,
           e_if->new({
              condition => "memory_has_been_read != 1",
              then => [
                       $readmem,
                       e_assign->new
                       (["memory_has_been_read", 1]),
                       ],
                    })
           );
    }
    elsif ($language =~ /verilog/i)
    {
      push @things,
        e_initial_block->new({
          contents => [$readmem],
        });
    }
    else
    {
      ribbit("unknown language '$language'\n");
    }
  }

  push (@contents,
        e_if->new({
           comment => " Write data",
           condition => "wren",
           then => [
                    e_assign->new({
                       lhs => "mem_array[wraddress]",
                       rhs => "data",
                    }),
                    ],
        })
        );

  push @things, 
    e_process->new({
      clock => "wrclock",
      contents => \@contents,
    });


  map {$_->tag("simulation")} @things;

  $module->add_contents(@things);
}








=item I<rdclken()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub rdclken
{
  my $this = shift;
  
  return 'rdclken';
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
  my $this = shift;




   $this->update_blind_instance();
   $this->update_mem_depth();
  $this->module()->overriding_vhdl_simulation(
					      $this->big_string()
					     );

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
   my $address_width = $module->get_signal_by_name("wraddress")
       ->width();
   $blind_instance_pm->{lpm_widthad} = $address_width;

   my $data_width = $module->get_signal_by_name("q")
       ->width();
   $blind_instance_pm->{lpm_width} = $data_width;
}



=item I<add_child_to_signal_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_child_to_signal_list
{
   my $this = shift;
   my ($child, $signal_name, $db_name) = @_;
   if ($signal_name eq 'reset_n')
   {
      print '';
   }
   return $this->SUPER::add_child_to_signal_list(@_);
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
  my $mem_width_nibbles = $width / 4;
  my $file = "";





  if ($this->dat_file() || $this->mif_file())
  {
     my $dat_name = $this->dat_file();
        $dat_name = $this->name() . ".dat" unless $dat_name;
     $file = $dat_name;
  }

  my $read_dependent_variable = "rdaddress";
  my $write_dependent_variable = "wrclock";
  my $read_address = "rdaddress";
  my $write_address = "wraddress";
  my $read_variable;
  my $write_variable;
  my $read_addr_process;

  my $address_width = $this->mem_addr_width();
  my $address_msb   = $address_width - 1;
  if ($this->registered_readaddress())
   {
     $read_dependent_variable = "clk";
     $read_address = "rd_address_internal";



     my @read_variables = ($read_address);
     
     if ($this->Read_Latency() > 1)
     {
       for my $i (1 .. $this->Read_Latency() - 1)
       {
         push @read_variables, "d$i\_rdaddress";
       }
     }
     my $type_suffix;
     if($address_width > 1){
       $type_suffix = 'STD_LOGIC_VECTOR ('.$address_msb.' DOWNTO 0) := (others => \'0\');';
     }else{
       $type_suffix = 'STD_LOGIC;';
     }
     

     $read_variable = join('', map {"    VARIABLE $_ : $type_suffix\n"} @read_variables);
     

     my $indent = "                            ";
     my @read_addr_process_terms;
     if ($this->Read_Latency() > 1)
     {

         push @read_addr_process_terms, "d1_rdaddress := rdaddress;";

       if ($this->Read_Latency() > 2)
       {
         for my $i (2 .. $this->Read_Latency() - 1)
         {
           my $prev = $i - 1;
           push @read_addr_process_terms, 
             "d$i\_rdaddress := d$prev\_rdaddress;";
         }
       }

       my $last_index = $this->Read_Latency() - 1;
       push @read_addr_process_terms, "$read_address := d$last_index\_rdaddress;";

     }
     else
     {
       @read_addr_process_terms = "$read_address := rdaddress;"
     }
     




     @read_addr_process_terms = reverse @read_addr_process_terms;


     my $latent_read_address =
       join('', map {"$indent$_\n"} @read_addr_process_terms);

     $read_addr_process = qq[
			 IF clk'event AND clk = '1' AND rdclken = '1' THEN
$latent_read_address
                         END IF;
                        ];
   }


   if (1)
   {
     $write_dependent_variable = "wrclock";
     $write_address = "wr_address_internal";
     
     if($address_width > 1){
       $write_variable = 
         'VARIABLE '.$write_address.' : STD_LOGIC_VECTOR ('.$address_msb.' DOWNTO 0) := (others => \'0\');';



     }else{
       $write_variable = 
         'VARIABLE '.$write_address.' : STD_LOGIC;';
     }
   }

   my $width_dependent_write_part; 

   if($address_width > 1){
    $width_dependent_write_part = $mem_variable.'(CONV_INTEGER(UNSIGNED('.$write_address.')))'; 
   }else{
    $width_dependent_write_part = $mem_variable.'(CONV_INTEGER('.$write_address.'))';
   }

   my $read_process;
   my $write_process;
   $write_process = 
       'if wrclock\'event and wrclock = \'1\' then
        '.$write_address.' := wraddress;
        if wren = \'1\' then 
          '.$width_dependent_write_part.' := data;
        end if;
      end if;';
   
   if($address_width > 1){			     
     $read_process = 'q <= '.$mem_variable.'(CONV_INTEGER(UNSIGNED('.$read_address.')));';
   }else{
     $read_process = 'q <= '.$mem_variable.'(CONV_INTEGER('.$read_address.'));';
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
               WHEN 'X' | 'x' => conv_string((4*curr_char)-1  DOWNTO 4*(curr_char-1)) := "XXXX";
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
begin
   process ($write_dependent_variable, $read_dependent_variable) -- MG
    $read_variable
    $write_variable
    variable $mem_variable : $mem_type; -- MG
    
    begin
      -- Write data
      $write_process

      -- read data
      $read_process
      $read_addr_process


    end process;
];
}else{
    $memory_process = qq[
      $memory_initialization_routines

begin
   process ($write_dependent_variable, $read_dependent_variable) -- MG
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
$read_variable
    $write_variable
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
--               IF NOT(b_munging_address) THEN
--                 dat_string_array(string_index) := the_character_from_data_line;
--               END IF;
	       b_found_new_val := TRUE;
            END IF;
	 END IF;

     IF b_convert THEN

       IF b_munging_address THEN
          converted_number := convert_string_to_number(found_string_array, string_index);    
          load_address := converted_number;
          mem_index := load_address;
--          mem_index := load_address / $mem_width_bytes;
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



      -- Write data
      $write_process

      -- read data
      $read_process
      $read_addr_process


    end process;
];
};

return ($memory_process);
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
