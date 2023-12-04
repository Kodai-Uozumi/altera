package provide ::qboard::de2 1.0

# ----------------------------------------------------------------
#
namespace eval ::qboard::de2 {
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
    variable board_name "DE2 Board"
}

# ----------------------------------------------------------------
#
proc ::qboard::de2::get_revision { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable pvcs_revision
	return $pvcs_revision
}

# ----------------------------------------------------------------
#
proc ::qboard::de2::get_name { } {
#
# Description: Get revision
#
# ----------------------------------------------------------------

	variable board_name
	return $board_name
}

# ----------------------------------------------------------------
#
proc ::qboard::de2::set_default_assignments { } {
#
# Description: Make all required QSF assignments
#
# ----------------------------------------------------------------

	# Set QBOARD's Family and Device
	set_global_assignment -name FAMILY "Cyclone II"
	set_global_assignment -name DEVICE "EP2C35F672C6"

	# Pin & Location Assignments
	# ==========================
	set_location_assignment PIN_N25 -to SW[0] -tag qboard
	set_location_assignment PIN_N26 -to SW[1] -tag qboard
	set_location_assignment PIN_P25 -to SW[2] -tag qboard
	set_location_assignment PIN_AE14 -to SW[3] -tag qboard
	set_location_assignment PIN_AF14 -to SW[4] -tag qboard
	set_location_assignment PIN_AD13 -to SW[5] -tag qboard
	set_location_assignment PIN_AC13 -to SW[6] -tag qboard
	set_location_assignment PIN_C13 -to SW[7] -tag qboard
	set_location_assignment PIN_B13 -to SW[8] -tag qboard
	set_location_assignment PIN_A13 -to SW[9] -tag qboard
	set_location_assignment PIN_N1 -to SW[10] -tag qboard
	set_location_assignment PIN_P1 -to SW[11] -tag qboard
	set_location_assignment PIN_P2 -to SW[12] -tag qboard
	set_location_assignment PIN_T7 -to SW[13] -tag qboard
	set_location_assignment PIN_U3 -to SW[14] -tag qboard
	set_location_assignment PIN_U4 -to SW[15] -tag qboard
	set_location_assignment PIN_V1 -to SW[16] -tag qboard
	set_location_assignment PIN_V2 -to SW[17] -tag qboard
	set_location_assignment PIN_T6 -to DRAM_ADDR[0] -tag qboard
	set_location_assignment PIN_V4 -to DRAM_ADDR[1] -tag qboard 
	set_location_assignment PIN_V3 -to DRAM_ADDR[2] -tag qboard
	set_location_assignment PIN_W2 -to DRAM_ADDR[3] -tag qboard
	set_location_assignment PIN_W1 -to DRAM_ADDR[4] -tag qboard
	set_location_assignment PIN_U6 -to DRAM_ADDR[5] -tag qboard
	set_location_assignment PIN_U7 -to DRAM_ADDR[6] -tag qboard
	set_location_assignment PIN_U5 -to DRAM_ADDR[7] -tag qboard
	set_location_assignment PIN_W4 -to DRAM_ADDR[8] -tag qboard
	set_location_assignment PIN_W3 -to DRAM_ADDR[9] -tag qboard
	set_location_assignment PIN_Y1 -to DRAM_ADDR[10] -tag qboard
	set_location_assignment PIN_V5 -to DRAM_ADDR[11] -tag qboard
	set_location_assignment PIN_AE2 -to DRAM_BA_0 -tag qboard
	set_location_assignment PIN_AE3 -to DRAM_BA_1 -tag qboard
	set_location_assignment PIN_AB3 -to DRAM_CAS_N -tag qboard
	set_location_assignment PIN_AA6 -to DRAM_CKE -tag qboard
	set_location_assignment PIN_AA7 -to DRAM_CLK -tag qboard
	set_location_assignment PIN_AC3 -to DRAM_CS_N -tag qboard
	set_location_assignment PIN_V6 -to DRAM_DQ[0] -tag qboard
	set_location_assignment PIN_AA2 -to DRAM_DQ[1] -tag qboard
	set_location_assignment PIN_AA1 -to DRAM_DQ[2] -tag qboard
	set_location_assignment PIN_Y3 -to DRAM_DQ[3] -tag qboard
	set_location_assignment PIN_Y4 -to DRAM_DQ[4] -tag qboard
	set_location_assignment PIN_R8 -to DRAM_DQ[5] -tag qboard
	set_location_assignment PIN_T8 -to DRAM_DQ[6] -tag qboard
	set_location_assignment PIN_V7 -to DRAM_DQ[7] -tag qboard
	set_location_assignment PIN_W6 -to DRAM_DQ[8] -tag qboard
	set_location_assignment PIN_AB2 -to DRAM_DQ[9] -tag qboard
	set_location_assignment PIN_AB1 -to DRAM_DQ[10] -tag qboard
	set_location_assignment PIN_AA4 -to DRAM_DQ[11] -tag qboard
	set_location_assignment PIN_AA3 -to DRAM_DQ[12] -tag qboard
	set_location_assignment PIN_AC2 -to DRAM_DQ[13] -tag qboard
	set_location_assignment PIN_AC1 -to DRAM_DQ[14] -tag qboard
	set_location_assignment PIN_AA5 -to DRAM_DQ[15] -tag qboard
	set_location_assignment PIN_AD2 -to DRAM_LDQM -tag qboard
	set_location_assignment PIN_Y5 -to DRAM_UDQM -tag qboard
	set_location_assignment PIN_AB4 -to DRAM_RAS_N -tag qboard
	set_location_assignment PIN_AD3 -to DRAM_WE_N -tag qboard
	set_location_assignment PIN_AC18 -to FL_ADDR[0] -tag qboard
	set_location_assignment PIN_AB18 -to FL_ADDR[1] -tag qboard
	set_location_assignment PIN_AE19 -to FL_ADDR[2] -tag qboard
	set_location_assignment PIN_AF19 -to FL_ADDR[3] -tag qboard
	set_location_assignment PIN_AE18 -to FL_ADDR[4] -tag qboard
	set_location_assignment PIN_AF18 -to FL_ADDR[5] -tag qboard
	set_location_assignment PIN_Y16 -to FL_ADDR[6] -tag qboard
	set_location_assignment PIN_AA16 -to FL_ADDR[7] -tag qboard
	set_location_assignment PIN_AD17 -to FL_ADDR[8] -tag qboard
	set_location_assignment PIN_AC17 -to FL_ADDR[9] -tag qboard
	set_location_assignment PIN_AE17 -to FL_ADDR[10] -tag qboard
	set_location_assignment PIN_AF17 -to FL_ADDR[11] -tag qboard
	set_location_assignment PIN_W16 -to FL_ADDR[12] -tag qboard
	set_location_assignment PIN_W15 -to FL_ADDR[13] -tag qboard
	set_location_assignment PIN_AC16 -to FL_ADDR[14] -tag qboard
	set_location_assignment PIN_AD16 -to FL_ADDR[15] -tag qboard
	set_location_assignment PIN_AE16 -to FL_ADDR[16] -tag qboard
	set_location_assignment PIN_AC15 -to FL_ADDR[17] -tag qboard
	set_location_assignment PIN_AB15 -to FL_ADDR[18] -tag qboard
	set_location_assignment PIN_AA15 -to FL_ADDR[19] -tag qboard
	set_location_assignment PIN_V17 -to FL_CE_N -tag qboard
	set_location_assignment PIN_W17 -to FL_OE_N -tag qboard
	set_location_assignment PIN_AD19 -to FL_DQ[0] -tag qboard
	set_location_assignment PIN_AC19 -to FL_DQ[1] -tag qboard
	set_location_assignment PIN_AF20 -to FL_DQ[2] -tag qboard
	set_location_assignment PIN_AE20 -to FL_DQ[3] -tag qboard
	set_location_assignment PIN_AB20 -to FL_DQ[4] -tag qboard
	set_location_assignment PIN_AC20 -to FL_DQ[5] -tag qboard
	set_location_assignment PIN_AF21 -to FL_DQ[6] -tag qboard
	set_location_assignment PIN_AE21 -to FL_DQ[7] -tag qboard
	set_location_assignment PIN_AA18 -to FL_RST_N -tag qboard
	set_location_assignment PIN_AA17 -to FL_WE_N -tag qboard
	set_location_assignment PIN_AF10 -to HEX0[0] -tag qboard
	set_location_assignment PIN_AB12 -to HEX0[1] -tag qboard
	set_location_assignment PIN_AC12 -to HEX0[2] -tag qboard
	set_location_assignment PIN_AD11 -to HEX0[3] -tag qboard
	set_location_assignment PIN_AE11 -to HEX0[4] -tag qboard
	set_location_assignment PIN_V14 -to HEX0[5] -tag qboard
	set_location_assignment PIN_V13 -to HEX0[6] -tag qboard
	set_location_assignment PIN_V20 -to HEX1[0] -tag qboard
	set_location_assignment PIN_V21 -to HEX1[1] -tag qboard
	set_location_assignment PIN_W21 -to HEX1[2] -tag qboard
	set_location_assignment PIN_Y22 -to HEX1[3] -tag qboard
	set_location_assignment PIN_AA24 -to HEX1[4] -tag qboard
	set_location_assignment PIN_AA23 -to HEX1[5] -tag qboard
	set_location_assignment PIN_AB24 -to HEX1[6] -tag qboard
	set_location_assignment PIN_AB23 -to HEX2[0] -tag qboard
	set_location_assignment PIN_V22 -to HEX2[1] -tag qboard
	set_location_assignment PIN_AC25 -to HEX2[2] -tag qboard
	set_location_assignment PIN_AC26 -to HEX2[3] -tag qboard
	set_location_assignment PIN_AB26 -to HEX2[4] -tag qboard
	set_location_assignment PIN_AB25 -to HEX2[5] -tag qboard
	set_location_assignment PIN_Y24 -to HEX2[6] -tag qboard
	set_location_assignment PIN_Y23 -to HEX3[0] -tag qboard
	set_location_assignment PIN_AA25 -to HEX3[1] -tag qboard
	set_location_assignment PIN_AA26 -to HEX3[2] -tag qboard
	set_location_assignment PIN_Y26 -to HEX3[3] -tag qboard
	set_location_assignment PIN_Y25 -to HEX3[4] -tag qboard
	set_location_assignment PIN_U22 -to HEX3[5] -tag qboard
	set_location_assignment PIN_W24 -to HEX3[6] -tag qboard
	set_location_assignment PIN_U9 -to HEX4[0] -tag qboard
	set_location_assignment PIN_U1 -to HEX4[1] -tag qboard
	set_location_assignment PIN_U2 -to HEX4[2] -tag qboard
	set_location_assignment PIN_T4 -to HEX4[3] -tag qboard
	set_location_assignment PIN_R7 -to HEX4[4] -tag qboard
	set_location_assignment PIN_R6 -to HEX4[5] -tag qboard
	set_location_assignment PIN_T3 -to HEX4[6] -tag qboard
	set_location_assignment PIN_T2 -to HEX5[0] -tag qboard
	set_location_assignment PIN_P6 -to HEX5[1] -tag qboard
	set_location_assignment PIN_P7 -to HEX5[2] -tag qboard
	set_location_assignment PIN_T9 -to HEX5[3] -tag qboard
	set_location_assignment PIN_R5 -to HEX5[4] -tag qboard
	set_location_assignment PIN_R4 -to HEX5[5] -tag qboard
	set_location_assignment PIN_R3 -to HEX5[6] -tag qboard
	set_location_assignment PIN_R2 -to HEX6[0] -tag qboard
	set_location_assignment PIN_P4 -to HEX6[1] -tag qboard
	set_location_assignment PIN_P3 -to HEX6[2] -tag qboard
	set_location_assignment PIN_M2 -to HEX6[3] -tag qboard
	set_location_assignment PIN_M3 -to HEX6[4] -tag qboard
	set_location_assignment PIN_M5 -to HEX6[5] -tag qboard
	set_location_assignment PIN_M4 -to HEX6[6] -tag qboard
	set_location_assignment PIN_L3 -to HEX7[0] -tag qboard
	set_location_assignment PIN_L2 -to HEX7[1] -tag qboard
	set_location_assignment PIN_L9 -to HEX7[2] -tag qboard
	set_location_assignment PIN_L6 -to HEX7[3] -tag qboard
	set_location_assignment PIN_L7 -to HEX7[4] -tag qboard
	set_location_assignment PIN_P9 -to HEX7[5] -tag qboard
	set_location_assignment PIN_N9 -to HEX7[6] -tag qboard
	set_location_assignment PIN_G26 -to KEY[0] -tag qboard
	set_location_assignment PIN_N23 -to KEY[1] -tag qboard
	set_location_assignment PIN_P23 -to KEY[2] -tag qboard
	set_location_assignment PIN_W26 -to KEY[3] -tag qboard
	set_location_assignment PIN_AE23 -to LEDR[0] -tag qboard
	set_location_assignment PIN_AF23 -to LEDR[1] -tag qboard
	set_location_assignment PIN_AB21 -to LEDR[2] -tag qboard
	set_location_assignment PIN_AC22 -to LEDR[3] -tag qboard
	set_location_assignment PIN_AD22 -to LEDR[4] -tag qboard
	set_location_assignment PIN_AD23 -to LEDR[5] -tag qboard
	set_location_assignment PIN_AD21 -to LEDR[6] -tag qboard
	set_location_assignment PIN_AC21 -to LEDR[7] -tag qboard
	set_location_assignment PIN_AA14 -to LEDR[8] -tag qboard
	set_location_assignment PIN_Y13 -to LEDR[9] -tag qboard
	set_location_assignment PIN_AA13 -to LEDR[10] -tag qboard
	set_location_assignment PIN_AC14 -to LEDR[11] -tag qboard
	set_location_assignment PIN_AD15 -to LEDR[12] -tag qboard
	set_location_assignment PIN_AE15 -to LEDR[13] -tag qboard
	set_location_assignment PIN_AF13 -to LEDR[14] -tag qboard
	set_location_assignment PIN_AE13 -to LEDR[15] -tag qboard
	set_location_assignment PIN_AE12 -to LEDR[16] -tag qboard
	set_location_assignment PIN_AD12 -to LEDR[17] -tag qboard
	set_location_assignment PIN_AE22 -to LEDG[0] -tag qboard
	set_location_assignment PIN_AF22 -to LEDG[1] -tag qboard
	set_location_assignment PIN_W19 -to LEDG[2] -tag qboard
	set_location_assignment PIN_V18 -to LEDG[3] -tag qboard
	set_location_assignment PIN_U18 -to LEDG[4] -tag qboard
	set_location_assignment PIN_U17 -to LEDG[5] -tag qboard
	set_location_assignment PIN_AA20 -to LEDG[6] -tag qboard
	set_location_assignment PIN_Y18 -to LEDG[7] -tag qboard
	set_location_assignment PIN_Y12 -to LEDG[8] -tag qboard
	set_location_assignment PIN_D13 -to CLOCK_27 -tag qboard
	set_location_assignment PIN_N2 -to CLOCK_50 -tag qboard
	set_location_assignment PIN_P26 -to EXT_CLOCK -tag qboard
	set_location_assignment PIN_D26 -to PS2_CLK -tag qboard
	set_location_assignment PIN_C24 -to PS2_DAT -tag qboard
	set_location_assignment PIN_C25 -to UART_RXD -tag qboard
	set_location_assignment PIN_B25 -to UART_TXD -tag qboard
	set_location_assignment PIN_K4 -to LCD_RW -tag qboard
	set_location_assignment PIN_K3 -to LCD_EN -tag qboard
	set_location_assignment PIN_K1 -to LCD_RS -tag qboard
	set_location_assignment PIN_J1 -to LCD_DATA[0] -tag qboard
	set_location_assignment PIN_J2 -to LCD_DATA[1] -tag qboard
	set_location_assignment PIN_H1 -to LCD_DATA[2] -tag qboard
	set_location_assignment PIN_H2 -to LCD_DATA[3] -tag qboard
	set_location_assignment PIN_J4 -to LCD_DATA[4] -tag qboard
	set_location_assignment PIN_J3 -to LCD_DATA[5] -tag qboard
	set_location_assignment PIN_H4 -to LCD_DATA[6] -tag qboard
	set_location_assignment PIN_H3 -to LCD_DATA[7] -tag qboard
	set_location_assignment PIN_L4 -to LCD_ON -tag qboard
	set_location_assignment PIN_K2 -to LCD_BLON -tag qboard
	set_location_assignment PIN_AE4 -to SRAM_ADDR[0] -tag qboard
	set_location_assignment PIN_AF4 -to SRAM_ADDR[1] -tag qboard
	set_location_assignment PIN_AC5 -to SRAM_ADDR[2] -tag qboard
	set_location_assignment PIN_AC6 -to SRAM_ADDR[3] -tag qboard
	set_location_assignment PIN_AD4 -to SRAM_ADDR[4] -tag qboard
	set_location_assignment PIN_AD5 -to SRAM_ADDR[5] -tag qboard
	set_location_assignment PIN_AE5 -to SRAM_ADDR[6] -tag qboard
	set_location_assignment PIN_AF5 -to SRAM_ADDR[7] -tag qboard
	set_location_assignment PIN_AD6 -to SRAM_ADDR[8] -tag qboard
	set_location_assignment PIN_AD7 -to SRAM_ADDR[9] -tag qboard
	set_location_assignment PIN_V10 -to SRAM_ADDR[10] -tag qboard
	set_location_assignment PIN_V9 -to SRAM_ADDR[11] -tag qboard
	set_location_assignment PIN_AC7 -to SRAM_ADDR[12] -tag qboard
	set_location_assignment PIN_W8 -to SRAM_ADDR[13] -tag qboard
	set_location_assignment PIN_W10 -to SRAM_ADDR[14] -tag qboard
	set_location_assignment PIN_Y10 -to SRAM_ADDR[15] -tag qboard
	set_location_assignment PIN_AB8 -to SRAM_ADDR[16] -tag qboard
	set_location_assignment PIN_AC8 -to SRAM_ADDR[17] -tag qboard
	set_location_assignment PIN_AD8 -to SRAM_DQ[0] -tag qboard
	set_location_assignment PIN_AE6 -to SRAM_DQ[1] -tag qboard
	set_location_assignment PIN_AF6 -to SRAM_DQ[2] -tag qboard
	set_location_assignment PIN_AA9 -to SRAM_DQ[3] -tag qboard
	set_location_assignment PIN_AA10 -to SRAM_DQ[4] -tag qboard
	set_location_assignment PIN_AB10 -to SRAM_DQ[5] -tag qboard
	set_location_assignment PIN_AA11 -to SRAM_DQ[6] -tag qboard
	set_location_assignment PIN_Y11 -to SRAM_DQ[7] -tag qboard
	set_location_assignment PIN_AE7 -to SRAM_DQ[8] -tag qboard
	set_location_assignment PIN_AF7 -to SRAM_DQ[9] -tag qboard
	set_location_assignment PIN_AE8 -to SRAM_DQ[10] -tag qboard
	set_location_assignment PIN_AF8 -to SRAM_DQ[11] -tag qboard
	set_location_assignment PIN_W11 -to SRAM_DQ[12] -tag qboard
	set_location_assignment PIN_W12 -to SRAM_DQ[13] -tag qboard
	set_location_assignment PIN_AC9 -to SRAM_DQ[14] -tag qboard
	set_location_assignment PIN_AC10 -to SRAM_DQ[15] -tag qboard
	set_location_assignment PIN_AE10 -to SRAM_WE_N -tag qboard
	set_location_assignment PIN_AD10 -to SRAM_OE_N -tag qboard
	set_location_assignment PIN_AF9 -to SRAM_UB_N -tag qboard
	set_location_assignment PIN_AE9 -to SRAM_LB_N -tag qboard
	set_location_assignment PIN_AC11 -to SRAM_CE_N -tag qboard
	set_location_assignment PIN_K7 -to OTG_ADDR[0] -tag qboard
	set_location_assignment PIN_F2 -to OTG_ADDR[1] -tag qboard
	set_location_assignment PIN_F1 -to OTG_CS_N -tag qboard
	set_location_assignment PIN_G2 -to OTG_RD_N -tag qboard
	set_location_assignment PIN_G1 -to OTG_WR_N -tag qboard
	set_location_assignment PIN_G5 -to OTG_RST_N -tag qboard
	set_location_assignment PIN_F4 -to OTG_DATA[0] -tag qboard
	set_location_assignment PIN_D2 -to OTG_DATA[1] -tag qboard
	set_location_assignment PIN_D1 -to OTG_DATA[2] -tag qboard
	set_location_assignment PIN_F7 -to OTG_DATA[3] -tag qboard
	set_location_assignment PIN_J5 -to OTG_DATA[4] -tag qboard
	set_location_assignment PIN_J8 -to OTG_DATA[5] -tag qboard
	set_location_assignment PIN_J7 -to OTG_DATA[6] -tag qboard
	set_location_assignment PIN_H6 -to OTG_DATA[7] -tag qboard
	set_location_assignment PIN_E2 -to OTG_DATA[8] -tag qboard
	set_location_assignment PIN_E1 -to OTG_DATA[9] -tag qboard
	set_location_assignment PIN_K6 -to OTG_DATA[10] -tag qboard
	set_location_assignment PIN_K5 -to OTG_DATA[11] -tag qboard
	set_location_assignment PIN_G4 -to OTG_DATA[12] -tag qboard
	set_location_assignment PIN_G3 -to OTG_DATA[13] -tag qboard
	set_location_assignment PIN_J6 -to OTG_DATA[14] -tag qboard
	set_location_assignment PIN_K8 -to OTG_DATA[15] -tag qboard
	set_location_assignment PIN_B3 -to OTG_INT0 -tag qboard
	set_location_assignment PIN_C3 -to OTG_INT1 -tag qboard
	set_location_assignment PIN_C2 -to OTG_DACK0_N -tag qboard
	set_location_assignment PIN_B2 -to OTG_DACK1_N -tag qboard
	set_location_assignment PIN_F6 -to OTG_DREQ0 -tag qboard
	set_location_assignment PIN_E5 -to OTG_DREQ1 -tag qboard
	set_location_assignment PIN_F3 -to OTG_FSPEED -tag qboard
	set_location_assignment PIN_G6 -to OTG_LSPEED -tag qboard
	set_location_assignment PIN_B14 -to TDI -tag qboard
	set_location_assignment PIN_A14 -to TCS -tag qboard
	set_location_assignment PIN_D14 -to TCK -tag qboard
	set_location_assignment PIN_F14 -to TDO -tag qboard
	set_location_assignment PIN_C4 -to TD_RESET -tag qboard
	set_location_assignment PIN_C8 -to VGA_R[0] -tag qboard
	set_location_assignment PIN_F10 -to VGA_R[1] -tag qboard
	set_location_assignment PIN_G10 -to VGA_R[2] -tag qboard
	set_location_assignment PIN_D9 -to VGA_R[3] -tag qboard
	set_location_assignment PIN_C9 -to VGA_R[4] -tag qboard
	set_location_assignment PIN_A8 -to VGA_R[5] -tag qboard
	set_location_assignment PIN_H11 -to VGA_R[6] -tag qboard
	set_location_assignment PIN_H12 -to VGA_R[7] -tag qboard
	set_location_assignment PIN_F11 -to VGA_R[8] -tag qboard
	set_location_assignment PIN_E10 -to VGA_R[9] -tag qboard
	set_location_assignment PIN_B9 -to VGA_G[0] -tag qboard
	set_location_assignment PIN_A9 -to VGA_G[1] -tag qboard
	set_location_assignment PIN_C10 -to VGA_G[2] -tag qboard
	set_location_assignment PIN_D10 -to VGA_G[3] -tag qboard
	set_location_assignment PIN_B10 -to VGA_G[4] -tag qboard
	set_location_assignment PIN_A10 -to VGA_G[5] -tag qboard
	set_location_assignment PIN_G11 -to VGA_G[6] -tag qboard
	set_location_assignment PIN_D11 -to VGA_G[7] -tag qboard
	set_location_assignment PIN_E12 -to VGA_G[8] -tag qboard
	set_location_assignment PIN_D12 -to VGA_G[9] -tag qboard
	set_location_assignment PIN_J13 -to VGA_B[0] -tag qboard
	set_location_assignment PIN_J14 -to VGA_B[1] -tag qboard
	set_location_assignment PIN_F12 -to VGA_B[2] -tag qboard
	set_location_assignment PIN_G12 -to VGA_B[3] -tag qboard
	set_location_assignment PIN_J10 -to VGA_B[4] -tag qboard
	set_location_assignment PIN_J11 -to VGA_B[5] -tag qboard
	set_location_assignment PIN_C11 -to VGA_B[6] -tag qboard
	set_location_assignment PIN_B11 -to VGA_B[7] -tag qboard
	set_location_assignment PIN_C12 -to VGA_B[8] -tag qboard
	set_location_assignment PIN_B12 -to VGA_B[9] -tag qboard
	set_location_assignment PIN_B8 -to VGA_CLK -tag qboard
	set_location_assignment PIN_D6 -to VGA_BLANK -tag qboard
	set_location_assignment PIN_A7 -to VGA_HS -tag qboard
	set_location_assignment PIN_D8 -to VGA_VS -tag qboard
	set_location_assignment PIN_B7 -to VGA_SYNC -tag qboard
	set_location_assignment PIN_A6 -to I2C_SCLK -tag qboard
	set_location_assignment PIN_B6 -to I2C_SDAT -tag qboard
	set_location_assignment PIN_J9 -to TD_DATA[0] -tag qboard
	set_location_assignment PIN_E8 -to TD_DATA[1] -tag qboard
	set_location_assignment PIN_H8 -to TD_DATA[2] -tag qboard
	set_location_assignment PIN_H10 -to TD_DATA[3] -tag qboard
	set_location_assignment PIN_G9 -to TD_DATA[4] -tag qboard
	set_location_assignment PIN_F9 -to TD_DATA[5] -tag qboard
	set_location_assignment PIN_D7 -to TD_DATA[6] -tag qboard
	set_location_assignment PIN_C7 -to TD_DATA[7] -tag qboard
	set_location_assignment PIN_D5 -to TD_HS -tag qboard
	set_location_assignment PIN_K9 -to TD_VS -tag qboard
	set_location_assignment PIN_C5 -to AUD_ADCLRCK -tag qboard
	set_location_assignment PIN_B5 -to AUD_ADCDAT -tag qboard
	set_location_assignment PIN_C6 -to AUD_DACLRCK -tag qboard
	set_location_assignment PIN_A4 -to AUD_DACDAT -tag qboard
	set_location_assignment PIN_A5 -to AUD_XCK -tag qboard
	set_location_assignment PIN_B4 -to AUD_BCLK -tag qboard
	set_location_assignment PIN_D17 -to ENET_DATA[0] -tag qboard
	set_location_assignment PIN_C17 -to ENET_DATA[1] -tag qboard
	set_location_assignment PIN_B18 -to ENET_DATA[2] -tag qboard
	set_location_assignment PIN_A18 -to ENET_DATA[3] -tag qboard
	set_location_assignment PIN_B17 -to ENET_DATA[4] -tag qboard
	set_location_assignment PIN_A17 -to ENET_DATA[5] -tag qboard
	set_location_assignment PIN_B16 -to ENET_DATA[6] -tag qboard
	set_location_assignment PIN_B15 -to ENET_DATA[7] -tag qboard
	set_location_assignment PIN_B20 -to ENET_DATA[8] -tag qboard
	set_location_assignment PIN_A20 -to ENET_DATA[9] -tag qboard
	set_location_assignment PIN_C19 -to ENET_DATA[10] -tag qboard
	set_location_assignment PIN_D19 -to ENET_DATA[11] -tag qboard
	set_location_assignment PIN_B19 -to ENET_DATA[12] -tag qboard
	set_location_assignment PIN_A19 -to ENET_DATA[13] -tag qboard
	set_location_assignment PIN_E18 -to ENET_DATA[14] -tag qboard
	set_location_assignment PIN_D18 -to ENET_DATA[15] -tag qboard
	set_location_assignment PIN_B24 -to ENET_CLK -tag qboard
	set_location_assignment PIN_A21 -to ENET_CMD -tag qboard
	set_location_assignment PIN_A23 -to ENET_CS_N -tag qboard
	set_location_assignment PIN_B21 -to ENET_INT -tag qboard
	set_location_assignment PIN_A22 -to ENET_RD_N -tag qboard
	set_location_assignment PIN_B22 -to ENET_WR_N -tag qboard
	set_location_assignment PIN_B23 -to ENET_RST_N -tag qboard
	set_location_assignment PIN_AE24 -to IRDA_TXD -tag qboard
	set_location_assignment PIN_AE25 -to IRDA_RXD -tag qboard
	set_location_assignment PIN_AD24 -to SD_DAT -tag qboard
	set_location_assignment PIN_AC23 -to SD_DAT3 -tag qboard
	set_location_assignment PIN_Y21 -to SD_CMD -tag qboard
	set_location_assignment PIN_AD25 -to SD_CLK -tag qboard
	set_location_assignment PIN_D25 -to GPIO_0[0] -tag qboard
	set_location_assignment PIN_J22 -to GPIO_0[1] -tag qboard
	set_location_assignment PIN_E26 -to GPIO_0[2] -tag qboard
	set_location_assignment PIN_E25 -to GPIO_0[3] -tag qboard
	set_location_assignment PIN_F24 -to GPIO_0[4] -tag qboard
	set_location_assignment PIN_F23 -to GPIO_0[5] -tag qboard
	set_location_assignment PIN_J21 -to GPIO_0[6] -tag qboard
	set_location_assignment PIN_J20 -to GPIO_0[7] -tag qboard
	set_location_assignment PIN_F25 -to GPIO_0[8] -tag qboard
	set_location_assignment PIN_F26 -to GPIO_0[9] -tag qboard
	set_location_assignment PIN_N18 -to GPIO_0[10] -tag qboard
	set_location_assignment PIN_P18 -to GPIO_0[11] -tag qboard
	set_location_assignment PIN_G23 -to GPIO_0[12] -tag qboard
	set_location_assignment PIN_G24 -to GPIO_0[13] -tag qboard
	set_location_assignment PIN_K22 -to GPIO_0[14] -tag qboard
	set_location_assignment PIN_G25 -to GPIO_0[15] -tag qboard
	set_location_assignment PIN_H23 -to GPIO_0[16] -tag qboard
	set_location_assignment PIN_H24 -to GPIO_0[17] -tag qboard
	set_location_assignment PIN_J23 -to GPIO_0[18] -tag qboard
	set_location_assignment PIN_J24 -to GPIO_0[19] -tag qboard
	set_location_assignment PIN_H25 -to GPIO_0[20] -tag qboard
	set_location_assignment PIN_H26 -to GPIO_0[21] -tag qboard
	set_location_assignment PIN_H19 -to GPIO_0[22] -tag qboard
	set_location_assignment PIN_K18 -to GPIO_0[23] -tag qboard
	set_location_assignment PIN_K19 -to GPIO_0[24] -tag qboard
	set_location_assignment PIN_K21 -to GPIO_0[25] -tag qboard
	set_location_assignment PIN_K23 -to GPIO_0[26] -tag qboard
	set_location_assignment PIN_K24 -to GPIO_0[27] -tag qboard
	set_location_assignment PIN_L21 -to GPIO_0[28] -tag qboard
	set_location_assignment PIN_L20 -to GPIO_0[29] -tag qboard
	set_location_assignment PIN_J25 -to GPIO_0[30] -tag qboard
	set_location_assignment PIN_J26 -to GPIO_0[31] -tag qboard
	set_location_assignment PIN_L23 -to GPIO_0[32] -tag qboard
	set_location_assignment PIN_L24 -to GPIO_0[33] -tag qboard
	set_location_assignment PIN_L25 -to GPIO_0[34] -tag qboard
	set_location_assignment PIN_L19 -to GPIO_0[35] -tag qboard
	set_location_assignment PIN_K25 -to GPIO_1[0] -tag qboard
	set_location_assignment PIN_K26 -to GPIO_1[1] -tag qboard
	set_location_assignment PIN_M22 -to GPIO_1[2] -tag qboard
	set_location_assignment PIN_M23 -to GPIO_1[3] -tag qboard
	set_location_assignment PIN_M19 -to GPIO_1[4] -tag qboard
	set_location_assignment PIN_M20 -to GPIO_1[5] -tag qboard
	set_location_assignment PIN_N20 -to GPIO_1[6] -tag qboard
	set_location_assignment PIN_M21 -to GPIO_1[7] -tag qboard
	set_location_assignment PIN_M24 -to GPIO_1[8] -tag qboard
	set_location_assignment PIN_M25 -to GPIO_1[9] -tag qboard
	set_location_assignment PIN_N24 -to GPIO_1[10] -tag qboard
	set_location_assignment PIN_P24 -to GPIO_1[11] -tag qboard
	set_location_assignment PIN_R25 -to GPIO_1[12] -tag qboard
	set_location_assignment PIN_R24 -to GPIO_1[13] -tag qboard
	set_location_assignment PIN_R20 -to GPIO_1[14] -tag qboard
	set_location_assignment PIN_T22 -to GPIO_1[15] -tag qboard
	set_location_assignment PIN_T23 -to GPIO_1[16] -tag qboard
	set_location_assignment PIN_T24 -to GPIO_1[17] -tag qboard
	set_location_assignment PIN_T25 -to GPIO_1[18] -tag qboard
	set_location_assignment PIN_T18 -to GPIO_1[19] -tag qboard
	set_location_assignment PIN_T21 -to GPIO_1[20] -tag qboard
	set_location_assignment PIN_T20 -to GPIO_1[21] -tag qboard
	set_location_assignment PIN_U26 -to GPIO_1[22] -tag qboard
	set_location_assignment PIN_U25 -to GPIO_1[23] -tag qboard
	set_location_assignment PIN_U23 -to GPIO_1[24] -tag qboard
	set_location_assignment PIN_U24 -to GPIO_1[25] -tag qboard
	set_location_assignment PIN_R19 -to GPIO_1[26] -tag qboard
	set_location_assignment PIN_T19 -to GPIO_1[27] -tag qboard
	set_location_assignment PIN_U20 -to GPIO_1[28] -tag qboard
	set_location_assignment PIN_U21 -to GPIO_1[29] -tag qboard
	set_location_assignment PIN_V26 -to GPIO_1[30] -tag qboard
	set_location_assignment PIN_V25 -to GPIO_1[31] -tag qboard
	set_location_assignment PIN_V24 -to GPIO_1[32] -tag qboard
	set_location_assignment PIN_V23 -to GPIO_1[33] -tag qboard
	set_location_assignment PIN_W25 -to GPIO_1[34] -tag qboard
	set_location_assignment PIN_W23 -to GPIO_1[35] -tag qboard
	set_location_assignment PIN_Y15 -to FL_ADDR[20] -tag qboard
	set_location_assignment PIN_Y14 -to FL_ADDR[21] -tag qboard

	set_instance_assignment -name IO_STANDARD LVTTL -to TD_DATA* -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to TD_HS -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to TD_VS -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to AUD_ADCLRCK -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to AUD_ADCDAT -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to AUD_DACLRCK -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to AUD_DACDAT -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to AUD_XCK -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to AUD_BCLK -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to ENET_DATA[0] -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to SD_DAT3 -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to FL_ADDR[20] -tag qboard
	set_instance_assignment -name IO_STANDARD LVTTL -to FL_ADDR[21] -tag qboard

	# Other Assignments
	# =====================
	set_global_assignment -name STRATIX_DEVICE_IO_STANDARD LVTTL -tag qboard
	set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO" -tag qboard
	set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED" -tag qboard
	set_global_assignment -name RESERVE_ASDO_AFTER_CONFIGURATION "AS OUTPUT DRIVING AN UNSPECIFIED SIGNAL" -tag qboard
	set_global_assignment -name RESERVE_ALL_UNUSED_PINS_NO_OUTPUT_GND "AS INPUT TRI-STATED" -tag qboard
	set_global_assignment -name STRATIX_CONFIGURATION_DEVICE EPCS16 -tag qboard

}
