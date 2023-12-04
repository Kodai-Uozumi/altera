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
///////////////////////////////////////////////////////////////////////////////
//
//                           STRATIXGX_XGM_INTERFACE
//
///////////////////////////////////////////////////////////////////////////////

module stratixgx_xgm_interface (
    txdatain,
    txctrl,
    rdenablesync,
    txclk,
    rxdatain,
    rxctrl,
    rxrunningdisp,
    rxdatavalid,
    rxclk,
    resetall,
    adet,
    syncstatus,
    rdalign,
    recovclk,
    devpor,
    devclrn,
    txdataout,
    txctrlout,
    rxdataout,
    rxctrlout,
    resetout,
    alignstatus,
    enabledeskew,
    fiforesetrd,
    // PE ONLY PORTS
    scanclk, 
    scanin, 
    scanshift,
    scanmode,
    scanout,
    test,
    digitalsmtest,
    calibrationstatus,
    // MDIO PORTS
    mdiodisable,
    mdioclk,
    mdioin,
    rxppmselect,
    mdioout,
    mdiooe,
    // RESET PORTS
    txdigitalreset,
    rxdigitalreset,
    rxanalogreset,
    pllreset,
    pllenable,
    txdigitalresetout,
    rxdigitalresetout,   
    txanalogresetout,
    rxanalogresetout,
    pllresetout
    );

   parameter use_continuous_calibration_mode = "false";
   parameter mode_is_xaui = "false";
   parameter digital_test_output_select = 0;
   parameter analog_test_output_signal_select = 0;
   parameter analog_test_output_channel_select = 0;
   parameter rx_ppm_setting_0 = 0;
   parameter rx_ppm_setting_1 = 0;
   parameter use_rx_calibration_status = "false";
   parameter use_global_serial_loopback = "false";
   parameter rx_calibration_test_write_value = 0;
   parameter enable_rx_calibration_test_write = "false";
   parameter tx_calibration_test_write_value = 0;
   parameter enable_tx_calibration_test_write = "false";
      
   input [31 : 0] txdatain;
   input [3 : 0]  txctrl;
   input      rdenablesync;
   input      txclk;
   input [31 : 0] rxdatain;
   input [3 : 0]  rxctrl;
   input [3 : 0]  rxrunningdisp;
   input [3 : 0]  rxdatavalid;
   input      rxclk;
   input      resetall;
   input [3 : 0]  adet;
   input [3 : 0]  syncstatus;
   input [3 : 0]  rdalign;
   input      recovclk;
   input      devpor;
   input      devclrn;
   
   // RESET PORTS
   input [3:0]    txdigitalreset;
   input [3:0]    rxdigitalreset;
   input [3:0]    rxanalogreset;
   input      pllreset;
   input      pllenable;

   // NEW MDIO/PE ONLY PORTS
   input      mdioclk;
   input      mdiodisable;
   input      mdioin;
   input      rxppmselect;
   input      scanclk;
   input      scanin;
   input      scanmode;
   input      scanshift;
   
   output [31 : 0] txdataout;
   output [3 : 0]  txctrlout;
   output [31 : 0] rxdataout;
   output [3 : 0]  rxctrlout;
   output      resetout;
   output      alignstatus;
   output      enabledeskew;
   output      fiforesetrd;
   
   // RESET PORTS
   output [3:0]    txdigitalresetout;
   output [3:0]    rxdigitalresetout;   
   output [3:0]    txanalogresetout;
   output [3:0]    rxanalogresetout;
   output      pllresetout;

   // NEW MDIO/PE ONLY PORTS
   output [4:0]    calibrationstatus;
   output [3:0]    digitalsmtest;
   output      mdiooe;
   output      mdioout;
   output      scanout;
   output      test;

endmodule 
