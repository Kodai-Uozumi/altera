package provide ::qboard::de1 1.0

# ----------------------------------------------------------------
#
namespace eval ::qboard::de1 {
#
# Description: DE2 Configuration
#
# ----------------------------------------------------------------


	namespace export get_name
	namespace export get_revision
	namespace export set_default_assignments 

    # Declare Global Variables Here!
    # DO NOT EXPORT ANY OF THESE!
    
    variable pvcs_revision [regsub -nocase -- {\$revision:\s*(\S+)\s*\$} {$Revision: #1 $} {\1}]
    variable board_name "DE1 Board"
}

# ----------------------------------------------------------------
#
proc ::qboard::de1::get_revision { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable pvcs_revision
	return $pvcs_revision
}

# ----------------------------------------------------------------
#
proc ::qboard::de1::get_name { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable board_name
	return $board_name
}

# ----------------------------------------------------------------
#
proc ::qboard::de1::set_default_assignments { } {
	#
	# Description: Make all required QSF assignments
	#
	# ----------------------------------------------------------------

	# Set QBOARD's Family and Device
	set_global_assignment -name FAMILY "Cyclone II"
	set_global_assignment -name DEVICE "EP2C20F484C7"

	# Pin & Location Assignments
	# ==========================
	set_location_assignment PIN_A13 -to GPIO_0[0] -tag qboard
	set_location_assignment PIN_B13 -to GPIO_0[1] -tag qboard
	set_location_assignment PIN_A14 -to GPIO_0[2] -tag qboard
	set_location_assignment PIN_B14 -to GPIO_0[3] -tag qboard
	set_location_assignment PIN_A15 -to GPIO_0[4] -tag qboard
	set_location_assignment PIN_B15 -to GPIO_0[5] -tag qboard
	set_location_assignment PIN_A16 -to GPIO_0[6] -tag qboard
	set_location_assignment PIN_B16 -to GPIO_0[7] -tag qboard
	set_location_assignment PIN_A17 -to GPIO_0[8] -tag qboard
	set_location_assignment PIN_B17 -to GPIO_0[9] -tag qboard
	set_location_assignment PIN_A18 -to GPIO_0[10] -tag qboard
	set_location_assignment PIN_B18 -to GPIO_0[11] -tag qboard
	set_location_assignment PIN_A19 -to GPIO_0[12] -tag qboard
	set_location_assignment PIN_B19 -to GPIO_0[13] -tag qboard
	set_location_assignment PIN_A20 -to GPIO_0[14] -tag qboard
	set_location_assignment PIN_B20 -to GPIO_0[15] -tag qboard
	set_location_assignment PIN_C21 -to GPIO_0[16] -tag qboard
	set_location_assignment PIN_C22 -to GPIO_0[17] -tag qboard
	set_location_assignment PIN_D21 -to GPIO_0[18] -tag qboard
	set_location_assignment PIN_D22 -to GPIO_0[19] -tag qboard
	set_location_assignment PIN_E21 -to GPIO_0[20] -tag qboard
	set_location_assignment PIN_E22 -to GPIO_0[21] -tag qboard
	set_location_assignment PIN_F21 -to GPIO_0[22] -tag qboard
	set_location_assignment PIN_F22 -to GPIO_0[23] -tag qboard
	set_location_assignment PIN_G21 -to GPIO_0[24] -tag qboard
	set_location_assignment PIN_G22 -to GPIO_0[25] -tag qboard
	set_location_assignment PIN_J21 -to GPIO_0[26] -tag qboard
	set_location_assignment PIN_J22 -to GPIO_0[27] -tag qboard
	set_location_assignment PIN_K21 -to GPIO_0[28] -tag qboard
	set_location_assignment PIN_K22 -to GPIO_0[29] -tag qboard
	set_location_assignment PIN_J19 -to GPIO_0[30] -tag qboard
	set_location_assignment PIN_J20 -to GPIO_0[31] -tag qboard
	set_location_assignment PIN_J18 -to GPIO_0[32] -tag qboard
	set_location_assignment PIN_K20 -to GPIO_0[33] -tag qboard
	set_location_assignment PIN_L19 -to GPIO_0[34] -tag qboard
	set_location_assignment PIN_L18 -to GPIO_0[35] -tag qboard
	set_location_assignment PIN_H12 -to GPIO_1[0] -tag qboard
	set_location_assignment PIN_H13 -to GPIO_1[1] -tag qboard
	set_location_assignment PIN_H14 -to GPIO_1[2] -tag qboard
	set_location_assignment PIN_G15 -to GPIO_1[3] -tag qboard
	set_location_assignment PIN_E14 -to GPIO_1[4] -tag qboard
	set_location_assignment PIN_E15 -to GPIO_1[5] -tag qboard
	set_location_assignment PIN_F15 -to GPIO_1[6] -tag qboard
	set_location_assignment PIN_G16 -to GPIO_1[7] -tag qboard
	set_location_assignment PIN_F12 -to GPIO_1[8] -tag qboard
	set_location_assignment PIN_F13 -to GPIO_1[9] -tag qboard
	set_location_assignment PIN_C14 -to GPIO_1[10] -tag qboard
	set_location_assignment PIN_D14 -to GPIO_1[11] -tag qboard
	set_location_assignment PIN_D15 -to GPIO_1[12] -tag qboard
	set_location_assignment PIN_D16 -to GPIO_1[13] -tag qboard
	set_location_assignment PIN_C17 -to GPIO_1[14] -tag qboard
	set_location_assignment PIN_C18 -to GPIO_1[15] -tag qboard
	set_location_assignment PIN_C19 -to GPIO_1[16] -tag qboard
	set_location_assignment PIN_C20 -to GPIO_1[17] -tag qboard
	set_location_assignment PIN_D19 -to GPIO_1[18] -tag qboard
	set_location_assignment PIN_D20 -to GPIO_1[19] -tag qboard
	set_location_assignment PIN_E20 -to GPIO_1[20] -tag qboard
	set_location_assignment PIN_F20 -to GPIO_1[21] -tag qboard
	set_location_assignment PIN_E19 -to GPIO_1[22] -tag qboard
	set_location_assignment PIN_E18 -to GPIO_1[23] -tag qboard
	set_location_assignment PIN_G20 -to GPIO_1[24] -tag qboard
	set_location_assignment PIN_G18 -to GPIO_1[25] -tag qboard
	set_location_assignment PIN_G17 -to GPIO_1[26] -tag qboard
	set_location_assignment PIN_H17 -to GPIO_1[27] -tag qboard
	set_location_assignment PIN_J15 -to GPIO_1[28] -tag qboard
	set_location_assignment PIN_H18 -to GPIO_1[29] -tag qboard
	set_location_assignment PIN_N22 -to GPIO_1[30] -tag qboard
	set_location_assignment PIN_N21 -to GPIO_1[31] -tag qboard
	set_location_assignment PIN_P15 -to GPIO_1[32] -tag qboard
	set_location_assignment PIN_N15 -to GPIO_1[33] -tag qboard
	set_location_assignment PIN_P17 -to GPIO_1[34] -tag qboard
	set_location_assignment PIN_P18 -to GPIO_1[35] -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[0] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[1] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[2] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[3] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[4] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[5] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[6] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[7] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[8] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[9] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[10] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[11] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[12] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[13] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[14] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[15] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[16] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[17] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[18] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[19] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[20] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[21] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[22] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[23] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[24] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[25] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[26] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[27] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[28] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[29] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[30] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[31] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[32] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[33] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[34] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_0[35] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[0] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[1] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[2] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[3] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[4] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[5] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[6] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[7] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[8] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[9] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[10] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[11] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[12] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[13] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[14] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[15] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[16] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[17] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[18] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[19] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[20] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[21] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[22] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[23] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[24] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[25] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[26] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[27] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[28] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[29] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[30] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[31] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[32] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[33] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[34] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to GPIO_1[35] -tag aboard
	set_location_assignment PIN_L22 -to SW[0] -tag qboard
	set_location_assignment PIN_L21 -to SW[1] -tag qboard
	set_location_assignment PIN_M22 -to SW[2] -tag qboard
	set_location_assignment PIN_V12 -to SW[3] -tag qboard
	set_location_assignment PIN_W12 -to SW[4] -tag qboard
	set_location_assignment PIN_U12 -to SW[5] -tag qboard
	set_location_assignment PIN_U11 -to SW[6] -tag qboard
	set_location_assignment PIN_M2 -to SW[7] -tag qboard
	set_location_assignment PIN_M1 -to SW[8] -tag qboard
	set_location_assignment PIN_L2 -to SW[9] -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to SW[0] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to SW[1] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to SW[2] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to SW[3] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to SW[4] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to SW[5] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to SW[6] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to SW[7] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to SW[8] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to SW[9] -tag aboard
	set_location_assignment PIN_J2 -to HEX0[0] -tag qboard
	set_location_assignment PIN_J1 -to HEX0[1] -tag qboard
	set_location_assignment PIN_H2 -to HEX0[2] -tag qboard
	set_location_assignment PIN_H1 -to HEX0[3] -tag qboard
	set_location_assignment PIN_F2 -to HEX0[4] -tag qboard
	set_location_assignment PIN_F1 -to HEX0[5] -tag qboard
	set_location_assignment PIN_E2 -to HEX0[6] -tag qboard
	set_location_assignment PIN_E1 -to HEX1[0] -tag qboard
	set_location_assignment PIN_H6 -to HEX1[1] -tag qboard
	set_location_assignment PIN_H5 -to HEX1[2] -tag qboard
	set_location_assignment PIN_H4 -to HEX1[3] -tag qboard
	set_location_assignment PIN_G3 -to HEX1[4] -tag qboard
	set_location_assignment PIN_D2 -to HEX1[5] -tag qboard
	set_location_assignment PIN_D1 -to HEX1[6] -tag qboard
	set_location_assignment PIN_G5 -to HEX2[0] -tag qboard
	set_location_assignment PIN_G6 -to HEX2[1] -tag qboard
	set_location_assignment PIN_C2 -to HEX2[2] -tag qboard
	set_location_assignment PIN_C1 -to HEX2[3] -tag qboard
	set_location_assignment PIN_E3 -to HEX2[4] -tag qboard
	set_location_assignment PIN_E4 -to HEX2[5] -tag qboard
	set_location_assignment PIN_D3 -to HEX2[6] -tag qboard
	set_location_assignment PIN_F4 -to HEX3[0] -tag qboard
	set_location_assignment PIN_D5 -to HEX3[1] -tag qboard
	set_location_assignment PIN_D6 -to HEX3[2] -tag qboard
	set_location_assignment PIN_J4 -to HEX3[3] -tag qboard
	set_location_assignment PIN_L8 -to HEX3[4] -tag qboard
	set_location_assignment PIN_F3 -to HEX3[5] -tag qboard
	set_location_assignment PIN_D4 -to HEX3[6] -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX0[0] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX0[1] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX0[2] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX0[3] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX0[4] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX0[5] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX0[6] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX1[0] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX1[1] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX1[2] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX1[3] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX1[4] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX1[5] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX1[6] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX2[0] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX2[1] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX2[2] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX2[3] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX2[4] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX2[5] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX2[6] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX3[0] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX3[1] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX3[2] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX3[3] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX3[4] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX3[5] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to HEX3[6] -tag aboard
	set_location_assignment PIN_R22 -to KEY[0] -tag qboard
	set_location_assignment PIN_R21 -to KEY[1] -tag qboard
	set_location_assignment PIN_T22 -to KEY[2] -tag qboard
	set_location_assignment PIN_T21 -to KEY[3] -tag qboard
	set_location_assignment PIN_R20 -to LEDR[0] -tag qboard
	set_location_assignment PIN_R19 -to LEDR[1] -tag qboard
	set_location_assignment PIN_U19 -to LEDR[2] -tag qboard
	set_location_assignment PIN_Y19 -to LEDR[3] -tag qboard
	set_location_assignment PIN_T18 -to LEDR[4] -tag qboard
	set_location_assignment PIN_V19 -to LEDR[5] -tag qboard
	set_location_assignment PIN_Y18 -to LEDR[6] -tag qboard
	set_location_assignment PIN_U18 -to LEDR[7] -tag qboard
	set_location_assignment PIN_R18 -to LEDR[8] -tag qboard
	set_location_assignment PIN_R17 -to LEDR[9] -tag qboard
	set_location_assignment PIN_U22 -to LEDG[0] -tag qboard
	set_location_assignment PIN_U21 -to LEDG[1] -tag qboard
	set_location_assignment PIN_V22 -to LEDG[2] -tag qboard
	set_location_assignment PIN_V21 -to LEDG[3] -tag qboard
	set_location_assignment PIN_W22 -to LEDG[4] -tag qboard
	set_location_assignment PIN_W21 -to LEDG[5] -tag qboard
	set_location_assignment PIN_Y22 -to LEDG[6] -tag qboard
	set_location_assignment PIN_Y21 -to LEDG[7] -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to KEY[0] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to KEY[1] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to KEY[2] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to KEY[3] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to LEDR[0] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to LEDR[1] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to LEDR[2] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to LEDR[3] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to LEDR[4] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to LEDR[5] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to LEDR[6] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to LEDR[7] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to LEDR[8] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to LEDR[9] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to LEDG[0] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to LEDG[1] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to LEDG[2] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to LEDG[3] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to LEDG[4] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to LEDG[5] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to LEDG[6] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to LEDG[7] -tag aboard
	set_location_assignment PIN_D12 -to CLOCK_27[0] -tag qboard
	set_location_assignment PIN_E12 -to CLOCK_27[1] -tag qboard
	set_location_assignment PIN_B12 -to CLOCK_24[0] -tag qboard
	set_location_assignment PIN_A12 -to CLOCK_24[1] -tag qboard
	set_location_assignment PIN_L1 -to CLOCK_50 -tag qboard
	set_location_assignment PIN_M21 -to EXT_CLOCK -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to CLOCK_27[1] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to CLOCK_24[0] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to CLOCK_24[1] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to CLOCK_50 -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to EXT_CLOCK -tag aboard
	set_location_assignment PIN_H15 -to PS2_CLK -tag qboard
	set_location_assignment PIN_J14 -to PS2_DAT -tag qboard
	set_location_assignment PIN_F14 -to UART_RXD -tag qboard
	set_location_assignment PIN_G12 -to UART_TXD -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to PS2_CLK -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to PS2_DAT -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to UART_RXD -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to UART_TXD -tag aboard
	set_location_assignment PIN_E8 -to TDI -tag qboard
	set_location_assignment PIN_D8 -to TCS -tag qboard
	set_location_assignment PIN_C7 -to TCK -tag qboard
	set_location_assignment PIN_D7 -to TDO -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to TDI -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to TCS -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to TCK -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to TDO -tag aboard
	set_location_assignment PIN_D9 -to VGA_R[0] -tag qboard
	set_location_assignment PIN_C9 -to VGA_R[1] -tag qboard
	set_location_assignment PIN_A7 -to VGA_R[2] -tag qboard
	set_location_assignment PIN_B7 -to VGA_R[3] -tag qboard
	set_location_assignment PIN_B8 -to VGA_G[0] -tag qboard
	set_location_assignment PIN_C10 -to VGA_G[1] -tag qboard
	set_location_assignment PIN_B9 -to VGA_G[2] -tag qboard
	set_location_assignment PIN_A8 -to VGA_G[3] -tag qboard
	set_location_assignment PIN_A9 -to VGA_B[0] -tag qboard
	set_location_assignment PIN_D11 -to VGA_B[1] -tag qboard
	set_location_assignment PIN_A10 -to VGA_B[2] -tag qboard
	set_location_assignment PIN_B10 -to VGA_B[3] -tag qboard
	set_location_assignment PIN_A11 -to VGA_HS -tag qboard
	set_location_assignment PIN_B11 -to VGA_VS -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to VGA_R[0] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to VGA_R[1] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to VGA_R[2] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to VGA_R[3] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to VGA_G[0] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to VGA_G[1] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to VGA_G[2] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to VGA_G[3] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to VGA_B[0] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to VGA_B[1] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to VGA_B[2] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to VGA_B[3] -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to VGA_HS -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to VGA_VS -tag aboard
	set_location_assignment PIN_A3 -to I2C_SCLK -tag qboard
	set_location_assignment PIN_B3 -to I2C_SDAT -tag qboard
	set_location_assignment PIN_A6 -to AUD_ADCLRCK -tag qboard
	set_location_assignment PIN_B6 -to AUD_ADCDAT -tag qboard
	set_location_assignment PIN_A5 -to AUD_DACLRCK -tag qboard
	set_location_assignment PIN_B5 -to AUD_DACDAT -tag qboard
	set_location_assignment PIN_B4 -to AUD_XCK -tag qboard
	set_location_assignment PIN_A4 -to AUD_BCLK -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to I2C_SCLK -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to I2C_SDAT -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to AUD_ADCLRCK -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to AUD_ADCDAT -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to AUD_DACLRCK -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to AUD_DACDAT -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to AUD_XCK -tag aboard
	set_instance_assignment -name IO_STANDARD LVTTL -to AUD_BCLK -tag aboard
	set_location_assignment PIN_W4 -to DRAM_ADDR[0] -tag qboard
	set_location_assignment PIN_W5 -to DRAM_ADDR[1] -tag qboard
	set_location_assignment PIN_Y3 -to DRAM_ADDR[2] -tag qboard
	set_location_assignment PIN_Y4 -to DRAM_ADDR[3] -tag qboard
	set_location_assignment PIN_R6 -to DRAM_ADDR[4] -tag qboard
	set_location_assignment PIN_R5 -to DRAM_ADDR[5] -tag qboard
	set_location_assignment PIN_P6 -to DRAM_ADDR[6] -tag qboard
	set_location_assignment PIN_P5 -to DRAM_ADDR[7] -tag qboard
	set_location_assignment PIN_P3 -to DRAM_ADDR[8] -tag qboard
	set_location_assignment PIN_N4 -to DRAM_ADDR[9] -tag qboard
	set_location_assignment PIN_W3 -to DRAM_ADDR[10] -tag qboard
	set_location_assignment PIN_N6 -to DRAM_ADDR[11] -tag qboard
	set_location_assignment PIN_U3 -to DRAM_BA_0 -tag qboard
	set_location_assignment PIN_V4 -to DRAM_BA_1 -tag qboard
	set_location_assignment PIN_T3 -to DRAM_CAS_N -tag qboard
	set_location_assignment PIN_N3 -to DRAM_CKE -tag qboard
	set_location_assignment PIN_U4 -to DRAM_CLK -tag qboard
	set_location_assignment PIN_T6 -to DRAM_CS_N -tag qboard
	set_location_assignment PIN_U1 -to DRAM_DQ[0] -tag qboard
	set_location_assignment PIN_U2 -to DRAM_DQ[1] -tag qboard
	set_location_assignment PIN_V1 -to DRAM_DQ[2] -tag qboard
	set_location_assignment PIN_V2 -to DRAM_DQ[3] -tag qboard
	set_location_assignment PIN_W1 -to DRAM_DQ[4] -tag qboard
	set_location_assignment PIN_W2 -to DRAM_DQ[5] -tag qboard
	set_location_assignment PIN_Y1 -to DRAM_DQ[6] -tag qboard
	set_location_assignment PIN_Y2 -to DRAM_DQ[7] -tag qboard
	set_location_assignment PIN_N1 -to DRAM_DQ[8] -tag qboard
	set_location_assignment PIN_N2 -to DRAM_DQ[9] -tag qboard
	set_location_assignment PIN_P1 -to DRAM_DQ[10] -tag qboard
	set_location_assignment PIN_P2 -to DRAM_DQ[11] -tag qboard
	set_location_assignment PIN_R1 -to DRAM_DQ[12] -tag qboard
	set_location_assignment PIN_R2 -to DRAM_DQ[13] -tag qboard
	set_location_assignment PIN_T1 -to DRAM_DQ[14] -tag qboard
	set_location_assignment PIN_T2 -to DRAM_DQ[15] -tag qboard
	set_location_assignment PIN_R7 -to DRAM_LDQM -tag qboard
	set_location_assignment PIN_T5 -to DRAM_RAS_N -tag qboard
	set_location_assignment PIN_M5 -to DRAM_UDQM -tag qboard
	set_location_assignment PIN_R8 -to DRAM_WE_N -tag qboard
	set_location_assignment PIN_AB20 -to FL_ADDR[0] -tag qboard
	set_location_assignment PIN_AA14 -to FL_ADDR[1] -tag qboard
	set_location_assignment PIN_Y16 -to FL_ADDR[2] -tag qboard
	set_location_assignment PIN_R15 -to FL_ADDR[3] -tag qboard
	set_location_assignment PIN_T15 -to FL_ADDR[4] -tag qboard
	set_location_assignment PIN_U15 -to FL_ADDR[5] -tag qboard
	set_location_assignment PIN_V15 -to FL_ADDR[6] -tag qboard
	set_location_assignment PIN_W15 -to FL_ADDR[7] -tag qboard
	set_location_assignment PIN_R14 -to FL_ADDR[8] -tag qboard
	set_location_assignment PIN_Y13 -to FL_ADDR[9] -tag qboard
	set_location_assignment PIN_R12 -to FL_ADDR[10] -tag qboard
	set_location_assignment PIN_T12 -to FL_ADDR[11] -tag qboard
	set_location_assignment PIN_AB14 -to FL_ADDR[12] -tag qboard
	set_location_assignment PIN_AA13 -to FL_ADDR[13] -tag qboard
	set_location_assignment PIN_AB13 -to FL_ADDR[14] -tag qboard
	set_location_assignment PIN_AA12 -to FL_ADDR[15] -tag qboard
	set_location_assignment PIN_AB12 -to FL_ADDR[16] -tag qboard
	set_location_assignment PIN_AA20 -to FL_ADDR[17] -tag qboard
	set_location_assignment PIN_U14 -to FL_ADDR[18] -tag qboard
	set_location_assignment PIN_V14 -to FL_ADDR[19] -tag qboard
	set_location_assignment PIN_U13 -to FL_ADDR[20] -tag qboard
	set_location_assignment PIN_R13 -to FL_ADDR[21] -tag qboard
	set_location_assignment PIN_AB16 -to FL_DQ[0] -tag qboard
	set_location_assignment PIN_AA16 -to FL_DQ[1] -tag qboard
	set_location_assignment PIN_AB17 -to FL_DQ[2] -tag qboard
	set_location_assignment PIN_AA17 -to FL_DQ[3] -tag qboard
	set_location_assignment PIN_AB18 -to FL_DQ[4] -tag qboard
	set_location_assignment PIN_AA18 -to FL_DQ[5] -tag qboard
	set_location_assignment PIN_AB19 -to FL_DQ[6] -tag qboard
	set_location_assignment PIN_AA19 -to FL_DQ[7] -tag qboard
	set_location_assignment PIN_AA15 -to FL_OE_N -tag qboard
	set_location_assignment PIN_W14 -to FL_RST_N -tag qboard
	set_location_assignment PIN_Y14 -to FL_WE_N -tag qboard
	set_location_assignment PIN_AA3 -to SRAM_ADDR[0] -tag qboard
	set_location_assignment PIN_AB3 -to SRAM_ADDR[1] -tag qboard
	set_location_assignment PIN_AA4 -to SRAM_ADDR[2] -tag qboard
	set_location_assignment PIN_AB4 -to SRAM_ADDR[3] -tag qboard
	set_location_assignment PIN_AA5 -to SRAM_ADDR[4] -tag qboard
	set_location_assignment PIN_AB10 -to SRAM_ADDR[5] -tag qboard
	set_location_assignment PIN_AA11 -to SRAM_ADDR[6] -tag qboard
	set_location_assignment PIN_AB11 -to SRAM_ADDR[7] -tag qboard
	set_location_assignment PIN_V11 -to SRAM_ADDR[8] -tag qboard
	set_location_assignment PIN_W11 -to SRAM_ADDR[9] -tag qboard
	set_location_assignment PIN_R11 -to SRAM_ADDR[10] -tag qboard
	set_location_assignment PIN_T11 -to SRAM_ADDR[11] -tag qboard
	set_location_assignment PIN_Y10 -to SRAM_ADDR[12] -tag qboard
	set_location_assignment PIN_U10 -to SRAM_ADDR[13] -tag qboard
	set_location_assignment PIN_R10 -to SRAM_ADDR[14] -tag qboard
	set_location_assignment PIN_T7 -to SRAM_ADDR[15] -tag qboard
	set_location_assignment PIN_Y6 -to SRAM_ADDR[16] -tag qboard
	set_location_assignment PIN_Y5 -to SRAM_ADDR[17] -tag qboard
	set_location_assignment PIN_AB5 -to SRAM_CE_N -tag qboard
	set_location_assignment PIN_AA6 -to SRAM_DQ[0] -tag qboard
	set_location_assignment PIN_AB6 -to SRAM_DQ[1] -tag qboard
	set_location_assignment PIN_AA7 -to SRAM_DQ[2] -tag qboard
	set_location_assignment PIN_AB7 -to SRAM_DQ[3] -tag qboard
	set_location_assignment PIN_AA8 -to SRAM_DQ[4] -tag qboard
	set_location_assignment PIN_AB8 -to SRAM_DQ[5] -tag qboard
	set_location_assignment PIN_AA9 -to SRAM_DQ[6] -tag qboard
	set_location_assignment PIN_AB9 -to SRAM_DQ[7] -tag qboard
	set_location_assignment PIN_Y9 -to SRAM_DQ[8] -tag qboard
	set_location_assignment PIN_W9 -to SRAM_DQ[9] -tag qboard
	set_location_assignment PIN_V9 -to SRAM_DQ[10] -tag qboard
	set_location_assignment PIN_U9 -to SRAM_DQ[11] -tag qboard
	set_location_assignment PIN_R9 -to SRAM_DQ[12] -tag qboard
	set_location_assignment PIN_W8 -to SRAM_DQ[13] -tag qboard
	set_location_assignment PIN_V8 -to SRAM_DQ[14] -tag qboard
	set_location_assignment PIN_U8 -to SRAM_DQ[15] -tag qboard
	set_location_assignment PIN_Y7 -to SRAM_LB_N -tag qboard
	set_location_assignment PIN_T8 -to SRAM_OE_N -tag qboard
	set_location_assignment PIN_W7 -to SRAM_UB_N -tag qboard
	set_location_assignment PIN_AA10 -to SRAM_WE_N -tag qboard

	# Other Assignments
	# =====================
	set_global_assignment -name STRATIX_DEVICE_IO_STANDARD LVTTL -tag qboard
	set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO" -tag qboard
	set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED" -tag qboard
	set_global_assignment -name RESERVE_ASDO_AFTER_CONFIGURATION "AS OUTPUT DRIVING AN UNSPECIFIED SIGNAL" -tag qboard
	set_global_assignment -name RESERVE_ALL_UNUSED_PINS_NO_OUTPUT_GND "AS INPUT TRI-STATED" -tag qboard
	set_global_assignment -name STRATIX_CONFIGURATION_DEVICE EPCS16 -tag qboard

}
