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

e_control_bit - description of the module goes here ...

=head1 SYNOPSIS

The e_control_bit class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_control_bit;
use europa_utils;
use e_pipe_module;
use e_mnemonic;
use e_port;
use e_initial_block;
use e_readmem;
use format_conversion_utils;
@ISA = ("e_port");
use strict;


my %all_control_bits_by_name = ();
my @_rommed_control_bits = ();   # Ordered-list of rommed control-bits.
my @_rom_contents = ();          # And the corresponding rom contents.

















































































































































my %fields = (
              _order           => ["name", "add_x_regexps"],
              exclude_from_rom => 0,
  
              _x_regexp_list   => {},  # Keep as hash for uniqueness
              _is_rom          => 0,
              _alias_cbit_name => "",
              );
my %pointers = ();


&package_setup_fields_and_pointers(__PACKAGE__,
                                   \%fields,
                                   \%pointers);



=item I<new()>

Object constructor

=cut

sub new 
{
   my $that = shift;
   my $self = $that->SUPER::new();


   if (scalar (@_) == 1 && ref ($_[0]) eq "") {
      $self->_construct_from_just_a_simple_string(@_);
   } else {
      $self->set(@_);
   }


   if ((scalar(@_) == 1) && (ref($_[0]) eq __PACKAGE__))
   {

   } else {

      &goldfish ("suspicious attempt to redefine control bit: ", $self->name())
          if $all_control_bits_by_name{$self->name()};
      $all_control_bits_by_name{$self->name()} = $self;
   }

   return $self;
}










=item I<parent()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub parent
{
   my $this = shift;
   return $this->SUPER::parent() unless @_;
   my $new_parent = shift;
   &ribbit ("too many arguments") if @_;
   &ribbit ("e_module argument required") 
       unless &is_blessed ($new_parent) && $new_parent->isa("e_module");

   &ribbit ("invalid attempt to add control-bit ",
            $this->name(), " to non-pipe-module ", 
            $new_parent->name())  
       unless $new_parent->isa("e_pipe_module");

   return $this->SUPER::parent ($new_parent);
}



=item I<_construct_from_just_a_simple_string()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _construct_from_just_a_simple_string
{
   my $this          = shift;
   my $simple_string = shift or &ribbit ("missing argument: string.");
   
   &ribbit ("badly-formed 'simple' name for control bit: $simple_string \n",
            "   (must start with 'do_i')\n")
       unless $simple_string =~ /^\s*do_i(\w+)\s*$/;
   
   $this->add_x_regexps ($1);
   $this->name($simple_string);
   return $this;
}



=item I<get_all_control_bits()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_all_control_bits
{
   my $this = shift;
   &ribbit ("access-only function") if @_;
   &ribbit ("Please call this function statically") unless ref($this) eq "";
   return values (%all_control_bits_by_name);
}



=item I<get_rommed_control_bit_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_rommed_control_bit_list
{
  my $this = shift;
  &ribbit ("access-only function") if @_;
  &ribbit ("Please call this function statically") unless ref($this) eq "";
  &ribbit(
    "Call 'allocate_rom_control_bits' before 'get_rommed_control_bit_list'\n"
  )
    if (!@_rommed_control_bits);
  return @_rommed_control_bits;
}
   


=item I<get_rom_contents()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_rom_contents
{
   my $this = shift;
   return @_rom_contents;
}



=item I<add_x_regexps()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_x_regexps
{
  my $this                = shift;
  my $pattern_list_string = shift or &ribbit ("missing list argument");

  &ribbit ("expected reference to space-separated string of mnemonic-patterns")
      unless ref ($pattern_list_string) eq "";


  $pattern_list_string =~ s/\,/ /sg;
  $pattern_list_string =~ s/\n/ /sg;   # Newlines are just whitespace.
  $pattern_list_string =~ s/^\s+//sg;  # Blast leading/trailing whitespace.
  $pattern_list_string =~ s/\s+$//sg;  # Blast leading/trailing whitespace.

  foreach my $pattern (split (/\s+/, $pattern_list_string))
  { 


     if ($pattern !~ /^\=(.*)$/) {
        &goldfish ("pattern '$pattern' does not match any known mnemonic.")
            unless e_mnemonic->is_valid_regexp ($pattern);
     }
     
     $this->_x_regexp_list()->{$pattern}++;
  }
}



=item I<width()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub width
{
   my $this = shift;
   if (@_) {
      &ribbit ("can't change the width of a control bit") 
          unless $_[0] == 1;
   }
   return $this->SUPER::width();
}



