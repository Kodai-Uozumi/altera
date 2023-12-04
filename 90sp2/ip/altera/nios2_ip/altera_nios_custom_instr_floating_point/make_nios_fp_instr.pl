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


























use europa_all;
use e_custom_instruction_slave;
use strict;

my @arguments =  (@ARGV);
my $project = e_project->new(@arguments);


&make_custom_instruction($project);









sub make_custom_instruction 
{


  my $project = shift;
  my $module = $project->top();
  my $module_name = $module->name();
  my $module_ptf = $project->system_ptf()->{"MODULE $module_name"};
  my $WSA = &copy_of_hash($module_ptf->{"WIZARD_SCRIPT_ARGUMENTS"});


  &validate_custom_instr_options($WSA);
  
  my $language = $project->system_ptf()->{"WIZARD_SCRIPT_ARGUMENTS"}->{"hdl_language"};
  my $system_directory = $project->{"__system_directory"};
  my $precision = 1;
  my $reduced_operation = 0;
  my $use_divider = $WSA->{"Use_Divider"};
  my $data_width;
  my $in_port_map;
  my $out_port_map;
  my $selected_fp_module; 
  my $altfp_mult_component_name;
  my $altfp_addsub_component_name;
  my $altfp_div_component_name;
  my $file_ext;
  my $mantissa;
  my $exp;
  my $device_family = $project->system_ptf()->{"WIZARD_SCRIPT_ARGUMENTS"}->{"device_family_id"};


  if ($precision == 1) {
    $mantissa = "23";
    $exp = "8";
    $altfp_addsub_component_name = $module_name . "_addsub_single";
    $altfp_mult_component_name = $module_name . "_mult_single";
    $altfp_div_component_name = $module_name . "_div_single";
    $data_width = "32";
  } elsif ($precision == 2) {
    $mantissa = "52";
    $exp = "11";
    $altfp_addsub_component_name = $module_name . "_addsub_double";
    $altfp_mult_component_name = $module_name . "_mult_double";
    $altfp_div_component_name = $module_name . "_div_double";
    $data_width = "64";
  } else {
    print "Detected illegal precision value : $precision\n";
    ribbit "Internal error. \n";
  }

  if ($language =~ /verilog/i) {
    $file_ext = "v";
  } else {
    $file_ext = "vhd";
  }


  my $data = {

    flush_subnormal_operands => "0",
    modulename => "$module_name",
    system_directory => "$system_directory",
    precision => "$precision",
    reduced_operation => "$reduced_operation",
    use_divider => "$use_divider",
    data_width => "$data_width",
    altfp_addsub_pipeline => "8",
    altfp_mult_pipeline => "10",
    altfp_div_pipeline => "33",
    devicefamily => "$device_family",
    file_ext => "$file_ext",
    mantissa => "$mantissa",
    exponent => "$exp",
    altfp_addsub_component_name => "$altfp_addsub_component_name",
    altfp_mult_component_name => "$altfp_mult_component_name",
    altfp_div_component_name => "$altfp_div_component_name",
    device_family => "$device_family",
    language => "$language",
  };


  &make_top_level_wrapper ($data, $module);


  &generate_altfp_megafunctions ($data);


  $project->output();
  

  &combine_files($data);


  return 1; 

}









sub validate_custom_instr_options
{
  my ($WSA) = (@_);





  &validate_parameter ({hash    => $WSA,
                        name    => "ci_cycles",
                        type    => "integer",
                        default => 1,
                       });
  
  &validate_parameter ({hash    => $WSA,
                        name    => "ci_inst_type",
                        type    => "string",
                        allowed => ["variable multicycle"],
                       });
  
  &validate_parameter ({hash    => $WSA,
                        name    => "ci_instr_format",
                        type    => "string",
                        allowed => ["RR"],
                       });

  &validate_parameter ({hash    => $WSA,
                        name    => "Use_Divider",
                        type    => "integer",
                        allowed => [0,1],
                       });

}










