// Copyright (C) 1991-2009 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.
// Blackbox Model for Formal Verification

module stratixiigx_hssi_receiver (
    a1a2size,
    adcepowerdn,
    adcereset,        // in rev1.3 
    alignstatus,
    alignstatussync,  // added in rev1.2
    analogreset,
    bitslip,
    coreclk,
    cruclk, 
    crupowerdn,
    crureset,        // in rev1.3 
    datain,
    digitalreset,
    disablefifordin,
    disablefifowrin,
    dpriodisable,
    dprioin,
    enabledeskew,
    enabyteord,
    enapatternalign,
    fifordin,
    fiforesetrd,
    ibpowerdn, 
    invpol,       // invpolarity,
    localrefclk,
    locktodata, 
    locktorefclk,
    masterclk,
    parallelfdbk,
    phfifordenable,
    phfiforeset, 
    phfifowrdisable,
    phfifox4bytesel,
    phfifox4rdenable,
    phfifox4wrclk, 
    phfifox4wrenable, 
    phfifox8bytesel,
    phfifox8rdenable,
    phfifox8wrclk, 
    phfifox8wrenable,
    pipe8b10binvpolarity,  // in rev1.3
    pipepowerdown,
    pipepowerstate,
    quadreset, 
    refclk,
    revbitorderwa,
    revbyteorderwa,
    rmfifordena,
    rmfiforeset,
    rmfifowrena,
    rxdetectvalid,
    rxfound,
    serialfdbk,
    seriallpbken,
    termvoltage, 
    testsel, 
    xgmctrlin,
    xgmdatain,

    a1a2sizeout,
    a1detect,
    a2detect,
    adetectdeskew,
    alignstatussyncout,   // added in rev1.2
    analogtestbus,             
    bistdone,
    bisterr,
    byteorderalignstatus,
    clkout,                // clockout,
    cmudivclkout,
    ctrldetect,
    dataout,
    disablefifordout,
    disablefifowrout,
    disperr,
    dprioout,
    errdetect,
    fifordout,
    freqlock,             // freqlocked,
    k1detect,
    k2detect, 
    patterndetect,
    phaselockloss,
    phfifobyteselout,
    phfifooverflow,  
    phfifordenableout,
    phfifounderflow,      
    phfifowrclkout,
    phfifowrenableout,
    pipebufferstat,
    pipedatavalid,
    pipeelecidle,
    pipephydonestatus,
    pipestatus,
    pipestatetransdoneout,  // added in rev1.3
    rdalign,
    recovclkout,
    revparallelfdbkdata,        
    revserialfdbkout,    
    rlv, 
    rmfifoalmostempty,
    rmfifoalmostfull,
    rmfifodatadeleted,        
    rmfifodatainserted,
    rmfifoempty,
    rmfifofull,
    runningdisp,
    signaldetect,
    syncstatus,
    syncstatusdeskew,
    xgmctrldet,
    xgmdataout,
    xgmdatavalid,
    xgmrunningdisp,
	 dataoutfull
);

