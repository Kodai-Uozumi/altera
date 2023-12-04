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




























package europa_utils;
require Exporter;
@ISA = Exporter;
@EXPORT = qw(dwarn dprint ribbit goldfish history e_signal_list log2
             Bits_To_Encode is_blessed copy_of_hash floor ceil max min
             copy_hash_array_or_scalar
             concatenate validate_parameter
             caller_subroutine_list
             strip_enclosing_parentheses
             or_array and_array complement complement_null_ok
             unit_prefix_to_num
             num_to_bin is_power_of_two 
             next_lower_power_of_two next_higher_power_of_two
             round_up_to_next_computer_acceptable_bit_width
             is_computer_acceptable_bit_width
             europa_indent
             System_Win98_Safe
             master_address_width_from_slave_parameters
             Strip_Perl_Comments
             hash_ref_to_parameters_signature
             str2hex str2bin 
             package_setup_fields_and_pointers
             get_mask_of_1_bits
             one_hot_encoding
             spaceless_to_spaced_hash
             to_base_26
             
             get_class_ptf
             find_component_dir
             find_all_component_dirs
             );
use strict;
use print_command;





$| = 1;   # Flush STDERR always.


sub indent
{
   my $i = 0;

   while (caller ($i++)){;}

   return (" " x $i);
}


sub europa_indent {   return &indent(@_); }


sub dwarn
{
   my $msg = join ("$,",@_); #join with special output

   my $indent = &indent();

   $msg =~ s/^/$indent/mg;   #every newline gets indented
   warn ($msg);
}

sub dprint
{
   my $msg = join ("$,",@_); #join with special output

   my $indent = &indent();

   $msg =~ s/^/$indent/mg;   #every newline gets indented.

   print ($msg);
}