sub make_top_level_wrapper
{
  my $data = shift; 
  my $module = shift;
  my $data_width = $data->{"data_width"};
  my $altfp_mult_component_name = $data->{"altfp_mult_component_name"};
  my $altfp_addsub_component_name = $data->{"altfp_addsub_component_name"};
  my $altfp_div_component_name = $data->{"altfp_div_component_name"};
  my $altfp_addsub_pipeline = $data->{"altfp_addsub_pipeline"};
  my $altfp_mult_pipeline = $data->{"altfp_mult_pipeline"};
  my $altfp_div_pipeline = $data->{"altfp_div_pipeline"};
  my $flush_subnormal_operands = $data->{"flush_subnormal_operands"};  

  my $altfp_addsub_countlatency;
  my $altfp_mult_countlatency;
  my $altfp_div_countlatency;
	


  $altfp_addsub_countlatency = $altfp_addsub_pipeline;
  $altfp_mult_countlatency = $altfp_mult_pipeline;
  $altfp_div_countlatency = $altfp_div_pipeline;
 	
  my $max_countlatency;
  my $counter_width;
  my $use_divider = $data->{"use_divider"};



  if ($use_divider eq "1") {
    $max_countlatency = &max($altfp_addsub_countlatency, $altfp_mult_countlatency, $altfp_div_countlatency);
  }
  else {
    $max_countlatency = &max($altfp_addsub_countlatency, $altfp_mult_countlatency);
  }


  $counter_width = &Bits_To_Encode($max_countlatency);

  my $altfp_mult_in_port_map; 

  $altfp_mult_in_port_map = {
                 dataa => "dataa_regout",
                 datab => "datab_regout",
                 clock => "clk",
                 clk_en => "clk_en",
                 aclr => "reset",
              };


  my $altfp_mult_out_port_map = {
                   result => "result_mult",
                  };



  if ($flush_subnormal_operands eq "1") {
    $module->add_contents (
      e_mux->new({
         comment => "Mux to flush subnormal dataa mantissa to zero",
         type   => "selecto",
         selecto=> "subnormal_operand_sel_dataa",
         lhs    => "dataa_muxout",
         table  => [
               0 => "23'b0",
               1 => "dataa[22:0]",
               ],
      }),
      e_mux->new({
         comment => "Mux to flush subnormal datab mantissa to zero",
         type   => "selecto",
         selecto=> "subnormal_operand_sel_datab",
         lhs    => "datab_muxout",
         table  => [
               0 => "23'b0",
               1 => "datab[22:0]",
               ],
      }),


      e_register->new({
         comment => "register the mux outputs",
         out => "dataa_regout",
         in => "{dataa[31:23], dataa_muxout}",
         clock => "clk",
         async_set => "local_reset_n",
      }),

      e_register->new({
         comment => "register the mux outputs",
         out => "datab_regout",
         in => "{datab[31:23], datab_muxout}",
         clock => "clk",
         async_set => "local_reset_n",
      }),

      e_signal->new(["dataa_exp", 8]),
      e_signal->new(["datab_exp", 8]),

      e_assign->new([dataa_exp => "dataa[30:23]"]),
      e_assign->new([datab_exp => "datab[30:23]"]),
      e_signal->new(["dataa_muxout", "23"]),
      e_signal->new(["datab_muxout", "23"]),
      e_signal->new(["dataa_regout", "$data_width"]),
      e_signal->new(["datab_regout", "$data_width"]),

      e_assign->new([subnormal_operand_sel_dataa => "|dataa_exp"]),
      e_assign->new([subnormal_operand_sel_datab => "|datab_exp"]),

    );
  } else {
  	$module->add_contents (

	      e_register->new({
	         comment => "register the input for dataa",
	         out => "dataa_regout",
	         in => "dataa",
	         clock => "clk",
	         async_set => "local_reset_n",
	      }),
	
	      e_register->new({
	         comment => "register the input for datab",
	         out => "datab_regout",
	         in => "datab",
	         clock => "clk",
	         async_set => "local_reset_n",
	      }),
	      
	      e_signal->new(["dataa_regout", "$data_width"]),
	      e_signal->new(["datab_regout", "$data_width"]),
      )
  }



  $module->add_contents (
    e_blind_instance->new ({
      name    => "the_fp_mult",
      module  => $altfp_mult_component_name,
      in_port_map => $altfp_mult_in_port_map,
      out_port_map => $altfp_mult_out_port_map,
    }),
  );

  my $altfp_addsub_in_port_map;

  $altfp_addsub_in_port_map = {
    dataa => "dataa_regout",
    datab => "datab_regout",
    clock => "clk",
    aclr => "reset",
    clk_en => "clk_en",
    add_sub => "add_sub",
  };

  
  my $altfp_addsub_out_port_map = {
    result => "result_addsub",
  };

  $module->add_contents (
    e_blind_instance->new({
      name => "the_fp_addsub",
      module => "$altfp_addsub_component_name",
      in_port_map => $altfp_addsub_in_port_map,
      out_port_map => $altfp_addsub_out_port_map,
    }),
  );

  my $altfp_div_in_port_map;

  if ($use_divider == 1) {
    $altfp_div_in_port_map = {
      dataa => "dataa_regout",
      datab => "datab_regout",
      clock => "clk",
      aclr => "reset",
      clk_en => "clk_en",
    };

    my $altfp_div_out_port_map = {
      result => "result_div",
    };

    $module->add_contents (
      e_blind_instance->new({
        name => "the_fp_div",
        module => "$altfp_div_component_name",
        in_port_map => $altfp_div_in_port_map,
        out_port_map => $altfp_div_out_port_map,
      }),
    );
  }


  $module->add_contents (
      e_port->new (["dataa",  $data_width, "in" ]),
      e_port->new (["datab",  $data_width, "in" ]),
      e_port->new (["result", $data_width, "out"]),
      e_port->new (["clk", 1, "in"]),
      e_port->new (["clk_en", 1, "in"]),
      e_port->new (["reset", 1, "in"]),
      e_port->new (["start", 1, "in"]),
      e_port->new (["done", 1, "out"]),
      e_port->new (["n", 2, "in"]),



      e_custom_instruction_slave->new ({
          name     => "s1",
          type_map => {
            result => "result",
            dataa  => "dataa",
            datab  => "datab",
            clk => "clk",
            clk_en => "clk_en",
            reset => "reset",
            start => "start",
            done => "done",
            n => "n",
          },
      }),
  );



  $module->add_contents (
      e_signal->news (["counter_out", "$counter_width"],
                      ["counter_in", "$counter_width"],
                      ["add_sub". "1"],
                      ["result_mult", "$data_width"],
                      ["result_addsub", "$data_width"],
                      ["load_data", "$counter_width"],
                      ["local_reset_n", "1"],
                     ),

      e_register->new ({
         comment => "down_counter to signal done",
         out => "counter_out",
         in => "counter_in",
         clock => "clk",
         async_set => "local_reset_n",
         async_value => "$counter_width\'d$max_countlatency",
         enable => "clk_en",
      }),

      e_mux->new
      ({
         comment => "decrement or load the counter based on start",
         type   => "selecto",
         selecto=> "start",
         lhs    => "counter_in",
         table  => [
               0 => "counter_out - 1'b1",
               1 => "load_data",
               ],
      }),


      e_assign->new ([add_sub => "n[0]"]),


      e_assign->new ([local_reset_n => "~reset"]),
      



      e_assign->new ([done => "clk_en & ~|counter_out & ~start"]),

  );





  my @load_data_hash = (
    "0" => "$altfp_mult_countlatency",
    "1" => "$altfp_addsub_countlatency",
    "2" => "$altfp_addsub_countlatency",
  );


  my @result_hash = (
    "0" => "result_mult",
    "1" => "result_addsub",
    "2" => "result_addsub",
  );


  if ($use_divider == 1) {
    push (@load_data_hash, "3" => "$altfp_div_countlatency");
    push (@result_hash, "3" => "result_div");

    $module->add_contents (
      e_signal->new (["result_div", "$data_width"]),
    );
  }
 
  $module->add_contents (
    e_mux->new
    ({
       comment => "select load value of counter based on n",
       type   => "selecto",
       selecto=> "n",
       lhs    => "load_data",
       table  => \@load_data_hash, 
    }),

    e_mux->new
    ({
       comment => "multiplex output based on n",
       type => "selecto",
       selecto => "n",
       lhs => "result",
       table => \@result_hash,
    }),
  );

}

