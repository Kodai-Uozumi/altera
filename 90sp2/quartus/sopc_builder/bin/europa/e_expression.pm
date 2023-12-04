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

e_expression - description of the module goes here ...

=head1 SYNOPSIS

The e_expression class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_expression;

use europa_utils;
use e_signal;

use e_thing_that_can_go_in_a_module;
use vars qw($AUTOLOAD);		# it's a package global

@ISA = qw (e_thing_that_can_go_in_a_module);

use strict;








my %fields = (
              _hash                => {},
	      _vhdl_replace_number => 0,
	      _vhdl_replace_array  => [],
	      vhdl_type            => "",
	      vhdl_variable_type   => "",
	      de_ambigiousize      => 0,
              _vce      => "",
              _direction => 'input',
              _signal   => e_signal->dummy(),
              _has_signal => 0,
              _conduit_width => 0,
              isa_signal_name => 0,
              return_parenthesized => 0,
              );

my %pointers = (
                );


my $call_tally = 0;
my %caller_tally = ();

my $construction_type_tally = 0;
my %construction_type_tally = ();

my %update_tally = ();
my %update_tally_objs = ();

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );





=item I<access_methods_for_auto_constructor()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub access_methods_for_auto_constructor
{
   my $this = shift;
   return (qw(direction expression _has_signal _signal),
           $this->SUPER::access_methods_for_auto_constructor(@_));
}



=item I<enough_data_known()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub enough_data_known
{
   my $this = shift;
   return 
       $this->direction() &&
       $this->_parent_set() &&
       $this->expression();
}



=item I<add_this_to_parent()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub add_this_to_parent
{
   my $this = shift;

   if ($this->enough_data_known())
   {
      my @signals = 
          $this->_get_all_signal_names_in_expression();

      my $direction = $this->direction();
      foreach my $signal (@signals)
      {

         next if ($signal eq 'open');
         $this->add_child_to_parent_signal_list
             ($signal, $direction);
      }

      if ($this->conduit_width() && $this->isa_signal_name())
      {
         $this->add_child_to_parent_signal_list
             ($signals[0], 'call_me_if_sig_updates');
      }
      $this->_signal()->add_this_to_parent()
          if ($this->_has_signal());
   }
}



=item I<remove_this_from_parent()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub remove_this_from_parent
{
   my $this = shift;

   if ($this->enough_data_known())
   {
      my @signals =
          $this->_get_all_signal_names_in_expression();

      my $direction = $this->direction();
      foreach my $signal (@signals)
      {

         next if ($signal eq 'open');

         $this->remove_child_from_parent_signal_list
             ($signal, $direction);
      }
      if ($this->conduit_width() && $this->isa_signal_name())
      {
         $this->remove_child_from_parent_signal_list
             ($signals[0], 'call_me_if_sig_updates');
      }
   }
   $this->_signal()->remove_this_from_parent()
       if ($this->_has_signal());

}





=item I<set()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub set
{
   my $this = shift;
   my $arg = shift;

   if (&is_blessed($arg) && $arg->isa(__PACKAGE__))
   {
      $this->SUPER::set($arg);
   }
   else
   {
      $this->expression($arg);
   }
   return $this;
}



=item I<direction()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub direction
{
   my $this = shift;
   my $existing_direction = $this->_direction();

   if (@_)
   {
      my $new_direction = shift;
      if ($new_direction ne $existing_direction)
      {
         $this->remove_this_from_parent();
         $existing_direction = $this->_direction($new_direction);
         $this->add_this_to_parent($new_direction);
      }
   }
   return $existing_direction;
}

my @binary_sigs = qw (& | + - = < > ^ ? * / % );
my $need_parentheses_check = "[".join ('|',@binary_sigs)
    ."]";



=item I<expression()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub expression
{
   my $this = shift;

   if (!defined ($this->{expression}))
   {
      $this->{expression} = '';
   }
   my $existing_expression = $this->{expression};
   if (@_)
   {
      my $new_expression = shift;
      if ($new_expression ne $existing_expression)
      {

         $this->remove_this_from_parent();

         my $ref = ref ($new_expression);

         if (($ref eq 'HASH') ||
             ($ref eq 'ARRAY') ||
             ($ref && $ref->isa('e_signal'))
             )
         {
            my $signal = $this->_signal($new_expression);
            if ($this->_parent_set())
            {
               $signal->parent($this->parent());
            }
            $this->_has_signal(1);
            $new_expression = $signal->name();
            $new_expression = '~'.$new_expression
                if ($signal->_negated());
            $this->isa_signal_name(1);
            $this->return_parenthesized(0);
         }
         else
         {
            $new_expression =~ s/^\s*(.*?)\s*$/$1/s;
            my $return_parenthesized = 
                ($new_expression =~ /.$need_parentheses_check/os) &&
                ($new_expression !~ /^\([^\)]*\)$/s);
            $this->isa_signal_name
                (!$return_parenthesized &&
                 $new_expression =~ /^[A-Za-z_]\w*$/s && 
                 ($new_expression ne 'open'));
            $this->return_parenthesized($return_parenthesized);
         }
         $this->{expression} = $new_expression;
         $this->add_this_to_parent();
         $existing_expression = $new_expression;
      }
   }

   if ($this->return_parenthesized())
   {
      return '('.$existing_expression.')';
   }
   else
   {
      return $existing_expression;
   }
}



=item I<parent()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub parent
{
   my $this = shift;
   if (@_ && $this->_has_signal())
   {
      $this->_signal()->parent($_[0]);
   }
   return $this->SUPER::parent(@_);
}



=item I<_unique_name()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _unique_name
{

   my $this = shift;
   return $this->SUPER::_unique_name(@_, $this->expression());
}



=item I<is_null()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub is_null
{
   my $this = shift;
   return ($this->expression() eq "");
}



