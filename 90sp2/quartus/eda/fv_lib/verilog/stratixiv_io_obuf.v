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
// stratixiv IO OBUF atom for Formal Verification
///////////////////////////////////////////////////////////////////////////////

// MODEL BEGIN

module stratixiv_io_obuf (
// INTERFACE BEGIN
	i,
	oe,
    seriesterminationcontrol,
    dynamicterminationcontrol,    
    parallelterminationcontrol,   
    devoe,
    o,
    obar
// INTERFACE END
);

//Parameter Declaration
parameter open_drain_output = "false";
parameter bus_hold = "false";
parameter shift_series_termination_control = "false";
parameter lpm_type = "stratixiv_io_obuf";
parameter sim_dynamic_termination_control_is_connected = "false";

//Input Ports Declaration
input i;
input oe;
input dynamicterminationcontrol;
input [13:0] parallelterminationcontrol;
input [13:0] seriesterminationcontrol;

input devoe;

//Output Ports Declaration
output o;
output obar;

//INTERNAL Signals
reg tristate_out;

// IMPLEMENTATION BEGIN 
always @(i or oe)
begin
    if (open_drain_output == "true")
      begin
        if (oe == 1'b1)
           tristate_out = ( i == 1'b0) ? 1'b0 : 1'bz;
        else
           tristate_out = 1'bz;
      end
    else
      tristate_out = (oe == 1'b1) ? i : 1'bz;
end

assign o = tristate_out;
assign obar = ~tristate_out; 

// IMPLEMENTATION END
endmodule 
// MODEL END