sub generate_altfp_megafunctions
{
  my $data = shift;
  

  
  &cbx_make_mult($data);
  &cbx_make_add_sub($data);
  
  if ($data->{"use_divider"} == 1){
    &cbx_make_divider($data);
  }
  

  unlink $data->{"module_name"}.".log";
}






sub combine_files
{
  my $data = shift;
  my $sys_dir = $data->{"system_directory"};
  my $file_ext = $data->{"file_ext"};
  my $module_filename = $sys_dir ."/" . $data->{"modulename"} . ".$file_ext";
  my $altfp_addsub_component_filename = $sys_dir . "/" . $data->{"altfp_addsub_component_name"} . ".$file_ext";
  my $altfp_mult_component_filename = $sys_dir . "/" . $data->{"altfp_mult_component_name"} . ".$file_ext";
  my $altfp_div_component_filename = $sys_dir . "/" . $data->{"altfp_div_component_name"} . ".$file_ext";
  my $use_divider = $data->{"use_divider"};
  my @buffer;
  my $skip_line = 1;

  

  open (READFILE, "$module_filename") or die "\nCannot read $module_filename : $!";
  @buffer = <READFILE>;
  close (READFILE);
  

  open (WRFILE, ">$module_filename") or die "\nCannot write $module_filename : $!";
  

  open (MULTFILE, "$altfp_mult_component_filename") or die "\nCannot read $altfp_mult_component_filename : $!";

  while (<MULTFILE>) {
    if ($skip_line == 1)
    {
      if ($_ =~ m/.*Copy.*/i)
      {
         $skip_line = 0;
         print WRFILE $_;
      }
    }
    else
    {
      print WRFILE $_;
    }
  }
  close (MULTFILE);

  print WRFILE "\n";
  

  open (ADDFILE, "$altfp_addsub_component_filename") or die "\nCannot read $altfp_addsub_component_filename : $!";
  while (<ADDFILE>) {
    print WRFILE $_;
  }
  close (ADDFILE);
 
  print WRFILE "\n";


  if ($use_divider == 1) {
    open (DIVFILE, "$altfp_div_component_filename") or die "\nCannot read $altfp_div_component_filename : $!";
    while (<DIVFILE>) {
      print WRFILE $_;
    }
    close (DIVFILE);

    print WRFILE "\n";
  }

 

  print WRFILE @buffer;
  close (WRFILE);


  unlink ("$altfp_addsub_component_filename");
  unlink ("$altfp_mult_component_filename");
 
  if ($use_divider == 1) {
    unlink ("$altfp_div_component_filename");
  }

}






