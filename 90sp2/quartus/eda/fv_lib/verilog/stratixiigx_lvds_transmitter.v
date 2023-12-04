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
// Module Name : stratixiigx_lvds_transmitter
//
// Description : Black Box model for Formal Verification
//
///////////////////////////////////////////////////////////////////////////////

module stratixiigx_lvds_transmitter (
               datain,
               clk0,
				   enable0,
               serialdatain,
               postdpaserialdatain,
               dataout,
               serialfdbkout,
					devclrn, devpor
);

    parameter channel_width                  = 1;
    parameter bypass_serializer              = "false";
    parameter invert_clock                   = "false";
    parameter use_falling_clock_edge         = "false";
    parameter preemphasis_setting            = 0;
    parameter vod_setting                    = 0;
    parameter differential_drive             = 0;
	 parameter lpm_type = "stratixiigx_lvds_transmitter";
	 parameter use_post_dpa_serial_data_input = "false";
	 parameter use_serial_data_input = "false";

    // INPUT PORTS
    input [channel_width-1:0] datain;
    input clk0;
    input enable0;
    input serialdatain;
    input postdpaserialdatain;
	input devclrn, devpor;

    // OUTPUT PORTS
    output dataout;
    output serialfdbkout;

endmodule // stratixiigx_lvds_transmitter
