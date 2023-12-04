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














































sub ribbit
{
  my ($msg) = (@_);
  die "Please link with 'ribbit' module.\n$msg\n";
}

sub hash_to_string
{
  my ($h, $space) = (@_);
  my @result = ();
  my $name = $h->{name};
     $name = "unnamed" if $name eq "";
  push (@result, "$space $name, which is:\n");
  foreach $key (keys(%$h)) {
    push (@result, "$space   $key = ($h->{$key})\n");
  }
  return join ("", @result);
}












sub verilog_object_order
{

  if ($a->{type} eq "e_signal" && $b->{type} eq "e_signal") {

    if ($a->{signal_type} eq "port" && $b->{signal_type} eq "port") {
      return -1 if $a->{direction} eq "input";
      return  1 if $b->{direction} eq "output";
      return  0;
    }
    return -1 if $a->{signal_type} eq "port";
    return  1 if $b->{signal_type} eq "port";

    return -1 if $a->{signal_type} eq "wire";
    return  1 if $b->{signal_type} eq "wire";

    return  0;
  }

  return -1 if $a->{type} eq "e_signal";
  return  1 if $b->{type} eq "e_signal";
}






































sub Arg_Error_Message
{
  my ($msg, $subroutine_name, $raw_hash) = (@_);

  return "Invalid arguments for $subroutine_name:\n" . 
         &hash_to_string ($raw_hash, "     ")        . 
         "  $msg\n"                                  ;
}

