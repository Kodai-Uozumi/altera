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






















use cpu_utils;
use nios_tdp_ram;
use nios2_insts;
use nios2_control_regs;
use europa_all;
use format_conversion_utils;  # needed for fcu_convert
use filename_utils;           # needed for Perlcopy 
use strict;

sub make_nios2_ocimem
{
  my $Opt = shift;

  my $module = e_module->new ({
      name    => $Opt->{name}."_nios2_ocimem",
  });



  $module->add_contents (

    e_signal->news (
      ["oci_ram_readdata",      32,   1],
      ["MonDReg",               32,   1],
    ),

    e_signal->news (
      ["address",               9,    0],
      ["writedata",             32,   0],
      ["byteenable",            4,    0],
      ["ir",            $IR_WIDTH,    0],
      ["jdo",           $SR_WIDTH,    0],
      ["reset",                 1,    0],
      ["resetrequest",          1,    0],
    ),



    e_signal->news (
      ["MonAReg",               11,   0],  # low 2 bits will be optimzed out
    ),
    
  );

  my $cfgdout_table = make_nios2_ociram_contents($Opt);






  if (manditory_bool($Opt, "export_large_RAMs")) {
    $module->add_contents (
      e_assign->new (["avalon" => "begintransfer & ~resetrequest"]),
  
      e_process->new ({
        clock     => "clk",
        reset     => "jrst_n",
        asynchronous_contents => [
          e_assign->news (
            ["MonWr" => "1'b0"],
            ["MonRd" => "1'b0"],
            ["MonRd1" => "1'b0"],
            ["MonAReg" => "0"],
            ["MonDReg" => "0"],
          ),
        ],
        contents  => [
          e_if->new ({
            condition => "take_no_action_ocimem_a",
            then      => [ 
              ["MonAReg[10:2]" => "MonAReg[10:2]+1"],       # preincrement
              ["MonRd" => "1'b1"],                          # request read
            ],
            else      => [
              e_if->new ({
                condition => "take_action_ocimem_a",
                then      => [ 
                  ["MonAReg[10:2]" =>
                    "{ jdo[$OCIMEM_A_ADDR_A10_POS],
                       jdo[$OCIMEM_A_ADDR_A9_POS:$OCIMEM_A_ADDR_A2_POS] }"],
                  ["MonRd" => "1'b1"],                          # request read
                ],
                else      => [
                  e_if->new ({
                    condition => "take_action_ocimem_b",
                    then      => [
                      ["MonAReg[10:2]" => "MonAReg[10:2]+1"], # preincrement
                      ["MonDReg" =>
                        "jdo[$OCIMEM_B_WRDATA_MSB_POS:$OCIMEM_B_WRDATA_LSB_POS]"],
                      ["MonWr" => "1'b1"],                  # request write
                    ],
                    else      => [
                      e_if->new ({
                        condition => "~avalon",
                        then      => [ 
                            ["MonWr" => "0"],
                            ["MonRd" => "0"],
                        ],
                      }),
                      e_if->new ({
                        condition => "MonRd1",
                        then      => [ 
                          e_assign->new (
                            ["MonDReg" => "MonAReg[10] ? cfgdout : sramdout"]
                          ),
                        ],
                      }),
                    ], # end else
                  }),
                ],  # end else
              }),
            ],  # end else
          }),
          e_assign->new (["MonRd1" => "MonRd"]),
        ], # end sync contents
      }), # end e_process
  
      e_comment->new({
        comment => 
           ("Export OCI RAM ports to top level\n" .
            "because the RAM is instantiated external to CPU.\n"),
      }),
      e_assign->news (

        [["cpu_lpm_oci_ram_bdp_address_a", 8] => "address[7 : 0]"],
        [["cpu_lpm_oci_ram_bdp_address_b", 8] => "MonAReg[9 : 2]"],
        [["cpu_lpm_oci_ram_bdp_byte_enable_a", 4] => "byteenable"],
        ["cpu_lpm_oci_ram_bdp_clk_en_0" => "1'b1"],
        ["cpu_lpm_oci_ram_bdp_clk_en_1" => "1'b1"],
        [["cpu_lpm_oci_ram_bdp_write_data_a", 32] => "writedata"],
        [["cpu_lpm_oci_ram_bdp_write_data_b", 32] => "MonDReg[31 : 0]"],
        ["cpu_lpm_oci_ram_bdp_write_enable_a" => "chipselect & write & debugaccess & ~address[8]"],
        ["cpu_lpm_oci_ram_bdp_write_enable_b" => "MonWr"],
  

        ["oci_ram_readdata" => ["cpu_lpm_oci_ram_bdp_read_data_a", 32]],
        [["sramdout",32] => ["cpu_lpm_oci_ram_bdp_read_data_b", 32]],
      ),
  
      e_mux->new ({
        lhs => ["cfgdout", 32],
        selecto => "MonAReg[4:2]",
        table => $cfgdout_table,
      }),
  
    );  # end of add_contents
  } else {
    $module->add_contents (
      e_assign->new (["avalon" => "begintransfer & ~resetrequest"]),
  





      e_process->new ({
        clock     => "clk",
        reset     => "jrst_n",
        user_attributes_names => ["MonDReg, MonAReg, MonRd1, MonRd, MonWr"],
        user_attributes => [
          {
            attribute_name => 'SUPPRESS_DA_RULE_INTERNAL',
            attribute_operator => '=',
            attribute_values => [qw(D101 D103 R101)],
          },
        ],
        asynchronous_contents => [
          e_assign->news (
            ["MonWr" => "1'b0"],
            ["MonRd" => "1'b0"],
            ["MonRd1" => "1'b0"],
            ["MonAReg" => "0"],
            ["MonDReg" => "0"],
          ),
        ],
        contents  => [
          e_if->new ({
            condition => "take_no_action_ocimem_a",
            then      => [ 
              ["MonAReg[10:2]" => "MonAReg[10:2]+1"],       # preincrement
              ["MonRd" => "1'b1"],                          # request read
            ],
            else      => [
              e_if->new ({
                condition => "take_action_ocimem_a",
                then      => [ 
                  ["MonAReg[10:2]" =>
                    "{ jdo[$OCIMEM_A_ADDR_A10_POS],
                       jdo[$OCIMEM_A_ADDR_A9_POS:$OCIMEM_A_ADDR_A2_POS] }"],
                  ["MonRd" => "1'b1"],                          # request read
                ],
                else      => [
                  e_if->new ({
                    condition => "take_action_ocimem_b",
                    then      => [
                      ["MonAReg[10:2]" => "MonAReg[10:2]+1"], # preincrement
                      ["MonDReg" =>
                        "jdo[$OCIMEM_B_WRDATA_MSB_POS:$OCIMEM_B_WRDATA_LSB_POS]"],
                      ["MonWr" => "1'b1"],                  # request write
                    ],
                    else      => [
                      e_if->new ({
                        condition => "~avalon",
                        then      => [ 
                            ["MonWr" => "0"],
                            ["MonRd" => "0"],
                        ],
                      }),
                      e_if->new ({
                        condition => "MonRd1",
                        then      => [ 
                          e_assign->new (
                            ["MonDReg" => "MonAReg[10] ? cfgdout : sramdout"]
                          ),
                        ],
                      }),
                    ], # end else
                  }),
                ],  # end else
              }),
            ],  # end else
          }),
          e_assign->new (["MonRd1" => "MonRd"]),
        ], # end sync contents
      }), # end e_process
  













      nios_tdp_ram->new ({
        name => $Opt->{name} . "_ociram_lpm_dram_bdp_component",
        Opt                     => $Opt,
        read_latency            => 1,
        a_data_width            => 32,
        a_address_width         => 8,
        b_data_width            => 32,
        b_address_width         => 8,
        a_num_words             => 256, 
        b_num_words             => 256,
        contents_file           => $Opt->{name}."_ociram_default_contents",
        implement_as_esb        => 1,
        write_pass_through      => 0,
        intended_device_family  => '"'. $Opt->{device_family} .'"',
  
        port_map => {

          clock0    => "clk",
          clocken0  => "1'b1",
          wren_a    => "(chipselect & write & debugaccess & 
                         ~address[8] 
                         )",


          address_a => "address[7:0]",
          data_a    => "writedata",
          q_a       => "oci_ram_readdata",
          byteena_a => "byteenable",
  


          clock1    => "clk",
          clocken1  => "1'b1",
          wren_b    => "MonWr",
          address_b => "MonAReg[9:2]",
          data_b    => "MonDReg[31:0]",
          q_b       => "sramdout",
  
        },
      }),
  
      e_mux->new ({
        lhs => ["cfgdout", 32],
        selecto => "MonAReg[4:2]",
        table => $cfgdout_table,
      }),
  
    );  # end of add_contents
  }

  return $module;
}