parameter adaptive_equalization_mode    = "none";       // <continuous/stopped/none>; 
parameter align_loss_sync_error_num     = 4;            // <integer 0-7>;// wordalign
parameter align_ordered_set_based       = "false";       // <true/false>;           
parameter align_pattern                 = "0101111100"; //  word align: size of align_pattern_length; 
parameter align_pattern_length          = 10;           // <7, 8, 10, 16, 20, 32, 40>; 
parameter align_to_deskew_pattern_pos_disp_only = "false"; // <true/false>;
parameter allow_align_polarity_inversion = "false";     // <true/false>; 
parameter allow_pipe_polarity_inversion  = "false";     // <true/false>;
parameter allow_serial_loopback          = "false";     // <true/false>;
parameter bandwidth_mode                 = 0;           // <integer 0-3>;
parameter bit_slip_enable                = "false";     // <true/false>;
parameter byte_order_pad_pattern         = "0101111100";// <10-bit binary string>;            
parameter byte_order_pattern             = "0101111100";// <10-bit binary string>;
parameter byte_ordering_mode             = "none";      // <none/pattern-based/syncstatus-based>;
parameter channel_number                 = 0;           // <integer 0-3>;
parameter channel_bonding                = "none";      // <none, x4, x8>;
parameter channel_width                  = 10;          // <integer 8,10,16,20,32,40>;
parameter clk1_mux_select                = "recvd_clk"; // <RECVD_CLK, MASTER_CLK, LOCAL_REFCLK, DIGITAL_REFCLK>;      
parameter clk2_mux_select                = "recvd_clk"; // <RECVD_CLK, LOCAL_REFCLK, DIGITAL_REFCLK, CORE_CLK>;
parameter cru_clock_select               = 0;           //  <CRUCLK<n> where n is 0 through 7 >
parameter cru_divide_by                  = 1;           // <1,2,4>;
parameter cru_multiply_by                = 10;          // <1,2,4,5,8,10,16,20,25>;
parameter cru_pre_divide_by              = 1;           // <1,2,4,8>;
parameter cruclk0_period                 = 10000;       //  in ps
parameter cruclk1_period                 = 10000;       //  in ps
parameter cruclk2_period                 = 10000;       //  in ps
parameter cruclk3_period                 = 10000;       //  in ps
parameter cruclk4_period                 = 10000;       //  in ps
parameter cruclk5_period                 = 10000;       //  in ps
parameter cruclk6_period                 = 10000;       //  in ps
parameter cruclk7_period                 = 10000;       //  in ps
parameter datapath_protocol              = "basic";     // <basic/pipe/xaui>;
parameter dec_8b_10b_compatibility_mode  = "true";     // <true/false>;
parameter dec_8b_10b_mode                = "none";      // <normal/cascaded/none>;
parameter deskew_pattern                 = "1100111100";// K28.3
parameter disable_auto_idle_insertion    = "false";      // <true/false>;  
parameter disable_ph_low_latency_mode    = "false";      // <true/false>;       
parameter disable_running_disp_in_word_align       = "false";    // <true/false>; 
parameter disallow_kchar_after_pattern_ordered_set = "false";    // <true/false>;
parameter dprio_mode                     = "none";      // <none/pma_electricals/full>;
parameter enable_bit_reversal            = "false";     // <true/false>;
parameter enable_byte_order_control_sig  = "false";     // <true/false>;           
parameter enable_dc_coupling             = "false";     // <true/false>;
parameter enable_deep_align              = "false";     // <true/false>;                          
parameter enable_deep_align_byte_swap    = "false";     // <true/false>;
parameter enable_lock_to_data_sig        = "false";     // <true/false>;
parameter enable_lock_to_refclk_sig      = "true";      // <true/false>;
parameter enable_self_test_mode          = "false";     // <true/false>;
parameter enable_true_complement_match_in_word_align = "true";    // <true/false>; 
parameter eq_adapt_seq_control           = 0;           // <integer 0-3>; 
parameter eq_max_gradient_control        = 0;           // <integer 0-7>;
parameter equalizer_ctrl_a               = 0;           // <integer 0-7>;
parameter equalizer_ctrl_b               = 0;           // < integer 0-7>;
parameter equalizer_ctrl_c               = 0;           // < integer 0-7>;
parameter equalizer_ctrl_d               = 0;           // < integer 0-7>;
parameter equalizer_ctrl_v               = 0;           // < integer 0-7>;
parameter equalizer_dc_gain              = 0;           // <integer 0-3>;
parameter force_freq_det_high            = "false";     // <true/false>;
parameter force_freq_det_low             = "false";     // <true/false>;
parameter force_signal_detect            = "false";     // <true/false>;
parameter force_signal_detect_dig        = "false";     // <true/false>;
parameter ignore_lock_detect             = "false";     // <true/false>;
parameter infiniband_invalid_code        = 0;           // <integer 0-3>;
parameter insert_pad_on_underflow        = "false";
parameter num_align_code_groups_in_ordered_set = 1;     // <integer 0-3>;   
parameter num_align_cons_good_data       = 3;           // wordalign<Integer 1-256>;
parameter num_align_cons_pat             = 4;           // <Integer 1-256>;
parameter ppmselect                      = 20;          // <integer 0-63>;           
parameter prbs_all_one_detect            = "false";     // <true/false>;
parameter rate_match_almost_empty_threshold = 11;        // <integer 0-15>;           
parameter rate_match_almost_full_threshold  = 13;       // <integer 0-15>;           
parameter rate_match_back_to_back        = "false";     // <true/false>;           
parameter rate_match_fifo_mode           = "none";      // <normal/cascaded/generic/cascaded_generic/none>;
parameter rate_match_ordered_set_based   = "false";     // <integer 10 or 20>;
parameter rate_match_pattern_size        = 10;          // <integer 10 or 20>;
parameter rate_match_pattern1            = "00000000000010111100";  // <20-bit binary string>;           
parameter rate_match_pattern2            = "00000000000010111100";  // <20-bit binary string>;           
parameter rate_match_skip_set_based      = "false";     // <true/false>;  
parameter rd_clk_mux_select              = "int_clk";   // <INT_CLK, CORE_CLK>;
parameter recovered_clk_mux_select       = "recvd_clk"; // <RECVD_CLK, LOCAL_REFCLK, DIGITAL_REFCLK>; 
parameter reset_clock_output_during_digital_reset = "false";   // <true/false>;
parameter run_length                     = 200;         // <5-320 or 4-254 depending on the deserialization factor>; 
parameter run_length_enable              = "false";     // <true/false>; 
parameter rx_detect_bypass               = "false";
parameter self_test_mode                 = "incremental"; // <PRBS_7,PRBS_8,PRBS_10,PRBS_23,low_freq,mixed_freq,high_freq,incremental,cjpat,crpat>;
parameter send_direct_reverse_serial_loopback = "false";  // <true/false>;
parameter signal_detect_threshold        = 0;           // <integer 0-7 (actual values determined after PE char)>;
parameter termination                    = "OCT_100_OHMS";  // new in 5.1SP1
parameter use_align_state_machine        = "false";     // <true/false>;
parameter use_deserializer_double_data_mode = "false";  // <true/false>;
parameter use_deskew_fifo                = "false";     // <true/false>;                                                  
parameter use_double_data_mode           = "false";     // <true/false>; 
parameter use_parallel_loopback          = "false";     // <true/false>;
parameter use_rate_match_pattern1_only   = "false";     // <true/false>;           
parameter use_rising_edge_triggered_pattern_align = "false";         // <true/false>; 