sub Document_Args
{
  my ($subroutine_name, $doc) = (@_);


  my %required       = ();
  my %documented     = ();
  my %default_value  = ();
  my %expected_type  = ();
  my %allowed_values = ();







  my @doc_lines = split (/\s*\n\s*/, $doc);
  foreach $doc_line (@doc_lines) {


    $doc_line =~ s/^\s*([^\#]*)\#.*$/$1/;


    $doc_line =~ s/^(.*?)\s+\-.*$/$1/;

    next unless $doc_line =~ /^(\*?)\s*(\w+)(.*?)$/;
    my $required_star = $1;
    my $arg_name      = $2;
    my $rest_of_line  = $3;

    if ($rest_of_line =~ s/(.*?)\s*\((.*)\)\s*(.*?)/$1$3/) {
      my @value_list = split (/\s*,\s*/, $2);
      $allowed_values{$arg_name} = \@value_list;
    }

    $documented   {$arg_name} =  1;
    $required     {$arg_name} =  1 if $required_star;
    $default_value{$arg_name} = $1 if $rest_of_line =~ /\s*=\s*(\S+)\s*/;
    $expected_type{$arg_name} = $1 if $rest_of_line =~ /\s*:\s*(\S+)\s*/;
  }

  my %sub_doc_hash;
  $sub_doc_hash{documented}     = \%documented;
  $sub_doc_hash{required}       = \%required;
  $sub_doc_hash{default_value}  = \%default_value;
  $sub_doc_hash{expected_type}  = \%expected_type;
  $sub_doc_hash{allowed_values} = \%allowed_values;




  $db_arg_doc{$subroutine_name} = \%sub_doc_hash;

}

sub Validate_Args
{
  my ($subroutine_name, $raw_hash) = (@_);

  my $sub_doc_hash = $db_arg_doc{$subroutine_name};


  my %result         = ();
  my %user_defined   = ();
  my %unrecognized   = ();



  foreach $raw_arg_name (keys(%$raw_hash)) {
    $user_defined{$raw_arg_name} = 1;

    if ($sub_doc_hash->{documented}{$raw_arg_name} ) {
      $result      {$raw_arg_name} = $raw_hash->{$raw_arg_name};
    } else {





      $result      {$raw_arg_name} = $raw_hash->{$raw_arg_name};
      $unrecognized{$raw_arg_name} = $raw_hash->{$raw_arg_name};
    }

    if (my $expecto = $sub_doc_hash->{expected_type}{$raw_arg_name}) {
      my $raw_arg_type = $raw_hash->{$raw_arg_name}{type};
      if ($expecto ne $raw_arg_type) {
        ribbit (&Arg_Error_Message (
                "Wrong arg type for '$raw_arg_name'.\n" . 
                 "  Got type '$raw_arg_type', expected '$expecto'.\n", @_));
      }
    }
  }



  foreach $required_arg (keys(%{$sub_doc_hash->{required}})) {
    next if $user_defined {$required_arg};
    ribbit (&Arg_Error_Message (
               "Required argument '$required_arg' not found.\n", @_));
  }


  foreach $defaulting_arg (keys(%{$sub_doc_hash->{default_value}})) {
    next if $user_defined {$defaulting_arg};
    $result{$defaulting_arg} = $sub_doc_hash->{default_value}{$defaulting_arg};
  }



  foreach $limited_arg  (keys (%{$sub_doc_hash->{allowed_values}})) {
    my $value = $result{$limited_arg};
    my $is_allowed = 0;

    my (@allowed_value_list) = 
      (@{$sub_doc_hash->{allowed_values}{$limited_arg}});

    foreach $allowed_value (@allowed_value_list) {
      $is_allowed = 1 if $allowed_value eq $value;
      $is_allowed = 1 if $allowed_value == $value;
    }
    if (!$is_allowed) { ribbit ( &Arg_Error_Message (
       "Error '$value' is not one of the allowed\n" . 
        "  values for '$limited_arg' ("             . 
        join (", ", @allowed_value_list) . ")\n", @_));
    }
  }

  return (\%result, \%user_defined, \%unrecognized);
}








sub ei_hdl_comment
{
  my ($comment, $language) = (@_);
  return "   // $comment\n" if $language =~ /verilog/i;
  return "   -- $comment\n" if $language =~ /vhdl/i;

  ribbit ("e_hdl_comment: unknown language: $language");
}


















&Document_Args ("ei_create_hash_from_attributes", "
 *attribute_list                    - Ref to list of attribute strings.
  unnamed_coercion_order            - Ref to list of coercion names.
 ");


sub ei_create_hash_from_attributes
{
  my ($arg) = &Validate_Args ("ei_create_hash_from_attributes", @_);

  my %result = ();


  my (@unnamed_attribute_coercion_order) = (@{$arg->{unnamed_coercion_order}});

  my @expanded_attributes = ();
  foreach $attribute (@{$arg->{attribute_list}}) {
    $attribute =~ s/\n/ /smg;
    $attribute =~ s/\s+(.*?)\s+/$1/smg;
    push (@expanded_attributes, split (/\s*\|\s*/, $attribute));
  }

  foreach $pair (@expanded_attributes) {
    my $attrib_name  = "";
    my $attrib_value = "";
    if ($pair !~ /^\s*(\w+)+=(.+?)\s*/) {
      $attrib_name  = shift (@unnamed_attribute_coercion_order);
      $attrib_value = $pair;
    } else {
      $attrib_name  = $1;
      $attrib_value = $2;
    }

    die "ei_create_hash_from_attributes: Bad 'name=value' pair: $pair"
      unless ($attrib_name ne "") && ($attrib_value ne "");
    $result{$attrib_name} = $attrib_value;
  }
  return \%result;
}










&Document_Args ("ei_merge_hashes", "
  *source              -Ref to source-hash
  *dest                -Ref to desitnation hash.
 ");


sub ei_merge_hashes
{
 my ($arg) = &Validate_Args ("ei_merge_hashes", @_);

 foreach $src_key (keys (%{ $arg->{source} })) {
   next if $arg->{dest}{$src_key} ne "";
   $arg->{dest}{$src_key} = $arg->{source}{$src_key};
 }
}




&Document_Args ("e_signal", "
  *name                                     - Formal HDL name of signal.
   width       = 1                          - Vector (bit) width of signal
   signal_type = wire (port,wire,register)  - What kind of thing?
 ");




sub e_signal
{
  my ($arg)  = &Validate_Args ("e_signal", @_);

  my %result = (type => e_signal);
  &ei_merge_hashes ({ dest => \%result, source=> $arg });

  return \%result;
}




&Document_Args ("e_port", "
  *name                                - Formal port name.
   width      = 1                      - Vector (bit) width.
  *direction  (input,output,inout,I,O) - Direction (w/handy abbreviations!)
 ");




sub e_port
{
  my ($arg)= &Validate_Args ("e_port", @_);

  $arg->{direction} = "input"  if $arg->{direction} =~ /^\s*I\s*$/i;
  $arg->{direction} = "output" if $arg->{direction} =~ /^\s*O\s*$/i;

  my %signal_args = (signal_type => "port");
  &ei_merge_hashes ({ dest => \%signal_args, source => $arg });

  return &e_signal (\%signal_args);
}

















sub e_port_from_description
{
  my (@attribs) = (@_);
  my $port_args = &ei_create_hash_from_attributes ({
                     attribute_list         => \@attribs,
                     unnamed_coercion_order => ["name", "width", "direction"],
                     });

  my $e_port = &e_port ($port_args);
  return $e_port;
}











sub e_make_port_list
{
  my (@description_strings) = (@_);
  my $big_string = join (",", @description_strings);
  my @description_list = split (/\s*,\s*/, $big_string);

  my @result = ();
  foreach $description (@description_list) {
    push (@result, &e_port_from_description ($description))
  }
  return @result;
}








sub ei_signal_hdl_declare
{
  my ($sig, $language) = (@_);
  $language = "Verilog" if !$language;
  
  if ($language !~ /verilog/i) { ribbit (
     "Sorry.  Verilog is the only language curently supported.");
  }


  my @result = ("   ");



  if      ($sig->{signal_type} eq "port") {
    push (@result, $sig->{direction});
  } elsif ($sig->{signal_type} eq "register") {
    push (@result, "reg");
  } else {
    push (@result, "wire");
  }



  if ($sig->{width} > 1) {
    my $msb = $sig->{width} - 1;
    push (@result, " [$msb : 0]");
  }



  push (@result, " ", $sig->{name}, ";\n");

  return join ("", @result);
}










&Document_Args ("e_register", '
  *q                          -Name of the Q-output, which is also taken
                              -   as the formal name of this register.
   d                          -Signal-name of D-input.  Not required
                              -   if "sync_set" or "sync_reset" inputs presnt.
   clk        =clk            - Name of clock-input signal.
   edge       =pos  (pos,neg) - Which edge of clock.
   enable                     - Name of clock-enable input signal, if any.
   reset                      - Name of asynchronous-reset input signal.
   set                        - Name of asynchronous-set input signal.
   sync_set                   - Name of synchronous-set input, if any.
   sync_reset                 - Name of synchronous-reset input, if any.
   set_value  =1              - Value associated with sync/async set inputs.
   width      =1              - Number of bits in vector.
 ');











sub e_register
{
  my ($args) = &Validate_Args ("e_register", @_);

  my %result = ( type        => "e_signal",
                 signal_type => "register",
                 name        => $args->{"q"} );

  &ei_merge_hashes ({ dest => \%result, source => $args});
  return \%result;
}
















&Document_Args ("e_assign", "
  *target             - The signal name being assigned-to
  *expression         - Verilog-syntax continuous-assignment expression.
  width        =1     - Vector (bit) width of target signal.
 ");









sub e_assign
{
  my ($arg) = &Validate_Args ("e_assign", @_);

  my %result = ( type => "e_assign" );
  &ei_merge_hashes ({ dest => \%result, source => $args});
  return \%result;
}








sub ei_assign_hdl_implement
{
  my ($obj, $language) = (@_);
  my @result = ("   ");
  if ($language =~ /verilog/i) {
    push (@result,
          "assign ", $obj->{target}, " = ", $obj->{expression}, ";\n");
  } else {
    die ("e_assign: '$language' is not a supported language.\n");
  }
  return join ("", @result);
}






&Document_Args ("e_mux", "
  *out               - Name of output signal
  *width             - Vector (bit) width of output signal.
  *table             - Condition --> result table, comma-delimited.
   type    = and_or  - Can be any of: priority, case, or numeric.
 ");





sub e_mux
{
  my ($arg) = &Validate_Args ("e_mux", @_);

  my %result = ( type => "e_mux" );
  &ei_merge_hashes ({ dest => \%result, source => $arg });
  return \%result;
}









&Document_Args ("e_module", "
  *name                   -Formal HDL module-name.
  *contents               -List (ref) of other e_object elements.
 ");








sub e_module
{
  my ($arg) = &Validate_Args ("e_module", @_);

  my %result =    ( type => "e_module");
  &ei_merge_hashes ({ dest => \%result, source => $arg });
  $europa_module_database{$result{name}} = \%result;
  return \%result;
}

















sub ei_object_hdl_implement
{
  my ($obj, $language) = (@_);

  if      ($obj->{type} eq "e_signal") {
    return &ei_signal_hdl_implement ($obj, $language)

  } elsif ($obj->{type} eq "e_assign") {
    return &ei_assign_hdl_implement ($obj, $language)

  } elsif ($obj->{type} eq "e_mux") {
    return &ei_mux_hdl_implement ($obj, $language)
  }
}









sub ei_module_get_objects_of_type
{
  my ($mod, $type) = (@_);
  my @result = ();
  foreach $e_object (@{$mod->{contents}}) {
    next unless $e_object->{type} eq $type;
    push (@result, $e_object);
  }
  return @result;
}








sub ei_module_get_ports
{
  my ($mod) = (@_);
  my @result = ();
  foreach $e_object (&ei_module_get_objects_of_type ($mod, "e_signal")) {
    next unless $e_object->{signal_type} eq "port";
    push (@result, $e_object);
  }
  return @result;
}








sub ei_module_get_port_names
{
  my ($mod) = (@_);
  my @result = ();
  my @ports = &ei_module_get_ports ($mod);
  foreach $e_port (@ports) {
    push (@result, $e_port->{name});
  }
  return @result;
}






&Document_Args ("e_module_to_hdl_string", "
  module                         - NAME of module to write.
  e_module_ref                   - Ref to e_module object.
  language          = Verilog    - Verilog or VHDL.
 ");





sub e_module_to_hdl_string
{
  my ($arg, $user_defined) = &Validate_Args ("e_module_to_hdl_string", @_);








  my @result = ();




  if ($user_defined->{module}      &&
      $user_defined->{e_module_ref} )  {
    ribbit ("
      e_write_module: module specified by both name and ref.
      Module can be specified either way, but not both.\n");
  }

  if ($user_defined->{module}) {
    $arg->{e_module_ref} = $europa_module_database{$arg->{module}};
  }



  my $mod = $arg->{e_module_ref};










  push (@result, "module ", $mod->{name}, "\n(\n");
  push (@result, join (",\n", &ei_module_get_port_names ($mod)));
  push (@result, "\n);\n");


  my @sig_list = &ei_module_get_objects_of_type ($mod, "e_signal");
  foreach $sig (sort verilog_object_order @sig_list) {
    push (@result, &ei_signal_hdl_declare ($sig, $arg->{language}));
  }


  foreach $obj (sort verilog_object_order $mod->{contents}) {
    push (@result, &ei_object_hdl_implement ($obj, $arg->{language}));
  }

  push (@result, "endmodule\n");
  return (join ("", @result));
}



"John Wilkes Booth";