sub make_nios2_ociram_contents
{
  my $Opt = shift;

  my $system_path = $Opt->{system_directory};
  my $library_path = $Opt->{module_lib_directory};
  my $sim_path     = $Opt->{simulation_directory};
  my $cpu_name     = $Opt->{name};
    
  my $switches	= {
		width	=> 32,
		lanes	=> 1,
		lane	=> 0,
		info	=> "made at Generate time\n",
		address_low   => 0,
		address_high  => 0x3ff,
	};


  my $sourceFile = &fcu_read_file($library_path."/ociram_default_contents.mif");
  my $bytes_ref = &fcu_text_to_hash( $sourceFile, "mif", 32);

  my $mmu = $Opt->{mmu_present};
  my $mpu = $Opt->{mpu_present};
  my $onchip_trace = $Opt->{oci_onchip_trace};




  $$bytes_ref{0x0} = ($Opt->{general_exception_addr} >> 0 ) & 0xff;
  $$bytes_ref{0x1} = ($Opt->{general_exception_addr} >> 8 ) & 0xff;
  $$bytes_ref{0x2} = ($Opt->{general_exception_addr} >> 16) & 0xff;
  $$bytes_ref{0x3} = ($Opt->{general_exception_addr} >> 24) & 0xff;

  $$bytes_ref{0x4} = $Opt->{i_Address_Width};          # instr master width
  $$bytes_ref{0x5} = $Opt->{d_Address_Width};          # data master width
  $$bytes_ref{0x6} = $Opt->{oci_num_dbrk};             # number of dbrks
  $$bytes_ref{0x7} = $Opt->{oci_num_xbrk};             # number of xbrks

  $$bytes_ref{0x8} = $Opt->{oci_dbrk_trace};           # dbrk start trace?
  $$bytes_ref{0x9} = $Opt->{oci_dbrk_pairs};           # dbrk support pairs?
  $$bytes_ref{0xa} = #  width --v        v--- bit offset
    (($Opt->{oci_data_trace}  & 0x01    ) << 0) | # OCI have data trace?
    (($Opt->{big_endian}                ) << 1) | # big endian processor?
    ((defined($cpuid_reg)               ) << 2) | # CPUID register present?
    (($mmu                              ) << 3) | # MMU present?
    (($mpu                              ) << 4) | # MPU present?
    (($mpu ? $Opt->{mpu_use_limit} : 0  ) << 5) | # MPU uses LIMIT (not MASK)
    (($Opt->{extra_exc_info}            ) << 6);  # EXCEPTION/BADADDR present?
  $$bytes_ref{0xb} = $Opt->{oci_offchip_trace} ;  # have offchip trace?

  $$bytes_ref{0xc} = 
    (                            
      $onchip_trace ? $Opt->{oci_trace_addr_width} :    # Log2 num bytes
                      0
    ) & 0xff;   
  $$bytes_ref{0xd} = 
    (((
      $mpu ? ($Opt->{mpu_num_inst_regions}-1) : # 1-32 regions (coded 0-31)
             0
      ) & 0x1f ) << 3);
  $$bytes_ref{0xe} = 
    (((
      $mmu ? $Opt->{tlb_ptr_sz} :               # width of tlb addr (log2)
      $mpu ? ($Opt->{mpu_min_inst_region_size_log2}-5) : # 6-20 (coded 1-15)
             0
      ) & 0x0f ) << 0) | 
    (((
      $mmu ? count2sz($Opt->{tlb_num_ways}) :  # number of tlb ways 
      $mpu ? ($Opt->{mpu_min_data_region_size_log2}-5) : # 6-20 (coded 1-15)
             0
      ) & 0x0f ) << 4);  
  $$bytes_ref{0xf} = 
    (((
      $mpu ? ($Opt->{mpu_num_data_regions}-1) : # 1-32 region (coded 0-31)
             0
      ) & 0x1f ) << 0);
                                                      

  $$bytes_ref{0x10} = $Opt->{cache_has_icache} ?         # how much inst cache? 
                    count2sz($Opt->{cache_icache_size}) 
                     : 0;       
  $$bytes_ref{0x11} = $Opt->{cache_has_dcache} ?         # how much data cache? 
                    count2sz($Opt->{cache_dcache_size}) 
                     : 0;       
  $$bytes_ref{0x12} = $Opt->{oci_num_pm};               # how many pms
  $$bytes_ref{0x13} = $Opt->{oci_pm_width};             # width of pms

  $$bytes_ref{0x14} = ($Opt->{reset_addr} >> 0 ) & 0xff; # reset address
  $$bytes_ref{0x15} = ($Opt->{reset_addr} >> 8 ) & 0xff;
  $$bytes_ref{0x16} = ($Opt->{reset_addr} >> 16) & 0xff;
  $$bytes_ref{0x17} = ($Opt->{reset_addr} >> 24) & 0xff;

  $$bytes_ref{0x18} = ($Opt->{fast_tlb_miss_exception_addr} >> 0 ) & 0xff;
  $$bytes_ref{0x19} = ($Opt->{fast_tlb_miss_exception_addr} >> 8 ) & 0xff;
  $$bytes_ref{0x1a} = ($Opt->{fast_tlb_miss_exception_addr} >> 16) & 0xff;
  $$bytes_ref{0x1b} = ($Opt->{fast_tlb_miss_exception_addr} >> 24) & 0xff; 


  $$bytes_ref{0x1c} = 0;
  $$bytes_ref{0x1d} = 0;
  $$bytes_ref{0x1e} = 0;
  $$bytes_ref{0x1f} = 0;


  my @cfgdout_table;
  for (my $cfgdout_waddr = 0; $cfgdout_waddr < 8; $cfgdout_waddr++) {

    my $baddr = $cfgdout_waddr * 4; 


    my $wval =
      (($$bytes_ref{$baddr+0} << 0) |
       ($$bytes_ref{$baddr+1} << 8) |
       ($$bytes_ref{$baddr+2} << 16) |
       ($$bytes_ref{$baddr+3} << 24));

    my $whex = sprintf("32'h%08x", $wval);


    push(@cfgdout_table, "3'd" . $cfgdout_waddr => $whex);
  }


  my $destFile = &fcu_hash_to_text ($bytes_ref, "mif", $switches);
  &fcu_write_file(
      $system_path."/".$cpu_name."_ociram_default_contents.mif",
      $destFile->[0]
  );


  my $make_dat_hex = $Opt->{do_build_sim};
  if ($make_dat_hex) {
    &fcu_convert ({
      "0"      => $system_path."/".$cpu_name."_ociram_default_contents.mif",
      "1"      => $sim_path."/".$cpu_name."_ociram_default_contents.dat",
      oformat  => "dat",
      iformat  => "mif",
      width    => 32,
    });


    &fcu_convert ({
      "0"      => $system_path."/".$cpu_name."_ociram_default_contents.mif",
      "1"      => $sim_path."/".$cpu_name."_ociram_default_contents.hex",
      oformat  => "hex",
      iformat  => "mif",
      width    => 32,
    });
  }

  return \@cfgdout_table;
}


1;


