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






















package nios_div;
use Exporter;
@ISA = Exporter;
@EXPORT = qw(
    $hw_div
);

use cpu_utils;
use nios_europa;
use nios_ptf_utils;
use nios_isa;
use europa_all;
use europa_utils;
use strict;





our $hw_div;





sub 
initialize_config_constants
{
    my $divide_info = shift;


    $hw_div = manditory_bool($divide_info, "hardware_divide_present");
}








sub 
gen_div
{
    my $Opt = shift;

    if (!$hw_div) {
        &$error("Called when hw_div is false");
    }

    my $whoami = "hardware divide";

    my $is = check_opt_value($Opt, "non_pipelined_long_latency_input_stage",
      ["E", "M"], $whoami);
    my $os = not_empty_scalar($Opt, "long_latency_output_stage");
    my $div_done = not_empty_scalar($Opt, "div_done");






    my $div_norm_cnt_sz = $datapath_log2_sz + 1;
    my $div_norm_cnt_lsb = 0;
    my $div_norm_cnt_msb = $div_norm_cnt_lsb + $div_norm_cnt_sz - 1;



    e_assign->adds(
      [["E_div_negate_src1", 1], 
        "E_ctrl_div_signed & E_src1[$datapath_msb]"],

      [["E_div_negate_src2", 1], 
        "E_ctrl_div_signed & E_src2[$datapath_msb]"],

      [["E_div_negate_result", 1], 
        "E_div_negate_src1 ^ E_div_negate_src2"],

      [["E_div_src1", $datapath_sz], 
        "E_div_negate_src1 ? -E_src1 : E_src1"],

      [["E_div_src2", $datapath_sz], 
        "E_div_negate_src2 ? -E_src2 : E_src2"],
      );



    e_register->adds(
      {out => ["M_div_negate_result", 1],         
       in => "E_div_negate_result", enable => "M_en"},
    );

    if ($os ne "M") {


        e_register->adds(
          {out => ["${os}_div_negate_result", 1],         
           in => "M_div_negate_result", enable => "${os}_en"},
        );
    }

    if ($is eq "M") {

        e_register->adds(
          {out => ["M_div_src1", $datapath_sz], in => "E_div_src1", 
           enable => "M_en"},
          {out => ["M_div_src2", $datapath_sz], in => "E_div_src2", 
           enable => "M_en"},
        );



        e_assign->adds(
          [["M_src1", $datapath_sz, 0, $force_never_export], "M_div_src1"],
          [["M_src2", $datapath_sz, 0, $force_never_export], "M_div_src2"],
        );
    }





    e_assign->adds(






      [["${os}_div_rem_den_sum_diff", $datapath_sz+1], "${os}_div_do_sub ?
         ${os}_div_rem - {1'b0, ${os}_div_den} :
         ${os}_div_rem + {1'b0, ${os}_div_den}"],


      [["${os}_div_rem_sign_bit", 1], 
        "${os}_div_rem_den_sum_diff[$datapath_msb+1]"],





      [["${os}_div_quot_bit_nxt", 1], 
        "~${os}_div_rem_den_sum_diff[$datapath_msb+1]"],
























      [["${os}_div_den_is_normalized", 1],
        "${os}_div_den_is_normalized_sticky |
         (${os}_div_norm_cnt[$div_norm_cnt_msb] |
          ${os}_div_den[$datapath_msb] |
          ${os}_div_rem_sign_bit)"],




      [["${os}_div_discover_quotient_bits", 1],
          "${os}_div_den_is_normalized"],




      [["${os}_div_last_quotient_bit_nxt", 1], 
        "${os}_div_den_is_normalized & (${os}_div_norm_cnt == 1)"],



      [["${os}_div_norm_cnt_nxt", $div_norm_cnt_sz], 
        "${os}_en ? 1 : 
          (${os}_div_den_is_normalized ? 
            ${os}_div_norm_cnt-1 : 
            ${os}_div_norm_cnt+1)"],






      [["${os}_div_rem_nxt", $datapath_sz+1],         
        "${os}_en ? 
           {1'b0, ${is}_div_src1} : 
           {${os}_div_rem_den_sum_diff[$datapath_msb:0], 1'b0}"],
      [["${os}_div_rem_en", 1],         
        "${os}_en | ${os}_div_discover_quotient_bits"],






      [["${os}_div_den_nxt", $datapath_sz],         
        "${os}_en ? ${is}_div_src2 : {${os}_div_den[$datapath_msb-1:0], 1'b0}"],
      [["${os}_div_den_en", 1],         
        "${os}_en | ~${os}_div_den_is_normalized"],















      [["${os}_div_quot_shifted", $datapath_sz],
         "{${os}_div_quot[$datapath_msb-1:0], 
           ${os}_div_quot_bit ^ ${os}_div_negate_result}"],
      [["${os}_div_quot_hot1", 1],
          "${os}_div_negate_result & ${os}_div_last_quotient_bit"],
      [["${os}_div_quot_nxt", $datapath_sz],         
        "${os}_en ? 
          {${datapath_sz}\{${is}_div_negate_result}} : 
          (${os}_div_quot_shifted + ${os}_div_quot_hot1)"],

      [["${os}_div_quot_en", 1],         
        "${os}_en | ${os}_div_accumulate_quotient_bits"],




      [["${os}_div_stall", 1], 
        "${os}_ctrl_div & ${os}_valid & ~${div_done}"], 
    );

    e_register->adds(
      {out => ["${os}_div_den", $datapath_sz],   in => "${os}_div_den_nxt", 
       enable => "${os}_div_den_en"},

      {out => ["${os}_div_rem", $datapath_sz+1], in => "${os}_div_rem_nxt",
       enable => "${os}_div_rem_en"},

      {out => ["${os}_div_quot", $datapath_sz], 
       in => "${os}_div_quot_nxt", enable => "${os}_div_quot_en"},

      {out => ["${os}_div_accumulate_quotient_bits", 1], 
       in => "${os}_en ? 1'b0 : ${os}_div_discover_quotient_bits", 
       enable => "1'b1"},

      {out => ["${os}_div_quot_bit", 1], 
       in => "${os}_div_quot_bit_nxt", enable => "1'b1"},

      {out => ["${os}_div_last_quotient_bit", 1], 
       in => "${os}_en ? 1'b0 : ${os}_div_last_quotient_bit_nxt", 
       enable => "1'b1"},


      {out => ["${os}_div_quot_ready", 1], 
       in => "${os}_en ? 1'b0 : ${os}_div_last_quotient_bit", enable => "1'b1"},





      {out => ["${os}_div_den_is_normalized_sticky", 1], 
       in => "${os}_en ? 1'b0 : ${os}_div_den_is_normalized", enable => "1'b1"},




      {out => ["${os}_div_norm_cnt", $div_norm_cnt_sz],
       in => "${os}_div_norm_cnt_nxt", enable => "1'b1"},















      {out => ["${os}_div_do_sub", 1], 
       in => "${os}_en ? 1'b1 : ~${os}_div_rem_sign_bit", enable => "1'b1"},
      );

    my @div = (
        { divider => "div" },
        { radix => "x", signal => "E_div_negate_src1" },
        { radix => "x", signal => "E_div_negate_src2" },
        { radix => "x", signal => "E_div_negate_result" },
        { radix => "x", signal => "${is}_ctrl_div" },
        { radix => "x", signal => "${is}_div_src1" },
        { radix => "x", signal => "${is}_div_src2" },
        { radix => "x", signal => "${is}_div_negate_result" },
        { radix => "a", signal => "${os}_vinst" },
        { radix => "x", signal => "${os}_pcb" },
        { radix => "x", signal => "${os}_ctrl_div" },
        { radix => "x", signal => "${os}_div_stall" },
        { radix => "x", signal => "${os}_div_rem_den_sum_diff" },
        { radix => "x", signal => "${os}_div_rem_sign_bit" },
        { radix => "x", signal => "${os}_div_quot_bit_nxt" },
        { radix => "x", signal => "${os}_div_den_is_normalized" },
        { radix => "x", signal => "${os}_div_accumulate_quotient_bits" },
        { radix => "x", signal => "${os}_div_discover_quotient_bits" },
        { radix => "x", signal => "${os}_div_last_quotient_bit" },
        { radix => "x", signal => "${os}_div_norm_cnt_nxt" },
        { radix => "x", signal => "${os}_div_rem_nxt" },
        { radix => "x", signal => "${os}_div_rem_en" },
        { radix => "x", signal => "${os}_div_den_nxt" },
        { radix => "x", signal => "${os}_div_den_en" },
        { radix => "x", signal => "${os}_div_quot_bit" },
        { radix => "x", signal => "${os}_div_quot_shifted" },
        { radix => "x", signal => "${os}_div_quot_hot1" },
        { radix => "x", signal => "${os}_div_quot_nxt" },
        { radix => "x", signal => "${os}_div_quot_en" },
        { radix => "x", signal => "${os}_div_den" },
        { radix => "x", signal => "${os}_div_rem" },
        { radix => "x", signal => "${os}_div_quot" },
        { radix => "x", signal => "${os}_div_norm_cnt" },
        { radix => "x", signal => "${os}_div_den_is_normalized_sticky" },
        { radix => "x", signal => "${os}_div_do_sub" },
        { radix => "x", signal => "${os}_div_quot_ready" },
        { radix => "x", signal => "$div_done" },
    );

    if ($Opt->{full_waveform_signals}) {
        push(@plaintext_wave_signals, @div);
    }
}

1;
