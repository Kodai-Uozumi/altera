# $Id: //acds/rel-r/9.0sp2/ip/sopc/components/verification/avalon_mm_bfm/avalon_mm_slave_bfm/avalon_mm_slave_bfm_hw.tcl#1 $
# $Revision: #1 $
# $Date: 2009/04/01 $
#------------------------------------------------------------------------------

set_module_property NAME avalon_mm_slave_bfm
set_module_property DISPLAY_NAME avalon_slave_bfm
set_module_property DESCRIPTION "Avalon Slave BFM"
set_module_property AUTHOR "Altera Corporation"
set_module_property VERSION 9.0
set_module_property GROUP "Avalon BFM"
set_module_property TOP_LEVEL_HDL_FILE avalon_mm_slave_bfm.sv
set_module_property TOP_LEVEL_HDL_MODULE avalon_mm_slave_bfm
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ELABORATION_CALLBACK "elaborate"
set_module_property INTERNAL true 

# Files
#---------------------------------------------------------------------
add_file ../../lib/verbosity_pkg.sv {SIMULATION}
add_file ../../lib/avalon_mm_pkg.sv {SIMULATION}
add_file avalon_mm_slave_bfm.sv {SYNTHESIS SIMULATION}

# Parameters
#---------------------------------------------------------------------
set AV_ADDRESS_W_NAME          "AV_ADDRESS_W"
set AV_SYMBOL_W_NAME           "AV_SYMBOL_W" 
set AV_NUMSYMBOLS_NAME         "AV_NUMSYMBOLS"

set AV_BURST_W_NAME            "AV_BURST_W" 
set AV_USE_BURSTS_NAME         "AV_USE_BURSTS"
set AV_MAX_BURST_NAME          "AV_MAX_BURST"
set AV_BURST_TYPE_NAME         "AV_BURST_TYPE"
set AV_BURST_LINEWRAP_NAME     "AV_BURST_LINEWRAP" 
set AV_BURST_BNDR_ONLY_NAME    "AV_BURST_BNDR_ONLY"

set AV_MAX_PENDING_READS_NAME  "AV_MAX_PENDING_READS"
set AV_USE_PIPELINE_READS_NAME "AV_USE_PIPELINE_READS"
set AV_VAR_READ_LATENCY_NAME   "AV_VAR_READ_LATENCY"
set AV_FIX_READ_LATENCY_NAME   "AV_FIX_READ_LATENCY"

set RESPONSE_TIMEOUT_CYCLES_NAME "RESPONSE_TIMEOUT_CYCLES"

add_parameter $AV_ADDRESS_W_NAME int 16
set_parameter_property $AV_ADDRESS_W_NAME DISPLAY_NAME AV_ADDRESS_W
set_parameter_property $AV_ADDRESS_W_NAME AFFECTS_PORT_WIDTHS true

add_parameter $AV_SYMBOL_W_NAME int 8
set_parameter_property $AV_SYMBOL_W_NAME DISPLAY_NAME AV_SYMBOL_W
set_parameter_property $AV_SYMBOL_W_NAME AFFECTS_PORT_WIDTHS true

add_parameter $AV_NUMSYMBOLS_NAME int 4
set_parameter_property $AV_NUMSYMBOLS_NAME DISPLAY_NAME AV_NUMSYMBOLS
set_parameter_property $AV_NUMSYMBOLS_NAME AFFECTS_PORT_WIDTHS true

add_parameter $AV_BURST_W_NAME int 3
set_parameter_property $AV_BURST_W_NAME DISPLAY_NAME AV_BURST_W
set_parameter_property $AV_BURST_W_NAME AFFECTS_PORT_WIDTHS true

add_parameter $AV_USE_BURSTS_NAME int 0
set_parameter_property $AV_USE_BURSTS_NAME DISPLAY_NAME AV_USE_BURSTS

add_parameter $AV_USE_PIPELINE_READS_NAME int 0
set_parameter_property $AV_USE_PIPELINE_READS_NAME DISPLAY_NAME AV_USE_PIPELINE_READS

