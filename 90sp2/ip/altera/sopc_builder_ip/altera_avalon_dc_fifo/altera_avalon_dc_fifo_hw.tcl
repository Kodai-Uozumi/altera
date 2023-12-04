# $Id: //acds/rel-r/9.0sp2/ip/sopc/components/altera_avalon_dc_fifo/altera_avalon_dc_fifo_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2009/04/01 $
#-------------------------------------------------------------------------------
# Avalon-ST DCFIFO component description

set_source_file "altera_avalon_dc_fifo.v"
set_module "altera_avalon_dc_fifo"
set_module_description ""
set_module_property "author"  "Altera Corporation"
set_module_property "version" "9.0"
set_module_property "datasheetURL" "http://www.altera.com/literature/hb/nios2/qts_qii55014.pdf"
set_module_property "className" "altera_avalon_dc_fifo"
set_module_property "displayName" "Avalon-ST Dual Clock FIFO"
set_module_property "group" "Memories and Memory Controllers/On-Chip"
set_module_property "instantiateInSystemModule" "true"
set_module_property "simulationModelInVHDL" "true"
set_module_property "editable" "false"

add_file altera_avalon_dc_fifo.v {SYNTHESIS SIMULATION}
add_file altera_dcfifo_synchronizer_bundle.v {SYNTHESIS SIMULATION}
add_file altera_avalon_dc_fifo.sdc SDC

## --------------------------------------------
#|
#| Module parameters
#|
add_parameter "SYMBOLS_PER_BEAT"   "integer" "1" ""
add_parameter "BITS_PER_SYMBOL"    "integer" "8" ""
add_parameter "FIFO_DEPTH"         "integer" "16" ""
add_parameter "CHANNEL_WIDTH"      "integer" "0" ""
add_parameter "ERROR_WIDTH"        "integer" "0" ""
add_parameter "USE_PACKETS"        "integer" "0" ""
add_parameter "USE_IN_FILL_LEVEL"  "integer" "0" ""
add_parameter "USE_OUT_FILL_LEVEL" "integer" "0" ""
add_parameter "WR_SYNC_DEPTH"      "integer" "2" ""
add_parameter "RD_SYNC_DEPTH"      "integer" "2" ""

## ---------------------------------
#|
#| Set display names for all the visible parameters
#|
set_parameter_property "SYMBOLS_PER_BEAT"   "DISPLAY_NAME" "Symbols per beat"
set_parameter_property "BITS_PER_SYMBOL"    "DISPLAY_NAME" "Bits per symbol"
set_parameter_property "FIFO_DEPTH"         "DISPLAY_NAME" "FIFO depth"
set_parameter_property "CHANNEL_WIDTH"      "DISPLAY_NAME" "Channel width"
set_parameter_property "ERROR_WIDTH"        "DISPLAY_NAME" "Error width"
set_parameter_property "USE_PACKETS"        "DISPLAY_NAME" "Use packets"
set_parameter_property "USE_IN_FILL_LEVEL"  "DISPLAY_NAME" "Use sink fill level"
set_parameter_property "USE_OUT_FILL_LEVEL" "DISPLAY_NAME" "Use source fill level"
set_parameter_property "WR_SYNC_DEPTH"      "DISPLAY_NAME" "Write pointer synchronizer length"
set_parameter_property "RD_SYNC_DEPTH"      "DISPLAY_NAME" "Read pointer synchronizer length"

## ---------------------------------
#|
#| Set display hints for those boolean-like parameters
#|
set_parameter_property "USE_PACKETS"        "DISPLAY_HINT" "boolean"
set_parameter_property "USE_IN_FILL_LEVEL"  "DISPLAY_HINT" "boolean"
set_parameter_property "USE_OUT_FILL_LEVEL" "DISPLAY_HINT" "boolean"

## --------------------------------------------
#|
#| Callback routines
#|
set_module_property previewElaborationCallback "elaborate"
set_module_property previewValidationCallback  "validate"


proc log2ceil {num} {

    set val 0
    set i 1
    while {$i < $num} {
        set val [expr $val + 1]
        set i [expr 1 << $val]
    }

    return $val;
}

