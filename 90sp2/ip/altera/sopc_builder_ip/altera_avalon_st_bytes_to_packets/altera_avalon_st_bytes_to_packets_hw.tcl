# TCL File Generated by Component Editor 8.1
# Thu Aug 07 21:52:17 PDT 2008
# DO NOT MODIFY


# +-----------------------------------
# | 
# | altera_avalon_st_bytes_to_packets "Avalon-ST Bytes to Packets Converter" v8.1
# | Altera Corporation 2008.08.07.21:52:17
# | Avalon-ST Bytes to Packets Converter
# | 
# | ./altera_avalon_st_bytes_to_packets.v
# | 
# |    ./altera_avalon_st_bytes_to_packets.v syn, sim
# | 
# +-----------------------------------


# +-----------------------------------
# | module altera_avalon_st_bytes_to_packets
# | 
set_module_property DESCRIPTION "Avalon-ST Bytes to Packets Converter"
set_module_property NAME altera_avalon_st_bytes_to_packets
set_module_property VERSION 9.0
set_module_property GROUP "Bridges and Adapters/Streaming"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "Avalon-ST Bytes to Packets Converter"
set_module_property DATASHEET_URL http://www.altera.com/literature/hb/nios2/qts_qii55012.pdf
set_module_property TOP_LEVEL_HDL_FILE altera_avalon_st_bytes_to_packets.v
set_module_property TOP_LEVEL_HDL_MODULE altera_avalon_st_bytes_to_packets
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file altera_avalon_st_bytes_to_packets.v {SYNTHESIS SIMULATION}
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
# | connection point out_packets_stream
# | 
add_interface out_packets_stream avalon_streaming start
set_interface_property out_packets_stream dataBitsPerSymbol 8
set_interface_property out_packets_stream errorDescriptor ""
set_interface_property out_packets_stream maxChannel 255
set_interface_property out_packets_stream readyLatency 0
set_interface_property out_packets_stream symbolsPerBeat 1

set_interface_property out_packets_stream ASSOCIATED_CLOCK clk

add_interface_port out_packets_stream out_ready ready Input 1
add_interface_port out_packets_stream out_valid valid Output 1
add_interface_port out_packets_stream out_data data Output 8
add_interface_port out_packets_stream out_channel channel Output 8
add_interface_port out_packets_stream out_startofpacket startofpacket Output 1
add_interface_port out_packets_stream out_endofpacket endofpacket Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point in_bytes_stream
# | 
add_interface in_bytes_stream avalon_streaming end
set_interface_property in_bytes_stream dataBitsPerSymbol 8
set_interface_property in_bytes_stream errorDescriptor ""
set_interface_property in_bytes_stream maxChannel 0
set_interface_property in_bytes_stream readyLatency 0
set_interface_property in_bytes_stream symbolsPerBeat 1

set_interface_property in_bytes_stream ASSOCIATED_CLOCK clk

add_interface_port in_bytes_stream in_ready ready Output 1
add_interface_port in_bytes_stream in_valid valid Input 1
add_interface_port in_bytes_stream in_data data Input 8
# | 
# +-----------------------------------