add_parameter $AV_MAX_BURST_NAME int 4
set_parameter_property $AV_MAX_BURST_NAME DISPLAY_NAME AV_MAX_BURST

add_parameter $AV_MAX_PENDING_READS_NAME int 1
set_parameter_property $AV_MAX_PENDING_READS_NAME DISPLAY_NAME AV_MAX_PENDING_READS

add_parameter $AV_BURST_TYPE_NAME int 2
set_parameter_property $AV_BURST_TYPE_NAME DISPLAY_NAME AV_BURST_TYPE
set_parameter_property $AV_BURST_TYPE_NAME UNITS None
set_parameter_property $AV_BURST_TYPE_NAME AFFECTS_PORT_WIDTHS true

add_parameter $AV_VAR_READ_LATENCY_NAME int 1
set_parameter_property $AV_VAR_READ_LATENCY_NAME DISPLAY_NAME AV_VAR_READ_LATENCY
add_parameter $AV_FIX_READ_LATENCY_NAME int 0
set_parameter_property $AV_FIX_READ_LATENCY_NAME DISPLAY_NAME AV_FIX_READ_LATENCY

add_parameter $AV_BURST_LINEWRAP_NAME int 0
set_parameter_property $AV_BURST_LINEWRAP_NAME DISPLAY_NAME AV_BURST_LINEWRAP

add_parameter $AV_BURST_BNDR_ONLY_NAME int 1
set_parameter_property  $AV_BURST_BNDR_ONLY_NAME DISPLAY_NAME AV_BURST_BNDR_ONLY
add_parameter $RESPONSE_TIMEOUT_CYCLES_NAME int 100
set_parameter_property $RESPONSE_TIMEOUT_CYCLES_NAME DISPLAY_NAME RESPONSE_TIMEOUT_CYCLES