sub cbx_make_divider{
  my $data = shift;
  my $module_component_name = $data->{"altfp_div_component_name"};
  my $file_ext = $data->{"file_ext"};
  my $device_family = $data->{"device_family"};
  my $system_directory = $data->{"system_directory"};
  my $module_name = $data->{"module_name"};
  my $pipeline = $data->{"altfp_div_pipeline"};
  my $mantissa = $data->{"mantissa"};
  my $exp = $data->{"exponent"};
  
  $module_component_name = $module_component_name.".$file_ext";  
  
  my $command;
  $command  = qq(clearbox altfp_div );
  $command .= qq(CBX_AUTO_BLACKBOX="ON" );
  $command .= qq(CBX_SINGLE_OUTPUT_FILE="ON" );
  $command .= qq(EXCEPTION_HANDLING="NO" );
  $command .= qq(DECODER_SUPPORT="YES" );
  $command .= qq(DENORMAL_SUPPORT="NO" );
  $command .= qq(DEVICE_FAMILY=$device_family );
  $command .= qq(PIPELINE=$pipeline );
  $command .= qq(REDUCED_FUNCTIONALITY="NO" );
  $command .= qq(WIDTH_EXP=$exp );
  $command .= qq(WIDTH_MAN=$mantissa );
  $command .= qq(aclr clk_en clock dataa datab result );
  $command .= qq(CBX_OUTPUT_DIRECTORY=$system_directory );
  $command .= qq(CBX_FILE=$module_component_name);
  
  system ($command.">>$module_name.log");
}