=item I<direction()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub direction
{
   my $this = shift;
   if (@_) { 
      &ribbit ("can't change the direction of a control bit") 
          unless $_[0] eq "in";
   }
   return $this->SUPER::direction();
}



=item I<get_regexps()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_regexps
{
   my $this = shift;
   &ribbit ("access-only") if @_;
   return keys (%{$this->_x_regexp_list()});
}



=item I<get_stage_number()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_stage_number
{
   my $this = shift;
   &ribbit ("access-only") if @_;
   return $this->parent_module()->get_stage_number();
}



=item I<is_simple_alias()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub is_simple_alias
{
   my $this = shift;
   &ribbit ("access-only") if @_;
   my @regexp_list = $this->get_regexps();
   foreach my $regexp (@regexp_list) 
   {
      return 0 unless $regexp =~ /^\=(.*)/; 
   }
   return 1;
}



=item I<does_depend_on_subinstruction()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub does_depend_on_subinstruction
{
   my $this = shift;
   &ribbit ("access-only") if @_;
   return 0 if 
       $this->get_stage_number() <= 
           e_control_bit->subinstruction_origin_stage_num() + 1;

   my @regexp_list = $this->get_regexps_recursively();
   foreach my $regexp (@regexp_list) {


=item I<regexps()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

      next unless $regexp =~ /_(n|\d+)$/;    # Ignore non-sub regexps.
      



      next if scalar (e_mnemonic->get_matching_mnemonics($regexp)) == 0;
      


      return 1;
   }


   return 0;
}



=item I<make_rom_column_list()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_rom_column_list
{
   my $this = shift;
   &ribbit ("too many arguments") if @_;
   

   my @result = ();
   for my $i (0..127) {
      push (@result, 0);
   }

   my @mnem_list = 
       e_mnemonic->get_matching_mnemonics($this->get_regexps_recursively());



   foreach my $mnem (@mnem_list) 
   {
      my $bitstring  = $mnem->bit_string();
      my $mnem_table = $mnem->table()->name(); 

      if      ($mnem_table =~ /major/i) {
         $bitstring = "0" .$bitstring;        # 1st half, 6-bit opcode.
      } elsif ($mnem_table =~ /U/i) {
         $bitstring = "10".$bitstring. "x0";  # 3rd quarter, 3-bit op, lsb=0 
      } elsif ($mnem_table =~ /V/i) {
         $bitstring = "10".$bitstring."xx1";  # 3rd quarter, 2-bit op, lsb=1
      } elsif ($mnem_table =~ /W/i) {
         $bitstring = "11".$bitstring;        # quarter 4, 5-bit opcode.
      }
      &fill_in_ones (\@result, [&convert_to_ordinals($bitstring)]);
   }
   return @result;
}   



=item I<fill_in_ones()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub fill_in_ones 
{
   my $destination_list = shift;
   my $source_list      = shift;
   foreach my $one_index (@{$source_list}) 
   {
      $destination_list->[$one_index] = 1;
   }
}



=item I<convert_to_ordinals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub convert_to_ordinals
{
   my $bitstring = shift;
   my @result = ();
   &ribbit ("bad bitstring: '$bitstring'") 
       if  $bitstring =~ /[^10x]/;

   if ($bitstring !~ /x/) {
      return (&bitstring_to_num($bitstring));
   } else {
      my $one_case = $bitstring;
      my $zero_case = $bitstring;
      $one_case  =~ s/x/1/;      # just the first one, please.
      $zero_case =~ s/x/0/;      # just the first one, please.
      return (&convert_to_ordinals($zero_case),
              &convert_to_ordinals($one_case) ,);
   }
}