#------------------------------------------------------------------------------
proc elaborate {} {
    global AV_ADDRESS_W_NAME          
    global AV_SYMBOL_W_NAME           
    global AV_NUMSYMBOLS_NAME         
    global AV_BURST_W_NAME            
    global AV_USE_BURSTS_NAME         
    global AV_USE_PIPELINE_READS_NAME 
    global AV_MAX_BURST_NAME          
    global AV_MAX_PENDING_READS_NAME  
    global AV_BURST_TYPE_NAME         
    global AV_VAR_READ_LATENCY_NAME   
    global AV_FIX_READ_LATENCY_NAME   
    global AV_BURST_LINEWRAP_NAME     
    global AV_BURST_BNDR_ONLY_NAME 
    global RESPONSE_TIMEOUT_CYCLES_NAME

    set AV_ADDRESS_W_VALUE          [ get_parameter_value $AV_ADDRESS_W_NAME ]
    set AV_SYMBOL_W_VALUE           [ get_parameter_value $AV_SYMBOL_W_NAME ] 
    set AV_NUMSYMBOLS_VALUE         [ get_parameter_value $AV_NUMSYMBOLS_NAME ]
    set AV_BURST_W_VALUE            [ get_parameter_value $AV_BURST_W_NAME ]
    set AV_USE_BURSTS_VALUE         [ get_parameter_value $AV_USE_BURSTS_NAME ]
    set AV_USE_PIPELINE_READS_VALUE [ get_parameter_value $AV_USE_PIPELINE_READS_NAME ] 
    set AV_MAX_BURST_VALUE          [ get_parameter_value $AV_MAX_BURST_NAME ]
    set AV_MAX_PENDING_READS_VALUE  [ get_parameter_value $AV_MAX_PENDING_READS_NAME ] 
    set AV_BURST_TYPE_VALUE       [ get_parameter_value $AV_BURST_TYPE_NAME ]
    set AV_VAR_READ_LATENCY_VALUE [ get_parameter_value $AV_VAR_READ_LATENCY_NAME ]  
    set AV_FIX_READ_LATENCY_VALUE [ get_parameter_value $AV_FIX_READ_LATENCY_NAME ]  
    set AV_BURST_LINEWRAP_VALUE [ get_parameter_value $AV_BURST_LINEWRAP_NAME ]

    set AV_BURST_BNDR_ONLY_VALUE [ get_parameter_value $AV_BURST_BNDR_ONLY_NAME ]
    set RESPONSE_TIMEOUT_CYCLES_VALUE [ get_parameter_value $RESPONSE_TIMEOUT_CYCLES_NAME ]

    set CLOCK_INTERFACE "clk"
    set SLAVE_INTERFACE "s0"

    # connection point - clock
    #---------------------------------------------------------------------
    add_interface $CLOCK_INTERFACE clock end
    add_interface_port $CLOCK_INTERFACE clk clk Input 1
    add_interface_port $CLOCK_INTERFACE reset reset Input 1

    #  Avalon Slave connection point
    #---------------------------------------------------------------------
    add_interface $SLAVE_INTERFACE avalon end
    set_interface_property $SLAVE_INTERFACE ENABLED true
    set_interface_property $SLAVE_INTERFACE ASSOCIATED_CLOCK $CLOCK_INTERFACE
    set_interface_property $SLAVE_INTERFACE addressAlignment DYNAMIC
    set_interface_property $SLAVE_INTERFACE holdTime 0
    set_interface_property $SLAVE_INTERFACE isMemoryDevice false
    set_interface_property $SLAVE_INTERFACE isNonVolatileStorage false
    set_interface_property $SLAVE_INTERFACE minimumUninterruptedRunLength 1
    set_interface_property $SLAVE_INTERFACE printableDevice false
    set_interface_property $SLAVE_INTERFACE readLatency 0
    set_interface_property $SLAVE_INTERFACE readWaitTime 1
    set_interface_property $SLAVE_INTERFACE setupTime 0
    set_interface_property $SLAVE_INTERFACE timingUnits Cycles
    set_interface_property $SLAVE_INTERFACE writeWaitTime 0


    if { $AV_BURST_BNDR_ONLY_VALUE > 0 } {
	set_interface_property $SLAVE_INTERFACE burstOnBurstBoundariesOnly true
    } else {
	set_interface_property $SLAVE_INTERFACE burstOnBurstBoundariesOnly false
    }
    if { $AV_BURST_LINEWRAP_VALUE > 0 } {
	set_interface_property $SLAVE_INTERFACE linewrapBursts true
    } else {
	set_interface_property $SLAVE_INTERFACE linewrapBursts false
    }


    add_interface_port $SLAVE_INTERFACE waitrequest waitrequest Output 1
    add_interface_port $SLAVE_INTERFACE write write Input 1
    add_interface_port $SLAVE_INTERFACE read read Input 1
    add_interface_port $SLAVE_INTERFACE address address Input $AV_ADDRESS_W_VALUE
    add_interface_port $SLAVE_INTERFACE byteenable byteenable Input $AV_NUMSYMBOLS_VALUE
    add_interface_port $SLAVE_INTERFACE burstcount burstcount Input $AV_BURST_W_VALUE
    add_interface_port $SLAVE_INTERFACE beginbursttransfer beginbursttransfer Input 1
    add_interface_port $SLAVE_INTERFACE begintransfer begintransfer Input 1
    add_interface_port $SLAVE_INTERFACE writedata writedata Input [expr {$AV_SYMBOL_W_VALUE * $AV_NUMSYMBOLS_VALUE }]
    add_interface_port $SLAVE_INTERFACE readdata readdata Output [expr {$AV_SYMBOL_W_VALUE * $AV_NUMSYMBOLS_VALUE }]
    add_interface_port $SLAVE_INTERFACE readdatavalid readdatavalid Output 1

    set_interface_property $SLAVE_INTERFACE maximumPendingReadTransactions $AV_MAX_PENDING_READS_VALUE

}


