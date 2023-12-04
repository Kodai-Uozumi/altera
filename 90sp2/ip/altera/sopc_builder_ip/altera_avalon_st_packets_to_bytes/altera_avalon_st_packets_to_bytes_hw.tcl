# TCL File Generated by Component Editor 8.1
# Thu Aug 07 21:52:51 PDT 2008
# DO NOT MODIFY


# +-----------------------------------
# | 
# | altera_avalon_st_packets_to_bytes "Avalon-ST Packets to Bytes Converter"
# | Altera Corporation 2008.08.07.21:52:51
# | Avalon-ST Packets to Bytes Converter
# | 
# | ./altera_avalon_st_packets_to_bytes.v
# | 
# |    ./altera_avalon_st_packets_to_bytes.v syn, sim
# | 
# +-----------------------------------


# +-----------------------------------
# | module altera_avalon_st_packets_to_bytes
# | 
set_module_property DESCRIPTION "Avalon-ST Packets to Bytes Converter"
set_module_property NAME altera_avalon_st_packets_to_bytes
set_module_property VERSION 9.0
set_module_property GROUP "Bridges and Adapters/Streaming"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "Avalon-ST Packets to Bytes Converter"
set_module_property DATASHEET_URL http://www.altera.com/literature/hb/nios2/qts_qii55012.pdf
set_module_property TOP_LEVEL_HDL_FILE altera_avalon_st_packets_to_bytes.v
set_module_property TOP_LEVEL_HDL_MODULE altera_avalon_st_packets_to_bytes
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file altera_avalon_st_packets_to_bytes.v {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clk
# | 
add_interface clk clock end
set_interface_property clk ptfSchematicName ""

add_interface_port clk clk clk Input 1
add_interface_port clk reset_n reset_n Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point in_packets_stream
# | 
add_interface in_packets_stream avalon_streaming end
set_interface_property in_packets_stream dataBitsPerSymbol 8
set_interface_property in_packets_stream errorDescriptor ""
set_interface_property in_packets_stream maxChannel 255
set_interface_property in_packets_stream readyLatency 0
set_interface_property in_packets_stream symbolsPerBeat 1

set_interface_property in_packets_stream ASSOCIATED_CLOCK clk

add_interface_port in_packets_stream in_ready ready Output 1
add_interface_port in_packets_stream in_valid valid Input 1
add_interface_port in_packets_stream in_data data Input 8
add_interface_port in_packets_stream in_channel channel Input 8
add_interface_port in_packets_stream in_startofpacket startofpacket Input 1
add_interface_port in_packets_stream in_endofpacket endofpacket Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point out_bytes_stream
# | 
add_interface out_bytes_stream avalon_streaming start
set_interface_property out_bytes_stream dataBitsPerSymbol 8
set_interface_property out_bytes_stream errorDescriptor ""
set_interface_property out_bytes_stream maxChannel 0
set_interface_property out_bytes_stream readyLatency 0
set_interface_property out_bytes_stream symbolsPerBeat 1

set_interface_property out_bytes_stream ASSOCIATED_CLOCK clk

add_interface_port out_bytes_stream out_ready ready Input 1
add_interface_port out_bytes_stream out_valid valid Output 1
add_interface_port out_bytes_stream out_data data Output 8
# | 
# +-----------------------------------
