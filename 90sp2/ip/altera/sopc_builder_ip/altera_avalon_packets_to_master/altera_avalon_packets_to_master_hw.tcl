# TCL File for Altera Avalon Packets to Master component 
#
# Has a hidden parameter for exporting master signals.  Off by default, the
# component will have 2 Avalon ST interfaces, and an Avalon Master.  When the
# hidden switch is turned on, the Avalon Master signals will be pushed to the
# top level as conduits.  This allows for repackaging the entire JTAG chain as
# the altera_avalon_jtag_master component with these conduits being used as the
# Avalon Master at that level.
#
# The elaboration callback is used to accomplish this switch.

set_module_property DESCRIPTION "Avalon Packets to Transaction Converter"
set_module_property NAME altera_avalon_packets_to_master
set_module_property VERSION 9.0
set_module_property GROUP "Bridges and Adapters/Streaming"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME  "Avalon Packets to Transaction Converter"
set_module_property DATASHEET_URL "http://www.altera.com/literature/hb/nios2/qts_qii55013.pdf"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property TOP_LEVEL_HDL_FILE altera_avalon_packets_to_master.v
set_module_property TOP_LEVEL_HDL_MODULE altera_avalon_packets_to_master
set_module_property ELABORATION_CALLBACK elaborate
set_module_property EDITABLE false 

add_file altera_avalon_packets_to_master.v {SYNTHESIS SIMULATION}

# Module parameters
add_parameter EXPORT_MASTER_SIGNALS "integer" "0" ""
set_parameter_property EXPORT_MASTER_SIGNALS visible false

proc elaborate {} {
    set export_master [ get_parameter_value EXPORT_MASTER_SIGNALS ]
    # Interface clk
    add_interface clk clock end
    set_interface_property clk ptfSchematicName ""
    # Ports in interface clk
    add_interface_port clk clk clk Input 1
    add_interface_port clk reset_n reset_n Input 1
    
    # Interface out_stream
    add_interface out_stream avalon_streaming start
    set_interface_property out_stream maxChannel 0
    set_interface_property out_stream readyLatency 0
    set_interface_property out_stream dataBitsPerSymbol 8
    set_interface_property out_stream symbolsPerBeat 1

    set_interface_property out_stream ASSOCIATED_CLOCK clk

    # Ports in interface out_stream
    add_interface_port out_stream out_ready ready Input 1
    add_interface_port out_stream out_valid valid Output 1
    add_interface_port out_stream out_data data Output 8
    add_interface_port out_stream out_startofpacket startofpacket Output 1
    add_interface_port out_stream out_endofpacket endofpacket Output 1
    
    # Interface in_stream
    add_interface in_stream avalon_streaming end
    set_interface_property in_stream maxChannel 0
    set_interface_property in_stream readyLatency 0
    set_interface_property in_stream dataBitsPerSymbol 8
    set_interface_property in_stream symbolsPerBeat 1

    set_interface_property in_stream ASSOCIATED_CLOCK clk

    # Ports in interface in_stream
    add_interface_port in_stream in_ready ready Output 1
    add_interface_port in_stream in_valid valid Input 1
    add_interface_port in_stream in_data data Input 8
    add_interface_port in_stream in_startofpacket startofpacket Input 1
    add_interface_port in_stream in_endofpacket endofpacket Input 1

    if {$export_master == "1"} {
        # export avalon master as conduit
        add_interface avalon_master_export conduit start
        set_interface_property avalon_master_export ASSOCIATED_CLOCK clk
        add_interface_port avalon_master_export address export Output 32
        add_interface_port avalon_master_export readdata export Input 32
        add_interface_port avalon_master_export read export Output 1 
        add_interface_port avalon_master_export write export Output 1
        add_interface_port avalon_master_export writedata export Output 32
        add_interface_port avalon_master_export waitrequest export Input 1
        add_interface_port avalon_master_export readdatavalid export Input 1
        add_interface_port avalon_master_export byteenable export Output 4
    } else {
        # Interface avalon_master
        add_interface avalon_master avalon start 
        set_interface_property avalon_master linewrapBursts false
        set_interface_property avalon_master doStreamReads false
        set_interface_property avalon_master doStreamWrites false
        set_interface_property avalon_master burstOnBurstBoundariesOnly false
       
        set_interface_property avalon_master ASSOCIATED_CLOCK clk
        # Ports in interface avalon_master
        add_interface_port avalon_master address address Output 32
        add_interface_port avalon_master readdata readdata Input 32
        add_interface_port avalon_master read read Output 1
        add_interface_port avalon_master write write Output 1
        add_interface_port avalon_master writedata writedata Output 32
        add_interface_port avalon_master waitrequest waitrequest Input 1
        add_interface_port avalon_master readdatavalid readdatavalid Input 1
        add_interface_port avalon_master byteenable byteenable Output 4
    }
}
