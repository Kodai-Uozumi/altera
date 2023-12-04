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






















package nios_icache;
use Exporter;
@ISA = Exporter;
@EXPORT = qw(
    $icache_present
);

use europa_all;
use europa_utils;
use cpu_utils;
use cpu_file_utils;
use cpu_bit_field;
use nios_dpram;
use nios_utils;
use nios_ptf_utils;
use nios_sdp_ram;
use nios_avalon_masters;
use nios_isa;
use strict;











our $icache_present;





sub
initialize_config_constants
{
    my $Opt = shift;


    $icache_present = manditory_bool($Opt, "cache_has_icache");
}








sub 
gen_instruction_cache
{
    my $Opt = shift;

    if (!$instruction_master_present) {
        &$error("Instruction cache requires that Avalon" .
          " instruction_master be present");
    }

    my $whoami = "I-cache";

    my $fetch_npc = not_empty_scalar($Opt, "fetch_npc");
    my $D_ic_want_fill_expr = not_empty_scalar($Opt, "D_ic_want_fill");
    my $inst_invalidate = not_empty_scalar($Opt, "inst_invalidate");
    my $inst_invalidate_baddr = not_empty_scalar($Opt, "inst_invalidate_baddr");
    my $inst_crst = not_empty_scalar($Opt, "inst_crst");

    check_opt_value($Opt, "inst_ram_output_stage", "F", $whoami);
    check_opt_value($Opt, "ic_fill_stage", "D", $whoami);

    my $mmu_addr_pfn_lsb;
    if ($tlb_present) {
        $mmu_addr_pfn_lsb = manditory_int($Opt, "mmu_addr_pfn_lsb");
    }















    my $ic_bytes_per_line = manditory_int($Opt, "cache_icache_line_size");
    if ($ic_bytes_per_line != 32) {
        &$error("Number of I-Cache bytes per line must be 32 but is " .
           $ic_bytes_per_line . "\n");
    }

    if ((manditory_int($Opt, "reset_addr") % $ic_bytes_per_line) != 0) {
        my $reset_hex = sprintf("0x%08x", manditory_int($Opt, "reset_addr"));
        &$error("Reset address $reset_hex is not 32-byte aligned\n");
    }

    my $break_addr = optional_int($Opt, "break_addr"); # defaults to 0

    if (($break_addr % $ic_bytes_per_line) != 0) {
        my $break_hex = sprintf("0x%08x", $break_addr);
        &$error("Break address $break_hex is not 32-byte aligned\n");
    }

    my $ic_total_bytes = manditory_int($Opt, "cache_icache_size");


    my $ic_words_per_line = $ic_bytes_per_line >> 2;
    my $ic_num_lines = $ic_total_bytes / $ic_bytes_per_line;


    my $ic_valid_bits_per_line = $ic_words_per_line;




    my $ic_offset_field_sz = count2sz($ic_words_per_line);
    my $ic_offset_field_lsb = 0;
    my $ic_offset_field_msb = $ic_offset_field_lsb + $ic_offset_field_sz - 1;

    my $ic_line_field_sz = count2sz($ic_num_lines);
    my $ic_line_field_lsb = $ic_offset_field_msb + 1;
    my $ic_line_field_msb = $ic_line_field_lsb + $ic_line_field_sz - 1;





    my $ic_line_field_paddr_sz = $ic_line_field_sz;
    my $ic_line_field_paddr_lsb = $ic_line_field_lsb;
    my $ic_line_field_paddr_msb = $ic_line_field_msb;


    my $mmu_addr_pfn_word_lsb = $mmu_addr_pfn_lsb - 2;

    my $ic_tag_field_msb = manditory_int($Opt, "i_Address_Width") - 2 - 1;
    my $ic_tag_field_lsb = $ic_line_field_msb + 1;
    if ($tlb_present && ($ic_tag_field_lsb > $mmu_addr_pfn_word_lsb)) {

        $ic_tag_field_lsb = $mmu_addr_pfn_word_lsb;


        $ic_line_field_paddr_msb = $mmu_addr_pfn_word_lsb - 1;
        $ic_line_field_paddr_sz = 
          $ic_line_field_paddr_msb - $ic_line_field_paddr_lsb + 1;
    }
    my $ic_tag_field_sz = $ic_tag_field_msb - $ic_tag_field_lsb + 1;















    if ($ic_tag_field_sz < 1) {
        &$error("I-cache is too large relative to instruction address size");
    }



    my $ic_data_addr_sz = $ic_line_field_sz + $ic_offset_field_sz;
    my $ic_data_num_addrs = 0x1 << $ic_data_addr_sz;


    my $ic_data_data_sz = $iw_sz;


    my $ic_tag_addr_sz = $ic_line_field_sz;
    my $ic_tag_num_addrs = 0x1 << $ic_tag_addr_sz;



    my $ic_tag_data_sz = $ic_tag_field_sz + $ic_valid_bits_per_line;


    my $inst_invalidate_line = 
      $inst_invalidate_baddr . "[$ic_line_field_msb+2:$ic_line_field_lsb+2]";






    e_signal->adds(
      ["F_ic_iw", $iw_sz],
      );


    e_assign->adds(
      [["F_ic_data_rd_addr_nxt", $ic_data_addr_sz],
        $fetch_npc . "[$ic_line_field_msb:$ic_offset_field_lsb]"],
      );

    my $ram_block_type = not_empty_scalar($Opt, "cache_icache_ram_block_type");
      


    if (manditory_bool($Opt, "export_large_RAMs")) {


        e_comment->add({
          comment => 
            ("Export icache data RAM ports to top level\n" .
             "because the RAM is instantiated external to CPU.\n"),
        });
        e_assign->adds(

          [["icache_data_ram_write_data", $ic_data_data_sz], "i_readdata_d1"],
          [["icache_data_ram_write_enable", 1], "i_readdatavalid_d1"],
          [["icache_data_ram_write_address", $ic_data_addr_sz], 
            "{ic_fill_line, ic_fill_dp_offset}"],
          [["icache_data_ram_read_clk_en", 1], "F_en"],
          [["icache_data_ram_read_address", $ic_data_addr_sz], 
            "F_ic_data_rd_addr_nxt"],


          ["F_ic_iw", ["icache_data_ram_read_data", $ic_data_data_sz]],
        );
    } else {


        if (manditory_bool($Opt, "mrams_present")) {

            nios_dpram->add({
              name => $Opt->{name} . "_ic_data",
              Opt                     => $Opt,
              data_width              => $ic_data_data_sz,
              address_width           => $ic_data_addr_sz,
              num_words               => $ic_data_num_addrs,
              read_during_write_mode_mixed_ports => qq("DONT_CARE"),
              ram_block_type          => '"' . $ram_block_type . '"',
              port_map => {

                wrclock   => "clk",
                data      => "i_readdata_d1",
                wren      => "i_readdatavalid_d1",
                wraddress => "{ic_fill_line, ic_fill_dp_offset}",
        

                rdclock   => "clk",
                rdclken   => "F_en",
                rdaddress => "F_ic_data_rd_addr_nxt",
                q         => "F_ic_iw",
                },
            });
        } else {
            nios_sdp_ram->add({
              name => $Opt->{name} . "_ic_data",
              Opt                     => $Opt,
              data_width              => $ic_data_data_sz,
              address_width           => $ic_data_addr_sz,
              num_words               => $ic_data_num_addrs,
              read_during_write_mode_mixed_ports => qq("DONT_CARE"),
              ram_block_type          => '"' . $ram_block_type . '"',
              port_map => {
                clock       => "clk",
        

                data        => "i_readdata_d1",
                wren        => "i_readdatavalid_d1",
                wraddress   => "{ic_fill_line, ic_fill_dp_offset}",
        

                rden        => "F_en",
                rdaddress   => "F_ic_data_rd_addr_nxt",
                q           => "F_ic_iw",
                },
            });
        }
    }






    e_signal->adds(
      {name => "F_ic_tag_rd", never_export => 1, 
       width => $ic_tag_data_sz },
    );


    e_assign->adds(
      [["F_ic_tag_rd_addr_nxt", $ic_tag_addr_sz],
        $fetch_npc . "[$ic_line_field_msb:$ic_line_field_lsb]"],
      );


    my $ic_reset_line = 
      (manditory_int($Opt, "reset_addr") >> ($ic_line_field_lsb + 2)) & 
      ((0x1 << $ic_line_field_sz) - 1);
    my $ic_break_line = 
      ($break_addr >> ($ic_line_field_lsb + 2)) & 
      ((0x1 << $ic_line_field_sz) - 1);







    e_assign->adds(







      [["ic_tag_clr_valid_bits_nxt", 1], 
        "$inst_invalidate | D_ic_fill_starting | reset_d1"],





      [["ic_fill_valid_bits_nxt", $ic_valid_bits_per_line], 
        "ic_tag_clr_valid_bits_nxt ? 0 :
         D_ic_fill_starting_d1     ? ic_fill_valid_bit_new : 
         (ic_fill_valid_bits | ic_fill_valid_bit_new)"],




      [["ic_fill_valid_bits_en", 1], 
        "ic_tag_clr_valid_bits_nxt | D_ic_fill_starting_d1 | 
         i_readdatavalid_d1"],







      [["ic_tag_wraddress_nxt", $ic_tag_addr_sz],
        "reset_d1                ? $ic_break_line :
         $inst_crst              ? $ic_reset_line :
         $inst_invalidate        ? $inst_invalidate_line :
         D_ic_fill_starting      ? D_pc_line_field :
                                   ic_fill_line"],




      [["ic_tag_wren", 1], "ic_tag_clr_valid_bits | i_readdatavalid_d1"],


      [["ic_tag_wrdata", $ic_tag_data_sz], "{ic_fill_tag, ic_fill_valid_bits}"],
    );
      
    if (defined(optional($Opt, "break_addr"))) {
        e_register->adds(


          {out => ["reset_d1", 1],
           in => "0", 
           enable => "1",
           async_value => "1" },
        );
    } else {
        e_assign->adds(
            [["reset_d1", 1], "0"],
        );
    }

    e_register->adds(
      {out => ["ic_tag_clr_valid_bits", 1], 
       in => "ic_tag_clr_valid_bits_nxt",             
       enable => "1'b1", 
       async_value => "1"},




      {out => ["ic_fill_valid_bits", $ic_valid_bits_per_line],
       in => "ic_fill_valid_bits_nxt", 
       enable => "ic_fill_valid_bits_en",
       async_value => "0"},






      {out => ["ic_tag_wraddress", $ic_tag_addr_sz], 
       in => "ic_tag_wraddress_nxt",        
       enable => "1'b1",
       async_value => "$ic_reset_line"},
    );

    my $ic_tag_ram_fname = $Opt->{name} . "_ic_tag_ram";



    if (manditory_bool($Opt, "export_large_RAMs")) {


        e_comment->add({
          comment => 
            ("Export icache tag RAM ports to top level\n" .
             "because the RAM is instantiated external to CPU.\n"),
        });
        e_assign->adds(

          [["icache_tag_ram_write_data", $ic_tag_data_sz], "ic_tag_wrdata"],
          [["icache_tag_ram_write_enable", 1], "ic_tag_wren"],
          [["icache_tag_ram_write_address", $ic_tag_addr_sz], 
            "ic_tag_wraddress"],
          [["icache_tag_ram_read_clk_en", 1], "F_en"],
          [["icache_tag_ram_read_address", $ic_tag_addr_sz], 
            "F_ic_tag_rd_addr_nxt"],


          ["F_ic_tag_rd", ["icache_tag_ram_read_data", $ic_tag_data_sz]],
        );
    } else {
        nios_sdp_ram->add({
          name => $Opt->{name} . "_ic_tag",
          Opt                     => $Opt,
          data_width              => $ic_tag_data_sz,
          address_width           => $ic_tag_addr_sz,
          num_words               => $ic_tag_num_addrs,
          contents_file           => $ic_tag_ram_fname,
          read_during_write_mode_mixed_ports => qq("OLD_DATA"),
          port_map => {
            clock     => "clk",
    

            wren      => "ic_tag_wren",
            data      => "ic_tag_wrdata",
            wraddress => "ic_tag_wraddress",
    

            rden      => "F_en",
            rdaddress => "F_ic_tag_rd_addr_nxt",
            q         => "F_ic_tag_rd",
            },
        });
    }


    e_assign->adds(
      [["F_ic_tag_field", $ic_tag_field_sz],
        "F_ic_tag_rd[$ic_tag_data_sz-1:$ic_valid_bits_per_line]"],
      [["F_ic_valid_bits", $ic_valid_bits_per_line],
        "F_ic_tag_rd[$ic_valid_bits_per_line-1:0]"],
      );

    make_contents_file_for_ram({
      filename_no_suffix        => $ic_tag_ram_fname,
      data_sz                   => $ic_tag_data_sz,
      num_entries               => $ic_tag_num_addrs, 
      value_str                 => "random",
      clear_hdl_sim_contents    => 
        manditory_bool($Opt, "hdl_sim_caches_cleared"),
      do_build_sim              => manditory_bool($Opt, "do_build_sim"),
      system_directory          => not_empty_scalar($Opt, "system_directory"),
      simulation_directory      => 
        not_empty_scalar($Opt, "simulation_directory"),
    });





    if ($tlb_present) {


        e_register->adds(
          {out => ["D_ic_desired_tag", $ic_tag_field_sz], 
           in => "F_ic_desired_tag", enable => "D_en"},
        );


    e_assign->adds(
          [["F_ic_desired_tag", $ic_tag_field_sz],
            "F_pc_phy[$ic_tag_field_msb:$ic_tag_field_lsb]"],
        );      
    } else {

        e_assign->adds(
      [["F_ic_desired_tag", $ic_tag_field_sz],
        "F_pc[$ic_tag_field_msb:$ic_tag_field_lsb]"],
    );      
    }




    e_mux->add ({
      lhs => ["F_ic_valid", 1],
      selecto => "F_pc[$ic_offset_field_msb:$ic_offset_field_lsb]",
      table => [
        "3'd0" => "F_ic_valid_bits[0]",
        "3'd1" => "F_ic_valid_bits[1]",
        "3'd2" => "F_ic_valid_bits[2]",
        "3'd3" => "F_ic_valid_bits[3]",
        "3'd4" => "F_ic_valid_bits[4]",
        "3'd5" => "F_ic_valid_bits[5]",
        "3'd6" => "F_ic_valid_bits[6]",
        "3'd7" => "F_ic_valid_bits[7]",
        ],
      });






    if ($tlb_present) {
        e_assign->adds(
          [["F_ic_hit", 1], 
            "F_pc_phy_got_pfn & 
              ((F_ic_valid & (F_ic_desired_tag == F_ic_tag_field)) | 
               (~F_pc_bypass_tlb & F_uitlb_m))"],
        );
    } else {
    e_assign->adds(
      [["F_ic_hit", 1], 
        "F_ic_valid & (F_ic_desired_tag == F_ic_tag_field)"],
    );
    }






    e_assign->adds(
      [["F_pc_tag_field", $ic_tag_field_sz], 
        $mmu_present ? 
          "F_ic_desired_tag" :
          "F_pc[$ic_tag_field_msb:$ic_tag_field_lsb]"], 

      [["F_pc_line_field", $ic_line_field_sz], 
        "F_pc[$ic_line_field_msb:$ic_line_field_lsb]"], 

      [["D_pc_tag_field", $ic_tag_field_sz], 
        $mmu_present ? 
          "D_ic_desired_tag" :
          "D_pc[$ic_tag_field_msb:$ic_tag_field_lsb]"], 

      [["D_pc_line_field", $ic_line_field_sz], 
        "D_pc[$ic_line_field_msb:$ic_line_field_lsb]"], 
      [["D_pc_offset_field", $ic_offset_field_sz], 
        "D_pc[$ic_offset_field_msb:$ic_offset_field_lsb]"], 
    );


























    if (manditory_bool($Opt, "asic_enabled")) {
        e_assign->adds(
          [["D_ic_want_fill_unfiltered", 1], "D_ic_want_fill"],
        );
    } else {
        create_x_filter({
          lhs       => "D_ic_want_fill",
          rhs       => "D_ic_want_fill_unfiltered",
          sz        => 1,
        });
    }

    e_assign->adds(

      [["D_ic_want_fill_unfiltered", 1], $D_ic_want_fill_expr],









      [["ic_fill_prevent_refill_nxt", 1], 
        "D_ic_fill_starting | (ic_fill_prevent_refill & ~$inst_invalidate)"],







      [["F_ic_fill_same_tag_line", 1], 
        "(F_pc_tag_field == ic_fill_tag) & (F_pc_line_field == ic_fill_line)"],




      [["D_ic_fill_ignore", 1], 
        "ic_fill_prevent_refill & D_ic_fill_same_tag_line"],



      [["D_ic_fill_starting", 1], 
        "~ic_fill_active & D_ic_want_fill & ~D_ic_fill_ignore"],


      [["ic_fill_done", 1], "ic_fill_dp_last_word & i_readdatavalid_d1"],



      [["ic_fill_active_nxt", 1], 
        "D_ic_fill_starting | (ic_fill_active & ~ic_fill_done)"],


      [["ic_fill_dp_last_word", 1], 
        "ic_fill_dp_offset_nxt == ic_fill_initial_offset"],



      [["ic_fill_dp_offset_en", 1], 
        "D_ic_fill_starting_d1 | i_readdatavalid_d1"],
      );

    if ($imaster_bursts && 
      (not_empty_scalar($Opt, "cache_icache_burst_type") eq "interleaved")) {

        e_assign->adds(





          [["ic_fill_dp_offset_nxt", $ic_offset_field_sz], 
            "D_ic_fill_starting_d1 ? 
               ic_fill_initial_offset : 
               (ic_fill_dp_index ^ ic_fill_initial_offset)"],



          [["ic_fill_dp_index_nxt", $ic_offset_field_sz], 
            "D_ic_fill_starting_d1 ? 1 : ic_fill_dp_index + 1"],
        );

        e_register->adds(

          {out => ["ic_fill_dp_index", $ic_offset_field_sz], 
           in => "ic_fill_dp_index_nxt", 
           enable => "D_ic_fill_starting_d1 | i_readdatavalid_d1"},
        );
    } else {

        e_assign->adds(




          [["ic_fill_dp_offset_nxt", $ic_offset_field_sz], 
            "D_ic_fill_starting_d1 ? 
               ic_fill_initial_offset : 
               (ic_fill_dp_offset + 1)"],
        );
    }

    my $instruction_master_baddr_sz = 
      manditory_int($Opt->{instruction_master}, "Address_Width");

    if ($imaster_bursts) {
        my $burst_words = manditory_int($Opt, "cache_icache_line_size") / 4;
    
        e_assign->adds(

          [["i_read_nxt", 1],
            "D_ic_fill_starting | (i_read & i_waitrequest)"],
    



          [["i_address", $instruction_master_baddr_sz],
            "{ic_fill_tag, 
              ic_fill_line[$ic_line_field_paddr_sz-1:0],
              ic_fill_initial_offset, 
              2'b00}"],
    
          [["i_burstcount", $imaster_burstcount_sz], "$burst_words"],
        );
    } else {

        e_assign->adds(




          [["ic_fill_ap_offset_nxt", $ic_offset_field_sz], 
            "ic_fill_req_accepted ? (ic_fill_ap_offset + 1) :
             D_ic_fill_starting   ? D_pc_offset_field :
                                    ic_fill_ap_offset"],







          [["ic_fill_ap_cnt_nxt", $ic_offset_field_sz+1], 
            "ic_fill_req_accepted ? (ic_fill_ap_cnt + 1) :
             D_ic_fill_starting   ? 1 :
                                    ic_fill_ap_cnt"],
    


          [["ic_fill_ap_last_word", 1], "ic_fill_ap_cnt[$ic_offset_field_sz]"],


          [["ic_fill_req_accepted", 1], "i_read & ~i_waitrequest"],



          [["i_read_nxt", 1],
            "D_ic_fill_starting | 
             (i_read & (i_waitrequest | ~ic_fill_ap_last_word))"],
    



          [["i_address", $instruction_master_baddr_sz],
            "{ic_fill_tag, 
              ic_fill_line[$ic_line_field_paddr_sz-1:0],
              ic_fill_ap_offset, 
              2'b00}"],

        );

        e_register->adds(
          {out => ["ic_fill_ap_offset", $ic_offset_field_sz], 
           in => "ic_fill_ap_offset_nxt",       enable => "1'b1"},

          {out => ["ic_fill_ap_cnt", ($ic_offset_field_sz+1)], 
           in => "ic_fill_ap_cnt_nxt",          enable => "1'b1"},
        );
    }



    e_mux->add ({
      lhs => ["ic_fill_valid_bit_new", $ic_valid_bits_per_line],
      selecto => "ic_fill_dp_offset_nxt",
      table => [
        "3'd0" => "8'b00000001",
        "3'd1" => "8'b00000010",
        "3'd2" => "8'b00000100",
        "3'd3" => "8'b00001000",
        "3'd4" => "8'b00010000",
        "3'd5" => "8'b00100000",
        "3'd6" => "8'b01000000",
        "3'd7" => "8'b10000000",
        ],
      });

    e_register->adds(
      {out => ["D_ic_fill_starting_d1", 1],             
       in => "D_ic_fill_starting",                  enable => "1'b1"},
      {out => ["D_ic_fill_same_tag_line", 1],             
       in => "F_ic_fill_same_tag_line",             enable => "D_en"},
      {out => ["ic_fill_active", 1],             
       in => "ic_fill_active_nxt",                  enable => "1'b1"},
      {out => ["ic_fill_prevent_refill", 1],             
       in => "ic_fill_prevent_refill_nxt",          enable => "1'b1"},



      {out => ["ic_fill_tag", $ic_tag_field_sz],
       in => "D_pc_tag_field", 
       enable => "D_ic_fill_starting"},
      {out => ["ic_fill_line", $ic_line_field_sz],
       in => "D_pc_line_field", 
       enable => "D_ic_fill_starting"},
      {out => ["ic_fill_initial_offset", $ic_offset_field_sz], 
       in => "D_pc_offset_field", 
       enable => "D_ic_fill_starting"},

      {out => ["ic_fill_dp_offset", $ic_offset_field_sz], 
       in => "ic_fill_dp_offset_nxt", 
       enable => "ic_fill_dp_offset_en"},
    );


    my @icache = (
        { divider => "icache" },
        { radix => "x", signal => "$fetch_npc" },
        { radix => "x", signal => "F_ic_data_rd_addr_nxt" },
        { radix => "x", signal => "F_ic_tag_rd_addr_nxt" },
        { radix => "x", signal => "F_iw" },
        { radix => "x", signal => "F_ic_tag_field" },
        { radix => "x", signal => "F_ic_valid" },
        { radix => "x", signal => "F_ic_desired_tag" },
        { radix => "x", signal => "F_ic_valid" },
        { radix => "x", signal => "F_inst_ram_hit" },
        { radix => "x", signal => "F_issue" },
        $mmu_present ? { radix => "x", signal => "D_ic_desired_tag" } : "",
        { radix => "x", signal => "D_pc_tag_field" },
        { radix => "x", signal => "D_pc_line_field" },
        { radix => "x", signal => "D_pc_offset_field" },
        { radix => "x", signal => "ic_tag_wren" },
        { radix => "x", signal => "ic_tag_wrdata" },
        { radix => "x", signal => "ic_tag_wraddress" },
        { radix => "x", signal => "ic_fill_valid_bit_new" },
        { radix => "x", signal => "ic_fill_valid_bits_nxt" },
        { radix => "x", signal => "ic_fill_valid_bits" },
        { radix => "x", signal => "F_ic_fill_same_tag_line" },
        { radix => "x", signal => "D_ic_fill_same_tag_line" },
        { radix => "x", signal => "D_ic_want_fill" },
        { radix => "x", signal => "D_ic_fill_ignore" },
        { radix => "x", signal => "D_ic_fill_starting" },
        { radix => "x", signal => "D_ic_fill_starting_d1" },
        { radix => "x", signal => "ic_fill_prevent_refill" },
        { radix => "x", signal => "ic_fill_done" },
        { radix => "x", signal => "ic_fill_active" },
        { radix => "x", signal => "ic_fill_tag" },
        { radix => "x", signal => "ic_fill_line" },
        { radix => "x", signal => "ic_fill_initial_offset" },
        { radix => "x", signal => "ic_fill_dp_offset" },
        { radix => "x", signal => "ic_fill_dp_offset_nxt" },
        { radix => "x", signal => "ic_fill_dp_offset_en" },
        { radix => "x", signal => "ic_fill_dp_last_word" },
        $imaster_bursts ? "" : {radix => "x", signal => "ic_fill_req_accepted"},
        $imaster_bursts ? "" : {radix => "x", signal => "ic_fill_ap_offset"},
        $imaster_bursts ? "" : {radix => "x", signal => "ic_fill_ap_last_word"},
      );

    if ($Opt->{full_waveform_signals}) {
        push(@plaintext_wave_signals, @icache);
    }
}

1;