## ---------------------------------
#|
#| Ensures that the FIFO depth is a power of two,
#| otherwise errors out with size recommendation.
#|
proc validate {} {

    set required_depth [ get_parameter_value "FIFO_DEPTH" ]
    set addr_width     [ log2ceil $required_depth ]
    set real_depth     [ expr (1 << $addr_width) ]

    if {$required_depth != $real_depth} {
        send_message "error" "FIFO depth must be a power of two ($real_depth would be acceptable)"
    }
}

proc elaborate {} {

    set symbols_per_beat    [get_parameter_value "SYMBOLS_PER_BEAT"]
    set bits_per_symbol     [get_parameter_value "BITS_PER_SYMBOL"]
    set data_width          [expr $symbols_per_beat * $bits_per_symbol]
    set empty_width         [log2ceil $symbols_per_beat] 
    set channel_width       [get_parameter_value "CHANNEL_WIDTH"]
    set max_channel         [expr (1 << $channel_width) - 1]
    set error_width         [get_parameter_value "ERROR_WIDTH"]
    set use_packets         [get_parameter_value "USE_PACKETS"]
    set use_out_fill_level  [get_parameter_value "USE_OUT_FILL_LEVEL"]
    set use_in_fill_level   [get_parameter_value "USE_IN_FILL_LEVEL"]

    # In clock interface
    add_interface "in_clk" "clock" "sink" "asynchronous"
    add_port_to_interface "in_clk" "in_clk" "clk"
    set_port_direction_and_width "in_clk" "input" 1
    add_port_to_interface "in_clk" "in_reset_n" "reset_n"
    set_port_direction_and_width "in_reset_n" "input" 1

    # Out clock interface
    add_interface "out_clk" "clock" "sink" "asynchronous"
    add_port_to_interface "out_clk" "out_clk" "clk"
    set_port_direction_and_width "out_clk" "input" 1
    add_port_to_interface "out_clk" "out_reset_n" "reset_n"
    set_port_direction_and_width "out_reset_n" "input" 1

    if {$use_in_fill_level == "1"} {
        add_interface "in_csr" "avalon" "slave" "in_clk"
        set_interface_property "in_csr" "isNonVolatileStorage" "false"
        set_interface_property "in_csr" "burstOnBurstBoundariesOnly" "false"
        set_interface_property "in_csr" "readLatency" "1"
        set_interface_property "in_csr" "holdTime" "0"
        set_interface_property "in_csr" "printableDevice" "false"
        set_interface_property "in_csr" "readWaitTime" "0"
        set_interface_property "in_csr" "setupTime" "0"
        set_interface_property "in_csr" "addressAlignment" "DYNAMIC"
        set_interface_property "in_csr" "writeWaitTime" "0"
        set_interface_property "in_csr" "timingUnits" "Cycles"
        set_interface_property "in_csr" "minimumUninterruptedRunLength" "1"
        set_interface_property "in_csr" "isMemoryDevice" "false"
        set_interface_property "in_csr" "linewrapBursts" "false"
        set_interface_property "in_csr" "maximumPendingReadTransactions" "0"

        add_port_to_interface "in_csr" "in_csr_address" "address"
        set_port_direction_and_width "in_csr_address" "input" 1
        add_port_to_interface "in_csr" "in_csr_read" "read"
        set_port_direction_and_width "in_csr_read" "input" 1
        add_port_to_interface "in_csr" "in_csr_write" "write"
        set_port_direction_and_width "in_csr_write" "input" 1
        add_port_to_interface "in_csr" "in_csr_readdata" "readdata"
        set_port_direction_and_width "in_csr_readdata" "output" 32
        add_port_to_interface "in_csr" "in_csr_writedata" "writedata"
        set_port_direction_and_width "in_csr_writedata" "input" 32
    }

    if {$use_out_fill_level == "1"} {
        add_interface "out_csr" "avalon" "slave" "out_clk"
        set_interface_property "out_csr" "isNonVolatileStorage" "false"
        set_interface_property "out_csr" "burstOnBurstBoundariesOnly" "false"
        set_interface_property "out_csr" "readLatency" "0"
        set_interface_property "out_csr" "holdTime" "0"
        set_interface_property "out_csr" "printableDevice" "false"
        set_interface_property "out_csr" "readWaitTime" "1"
        set_interface_property "out_csr" "setupTime" "0"
        set_interface_property "out_csr" "addressAlignment" "DYNAMIC"
        set_interface_property "out_csr" "writeWaitTime" "0"
        set_interface_property "out_csr" "timingUnits" "Cycles"
        set_interface_property "out_csr" "minimumUninterruptedRunLength" "1"
        set_interface_property "out_csr" "isMemoryDevice" "false"
        set_interface_property "out_csr" "linewrapBursts" "false"
        set_interface_property "out_csr" "maximumPendingReadTransactions" "0"

        add_port_to_interface "out_csr" "out_csr_address" "address"
        set_port_direction_and_width "out_csr_address" "input" 1
        add_port_to_interface "out_csr" "out_csr_read" "read"
        set_port_direction_and_width "out_csr_read" "input" 1
        add_port_to_interface "out_csr" "out_csr_write" "write"
        set_port_direction_and_width "out_csr_write" "input" 1
        add_port_to_interface "out_csr" "out_csr_readdata" "readdata"
        set_port_direction_and_width "out_csr_readdata" "output" 32
        add_port_to_interface "out_csr" "out_csr_writedata" "writedata"
        set_port_direction_and_width "out_csr_writedata" "input" 32
    }

    # Avalon-ST sink interface
    add_interface "in" "avalon_streaming" "sink" "in_clk"
    set_interface_property "in" "symbolsPerBeat" $symbols_per_beat
    set_interface_property "in" "dataBitsPerSymbol" $bits_per_symbol
    set_interface_property "in" "readyLatency" "0"
    set_interface_property "in" "maxChannel" "$max_channel"

    # Avalon-ST source interface
    add_interface "out" "avalon_streaming" "source" "out_clk"
    set_interface_property "out" "symbolsPerBeat" $symbols_per_beat
    set_interface_property "out" "dataBitsPerSymbol" $bits_per_symbol
    set_interface_property "out" "readyLatency" "0"
    set_interface_property "out" "maxChannel" "$max_channel"

    add_port_to_interface "in" "in_data" "data"
    set_port_direction_and_width "in_data" "input" $data_width
    add_port_to_interface "in" "in_valid" "valid"
    set_port_direction_and_width "in_valid" "input" 1
    add_port_to_interface "in" "in_ready" "ready"
    set_port_direction_and_width "in_ready" "output" 1

    add_port_to_interface "out" "out_data" "data"
    set_port_direction_and_width "out_data" "output" $data_width
    add_port_to_interface "out" "out_valid" "valid"
    set_port_direction_and_width "out_valid" "output" 1
    add_port_to_interface "out" "out_ready" "ready"
    set_port_direction_and_width "out_ready" "input" 1

    if {$use_packets == "1"} {
        add_port_to_interface "in" "in_startofpacket" "startofpacket"
        set_port_direction_and_width "in_startofpacket" "input" 1
        add_port_to_interface "in" "in_endofpacket" "endofpacket"
        set_port_direction_and_width "in_endofpacket" "input" 1

        add_port_to_interface "out" "out_startofpacket" "startofpacket"
        set_port_direction_and_width "out_startofpacket" "output" 1
        add_port_to_interface "out" "out_endofpacket" "endofpacket"
        set_port_direction_and_width "out_endofpacket" "output" 1

        if {$empty_width > 0} {
            add_port_to_interface "in" "in_empty" "empty"
            set_port_direction_and_width "in_empty" "input" $empty_width
            add_port_to_interface "out" "out_empty" "empty"
            set_port_direction_and_width "out_empty" "output" $empty_width
        }
    }

    if {$error_width > 0} {
        add_port_to_interface "in" "in_error" "error"
        set_port_direction_and_width "in_error" "input" $error_width
        add_port_to_interface "out" "out_error" "error"
        set_port_direction_and_width "out_error" "output" $error_width
    }

    if {$channel_width > 0} {
        add_port_to_interface "in" "in_channel" "channel"
        set_port_direction_and_width "in_channel" "input" $channel_width
        add_port_to_interface "out" "out_channel" "channel"
        set_port_direction_and_width "out_channel" "output" $channel_width
    }
}