parameter phystatus_reset_toggle         = "false";      // new in 6.0           

// pma
parameter common_mode = "0.9V";                         // new in 5.1 SP1
parameter signal_detect_hysteresis_enabled = "false";   // new in 5.1 SP1
parameter single_detect_hysteresis_enabled = "false";   // new in 5.1 SP1 - used in code
parameter use_termvoltage_signal = "true";              // new in 5.1 SP1

parameter protocol_hint = "basic"; // new in 6.0 -<gige,xaui,pcie_x1,pcie_x4,pcie_x8,sonet,cei, basic>

parameter dprio_config_mode = 0;                        // 6.1
parameter dprio_width = 200;                            // 6.1

parameter loop_filter_resistor_control = 0;             // new in 6.0
parameter loop_filter_ripple_capacitor_control = 0;     // new in 6.0
parameter pd_mode_charge_pump_current_control = 0;      // new in 6.0
parameter vco_range = "high";                           // new in 6.0
parameter sim_offset_cycle_count = 10;                  // new in 7.1 for adce


//  PE -only parameters
parameter allow_vco_bypass               = "false";     // <true/false>
parameter charge_pump_current_control    = 0;           // <integer 0-3>;
parameter up_dn_mismatch_control         = 0;           // <integer 0-3>;
parameter charge_pump_test_enable        = "false";     // <true/false>;
parameter charge_pump_current_test_control_pos = "false";  // <true/false>
parameter charge_pump_tristate_enable    = "false";     // <true/false>;
parameter low_speed_test_select          = 0;           // <integer 0-15>;
parameter cru_clk_sel_during_vco_bypass  = "refclk1";   // <refclk1/refclk2/ext1/ext2>
parameter test_bus_sel                   = 0;           // <integer 0-7>;

// POF ONLY parameters
parameter enable_phfifo_bypass     = "false";
parameter sim_rxpll_clkout_phase_shift = 0;
parameter sim_rxpll_clkout_latency = 0;


parameter CTRL_OUT_WIDTH = (use_deserializer_double_data_mode == "true"  && use_double_data_mode == "true")  ? 4 :
                          (use_deserializer_double_data_mode == "false" && use_double_data_mode == "false") ? 1 : 2;

parameter DATA_OUT_WIDTH = channel_width;