sub cbx_make_add_sub{
  my $data = shift;
  my $module_component_name = $data->{"altfp_addsub_component_name"};
  my $file_ext = $data->{"file_ext"};
  my $device_family = $data->{"device_family"};
  my $system_directory = $data->{"system_directory"};
  my $module_name = $data->{"module_name"};
  my $pipeline = $data->{"altfp_addsub_pipeline"};
  my $mantissa = $data->{"mantissa"};
  my $exp = $data->{"exponent"};
  
  $module_component_name = $module_component_name.".$file_ext";  
  
  my $command;
  $command  = qq(clearbox altfp_add_sub );
  $command .= qq(CBX_AUTO_BLACKBOX="ON" );
  $command .= qq(CBX_SINGLE_OUTPUT_FILE="ON" );
  $command .= qq(EXCEPTION_HANDLING="NO" );
  $command .= qq(DENORMAL_SUPPORT="NO" );
  $command .= qq(DEVICE_FAMILY=$device_family );
  $command .= qq(DIRECTION="VARIABLE" );
  $command .= qq(PIPELINE=$pipeline );
  $command .= qq(REDUCED_FUNCTIONALITY="NO" );
  $command .= qq(SPEED_OPTIMIZED="YES" );
  $command .= qq(WIDTH_EXP=$exp );
  $command .= qq(WIDTH_MAN=$mantissa );
  $command .= qq(aclr add_sub clk_en clock dataa datab result );
  $command .= qq(CBX_OUTPUT_DIRECTORY=$system_directory );
  $command .= qq(CBX_FILE=$module_component_name);

  
  system ($command.">>$module_name.log");
}






sub cbx_make_mult{
  my $data = shift;
  my $module_component_name = $data->{"altfp_mult_component_name"};
  my $file_ext = $data->{"file_ext"};
  my $device_family = $data->{"device_family"};
  my $system_directory = $data->{"system_directory"};
  my $module_name = $data->{"module_name"};
  my $pipeline = $data->{"altfp_mult_pipeline"};
  my $mantissa = $data->{"mantissa"};
  my $exp = $data->{"exponent"};
  
  $module_component_name = $module_component_name.".$file_ext";  
  
  my $command;
  $command  = qq(clearbox altfp_mult );
  $command .= qq(CBX_AUTO_BLACKBOX="ON" );
  $command .= qq(CBX_SINGLE_OUTPUT_FILE="ON" );
  $command .= qq(EXCEPTION_HANDLING="NO" );
  $command .= qq(DEDICATED_MULTIPLIER_CIRCUITRY="YES" );
  $command .= qq(DENORMAL_SUPPORT="NO" );
  $command .= qq(DEVICE_FAMILY=$device_family );
  $command .= qq(PIPELINE=$pipeline );
  $command .= qq(REDUCED_FUNCTIONALITY="NO" );
  $command .= qq(WIDTH_EXP=$exp );
  $command .= qq(WIDTH_MAN=$mantissa );
  $command .= qq(aclr clk_en clock dataa datab result );
  $command .= qq(CBX_OUTPUT_DIRECTORY=$system_directory );
  $command .= qq(CBX_FILE=$module_component_name);
 
  system ($command.">>$module_name.log");

}
