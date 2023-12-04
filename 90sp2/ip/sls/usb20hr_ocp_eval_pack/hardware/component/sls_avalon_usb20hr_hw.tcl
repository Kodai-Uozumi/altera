set_module_property NAME "sls_avalon_usb20hr"
set_module_property description "USB2.0 High Speed Device"
set_module_property AUTHOR "System Level Solutions (I) Pvt. Ltd."
set_module_property TOP_LEVEL_HDL_FILE sls_avalon_usb20hr.v
set_module_property TOP_LEVEL_HDL_MODULE sls_avalon_usb20hr
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property DATASHEET_URL "file://[get_module_property MODULE_DIRECTORY]info.htm"

add_file "hdl/control_ep_reg.v" {SYNTHESIS}
add_file "hdl/Enum_ram.v" {SYNTHESIS}
add_file "hdl/ep_register.v" {SYNTHESIS}
add_file "hdl/ep_register_dummy.v" {SYNTHESIS}
add_file "hdl/mem_arbitration.v" {SYNTHESIS}
add_file "hdl/memory_idma.v" {SYNTHESIS}
add_file "hdl/pkt_assembler.v" {SYNTHESIS}
add_file "hdl/pkt_deassembler.v" {SYNTHESIS}
add_file "hdl/proto_engine.v" {SYNTHESIS}
add_file "hdl/proto_layer.v" {SYNTHESIS}
add_file "hdl/registers.v" {SYNTHESIS}
add_file "hdl/sls_avalon_usb20hr.v" {SYNTHESIS}
add_file "hdl/SramCtrl.v" {SYNTHESIS}
add_file "hdl/Test_mode.v" {SYNTHESIS}
add_file "hdl/Test_mode_ROM.v" {SYNTHESIS}
add_file "hdl/Ulpi_config.v" {SYNTHESIS}
add_file "hdl/Ulpi_Rx.v" {SYNTHESIS}
add_file "hdl/Ulpi_Tx.v" {SYNTHESIS}
add_file "hdl/Ulpi_Wrapper.v" {SYNTHESIS}
add_file "hdl/usb_avalon.v" {SYNTHESIS}
add_file "hdl/usb_crc16.v" {SYNTHESIS}
add_file "hdl/usb_crc5.v" {SYNTHESIS}
add_file "hdl/usb_defines.v" {SYNTHESIS}
add_file "hdl/usb_ep0buf_cnt.v" {SYNTHESIS}
add_file "hdl/usb_top.v" {SYNTHESIS}
add_file "hdl/utmi_interface.v" {SYNTHESIS}



set_module_property "display_name" "USB20HR -- SLS"
set_module_property "group" "USB"
set_module_property "icon_path" "hdl/SLS_logo.jpg"
set_module_property "version" "2.2"

# callouts
set_module_property Validation_Callback validate
set_module_property Elaboration_Callback elaborate


# Module parameters
add_parameter "Simulation" "integer" "0" "0 = no simulation; 1 = simulation"
set_parameter_property "Simulation" "display_name" "Enter Simulation Option"
set_parameter_property "Simulation" ALLOWED_RANGES {0 1}
add_parameter "Interface_sel" "integer" "1" "0 = ULPI; 1 = UTMI"
set_parameter_property "Interface_sel" "display_name" "UTMI / ULPI Option"
set_parameter_property "Interface_sel" ALLOWED_RANGES {0 1}
add_parameter "Enum_data_file" "string" "Enum_ram.hex" ""
set_parameter_property "Enum_data_file" "displayName" "Hex File Path"