=item I<bitstring_to_num()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub bitstring_to_num
{
   my $bitstring = shift;
   my @bits = split(//, $bitstring);
   my $result = 0;
   foreach my $bit (@bits)
   {
      $result *= 2;
      $result++ if $bit eq "1";
   }
   return $result;
}
   
















=item I<get_regexps_recursively()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_regexps_recursively
{
   my $this = shift;
   &ribbit ("access-only") if @_;

   my %regexp_hash = ();   
   foreach my $regexp (keys (%{$this->_x_regexp_list()}))
   {
      if ($regexp =~ /^\=(.*)$/) 
      {
         my $sub_cbit = $all_control_bits_by_name{$1};
         my @sub_regexp_list = $sub_cbit->get_regexps_recursively();
         foreach my $sub_regexp (@sub_regexp_list) {
            $regexp_hash {$sub_regexp}++ ;
         }
      } else {
         $regexp_hash {$regexp}++ ;
      }
   }
   return keys (%regexp_hash);
}










=item I<get_regexps_by_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub get_regexps_by_name
{
   my $this = shift;
   &ribbit ("Please call statically") unless ref ($this) eq "";

   my @result = ();
   foreach my $bit_name (@_)
   {
      my $control_bit_object = $all_control_bits_by_name{$bit_name}
        or &ribbit ("'$bit_name' is not a known control bit") ;
      push (@result, $control_bit_object->get_regexps());
   }            
   return @result;
}




















=item I<initialize_rom_contents()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub initialize_rom_contents
{
   my $this = shift;
   my ($Opt, $project) = (@_);
   
   $this->allocate_rom_control_bits(@_);
   $this->create_rom_contents(@_);
   


   my $rom_width = scalar(e_control_bit->get_rommed_control_bit_list());
   my $rom_depth = scalar(e_control_bit->get_rom_contents());

   my $file_base = $Opt->{name} . '_instruction_decoder_rom';
   my $mif_name = $file_base . ".mif";
   my $dat_name = $file_base . ".dat";
   my $hex_name = $file_base . ".hex";
   
   $this->create_rom_files(
     {
       mif_name => $mif_name,
       dat_name => $dat_name,
       hex_name => $hex_name,
       rom_width => $rom_width,
       rom_depth => $rom_depth,
       $Opt,},
     $project,
   );
  
   return $file_base;
}

my @bitstring_report = ();






=item I<allocate_rom_control_bits()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub allocate_rom_control_bits
{
   my $this = shift;
   my ($Opt, $project) = (@_);
   
   &ribbit ("Please call statically") unless ref ($this) eq "";
   my %score_table = ();
   foreach my $cbit (e_control_bit->get_all_control_bits()) {



      next if $cbit->exclude_from_rom();
      my %matched_mnemonics = (); # Use hash to avoid double-counting of mnems
      foreach my $x_regexp ($cbit->get_regexps_recursively()) 
      {
         my @match_list = e_mnemonic->get_matching_mnemonics($x_regexp);
         foreach my $mnemonic (@match_list) {
            $matched_mnemonics{$mnemonic->name()}++;
         }
      }
      my $num_matches = scalar(keys(%matched_mnemonics));
      my $score = $num_matches;








      my $stage_num = $cbit->get_stage_number();
      $score += e_pipe_module->get_max_delay() - $stage_num;



      $score = 0 if $stage_num < 1;
      $score = 0 if $cbit->is_simple_alias();
      if ($score && $cbit->does_depend_on_subinstruction()) {
         if ($Opt->{verbose}) {
            print STDERR "disqualifying ($score)", $cbit->name(), "\n";
         }
         $score = 0;
      }
      $score_table{$cbit->name()} = $score;
   }

   my @sorted_list 
       = reverse( sort {$score_table{$a} <=> $score_table{$b}} 
         keys(%all_control_bits_by_name));

   foreach my $i (0..$Opt->{num_rom_control_bits}-1) 
   { 
      my $bit_name = $sorted_list[$i];
      &ribbit ("ERROR: not enough qualified control-bits for decoder-ROM.\n")
          if $score_table{$bit_name} <= 0;
      print STDERR "ROMMED: $bit_name      ($score_table{$bit_name})\n"
          if ($Opt->{verbose});
      my $rommed_bit = $all_control_bits_by_name{$bit_name};
      $rommed_bit->_is_rom(1);


      push (@_rommed_control_bits, $rommed_bit);
   }

}



=item I<create_rom_contents()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub create_rom_contents
{
   my $this = shift;
   my ($Opt, $project) = (@_);

   my @rommed_control_bits = $this->get_rommed_control_bit_list();


   my @result = ();
   foreach my $control_bit (@rommed_control_bits)
   {
      my @column = $control_bit->make_rom_column_list();
      my $i = 0;
      foreach my $bit (@column)  {
         $_rom_contents[$i++] .= $bit;
      }
   }
   if ($Opt->{verbose}) 
   {
      print STDERR "Decoder-Rom might look something like this:\n";
      foreach my $bitstring (@_rom_contents)
      {
         print STDERR "  $bitstring\n";
      }
      print STDERR "\n";
   }
   
}



=item I<create_rom_files()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub create_rom_files
{
   my $this = shift;
   my ($Opt, $project) = (@_);
   




   
   &ribbit ("decoder-roms limited to 32-bits wide") 
       if $Opt->{rom_width} > 32;     # Enforce arbitrary limit.
   open (MIFFILE, ">$Opt->{mif_name}") 
       or &ribbit ("couldn't open $Opt->{mif_name}: $!");
   print MIFFILE "WIDTH=$Opt->{rom_width};\n";
   print MIFFILE "DEPTH=$Opt->{rom_depth};\n";
   print MIFFILE "ADDRESS_RADIX=HEX;\n";
   print MIFFILE "DATA_RADIX=HEX;\n";
   print MIFFILE "CONTENT BEGIN\n";
   my $addr = 0;
   
   my @rom_contents = $this->get_rom_contents();
   foreach my $bitstring (@rom_contents)
   {
      print MIFFILE sprintf ("  %08X : %08X;\n", 
                             $addr++, 
                             &bitstring_to_num($bitstring));
   }
   print MIFFILE "END;\n";
   close (MIFFILE);






   my $simdir = $project->simulation_directory();
     &fcu_convert ({"0"  => $Opt->{mif_name},
                   "1"  => $simdir . "/" . $Opt->{dat_name},
                   oformat => "dat",
                   width   => $Opt->{rom_width},
                  });





     &fcu_convert ({"0"  => $Opt->{mif_name},
                   "1"  => $simdir . "/" . $Opt->{hex_name},
                   oformat => "hex",
                   width   => $Opt->{rom_width},
                  });
}




















































































































































































































































=item I<make_decoder_rom_sim_model()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_decoder_rom_sim_model
{
   my $arg     = shift           or &ribbit ("No args!");
   my $Opt     = $arg->{Opt}     or &ribbit ("missing Opt-hash");
   my $project = $arg->{project} or &ribbit ("missing project");

   my $module_name = $Opt->{name}."_".$arg->{rom_name}."_sim_model";

   my $module = e_module->new ({name => $module_name});
   $module->do_black_box (1);
   $module->_hdl_generated (0);   # Make 1 if you really want to use lib cell.
   $module->_explicitly_empty_module (1);
   $project->add_module($module);
   my $marker = e_default_module_marker->new ($module);

   if ($Opt->{use_altsyncram})
   {

       e_port->adds 
           ([q_a         => $arg->{rom_width},   "out"],
            [clock0      => 1,                   "in" ],
            [clocken0    => 1,                   "in" ],
            [address_a   => $arg->{address_bits},"in" ],  );
            
       e_parameter->adds
           ([qw(lpm_type               altsyncram            STRING  ) ],
            [qw(operation_mode         ROM                   STRING  ) ],
            [  "width_a",              $arg->{rom_width},   "INTEGER"  ],
            [  "widthad_a",            $arg->{address_bits},"INTEGER"  ],
            [  "num_words_a",          $arg->{depth},       "INTEGER"  ],
            [qw(outdata_reg_a          UNREGISTERED          STRING  ) ],
            [  "init_file",            $arg->{mif_name},    "STRING"   ],  );

       e_signal->add ({name         => "mem_array",
                       width        => $arg->{rom_width},
                       depth        => $arg->{depth},
                       never_export => 1,
                       tag          => "simulation",
                    });

       e_signal->add ({name         => "p1_q",
                       width        => $arg->{rom_width},
                       never_export => 1,
                       tag          => "simulation",
                    });

       e_assign->add (["p1_q", "mem_array[address_a]"])->tag("simulation");

       e_register->add 
           ({out       => "q_a",   
             in        => "p1_q",  
             clock     => "clock0",
             enable    => "clocken0",
             tag       => "simulation",
             async_set => "1'b1",
          });

       e_initial_block->add({
          tag      => "simulation",


          clock        => "clock0",   
          contents => [
                       e_readmem->new({
                          tag          => "simulation",
                          file         => $arg->{dat_name},
                          mem_variable => "mem_array",
                          hex_output   => 1,
                       }),
                       ],
       });
   } else {

       e_port->adds 
           ([wren      => 1,                   "in" ],
            [wrclock   => 1,                   "in" ],
            [rdclken   => 1,                   "in" ],
            [rdclock   => 1,                   "in" ],
            [rdaddress => $arg->{address_bits},"in" ],
            [wraddress => $arg->{address_bits},"in" ],
            [data      => $arg->{rom_width},   "in" ],
            [q         => $arg->{rom_width},   "out"],  );
            
       e_parameter->adds
           ([qw(lpm_type               lpm_ram_dp            STRING  ) ],
            [  "lpm_width",            $arg->{rom_width},   "INTEGER"  ],
            [  "lpm_widthad",          $arg->{address_bits},"INTEGER"  ],
            [  "lpm_file",             $arg->{mif_name},    "STRING"   ],
            [qw(lpm_indata             REGISTERED            STRING  ) ],
            [qw(lpm_outdata            REGISTERED            STRING  ) ],
            [qw(lpm_wraddress_control  REGISTERED            STRING  ) ],
            [qw(lpm_rdaddress_control  UNREGISTERED          STRING  ) ],
            [qw(lpm_hint               USE_EAB=ON            STRING  ) ],  );

       e_signal->add ({name         => "mem_array",
                       width        => $arg->{rom_width},
                       depth        => $arg->{depth},
                       never_export => 1,
                       tag          => "simulation",
                    });

       e_signal->add ({name         => "p1_q",
                       width        => $arg->{rom_width},
                       never_export => 1,
                       tag          => "simulation",
                    });

       e_assign->add (["p1_q", "mem_array[rdaddress]"])->tag("simulation");

       e_register->add 
           ({out       => "q",   
             in        => "p1_q",  
             clock     => "rdclock",
             enable    => "rdclken",
             tag       => "simulation",
             async_set => "1'b1",
          });

       e_initial_block->add({
          tag      => "simulation",


          clock        => "rdclock",   
          contents => [
                       e_readmem->new({
                          tag          => "simulation",
                          file         => $arg->{dat_name},
                          mem_variable => "mem_array",
                          hex_output   => 1,
                       }),
                       ],
       });
   }
   return $module;
}

my %cbit_count_by_stage = ();



=item I<_implement_alias_logic()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _implement_alias_logic
{
   my $this = shift;
   my $source_bit_name = shift or &ribbit ("no source-bit name given");
   my $source_bit = $all_control_bits_by_name{$source_bit_name};

   &ribbit ("Can't implement control-bit ", 
            $this->name(), 
            " as an alias of unknown source-bit '$source_bit_name'.")
       unless $source_bit;
   
   my $source_stage_num = $source_bit->parent_module()->get_stage_number();
   my $stage_num        = $this      ->parent_module()->get_stage_number();

   &ribbit ("Sorry, you may only create aliases of control-bits 
             defined in previous (earlier) stages.  
             Can't make '",$this->name(),"' ($stage_num) from
             $source_bit_name ($source_stage_num)"                 ) 
       if $source_stage_num > $stage_num;

   my $alias_name = sprintf ("%s_delayed_for_%s", 
                             $source_bit_name, $this->name);

   
   if ($stage_num == $source_stage_num) {
      $source_bit_name = "p_$source_bit_name";
   } else {
      $stage_num -= 1 unless $stage_num == 0 ;
   }





   my @result = ($alias_name);
   


   push (@result, 
         e_assign->new(["$alias_name\_$source_stage_num", $source_bit_name]));
   push (@result, 
         e_assign->new([$alias_name, "$alias_name\_$stage_num"]));

   foreach my $i ($source_stage_num+1 .. $stage_num) 
   {
      my $prev = $i-1;
      my $local_clk_en = e_pipe_module->get_stage_clk_en_signal($prev);
      push (@result, e_register->new ({out    => "$alias_name\_$i",
                                       in     => "$alias_name\_$prev",
                                       enable => $local_clk_en,
                                    }));
   }
   return @result;
}



=item I<implement_logic()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub implement_logic 
{
   my $this = shift;
   my $instruction_word_signal_name = shift 
       or &ribbit ("Expected instruction-word signal name argument");
   ref ($instruction_word_signal_name) eq "" or &ribbit ("expected string.");
   my $subinstruction_signal_name = shift;

   &ribbit ("too many arguments") if @_;


   my $stage_num = $this->get_stage_number();





   my $logic_stage = $stage_num - 1;
   $logic_stage = 0 if $stage_num == 0;



   $logic_stage = 1 if ($this->_is_rom());

   my $suffix = "_" . ($logic_stage);

   $instruction_word_signal_name .= $suffix;





   
   $subinstruction_signal_name .= $suffix;
   $subinstruction_signal_name = ""
       if $stage_num <= e_control_bit->subinstruction_origin_stage_num() + 1;




   my $out_port = e_port->new ([$this->name()=> 1, "out"]);
   my @result = ($out_port);

   my @or_terms      = ("1'b0");
   my @comment_terms = ("Control-bit ".$this->name().", set by: ");
   my @bitstrings = ();

   my %matched_mnemonics = ();   # Just for scorekeeping/reporting.
   if (!$this->_is_rom()) {
      foreach my $x_regexp ($this->get_regexps()) 
      {









         if ($x_regexp =~ /^\=(.*)$/)
         {
            my $original_control_bit = $1;


            my ($delayed_alias_name, @delay_logic) = 
                $this->_implement_alias_logic($original_control_bit);
            push (@comment_terms, $delayed_alias_name);
            push (@or_terms, $delayed_alias_name);
            push (@result, @delay_logic);
            
         } else {
            
            my @match_list = e_mnemonic->get_matching_mnemonics($x_regexp);
            foreach my $mnemonic (@match_list) {
               $matched_mnemonics{$mnemonic}++;
               push (@comment_terms, $mnemonic->name());
               push (@or_terms, $mnemonic->make_match_expression
                                 ($instruction_word_signal_name,
                                  $subinstruction_signal_name   ));
               push (@bitstrings, e_mnemonic->get_full_bitstring
                     ($mnemonic->name(), "yes, reduction string, please."));
               
            }
         }
      }
   }


   my $N_bits = scalar(keys(%all_control_bits_by_name));
   my $N_mnem = e_mnemonic->count_all_mnemonics();
   my $num_matches = scalar(keys(%matched_mnemonics));
   push (@comment_terms, "\n Just one of $N_bits total control bits.\n");
   push (@comment_terms, 
         "\n Matches $num_matches of $N_mnem mnemonics, stage=$stage_num\n");
   my $logic_sig = e_signal->new (["p_".$this->name(), 1]);
   if (!$this->_is_rom()) {
      push (@result, e_assign->new ({lhs     => $logic_sig,
                                     rhs     => join (" ||\n", @or_terms     ),
                                  })); 
   }

   push (@bitstring_report, 
         $this->name(), " (\n", join (",\n", @bitstrings), "\n)\n");

   foreach my $s ($logic_stage .. $stage_num)
   {
      my $s1 = $s + 1;
      my $in_sig  = sprintf("p%d_%s", $s, $this->name());
         $in_sig  = sprintf("p_%s",       $this->name()) if $s == $logic_stage;
      my $out_sig = sprintf("p%d_%s", $s1,$this->name());
         $out_sig = $this->name()                        if $s == $stage_num;
      
      if ($s == $stage_num) {
         push (@result, e_assign->new 
                           ({lhs     => $out_sig,
                             rhs     => $in_sig,
                             comment => join (", ",    @comment_terms),
                          })  
               );
      } else {
         my $stage_enable = 
             e_pipe_module->get_stage_clk_en_signal($s);
         push (@result, e_pipe_register->new 
               ({out     => $out_sig,
                 in      => $in_sig, 
                 enable  => $stage_enable,
                })  
               );
      }    
   }




   $cbit_count_by_stage{$stage_num}++ if $num_matches;
   return @result;
}



=item I<print_logic_report_file()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub print_logic_report_file
{
   my $this = shift;
   my $fname  = shift or &ribbit ("no filename");

   print "Control-bit counts by stage:\n  ";
   print join ("\n  ", 
               map {"$_ : $cbit_count_by_stage{$_}"} 
               keys(%cbit_count_by_stage));
   print "\n";
   
   open (EXPRFILE, ">$fname") or &ribbit("couldn't open $fname ($!)");
   print EXPRFILE join ("", @bitstring_report);

   print EXPRFILE "\n-- List of all mnemonics:\n  ";
   foreach my $mnem (e_mnemonic->get_all_counted_mnemonics()) {
      print EXPRFILE "  ", $mnem->name(), "\n";
   }
   close EXPRFILE;
}








my $_subinstruction_origin_stage_num = 0;


=item I<subinstruction_origin_stage_num()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub subinstruction_origin_stage_num 
{
   my $this = shift;
   ref ($this) eq "" or &ribbit ("Please call statically");
   return $_subinstruction_origin_stage_num unless @_;
   return ($_subinstruction_origin_stage_num = shift);
}



"How are you gentlemen.";










=back

=cut

=head1 EXAMPLE

Here is a usage example ...

=head1 AUTHOR

Santa Cruz Technology Center

=head1 BUGS AND LIMITATIONS

list them here ...

=head1 SEE ALSO

The inherited class e_port

=begin html

<A HREF="e_port.html">e_port</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
