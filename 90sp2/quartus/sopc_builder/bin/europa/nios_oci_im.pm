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























no strict;    # {~<% that strict $#!+.
use europa_all;
























sub make_nios_oci_im
{
  my ($Opt, $project) = (@_);

  my $module = e_module->new ({
      name    => $Opt->{name}."_nios_oci_im",
      project => $project,
  });



  $module->add_contents (

    e_signal->news (
      ["trc_im_data",     $Opt->{oci_tm_width},         1],
      ["trc_im_addr",     $Opt->{oci_trace_addr_width}, 1],
      ["trc_wrap",        1,                    1],
      ["trc_clear",       1,                    1],
    ),

    e_signal->news (
      ["ir",        8,    0],
      ["jdo",       36,   0],
      ["tw",              $Opt->{oci_tm_width}, 0],
    ),

  );





  $module->add_contents (

    e_signal->news (
      ["traceram_din",     $Opt->{oci_tm_width},         0, 1],
      ["traceram_dout",    $Opt->{oci_tm_width},         0, 1],
      ["traceram_addr",    $Opt->{oci_trace_addr_width}, 0, 1],
    ),
  );







  $module->add_contents (
    e_assign->news ( 
      ["trc_enb" => "trc_ctrl[$TRC_ENB_BIT]"],
      ["trc_on" => "~trc_ctrl[$TRC_OFC_BIT]"],
      ["tw_valid" => "|tw[".$Opt->{oci_tm_width}."-1 : ".$Opt->{oci_tm_width}."-4]"],
    ),
    e_process->new ({
      clock     => "clk",
      reset     => "jrst_n",
      asynchronous_contents => [
        e_assign->news (
          ["trc_im_addr" => "0"],
          ["trc_wrap" => "0"],
        ),
      ],
      contents => [
        e_if->new ({
          condition => "!".($Opt->{oci_onchip_trace} ? "1" : "0"),
          then  => [
            ["trc_im_addr" => "0"],
            ["trc_wrap" => "0"],
          ],
          elsif  => {
            condition => 
              "((trc_enb & trc_on & tw_valid)".     # recording
              "|| (~trc_enb & jxdr & (ir == $IR_TRCWR)) ".  # oci write
              "|| (~trc_enb & jxdr & (ir == $IR_TRCRD)))",  # oci read
            then  => [
              ["trc_im_addr" => "trc_im_addr+1"],
              e_if->new ({
                condition => "&trc_im_addr",
                then => [ ["trc_wrap" => "1"] ],
              }),
            ],
            elsif => {
              condition => "(~trc_enb & jxdr & (ir == $IR_TRCADDR))",
              then  => [
                ["trc_im_addr" => "jdo[".$Opt->{oci_trace_addr_width}."-1:0]"],
                ["trc_wrap" => "0"],
              ],
            }, # end elsif
          } # end elsif
        }),
      ],
    }),
    e_process->new ({
      clock     => "clk",
      contents => [
        e_assign->new (
          ["trc_clear" => "~trc_enb & jxdr & (ir == $IR_TRCADDR)"],
        ),
      ],
    }),
    e_assign->news ( 
      ["traceram_din" => "trc_enb ? tw : jdo[".$Opt->{oci_tm_width}."-1:0]"],
      ["traceram_wr" => "trc_enb ? tw_valid : (jxdr & (ir == $IR_TRCWR))"],
      ["traceram_addr" => "trc_im_addr"],
    ),


    e_dpram->new ({
      name    => $Opt->{name}."_traceram_lpm_dram_dp_component",

      stratix_style_memory => 0,
      data_width          => $Opt->{oci_tm_width},
      address_width       => 7,

      read_latency        => 1,    # register indata, do not register outdata
      implement_as_esb    => 1,
      write_pass_through  => 0,
      port_map => {
        data      => "traceram_din",
        wraddress => "traceram_addr",
        rdaddress => "traceram_addr",
        wren      => "traceram_wr",
        wrclock   => "clk",
        rdclock   => "clk",
        q         => "traceram_dout",
       },
    }),

    e_assign->news ( 
      ["trc_im_data" => "(".$Opt->{oci_onchip_trace}.") ? traceram_dout : 0"],
    ),
  );

  return $module;
}



1;