parameter A1K1_OUT_WIDTH = (use_deserializer_double_data_mode == "true") ? 2 : 1 ; // from walign directly
parameter BASIC_WIDTH = (channel_width % 10 == 0) ? 10 : 8;
parameter NUM_OF_BASIC = channel_width / BASIC_WIDTH;


input          a1a2size;
input          adcepowerdn;
input          adcereset; 
input          alignstatus;
input          alignstatussync;
input          analogreset;
input          bitslip;
input          coreclk;
input [8:0]    cruclk; 
input          crupowerdn;
input          crureset;
input          datain;
input          digitalreset;
input          disablefifordin;
input          disablefifowrin;
input          dpriodisable;
input [199:0]  dprioin;
input          enabledeskew;
input          enabyteord;
input          enapatternalign;
input          fifordin;
input          fiforesetrd;
input          ibpowerdn; 
input          invpol;
input          localrefclk;
input          locktodata; 
input          locktorefclk;
input          masterclk;
input [19:0]   parallelfdbk;
input          phfifordenable;
input          phfiforeset; 
input          phfifowrdisable;
input          phfifox4bytesel;
input          phfifox4rdenable;
input          phfifox4wrclk; 
input          phfifox4wrenable; 
input          phfifox8bytesel;
input          phfifox8rdenable;
input          phfifox8wrclk; 
input          phfifox8wrenable; 
input          pipe8b10binvpolarity; // new in rev1.2
input [1:0]    pipepowerdown;        // width from 1 -> 2 in rev1.2
input [3:0]    pipepowerstate;       // width change from 3 to 4 in rev1.3
input          quadreset; 
input          refclk;
input          revbitorderwa;
input          revbyteorderwa;
input          rmfifordena;
input          rmfiforeset;
input          rmfifowrena;
input          rxdetectvalid;
input [1:0]    rxfound;
input          serialfdbk;
input          seriallpbken;
input [2:0]    termvoltage; 
input [3:0]    testsel; 
input          xgmctrlin;
input [7:0]    xgmdatain;

output [CTRL_OUT_WIDTH-1:0]     a1a2sizeout;
output [A1K1_OUT_WIDTH-1:0]     a1detect;
output [A1K1_OUT_WIDTH-1:0]     a2detect;
output                          adetectdeskew;
output                          alignstatussyncout;
output [7:0]                    analogtestbus;             
output                          bistdone;
output                          bisterr;
output                          byteorderalignstatus;
output                          clkout;
output                          cmudivclkout;
output [CTRL_OUT_WIDTH-1:0]     ctrldetect;
output [DATA_OUT_WIDTH-1:0]     dataout;
output [63:0]                   dataoutfull;        // new in 6.1
output                          disablefifordout;
output                          disablefifowrout;
output [CTRL_OUT_WIDTH-1:0]     disperr;
output [199:0]                  dprioout;
output [CTRL_OUT_WIDTH-1:0]     errdetect;
output                          fifordout;
output                          freqlock;
output [A1K1_OUT_WIDTH-1:0]     k1detect;
output [1:0]                    k2detect; 
output [CTRL_OUT_WIDTH-1:0]     patterndetect;
output                          phaselockloss;
output                          phfifobyteselout;
output                          phfifooverflow;  
output                          phfifordenableout;
output                          phfifounderflow;      
output                          phfifowrclkout;
output                          phfifowrenableout;
output [3:0]                    pipebufferstat;
output                          pipedatavalid;
output                          pipeelecidle;
output                          pipephydonestatus;
output [2:0]                    pipestatus;
output                          pipestatetransdoneout;
output                          rdalign;
output                          recovclkout;
output [19:0]                   revparallelfdbkdata;        
output                          revserialfdbkout;    
output                          rlv; 
output                          rmfifoalmostempty;
output                          rmfifoalmostfull;
output [CTRL_OUT_WIDTH-1:0]     rmfifodatadeleted;        
output [CTRL_OUT_WIDTH-1:0]     rmfifodatainserted;
output                          rmfifoempty;
output                          rmfifofull;
output [CTRL_OUT_WIDTH-1:0]     runningdisp;
output                          signaldetect;
output [CTRL_OUT_WIDTH-1:0]     syncstatus;
output                          syncstatusdeskew;
output                          xgmctrldet;
output [7:0]                    xgmdataout;
output                          xgmdatavalid;
output                          xgmrunningdisp;

endmodule