sub fishing_report
{
   my (@msg_array) = (@_);


   $, = "" unless defined($,);

   my $n = scalar (@msg_array);
   
   
   my $msg = join ("$,",@msg_array); #join with special output


   $msg =~ s/^\s*(.*?)\s*$/$1/s;
   $msg .= "\n" if $msg =~ /\n$/s;  # Sugar: Prettier multi-line messages.

   my $string_to_figure_out_build = '

   ';



   if ($string_to_figure_out_build !~ /\#/s)
   {
      return $msg;
   }



   my @warn_array;
   my $i = 0;
   my ($package, 
       $filename, 
       $line,
       $subr,
       $has_args,
       $wantarray);

   while (($package, 
              $filename, 
              $line,
              $subr,
              $has_args,
              $wantarray) = caller ($i++))
   {
      $subr =~ s/^main\:\://;
      my $warn_string = "";#"\n";
      $warn_string .= "$filename $line CALLED ($subr)";
      push (@warn_array, $warn_string);
   }



   
   shift (@warn_array);

   my $ribbit_called = shift (@warn_array);
   $ribbit_called =~ s/\bCALLED\b.*//;

   my $output_string;
   my $indent = "";
   my $indent_increment = " ";
   foreach $line (reverse (@warn_array))
   {
      pop (@warn_array);
      $line =~ s/\n/\n$indent/g;

      $output_string .= $line;
      if (@warn_array)
      {
         $output_string .= "\n$indent$indent_increment";
      }
      else
      {
         $output_string .= 
             " WHERE\n'$msg' OCCURRED";
         $output_string .= " on $ribbit_called\n\n\n";
      }
      $indent .= $indent_increment;
   }

   return ($output_string);
}

sub caller_subroutine_list 
{
  my @result = ();
  my $i = 0;
  my $last_line = 0;
  while (my ($package, 
             $filename, 
             $line,
             $subr,
             $has_args,
             $wantarray) = caller ($i++))
    {
      $subr =~ s/^main\:\://;
      push (@result, "$subr\_line=$last_line");
      $last_line = $line;
    }
  return @result;
}


















sub goldfish
{
  my (@msg) = (@_);
  warn ("\nWARNING:\n",
        &fishing_report(@msg));
}

sub ribbit
{
  my (@msg) = (@_);
  my $n = scalar (@msg);
  die ("\nERROR:\n",
       &fishing_report(@msg)
       ."\n"
       );
}

sub history
{
  my (@msg) = (@_);
  return &fishing_report(@msg);
}


















sub get_next_arg
{
  my $arg_list_ref = shift;
  my $type         = shift;
  my $message      = shift;
  &ribbit ("get_next_arg itself: list-ref required for first argument.")
    unless ref ($arg_list_ref) eq "ARRAY";
  &ribbit ("get_next_arg itself: list-ref required for first argument.")
    unless ref ($type) eq "";
  &ribbit ("get_next_arg itself: two args required (list-ref, type-string).")
    unless scalar (@_) == 0;

  my $arg_value  = shift (@{$arg_list_ref});
  $message   .= ": expected $type";

  if      ($type =~ /string/) {
    &ribbit ($message) unless ref ($arg_value) eq "";
  } elsif ($type =~ /boolean/) {
    &ribbit ($message) unless $arg_value =~ /^[10]$/;
  } elsif ($type =~ /number/) {
    &ribbit ($message) unless $arg_value =~ /^\d+$/;
  } elsif ($type =~ /(.*)ref$/) {
    &ribbit ($message) unless ref ($arg_value) eq uc($1);
  } elsif ($type =~ /^e_/) {
    &ribbit ($message) unless $arg_value->isa($type);
  } else {
    &ribbit ("get_next_arg:  Don't know how to validate type '$type'");
  }
  return $arg_value;
}














sub e_signal_list {
  my @descriptions = (@_);
  my $description = join (",", @descriptions);
  my @signal_list;






  $description = &Strip_Perl_Comments    ($description);
  $description =~ s/\n/ /sg;
  foreach my $signal_description (split(/\s*\,\s*/, $description)) {
    next if $signal_description eq "";  # skip blank entries.
    my @line_list = split(/\s*\|\s*/, $signal_description);
    my $signal_name = $line_list[0];
    my $signal_width = $line_list[1];
    my $signal_export;
       $signal_export = $line_list[2] if (scalar(@line_list) > 2);
    my $signal = e_signal->new ({
        name    => $signal_name,
        width   => $signal_width, });
    $signal->export(1) if ($signal_export ne "");
    push @signal_list, $signal;
  }

  return @signal_list;
}










sub Strip_Perl_Comments
{
    my $expr;
    my @lines;
    my $stripped_expr;
    ($expr) = (@_);

    @lines = split (/\n/, $expr);

    $stripped_expr = "";
    foreach (@lines)
    {
        $stripped_expr .= "\n", next if /^\#/;
        s/^(.*?)[^\\]\#.*$/$1/;
        $stripped_expr .= "$_\n";
     }
    return $stripped_expr;
}

sub log2
{
  my ($number) = (@_);
  &ribbit ("positive-number required for log2 not ($number)") if $number <= 0;
  
  my $log_base_e_of_2 = log 2;
  
  my $log_base_e_of_number = 
    ($number == 0)? 0 :        # Error condition... see below
    log $number;
  my $log_base_2_of_number = $log_base_e_of_number / $log_base_e_of_2;
  &goldfish ("log2 of 0 is undefined!  I'll just give you 0 anyway.\n")
    if ($number == 0);

  return $log_base_2_of_number;
}
















sub strip_enclosing_parentheses
{
  my ($in_string) = (@_);





  my $stripped_string = $in_string;
  return $in_string unless $stripped_string =~ s/^\s*\((.*?)\)\s*$/$1/sg;





  if (&has_balanced_parentheses ($stripped_string)) {
    return &strip_enclosing_parentheses($stripped_string);
  } else {
    return $in_string ;
  }
}

sub has_balanced_parentheses
{
  my ($in_string) = (@_);


  $in_string =~ s/[^\(\)]*//sg;



  return 1 if length ($in_string) == 0;




  return 0 if $in_string =~ /^[^\(]*\)/s;
  return 0 if $in_string =~ /\([^\)]*$/s;



  my $count = 0;
  my @paren_list = split (//, $in_string);
  foreach my $paren (@paren_list) {
    $count--, next if $paren eq ')';
    return 0 if $count < 0;
    $count++, next if $paren eq '(';
  }

  return $count == 0;
}








sub copy_of_hash
{
  my ($input_hash) = shift;
  &ribbit ("copy_of_hash requires one argument:  A hash-reference.")
    if (ref($input_hash) ne "HASH" || scalar (@_));

  my %result = %{$input_hash};
  return \%result;
}



sub copy_hash_array_or_scalar
{
   my @return;
   foreach my $thing_to_copy (@_)
   {
      my $ref = ref($thing_to_copy);
      if ($ref eq 'HASH')
      {



         my %hash = (&copy_hash_array_or_scalar(%$thing_to_copy));
         my $hash_ptr = \%hash;
         push (@return, $hash_ptr);
      }
      elsif ($ref eq 'ARRAY')
      {
         my @array = &copy_hash_array_or_scalar(@$thing_to_copy);
         push (@return, \@array);
      }
      else
      {
         push (@return, $thing_to_copy);
      }
   }
   if (@_ == 1)
   {
      return $return[0];
   }
   else
   {
      return @return;
   }
}






sub max
{
  my $max = shift;

  for (@_)
  {

     next if $_ eq "";
     $max = $_, next if $max eq "";
     $max = $_ if ($_ > $max);
  }

  return $max;
}







sub min
{
  my $min = shift;

  for (@_)
  {

     next if $_ eq "";
     $min = $_, next if $min eq "";
     $min = $_ if ($_ < $min);
  }

  return $min;
}








sub get_file_modified_date
{
  my ($fname) = (@_);


  return 0 if !-e $fname;



  my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,
      $ctime, $blksize, $blocks) = stat ($fname);

  return $mtime;
}

BEGIN
{



  

  *CORE::GLOBAL::int = \&floor;
}

my $EPSILON = 2**(-46);






































sub floor
{
  my $num = shift;
  my $sign = $num >= 0 ? 1 : -1;

  my $floored = $sign * sprintf("%d", $sign * $num + $EPSILON);
 
  return $floored;
}







sub ceil
{
  my $num = shift;
  $num = int($num + 1) unless $num == int($num);

  return $num;
}







sub Bits_To_Encode 
{
    my $x;
    ($x) = (@_);
    return ceil(log2($x+1));
}











sub num_to_bin
{
  my ($num, $width) = (@_);
  $num = int ($num);
  my $result = "";
  while ($num || $width > 0) {
    my $next_digit = ($num & 0x01) ? "1" : "0";
    $result = $next_digit . $result;
    $num >>= 1;
    $width -= 1;
  }
  $result = "0" if $result eq "";
  return $result;
}







sub is_power_of_two
{
  my ($val) = (@_);


  if (not defined $val or $val eq '' or $val =~ /[^\d+-\.]/)
  {
    ribbit("is_power_of_two expects a number (it was passed '$val')")
  }
  



  return '' if $val == 0;

  my $log = log2($val);
  return $log == int($log);
}











sub next_lower_power_of_two
{
  my ($val) = (@_);
  return 2 ** (int (log2($val)))
}











sub next_higher_power_of_two
{
  my ($val) = (@_);
  return $val if (&is_power_of_two($val));
  return 2 * &next_lower_power_of_two($val);
}













sub round_up_to_next_computer_acceptable_bit_width
{
  my $val = shift;
  
  $val = 1 if $val <= 0;
  return max(8, 2**(ceil(log2($val))));
}







sub is_computer_acceptable_bit_width
{
  my $val = shift;
  
  return ($val >= 8) && (($val & ($val - 1)) == 0);
}





sub is_blessed
{
   my $thing = shift;

   return ref ($thing) !~
              /^(|REF|SCALAR|ARRAY|HASH|CODE|GLOB)$/;



















}
























sub concatenate
{

  my @non_null_names = ();
  foreach my $thing (@_) {
    &ribbit ("concatenate: all arguments must be -strings- (signal-names).")
      unless ref ($thing) eq "";

    push (@non_null_names, $thing) unless $thing eq "";
  }

  if (scalar (@non_null_names) == 0)  
  {
     &ribbit ("no names in concatenation");
  }
  elsif (scalar (@non_null_names) == 1)
  {
     return ($non_null_names[0]);
  }
  else
  {
     return "\{" . join (",\n", @non_null_names) . "\}";
  }
}










sub or_array
{
   my @a;
   foreach my $b (@_)
   {
      push (@a, $b) 
          unless $b eq "";
   }
   return 0 unless @a;
   return "(".join (" | ", @a).")";
}

sub and_array
{
   my @a;
   foreach my $b (@_)
   {
      push (@a, $b) 
          unless $b eq "";
   }
   &ribbit ("no signals") unless @a;
   return "(".join (" & ", @a).")";
}









sub complement
{
   my $thing_to_complement = shift;
   &ribbit ("no_complement") if ($thing_to_complement eq "");
   
   my $need_parentheses = $thing_to_complement;   


   while ($need_parentheses =~ s/\([^\(\)]*\)//s)
   {;}





   $thing_to_complement =~ s/^(\s*)(.*)/$2/s or 
       &ribbit ("But that's impossible! This regexp must match!");
   my ($indentation, $guts) = ($1,$2);

   ($need_parentheses =~ s/^(\s*)(\~)?([\w\s]*)([^\w\s])*/$4/s) or
   &ribbit ("But that's impossible! This regexp must match!");

   my $negation = $2;

   if ($negation eq "~")
   {



      if ($need_parentheses eq "") 
      {







         $guts =~ s/^\~/$1/;  #~(a) => (a)
      }
      else #we need parentheses 
      {

         $guts = "\~\($guts\)";
      }
      return ($indentation.$guts);
   }
   else
   {
      $guts = "\($guts\)"
          if ($need_parentheses ne "");

      return ("$indentation\~$guts");
   }
}

sub complement_null_ok
{
   my $thing_to_complement = shift;
   $thing_to_complement ne "" or return "";
   return (&complement($thing_to_complement));
}













sub vp_fail
{
  my ($vp_args, @err_messages) = (@_);

  my $is_warning = $vp_args->{severity} =~ /^warn/i;

  my $intro   = "ERROR:   Parameter validation failed.";
     $intro   = "WARNING: Parameter validation issue"   if $is_warning;

  my $closing = "\n";
     $closing = "Continuing logic generation...\n"      if $is_warning;


  my @blab_list = ();
  push (@blab_list, $intro);
  push (@blab_list, $vp_args->{message}) if $vp_args->{message} ne "";
  push (@blab_list, @err_messages);
  push (@blab_list, $closing);
  my $msg = join ("\n  ", @blab_list);

  if ($is_warning) {
    &goldfish ($msg);
  } else {
    &ribbit ($msg);
  }
}

















sub validate_parameter
{
  my ($arg) = (@_);





  my $value;
  if (exists($arg->{value})) {
    &ribbit ("Can't specify both 'value' and 'hash'") if(exists($arg->{hash}));
    &ribbit ("Can't specify both 'value' and 'name'") if(exists($arg->{name}));
    $value = $arg->{value};
  } else {
    &ribbit ("No value found.",
             "  You must set 'value' or both 'hash' and 'name'")
      if !exists($arg->{hash}) || !exists($arg->{name});
    $value = $arg->{hash}->{$arg->{name}};
  }

  my $name = $arg->{name};







  if (exists($arg->{default}) && $value eq "") {
    &ribbit ("Can't set default for parameter '$name' (hash required)")
      unless exists ($arg->{hash});


    $value                = $arg->{default};
    $arg->{hash}->{$name} = $arg->{default};
  }


  if (($value eq "") && !$arg->{optional}) {
    &vp_fail ($arg, " Required parameter '$name' is missing.");
  }










  if (($arg->{type} =~ /^int/i)) {
    &vp_fail ($arg, " Parameter '$name' must be an integer.")
        unless (ref ($value) eq "");



    $value = eval ($value) if $value =~ /^0x/;
    &vp_fail ($arg, " Parameter '$name' must be an integer.")
        unless (int ($value) == $value);

  } elsif ($arg->{type} =~ /^string$/i) {
    &vp_fail ($arg, " Parameter '$name' must be a string.")
      unless (ref ($value) eq "");

  } elsif ($arg->{type} =~ /^bool/i) {
    &vp_fail ($arg, " Parameter '$name' must be a boolean (1 or 0).")
      unless (ref ($value) eq "") && (($value == 1) || ($value == 0));
  }










  if (exists($arg->{range})) {
    my $range = $arg->{range};
    &vp_fail ($arg, 
              " range for '$name'  must be specified as a two-element list)")
      unless (ref ($range) eq "ARRAY") && (scalar(@{$range}) == 2);

    my ($lower, $upper) = @{$range};
    &vp_fail ($arg, " Parameter '$name' (=$value) is outside of allowed range",
                    " ($lower, $upper)")
      unless ($lower <= $value) && ($upper >= $value);
  }









  if (exists($arg->{allowed})) {
    my $allowed = $arg->{allowed};
    &vp_fail ($arg,
              " allowed values for '$name'  must be specified as a list)")
      unless (ref ($allowed) eq "ARRAY");

    my $is_allowed = 0;
    foreach my $allowed_value (@{$allowed}) 
    {
      if (($arg->{type} =~ /^string$/i)) {



        if (($allowed_value =~ /^\s*\/.*\/.*/)) {
          my $match_expr = "\$is_allowed = (\$value =~ $allowed_value)";
          eval ($match_expr);
          &vp_fail ($arg,
                    " Error evaluating match expression [$match_expr]: $@") 
            if $@;
        } else {
          $is_allowed = 1 if $value eq $allowed_value;
        }
      } else {
        $is_allowed = 1 if $value == $allowed_value;
      }
      last if $is_allowed;
    }

    &vp_fail ($arg,
              " Parameter '$name' (= $value)",
              " is not one of the listed allowed values.") unless $is_allowed;
  }










  if (exists($arg->{exlcudes_all}) && $value) {
    my $exclude_list = $arg->{exlcudes_all};

    foreach my $exclude_name (@{$exclude_list}) {
      my $exclude_value = $arg->{hash}->{$exclude_name};
      next unless $exclude_value;
      &vp_fail ($arg,
              " Parameter '$name' (= $value)\n",
              " is mutually exclusive with parameter",
              " '$exclude_name' (= $exclude_value)\n");
    }
  }









  if (exists($arg->{requires}) && $value) {
    my $require_name = $arg->{requires};
    &vp_fail ($arg, 
              " Parameter '$name' (= $value)\n",
              " requires setting paramter '$require_name'") 
      unless $arg->{hash}{$require_name};
  }

  return $value;
}















my %unit_prefix_hash = (a     => (1.0 / 1.0E18   ),
                        ato   => (1.0 / 1.0E18   ),
                        f     => (1.0 / 1.0E15   ),
                        femto => (1.0 / 1.0E15   ),
                        p     => (1.0 / 1.0E12   ),
                        pico  => (1.0 / 1.0E12   ),
                        n     => (1.0 / 1.0E9    ),
                        nano  => (1.0 / 1.0E9    ),
                        u     => (1.0 / 1000000.0),
                        micro => (1.0 / 1000000.0),
                        "m"   => (1.0 / 1000.0   ),
                        milli => (1.0 / 1000.0   ),
                        c     => (1.0 / 100.0    ),
                        centi => (1.0 / 100.0    ),
                        d     => (1.0 / 10.0     ),
                        deci  => (1.0 / 10.0     ),
                        K     => (1000.0         ),
                        k     => (1000.0         ),
                        kilo  => (1000.0         ),
                        M     => (1000000.0      ),
                        mega  => (1000000.0      ),
                        G     => (1.0E9          ),
                        giga  => (1.0E9          ),
                        T     => (1.0E12         ),
                        tera  => (1.0E12         ),
                       );

sub unit_prefix_to_num
{
  my ($prefix) = (@_);
  return 1.0 if $prefix eq "";    # no prefix--whole units.


  $prefix = lc($prefix) if length ($prefix) > 1;

  &ribbit ("unknown unit prefix: '$prefix'") 
    unless exists ($unit_prefix_hash{$prefix});

  return $unit_prefix_hash{$prefix};
}















sub System_Win98_Safe
{
  my ($first_arg) = (@_);
  my @command_parts;

  if(ref($first_arg) eq "ARRAY")
  {
    @command_parts = @$first_arg; 
  }
  else
  {
    @command_parts = @_; 
  }

  system(@command_parts);
  my $error_code = ($? >> 8);
  return $error_code;
}


























sub master_address_width_from_slave_parameters
{
  my $project = shift or ribbit("no project!");
  my $master_desc = shift or ribbit("no master desc!");
  my $slave_desc = shift or ribbit("no slave desc!");

  my $slave_hash = $project->SBI($slave_desc);
  &ribbit("$slave_desc: no SBI") if !$slave_hash;
  

  for (qw(Address_Width Data_Width Base_Address Address_Alignment))
  {
    &ribbit ("slave $slave_desc is missing parameter '$_'")
      if !defined($slave_hash->{$_});
  }
  

  my $determining_data_width;
  my $culprit;
  if ($slave_hash->{Address_Alignment} eq "native")
  {

    my $master_hash = $project->SBI($master_desc, "MASTER");
    &ribbit("$master_desc: no SBI") if !$master_hash;
    
    $determining_data_width = $master_hash->{Data_Width};
    $culprit = $master_desc;
  }
  elsif ($slave_hash->{Address_Alignment} eq "dynamic")
  {



    my $is_adapter = 0;
    if ($slave_desc =~ m|^(.+/)(.*)$|)
    {
      my $module_name = $1;
      my $module_sbi = $project->SBI($module_name);
      if ($module_sbi)
      {
        $is_adapter = $project->SBI($module_name)->{Is_Adapter} ||
          $project->SBI($module_name)->{Is_Test_Adapter};
      }
    }

    $determining_data_width = $is_adapter ? 8 : $slave_hash->{Data_Width};
    $culprit = $slave_desc;
  }
  else
  {
    ribbit("I don't understand address_alignment " .
      "'$slave_hash->{Address_Alignment}'\n");
  }

  &ribbit("$culprit: no data width") if !$determining_data_width;
  &goldfish ("$culprit: weird data width '$determining_data_width")
    if log2($determining_data_width) != int(log2($determining_data_width));

  $b = log2($determining_data_width / 8);


  my $base_address = $slave_hash->{Base_Address};
  


  $base_address = hex($base_address) if ($base_address =~ /^0x/);
  

  my $address_width = $slave_hash->{Address_Width};
  my $last_address = $base_address + 2**($b + $address_width) - 1;

  my $real_addr_width = Bits_To_Encode($last_address);
  


  if (wantarray)
  {
    return
      ($real_addr_width, $base_address, $last_address);
  }
  
  return $real_addr_width;
}






















sub hash_ref_to_parameters_signature
{
  if (@_ == 1)
  {

    my $hr = shift;
    if (ref($hr) ne 'HASH')
    {
      &ribbit("hash_ref_to_parameters_signature() wants a hash reference\n")
    }



    return hash_ref_to_parameters_signature('/', $hr);
  }
  elsif (@_ == 2)
  {

    my ($key, $value) = @_;
    my $return_value;






    return if $key eq 'Parameters_Signature';




















    if (ref($value) eq 'HASH')
    {
      $return_value .= $key;


      for my $subkey (sort keys %{$value})
      {
        $return_value .=
          hash_ref_to_parameters_signature($subkey, $value->{$subkey});
      }
    }
    elsif (ref($value) eq 'ARRAY')
    {
      $return_value .= $key;


      for my $array_item (@{$value})
      {
        $return_value .= hash_ref_to_parameters_signature('', $array_item);
      }
    }
    elsif (not ref($value))
    {

      $return_value .= $key;
      $return_value .= $value;
    }
    else
    {
      &ribbit("Unexpected ref: ", ref($value));
    }

    return $return_value;
  }
  else
  {
    &ribbit("Unexpected number of parameters: ", 0 + @_, "\n");
  }
}






sub str2hex
{
    my $string = shift;

    my $length = length ($string) * 2;
    my $TEMPLATE = "H".$length;

    return ($length*4)."'h".unpack($TEMPLATE, $string);
}






sub str2bin
{
    my $string = shift;

    my $length = length ($string) * 8;
    my $TEMPLATE = "B".$length;
    return ($length)."'b".unpack($TEMPLATE, $string);
}

my $base_class = 'e_object';
sub assign_subroutine
{
   my ($pkg,$sub_name,$sub) = @_;
   my $glob = $pkg.'::'.$sub_name;

   no strict 'refs';






   if (defined (&$glob))
   {

      if (defined (&$glob))
      {
         die ("$pkg, $glob already defined\n");
      }
   }


   *$glob = $sub;
   use strict 'refs';
}

sub package_setup_fields_and_pointers
{
   my ($pkg, $fields, $pointers,$debug) = @_;

   my $super_name = $pkg.'::ISA';
   no strict 'refs';
   my ($super) = @$super_name;
   use strict 'refs';

   my $gp = 'get_pointers';
   my $gf = 'get_fields';
   if (!$super)
   {
      $gp = 'empty_array';
      $gf = 'empty_array';
      $super = "$pkg";
   }


   my $get_pointers = sub 
   {
      my $this = shift;
      my %new_args = %$pointers;
      my @array_pointers = keys (%$pointers);
      map {$new_args{$_}++} $super->$gp();
      return (keys (%new_args));
   };

   &assign_subroutine($pkg, 'get_pointers', $get_pointers);
   foreach my $arg (keys (%$pointers))
   {
      my $value = $pointers->{$arg};
      my $sub = sub {
         my $this = shift;
	 &ribbit ("what are you thinking?")
	   unless (ref($this));
         if (@_)
         {
            $this->{$arg} = shift;
         }
         elsif (!defined ($this->{$arg}))
         {
            $this->{$arg} = $value;
         }
         return $this->{$arg};
      };
      &assign_subroutine($pkg,$arg,$sub);
   }

   my $get_fields = sub 
   {
      my $this = shift;
      my %new_args = %$fields;
      my @array_fields = keys (%$fields);
      map {$new_args{$_}++} $super->$gf();
      return (keys (%new_args));
   };
   &assign_subroutine($pkg, 'get_fields', $get_fields);

   foreach my $arg (keys (%$fields))
   {
      my $value = $fields->{$arg};
      my $set = $value;
      my $ref = ref($value);

      my $sub;
      if (&is_blessed($value))
      {
         $sub = sub {
            my $this = shift;

            if (@_)
            {
               my $shift = shift;
               $this->{$arg} = $ref->new($shift);
            }
            elsif (!defined ($this->{$arg}))
            {
               $this->{$arg} = $ref->new($value);
            }
            return $this->{$arg};
         };
      }
      elsif (ref ($value))
      {
         $sub = sub {
            my $this = shift;
            if (@_)
            {
               my $shift = shift;
               $this->{$arg} = &copy_hash_array_or_scalar($shift);
            }
            elsif (!defined ($this->{$arg}))
            {
               $this->{$arg} = &copy_hash_array_or_scalar($value);
            }
            return $this->{$arg};
         };
      }
      else
      {
         $sub = sub {
            my $this = shift;
            if (@_)
            {
               my $shift = shift;
               $this->{$arg} = $shift;
            }
            elsif (!defined ($this->{$arg}))
            {
               $this->{$arg} = $value;
            }
            return $this->{$arg};
         };
      }
      &assign_subroutine($pkg,$arg,$sub);
   }

}




















sub get_mask_of_1_bits
{
  my $n = 0 + shift;

  ribbit("bad parameter '$n'") if (($n > 32) || ($n < 0));
  return ~0 if ($n == 32);
  return ((1 << $n) - 1);
}













sub one_hot_encoding
{
    my $number = shift;
    return if ($number < 1);

    my @k = (0) x $number;

    $k[($number-1)] = 1;

    my @vals = ($number."'b".join('',@k));

    for (2 .. $number) {
        my $zero = shift(@k);
        push (@k, $zero);
        push (@vals, ($number."'b".join('',@k)));
    }

    return @vals;
} # &one_hot_encoding

=item I<make_special_assignments()>
A "spaceless" hash looks like this:
$spaceless = {
  Address_Alignment => "native",
  IRQ_MASTER => {
    cpu/data_master => {
      IRQ_Number => 1,
    }
  }    
  MASTERED_BY => {
    cpu/data_master => {
      priority => 1,
      fictitious_section => {
          with_space => {
          {
            assignment = "1",
          },
        },
      },
    },
    cpu/instruction_master => {
      priority => 1,
    },
  },
  NO_SPACE_SECTION => 
  {
    foo => "bar",
    one => "two",
  },
};

In other words, standard ptf assignments look like regular
key => scalar value pairs, but for ptf subsections whose names are of the form:

(\S+)\s+(\S+)
$key = $1;
$subkey = $2;

are represented in a subhash for each $key value, with a sub-subhash
for each unique $subkey value; each sub-subhash is keyed on $subkey,
and contains all the assignments of ptf subsection "$key<space>$subkey".


Here are the ptf file entries corresponding to the above spaceless hash:

SYSTEM_BUILDER_INFO 
{
  Address_Alignment = "native";
  MASTERED_BY cpu/data_master
  {
     priority = "1";
     fictitious_section with_space
     {
       assignment = "1";
     }
  }
  MASTERED_BY cpu/instruction_master
  {
     priority = "1";
  }
  IRQ_MASTER cpu/data_master
  {
     IRQ_Number = "1";
  }
  NO_SPACE_SECTION 
  {
     foo = "bar";
     one = "two";
  }
}


This routine puts the spaces back in:
$spacy = {
  Address_Alignment => "native",
  "IRQ_MASTER cpu/data_master" => {
    IRQ_Number => 1,
  }    
  "MASTERED_BY cpu/data_master "=> {
    priority => 1,
    "fictitious_section with_space" => {
      assignment = "1";
    },
  },
  "MASTERED_BY cpu/instruction_master "=> {
    priority => 1,
  },
  NO_SPACE_SECTION => 
  {
    foo => "bar",
    one => "two",
  },
};

=cut

sub spaceless_to_spaced_hash($)
{
  my $spaceless_hash = shift;
  
  if (ref($spaceless_hash) ne 'HASH')
  {
    ribbit("expected hash reference, got ", ref($spaceless_hash), "!");
  }
    
  my $spaced_hash = {};
  
  foreach my $key (sort keys %$spaceless_hash)
  {
    my $value = $spaceless_hash->{$key};
    if (!ref ($value))
    {
      $spaced_hash->{$key} = $value;
      next;
    }
    

    if (ref($value) ne 'HASH')
    {
      ribbit("expected hash reference; got ", ref($value), "!")
    }

    foreach my $subkey (keys %$value)
    {





      if (!ref($value->{$subkey}))
      {
        $spaced_hash->{$key} = {} if !exists($spaced_hash->{$key});
        $spaced_hash->{$key}->{$subkey} = $value->{$subkey};
      }
      else
      {
        my $spaced_subkey = "$key $subkey";
        $spaced_hash->{$spaced_subkey} =
          spaceless_to_spaced_hash($value->{$subkey});
      }
    }
  }
  
  return $spaced_hash
}

=item I<to_base_26()>
Convert an input number to base 26 (digits are represented by
the lowercase alphabet [a-z]).

1st parameter: the number to convert
optional 2nd parameter: the number of digits to use.  Defaults 
  to 3, which allows for 26**3 unique tags.

Why this subroutine exists: simulation wave info in the
<MODULE foo>/SIMULATION/DISPLAY section of the ptf is contained
in uniquely-tagged subsections.  Dividers and signals appear in the
wave window in lexically sorted order by tag.  Thus, this routine,
which converts from easily-created sequence numbers to a representation
which admits a lexical sort.

See e_project::set_sim_wave_signals().
=cut

sub to_base_26($;$)
{
  my $x = shift;
  my $digits = shift || 3;
  my @chars = ();
  
  return 'a' x $digits if ($x == 0);
  
  for (0 .. -1 + $digits)
  {
    push @chars, chr(($x % 26) + ord('a'));
    $x = int($x / 26);
  }
  
  my $ret = join("", reverse @chars);
  return $ret;
}













sub ensure_class_ptfs($$)
    {
    my ($g,$verbose) = (@_);

    return if($$g{class_dirs}); # already loaded them. yay.

    require "ptf_parse.pm";

    print_command("Finding all available components") if $verbose;

    $$g{class_ptfs} = {};
    $$g{class_dirs} = {};







    my $system_directory =$$g{system_directory};

    if(! -d $system_directory)
    {
        ribbit("get_class_ptf and ensure_class_ptfs must be called with g{system_directory}");
    }

    my $f;

    my $dir = $system_directory;
        {
        $f = "$dir/.sopc_builder/install.ptf";
        if(-f $f)
            {
            last;
            }
        $f = "";
        }

    ribbit ("no install.ptf file found") if(! -f $f);

    print_command("Reading $f") if $verbose;

    my $install_ptf = ptf_parse::new_ptf_from_file($f);

    my $install_ptf = ptf_parse::get_child_by_path($install_ptf,"PACKAGE");

    my $component_kind_count = ptf_parse::get_child_count($install_ptf,"COMPONENT");




    for(my $i = 0; $i < $component_kind_count; $i++)
        {
        my $component_ptf = ptf_parse::get_child($install_ptf,$i,"COMPONENT");
        my $component_name = ptf_parse::get_data($component_ptf);
        my $version_count = ptf_parse::get_child_count($component_ptf,"VERSION");

        my $highest_version = -10;
        my $highest_version_ptf;
        for(my $j = 0; $j < $version_count; $j++)
            {
            my $version_ptf = ptf_parse::get_child($component_ptf,$j,"VERSION");
            my $version = ptf_parse::get_data($version_ptf);
            if($version > $highest_version)
                {
                $highest_version = $version;
                $highest_version_ptf = $version_ptf;
                }
            }






        my $component_directory =
                ptf_parse::get_data_by_path($highest_version_ptf,"local");
        $component_directory =~ s/\\/\//g;  # no bad (backward) slashes
        $$g{class_dirs}{$component_name} = $component_directory;
        }
      print_command("Found $component_kind_count components") if $verbose;
    }








sub get_class_ptf($$;$)
  {
  my ($g,$module_type, $verbose) = (@_);

  ensure_class_ptfs($g, $verbose);

    my $class_ptf = $$g{class_ptfs}{$module_type};





    if(!$class_ptf)
        {
        my $component_directory = $$g{class_dirs}{$module_type};
        $class_ptf = ptf_parse::new_ptf_from_file("$component_directory/class.ptf");
        $$g{class_ptfs}{$module_type} = $class_ptf;
        }

  return $class_ptf;
  }












sub find_component_dir
  {
  my ($g,$module_ref,$module_type,$verbose) = @_;
  my $dir;

  ensure_class_ptfs($g,$verbose);

  if(!$module_type)
    {
    $module_type = ptf_parse::get_data_by_path($module_ref,"class");
    }

  return $$g{class_dirs}{$module_type};
  }








sub find_all_component_dirs
  {
  my ($g,$verbose) = @_;
  
  ensure_class_ptfs($g,$verbose);
  my @dirlist = values %{$$g{class_dirs}};
  
  return \@dirlist;
  }



1;