=item I<width()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub width
{
   my $this = shift;

   my $variables = shift && &ribbit
       ("You may not set the width of an expression, you may only set
    signal widths.");



   $this->to_vhdl();
   


   return 1 if ($this->vhdl_type eq "boolean");
   return $this->vhdl_type();
}



=item I<vhdl_hash_width()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub vhdl_hash_width
{
   my $this = shift;
   my $name = shift or return (0);
   my $hash = $this->_hash();
   $name =~ s/^\s*(.*?)\s*$/$1/s;
   return ($hash->{width}{$name} || 0);
}



=item I<_get_all_signal_names_in_expression()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_all_signal_names_in_expression
{
   my $this = shift;
   my $expression = shift || $this->expression();
   my @signals;
   if ($expression) {
      if ($expression =~ /HASH/) {
         ($this->identify(),"has hash in expression ($expression))\n");
      }
      




      $expression =~ s/[0-9]*\'[bodhBODH][\dA-Fa-fxXzZ]+//g;


      $expression =~ s/\w+\.\w+//g;       




      $expression =~ s/\[.*?\]//;


      @signals = $expression =~ /([A-Za-z_][\w]*)/g;
      my %unique_sigs;
      foreach my $us (@signals) {
         $unique_sigs{$us}++;
      }
      @signals = keys (%unique_sigs);
   }
   return (@signals);
}



=item I<rename_node()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub rename_node
{
   my $this = shift;
   my $old = shift or &ribbit ("no old signal name");
   my $new = shift or &ribbit ("no new signal name");

   my $expression = $this->expression();
   $expression =~ s/\b$old\b/$new/g or &ribbit 
       ("unable to rename expression $expression from $old to $new\n");
   $this->expression($expression);

   return;
}



=item I<replace_dot()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub replace_dot
{
   my $this = shift;

   my $pm = $this->parent_module();
   
   my ($signal_name) = shift or &ribbit ("no signal name");
   my ($field)       = shift or &ribbit ("no field");

   &ribbit ($this->_creation_history(),"not happy\n")
       if ($pm->isa_dummy());
   my $sig = $pm->get_object_by_name($signal_name);

   if (!$sig)
   {
      &goldfish ("Could not find a signal named ($signal_name)!");
      return "$signal_name\.$field";
   }

   my $return_this;

   my $width = $sig->width();
   return $width     if ($field =~ /^width$/);
   return $width - 1 if ($field =~ /^msb$/);
   return "[".($width - 1).":0]" 
       if ($field =~ /^width_sized_vector$/);
   &ribbit ("don't know what to do with field ($field)\n");
}



=item I<replace_sugar()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub replace_sugar
{
   my $this = shift;

   my $expr = $this->{expression};
   $this->expression($expr);
}



=item I<_make_leo_happy_indexwise()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _make_leo_happy_indexwise
{
   my $this = shift;
   my ($name,$index) = @_;


   return ("$name\[$index\]")
       if ($index =~ /^\s*[A-Za-z_]\w+\s*$/);

   my ($left,$right) = split (/:/,$index);

   $left  = eval ($left);
   $right = eval ($right);

   if (($left == $right) ||
       ($right eq "")) {
      my $sig = $this->parent_module()->get_signal_by_name($name)
          or &ribbit ("cannot find sig $name");

	my $lang = $this->parent_module()->project()->language();

      my $is_a_bit = ($sig->width() == 1) &&
          !(($sig->declare_one_bit_as_std_logic_vector()) && ($lang eq "vhdl"));
      if ($is_a_bit) {
         if ($left == 0) {
            return ($name);
         } else {
            &goldfish
                ("$name is width 1 but has non zero index in expr ".
                 $this->expression());
            return ("$name\[$index\]");
         }
      } else {
         return ("$name\[$left\]");
      }
   }
   return ("$name\[$left : $right\]");
}



=item I<to_verilog()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_verilog
{
   my $this = shift;
   my $return = $this->_preprocess_expression_string(@_);


   if ($return eq 'open')
   {
      return "";
   }
   return $return;
}



=item I<_preprocess_expression_string()>

Basic expression-munging needed by both Verilog and VHDL generation paths.

=cut


sub _preprocess_expression_string
{
   my $this = shift;
   my $crush_parens_string = shift;
   my $return;
   
   if($crush_parens_string eq "crush_parens_off")
   {
      $return = $this->expression();
   }
   else
   {
      $return = strip_enclosing_parentheses($this->expression());
   }

   $return =~ s/\b(\w+)\.(\w+)\b/$this->replace_dot($1,$2)/eg;
   $return =~ s/(\w+)\s*\[(.*?)\]/$this->_make_leo_happy_indexwise($1,$2)/gcse;
   
   return ($return);
}



=item I<print_time()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub print_time()
{
   my $this=shift;
   my ($message) = (@_);
   my ($user, $system, $cuser, $csytem) = times;
   print("time: $user -- $message\n");
}



=item I<debug_print()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub debug_print
{
   my ($expression) = @_;
   
   print "DEBUG: $expression\n";
}



=item I<pre_vhdl_equation()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub pre_vhdl_equation
{
   my $this = shift;
   return $this->_preprocess_expression_string("");
}



=item I<to_vhdl()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub to_vhdl
{
   my $this = shift;

   my $force_to_type = shift;
   my $force_to_vhdl_variable_type = shift;

   my $verilog_equation = $this->pre_vhdl_equation();
   if (($verilog_equation eq "") || 
       ($verilog_equation =~ /^\s*open\s*$/i)) {

      return $verilog_equation 
   }

   $this->_build_my_hash();

   my $equivalence_string;

   $verilog_equation =~ s/\&{2}/\`AND\`/sg;
   $verilog_equation =~ s/\|{2}/\`OR\`/sg;
   $verilog_equation =~ s/\!\={2}/\!\=/sg;
   $verilog_equation =~ s/\={3}/\=\=/sg;




   $this->vhdl_type($force_to_type)
       if ($force_to_type);

   $this->vhdl_variable_type($force_to_vhdl_variable_type)
       if ($force_to_vhdl_variable_type);


   $equivalence_string = $this->V2VHD_Equation($verilog_equation);
   
   $this->vhdl_type($this->vhdl_hash_width($equivalence_string));
   
   if (defined $force_to_type) {
      $equivalence_string = $this->Resize
          ($equivalence_string,
           $force_to_type
           );
   }






   my $bracket_equivalence_string =
       $this->Replace_Equivalences($equivalence_string);
   





   $bracket_equivalence_string =~ s/\[(.*?)\]/\($1\)/sg;
   my $return = strip_enclosing_parentheses($bracket_equivalence_string);






   $return =~ s/\s+/\ /g;


   $return =~ s/^\s+//s;
   $return =~ s/\s+$//s;

   $return =~ s/(\".*?\")/std_logic_vector\'($1)/gc
       if ($this->{de_ambigiousize});

   $return =~ s/\(\s+/\(/sg;
   $return =~ s/\s+\)/\)/sg;


   $return = "($return)"
       if ($this->is_source() &&
           $return =~ /\,/);

   return ($return);
}



=item I<_build_my_hash()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _build_my_hash
{
   my $this = shift;

   my $hash = $this->_hash();
   foreach my $signal_name ($this->_get_all_signal_names_in_expression()) {
      my $parent = $this->parent();
      if (!&is_blessed($parent))
      {
         &ribbit ("parent is bogus");
      }

      if (!($parent->isa("e_thing_that_can_go_in_a_module") ||
            $parent->isa("e_module")
            )
          ) {
         &goldfish ("$parent is not in module\n",$this->expression()); #,$parent->_creation_history(),"\n";
      }
      my $signal = $this->
          parent_module()->get_signal_by_name($signal_name);
      if (!$signal) {
          &ribbit ("No signal found for $signal_name\n");
      }
      if ($signal->_is_inout()) {

         $this->vhdl_variable_type("_is_inout");
      }
      $hash->{width}{$signal_name} = $signal->width();
   }


   $hash->{width}{"true"}  = "boolean";
   $hash->{width}{"false"} = "boolean";

}




=item I<ddd()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub ddd
{
   my $this = shift;
   my ($message, $print_expression, $death_level) = (@_);

   my ($expression, $ddd_message);

   if($print_expression =~ /^(1|t|true)$/i){
      $expression = "-- Expression: ".$this->expression();
   }elsif($print_expression =~ /^(0|f|false)$/i){
      $expression = "";
   }else{
      $this->ddd("DDD called with strange print_expression argument
       /($print_expression/), so I'm bailing", "1", "die");
   }
   $this->_dump_width_hash();
   
   $ddd_message = "\n\n";
   if($death_level eq "ribbit"){
      $ddd_message .= "-- ERROR: $message\n$expression"; 
      &ribbit($ddd_message);
   }elsif($death_level eq "die"){
      $ddd_message .= "-- ERROR: $message\n$expression";
      print($ddd_message);
      die();
   }elsif($death_level eq "warn"){
      $ddd_message .= "-- WARNING: $message\n$expression";
      print($ddd_message);
   }else{
      $this->ddd("DDD called with strange death_level argument/($death_level/), so I'm bailing!","1", "die");
   }


}



=item I<VN2BS()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub VN2BS
{
   my $this = shift;
   my ($verilog_number) = (@_);

   return ( $this->Verilog_Number_To_Bit_String(@_));
}









=item I<Verilog_Number_To_Bit_String()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub Verilog_Number_To_Bit_String
{
   my $this = shift;
   my ($verilog_number) = @_;
   my $integer_value = 0;
   my $width;
   my $bit_string;


   my $double_check = $verilog_number;

   my ($bit, $mask_bit, %_hash, $replacement_name, $replace_this);

   $verilog_number =~ s/^\s*(.*?)\s*$/$1/s;


   $width = $1
       if ($verilog_number =~ s/^(\d*)\'//);

   $this->ddd("I don't like 0-width numbers", "1", "ribbit") if ($width =~ /^0+$/);





   if ($verilog_number =~ /^(.*[bho])([x|z]){1}$/i){
      $verilog_number = "b$b".$2 x $width; 
   }


   if ($verilog_number =~ /^b/i) {    
      $verilog_number =~ /^b([01xz]+)$/i;
      $bit_string = $1;
      if($verilog_number =~ /^b([2-9]+)$/i)
      {
         &ribbit ($this->expression(), " you are only allowed to use binary numbers with z/x,",
                  "e.g. 1'bz");
      }
   }
   else       # if dealing with all of the other, nasty, non-binary bitstrings... 
   {          # <weep><weep><weep>
      if ($verilog_number =~ /^d([0-9xza-f]+)$/i) {
         if ($verilog_number =~ /^d([xza-f]+)/){
            $this->ddd("Europa only supports decimal numbers composed ".
                       "of the numerals \"0-9\"! Character $1 found in expression!",
                       1, "ribbit");
         }
         
         $integer_value = $1;
         if($integer_value >= ( 2 ** 32)){
            $this->ddd("Europa only supports decimal numbers which are ".
                       "less than 2^32.  Please use either the hexadecimal, octal, ".
                       "or binary radix numbers for anything larger!", 1, "ribbit");
         }
         my $temp_string = unpack("B32", pack("N", $integer_value));
         $bit_string = substr($temp_string, 32-$width, $width);

      }elsif($verilog_number =~ /^o([0-7a-fxz]+)$/i) {
         if($verilog_number =~ /^o([a-f]+)/){
            $this->ddd("Europa only supports octal numbers composed ".
                       "of the characters \"0-7,x,z\"! Character $1 ".
                       "found in expression!", 1, "ribbit");
         }
         my @hex_array;
         map{
            if($_ =~ /[0-7]/)
            {push(@hex_array, unpack("B$width", pack("H*", $_)));}
            else
            {push(@hex_array, $_ x 4);}
         }split(//, $1);

         
         my @stupid_octal_array = map {substr($_,1,3)} @hex_array;
         $bit_string = join('', @stupid_octal_array);
      }elsif($verilog_number =~ /^h([0-9a-fxz]+)$/i) {
         my @binary_array; 

         map{
            if($_ =~ /[0-9a-f]/i)
            {push(@binary_array, unpack("B4", pack("H1", $_)));}
            else
            {push(@binary_array, $_ x 4);}
         }split(//, $1);

         $bit_string = join('', @binary_array);# unpack("B4", pack("H*", $1));
         
      }else{
         $this->ddd("Number ($verilog_number) found . Number".
                    "is represented in a format unsuitable for processing\n", 1, "ribbit");
      }
   }




   my $string_width = split (//,$bit_string);
   if($string_width > $width){
      $bit_string = substr($bit_string, 
                           length($bit_string) - $width, 
                           $width);
   }
   $bit_string = ("0" x ($width - $string_width)).$bit_string;
















   my $cast_string = "std_logic";
   $bit_string =~ tr/a-z/A-Z/;
   if ($width == 1){
      $bit_string = "\'$bit_string\'"; 
   } else {
      $cast_string .= "_vector";
      $bit_string = "\"$bit_string\"";
   }



   $replacement_name = $this->Replace("Verilog_Number",
                                      "$cast_string\'($bit_string)",
                                      $width
                                      );

   if ($bit_string =~/[xz]/i)
   {
      $this->_hash()->{inout}{$replacement_name}++;
   }




   if($double_check =~ /^(\d*)\'[dbho]([a-f0-9xz])+$/)
   {
      if(($bit_string =~ /^[\"\']([0^1]|[1^0])+[\"\']$/) &&
         ($3 =~ /^([^0^1])+$/)){
         $this->ddd("Weird... number $double_check produced bit ".
                    "string $bit_string- this weird?!?!", 0, "warn");
      }
   }

   return $replacement_name;
}



=item I<process_vectors()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub process_vectors
{
   my $this = shift;
   my $verilog_equation = $this->_vce();
   my $left;
   my $right;



   while ($verilog_equation =~ s/^(.*?\b)(\w+)\s*(\[(.*?)\])(.*)/$1/s) {
      my $name = $2;
      my $index = $3;
      my $bracket_contents = $4;
      my $rest = $5;
      my $width;

      my $replace_this = $name;

      if ($bracket_contents =~ s/^\s*([a-zA-Z]\w*)\s*$/$1/s) {

           my $bracket_signal = $this->parent_module->get_signal_by_name($bracket_contents) or 
                &ribbit ("can't get signal for $bracket_contents. ",
                      "Parameter indexes aren't suported.",
                      "  Use perl to figure out the parameter you want");
       
            my $bracket_width = $bracket_signal->width() or &ribbit 
                ("width not known for $bracket_contents\n");
       
            if ($bracket_width == 1){
               $replace_this .= "(CONV_INTEGER($index))";
            }
            else{
               $replace_this .= "(CONV_INTEGER(UNSIGNED($index)))";
            }

            my $name_signal = $this->parent_module->get_signal_by_name($name) or 
                 &ribbit ("can't get signal for $name. ",
                          "Parameter indexes aren't suported.",
                          "  Use perl to figure out the parameter you want");
    
            if ($name_signal->depth > 0){
                $width = $this->vhdl_hash_width($name) or 
                     &ribbit ("no width for $replace_this");
            }
            else{

                $width = 1;
            }

      } else {
         ($replace_this,$left,$right) = $this->Vector_Range("$name$index");
         my ($l,$r) = split (/\s*\,\s*/s,$name);
         $right = $left if ($right eq ""); #If only one value,
         $replace_this .= $this->Vector_Order($left,$right);

         $width = $left - $right + 1;
      }

      my $replacement_name = $this->Replace("Verilog_Bracket",
                                            $replace_this,
                                            $width
                                            );
      $verilog_equation .= "$replacement_name $rest";
   }

   $this->_vce($verilog_equation);
}




=item I<process_numerals()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub process_numerals
{
   my $this = shift;
   my $processed_string = $this->_vce();
   my $width;
   my $replacement_name;


   $processed_string =~ s/(\d*\'[bodh][\da-fxz]+)/$this->VN2BS($1)/seig;

   $processed_string =~
       s/\b(\d+)\b/$this->VN2BS("32'd$1")/gex;




   $this->_vce($processed_string);
}




=item I<process_parentheses()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub process_parentheses
{
   my $this = shift;
   my $processed_string = $this->_vce();

   my ($before_paren, $inside_paren, $after_paren) =
       $this->Count_Parentheses($processed_string);
   
   while($inside_paren ne ""){
      my $replace_this = $this->V2VHD_Equation($inside_paren);
      my $replace;
      if ($before_paren || $after_paren)
      {
         $replace = $this->replace("\($replace_this\)",
                                   $this->vhdl_hash_width($replace_this));
         $processed_string = "$before_paren $replace $after_paren";
      }
      else
      {
         $replace = $this->replace($replace_this,
                                   $this->vhdl_hash_width($replace_this));
         $processed_string = $replace;
      }

      ($before_paren, $inside_paren, $after_paren)
          =$this->Count_Parentheses($processed_string);
   }
   $this->_vce($processed_string);
}



=item I<process_replication_and_concatentation()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub process_replication_and_concatentation
{
   my $this = shift;
   my $processed_string = $this->_vce();



   while ($processed_string =~  s/^(.*?)\{\s*(\w+)\s*(\{.*)/$1/s) {

      my $before_curly_brace = $1;
      my $rest = $3;
      my $repeat_number = $this->Replace_Equivalences($2);

      if($repeat_number =~ /\"([01]+)\"/){
         $repeat_number =  
             unpack("N", pack("B32", substr("0" x 32 . $1, -32)));
      }
      if($repeat_number =~ s/\'([01])\'/$1/g){};

      ($repeat_number > 0) or &ribbit
	  ("value for concatenation was ($2), evals to ($repeat_number) ($1)in expr (",
	   $this->expression(),")\n");
      
      my ($b,$m,$e) = $this->Count_Parentheses($rest,'\s*\{','\}\s*');
      $e =~ s/^\s*\}//s;





      

      

      my $rep = $this->V2VHD_Equation("$m");
      
      if($this->vhdl_hash_width($rep) eq "boolean"){
         $rep = $this->Resize($rep, 1);
      }
      
      my $replace = $rep;
      if($repeat_number > 1){
         my $width = $this->vhdl_hash_width($rep);

         &ddd("Found width of 0 in expression\n")
             if($width < 1);
         $replace = "A_REP";

         if($width > 1){
            $replace .= "_VECTOR";
         }
         
         $replace = "$replace\($rep, $repeat_number\)";
         $replace = $this->Replace("Replication", $replace, eval($width * $repeat_number));



      }
      $processed_string = "$before_curly_brace$b$replace$e";      
      

   }
   

   my ($before_curly_brace,$inside_curly_brace,$after_curly_brace) = $this->Count_Parentheses($processed_string,'\{','\}');

   while ($inside_curly_brace ne "") {
      my $replacement_name = $this->Process_Concatenation("\{$inside_curly_brace\}", $this->vhdl_variable_type());
      $processed_string = "$before_curly_brace$replacement_name$after_curly_brace";
      ($before_curly_brace,$inside_curly_brace,$after_curly_brace) = $this->Count_Parentheses($processed_string,'\{','\}');
   }
   $this->_vce($processed_string);
}



=item I<eval_and_replace()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub eval_and_replace
{
   my $this = shift;

   my $new_word = shift;
   my $width    = shift;
   my ($lhs, $op, $rhs) = @_;


   my $width_hash = $this->_hash()->{width};









   if ($width ne 'boolean')
   {
      $width = eval $width;
      if ($@)
      {
         my $expression = $this->expression();
         print "Badness in expression: $expression\n";
         die "something bad just happened with width $width ($@)";
      }
   }

   $new_word = eval $new_word;

   if ($@)
   {
      my $expression = $this->expression();
      print "Badness in expression: $expression\n";
      die "something bad just happened with word $new_word ($@)";
   }
   my $return = $this->replace($new_word, $width);
   return $return;
}







=item I<unary_replace()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub unary_replace
{
   my $this = shift;
   my $string = $this->_vce();
   my $replace_hash = shift;
   my $replace_width = shift;
   my %modified_hash;

   foreach my $key (keys (%$replace_hash))
   {
      my $value = $replace_hash->{$key};
      $value =~ s/\$RHS/\$rhs/g;

      $modified_hash{$key} = $value;
   }

   my %replace_width_hash;
   my $width_hash = $this->_hash()->{width};
   if (ref($replace_width) eq 'HASH')
   {
      foreach my $key (keys (%$replace_width))
      {
         my $value = $replace_width->{$key};
         $value =~ s/\$RHS/\$width_hash->{\$rhs}/g;
         $replace_width_hash{$key} = $value;
      }
   }
   else
   {
      $replace_width =~ s/\$RHS/\$width_hash->{\$rhs}/g;
      %replace_width_hash = map {$_ => $replace_width;}
      (keys (%$replace_hash));
   }

   my @replace_array;
   foreach my $key (keys (%modified_hash))
   {


      $key =~ s/(\W)/\\$1/gs;
      push (@replace_array, $key);
   }

   my $replace = join ('|',@replace_array);

   while ($string =~ 
          s/([^\w\s])\s*($replace)\s*(\w+)/$1.
          $this->eval_and_replace($modified_hash{$2},$replace_width_hash{$2},'',$2,$3)/sxe){;}
   while ($string =~  
          s/^(\s*)($replace)\s*(\w+)/$1.
          $this->eval_and_replace($modified_hash{$2},$replace_width_hash{$2},'',$2,$3)/sxe){;}   



   

   


   $this->_vce($string);
}



=item I<binary_replace()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub binary_replace






{

   my $this = shift;
   my $string = $this->_vce();
   my $op_hash = shift;
   my $operand_width = shift;
   my $replace_width = shift;
   
   my %modified_hash;
   if($replace_width eq ""){
      $replace_width = $operand_width;
   }

   my %replace_width_hash;
   if (ref($replace_width) eq 'HASH')
   {
      foreach my $key (keys (%$op_hash))
      {
         my $value = $replace_width->{$key};
         $value =~ s/\$RHS/\$width_hash->{\$rhs}/g;
         $value =~ s/\$LHS/\$width_hash->{\$lhs}/g;
         $replace_width_hash{$key} = $value;
      }
   }
   else
   {

      $replace_width =~ s/\$LHS/\$width_hash->{\$lhs}/g;
      $replace_width =~ s/\$RHS/\$width_hash->{\$rhs}/g;
      %replace_width_hash = map {$_ => $replace_width;}
      (keys (%$op_hash));
   }

   my %operand_width_hash;
   if (ref($operand_width) eq 'HASH')
   {
      foreach my $key (keys (%$op_hash))
      {
         my $value = $operand_width->{$key};
         $value =~ s/\$RHS/\$width_hash->{\$rhs}/g;
         $value =~ s/\$LHS/\$width_hash->{\$lhs}/g;
         $operand_width_hash{$key} = $value;
      }
   }
   else
   {

      $operand_width =~ s/\$LHS/\$width_hash->{\$lhs}/g;
      $operand_width =~ s/\$RHS/\$width_hash->{\$rhs}/g;
      %operand_width_hash = map {$_ => $operand_width;}
      (keys (%$op_hash));
   }


   foreach my $op (keys %$op_hash)
   {
      my $value = $op_hash->{$op};
      

      
      $value = '$LHS." $op ".$RHS'
          if (!$value);

      my $operand_resize_width = $operand_width_hash{$op};
      if($operand_resize_width){
        $value =~ s/\$LHS/\$this->Resize(\$lhs,$operand_resize_width)/g;
        $value =~ s/\$RHS/\$this->Resize(\$rhs,$operand_resize_width)/g;
      }
      else{
        $value =~ s/\$LHS/\$lhs/g;
        $value =~ s/\$RHS/\$rhs/g;
      }


      $modified_hash{$op} = $value;      
   }

   my @replace_array;
   foreach my $op (keys (%modified_hash))
   {


      $op =~ s/(\W)/\\$1/gs;
      push (@replace_array, $op);
   }

   my $replace = join ('|',@replace_array);





   while ($string =~ 
          s/(\w+?)\s*($replace)\s*(\w+)/
          $this->eval_and_replace($modified_hash{$2},$replace_width_hash{$2},$1,$2,$3)/sxe){
      ;
   }

   $this->_vce($string);
}



=item I<arithmetic_shift_replace()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub arithmetic_shift_replace
{
   my $this = shift;
   my $string = $this->_vce();
   my $op_hash = shift;
   my $operand_width = shift;
   my $replace_width = shift;

   my %modified_hash;
   if($replace_width eq ""){
      $replace_width = $operand_width;
   }

   my %replace_width_hash;
   if (ref($replace_width) eq 'HASH')
   {
      foreach my $key (keys (%$op_hash))
      {
         my $value = $replace_width->{$key};
         $value =~ s/\$RHS/\$width_hash->{\$rhs}/g;
         $value =~ s/\$LHS/\$width_hash->{\$lhs}/g;
         $replace_width_hash{$key} = $value;
      }
   }
   else
   {

      $replace_width =~ s/\$LHS/\$width_hash->{\$lhs}/g;
      $replace_width =~ s/\$RHS/\$width_hash->{\$rhs}/g;
      %replace_width_hash = map {$_ => $replace_width;}
      (keys (%$op_hash));
   }

   my %operand_width_hash;
   if (ref($operand_width) eq 'HASH')
   {
      foreach my $key (keys (%$op_hash))
      {
         my $value = $operand_width->{$key};
         $value =~ s/\$RHS/\$width_hash->{\$rhs}/g;
         $value =~ s/\$LHS/\$width_hash->{\$lhs}/g;
         $operand_width_hash{$key} = $value;
      }
   }
   else
   {

      $operand_width =~ s/\$LHS/\$width_hash->{\$lhs}/g;
      $operand_width =~ s/\$RHS/\$width_hash->{\$rhs}/g;
      %operand_width_hash = map {$_ => $operand_width;}
      (keys (%$op_hash));
   }


   foreach my $op (keys %$op_hash)
   {
      my $value = $op_hash->{$op};
      

      
      $value = '$LHS $op $RHS'
          if (!$value);

      $value =~ s/\$LHS/\$this->Resize(\$lhs,$operand_width_hash{$op})/g;

      $value =~ s/\$RHS/\$rhs/g;



      $modified_hash{$op} = $value;      
   }


   my @replace_array;
   foreach my $op (keys (%modified_hash))
   {


      $op =~ s/(\W)/\\$1/gs;
      push (@replace_array, $op);
   }

   my $replace = join ('|',@replace_array);



   while ($string =~ s/^(.*?)(\w+)\s*($replace)\s*(\w+)(.*)/$1/s){
      $string = $1;
      my $lhs = $2;
      my $op = $3;
      my $shift_amount = $this->Replace_Equivalences($4);

      if($shift_amount =~ s/^\"([1,0]+)\"$/$1/g){

         $shift_amount =  
             unpack("N", pack("B32", substr("0" x 32 . $shift_amount, -32)));

      }
      if($shift_amount =~ s/^\'([1,0])\'$/$1/g){};
      

      $lhs = $this->Replace_Equivalences($lhs);



      if($shift_amount == 0){
         $string .= $lhs;
      }elsif($this->vhdl_hash_width($lhs) <= $shift_amount){
         $string .= $this->replace($this->VN2BS($shift_amount."\'b"."0" x $shift_amount), $shift_amount);
      }else{
         $string .= $this->eval_and_replace($modified_hash{$op},
                                            $replace_width_hash{$op},$lhs,$op,$shift_amount);
      }
      $string .= $5;
   }
   
   
   $this->_vce($string);
}






=item I<conditional_replace()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub conditional_replace
{
   my $this = shift;
   my $string = $this->_vce();




   while ($string =~ /^(.*)\b(\w+)\s*\?\s*(\w+)\s*\:\s*(.*)/s) 
   {
      my $before    = $1;
      my $condition = $2;
      my $then      = $3;
      my $else      = $this->V2VHD_Equation($4);



      my $re = $this->Replace_Equivalences($condition);
      if ($re =~ /^([\(\)\s\=]|(\'\d\'))+$/){



         $re =~ s/(\'\d\')/STD_LOGIC\'\($1\)/gs;


      }
      
      my $width = &max ($this->vhdl_hash_width($then), $this->vhdl_hash_width($else));

      my $function_name = "A_WE_StdLogic";
      $function_name .= ($width > 1)? "Vector":"";












      

      $condition = $this->Resize($condition, 'boolean');
      $then      = $this->Resize($then,$width);
      $else      = $this->Resize($else,$width);

      my $replace = $this->replace
          ("$function_name($condition, $then, $else)",
           $width);
      $string = "$before $replace";
   }   
   $this->_vce($string);
}



=item I<_dump_width_hash()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _dump_width_hash
{
   my $this = shift;
   my $width_hash = $this->_hash()->{width};
   foreach my $key (keys(%$width_hash)){
      print "---wh  ".$key.":".$this->Replace_Equivalences($key).":".$width_hash->{$key}."\n";
   }
}













































































































=item I<V2VHD_Equation()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub V2VHD_Equation
{
   my $this = shift;
   my ($verilog_equation) = @_;

   if ($verilog_equation =~ /^[A-Za-z_]\w*$/)
   {
      return $verilog_equation;
   }
   $this->_vce($verilog_equation);
   my $thing = $this->_vce();

   $this->process_parentheses();
   $this->process_replication_and_concatentation();
   $this->process_vectors();
   $this->process_numerals();

   my $string = $this->_vce();




   $this->unary_replace
       ({'~|' => 'if($width_hash->{$RHS}>1){"nor_reduce($RHS)"} else{"$RHS"}',
         '~&' => 'if($width_hash->{$RHS}>1){"nand_reduce($RHS)"}else{"$RHS"}',
         '^~' => 'if($width_hash->{$RHS}>1){"xnor_reduce($RHS)"}else{"$RHS"}',
         '~^' => 'if($width_hash->{$RHS}>1){"xnor_reduce($RHS)"}else{"$RHS"}',
         '&'  => 'if($width_hash->{$RHS}>1){"and_reduce($RHS)"} else{"$RHS"}',
         '|'  => 'if($width_hash->{$RHS}>1){"or_reduce($RHS)"}  else{"$RHS"}',
         '^'  => 'if($width_hash->{$RHS}>1){"xor_reduce($RHS)"} else{"$RHS"}',
         '+'  => '"$RHS"',
         '-'  => 'if($width_hash->{$RHS}>1){"-SIGNED($RHS)"}
                  else{"$RHS"}',
      }, {
         '~|' => 1,
         '~&' => 1,
         '^~' => 1, 
         '~^' => 1,
         '&'  => 1,
         '|'  => 1,
         '^'  => 1,
         '+'  => '$RHS',
         '-'  => '$RHS',
      });






   
   $this->unary_replace
       ({'~' => '"NOT $RHS"'},
        '$RHS');
   





   $this->unary_replace
       ({'!' => 'if($width_hash->{$RHS}>1){"NOT(or_reduce($RHS))"}
           elsif ($width_hash->{$RHS}eq "boolean"){"NOT(to_std_logic($RHS))"}
           else{"NOT($RHS)"}',},
        '1');

   $this->binary_replace
       ({'*' => '"(".$LHS." * ".$RHS.")"',
         '/' => '"(".$LHS." / ".$RHS.")"',
         '%' => '"(".$LHS." mod ".$RHS.")"'},
        '&max($LHS, $RHS)', 
        {'*' => '2*(&max($LHS, $RHS))',
         '/' => '&max($LHS, $RHS)',
         '%' => '&max($LHS, $RHS)'});

   $this->binary_replace
       ({'+' => '"(".$LHS." + ".$RHS.")"',
         '-' => '"(".$LHS." - ".$RHS.")"'},
        {'+' => '&max($LHS, $RHS) + 1',
         '-' => '&max($LHS, $RHS) + 1'}
        );








   
   $this->binary_replace
       ({'<<' => '"A_SLL(".$LHS.",".$RHS.")"',
         '>>' => '"A_SRL(".$LHS.",".$RHS.")"'},


        {'<<' => '',  
         '>>' => ''},
        {'<<' => '$LHS',
         '>>' => '$LHS'});
   
   $this->binary_replace
       ({'<'  => '"(".$LHS ."<". $RHS.")"',
         '<=' => '"(".$LHS ."<=". $RHS.")"',
         '>'  => '"(".$LHS .">". $RHS.")"',
         '>=' => '"(".$LHS .">=". $RHS.")"'},
        '&max($LHS, $RHS)',
        'boolean'
        );

   $this->binary_replace
       ({'==' => '"(".(($width_hash->{$LHS} eq 1)? "std_logic\'(".$LHS.")":$LHS)
                        ." = ".
                         (($width_hash->{$RHS} eq 1)? "std_logic\'(".$RHS.")":$RHS)
                        .")"',     
                         '!=' => '"(".(($width_hash->{$LHS} eq 1)? "std_logic\'(".$LHS.")":$LHS)
                        ." /= ".
                         (($width_hash->{$RHS} eq 1)? "std_logic\'(".$RHS.")":$RHS)
                        .")"'},     
        '&max($LHS, $RHS)',
        'boolean'
        );

   $this->binary_replace
       ({'&'  => '"(".$LHS." AND ".$RHS.")"'},
        '&max($LHS, $RHS)',
        '&max($LHS, $RHS)'
        );

   $this->binary_replace
       ({'^'  => '"(".$LHS." XOR ".$RHS.")"',
         '^~' => '"(".$LHS." XNOR ".$RHS.")"',
         '~^' => '"(".$LHS." XNOR ".$RHS.")"'},
        '&max($LHS, $RHS)',
        '&max($LHS, $RHS)'
        );

   $this->binary_replace
       ({'|'  => '"(".$LHS." OR ".$RHS.")"'},
        '&max($LHS, $RHS)',
        '&max($LHS, $RHS)'
        );


   $this->binary_replace
       ({'`AND`'  => '(($width_hash->{$LHS} > 1)? "(or_reduce\(".$LHS."\)": "(".$LHS)
                         ." AND ".(($width_hash->{$RHS} > 1)? "or_reduce\(".$RHS."\)\)": $RHS.")")'},
        '&max($LHS, $RHS)',
        '(($LHS >= 1) || ($RHS >= 1))? 1: "boolean"'
        );

   $this->binary_replace
       ({'`OR`'  => '(($width_hash->{$LHS} > 1)? "(or_reduce\(".$LHS."\)": "(".$LHS)
                         ." OR ".(($width_hash->{$RHS} > 1)? "or_reduce\(".$RHS."\)\)": $RHS.")")'},
        '&max($LHS, $RHS)',
        '(($LHS >= 1) || ($RHS >= 1))? 1: "boolean"'
        );

   $this->conditional_replace();


   my $test = $this->_vce();
   if($test =~ /(\s*__\d+__\s*){2,}/){
      $this->_dump_width_hash();


=item I<expression()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

      $this->ddd("Unprocessed sub expression found ($test)!", "1", "ribbit"); 
   }
   
   return $this->_vce();
}



=item I<_vhdl_eval_real_equation()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _vhdl_eval_real_equation
{
   my $this = shift;

   my ($left_operand,
       $operator,
       $right_operand,
       $force_to_type
       ) = @_;



   my $result;
   if ($operator eq "\`AND\`") {
      if (($2 == 0) || ($4 == 0)) {
         $result .= "0";
      } else {
         $result .= "1";
      }
   } else {
      if ($operator eq "\`OR\`") {
         if (($2 != 0) || ($4 != 0)) {
            $result .= "1";
         } else {
            $result .= "0";
         }
      } else {
         my $evaluatedExpression = eval
             ("$left_operand $operator $right_operand");





         $evaluatedExpression = "0" if (!$evaluatedExpression);
         $result .= $evaluatedExpression;
      }
   }
   return ($result);
}



=item I<_vhdl_translate_logical_operators()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _vhdl_translate_logical_operators
{
   my $this = shift;

   my ($left_operand,
       $operator,
       $right_operand,
       $force_to_type) = @_;

   my $width;

   my $left_width =
       $this->vhdl_hash_width($left_operand);
   my $right_width =
       $this->vhdl_hash_width($right_operand);

   $operator = "AND" if ($operator eq "\`AND\`");
   $operator = "OR"  if ($operator eq "\`OR\`");

   my $replacement_name;




   if (($left_width  eq "1") &&
       ($right_width eq "1")
       ) {
      $replacement_name = $this->Replace
          ("logical",
           "$left_operand $operator $right_operand",
           1
           );


   }elsif (_is_a_vector($force_to_type) == 0) {


      if (_is_a_vector($left_width) == 1){ 
         $left_operand = $this->Resize($left_operand,
                                       "boolean"
                                       );
      }


      if (_is_a_vector($right_width) == 1){
         $right_operand = $this->Resize($right_operand,
                                        "boolean"
                                        );
      }

      ($left_operand,
       $right_operand,
       $width
       ) = $this->Force_To_Type
       (
        $left_operand,
        $right_operand,
        $force_to_type,
	);
      $replacement_name = $this->Replace
          (
           "logical",
           "$left_operand $operator $right_operand",
           $width,
           );
   } else {
      ($left_operand,
       $right_operand,
       $width
       ) = $this->Force_To_Type
       (
        $left_operand,
        $right_operand,
        "boolean"
	);



      $replacement_name = $this->Replace
          (
           "logical",
           "$left_operand $operator $right_operand",
           $width,
           );
   }
   return ($replacement_name);
}






=item I<_vhdl_translate_shift_operators()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _vhdl_translate_shift_operators
{
   my $this = shift;

   my ($left_operand,
       $operator,
       $right_operand,
       $force_to_type) = @_;

   my $right_operand = eval ($right_operand);
   &goldfish ("V2VHD_EQUATION (",$this->expression(),
              ")HAS NON-INTEGER SHIFT AMOUNT ",
              "($right_operand)\n"
              )
       unless ($right_operand =~ s/^\s*(\d+)\s*$/$1/s);
   $operator =~ s/\s*\<\<\s*/A_SLL/;
   $operator =~ s/\s*\>\>\s*/A_SRL/;
   ($operator =~ /A_SLL|A_SRL/) or &goldfish 
       ("shift operator ($operator) not understood");


   my $replace_this = $left_operand;
   $replace_this = "$operator($left_operand, $right_operand)"
       unless($this->vhdl_hash_width($left_operand) == 1);
   my $width = $this->vhdl_hash_width($left_operand);
   my $replacement_name = $this->Replace("shift",
                                         $replace_this,
                                         $width);
   return ($replacement_name);
}





=item I<_handle_parentheses()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _handle_parentheses
{ 
   my $this = shift;
   my $paren_stuff = shift;
   my $force_to_type = shift;
   my $force_to_vhdl_variable_type = shift;


   my $rep_value = $this->V2VHD_Equation($paren_stuff, $force_to_type, $force_to_vhdl_variable_type);
   return $this->Replace("Paren","\(".$rep_value."\)",$this->vhdl_hash_width($rep_value));
}















=item I<Vector_Range()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub Vector_Range
{

   my $this = shift;
   my ($var) = @_;
   my $name;
   my $left;
   my $right;

   $var =~ s/^\s*(.*?)\s*$/$1/s;






   if ($var =~ /(\w+)\s*\[(.*?)\]/s) {

      $name = $1;
      ($left,$right) = split (/\s*\:\s*/s,$2);
      $left = eval($left);
      $right = $left if ($right eq "");
      $right = eval($right);
      return ($name,$left,$right);
   } 


   if ($var =~ /(\w+)\s*\((.*?)\)/s) {

      $name = $1;
      my $index = $2;
      ($left,$right) = split (/\s*(DOWN)?TO\s*/s,$index);
      $left = eval($left);
      $right = $left if ($right eq "");
      $right = eval($right);
      return ($name,$left,$right);
   } 







   my $hash = $this->_hash();
   $left = $hash->{width}{$var};
   $left = $left - 1;
   $right = 0;
   $name = $var;
   return ($name,$left,$right);
}












=item I<Vector_Order()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub Vector_Order
{
   my $this = shift;
   my ($left_index,$right_index) = @_;
   return "($left_index)"
       if ($right_index eq "");
   if ($left_index == $right_index) {
      return "[$left_index]";
   }
   if (($left_index > $right_index) || ($right_index == 0)) {
      return "[$left_index DOWNTO $right_index]";
   } else {
      return "[$left_index TO $right_index]";
   }
}











=item I<Replace()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub Replace
{
   my $this = shift;

   my ($replacement_name,
       $replacement_value,
       $width) = @_;

   my $number = $this->{_vhdl_replace_number}++;
   $this->{_vhdl_replace_array}->[$number] = $replacement_value;
   $replacement_name = "__".$number."__";
   
   my $hash = $this->_hash();

   my $temp_name = $replacement_value;
   
   $width = 32
       unless($width);

   $hash->{width}{$replacement_name} = $width;
   
   return ($replacement_name);
}



=item I<replace()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub replace
{
   my $this = shift;
   return $this->Replace('bogus',@_);
}
















=item I<Count_Parentheses()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub Count_Parentheses
{
   my $this=shift;
   my ($string,$begin_match,$end_match) = @_;
   my $begin_string;
   my $paren_string;
   my $end_string;
   my $begin_match_default = '\s*\(\s*';
   my $end_match_default   = '\s*\)\s*';
   $begin_match = $begin_match_default unless ($begin_match);
   $end_match   = $end_match_default unless ($end_match);







   return("","","$string")
       unless ($string =~ /^(.*?)$begin_match(.*)$/s);






   $begin_string = $1;

   my $paren_count = 1;
   $end_string = $2;
   


   while ($end_string =~ s/^(.*?)($begin_match|$end_match)(.*)$/$3/s) {
      my $match;
      $match = $2;
      $paren_string .= $1;

      if ($match =~ /$begin_match/) {
         $paren_count++;
      } else {
         $paren_count = $paren_count - 1;
      }

      last if ($paren_count == 0);

      $paren_string .= $match;
   }      



   return ($begin_string,$paren_string,$end_string);
}



=item I<_crush_redundant_parentheses()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _crush_redundant_parentheses
{
   my $this   = shift;
   my $string = shift;

   my ($begin, $middle, $end) =
       $this->Count_Parentheses($string);

   my $return = $end;
   if ($middle ne "") {
      if ($begin.$end eq "") {
         $return = $this->_crush_redundant_parentheses
             ($middle);
      } else {
         $return = "$begin(".
             $this->_crush_redundant_parentheses
             ($middle).
             ")".$this->
             _crush_redundant_parentheses
             ($end);
      }
   }

   return ($return);
}



=item I<is_source()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub is_source
{
   my $this = shift;

   return ($this->direction() =~ /out/i);
}



=item I<is_destination()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub is_destination
{
   my $this = shift;


   return ($this->direction() !~ /out/i);
}



=item I<Process_Concatenation()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub Process_Concatenation
{
   my $this = shift;
   my ($string,
       $force_to_vhdl_variable_type) = @_;

   my $expanded_array;
   my $width;

   my ($begin,$middle,$end) = $this->Count_Parentheses($string,'\{','\}');
   &ribbit ("ERROR Process_Concatenation, NO VALUE BETWEEN SQUIGGLY BRACKETS in ($string)")
       if ($middle eq "");

   while ($middle =~ s/\{|\}//g) {
      ;
   }				#e.g. {a,b,c,{a,e},f,g} -> {a,b,c,a,e,f,g}

   ($expanded_array,$width) = $this->
       Expand_Array_Of_Bit_Vectors_Into_Separated_Bits(",",$middle);

   my $logic = "Logic";

   if ($this->direction() !~ /out/i) {
      my @concatenation;
      $middle =~ s/\s*(.*?)\s*$/$1/s;
      my @concatenatees = split (/\s*\,\s*/s,$middle);


      if (@concatenatees == 1) {
         $string = $concatenatees[0];
         $string = $this->Resize($string,1)
             if ($this->vhdl_hash_width($string) eq "boolean");
         $string = $this->V2VHD_Equation($string);
      } else {
         foreach my $expr (@concatenatees) {
            my $push_this = $this->V2VHD_Equation($expr);
            $push_this = $this->Resize($push_this,1)
                if ($this->vhdl_hash_width($push_this) eq "boolean");
            $push_this = "A_ToStd${logic}Vector($push_this)"
                if (($this->vhdl_hash_width($push_this) == 1) && 
                    ($force_to_vhdl_variable_type ne "_is_inout"));

            push (@concatenation, $push_this);
         }
         $string = "(".join (" & ", @concatenation).")";
         if($this->vhdl_hash_width($concatenatees[0]) < 2)
         {
            $string = "Std_${logic}_Vector'$string";
         }
      }
   } else {
      $string = "$begin";
      if (scalar(split (/\,/,$expanded_array)) == 1) {
         my $tmp_string = $expanded_array;
         while ($tmp_string =~ s/\'/\"/) {
            ;
         }


         while ($tmp_string =~ s/\[\s*(\d+)\s*\]/\[$1:$1\]/s) {
            ;
         }
         $string .= $tmp_string;
      } else {
         $string .= "\(";
         $string .= $expanded_array;
         $string .= " \)$end";
      }
   }

   my $replacement = $this->Replace("Concat",$string,$width);


   return ($replacement);
}












=item I<Expand_Array_Of_Bit_Vectors_Into_Separated_Bits()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub Expand_Array_Of_Bit_Vectors_Into_Separated_Bits
{
   my $this = shift;
   my ($separator,
       $Comma_Separated_String) = @_;



   my $string = "";
   my ($name, $bit, $index, $hash);
   $hash = $this->_hash();

   my $width = 0;
   foreach $name (split(/\s*\,\s*/s,$Comma_Separated_String)) {
      
      $name =~ s/^\s*(.*?)\s*$/$1/s;


      $name = $this->V2VHD_Equation($name);


      my $re = $this->Replace_Equivalences($name);
      if ($re =~ /^(\"|\')([01XZ]+)\1$/i) {
         foreach $bit (split(//,$2)) {


            $string .= "$separator " if ($string);
            $string .= "\'$bit\'";
            $width++;
         }
      } elsif ($this->vhdl_hash_width($name) eq "boolean") {

         $string .= "$separator " if ($string);
         $string .= $this->Resize($name,1);
         $width++;
      } else {
         my ($left,$right);

         my @vr = $this->Vector_Range($name);
         ($name,$left,$right) = @vr;




         if ($left eq "") {
            $left = $this->vhdl_hash_width($name) or &ribbit 
                ("No width found for $name\n");
         }
         if ($right eq "") {
            $left = eval ($left - 1);
            $right = 0;
         }

         $left = eval($left);$right = eval($right);

         foreach $index ($this->Order($left,$right)) {
            $width++;
            $string .= "$separator\n\t" if ($string);
            if ($hash->{width}{$name} == 1) {
               $string .= "$name";
            } else {
               $string .= "$name\[$index\]";
            }
         }
      }
   }

   &ribbit("String: $Comma_Separated_String, width is $width\n") unless $width;

   return($string,$width);
}











=item I<Replace_Equivalences()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub Replace_Equivalences
{
   my $this = shift;
   my ($string) = @_;

   my $array = $this->_vhdl_replace_array();
   while ($string =~ s/__(\d+)__/$array->[$1]/eg)
   {;}






   return($string);
}












=item I<Find_In_Order()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub Find_In_Order
{
   my $this = shift;
   my ($equation,$regexp) = @_;
   $regexp =~ s/([^|])$/$1|/s;

   my $tmp_regexp = $regexp;
   my $exp;
   while ($tmp_regexp =~ s/^(.*?[^\\])\|//) {
      $exp = $1;

      if ($equation =~ /($exp)/) {
         $exp = $1;

         last;
      }
   }
   &ribbit ("ERROR Find_In_Order: ($regexp) NOT FOUND IN ($equation)")
       unless ($exp ne "");
   $exp =~ s/(\W)/\\$1/gs;
   return ($exp);
}







=item I<Is_real()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub Is_real
{
   my $this = shift;
   my $value = shift (@_);
   return (1) if ($value =~ /^\s*\d+\s*$/s);
   return (0);
}










=item I<Order()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub Order
{
   my $this = shift;
   my ($left,$right) = @_;
   my @Vector_Array;
   $this->ddd("Order: LEFT VALUE ($left) NOT A NUMBER\n","1","ribbit")
       unless ($left =~ s/^\s*(\d+)\s*$/$1/s);
   $this->ddd("Order: RIGHT VALUE ($right) NOT A NUMBER\n","1","ribbit")
       unless ($right =~ s/^\s*(\d+)\s*$/$1/s);

   if ($right > $left) {
      @Vector_Array = ($left..$right);
   } else {
      @Vector_Array = reverse ($right..$left);
   }
   return (@Vector_Array);
}



=item I<Force_To_Type()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub Force_To_Type
{
   my $this = shift;
   my ($left_operand,
       $right_operand,
       $force_to_type
       ) = @_;

   my $left_width  = $this->vhdl_hash_width($left_operand);
   my $right_width = $this->vhdl_hash_width($right_operand);

   $left_width = &Bits_To_Encode($left_operand)
       if ($left_operand =~ s/^\s*(\d+)\s*$/$1/);
   $right_width = &Bits_To_Encode($right_operand)
       if ($right_operand =~ s/^\s*(\d+)\s*$/$1/);


   $force_to_type =
       ($left_width > $right_width) ? $left_width: $right_width
       unless ($force_to_type);

   $left_operand = $this->Resize($left_operand,$force_to_type);
   $right_operand = $this->Resize($right_operand,$force_to_type);

   return ($left_operand, $right_operand, $force_to_type);
}



=item I<Force_To_Largest_Type()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub Force_To_Largest_Type
{
   my $this = shift;
   my ($left_operand,
       $right_operand,
       $force_to_type
       ) = @_;

   my $left_width  = $this->vhdl_hash_width($left_operand);
   my $right_width = $this->vhdl_hash_width($right_operand);

   

   $left_width = &Bits_To_Encode($left_operand)
       if ($left_operand =~ s/^\s*(\d+)\s*$/$1/);
   $right_width = &Bits_To_Encode($right_operand)
       if ($right_operand =~ s/^\s*(\d+)\s*$/$1/);


   my @types = sort {$b <=> $a} ($left_width,
                                 $right_width,
                                 $force_to_type);


   my $force_to_this = $types[0];
   $left_operand = $this->Resize($left_operand,$force_to_this);
   $right_operand = $this->Resize($right_operand,$force_to_this);

   unless ($force_to_this)
   {
      &ribbit ("do not know what width to force $left_operand -> ($left_width), $right_operand -> ($right_width)");
   }
   return ($left_operand, $right_operand, $force_to_this);
}



=item I<Previous_Size()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub Previous_Size
{
   my $this = shift;
   my $value = shift;
   defined $value or &ribbit ("no value");

   my $blerg = $this->{_hash}->{equivalence_list}{$value};



   return ($blerg)
       if ($blerg =~ s/^\s*A_EXT\((.*)\,[^\,]+\)$/$1/s);
   return undef;
}



=item I<Resize()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub Resize
{
   my $this = shift;
   my $resize_this  = shift;
   defined $resize_this or &ribbit ("nothing to resize");
   my $resize_value = shift or return ($resize_this);
   $resize_this =~ s/^(\s*?)(\w*)(\s*?)$/$2/;

   my $this_width = $this->vhdl_hash_width($resize_this);
   if (!$this_width)
   {
      &ribbit ("no width for $resize_this\n");
   }

   return "$resize_this"
       if ($this_width eq $resize_value);

   if (defined $this->Previous_Size($resize_this)) {
      return ($this->Resize($this->Previous_Size($resize_this),
			    $resize_value));
   }


















   if ($resize_value eq "boolean") 
   {
      my $real_value = $this->Replace_Equivalences($resize_this);


      if ($real_value =~ /^([\(\s]*)([\'\"]?)(\d+)\2([\)\s]*)$/) 
      {
         return ($3) ? "$1true$4":"$1false$4";
      } 
      else 
      {
         if ($this_width == 1) 
         {
            return ($this->Replace("boolean","(std_logic'($resize_this) = '1')",
                                   $resize_value
                                   )
                    );
         } 
         else 
         {
            return ($this->Replace("boolean", "(($resize_this) /= ".
                                   $this->VN2BS("$this_width\'d0").")",
                                   $resize_value
                                   )
                    );
         }
      }
   }
   else	#resize value is 1,2,3,4,5...
   {

      if ($this_width eq "boolean") 
      {
         $resize_this = "to_std_logic($resize_this)";
         $this_width = 1;
         if ($resize_value == 1) 
         {
            return ($this->Replace("to_std_logic",$resize_this,$resize_value));





         }
      }
      my $resized_text = "A_EXT($resize_this, $resize_value)";

      my $real_value = $this->Replace_Equivalences($resize_this);
      if ($real_value =~ /^std_logic_vector\'\(([\'\"])([\dxz]+)\1\)$/) #bit_vector.
      {

         $resized_text = $this->VN2BS("$resize_value\'b$2");
      } 
      elsif ($real_value =~ /^(\d+)$/) #integer
      {
         $resized_text = $this->VN2BS("$resize_value\'d$1");
      } 
      elsif ($resize_value < $this_width)
      {
         if ($resize_this eq $real_value) #non complex expression
         {                                       
            if ($resize_value eq "1") 
            {
               $resized_text = "$real_value\[0\]";

            }
            else		#2,3,4,5,6
            {
               my $resize_msb = $resize_value - 1;
               $resized_text = "$real_value \[$resize_msb DOWNTO 0\]";
            }
         }
         else #complex expresssion
         {
            if ($resize_value eq "1")
            {
               $resized_text = "Vector_To_Std_Logic($real_value)";
            }
            else
            {
               $resized_text = "A_EXT ($real_value, $resize_value)";
            }
         }
      }
      else #($resize_value > $this_width) 
      {
         if (!$this_width) 
         {

	    my $replacement = $this->Replace_Equivalences($resize_this);
	    &ribbit ("no width for '$resize_this' ($replacement) in expr(",$this->expression(),")\n");
         }

         my $diff = $resize_value - $this_width;


	 $resize_this = "A_TOSTDLOGICVECTOR($resize_this)"
             if($this_width == 1);
         
         my $zero_extend = "0" x $diff;
         $zero_extend = '"'.$zero_extend.'"';

         $resized_text = "(std_logic_vector\'($zero_extend) & ($resize_this))";
      }

      if($this->_hash->{inout}{$resize_this})
      {
         $this->_hash->{inout}{$resized_text}++;
      }
      return ($this->Replace("new_resize",
                             $resized_text,
                             $resize_value
                             )
              );
   }
}




=item I<_can_build_signal_from_args()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _can_build_signal_from_args
{
   my $this = shift;
   my $arg  = shift;
   return 0 if @_;		# More than one thing?  Nope.






   return 1 if (&is_blessed($arg) && $arg->isa("e_signal"));  
   if (ref($arg) eq "ARRAY")
   {
      return 1; 
   }

   if (ref($arg) eq "HASH")
   {
      return 1;
   }
   return 0;
}



=item I<make_lcell_expression()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub make_lcell_expression
{
   my $this = shift;

   $this->_build_my_hash;

   my ($expr,@inputs) = $this->_get_expression_and_inputs(4);

   my ($d,$c,$b,$a) = @inputs;


   $a =~ s/(\W)/\\$1/g;
   $b =~ s/(\W)/\\$1/g;
   $c =~ s/(\W)/\\$1/g;
   $d =~ s/(\W)/\\$1/g;

   my @boolean = (0,1);
   my $expr_to_eval;

   my $result = 0;
   my $tmp_result;
   my $index  = 0;
   foreach my $d_value (@boolean)
   {
      foreach my $c_value (@boolean)
      {
         foreach my $b_value (@boolean)
         {
            foreach my $a_value (@boolean)
            {
               $expr_to_eval =  $expr;
               $expr_to_eval =~ s/\b$d(?!\w)/$d_value/gx
                   if ($d);
               $expr_to_eval =~ s/\b$c(?!\w)/$c_value/gx
                   if ($c);
               $expr_to_eval =~ s/\b$b(?!\w)/$b_value/gx
                   if ($b);
               $expr_to_eval =~ s/\b$a(?!\w)/$a_value/gx
                   if ($a);
               
               $tmp_result = eval ($expr_to_eval);
               &ribbit ("got error $@")
                   if ($@);


               $tmp_result = "0" unless $tmp_result;

               if ($tmp_result !~ /^[01]$/)
               {
                  my $expression = $this->expression();
                  &goldfish
                      ("got non boolean result $tmp_result ",
                       "for expression $expression ($a,$b,$c,$d)\n",
                       $this->Replace_Equivalences("$a"),
                       " => $a_value\n",
                       $this->Replace_Equivalences("$b"),
                       " => $b_value\n",
                       $this->Replace_Equivalences("$c"),
                       " => $c_value\n",
                       $this->Replace_Equivalences("$d"),
                       " => $d_value\n");
                  return ("\"bogus\"  result",
                          @inputs);
               }
               else
               {
                  $result |= $tmp_result << $index++;
               }
            }
         }
      }
   }

   my @return_inputs = map {
      $this->Replace_Equivalences($_);
   }@inputs;

   return (sprintf("%04X",$result),
           @return_inputs
           );
}



=item I<_get_expression_and_inputs()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _get_expression_and_inputs
{
   my $this = shift;
   my $number_of_inputs = shift;

   my $expr = $this->expression();

   my @inputs;


   $expr =~ s/\~/\!/g;


   $expr =~ s/\{(.*?)\}/$this->Replace("tmp","($1)",1)/ges;


   $expr =~ s/\s+//g;
   $expr =~ s/\[([^\]\:]+)/"\[".eval($1)/es;
   $expr =~ s/\:(.*?)\]/":".eval($1)."\]"/es;   


   $expr =~ s/\b([a-zA-Z_]\w*)\[(.*?)\]/$this->_convert_to_shift_value($1,$2)/egc;
   $expr =~ s/\b([a-zA-Z_]\w*)(?![\w\[])/$this->_convert_to_shift_value($1)/egc;



   my %args;
   my $crushed_expr = $expr;
   while ($crushed_expr =~ s/^.*?\b([a-zA-Z_]\w*)(\[\d+\])?//)
   {
      my $key = $1.$2;
      $args{$key}++;
   }
   my @return_array = reverse (sort (keys(%args)));

   if (@return_array <= $number_of_inputs)
   {
      return ($expr, @return_array);
   }
   else
   {
      my @error_array = map {$this->Replace_Equivalences($_)} @return_array;
      &ribbit ("Too many terms (\n",join ("\n",(@error_array)),")\n in cascade expression",
               $this->expression());
   }
}



=item I<_convert_to_shift_value()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _convert_to_shift_value
{
   my $this = shift;

   my ($name,$index) = @_;
   my $lhs;
   my $rhs;

   if ($index)
   {
      my ($lhs,$rhs) = split (/\:/,$index);
   }
   else
   {
      my $width = $this->vhdl_hash_width($name)
          or &goldfish ("could not find width for ($name)");

      if ($width > 1)
      {
         $lhs = $width - 1;
         $rhs = 0;
      }
      else
      {

         return $name;
      }
   }

   my $replace_this;
   if ($rhs ne "")
   {
      my @order = $this->Order($rhs,$lhs);
      my $index = 0;
      $replace_this = join ("|",map{"($name\[$order[$_]\]<<$_)"}
                            (0..$#order)
                            );
      $replace_this = "($replace_this)";
   }
   else
   {
      $replace_this = $name."[".$lhs."]";
   }
   return $replace_this;
}



=item I<_is_a_vector()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _is_a_vector
{
   my $this = shift;
   my $string = @_;

   if(($string eq "1") || 
      ($string eq "boolean")){
      return 0;
   }else{
      return 1;
   }
}




=item I<bit_slice()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub bit_slice
{
   my $this = shift;
   my $this_width  = $this->width();
   my $match_width = shift || $this_width;

   my $expression = $this->expression();
   $expression =~ s/^\s*(.*?)\s*$/$1/s;

   my @array;
   if ($expression =~ /^\d*\'[bodh][\da-fxz]+$/)
   {
      $expression = $this->VN2BS($expression);
      $expression =~ s/^([\'\"])(\d+)\1$/$2/s;

      @array = map {"1'b$_"} split (//,$expression);
   }
   else
   {
      my $vector_name;
      my $lhs = $this_width - 1;
      my $rhs = 0;

      if ($expression =~ /^\w+$/)
      {
         $vector_name = $expression;
      }
      elsif ($expression =~ /^(\w+)\[([\]]+)\]$/i)
      {
         $vector_name = $1;
         my $index = $2;
         ($lhs, $rhs) = split (/\:/,$index);
         $rhs = $lhs if ($rhs eq '');

         $lhs = eval ($lhs);
         $rhs = eval ($rhs);
      }
      else
      {

         my $parent_module = $this->parent_module();
         $vector_name  = $parent_module->get_exclusive_name('bit_slice');
         $parent_module->add_contents
             (e_assign->new([[$vector_name , $this_width, 0, 1],
                             $expression])
              );
      }
      @array = map {$vector_name."[$_]"} ($rhs .. $lhs);
   }


   if (@array)
   {
      while (@array > $match_width)
      {
         pop (@array);
      }
      while (@array < $match_width)
      {
         push (@array, 0);
      }
   }

   return \@array;
}



=item I<conduit_width()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub conduit_width
{
   my $this = shift;
   my $old_return = $this->_conduit_width();
   my $return = $this->_conduit_width(@_);

   if (@_ && $this->_parent_set() && ($old_return ne $return)) 
   {
      if ($this->isa_signal_name())
      {
         my $signal = $this->expression();
         if ($return)
         {
            $this->add_child_to_parent_signal_list
                ($signal,'call_me_if_sig_updates');
         }
         else
         {
            $this->remove_child_from_parent_signal_list
                ($signal,'call_me_if_sig_updates');
         }
      }
   }
   return $return;
}


1;

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