proc elaborate {} {
	set Interface_sel [ get_parameter_value "Interface_sel" ]

	# Interface clock
	add_interface "clock" "clock" "sink" "asynchronous"
	# Ports in interface clock
	add_interface_port "clock" "clk" "clk" "input" 1
	add_interface_port "clock" "reset_n" "reset_n" "input" 1

	# Interface avalon_slave_0
	add_interface "avalon_slave_0" "avalon" "slave" "clock"
	set_interface_property "avalon_slave_0" "isNonVolatileStorage" "false"
	set_interface_property "avalon_slave_0" "burstOnBurstBoundariesOnly" "false"
	set_interface_property "avalon_slave_0" "readLatency" "0"
	set_interface_property "avalon_slave_0" "holdTime" "0"
	set_interface_property "avalon_slave_0" "printableDevice" "false"
	set_interface_property "avalon_slave_0" "readWaitTime" "1"
	set_interface_property "avalon_slave_0" "setupTime" "0"
	set_interface_property "avalon_slave_0" "addressAlignment" "DYNAMIC"
	set_interface_property "avalon_slave_0" "writeWaitTime" "0"
	set_interface_property "avalon_slave_0" "timingUnits" "Cycles"
	set_interface_property "avalon_slave_0" "minimumUninterruptedRunLength" "1"
	set_interface_property "avalon_slave_0" "isMemoryDevice" "false"
	set_interface_property "avalon_slave_0" "linewrapBursts" "false"
	set_interface_property "avalon_slave_0" "maximumPendingReadTransactions" "0"
	# Ports in interface avalon_slave_0
	add_interface_port "avalon_slave_0" "address" "address" "input" 19
	add_interface_port "avalon_slave_0" "writedata" "writedata" "input" 32
	add_interface_port "avalon_slave_0" "chipselect" "chipselect" "input" 1
	add_interface_port "avalon_slave_0" "write_n" "write_n" "input" 1
	add_interface_port "avalon_slave_0" "read_n" "read_n" "input" 1
	add_interface_port "avalon_slave_0" "byteenable_n" "byteenable_n" "input" 4
	add_interface_port "avalon_slave_0" "readdata" "readdata" "output" 32
	add_interface_port "avalon_slave_0" "waitrequest" "waitrequest" "output" 1

	# Interface irq0
	add_interface "irq0" "interrupt" "sender" "clock"
	set_interface_property "irq0" "associatedAddressablePoint" "avalon_slave_0"
	#
	set_interface_property "irq0" "irqScheme" "NONE"
	# Ports in interface irq0
	add_interface_port "irq0" "irq" "irq" "output" 1

	
	# interface-specific signals
	# Export signals
	add_interface "conduit_end" "conduit" "end" "clock"
	# Data is part of both UTMI and ULPI
	add_interface_port "conduit_end" "Data" "export" "bidir" 8

	if {$Interface_sel == 0} {
		# ULPI Signals
		add_interface_port "conduit_end" "Stp" "export" "output" 1
		add_interface_port "conduit_end" "Dir" "export" "input" 1
		add_interface_port "conduit_end" "Nxt" "export" "input" 1
	} else {
		# UTMI Signals
		add_interface_port "conduit_end" "TxValid" "export" "output" 1
		add_interface_port "conduit_end" "XcvSelect" "export" "output" 1
		add_interface_port "conduit_end" "TermSel" "export" "output" 1
		add_interface_port "conduit_end" "SuspendM" "export" "output" 1
		add_interface_port "conduit_end" "OpMode" "export" "output" 2
		add_interface_port "conduit_end" "TxReady" "export" "input" 1
		add_interface_port "conduit_end" "RxValid" "export" "input" 1
		add_interface_port "conduit_end" "RxActive" "export" "input" 1
		add_interface_port "conduit_end" "RxError" "export" "input" 1
		add_interface_port "conduit_end" "LineState" "export" "input" 2
		add_interface_port "conduit_end" "usb_vbus" "export" "input" 1
	}
	
}

# validate parameters
proc validate {} {
	set Simulation [ get_parameter_value "Simulation" ]
	if {$Simulation == 0} {
		send_message "info" "Disabling simulation."
	} else {
		send_message "info" "Enabling simulation."
	}

	set Interface_sel [ get_parameter_value "Interface_sel" ]
	if {$Interface_sel == 0} {
		send_message "info" "Using ULPI."
	} else {
		send_message "info" "Using UTMI."
	}
	
	set Enum_data_file [ get_parameter_value "Enum_data_file" ]
	send_message "info" "Use ' / ' instead of ' \\ ' in Hex file path name"
	send_message "info" "Hex file : $Enum_data_file."
	
}

# custom GUI, in a future release
proc edit {} {
}