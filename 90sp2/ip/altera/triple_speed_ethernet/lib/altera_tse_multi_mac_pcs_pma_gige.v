
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------
//
// Revision Control Information
//
// $RCSfile: altera_tse_multi_mac_pcs_pma_gige.v,v $
// $Source: /ipbu/cvs/sio/projects/TriSpeedEthernet/src/RTL/Top_level_modules/altera_tse_multi_mac_pcs_pma_gige.v,v $
//
// $Revision: #1 $
// $Date: 2009/04/01 $
// Check in by : $Author: sc-build $
// Author      : Arul Paniandi
//
// Project     : Triple Speed Ethernet - 10/100/1000 MAC
//
// Description : 
//
// Top Level Triple Speed Ethernet(10/100/1000) MAC with MII/GMII
// interfaces, mdio module and register space (statistic, control and 
// management)

// 
// ALTERA Confidential and Proprietary
// Copyright 2006 (c) Altera Corporation  
// All rights reserved
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

(*altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF" } *)
module altera_tse_multi_mac_pcs_pma_gige

#(
parameter USE_SYNC_RESET        = 0,                    //  Use Synchronized Reset Inputs
parameter RESET_LEVEL           = 1'b 1 ,               //  Reset Active Level
parameter ENABLE_GMII_LOOPBACK  = 1,                    //  GMII_LOOPBACK_ENA : Enable GMII Loopback Logic 
parameter ENABLE_HD_LOGIC       = 1,                    //  HD_LOGIC_ENA : Enable Half Duplex Logic
parameter ENABLE_SUP_ADDR       = 1,                    //  SUP_ADDR_ENA : Enable Supplemental Addresses
parameter ENA_HASH              = 1,                    //  ENA_HASH Enable Hash Table 
parameter STAT_CNT_ENA          = 1,                    //  STAT_CNT_ENA Enable Statistic Counters
parameter MDIO_CLK_DIV          = 40 ,                  //  Host Clock Division - MDC Generation
parameter CORE_VERSION          = 16'h3,                //  ALTERA Core Version
parameter CUST_VERSION          = 1 ,                   //  Customer Core Version
parameter REDUCED_INTERFACE_ENA = 0,                    //  Enable the RGMII Interface
parameter ENABLE_MDIO           = 1,                    //  Enable the MDIO Interface
parameter ENABLE_MAGIC_DETECT   = 1,                    //  Enable magic packet detection 
parameter ENABLE_PADDING        = 1,                    //  Enable padding operation.
parameter ENABLE_LGTH_CHECK     = 1,                    //  Enable frame length checking.
parameter GBIT_ONLY             = 1,                    //  Enable Gigabit only operation.
parameter MBIT_ONLY             = 1,                    //  Enable Megabit (10/100) only operation.
parameter REDUCED_CONTROL       = 0,                    //  Reduced control for MAC LITE
parameter CRC32DWIDTH           = 4'b 1000,             //  input data width (informal, not for change)
parameter CRC32GENDELAY         = 3'b 110,              //  when the data from the generator is valid
parameter CRC32CHECK16BIT       = 1'b 0,                //  1 compare two times 16 bit of the CRC (adds one pipeline step) 
parameter CRC32S1L2_EXTERN      = 1'b0,                 //  false: merge enable
parameter ENABLE_SHIFT16        = 0,                    //  Enable byte stuffing at packet header 
parameter ENABLE_MAC_FLOW_CTRL  = 1'b1,                 //  Option to enable flow control 
parameter ENABLE_MAC_TXADDR_SET = 1'b1,                 //  Option to enable MAC address insertion onto 'to-be-transmitted' Ethernet frames on MAC TX data path
parameter ENABLE_MAC_RX_VLAN    = 1'b1,                 //  Option to enable VLAN tagged Ethernet frames on MAC RX data path
parameter ENABLE_MAC_TX_VLAN    = 1'b1,                 //  Option to enable VLAN tagged Ethernet frames on MAC TX data path
parameter PHY_IDENTIFIER        = 32'h 00000000,        //  PHY Identifier
parameter DEV_VERSION           = 16'h 0001 ,           //  Customer Phy's Core Version
parameter ENABLE_SGMII          = 1,                    //  Enable SGMII logic for synthesis
parameter ENABLE_CLK_SHARING    = 1,                    //  Option to share clock for multiple channels (Clocks are rate-matched).
parameter ENABLE_REG_SHARING    = 0,                    //  Option to share register space. Uses certain hard-coded values from input.
parameter ENABLE_EXTENDED_STAT_REG = 0,                 //  Enable a few extended statistic registers
parameter MAX_CHANNELS          = 1,                    //  The number of channels in Multi-TSE component
parameter ENABLE_PKT_CLASS      = 1,                    //  Enable Packet Classification Av-ST Interface
parameter ENABLE_RX_FIFO_STATUS = 1,                    //  Enable Receive FIFO Almost Full status interface
parameter CHANNEL_WIDTH         = 1,                    //  The width of the channel interface
parameter EXPORT_PWRDN          = 1'b0,                 //  Option to export the Alt2gxb powerdown signal
parameter DEVICE_FAMILY         = "ARRIAGX",            //  The device family the the core is targetted for.
parameter TRANSCEIVER_OPTION    = 1'b0,                 //  Option to select transceiver block for MAC PCS PMA Instantiation. Valid Values are 0 and 1:  0 - GXB (GIGE Mode) 1 � LVDS IO
parameter ENABLE_ALT_RECONFIG   = 0,                    //  Option to expose the altreconfig ports
parameter SYNCHRONIZER_DEPTH 	= 3,	  	        //  Number of synchronizer
// Internal parameters
parameter STARTING_CHANNEL_NUMBER = 0,
parameter ADDR_WIDTH = (MAX_CHANNELS > 16)? 13 :
                       (MAX_CHANNELS > 8)? 12 : 
                       (MAX_CHANNELS > 4)? 11 : 
                       (MAX_CHANNELS > 2)? 10 :  
                       (MAX_CHANNELS > 1)? 9 : 8
)


// Port List
(

    // RESET / MAC REG IF / MDIO
    input wire   reset,                      //  Asynchronous Reset - clk Domain
    input wire   clk,                        //  25MHz Host Interface Clock
    input wire   read,                       //  Register Read Strobe
    input wire   write,                      //  Register Write Strobe
    input wire   [ADDR_WIDTH-1:0] address,   //  Register Address
    input wire   [31:0] writedata,           //  Write Data for Host Bus
    output wire  [31:0] readdata,            //  Read Data to Host Bus
    output wire  waitrequest,                //  Interface Busy
    output wire  mdc,                        //  2.5MHz Inteface
    input wire   mdio_in,                    //  MDIO Input
    output wire  mdio_out,                   //  MDIO Output
    output wire  mdio_oen,                   //  MDIO Output Enable

    // DEVICE SPECIFIC SIGNALS
    input wire   gxb_cal_blk_clk,            //  GXB Calibration Clock
    input wire   ref_clk,                    //  Rference Clock

	// SHARED CLK SIGNALS
    output wire  mac_rx_clk,                 //  Av-ST Receive Clock
    output wire  mac_tx_clk,                 //  Av-ST Transmit Clock 

	// SHARED RX STATUS
    input wire   rx_afull_clk,                             //  Almost full clk
    input wire   [1:0] rx_afull_data,                      //  Almost full data
    input wire   rx_afull_valid,                           //  Almost full valid
    input wire   [CHANNEL_WIDTH-1:0] rx_afull_channel,     //  Almost full channel


    // CHANNEL 0

    // PCS SIGNALS TO PHY
    input wire   rxp_0,                    //  Differential Receive Data 
    output wire  txp_0,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_0,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_0,          //  Powerdown Enable from PCS
    output wire  led_crs_0,                //  Carrier Sense
    output wire  led_link_0,               //  Valid Link 
    output wire  led_col_0,                //  Collision Indication
    output wire  led_an_0,                 //  Auto-Negotiation Status
    output wire  led_char_err_0,           //  Character Error
    output wire  led_disp_err_0,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_0,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_0,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_0,            //  Start of Packet
    output wire  data_rx_eop_0,            //  End of Packet
    output wire  [7:0] data_rx_data_0,     //  Data from FIFO
    output wire  [4:0] data_rx_error_0,    //  Receive packet error
    output wire  data_rx_valid_0,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_0,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_0,   //  Frame Type Indication
    output wire  pkt_class_valid_0,        //  Frame Type Indication Valid 
    input wire   data_tx_error_0,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_0,     //  Data from FIFO transmit
    input wire   data_tx_valid_0,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_0,            //  Start of Packet
    input wire   data_tx_eop_0,            //  END of Packet
    output wire  data_tx_ready_0,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_0,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_0,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_0,               //  Xoff Pause frame generate 
    input wire   xon_gen_0,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_0,          //  Enable Sleep Mode
    output wire  magic_wakeup_0,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_0,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_0,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_0,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 1

    // PCS SIGNALS TO PHY
    input wire   rxp_1,                    //  Differential Receive Data 
    output wire  txp_1,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_1,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_1,          //  Powerdown Enable from PCS
    output wire  led_crs_1,                //  Carrier Sense
    output wire  led_link_1,               //  Valid Link 
    output wire  led_col_1,                //  Collision Indication
    output wire  led_an_1,                 //  Auto-Negotiation Status
    output wire  led_char_err_1,           //  Character Error
    output wire  led_disp_err_1,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_1,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_1,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_1,            //  Start of Packet
    output wire  data_rx_eop_1,            //  End of Packet
    output wire  [7:0] data_rx_data_1,     //  Data from FIFO
    output wire  [4:0] data_rx_error_1,    //  Receive packet error
    output wire  data_rx_valid_1,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_1,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_1,   //  Frame Type Indication
    output wire  pkt_class_valid_1,        //  Frame Type Indication Valid 
    input wire   data_tx_error_1,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_1,     //  Data from FIFO transmit
    input wire   data_tx_valid_1,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_1,            //  Start of Packet
    input wire   data_tx_eop_1,            //  END of Packet
    output wire  data_tx_ready_1,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_1,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_1,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_1,               //  Xoff Pause frame generate 
    input wire   xon_gen_1,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_1,          //  Enable Sleep Mode
    output wire  magic_wakeup_1,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_1,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_1,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_1,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 2

    // PCS SIGNALS TO PHY
    input wire   rxp_2,                    //  Differential Receive Data 
    output wire  txp_2,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_2,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_2,          //  Powerdown Enable from PCS
    output wire  led_crs_2,                //  Carrier Sense
    output wire  led_link_2,               //  Valid Link 
    output wire  led_col_2,                //  Collision Indication
    output wire  led_an_2,                 //  Auto-Negotiation Status
    output wire  led_char_err_2,           //  Character Error
    output wire  led_disp_err_2,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_2,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_2,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_2,            //  Start of Packet
    output wire  data_rx_eop_2,            //  End of Packet
    output wire  [7:0] data_rx_data_2,     //  Data from FIFO
    output wire  [4:0] data_rx_error_2,    //  Receive packet error
    output wire  data_rx_valid_2,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_2,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_2,   //  Frame Type Indication
    output wire  pkt_class_valid_2,        //  Frame Type Indication Valid 
    input wire   data_tx_error_2,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_2,     //  Data from FIFO transmit
    input wire   data_tx_valid_2,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_2,            //  Start of Packet
    input wire   data_tx_eop_2,            //  END of Packet
    output wire  data_tx_ready_2,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_2,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_2,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_2,               //  Xoff Pause frame generate 
    input wire   xon_gen_2,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_2,          //  Enable Sleep Mode
    output wire  magic_wakeup_2,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_2,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_2,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_2,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 3

    // PCS SIGNALS TO PHY
    input wire   rxp_3,                    //  Differential Receive Data 
    output wire  txp_3,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_3,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_3,          //  Powerdown Enable from PCS
    output wire  led_crs_3,                //  Carrier Sense
    output wire  led_link_3,               //  Valid Link 
    output wire  led_col_3,                //  Collision Indication
    output wire  led_an_3,                 //  Auto-Negotiation Status
    output wire  led_char_err_3,           //  Character Error
    output wire  led_disp_err_3,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_3,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_3,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_3,            //  Start of Packet
    output wire  data_rx_eop_3,            //  End of Packet
    output wire  [7:0] data_rx_data_3,     //  Data from FIFO
    output wire  [4:0] data_rx_error_3,    //  Receive packet error
    output wire  data_rx_valid_3,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_3,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_3,   //  Frame Type Indication
    output wire  pkt_class_valid_3,        //  Frame Type Indication Valid 
    input wire   data_tx_error_3,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_3,     //  Data from FIFO transmit
    input wire   data_tx_valid_3,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_3,            //  Start of Packet
    input wire   data_tx_eop_3,            //  END of Packet
    output wire  data_tx_ready_3,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_3,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_3,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_3,               //  Xoff Pause frame generate 
    input wire   xon_gen_3,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_3,          //  Enable Sleep Mode
    output wire  magic_wakeup_3,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_3,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_3,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_3,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 4

    // PCS SIGNALS TO PHY
    input wire   rxp_4,                    //  Differential Receive Data 
    output wire  txp_4,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_4,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_4,          //  Powerdown Enable from PCS
    output wire  led_crs_4,                //  Carrier Sense
    output wire  led_link_4,               //  Valid Link 
    output wire  led_col_4,                //  Collision Indication
    output wire  led_an_4,                 //  Auto-Negotiation Status
    output wire  led_char_err_4,           //  Character Error
    output wire  led_disp_err_4,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_4,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_4,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_4,            //  Start of Packet
    output wire  data_rx_eop_4,            //  End of Packet
    output wire  [7:0] data_rx_data_4,     //  Data from FIFO
    output wire  [4:0] data_rx_error_4,    //  Receive packet error
    output wire  data_rx_valid_4,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_4,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_4,   //  Frame Type Indication
    output wire  pkt_class_valid_4,        //  Frame Type Indication Valid 
    input wire   data_tx_error_4,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_4,     //  Data from FIFO transmit
    input wire   data_tx_valid_4,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_4,            //  Start of Packet
    input wire   data_tx_eop_4,            //  END of Packet
    output wire  data_tx_ready_4,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_4,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_4,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_4,               //  Xoff Pause frame generate 
    input wire   xon_gen_4,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_4,          //  Enable Sleep Mode
    output wire  magic_wakeup_4,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_4,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_4,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_4,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 5

    // PCS SIGNALS TO PHY
    input wire   rxp_5,                    //  Differential Receive Data 
    output wire  txp_5,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_5,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_5,          //  Powerdown Enable from PCS
    output wire  led_crs_5,                //  Carrier Sense
    output wire  led_link_5,               //  Valid Link 
    output wire  led_col_5,                //  Collision Indication
    output wire  led_an_5,                 //  Auto-Negotiation Status
    output wire  led_char_err_5,           //  Character Error
    output wire  led_disp_err_5,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_5,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_5,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_5,            //  Start of Packet
    output wire  data_rx_eop_5,            //  End of Packet
    output wire  [7:0] data_rx_data_5,     //  Data from FIFO
    output wire  [4:0] data_rx_error_5,    //  Receive packet error
    output wire  data_rx_valid_5,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_5,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_5,   //  Frame Type Indication
    output wire  pkt_class_valid_5,        //  Frame Type Indication Valid 
    input wire   data_tx_error_5,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_5,     //  Data from FIFO transmit
    input wire   data_tx_valid_5,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_5,            //  Start of Packet
    input wire   data_tx_eop_5,            //  END of Packet
    output wire  data_tx_ready_5,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_5,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_5,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_5,               //  Xoff Pause frame generate 
    input wire   xon_gen_5,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_5,          //  Enable Sleep Mode
    output wire  magic_wakeup_5,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_5,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_5,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_5,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 6

    // PCS SIGNALS TO PHY
    input wire   rxp_6,                    //  Differential Receive Data 
    output wire  txp_6,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_6,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_6,          //  Powerdown Enable from PCS
    output wire  led_crs_6,                //  Carrier Sense
    output wire  led_link_6,               //  Valid Link 
    output wire  led_col_6,                //  Collision Indication
    output wire  led_an_6,                 //  Auto-Negotiation Status
    output wire  led_char_err_6,           //  Character Error
    output wire  led_disp_err_6,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_6,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_6,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_6,            //  Start of Packet
    output wire  data_rx_eop_6,            //  End of Packet
    output wire  [7:0] data_rx_data_6,     //  Data from FIFO
    output wire  [4:0] data_rx_error_6,    //  Receive packet error
    output wire  data_rx_valid_6,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_6,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_6,   //  Frame Type Indication
    output wire  pkt_class_valid_6,        //  Frame Type Indication Valid 
    input wire   data_tx_error_6,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_6,     //  Data from FIFO transmit
    input wire   data_tx_valid_6,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_6,            //  Start of Packet
    input wire   data_tx_eop_6,            //  END of Packet
    output wire  data_tx_ready_6,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_6,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_6,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_6,               //  Xoff Pause frame generate 
    input wire   xon_gen_6,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_6,          //  Enable Sleep Mode
    output wire  magic_wakeup_6,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_6,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_6,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_6,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 7

    // PCS SIGNALS TO PHY
    input wire   rxp_7,                    //  Differential Receive Data 
    output wire  txp_7,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_7,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_7,          //  Powerdown Enable from PCS
    output wire  led_crs_7,                //  Carrier Sense
    output wire  led_link_7,               //  Valid Link 
    output wire  led_col_7,                //  Collision Indication
    output wire  led_an_7,                 //  Auto-Negotiation Status
    output wire  led_char_err_7,           //  Character Error
    output wire  led_disp_err_7,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_7,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_7,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_7,            //  Start of Packet
    output wire  data_rx_eop_7,            //  End of Packet
    output wire  [7:0] data_rx_data_7,     //  Data from FIFO
    output wire  [4:0] data_rx_error_7,    //  Receive packet error
    output wire  data_rx_valid_7,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_7,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_7,   //  Frame Type Indication
    output wire  pkt_class_valid_7,        //  Frame Type Indication Valid 
    input wire   data_tx_error_7,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_7,     //  Data from FIFO transmit
    input wire   data_tx_valid_7,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_7,            //  Start of Packet
    input wire   data_tx_eop_7,            //  END of Packet
    output wire  data_tx_ready_7,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_7,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_7,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_7,               //  Xoff Pause frame generate 
    input wire   xon_gen_7,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_7,          //  Enable Sleep Mode
    output wire  magic_wakeup_7,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_7,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_7,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_7,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 8

    // PCS SIGNALS TO PHY
    input wire   rxp_8,                    //  Differential Receive Data 
    output wire  txp_8,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_8,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_8,          //  Powerdown Enable from PCS
    output wire  led_crs_8,                //  Carrier Sense
    output wire  led_link_8,               //  Valid Link 
    output wire  led_col_8,                //  Collision Indication
    output wire  led_an_8,                 //  Auto-Negotiation Status
    output wire  led_char_err_8,           //  Character Error
    output wire  led_disp_err_8,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_8,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_8,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_8,            //  Start of Packet
    output wire  data_rx_eop_8,            //  End of Packet
    output wire  [7:0] data_rx_data_8,     //  Data from FIFO
    output wire  [4:0] data_rx_error_8,    //  Receive packet error
    output wire  data_rx_valid_8,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_8,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_8,   //  Frame Type Indication
    output wire  pkt_class_valid_8,        //  Frame Type Indication Valid 
    input wire   data_tx_error_8,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_8,     //  Data from FIFO transmit
    input wire   data_tx_valid_8,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_8,            //  Start of Packet
    input wire   data_tx_eop_8,            //  END of Packet
    output wire  data_tx_ready_8,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_8,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_8,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_8,               //  Xoff Pause frame generate 
    input wire   xon_gen_8,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_8,          //  Enable Sleep Mode
    output wire  magic_wakeup_8,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_8,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_8,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_8,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 9

    // PCS SIGNALS TO PHY
    input wire   rxp_9,                    //  Differential Receive Data 
    output wire  txp_9,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_9,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_9,          //  Powerdown Enable from PCS
    output wire  led_crs_9,                //  Carrier Sense
    output wire  led_link_9,               //  Valid Link 
    output wire  led_col_9,                //  Collision Indication
    output wire  led_an_9,                 //  Auto-Negotiation Status
    output wire  led_char_err_9,           //  Character Error
    output wire  led_disp_err_9,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_9,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_9,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_9,            //  Start of Packet
    output wire  data_rx_eop_9,            //  End of Packet
    output wire  [7:0] data_rx_data_9,     //  Data from FIFO
    output wire  [4:0] data_rx_error_9,    //  Receive packet error
    output wire  data_rx_valid_9,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_9,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_9,   //  Frame Type Indication
    output wire  pkt_class_valid_9,        //  Frame Type Indication Valid 
    input wire   data_tx_error_9,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_9,     //  Data from FIFO transmit
    input wire   data_tx_valid_9,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_9,            //  Start of Packet
    input wire   data_tx_eop_9,            //  END of Packet
    output wire  data_tx_ready_9,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_9,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_9,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_9,               //  Xoff Pause frame generate 
    input wire   xon_gen_9,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_9,          //  Enable Sleep Mode
    output wire  magic_wakeup_9,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_9,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_9,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_9,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 10

    // PCS SIGNALS TO PHY
    input wire   rxp_10,                    //  Differential Receive Data 
    output wire  txp_10,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_10,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_10,          //  Powerdown Enable from PCS
    output wire  led_crs_10,                //  Carrier Sense
    output wire  led_link_10,               //  Valid Link 
    output wire  led_col_10,                //  Collision Indication
    output wire  led_an_10,                 //  Auto-Negotiation Status
    output wire  led_char_err_10,           //  Character Error
    output wire  led_disp_err_10,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_10,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_10,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_10,            //  Start of Packet
    output wire  data_rx_eop_10,            //  End of Packet
    output wire  [7:0] data_rx_data_10,     //  Data from FIFO
    output wire  [4:0] data_rx_error_10,    //  Receive packet error
    output wire  data_rx_valid_10,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_10,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_10,   //  Frame Type Indication
    output wire  pkt_class_valid_10,        //  Frame Type Indication Valid 
    input wire   data_tx_error_10,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_10,     //  Data from FIFO transmit
    input wire   data_tx_valid_10,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_10,            //  Start of Packet
    input wire   data_tx_eop_10,            //  END of Packet
    output wire  data_tx_ready_10,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_10,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_10,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_10,               //  Xoff Pause frame generate 
    input wire   xon_gen_10,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_10,          //  Enable Sleep Mode
    output wire  magic_wakeup_10,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_10,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_10,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_10,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 11

    // PCS SIGNALS TO PHY
    input wire   rxp_11,                    //  Differential Receive Data 
    output wire  txp_11,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_11,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_11,          //  Powerdown Enable from PCS
    output wire  led_crs_11,                //  Carrier Sense
    output wire  led_link_11,               //  Valid Link 
    output wire  led_col_11,                //  Collision Indication
    output wire  led_an_11,                 //  Auto-Negotiation Status
    output wire  led_char_err_11,           //  Character Error
    output wire  led_disp_err_11,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_11,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_11,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_11,            //  Start of Packet
    output wire  data_rx_eop_11,            //  End of Packet
    output wire  [7:0] data_rx_data_11,     //  Data from FIFO
    output wire  [4:0] data_rx_error_11,    //  Receive packet error
    output wire  data_rx_valid_11,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_11,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_11,   //  Frame Type Indication
    output wire  pkt_class_valid_11,        //  Frame Type Indication Valid 
    input wire   data_tx_error_11,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_11,     //  Data from FIFO transmit
    input wire   data_tx_valid_11,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_11,            //  Start of Packet
    input wire   data_tx_eop_11,            //  END of Packet
    output wire  data_tx_ready_11,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_11,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_11,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_11,               //  Xoff Pause frame generate 
    input wire   xon_gen_11,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_11,          //  Enable Sleep Mode
    output wire  magic_wakeup_11,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_11,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_11,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_11,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 12

    // PCS SIGNALS TO PHY
    input wire   rxp_12,                    //  Differential Receive Data 
    output wire  txp_12,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_12,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_12,          //  Powerdown Enable from PCS
    output wire  led_crs_12,                //  Carrier Sense
    output wire  led_link_12,               //  Valid Link 
    output wire  led_col_12,                //  Collision Indication
    output wire  led_an_12,                 //  Auto-Negotiation Status
    output wire  led_char_err_12,           //  Character Error
    output wire  led_disp_err_12,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_12,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_12,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_12,            //  Start of Packet
    output wire  data_rx_eop_12,            //  End of Packet
    output wire  [7:0] data_rx_data_12,     //  Data from FIFO
    output wire  [4:0] data_rx_error_12,    //  Receive packet error
    output wire  data_rx_valid_12,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_12,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_12,   //  Frame Type Indication
    output wire  pkt_class_valid_12,        //  Frame Type Indication Valid 
    input wire   data_tx_error_12,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_12,     //  Data from FIFO transmit
    input wire   data_tx_valid_12,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_12,            //  Start of Packet
    input wire   data_tx_eop_12,            //  END of Packet
    output wire  data_tx_ready_12,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_12,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_12,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_12,               //  Xoff Pause frame generate 
    input wire   xon_gen_12,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_12,          //  Enable Sleep Mode
    output wire  magic_wakeup_12,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_12,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_12,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_12,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 13

    // PCS SIGNALS TO PHY
    input wire   rxp_13,                    //  Differential Receive Data 
    output wire  txp_13,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_13,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_13,          //  Powerdown Enable from PCS
    output wire  led_crs_13,                //  Carrier Sense
    output wire  led_link_13,               //  Valid Link 
    output wire  led_col_13,                //  Collision Indication
    output wire  led_an_13,                 //  Auto-Negotiation Status
    output wire  led_char_err_13,           //  Character Error
    output wire  led_disp_err_13,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_13,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_13,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_13,            //  Start of Packet
    output wire  data_rx_eop_13,            //  End of Packet
    output wire  [7:0] data_rx_data_13,     //  Data from FIFO
    output wire  [4:0] data_rx_error_13,    //  Receive packet error
    output wire  data_rx_valid_13,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_13,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_13,   //  Frame Type Indication
    output wire  pkt_class_valid_13,        //  Frame Type Indication Valid 
    input wire   data_tx_error_13,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_13,     //  Data from FIFO transmit
    input wire   data_tx_valid_13,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_13,            //  Start of Packet
    input wire   data_tx_eop_13,            //  END of Packet
    output wire  data_tx_ready_13,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_13,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_13,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_13,               //  Xoff Pause frame generate 
    input wire   xon_gen_13,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_13,          //  Enable Sleep Mode
    output wire  magic_wakeup_13,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_13,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_13,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_13,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 14

    // PCS SIGNALS TO PHY
    input wire   rxp_14,                    //  Differential Receive Data 
    output wire  txp_14,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_14,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_14,          //  Powerdown Enable from PCS
    output wire  led_crs_14,                //  Carrier Sense
    output wire  led_link_14,               //  Valid Link 
    output wire  led_col_14,                //  Collision Indication
    output wire  led_an_14,                 //  Auto-Negotiation Status
    output wire  led_char_err_14,           //  Character Error
    output wire  led_disp_err_14,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_14,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_14,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_14,            //  Start of Packet
    output wire  data_rx_eop_14,            //  End of Packet
    output wire  [7:0] data_rx_data_14,     //  Data from FIFO
    output wire  [4:0] data_rx_error_14,    //  Receive packet error
    output wire  data_rx_valid_14,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_14,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_14,   //  Frame Type Indication
    output wire  pkt_class_valid_14,        //  Frame Type Indication Valid 
    input wire   data_tx_error_14,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_14,     //  Data from FIFO transmit
    input wire   data_tx_valid_14,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_14,            //  Start of Packet
    input wire   data_tx_eop_14,            //  END of Packet
    output wire  data_tx_ready_14,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_14,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_14,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_14,               //  Xoff Pause frame generate 
    input wire   xon_gen_14,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_14,          //  Enable Sleep Mode
    output wire  magic_wakeup_14,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_14,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_14,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_14,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 15

    // PCS SIGNALS TO PHY
    input wire   rxp_15,                    //  Differential Receive Data 
    output wire  txp_15,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_15,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_15,          //  Powerdown Enable from PCS
    output wire  led_crs_15,                //  Carrier Sense
    output wire  led_link_15,               //  Valid Link 
    output wire  led_col_15,                //  Collision Indication
    output wire  led_an_15,                 //  Auto-Negotiation Status
    output wire  led_char_err_15,           //  Character Error
    output wire  led_disp_err_15,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_15,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_15,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_15,            //  Start of Packet
    output wire  data_rx_eop_15,            //  End of Packet
    output wire  [7:0] data_rx_data_15,     //  Data from FIFO
    output wire  [4:0] data_rx_error_15,    //  Receive packet error
    output wire  data_rx_valid_15,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_15,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_15,   //  Frame Type Indication
    output wire  pkt_class_valid_15,        //  Frame Type Indication Valid 
    input wire   data_tx_error_15,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_15,     //  Data from FIFO transmit
    input wire   data_tx_valid_15,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_15,            //  Start of Packet
    input wire   data_tx_eop_15,            //  END of Packet
    output wire  data_tx_ready_15,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_15,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_15,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_15,               //  Xoff Pause frame generate 
    input wire   xon_gen_15,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_15,          //  Enable Sleep Mode
    output wire  magic_wakeup_15,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_15,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_15,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_15,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 16

    // PCS SIGNALS TO PHY
    input wire   rxp_16,                    //  Differential Receive Data 
    output wire  txp_16,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_16,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_16,          //  Powerdown Enable from PCS
    output wire  led_crs_16,                //  Carrier Sense
    output wire  led_link_16,               //  Valid Link 
    output wire  led_col_16,                //  Collision Indication
    output wire  led_an_16,                 //  Auto-Negotiation Status
    output wire  led_char_err_16,           //  Character Error
    output wire  led_disp_err_16,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_16,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_16,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_16,            //  Start of Packet
    output wire  data_rx_eop_16,            //  End of Packet
    output wire  [7:0] data_rx_data_16,     //  Data from FIFO
    output wire  [4:0] data_rx_error_16,    //  Receive packet error
    output wire  data_rx_valid_16,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_16,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_16,   //  Frame Type Indication
    output wire  pkt_class_valid_16,        //  Frame Type Indication Valid 
    input wire   data_tx_error_16,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_16,     //  Data from FIFO transmit
    input wire   data_tx_valid_16,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_16,            //  Start of Packet
    input wire   data_tx_eop_16,            //  END of Packet
    output wire  data_tx_ready_16,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_16,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_16,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_16,               //  Xoff Pause frame generate 
    input wire   xon_gen_16,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_16,          //  Enable Sleep Mode
    output wire  magic_wakeup_16,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_16,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_16,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_16,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 17

    // PCS SIGNALS TO PHY
    input wire   rxp_17,                    //  Differential Receive Data 
    output wire  txp_17,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_17,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_17,          //  Powerdown Enable from PCS
    output wire  led_crs_17,                //  Carrier Sense
    output wire  led_link_17,               //  Valid Link 
    output wire  led_col_17,                //  Collision Indication
    output wire  led_an_17,                 //  Auto-Negotiation Status
    output wire  led_char_err_17,           //  Character Error
    output wire  led_disp_err_17,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_17,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_17,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_17,            //  Start of Packet
    output wire  data_rx_eop_17,            //  End of Packet
    output wire  [7:0] data_rx_data_17,     //  Data from FIFO
    output wire  [4:0] data_rx_error_17,    //  Receive packet error
    output wire  data_rx_valid_17,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_17,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_17,   //  Frame Type Indication
    output wire  pkt_class_valid_17,        //  Frame Type Indication Valid 
    input wire   data_tx_error_17,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_17,     //  Data from FIFO transmit
    input wire   data_tx_valid_17,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_17,            //  Start of Packet
    input wire   data_tx_eop_17,            //  END of Packet
    output wire  data_tx_ready_17,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_17,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_17,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_17,               //  Xoff Pause frame generate 
    input wire   xon_gen_17,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_17,          //  Enable Sleep Mode
    output wire  magic_wakeup_17,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_17,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_17,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_17,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 18

    // PCS SIGNALS TO PHY
    input wire   rxp_18,                    //  Differential Receive Data 
    output wire  txp_18,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_18,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_18,          //  Powerdown Enable from PCS
    output wire  led_crs_18,                //  Carrier Sense
    output wire  led_link_18,               //  Valid Link 
    output wire  led_col_18,                //  Collision Indication
    output wire  led_an_18,                 //  Auto-Negotiation Status
    output wire  led_char_err_18,           //  Character Error
    output wire  led_disp_err_18,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_18,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_18,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_18,            //  Start of Packet
    output wire  data_rx_eop_18,            //  End of Packet
    output wire  [7:0] data_rx_data_18,     //  Data from FIFO
    output wire  [4:0] data_rx_error_18,    //  Receive packet error
    output wire  data_rx_valid_18,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_18,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_18,   //  Frame Type Indication
    output wire  pkt_class_valid_18,        //  Frame Type Indication Valid 
    input wire   data_tx_error_18,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_18,     //  Data from FIFO transmit
    input wire   data_tx_valid_18,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_18,            //  Start of Packet
    input wire   data_tx_eop_18,            //  END of Packet
    output wire  data_tx_ready_18,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_18,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_18,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_18,               //  Xoff Pause frame generate 
    input wire   xon_gen_18,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_18,          //  Enable Sleep Mode
    output wire  magic_wakeup_18,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_18,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_18,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_18,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 19

    // PCS SIGNALS TO PHY
    input wire   rxp_19,                    //  Differential Receive Data 
    output wire  txp_19,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_19,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_19,          //  Powerdown Enable from PCS
    output wire  led_crs_19,                //  Carrier Sense
    output wire  led_link_19,               //  Valid Link 
    output wire  led_col_19,                //  Collision Indication
    output wire  led_an_19,                 //  Auto-Negotiation Status
    output wire  led_char_err_19,           //  Character Error
    output wire  led_disp_err_19,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_19,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_19,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_19,            //  Start of Packet
    output wire  data_rx_eop_19,            //  End of Packet
    output wire  [7:0] data_rx_data_19,     //  Data from FIFO
    output wire  [4:0] data_rx_error_19,    //  Receive packet error
    output wire  data_rx_valid_19,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_19,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_19,   //  Frame Type Indication
    output wire  pkt_class_valid_19,        //  Frame Type Indication Valid 
    input wire   data_tx_error_19,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_19,     //  Data from FIFO transmit
    input wire   data_tx_valid_19,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_19,            //  Start of Packet
    input wire   data_tx_eop_19,            //  END of Packet
    output wire  data_tx_ready_19,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_19,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_19,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_19,               //  Xoff Pause frame generate 
    input wire   xon_gen_19,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_19,          //  Enable Sleep Mode
    output wire  magic_wakeup_19,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_19,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_19,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_19,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 20

    // PCS SIGNALS TO PHY
    input wire   rxp_20,                    //  Differential Receive Data 
    output wire  txp_20,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_20,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_20,          //  Powerdown Enable from PCS
    output wire  led_crs_20,                //  Carrier Sense
    output wire  led_link_20,               //  Valid Link 
    output wire  led_col_20,                //  Collision Indication
    output wire  led_an_20,                 //  Auto-Negotiation Status
    output wire  led_char_err_20,           //  Character Error
    output wire  led_disp_err_20,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_20,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_20,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_20,            //  Start of Packet
    output wire  data_rx_eop_20,            //  End of Packet
    output wire  [7:0] data_rx_data_20,     //  Data from FIFO
    output wire  [4:0] data_rx_error_20,    //  Receive packet error
    output wire  data_rx_valid_20,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_20,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_20,   //  Frame Type Indication
    output wire  pkt_class_valid_20,        //  Frame Type Indication Valid 
    input wire   data_tx_error_20,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_20,     //  Data from FIFO transmit
    input wire   data_tx_valid_20,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_20,            //  Start of Packet
    input wire   data_tx_eop_20,            //  END of Packet
    output wire  data_tx_ready_20,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_20,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_20,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_20,               //  Xoff Pause frame generate 
    input wire   xon_gen_20,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_20,          //  Enable Sleep Mode
    output wire  magic_wakeup_20,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_20,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_20,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_20,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 21

    // PCS SIGNALS TO PHY
    input wire   rxp_21,                    //  Differential Receive Data 
    output wire  txp_21,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_21,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_21,          //  Powerdown Enable from PCS
    output wire  led_crs_21,                //  Carrier Sense
    output wire  led_link_21,               //  Valid Link 
    output wire  led_col_21,                //  Collision Indication
    output wire  led_an_21,                 //  Auto-Negotiation Status
    output wire  led_char_err_21,           //  Character Error
    output wire  led_disp_err_21,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_21,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_21,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_21,            //  Start of Packet
    output wire  data_rx_eop_21,            //  End of Packet
    output wire  [7:0] data_rx_data_21,     //  Data from FIFO
    output wire  [4:0] data_rx_error_21,    //  Receive packet error
    output wire  data_rx_valid_21,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_21,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_21,   //  Frame Type Indication
    output wire  pkt_class_valid_21,        //  Frame Type Indication Valid 
    input wire   data_tx_error_21,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_21,     //  Data from FIFO transmit
    input wire   data_tx_valid_21,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_21,            //  Start of Packet
    input wire   data_tx_eop_21,            //  END of Packet
    output wire  data_tx_ready_21,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_21,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_21,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_21,               //  Xoff Pause frame generate 
    input wire   xon_gen_21,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_21,          //  Enable Sleep Mode
    output wire  magic_wakeup_21,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_21,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_21,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_21,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 22

    // PCS SIGNALS TO PHY
    input wire   rxp_22,                    //  Differential Receive Data 
    output wire  txp_22,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_22,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_22,          //  Powerdown Enable from PCS
    output wire  led_crs_22,                //  Carrier Sense
    output wire  led_link_22,               //  Valid Link 
    output wire  led_col_22,                //  Collision Indication
    output wire  led_an_22,                 //  Auto-Negotiation Status
    output wire  led_char_err_22,           //  Character Error
    output wire  led_disp_err_22,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_22,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_22,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_22,            //  Start of Packet
    output wire  data_rx_eop_22,            //  End of Packet
    output wire  [7:0] data_rx_data_22,     //  Data from FIFO
    output wire  [4:0] data_rx_error_22,    //  Receive packet error
    output wire  data_rx_valid_22,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_22,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_22,   //  Frame Type Indication
    output wire  pkt_class_valid_22,        //  Frame Type Indication Valid 
    input wire   data_tx_error_22,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_22,     //  Data from FIFO transmit
    input wire   data_tx_valid_22,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_22,            //  Start of Packet
    input wire   data_tx_eop_22,            //  END of Packet
    output wire  data_tx_ready_22,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_22,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_22,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_22,               //  Xoff Pause frame generate 
    input wire   xon_gen_22,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_22,          //  Enable Sleep Mode
    output wire  magic_wakeup_22,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_22,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_22,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_22,  //  Signals from the gxb block to the reconfig block


    // CHANNEL 23

    // PCS SIGNALS TO PHY
    input wire   rxp_23,                    //  Differential Receive Data 
    output wire  txp_23,                    //  Differential Transmit Data 
    input wire   gxb_pwrdn_in_23,           //  Powerdown signal to GXB
    output wire  pcs_pwrdn_out_23,          //  Powerdown Enable from PCS
    output wire  led_crs_23,                //  Carrier Sense
    output wire  led_link_23,               //  Valid Link 
    output wire  led_col_23,                //  Collision Indication
    output wire  led_an_23,                 //  Auto-Negotiation Status
    output wire  led_char_err_23,           //  Character Error
    output wire  led_disp_err_23,           //  Disparity Error

    // AV-ST TX & RX
    output wire  mac_rx_clk_23,             //  Av-ST Receive Clock
    output wire  mac_tx_clk_23,             //  Av-ST Transmit Clock   
    output wire  data_rx_sop_23,            //  Start of Packet
    output wire  data_rx_eop_23,            //  End of Packet
    output wire  [7:0] data_rx_data_23,     //  Data from FIFO
    output wire  [4:0] data_rx_error_23,    //  Receive packet error
    output wire  data_rx_valid_23,          //  Data Receive FIFO Valid
    input wire   data_rx_ready_23,          //  Data Receive Ready
    output wire  [4:0] pkt_class_data_23,   //  Frame Type Indication
    output wire  pkt_class_valid_23,        //  Frame Type Indication Valid 
    input wire   data_tx_error_23,          //  STATUS FIFO (Tx frame Error from Apps)
    input wire   [7:0] data_tx_data_23,     //  Data from FIFO transmit
    input wire   data_tx_valid_23,          //  Data FIFO transmit Empty
    input wire   data_tx_sop_23,            //  Start of Packet
    input wire   data_tx_eop_23,            //  END of Packet
    output wire  data_tx_ready_23,          //  Data FIFO transmit Read Enable 	

    // STAND_ALONE CONDUITS 
    output wire  tx_ff_uflow_23,            //  TX FIFO underflow occured (Synchronous with tx_clk)
    input wire   tx_crc_fwd_23,             //  Forward Current Frame with CRC from Application
    input wire   xoff_gen_23,               //  Xoff Pause frame generate 
    input wire   xon_gen_23,                //  Xon Pause frame generate 
    input wire   magic_sleep_n_23,          //  Enable Sleep Mode
    output wire  magic_wakeup_23,           //  Wake Up Request

    // RECONFIG BLOCK SIGNALS
    input wire   reconfig_clk_23,             //  Clock for reconfiguration block
    input wire   [3:0] reconfig_togxb_23,     //  Signals from the reconfig block to the GXB block
    output wire  [16:0] reconfig_fromgxb_23); //  Signals from the gxb block to the reconfig block


wire    MAC_PCS_reset;
wire    [23:0] pcs_pwrdn_out_sig;
wire    [23:0] gxb_pwrdn_in_sig;
wire    gige_pma_reset;
wire    [23:0] led_char_err_gx;
wire    [23:0] link_status;
//wire    [23:0] pcs_clk;
wire    pcs_clk_c0;
wire    pcs_clk_c1;
wire    pcs_clk_c2;
wire    pcs_clk_c3;
wire    pcs_clk_c4;
wire    pcs_clk_c5;
wire    pcs_clk_c6;
wire    pcs_clk_c7;
wire    pcs_clk_c8;
wire    pcs_clk_c9;
wire    pcs_clk_c10;
wire    pcs_clk_c11;
wire    pcs_clk_c12;
wire    pcs_clk_c13;
wire    pcs_clk_c14;
wire    pcs_clk_c15;
wire    pcs_clk_c16;
wire    pcs_clk_c17;
wire    pcs_clk_c18;
wire    pcs_clk_c19;
wire    pcs_clk_c20;
wire    pcs_clk_c21;
wire    pcs_clk_c22;
wire    pcs_clk_c23;
wire    [23:0] rx_char_err_gx;
wire    [23:0] rx_disp_err;
wire    [23:0] rx_syncstatus;
wire    [23:0] rx_runlengthviolation;
wire    [23:0] rx_patterndetect;
wire    [23:0] rx_runningdisp;
wire    [23:0] rx_rmfifodatadeleted;
wire    [23:0] rx_rmfifodatainserted;
wire    [23:0] pcs_rx_rmfifodatadeleted;
wire    [23:0] pcs_rx_rmfifodatainserted;
wire    [23:0] pcs_rx_carrierdetected;

reg     pma_digital_rst0;
reg     pma_digital_rst1;
reg     pma_digital_rst2;
wire    rx_kchar_0;
wire    [7:0] rx_frame_0;
wire    pcs_rx_kchar_0;
wire    [7:0] pcs_rx_frame_0;
wire    tx_kchar_0;
wire    [7:0] tx_frame_0;
wire    rx_kchar_1;
wire    [7:0] rx_frame_1;
wire    pcs_rx_kchar_1;
wire    [7:0] pcs_rx_frame_1;
wire    tx_kchar_1;
wire    [7:0] tx_frame_1;
wire    rx_kchar_2;
wire    [7:0] rx_frame_2;
wire    pcs_rx_kchar_2;
wire    [7:0] pcs_rx_frame_2;
wire    tx_kchar_2;
wire    [7:0] tx_frame_2;
wire    rx_kchar_3;
wire    [7:0] rx_frame_3;
wire    pcs_rx_kchar_3;
wire    [7:0] pcs_rx_frame_3;
wire    tx_kchar_3;
wire    [7:0] tx_frame_3;
wire    rx_kchar_4;
wire    [7:0] rx_frame_4;
wire    pcs_rx_kchar_4;
wire    [7:0] pcs_rx_frame_4;
wire    tx_kchar_4;
wire    [7:0] tx_frame_4;
wire    rx_kchar_5;
wire    [7:0] rx_frame_5;
wire    pcs_rx_kchar_5;
wire    [7:0] pcs_rx_frame_5;
wire    tx_kchar_5;
wire    [7:0] tx_frame_5;
wire    rx_kchar_6;
wire    [7:0] rx_frame_6;
wire    pcs_rx_kchar_6;
wire    [7:0] pcs_rx_frame_6;
wire    tx_kchar_6;
wire    [7:0] tx_frame_6;
wire    rx_kchar_7;
wire    [7:0] rx_frame_7;
wire    pcs_rx_kchar_7;
wire    [7:0] pcs_rx_frame_7;
wire    tx_kchar_7;
wire    [7:0] tx_frame_7;
wire    rx_kchar_8;
wire    [7:0] rx_frame_8;
wire    pcs_rx_kchar_8;
wire    [7:0] pcs_rx_frame_8;
wire    tx_kchar_8;
wire    [7:0] tx_frame_8;
wire    rx_kchar_9;
wire    [7:0] rx_frame_9;
wire    pcs_rx_kchar_9;
wire    [7:0] pcs_rx_frame_9;
wire    tx_kchar_9;
wire    [7:0] tx_frame_9;
wire    rx_kchar_10;
wire    [7:0] rx_frame_10;
wire    pcs_rx_kchar_10;
wire    [7:0] pcs_rx_frame_10;
wire    tx_kchar_10;
wire    [7:0] tx_frame_10;
wire    rx_kchar_11;
wire    [7:0] rx_frame_11;
wire    pcs_rx_kchar_11;
wire    [7:0] pcs_rx_frame_11;
wire    tx_kchar_11;
wire    [7:0] tx_frame_11;
wire    rx_kchar_12;
wire    [7:0] rx_frame_12;
wire    pcs_rx_kchar_12;
wire    [7:0] pcs_rx_frame_12;
wire    tx_kchar_12;
wire    [7:0] tx_frame_12;
wire    rx_kchar_13;
wire    [7:0] rx_frame_13;
wire    pcs_rx_kchar_13;
wire    [7:0] pcs_rx_frame_13;
wire    tx_kchar_13;
wire    [7:0] tx_frame_13;
wire    rx_kchar_14;
wire    [7:0] rx_frame_14;
wire    pcs_rx_kchar_14;
wire    [7:0] pcs_rx_frame_14;
wire    tx_kchar_14;
wire    [7:0] tx_frame_14;
wire    rx_kchar_15;
wire    [7:0] rx_frame_15;
wire    pcs_rx_kchar_15;
wire    [7:0] pcs_rx_frame_15;
wire    tx_kchar_15;
wire    [7:0] tx_frame_15;
wire    rx_kchar_16;
wire    [7:0] rx_frame_16;
wire    pcs_rx_kchar_16;
wire    [7:0] pcs_rx_frame_16;
wire    tx_kchar_16;
wire    [7:0] tx_frame_16;
wire    rx_kchar_17;
wire    [7:0] rx_frame_17;
wire    pcs_rx_kchar_17;
wire    [7:0] pcs_rx_frame_17;
wire    tx_kchar_17;
wire    [7:0] tx_frame_17;
wire    rx_kchar_18;
wire    [7:0] rx_frame_18;
wire    pcs_rx_kchar_18;
wire    [7:0] pcs_rx_frame_18;
wire    tx_kchar_18;
wire    [7:0] tx_frame_18;
wire    rx_kchar_19;
wire    [7:0] rx_frame_19;
wire    pcs_rx_kchar_19;
wire    [7:0] pcs_rx_frame_19;
wire    tx_kchar_19;
wire    [7:0] tx_frame_19;
wire    rx_kchar_20;
wire    [7:0] rx_frame_20;
wire    pcs_rx_kchar_20;
wire    [7:0] pcs_rx_frame_20;
wire    tx_kchar_20;
wire    [7:0] tx_frame_20;
wire    rx_kchar_21;
wire    [7:0] rx_frame_21;
wire    pcs_rx_kchar_21;
wire    [7:0] pcs_rx_frame_21;
wire    tx_kchar_21;
wire    [7:0] tx_frame_21;
wire    rx_kchar_22;
wire    [7:0] rx_frame_22;
wire    pcs_rx_kchar_22;
wire    [7:0] pcs_rx_frame_22;
wire    tx_kchar_22;
wire    [7:0] tx_frame_22;
wire    rx_kchar_23;
wire    [7:0] rx_frame_23;
wire    pcs_rx_kchar_23;
wire    [7:0] pcs_rx_frame_23;
wire    tx_kchar_23;
wire    [7:0] tx_frame_23;




    // Reset logic used to reset the PMA blocks
    // ----------------------------------------
    always @(posedge clk or posedge reset)
      begin
        if (reset == 1)
          begin
            pma_digital_rst0 <= reset;
            pma_digital_rst1 <= reset;
            pma_digital_rst2 <= reset;
          end
        else 
          begin
            pma_digital_rst0 <= reset;
            pma_digital_rst1 <= pma_digital_rst0;
            pma_digital_rst2 <= pma_digital_rst1;
          end
      end


    //  Assign the digital reset of the PMA to the MAC_PCS logic
    //  --------------------------------------------------------
    assign MAC_PCS_reset = pma_digital_rst2;
	
	// Assign pcs clock for all channels
	//assign pcs_clk = {pcs_clk_c23,pcs_clk_c22,pcs_clk_c21,pcs_clk_c20,pcs_clk_c19,pcs_clk_c18,pcs_clk_c17,pcs_clk_c16,pcs_clk_c15,pcs_clk_c14,pcs_clk_c13,pcs_clk_c12,pcs_clk_c11,pcs_clk_c10,pcs_clk_c9,pcs_clk_c8,pcs_clk_c7,pcs_clk_c6,pcs_clk_c5,pcs_clk_c4,pcs_clk_c3,pcs_clk_c2,pcs_clk_c1,pcs_clk_c0};

    //  Assign the character error and link status to top level leds
    //  ------------------------------------------------------------
    assign led_char_err_0 = led_char_err_gx[0];
    assign led_link_0 = link_status[0];
    assign led_char_err_1 = led_char_err_gx[1];
    assign led_link_1 = link_status[1];
    assign led_char_err_2 = led_char_err_gx[2];
    assign led_link_2 = link_status[2];
    assign led_char_err_3 = led_char_err_gx[3];
    assign led_link_3 = link_status[3];
    assign led_char_err_4 = led_char_err_gx[4];
    assign led_link_4 = link_status[4];
    assign led_char_err_5 = led_char_err_gx[5];
    assign led_link_5 = link_status[5];
    assign led_char_err_6 = led_char_err_gx[6];
    assign led_link_6 = link_status[6];
    assign led_char_err_7 = led_char_err_gx[7];
    assign led_link_7 = link_status[7];
    assign led_char_err_8 = led_char_err_gx[8];
    assign led_link_8 = link_status[8];
    assign led_char_err_9 = led_char_err_gx[9];
    assign led_link_9 = link_status[9];
    assign led_char_err_10 = led_char_err_gx[10];
    assign led_link_10 = link_status[10];
    assign led_char_err_11 = led_char_err_gx[11];
    assign led_link_11 = link_status[11];
    assign led_char_err_12 = led_char_err_gx[12];
    assign led_link_12 = link_status[12];
    assign led_char_err_13 = led_char_err_gx[13];
    assign led_link_13 = link_status[13];
    assign led_char_err_14 = led_char_err_gx[14];
    assign led_link_14 = link_status[14];
    assign led_char_err_15 = led_char_err_gx[15];
    assign led_link_15 = link_status[15];
    assign led_char_err_16 = led_char_err_gx[16];
    assign led_link_16 = link_status[16];
    assign led_char_err_17 = led_char_err_gx[17];
    assign led_link_17 = link_status[17];
    assign led_char_err_18 = led_char_err_gx[18];
    assign led_link_18 = link_status[18];
    assign led_char_err_19 = led_char_err_gx[19];
    assign led_link_19 = link_status[19];
    assign led_char_err_20 = led_char_err_gx[20];
    assign led_link_20 = link_status[20];
    assign led_char_err_21 = led_char_err_gx[21];
    assign led_link_21 = link_status[21];
    assign led_char_err_22 = led_char_err_gx[22];
    assign led_link_22 = link_status[22];
    assign led_char_err_23 = led_char_err_gx[23];
    assign led_link_23 = link_status[23];


    // Instantiation of the MAC_PCS core that connects to a PMA
    // --------------------------------------------------------

    altera_tse_top_multi_mac_pcs_gige U_MULTI_MAC_PCS(

        .reset(reset),                            //INPUT  : ASYNCHRONOUS RESET - clk DOMAIN
        .clk(clk),                                //INPUT  : CLOCK
        .read(read),                              //INPUT  : REGISTER READ TRANSACTION
        .ref_clk(ref_clk),                        //INPUT  : REFERENCE CLOCK 
        .write(write),                            //INPUT  : REGISTER WRITE TRANSACTION
        .address(address),                        //INPUT  : REGISTER ADDRESS
        .writedata(writedata),                    //INPUT  : REGISTER WRITE DATA
        .readdata(readdata),                      //OUTPUT : REGISTER READ DATA
        .waitrequest(waitrequest),                //OUTPUT : TRANSACTION BUSY, ACTIVE LOW
        .mdc(mdc),                                //OUTPUT : MDIO Clock 
        .mdio_out(mdio_out),                      //OUTPUT : Outgoing MDIO DATA
        .mdio_in(mdio_in),                        //INPUT  : Incoming MDIO DATA       
        .mdio_oen(mdio_oen),                      //OUTPUT : MDIO Output Enable
        .mac_rx_clk(mac_rx_clk),                  //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk(mac_tx_clk),                  //OUTPUT : Av-ST Tx Clock
	    .rx_afull_clk(rx_afull_clk),              //INPUT  : AFull Status Clock
	    .rx_afull_data(rx_afull_data),            //INPUT  : AFull Status Data
	    .rx_afull_valid(rx_afull_valid),          //INPUT  : AFull Status Valid
	    .rx_afull_channel(rx_afull_channel),      //INPUT  : AFull Status Channel

         // Channel 0 
            

        .rx_carrierdetected_0(pcs_rx_carrierdetected[0]),
        .rx_rmfifodatadeleted_0(pcs_rx_rmfifodatadeleted[0]),
        .rx_rmfifodatainserted_0(pcs_rx_rmfifodatainserted[0]),

        .rx_clkout_0(pcs_clk_c0),                 //INPUT  : Receive Clock
        .tx_clkout_0(pcs_clk_c0),                 //INPUT  : Transmit Clock
        .rx_kchar_0(pcs_rx_kchar_0),              //INPUT  : Special Character Indication
        .tx_kchar_0(tx_kchar_0),                  //OUTPUT : Special Character Indication
        .rx_frame_0(pcs_rx_frame_0),              //INPUT  : Frame
        .tx_frame_0(tx_frame_0),                  //OUTPUT : Frame
        .sd_loopback_0(sd_loopback_0),            //OUTPUT : SERDES Loopback Enable
        .powerdown_0(pcs_pwrdn_out_sig[0]),       //OUTPUT : Powerdown Enable
        .led_col_0(led_col_0),                    //OUTPUT : Collision Indication
        .led_an_0(led_an_0),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_0(led_char_err_gx[0]),      //INPUT  : Character error
        .led_crs_0(led_crs_0),                    //OUTPUT : Carrier sense
        .led_link_0(link_status[0]),              //INPUT  : Valid link    
        .mac_rx_clk_0(mac_rx_clk_0),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_0(mac_tx_clk_0),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_0(data_rx_sop_0),            //OUTPUT : Start of Packet
        .data_rx_eop_0(data_rx_eop_0),            //OUTPUT : End of Packet
        .data_rx_data_0(data_rx_data_0),          //OUTPUT : Data from FIFO
        .data_rx_error_0(data_rx_error_0),        //OUTPUT : Receive packet error
        .data_rx_valid_0(data_rx_valid_0),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_0(data_rx_ready_0),        //OUTPUT : Data Receive Ready
        .pkt_class_data_0(pkt_class_data_0),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_0(pkt_class_valid_0),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_0(data_tx_error_0),        //INPUT  : Status
        .data_tx_data_0(data_tx_data_0),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_0(data_tx_valid_0),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_0(data_tx_sop_0),            //INPUT  : Start of Packet
        .data_tx_eop_0(data_tx_eop_0),            //INPUT  : End of Packet
        .data_tx_ready_0(data_tx_ready_0),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_0(tx_ff_uflow_0),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_0(tx_crc_fwd_0),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_0(xoff_gen_0),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_0(xon_gen_0),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_0(magic_sleep_n_0),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_0(magic_wakeup_0),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 1 
            

        .rx_carrierdetected_1(pcs_rx_carrierdetected[1]),
        .rx_rmfifodatadeleted_1(pcs_rx_rmfifodatadeleted[1]),
        .rx_rmfifodatainserted_1(pcs_rx_rmfifodatainserted[1]),

        .rx_clkout_1(pcs_clk_c1),                 //INPUT  : Receive Clock
        .tx_clkout_1(pcs_clk_c1),                 //INPUT  : Transmit Clock
        .rx_kchar_1(pcs_rx_kchar_1),              //INPUT  : Special Character Indication
        .tx_kchar_1(tx_kchar_1),                  //OUTPUT : Special Character Indication
        .rx_frame_1(pcs_rx_frame_1),              //INPUT  : Frame
        .tx_frame_1(tx_frame_1),                  //OUTPUT : Frame
        .sd_loopback_1(sd_loopback_1),            //OUTPUT : SERDES Loopback Enable
        .powerdown_1(pcs_pwrdn_out_sig[1]),       //OUTPUT : Powerdown Enable
        .led_col_1(led_col_1),                    //OUTPUT : Collision Indication
        .led_an_1(led_an_1),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_1(led_char_err_gx[1]),      //INPUT  : Character error
        .led_crs_1(led_crs_1),                    //OUTPUT : Carrier sense
        .led_link_1(link_status[1]),              //INPUT  : Valid link    
        .mac_rx_clk_1(mac_rx_clk_1),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_1(mac_tx_clk_1),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_1(data_rx_sop_1),            //OUTPUT : Start of Packet
        .data_rx_eop_1(data_rx_eop_1),            //OUTPUT : End of Packet
        .data_rx_data_1(data_rx_data_1),          //OUTPUT : Data from FIFO
        .data_rx_error_1(data_rx_error_1),        //OUTPUT : Receive packet error
        .data_rx_valid_1(data_rx_valid_1),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_1(data_rx_ready_1),        //OUTPUT : Data Receive Ready
        .pkt_class_data_1(pkt_class_data_1),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_1(pkt_class_valid_1),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_1(data_tx_error_1),        //INPUT  : Status
        .data_tx_data_1(data_tx_data_1),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_1(data_tx_valid_1),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_1(data_tx_sop_1),            //INPUT  : Start of Packet
        .data_tx_eop_1(data_tx_eop_1),            //INPUT  : End of Packet
        .data_tx_ready_1(data_tx_ready_1),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_1(tx_ff_uflow_1),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_1(tx_crc_fwd_1),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_1(xoff_gen_1),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_1(xon_gen_1),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_1(magic_sleep_n_1),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_1(magic_wakeup_1),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 2 
            

        .rx_carrierdetected_2(pcs_rx_carrierdetected[2]),
        .rx_rmfifodatadeleted_2(pcs_rx_rmfifodatadeleted[2]),
        .rx_rmfifodatainserted_2(pcs_rx_rmfifodatainserted[2]),

        .rx_clkout_2(pcs_clk_c2),                 //INPUT  : Receive Clock
        .tx_clkout_2(pcs_clk_c2),                 //INPUT  : Transmit Clock
        .rx_kchar_2(pcs_rx_kchar_2),              //INPUT  : Special Character Indication
        .tx_kchar_2(tx_kchar_2),                  //OUTPUT : Special Character Indication
        .rx_frame_2(pcs_rx_frame_2),              //INPUT  : Frame
        .tx_frame_2(tx_frame_2),                  //OUTPUT : Frame
        .sd_loopback_2(sd_loopback_2),            //OUTPUT : SERDES Loopback Enable
        .powerdown_2(pcs_pwrdn_out_sig[2]),       //OUTPUT : Powerdown Enable
        .led_col_2(led_col_2),                    //OUTPUT : Collision Indication
        .led_an_2(led_an_2),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_2(led_char_err_gx[2]),      //INPUT  : Character error
        .led_crs_2(led_crs_2),                    //OUTPUT : Carrier sense
        .led_link_2(link_status[2]),              //INPUT  : Valid link    
        .mac_rx_clk_2(mac_rx_clk_2),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_2(mac_tx_clk_2),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_2(data_rx_sop_2),            //OUTPUT : Start of Packet
        .data_rx_eop_2(data_rx_eop_2),            //OUTPUT : End of Packet
        .data_rx_data_2(data_rx_data_2),          //OUTPUT : Data from FIFO
        .data_rx_error_2(data_rx_error_2),        //OUTPUT : Receive packet error
        .data_rx_valid_2(data_rx_valid_2),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_2(data_rx_ready_2),        //OUTPUT : Data Receive Ready
        .pkt_class_data_2(pkt_class_data_2),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_2(pkt_class_valid_2),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_2(data_tx_error_2),        //INPUT  : Status
        .data_tx_data_2(data_tx_data_2),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_2(data_tx_valid_2),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_2(data_tx_sop_2),            //INPUT  : Start of Packet
        .data_tx_eop_2(data_tx_eop_2),            //INPUT  : End of Packet
        .data_tx_ready_2(data_tx_ready_2),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_2(tx_ff_uflow_2),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_2(tx_crc_fwd_2),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_2(xoff_gen_2),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_2(xon_gen_2),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_2(magic_sleep_n_2),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_2(magic_wakeup_2),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 3 
            

        .rx_carrierdetected_3(pcs_rx_carrierdetected[3]),
        .rx_rmfifodatadeleted_3(pcs_rx_rmfifodatadeleted[3]),
        .rx_rmfifodatainserted_3(pcs_rx_rmfifodatainserted[3]),

        .rx_clkout_3(pcs_clk_c3),                 //INPUT  : Receive Clock
        .tx_clkout_3(pcs_clk_c3),                 //INPUT  : Transmit Clock
        .rx_kchar_3(pcs_rx_kchar_3),              //INPUT  : Special Character Indication
        .tx_kchar_3(tx_kchar_3),                  //OUTPUT : Special Character Indication
        .rx_frame_3(pcs_rx_frame_3),              //INPUT  : Frame
        .tx_frame_3(tx_frame_3),                  //OUTPUT : Frame
        .sd_loopback_3(sd_loopback_3),            //OUTPUT : SERDES Loopback Enable
        .powerdown_3(pcs_pwrdn_out_sig[3]),       //OUTPUT : Powerdown Enable
        .led_col_3(led_col_3),                    //OUTPUT : Collision Indication
        .led_an_3(led_an_3),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_3(led_char_err_gx[3]),      //INPUT  : Character error
        .led_crs_3(led_crs_3),                    //OUTPUT : Carrier sense
        .led_link_3(link_status[3]),              //INPUT  : Valid link    
        .mac_rx_clk_3(mac_rx_clk_3),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_3(mac_tx_clk_3),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_3(data_rx_sop_3),            //OUTPUT : Start of Packet
        .data_rx_eop_3(data_rx_eop_3),            //OUTPUT : End of Packet
        .data_rx_data_3(data_rx_data_3),          //OUTPUT : Data from FIFO
        .data_rx_error_3(data_rx_error_3),        //OUTPUT : Receive packet error
        .data_rx_valid_3(data_rx_valid_3),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_3(data_rx_ready_3),        //OUTPUT : Data Receive Ready
        .pkt_class_data_3(pkt_class_data_3),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_3(pkt_class_valid_3),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_3(data_tx_error_3),        //INPUT  : Status
        .data_tx_data_3(data_tx_data_3),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_3(data_tx_valid_3),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_3(data_tx_sop_3),            //INPUT  : Start of Packet
        .data_tx_eop_3(data_tx_eop_3),            //INPUT  : End of Packet
        .data_tx_ready_3(data_tx_ready_3),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_3(tx_ff_uflow_3),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_3(tx_crc_fwd_3),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_3(xoff_gen_3),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_3(xon_gen_3),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_3(magic_sleep_n_3),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_3(magic_wakeup_3),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 4 
            

        .rx_carrierdetected_4(pcs_rx_carrierdetected[4]),
        .rx_rmfifodatadeleted_4(pcs_rx_rmfifodatadeleted[4]),
        .rx_rmfifodatainserted_4(pcs_rx_rmfifodatainserted[4]),

        .rx_clkout_4(pcs_clk_c4),                 //INPUT  : Receive Clock
        .tx_clkout_4(pcs_clk_c4),                 //INPUT  : Transmit Clock
        .rx_kchar_4(pcs_rx_kchar_4),              //INPUT  : Special Character Indication
        .tx_kchar_4(tx_kchar_4),                  //OUTPUT : Special Character Indication
        .rx_frame_4(pcs_rx_frame_4),              //INPUT  : Frame
        .tx_frame_4(tx_frame_4),                  //OUTPUT : Frame
        .sd_loopback_4(sd_loopback_4),            //OUTPUT : SERDES Loopback Enable
        .powerdown_4(pcs_pwrdn_out_sig[4]),       //OUTPUT : Powerdown Enable
        .led_col_4(led_col_4),                    //OUTPUT : Collision Indication
        .led_an_4(led_an_4),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_4(led_char_err_gx[4]),      //INPUT  : Character error
        .led_crs_4(led_crs_4),                    //OUTPUT : Carrier sense
        .led_link_4(link_status[4]),              //INPUT  : Valid link    
        .mac_rx_clk_4(mac_rx_clk_4),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_4(mac_tx_clk_4),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_4(data_rx_sop_4),            //OUTPUT : Start of Packet
        .data_rx_eop_4(data_rx_eop_4),            //OUTPUT : End of Packet
        .data_rx_data_4(data_rx_data_4),          //OUTPUT : Data from FIFO
        .data_rx_error_4(data_rx_error_4),        //OUTPUT : Receive packet error
        .data_rx_valid_4(data_rx_valid_4),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_4(data_rx_ready_4),        //OUTPUT : Data Receive Ready
        .pkt_class_data_4(pkt_class_data_4),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_4(pkt_class_valid_4),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_4(data_tx_error_4),        //INPUT  : Status
        .data_tx_data_4(data_tx_data_4),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_4(data_tx_valid_4),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_4(data_tx_sop_4),            //INPUT  : Start of Packet
        .data_tx_eop_4(data_tx_eop_4),            //INPUT  : End of Packet
        .data_tx_ready_4(data_tx_ready_4),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_4(tx_ff_uflow_4),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_4(tx_crc_fwd_4),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_4(xoff_gen_4),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_4(xon_gen_4),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_4(magic_sleep_n_4),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_4(magic_wakeup_4),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 5 
            

        .rx_carrierdetected_5(pcs_rx_carrierdetected[5]),
        .rx_rmfifodatadeleted_5(pcs_rx_rmfifodatadeleted[5]),
        .rx_rmfifodatainserted_5(pcs_rx_rmfifodatainserted[5]),

        .rx_clkout_5(pcs_clk_c5),                 //INPUT  : Receive Clock
        .tx_clkout_5(pcs_clk_c5),                 //INPUT  : Transmit Clock
        .rx_kchar_5(pcs_rx_kchar_5),              //INPUT  : Special Character Indication
        .tx_kchar_5(tx_kchar_5),                  //OUTPUT : Special Character Indication
        .rx_frame_5(pcs_rx_frame_5),              //INPUT  : Frame
        .tx_frame_5(tx_frame_5),                  //OUTPUT : Frame
        .sd_loopback_5(sd_loopback_5),            //OUTPUT : SERDES Loopback Enable
        .powerdown_5(pcs_pwrdn_out_sig[5]),       //OUTPUT : Powerdown Enable
        .led_col_5(led_col_5),                    //OUTPUT : Collision Indication
        .led_an_5(led_an_5),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_5(led_char_err_gx[5]),      //INPUT  : Character error
        .led_crs_5(led_crs_5),                    //OUTPUT : Carrier sense
        .led_link_5(link_status[5]),              //INPUT  : Valid link    
        .mac_rx_clk_5(mac_rx_clk_5),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_5(mac_tx_clk_5),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_5(data_rx_sop_5),            //OUTPUT : Start of Packet
        .data_rx_eop_5(data_rx_eop_5),            //OUTPUT : End of Packet
        .data_rx_data_5(data_rx_data_5),          //OUTPUT : Data from FIFO
        .data_rx_error_5(data_rx_error_5),        //OUTPUT : Receive packet error
        .data_rx_valid_5(data_rx_valid_5),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_5(data_rx_ready_5),        //OUTPUT : Data Receive Ready
        .pkt_class_data_5(pkt_class_data_5),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_5(pkt_class_valid_5),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_5(data_tx_error_5),        //INPUT  : Status
        .data_tx_data_5(data_tx_data_5),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_5(data_tx_valid_5),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_5(data_tx_sop_5),            //INPUT  : Start of Packet
        .data_tx_eop_5(data_tx_eop_5),            //INPUT  : End of Packet
        .data_tx_ready_5(data_tx_ready_5),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_5(tx_ff_uflow_5),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_5(tx_crc_fwd_5),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_5(xoff_gen_5),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_5(xon_gen_5),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_5(magic_sleep_n_5),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_5(magic_wakeup_5),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 6 
            

        .rx_carrierdetected_6(pcs_rx_carrierdetected[6]),
        .rx_rmfifodatadeleted_6(pcs_rx_rmfifodatadeleted[6]),
        .rx_rmfifodatainserted_6(pcs_rx_rmfifodatainserted[6]),

        .rx_clkout_6(pcs_clk_c6),                 //INPUT  : Receive Clock
        .tx_clkout_6(pcs_clk_c6),                 //INPUT  : Transmit Clock
        .rx_kchar_6(pcs_rx_kchar_6),              //INPUT  : Special Character Indication
        .tx_kchar_6(tx_kchar_6),                  //OUTPUT : Special Character Indication
        .rx_frame_6(pcs_rx_frame_6),              //INPUT  : Frame
        .tx_frame_6(tx_frame_6),                  //OUTPUT : Frame
        .sd_loopback_6(sd_loopback_6),            //OUTPUT : SERDES Loopback Enable
        .powerdown_6(pcs_pwrdn_out_sig[6]),       //OUTPUT : Powerdown Enable
        .led_col_6(led_col_6),                    //OUTPUT : Collision Indication
        .led_an_6(led_an_6),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_6(led_char_err_gx[6]),      //INPUT  : Character error
        .led_crs_6(led_crs_6),                    //OUTPUT : Carrier sense
        .led_link_6(link_status[6]),              //INPUT  : Valid link    
        .mac_rx_clk_6(mac_rx_clk_6),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_6(mac_tx_clk_6),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_6(data_rx_sop_6),            //OUTPUT : Start of Packet
        .data_rx_eop_6(data_rx_eop_6),            //OUTPUT : End of Packet
        .data_rx_data_6(data_rx_data_6),          //OUTPUT : Data from FIFO
        .data_rx_error_6(data_rx_error_6),        //OUTPUT : Receive packet error
        .data_rx_valid_6(data_rx_valid_6),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_6(data_rx_ready_6),        //OUTPUT : Data Receive Ready
        .pkt_class_data_6(pkt_class_data_6),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_6(pkt_class_valid_6),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_6(data_tx_error_6),        //INPUT  : Status
        .data_tx_data_6(data_tx_data_6),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_6(data_tx_valid_6),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_6(data_tx_sop_6),            //INPUT  : Start of Packet
        .data_tx_eop_6(data_tx_eop_6),            //INPUT  : End of Packet
        .data_tx_ready_6(data_tx_ready_6),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_6(tx_ff_uflow_6),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_6(tx_crc_fwd_6),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_6(xoff_gen_6),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_6(xon_gen_6),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_6(magic_sleep_n_6),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_6(magic_wakeup_6),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 7 
            

        .rx_carrierdetected_7(pcs_rx_carrierdetected[7]),
        .rx_rmfifodatadeleted_7(pcs_rx_rmfifodatadeleted[7]),
        .rx_rmfifodatainserted_7(pcs_rx_rmfifodatainserted[7]),

        .rx_clkout_7(pcs_clk_c7),                 //INPUT  : Receive Clock
        .tx_clkout_7(pcs_clk_c7),                 //INPUT  : Transmit Clock
        .rx_kchar_7(pcs_rx_kchar_7),              //INPUT  : Special Character Indication
        .tx_kchar_7(tx_kchar_7),                  //OUTPUT : Special Character Indication
        .rx_frame_7(pcs_rx_frame_7),              //INPUT  : Frame
        .tx_frame_7(tx_frame_7),                  //OUTPUT : Frame
        .sd_loopback_7(sd_loopback_7),            //OUTPUT : SERDES Loopback Enable
        .powerdown_7(pcs_pwrdn_out_sig[7]),       //OUTPUT : Powerdown Enable
        .led_col_7(led_col_7),                    //OUTPUT : Collision Indication
        .led_an_7(led_an_7),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_7(led_char_err_gx[7]),      //INPUT  : Character error
        .led_crs_7(led_crs_7),                    //OUTPUT : Carrier sense
        .led_link_7(link_status[7]),              //INPUT  : Valid link    
        .mac_rx_clk_7(mac_rx_clk_7),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_7(mac_tx_clk_7),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_7(data_rx_sop_7),            //OUTPUT : Start of Packet
        .data_rx_eop_7(data_rx_eop_7),            //OUTPUT : End of Packet
        .data_rx_data_7(data_rx_data_7),          //OUTPUT : Data from FIFO
        .data_rx_error_7(data_rx_error_7),        //OUTPUT : Receive packet error
        .data_rx_valid_7(data_rx_valid_7),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_7(data_rx_ready_7),        //OUTPUT : Data Receive Ready
        .pkt_class_data_7(pkt_class_data_7),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_7(pkt_class_valid_7),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_7(data_tx_error_7),        //INPUT  : Status
        .data_tx_data_7(data_tx_data_7),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_7(data_tx_valid_7),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_7(data_tx_sop_7),            //INPUT  : Start of Packet
        .data_tx_eop_7(data_tx_eop_7),            //INPUT  : End of Packet
        .data_tx_ready_7(data_tx_ready_7),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_7(tx_ff_uflow_7),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_7(tx_crc_fwd_7),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_7(xoff_gen_7),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_7(xon_gen_7),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_7(magic_sleep_n_7),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_7(magic_wakeup_7),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 8 
            

        .rx_carrierdetected_8(pcs_rx_carrierdetected[8]),
        .rx_rmfifodatadeleted_8(pcs_rx_rmfifodatadeleted[8]),
        .rx_rmfifodatainserted_8(pcs_rx_rmfifodatainserted[8]),

        .rx_clkout_8(pcs_clk_c8),                 //INPUT  : Receive Clock
        .tx_clkout_8(pcs_clk_c8),                 //INPUT  : Transmit Clock
        .rx_kchar_8(pcs_rx_kchar_8),              //INPUT  : Special Character Indication
        .tx_kchar_8(tx_kchar_8),                  //OUTPUT : Special Character Indication
        .rx_frame_8(pcs_rx_frame_8),              //INPUT  : Frame
        .tx_frame_8(tx_frame_8),                  //OUTPUT : Frame
        .sd_loopback_8(sd_loopback_8),            //OUTPUT : SERDES Loopback Enable
        .powerdown_8(pcs_pwrdn_out_sig[8]),       //OUTPUT : Powerdown Enable
        .led_col_8(led_col_8),                    //OUTPUT : Collision Indication
        .led_an_8(led_an_8),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_8(led_char_err_gx[8]),      //INPUT  : Character error
        .led_crs_8(led_crs_8),                    //OUTPUT : Carrier sense
        .led_link_8(link_status[8]),              //INPUT  : Valid link    
        .mac_rx_clk_8(mac_rx_clk_8),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_8(mac_tx_clk_8),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_8(data_rx_sop_8),            //OUTPUT : Start of Packet
        .data_rx_eop_8(data_rx_eop_8),            //OUTPUT : End of Packet
        .data_rx_data_8(data_rx_data_8),          //OUTPUT : Data from FIFO
        .data_rx_error_8(data_rx_error_8),        //OUTPUT : Receive packet error
        .data_rx_valid_8(data_rx_valid_8),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_8(data_rx_ready_8),        //OUTPUT : Data Receive Ready
        .pkt_class_data_8(pkt_class_data_8),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_8(pkt_class_valid_8),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_8(data_tx_error_8),        //INPUT  : Status
        .data_tx_data_8(data_tx_data_8),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_8(data_tx_valid_8),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_8(data_tx_sop_8),            //INPUT  : Start of Packet
        .data_tx_eop_8(data_tx_eop_8),            //INPUT  : End of Packet
        .data_tx_ready_8(data_tx_ready_8),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_8(tx_ff_uflow_8),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_8(tx_crc_fwd_8),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_8(xoff_gen_8),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_8(xon_gen_8),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_8(magic_sleep_n_8),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_8(magic_wakeup_8),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 9 
            

        .rx_carrierdetected_9(pcs_rx_carrierdetected[9]),
        .rx_rmfifodatadeleted_9(pcs_rx_rmfifodatadeleted[9]),
        .rx_rmfifodatainserted_9(pcs_rx_rmfifodatainserted[9]),

        .rx_clkout_9(pcs_clk_c9),                 //INPUT  : Receive Clock
        .tx_clkout_9(pcs_clk_c9),                 //INPUT  : Transmit Clock
        .rx_kchar_9(pcs_rx_kchar_9),              //INPUT  : Special Character Indication
        .tx_kchar_9(tx_kchar_9),                  //OUTPUT : Special Character Indication
        .rx_frame_9(pcs_rx_frame_9),              //INPUT  : Frame
        .tx_frame_9(tx_frame_9),                  //OUTPUT : Frame
        .sd_loopback_9(sd_loopback_9),            //OUTPUT : SERDES Loopback Enable
        .powerdown_9(pcs_pwrdn_out_sig[9]),       //OUTPUT : Powerdown Enable
        .led_col_9(led_col_9),                    //OUTPUT : Collision Indication
        .led_an_9(led_an_9),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_9(led_char_err_gx[9]),      //INPUT  : Character error
        .led_crs_9(led_crs_9),                    //OUTPUT : Carrier sense
        .led_link_9(link_status[9]),              //INPUT  : Valid link    
        .mac_rx_clk_9(mac_rx_clk_9),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_9(mac_tx_clk_9),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_9(data_rx_sop_9),            //OUTPUT : Start of Packet
        .data_rx_eop_9(data_rx_eop_9),            //OUTPUT : End of Packet
        .data_rx_data_9(data_rx_data_9),          //OUTPUT : Data from FIFO
        .data_rx_error_9(data_rx_error_9),        //OUTPUT : Receive packet error
        .data_rx_valid_9(data_rx_valid_9),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_9(data_rx_ready_9),        //OUTPUT : Data Receive Ready
        .pkt_class_data_9(pkt_class_data_9),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_9(pkt_class_valid_9),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_9(data_tx_error_9),        //INPUT  : Status
        .data_tx_data_9(data_tx_data_9),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_9(data_tx_valid_9),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_9(data_tx_sop_9),            //INPUT  : Start of Packet
        .data_tx_eop_9(data_tx_eop_9),            //INPUT  : End of Packet
        .data_tx_ready_9(data_tx_ready_9),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_9(tx_ff_uflow_9),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_9(tx_crc_fwd_9),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_9(xoff_gen_9),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_9(xon_gen_9),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_9(magic_sleep_n_9),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_9(magic_wakeup_9),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 10 
            

        .rx_carrierdetected_10(pcs_rx_carrierdetected[10]),
        .rx_rmfifodatadeleted_10(pcs_rx_rmfifodatadeleted[10]),
        .rx_rmfifodatainserted_10(pcs_rx_rmfifodatainserted[10]),

        .rx_clkout_10(pcs_clk_c10),                 //INPUT  : Receive Clock
        .tx_clkout_10(pcs_clk_c10),                 //INPUT  : Transmit Clock
        .rx_kchar_10(pcs_rx_kchar_10),              //INPUT  : Special Character Indication
        .tx_kchar_10(tx_kchar_10),                  //OUTPUT : Special Character Indication
        .rx_frame_10(pcs_rx_frame_10),              //INPUT  : Frame
        .tx_frame_10(tx_frame_10),                  //OUTPUT : Frame
        .sd_loopback_10(sd_loopback_10),            //OUTPUT : SERDES Loopback Enable
        .powerdown_10(pcs_pwrdn_out_sig[10]),       //OUTPUT : Powerdown Enable
        .led_col_10(led_col_10),                    //OUTPUT : Collision Indication
        .led_an_10(led_an_10),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_10(led_char_err_gx[10]),      //INPUT  : Character error
        .led_crs_10(led_crs_10),                    //OUTPUT : Carrier sense
        .led_link_10(link_status[10]),              //INPUT  : Valid link    
        .mac_rx_clk_10(mac_rx_clk_10),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_10(mac_tx_clk_10),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_10(data_rx_sop_10),            //OUTPUT : Start of Packet
        .data_rx_eop_10(data_rx_eop_10),            //OUTPUT : End of Packet
        .data_rx_data_10(data_rx_data_10),          //OUTPUT : Data from FIFO
        .data_rx_error_10(data_rx_error_10),        //OUTPUT : Receive packet error
        .data_rx_valid_10(data_rx_valid_10),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_10(data_rx_ready_10),        //OUTPUT : Data Receive Ready
        .pkt_class_data_10(pkt_class_data_10),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_10(pkt_class_valid_10),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_10(data_tx_error_10),        //INPUT  : Status
        .data_tx_data_10(data_tx_data_10),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_10(data_tx_valid_10),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_10(data_tx_sop_10),            //INPUT  : Start of Packet
        .data_tx_eop_10(data_tx_eop_10),            //INPUT  : End of Packet
        .data_tx_ready_10(data_tx_ready_10),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_10(tx_ff_uflow_10),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_10(tx_crc_fwd_10),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_10(xoff_gen_10),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_10(xon_gen_10),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_10(magic_sleep_n_10),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_10(magic_wakeup_10),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 11 
            

        .rx_carrierdetected_11(pcs_rx_carrierdetected[11]),
        .rx_rmfifodatadeleted_11(pcs_rx_rmfifodatadeleted[11]),
        .rx_rmfifodatainserted_11(pcs_rx_rmfifodatainserted[11]),

        .rx_clkout_11(pcs_clk_c11),                 //INPUT  : Receive Clock
        .tx_clkout_11(pcs_clk_c11),                 //INPUT  : Transmit Clock
        .rx_kchar_11(pcs_rx_kchar_11),              //INPUT  : Special Character Indication
        .tx_kchar_11(tx_kchar_11),                  //OUTPUT : Special Character Indication
        .rx_frame_11(pcs_rx_frame_11),              //INPUT  : Frame
        .tx_frame_11(tx_frame_11),                  //OUTPUT : Frame
        .sd_loopback_11(sd_loopback_11),            //OUTPUT : SERDES Loopback Enable
        .powerdown_11(pcs_pwrdn_out_sig[11]),       //OUTPUT : Powerdown Enable
        .led_col_11(led_col_11),                    //OUTPUT : Collision Indication
        .led_an_11(led_an_11),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_11(led_char_err_gx[11]),      //INPUT  : Character error
        .led_crs_11(led_crs_11),                    //OUTPUT : Carrier sense
        .led_link_11(link_status[11]),              //INPUT  : Valid link    
        .mac_rx_clk_11(mac_rx_clk_11),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_11(mac_tx_clk_11),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_11(data_rx_sop_11),            //OUTPUT : Start of Packet
        .data_rx_eop_11(data_rx_eop_11),            //OUTPUT : End of Packet
        .data_rx_data_11(data_rx_data_11),          //OUTPUT : Data from FIFO
        .data_rx_error_11(data_rx_error_11),        //OUTPUT : Receive packet error
        .data_rx_valid_11(data_rx_valid_11),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_11(data_rx_ready_11),        //OUTPUT : Data Receive Ready
        .pkt_class_data_11(pkt_class_data_11),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_11(pkt_class_valid_11),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_11(data_tx_error_11),        //INPUT  : Status
        .data_tx_data_11(data_tx_data_11),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_11(data_tx_valid_11),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_11(data_tx_sop_11),            //INPUT  : Start of Packet
        .data_tx_eop_11(data_tx_eop_11),            //INPUT  : End of Packet
        .data_tx_ready_11(data_tx_ready_11),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_11(tx_ff_uflow_11),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_11(tx_crc_fwd_11),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_11(xoff_gen_11),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_11(xon_gen_11),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_11(magic_sleep_n_11),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_11(magic_wakeup_11),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 12 
            

        .rx_carrierdetected_12(pcs_rx_carrierdetected[12]),
        .rx_rmfifodatadeleted_12(pcs_rx_rmfifodatadeleted[12]),
        .rx_rmfifodatainserted_12(pcs_rx_rmfifodatainserted[12]),

        .rx_clkout_12(pcs_clk_c12),                 //INPUT  : Receive Clock
        .tx_clkout_12(pcs_clk_c12),                 //INPUT  : Transmit Clock
        .rx_kchar_12(pcs_rx_kchar_12),              //INPUT  : Special Character Indication
        .tx_kchar_12(tx_kchar_12),                  //OUTPUT : Special Character Indication
        .rx_frame_12(pcs_rx_frame_12),              //INPUT  : Frame
        .tx_frame_12(tx_frame_12),                  //OUTPUT : Frame
        .sd_loopback_12(sd_loopback_12),            //OUTPUT : SERDES Loopback Enable
        .powerdown_12(pcs_pwrdn_out_sig[12]),       //OUTPUT : Powerdown Enable
        .led_col_12(led_col_12),                    //OUTPUT : Collision Indication
        .led_an_12(led_an_12),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_12(led_char_err_gx[12]),      //INPUT  : Character error
        .led_crs_12(led_crs_12),                    //OUTPUT : Carrier sense
        .led_link_12(link_status[12]),              //INPUT  : Valid link    
        .mac_rx_clk_12(mac_rx_clk_12),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_12(mac_tx_clk_12),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_12(data_rx_sop_12),            //OUTPUT : Start of Packet
        .data_rx_eop_12(data_rx_eop_12),            //OUTPUT : End of Packet
        .data_rx_data_12(data_rx_data_12),          //OUTPUT : Data from FIFO
        .data_rx_error_12(data_rx_error_12),        //OUTPUT : Receive packet error
        .data_rx_valid_12(data_rx_valid_12),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_12(data_rx_ready_12),        //OUTPUT : Data Receive Ready
        .pkt_class_data_12(pkt_class_data_12),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_12(pkt_class_valid_12),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_12(data_tx_error_12),        //INPUT  : Status
        .data_tx_data_12(data_tx_data_12),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_12(data_tx_valid_12),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_12(data_tx_sop_12),            //INPUT  : Start of Packet
        .data_tx_eop_12(data_tx_eop_12),            //INPUT  : End of Packet
        .data_tx_ready_12(data_tx_ready_12),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_12(tx_ff_uflow_12),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_12(tx_crc_fwd_12),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_12(xoff_gen_12),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_12(xon_gen_12),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_12(magic_sleep_n_12),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_12(magic_wakeup_12),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 13 
            

        .rx_carrierdetected_13(pcs_rx_carrierdetected[13]),
        .rx_rmfifodatadeleted_13(pcs_rx_rmfifodatadeleted[13]),
        .rx_rmfifodatainserted_13(pcs_rx_rmfifodatainserted[13]),

        .rx_clkout_13(pcs_clk_c13),                 //INPUT  : Receive Clock
        .tx_clkout_13(pcs_clk_c13),                 //INPUT  : Transmit Clock
        .rx_kchar_13(pcs_rx_kchar_13),              //INPUT  : Special Character Indication
        .tx_kchar_13(tx_kchar_13),                  //OUTPUT : Special Character Indication
        .rx_frame_13(pcs_rx_frame_13),              //INPUT  : Frame
        .tx_frame_13(tx_frame_13),                  //OUTPUT : Frame
        .sd_loopback_13(sd_loopback_13),            //OUTPUT : SERDES Loopback Enable
        .powerdown_13(pcs_pwrdn_out_sig[13]),       //OUTPUT : Powerdown Enable
        .led_col_13(led_col_13),                    //OUTPUT : Collision Indication
        .led_an_13(led_an_13),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_13(led_char_err_gx[13]),      //INPUT  : Character error
        .led_crs_13(led_crs_13),                    //OUTPUT : Carrier sense
        .led_link_13(link_status[13]),              //INPUT  : Valid link    
        .mac_rx_clk_13(mac_rx_clk_13),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_13(mac_tx_clk_13),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_13(data_rx_sop_13),            //OUTPUT : Start of Packet
        .data_rx_eop_13(data_rx_eop_13),            //OUTPUT : End of Packet
        .data_rx_data_13(data_rx_data_13),          //OUTPUT : Data from FIFO
        .data_rx_error_13(data_rx_error_13),        //OUTPUT : Receive packet error
        .data_rx_valid_13(data_rx_valid_13),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_13(data_rx_ready_13),        //OUTPUT : Data Receive Ready
        .pkt_class_data_13(pkt_class_data_13),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_13(pkt_class_valid_13),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_13(data_tx_error_13),        //INPUT  : Status
        .data_tx_data_13(data_tx_data_13),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_13(data_tx_valid_13),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_13(data_tx_sop_13),            //INPUT  : Start of Packet
        .data_tx_eop_13(data_tx_eop_13),            //INPUT  : End of Packet
        .data_tx_ready_13(data_tx_ready_13),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_13(tx_ff_uflow_13),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_13(tx_crc_fwd_13),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_13(xoff_gen_13),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_13(xon_gen_13),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_13(magic_sleep_n_13),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_13(magic_wakeup_13),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 14 
            

        .rx_carrierdetected_14(pcs_rx_carrierdetected[14]),
        .rx_rmfifodatadeleted_14(pcs_rx_rmfifodatadeleted[14]),
        .rx_rmfifodatainserted_14(pcs_rx_rmfifodatainserted[14]),

        .rx_clkout_14(pcs_clk_c14),                 //INPUT  : Receive Clock
        .tx_clkout_14(pcs_clk_c14),                 //INPUT  : Transmit Clock
        .rx_kchar_14(pcs_rx_kchar_14),              //INPUT  : Special Character Indication
        .tx_kchar_14(tx_kchar_14),                  //OUTPUT : Special Character Indication
        .rx_frame_14(pcs_rx_frame_14),              //INPUT  : Frame
        .tx_frame_14(tx_frame_14),                  //OUTPUT : Frame
        .sd_loopback_14(sd_loopback_14),            //OUTPUT : SERDES Loopback Enable
        .powerdown_14(pcs_pwrdn_out_sig[14]),       //OUTPUT : Powerdown Enable
        .led_col_14(led_col_14),                    //OUTPUT : Collision Indication
        .led_an_14(led_an_14),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_14(led_char_err_gx[14]),      //INPUT  : Character error
        .led_crs_14(led_crs_14),                    //OUTPUT : Carrier sense
        .led_link_14(link_status[14]),              //INPUT  : Valid link    
        .mac_rx_clk_14(mac_rx_clk_14),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_14(mac_tx_clk_14),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_14(data_rx_sop_14),            //OUTPUT : Start of Packet
        .data_rx_eop_14(data_rx_eop_14),            //OUTPUT : End of Packet
        .data_rx_data_14(data_rx_data_14),          //OUTPUT : Data from FIFO
        .data_rx_error_14(data_rx_error_14),        //OUTPUT : Receive packet error
        .data_rx_valid_14(data_rx_valid_14),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_14(data_rx_ready_14),        //OUTPUT : Data Receive Ready
        .pkt_class_data_14(pkt_class_data_14),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_14(pkt_class_valid_14),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_14(data_tx_error_14),        //INPUT  : Status
        .data_tx_data_14(data_tx_data_14),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_14(data_tx_valid_14),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_14(data_tx_sop_14),            //INPUT  : Start of Packet
        .data_tx_eop_14(data_tx_eop_14),            //INPUT  : End of Packet
        .data_tx_ready_14(data_tx_ready_14),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_14(tx_ff_uflow_14),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_14(tx_crc_fwd_14),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_14(xoff_gen_14),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_14(xon_gen_14),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_14(magic_sleep_n_14),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_14(magic_wakeup_14),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 15 
            

        .rx_carrierdetected_15(pcs_rx_carrierdetected[15]),
        .rx_rmfifodatadeleted_15(pcs_rx_rmfifodatadeleted[15]),
        .rx_rmfifodatainserted_15(pcs_rx_rmfifodatainserted[15]),

        .rx_clkout_15(pcs_clk_c15),                 //INPUT  : Receive Clock
        .tx_clkout_15(pcs_clk_c15),                 //INPUT  : Transmit Clock
        .rx_kchar_15(pcs_rx_kchar_15),              //INPUT  : Special Character Indication
        .tx_kchar_15(tx_kchar_15),                  //OUTPUT : Special Character Indication
        .rx_frame_15(pcs_rx_frame_15),              //INPUT  : Frame
        .tx_frame_15(tx_frame_15),                  //OUTPUT : Frame
        .sd_loopback_15(sd_loopback_15),            //OUTPUT : SERDES Loopback Enable
        .powerdown_15(pcs_pwrdn_out_sig[15]),       //OUTPUT : Powerdown Enable
        .led_col_15(led_col_15),                    //OUTPUT : Collision Indication
        .led_an_15(led_an_15),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_15(led_char_err_gx[15]),      //INPUT  : Character error
        .led_crs_15(led_crs_15),                    //OUTPUT : Carrier sense
        .led_link_15(link_status[15]),              //INPUT  : Valid link    
        .mac_rx_clk_15(mac_rx_clk_15),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_15(mac_tx_clk_15),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_15(data_rx_sop_15),            //OUTPUT : Start of Packet
        .data_rx_eop_15(data_rx_eop_15),            //OUTPUT : End of Packet
        .data_rx_data_15(data_rx_data_15),          //OUTPUT : Data from FIFO
        .data_rx_error_15(data_rx_error_15),        //OUTPUT : Receive packet error
        .data_rx_valid_15(data_rx_valid_15),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_15(data_rx_ready_15),        //OUTPUT : Data Receive Ready
        .pkt_class_data_15(pkt_class_data_15),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_15(pkt_class_valid_15),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_15(data_tx_error_15),        //INPUT  : Status
        .data_tx_data_15(data_tx_data_15),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_15(data_tx_valid_15),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_15(data_tx_sop_15),            //INPUT  : Start of Packet
        .data_tx_eop_15(data_tx_eop_15),            //INPUT  : End of Packet
        .data_tx_ready_15(data_tx_ready_15),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_15(tx_ff_uflow_15),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_15(tx_crc_fwd_15),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_15(xoff_gen_15),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_15(xon_gen_15),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_15(magic_sleep_n_15),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_15(magic_wakeup_15),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 16 
            

        .rx_carrierdetected_16(pcs_rx_carrierdetected[16]),
        .rx_rmfifodatadeleted_16(pcs_rx_rmfifodatadeleted[16]),
        .rx_rmfifodatainserted_16(pcs_rx_rmfifodatainserted[16]),

        .rx_clkout_16(pcs_clk_c16),                 //INPUT  : Receive Clock
        .tx_clkout_16(pcs_clk_c16),                 //INPUT  : Transmit Clock
        .rx_kchar_16(pcs_rx_kchar_16),              //INPUT  : Special Character Indication
        .tx_kchar_16(tx_kchar_16),                  //OUTPUT : Special Character Indication
        .rx_frame_16(pcs_rx_frame_16),              //INPUT  : Frame
        .tx_frame_16(tx_frame_16),                  //OUTPUT : Frame
        .sd_loopback_16(sd_loopback_16),            //OUTPUT : SERDES Loopback Enable
        .powerdown_16(pcs_pwrdn_out_sig[16]),       //OUTPUT : Powerdown Enable
        .led_col_16(led_col_16),                    //OUTPUT : Collision Indication
        .led_an_16(led_an_16),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_16(led_char_err_gx[16]),      //INPUT  : Character error
        .led_crs_16(led_crs_16),                    //OUTPUT : Carrier sense
        .led_link_16(link_status[16]),              //INPUT  : Valid link    
        .mac_rx_clk_16(mac_rx_clk_16),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_16(mac_tx_clk_16),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_16(data_rx_sop_16),            //OUTPUT : Start of Packet
        .data_rx_eop_16(data_rx_eop_16),            //OUTPUT : End of Packet
        .data_rx_data_16(data_rx_data_16),          //OUTPUT : Data from FIFO
        .data_rx_error_16(data_rx_error_16),        //OUTPUT : Receive packet error
        .data_rx_valid_16(data_rx_valid_16),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_16(data_rx_ready_16),        //OUTPUT : Data Receive Ready
        .pkt_class_data_16(pkt_class_data_16),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_16(pkt_class_valid_16),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_16(data_tx_error_16),        //INPUT  : Status
        .data_tx_data_16(data_tx_data_16),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_16(data_tx_valid_16),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_16(data_tx_sop_16),            //INPUT  : Start of Packet
        .data_tx_eop_16(data_tx_eop_16),            //INPUT  : End of Packet
        .data_tx_ready_16(data_tx_ready_16),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_16(tx_ff_uflow_16),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_16(tx_crc_fwd_16),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_16(xoff_gen_16),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_16(xon_gen_16),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_16(magic_sleep_n_16),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_16(magic_wakeup_16),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 17 
            

        .rx_carrierdetected_17(pcs_rx_carrierdetected[17]),
        .rx_rmfifodatadeleted_17(pcs_rx_rmfifodatadeleted[17]),
        .rx_rmfifodatainserted_17(pcs_rx_rmfifodatainserted[17]),

        .rx_clkout_17(pcs_clk_c17),                 //INPUT  : Receive Clock
        .tx_clkout_17(pcs_clk_c17),                 //INPUT  : Transmit Clock
        .rx_kchar_17(pcs_rx_kchar_17),              //INPUT  : Special Character Indication
        .tx_kchar_17(tx_kchar_17),                  //OUTPUT : Special Character Indication
        .rx_frame_17(pcs_rx_frame_17),              //INPUT  : Frame
        .tx_frame_17(tx_frame_17),                  //OUTPUT : Frame
        .sd_loopback_17(sd_loopback_17),            //OUTPUT : SERDES Loopback Enable
        .powerdown_17(pcs_pwrdn_out_sig[17]),       //OUTPUT : Powerdown Enable
        .led_col_17(led_col_17),                    //OUTPUT : Collision Indication
        .led_an_17(led_an_17),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_17(led_char_err_gx[17]),      //INPUT  : Character error
        .led_crs_17(led_crs_17),                    //OUTPUT : Carrier sense
        .led_link_17(link_status[17]),              //INPUT  : Valid link    
        .mac_rx_clk_17(mac_rx_clk_17),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_17(mac_tx_clk_17),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_17(data_rx_sop_17),            //OUTPUT : Start of Packet
        .data_rx_eop_17(data_rx_eop_17),            //OUTPUT : End of Packet
        .data_rx_data_17(data_rx_data_17),          //OUTPUT : Data from FIFO
        .data_rx_error_17(data_rx_error_17),        //OUTPUT : Receive packet error
        .data_rx_valid_17(data_rx_valid_17),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_17(data_rx_ready_17),        //OUTPUT : Data Receive Ready
        .pkt_class_data_17(pkt_class_data_17),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_17(pkt_class_valid_17),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_17(data_tx_error_17),        //INPUT  : Status
        .data_tx_data_17(data_tx_data_17),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_17(data_tx_valid_17),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_17(data_tx_sop_17),            //INPUT  : Start of Packet
        .data_tx_eop_17(data_tx_eop_17),            //INPUT  : End of Packet
        .data_tx_ready_17(data_tx_ready_17),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_17(tx_ff_uflow_17),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_17(tx_crc_fwd_17),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_17(xoff_gen_17),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_17(xon_gen_17),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_17(magic_sleep_n_17),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_17(magic_wakeup_17),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 18 
            

        .rx_carrierdetected_18(pcs_rx_carrierdetected[18]),
        .rx_rmfifodatadeleted_18(pcs_rx_rmfifodatadeleted[18]),
        .rx_rmfifodatainserted_18(pcs_rx_rmfifodatainserted[18]),

        .rx_clkout_18(pcs_clk_c18),                 //INPUT  : Receive Clock
        .tx_clkout_18(pcs_clk_c18),                 //INPUT  : Transmit Clock
        .rx_kchar_18(pcs_rx_kchar_18),              //INPUT  : Special Character Indication
        .tx_kchar_18(tx_kchar_18),                  //OUTPUT : Special Character Indication
        .rx_frame_18(pcs_rx_frame_18),              //INPUT  : Frame
        .tx_frame_18(tx_frame_18),                  //OUTPUT : Frame
        .sd_loopback_18(sd_loopback_18),            //OUTPUT : SERDES Loopback Enable
        .powerdown_18(pcs_pwrdn_out_sig[18]),       //OUTPUT : Powerdown Enable
        .led_col_18(led_col_18),                    //OUTPUT : Collision Indication
        .led_an_18(led_an_18),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_18(led_char_err_gx[18]),      //INPUT  : Character error
        .led_crs_18(led_crs_18),                    //OUTPUT : Carrier sense
        .led_link_18(link_status[18]),              //INPUT  : Valid link    
        .mac_rx_clk_18(mac_rx_clk_18),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_18(mac_tx_clk_18),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_18(data_rx_sop_18),            //OUTPUT : Start of Packet
        .data_rx_eop_18(data_rx_eop_18),            //OUTPUT : End of Packet
        .data_rx_data_18(data_rx_data_18),          //OUTPUT : Data from FIFO
        .data_rx_error_18(data_rx_error_18),        //OUTPUT : Receive packet error
        .data_rx_valid_18(data_rx_valid_18),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_18(data_rx_ready_18),        //OUTPUT : Data Receive Ready
        .pkt_class_data_18(pkt_class_data_18),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_18(pkt_class_valid_18),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_18(data_tx_error_18),        //INPUT  : Status
        .data_tx_data_18(data_tx_data_18),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_18(data_tx_valid_18),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_18(data_tx_sop_18),            //INPUT  : Start of Packet
        .data_tx_eop_18(data_tx_eop_18),            //INPUT  : End of Packet
        .data_tx_ready_18(data_tx_ready_18),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_18(tx_ff_uflow_18),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_18(tx_crc_fwd_18),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_18(xoff_gen_18),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_18(xon_gen_18),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_18(magic_sleep_n_18),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_18(magic_wakeup_18),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 19 
            

        .rx_carrierdetected_19(pcs_rx_carrierdetected[19]),
        .rx_rmfifodatadeleted_19(pcs_rx_rmfifodatadeleted[19]),
        .rx_rmfifodatainserted_19(pcs_rx_rmfifodatainserted[19]),

        .rx_clkout_19(pcs_clk_c19),                 //INPUT  : Receive Clock
        .tx_clkout_19(pcs_clk_c19),                 //INPUT  : Transmit Clock
        .rx_kchar_19(pcs_rx_kchar_19),              //INPUT  : Special Character Indication
        .tx_kchar_19(tx_kchar_19),                  //OUTPUT : Special Character Indication
        .rx_frame_19(pcs_rx_frame_19),              //INPUT  : Frame
        .tx_frame_19(tx_frame_19),                  //OUTPUT : Frame
        .sd_loopback_19(sd_loopback_19),            //OUTPUT : SERDES Loopback Enable
        .powerdown_19(pcs_pwrdn_out_sig[19]),       //OUTPUT : Powerdown Enable
        .led_col_19(led_col_19),                    //OUTPUT : Collision Indication
        .led_an_19(led_an_19),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_19(led_char_err_gx[19]),      //INPUT  : Character error
        .led_crs_19(led_crs_19),                    //OUTPUT : Carrier sense
        .led_link_19(link_status[19]),              //INPUT  : Valid link    
        .mac_rx_clk_19(mac_rx_clk_19),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_19(mac_tx_clk_19),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_19(data_rx_sop_19),            //OUTPUT : Start of Packet
        .data_rx_eop_19(data_rx_eop_19),            //OUTPUT : End of Packet
        .data_rx_data_19(data_rx_data_19),          //OUTPUT : Data from FIFO
        .data_rx_error_19(data_rx_error_19),        //OUTPUT : Receive packet error
        .data_rx_valid_19(data_rx_valid_19),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_19(data_rx_ready_19),        //OUTPUT : Data Receive Ready
        .pkt_class_data_19(pkt_class_data_19),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_19(pkt_class_valid_19),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_19(data_tx_error_19),        //INPUT  : Status
        .data_tx_data_19(data_tx_data_19),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_19(data_tx_valid_19),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_19(data_tx_sop_19),            //INPUT  : Start of Packet
        .data_tx_eop_19(data_tx_eop_19),            //INPUT  : End of Packet
        .data_tx_ready_19(data_tx_ready_19),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_19(tx_ff_uflow_19),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_19(tx_crc_fwd_19),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_19(xoff_gen_19),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_19(xon_gen_19),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_19(magic_sleep_n_19),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_19(magic_wakeup_19),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 20 
            

        .rx_carrierdetected_20(pcs_rx_carrierdetected[20]),
        .rx_rmfifodatadeleted_20(pcs_rx_rmfifodatadeleted[20]),
        .rx_rmfifodatainserted_20(pcs_rx_rmfifodatainserted[20]),

        .rx_clkout_20(pcs_clk_c20),                 //INPUT  : Receive Clock
        .tx_clkout_20(pcs_clk_c20),                 //INPUT  : Transmit Clock
        .rx_kchar_20(pcs_rx_kchar_20),              //INPUT  : Special Character Indication
        .tx_kchar_20(tx_kchar_20),                  //OUTPUT : Special Character Indication
        .rx_frame_20(pcs_rx_frame_20),              //INPUT  : Frame
        .tx_frame_20(tx_frame_20),                  //OUTPUT : Frame
        .sd_loopback_20(sd_loopback_20),            //OUTPUT : SERDES Loopback Enable
        .powerdown_20(pcs_pwrdn_out_sig[20]),       //OUTPUT : Powerdown Enable
        .led_col_20(led_col_20),                    //OUTPUT : Collision Indication
        .led_an_20(led_an_20),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_20(led_char_err_gx[20]),      //INPUT  : Character error
        .led_crs_20(led_crs_20),                    //OUTPUT : Carrier sense
        .led_link_20(link_status[20]),              //INPUT  : Valid link    
        .mac_rx_clk_20(mac_rx_clk_20),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_20(mac_tx_clk_20),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_20(data_rx_sop_20),            //OUTPUT : Start of Packet
        .data_rx_eop_20(data_rx_eop_20),            //OUTPUT : End of Packet
        .data_rx_data_20(data_rx_data_20),          //OUTPUT : Data from FIFO
        .data_rx_error_20(data_rx_error_20),        //OUTPUT : Receive packet error
        .data_rx_valid_20(data_rx_valid_20),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_20(data_rx_ready_20),        //OUTPUT : Data Receive Ready
        .pkt_class_data_20(pkt_class_data_20),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_20(pkt_class_valid_20),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_20(data_tx_error_20),        //INPUT  : Status
        .data_tx_data_20(data_tx_data_20),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_20(data_tx_valid_20),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_20(data_tx_sop_20),            //INPUT  : Start of Packet
        .data_tx_eop_20(data_tx_eop_20),            //INPUT  : End of Packet
        .data_tx_ready_20(data_tx_ready_20),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_20(tx_ff_uflow_20),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_20(tx_crc_fwd_20),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_20(xoff_gen_20),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_20(xon_gen_20),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_20(magic_sleep_n_20),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_20(magic_wakeup_20),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 21 
            

        .rx_carrierdetected_21(pcs_rx_carrierdetected[21]),
        .rx_rmfifodatadeleted_21(pcs_rx_rmfifodatadeleted[21]),
        .rx_rmfifodatainserted_21(pcs_rx_rmfifodatainserted[21]),

        .rx_clkout_21(pcs_clk_c21),                 //INPUT  : Receive Clock
        .tx_clkout_21(pcs_clk_c21),                 //INPUT  : Transmit Clock
        .rx_kchar_21(pcs_rx_kchar_21),              //INPUT  : Special Character Indication
        .tx_kchar_21(tx_kchar_21),                  //OUTPUT : Special Character Indication
        .rx_frame_21(pcs_rx_frame_21),              //INPUT  : Frame
        .tx_frame_21(tx_frame_21),                  //OUTPUT : Frame
        .sd_loopback_21(sd_loopback_21),            //OUTPUT : SERDES Loopback Enable
        .powerdown_21(pcs_pwrdn_out_sig[21]),       //OUTPUT : Powerdown Enable
        .led_col_21(led_col_21),                    //OUTPUT : Collision Indication
        .led_an_21(led_an_21),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_21(led_char_err_gx[21]),      //INPUT  : Character error
        .led_crs_21(led_crs_21),                    //OUTPUT : Carrier sense
        .led_link_21(link_status[21]),              //INPUT  : Valid link    
        .mac_rx_clk_21(mac_rx_clk_21),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_21(mac_tx_clk_21),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_21(data_rx_sop_21),            //OUTPUT : Start of Packet
        .data_rx_eop_21(data_rx_eop_21),            //OUTPUT : End of Packet
        .data_rx_data_21(data_rx_data_21),          //OUTPUT : Data from FIFO
        .data_rx_error_21(data_rx_error_21),        //OUTPUT : Receive packet error
        .data_rx_valid_21(data_rx_valid_21),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_21(data_rx_ready_21),        //OUTPUT : Data Receive Ready
        .pkt_class_data_21(pkt_class_data_21),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_21(pkt_class_valid_21),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_21(data_tx_error_21),        //INPUT  : Status
        .data_tx_data_21(data_tx_data_21),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_21(data_tx_valid_21),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_21(data_tx_sop_21),            //INPUT  : Start of Packet
        .data_tx_eop_21(data_tx_eop_21),            //INPUT  : End of Packet
        .data_tx_ready_21(data_tx_ready_21),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_21(tx_ff_uflow_21),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_21(tx_crc_fwd_21),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_21(xoff_gen_21),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_21(xon_gen_21),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_21(magic_sleep_n_21),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_21(magic_wakeup_21),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 22 
            

        .rx_carrierdetected_22(pcs_rx_carrierdetected[22]),
        .rx_rmfifodatadeleted_22(pcs_rx_rmfifodatadeleted[22]),
        .rx_rmfifodatainserted_22(pcs_rx_rmfifodatainserted[22]),

        .rx_clkout_22(pcs_clk_c22),                 //INPUT  : Receive Clock
        .tx_clkout_22(pcs_clk_c22),                 //INPUT  : Transmit Clock
        .rx_kchar_22(pcs_rx_kchar_22),              //INPUT  : Special Character Indication
        .tx_kchar_22(tx_kchar_22),                  //OUTPUT : Special Character Indication
        .rx_frame_22(pcs_rx_frame_22),              //INPUT  : Frame
        .tx_frame_22(tx_frame_22),                  //OUTPUT : Frame
        .sd_loopback_22(sd_loopback_22),            //OUTPUT : SERDES Loopback Enable
        .powerdown_22(pcs_pwrdn_out_sig[22]),       //OUTPUT : Powerdown Enable
        .led_col_22(led_col_22),                    //OUTPUT : Collision Indication
        .led_an_22(led_an_22),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_22(led_char_err_gx[22]),      //INPUT  : Character error
        .led_crs_22(led_crs_22),                    //OUTPUT : Carrier sense
        .led_link_22(link_status[22]),              //INPUT  : Valid link    
        .mac_rx_clk_22(mac_rx_clk_22),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_22(mac_tx_clk_22),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_22(data_rx_sop_22),            //OUTPUT : Start of Packet
        .data_rx_eop_22(data_rx_eop_22),            //OUTPUT : End of Packet
        .data_rx_data_22(data_rx_data_22),          //OUTPUT : Data from FIFO
        .data_rx_error_22(data_rx_error_22),        //OUTPUT : Receive packet error
        .data_rx_valid_22(data_rx_valid_22),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_22(data_rx_ready_22),        //OUTPUT : Data Receive Ready
        .pkt_class_data_22(pkt_class_data_22),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_22(pkt_class_valid_22),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_22(data_tx_error_22),        //INPUT  : Status
        .data_tx_data_22(data_tx_data_22),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_22(data_tx_valid_22),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_22(data_tx_sop_22),            //INPUT  : Start of Packet
        .data_tx_eop_22(data_tx_eop_22),            //INPUT  : End of Packet
        .data_tx_ready_22(data_tx_ready_22),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_22(tx_ff_uflow_22),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_22(tx_crc_fwd_22),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_22(xoff_gen_22),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_22(xon_gen_22),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_22(magic_sleep_n_22),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_22(magic_wakeup_22),          //OUTPUT : MAC WAKE-UP INDICATION

         // Channel 23 
            

        .rx_carrierdetected_23(pcs_rx_carrierdetected[23]),
        .rx_rmfifodatadeleted_23(pcs_rx_rmfifodatadeleted[23]),
        .rx_rmfifodatainserted_23(pcs_rx_rmfifodatainserted[23]),

        .rx_clkout_23(pcs_clk_c23),                 //INPUT  : Receive Clock
        .tx_clkout_23(pcs_clk_c23),                 //INPUT  : Transmit Clock
        .rx_kchar_23(pcs_rx_kchar_23),              //INPUT  : Special Character Indication
        .tx_kchar_23(tx_kchar_23),                  //OUTPUT : Special Character Indication
        .rx_frame_23(pcs_rx_frame_23),              //INPUT  : Frame
        .tx_frame_23(tx_frame_23),                  //OUTPUT : Frame
        .sd_loopback_23(sd_loopback_23),            //OUTPUT : SERDES Loopback Enable
        .powerdown_23(pcs_pwrdn_out_sig[23]),       //OUTPUT : Powerdown Enable
        .led_col_23(led_col_23),                    //OUTPUT : Collision Indication
        .led_an_23(led_an_23),                      //OUTPUT : Auto Negotiation Status
        .led_char_err_23(led_char_err_gx[23]),      //INPUT  : Character error
        .led_crs_23(led_crs_23),                    //OUTPUT : Carrier sense
        .led_link_23(link_status[23]),              //INPUT  : Valid link    
        .mac_rx_clk_23(mac_rx_clk_23),              //OUTPUT : Av-ST Rx Clock
        .mac_tx_clk_23(mac_tx_clk_23),              //OUTPUT : Av-ST Tx Clock
        .data_rx_sop_23(data_rx_sop_23),            //OUTPUT : Start of Packet
        .data_rx_eop_23(data_rx_eop_23),            //OUTPUT : End of Packet
        .data_rx_data_23(data_rx_data_23),          //OUTPUT : Data from FIFO
        .data_rx_error_23(data_rx_error_23),        //OUTPUT : Receive packet error
        .data_rx_valid_23(data_rx_valid_23),        //OUTPUT : Data Receive FIFO Valid
        .data_rx_ready_23(data_rx_ready_23),        //OUTPUT : Data Receive Ready
        .pkt_class_data_23(pkt_class_data_23),      //OUTPUT : Frame Type Indication
        .pkt_class_valid_23(pkt_class_valid_23),    //OUTPUT : Frame Type Indication Valid
        .data_tx_error_23(data_tx_error_23),        //INPUT  : Status
        .data_tx_data_23(data_tx_data_23),          //INPUT  : Data from FIFO transmit
        .data_tx_valid_23(data_tx_valid_23),        //INPUT  : Data FIFO transmit Empty
        .data_tx_sop_23(data_tx_sop_23),            //INPUT  : Start of Packet
        .data_tx_eop_23(data_tx_eop_23),            //INPUT  : End of Packet
        .data_tx_ready_23(data_tx_ready_23),        //OUTPUT : Data FIFO transmit Read Enable  
        .tx_ff_uflow_23(tx_ff_uflow_23),            //OUTPUT : TX FIFO underflow occured (Synchronous with tx_clk)
        .tx_crc_fwd_23(tx_crc_fwd_23),              //INPUT  : Forward Current Frame with CRC from Application
        .xoff_gen_23(xoff_gen_23),                  //INPUT  : XOFF PAUSE FRAME GENERATE
        .xon_gen_23(xon_gen_23),                    //INPUT  : XON PAUSE FRAME GENERATE
        .magic_sleep_n_23(magic_sleep_n_23),        //INPUT  : MAC SLEEP MODE CONTROL
        .magic_wakeup_23(magic_wakeup_23));         //OUTPUT : MAC WAKE-UP INDICATION

    defparam
        U_MULTI_MAC_PCS.USE_SYNC_RESET = USE_SYNC_RESET, 
        U_MULTI_MAC_PCS.RESET_LEVEL = RESET_LEVEL,
        U_MULTI_MAC_PCS.ENABLE_GMII_LOOPBACK = ENABLE_GMII_LOOPBACK, 
        U_MULTI_MAC_PCS.ENABLE_HD_LOGIC = ENABLE_HD_LOGIC,
        U_MULTI_MAC_PCS.ENABLE_SUP_ADDR = ENABLE_SUP_ADDR,
        U_MULTI_MAC_PCS.ENA_HASH = ENA_HASH,
        U_MULTI_MAC_PCS.STAT_CNT_ENA = STAT_CNT_ENA,
        U_MULTI_MAC_PCS.CORE_VERSION = CORE_VERSION, 
        U_MULTI_MAC_PCS.CUST_VERSION = CUST_VERSION,
        U_MULTI_MAC_PCS.REDUCED_INTERFACE_ENA = REDUCED_INTERFACE_ENA,
        U_MULTI_MAC_PCS.ENABLE_MDIO = ENABLE_MDIO,
        U_MULTI_MAC_PCS.MDIO_CLK_DIV = MDIO_CLK_DIV,
        U_MULTI_MAC_PCS.ENABLE_MAGIC_DETECT = ENABLE_MAGIC_DETECT,
        U_MULTI_MAC_PCS.ENABLE_PADDING = ENABLE_PADDING,
        U_MULTI_MAC_PCS.ENABLE_LGTH_CHECK = ENABLE_LGTH_CHECK,
        U_MULTI_MAC_PCS.GBIT_ONLY = GBIT_ONLY,
        U_MULTI_MAC_PCS.MBIT_ONLY = MBIT_ONLY,
        U_MULTI_MAC_PCS.REDUCED_CONTROL = REDUCED_CONTROL,
        U_MULTI_MAC_PCS.CRC32DWIDTH = CRC32DWIDTH,
        U_MULTI_MAC_PCS.CRC32GENDELAY = CRC32GENDELAY, 
        U_MULTI_MAC_PCS.CRC32CHECK16BIT = CRC32CHECK16BIT, 
        U_MULTI_MAC_PCS.CRC32S1L2_EXTERN = CRC32S1L2_EXTERN,
        U_MULTI_MAC_PCS.ENABLE_SHIFT16 = ENABLE_SHIFT16,   
        U_MULTI_MAC_PCS.ENABLE_MAC_FLOW_CTRL = ENABLE_MAC_FLOW_CTRL,
        U_MULTI_MAC_PCS.ENABLE_MAC_TXADDR_SET = ENABLE_MAC_TXADDR_SET,
        U_MULTI_MAC_PCS.ENABLE_MAC_RX_VLAN = ENABLE_MAC_RX_VLAN,
        U_MULTI_MAC_PCS.ENABLE_MAC_TX_VLAN = ENABLE_MAC_TX_VLAN,
        U_MULTI_MAC_PCS.PHY_IDENTIFIER = PHY_IDENTIFIER,
        U_MULTI_MAC_PCS.DEV_VERSION = DEV_VERSION,
        U_MULTI_MAC_PCS.ENABLE_SGMII = ENABLE_SGMII,
        U_MULTI_MAC_PCS.MAX_CHANNELS = MAX_CHANNELS,
        U_MULTI_MAC_PCS.CHANNEL_WIDTH = CHANNEL_WIDTH,
        U_MULTI_MAC_PCS.ENABLE_RX_FIFO_STATUS = ENABLE_RX_FIFO_STATUS,
        U_MULTI_MAC_PCS.ENABLE_EXTENDED_STAT_REG = ENABLE_EXTENDED_STAT_REG,
        U_MULTI_MAC_PCS.ENABLE_CLK_SHARING = ENABLE_CLK_SHARING,    
        U_MULTI_MAC_PCS.ENABLE_REG_SHARING = ENABLE_REG_SHARING;    



// #######################################################################
// ###############       CHANNEL 0 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 0)
    begin          
        assign gxb_pwrdn_in_sig[0] = gxb_pwrdn_in_0;
        assign pcs_pwrdn_out_0 = pcs_pwrdn_out_sig[0];
    end
else
    begin
        assign gxb_pwrdn_in_sig[0] = pcs_pwrdn_out_sig[0];
    end      
endgenerate


generate if (MAX_CHANNELS > 0)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_0
          (
            .clk(pcs_clk_c0),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_0),
            .alt_sync(rx_syncstatus[0]),
            .alt_disperr(rx_disp_err[0]),
            .alt_ctrldetect(rx_kchar_0),
            .alt_errdetect(rx_char_err_gx[0]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[0]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[0]),
            .alt_runlengthviolation(rx_runlengthviolation[0]),
            .alt_patterndetect(rx_patterndetect[0]),
            .alt_runningdisp(rx_runningdisp[0]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_0),
            .altpcs_sync(link_status[0]),
            .altpcs_disperr(led_disp_err_0),
            .altpcs_ctrldetect(pcs_rx_kchar_0),
            .altpcs_errdetect(led_char_err_gx[0]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[0]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[0]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[0])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_0.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_0
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[0]),            
            .pll_inclk (ref_clk),
       	    .reconfig_clk(reconfig_clk_0),
            .reconfig_togxb(reconfig_togxb_0),
            .reconfig_fromgxb(reconfig_fromgxb_0),             
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_0),
            .rx_datain (rxp_0),
            .rx_dataout (rx_frame_0),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[0]),
            .rx_errdetect (rx_char_err_gx[0]),
            .rx_patterndetect (rx_patterndetect[0]),
            .rx_rlv (rx_runlengthviolation[0]),
            .rx_seriallpbken (sd_loopback_0),
            .rx_syncstatus (rx_syncstatus[0]),
            .tx_clkout (pcs_clk_c0),
            .tx_ctrlenable (tx_kchar_0),
            .tx_datain (tx_frame_0),
            .tx_dataout (txp_0),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[0]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[0]),
            .rx_runningdisp(rx_runningdisp[0])
          );
   defparam
        the_altera_tse_gxb_gige_inst_0.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_0.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER,
        the_altera_tse_gxb_gige_inst_0.DEVICE_FAMILY = DEVICE_FAMILY; 
        
    end
else
    begin
    assign reconfig_fromgxb_0 = {17{1'b0}};
    assign led_char_err_gx[0] = 1'b0;
    assign link_status[0] = 1'b0;
    assign led_disp_err_0 = 1'b0;
    assign txp_0 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 1 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 1)
    begin          
        assign gxb_pwrdn_in_sig[1] = gxb_pwrdn_in_1;
        assign pcs_pwrdn_out_1 = pcs_pwrdn_out_sig[1];
    end
else
    begin
        assign gxb_pwrdn_in_sig[1] = pcs_pwrdn_out_sig[1];
    end      
endgenerate


generate if (MAX_CHANNELS > 1)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_1
          (
            .clk(pcs_clk_c1),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_1),
            .alt_sync(rx_syncstatus[1]),
            .alt_disperr(rx_disp_err[1]),
            .alt_ctrldetect(rx_kchar_1),
            .alt_errdetect(rx_char_err_gx[1]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[1]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[1]),
            .alt_runlengthviolation(rx_runlengthviolation[1]),
            .alt_patterndetect(rx_patterndetect[1]),
            .alt_runningdisp(rx_runningdisp[1]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_1),
            .altpcs_sync(link_status[1]),
            .altpcs_disperr(led_disp_err_1),
            .altpcs_ctrldetect(pcs_rx_kchar_1),
            .altpcs_errdetect(led_char_err_gx[1]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[1]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[1]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[1])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_1.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_1
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[1]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_1),
            .reconfig_togxb(reconfig_togxb_1),
            .reconfig_fromgxb(reconfig_fromgxb_1),         
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_1),
            .rx_datain (rxp_1),
            .rx_dataout (rx_frame_1),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[1]),
            .rx_errdetect (rx_char_err_gx[1]),
            .rx_patterndetect (rx_patterndetect[1]),
            .rx_rlv (rx_runlengthviolation[1]),
            .rx_seriallpbken (sd_loopback_1),
            .rx_syncstatus (rx_syncstatus[1]),
            .tx_clkout (pcs_clk_c1),
            .tx_ctrlenable (tx_kchar_1),
            .tx_datain (tx_frame_1),
            .tx_dataout (txp_1),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[1]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[1]),
            .rx_runningdisp(rx_runningdisp[1])
          );
   defparam
        the_altera_tse_gxb_gige_inst_1.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_1.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 4,
        the_altera_tse_gxb_gige_inst_1.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_1 = {17{1'b0}};
    assign led_char_err_gx[1] = 1'b0;
    assign link_status[1] = 1'b0;
    assign led_disp_err_1 = 1'b0;
    assign txp_1 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 2 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 2)
    begin          
        assign gxb_pwrdn_in_sig[2] = gxb_pwrdn_in_2;
        assign pcs_pwrdn_out_2 = pcs_pwrdn_out_sig[2];
    end
else
    begin
        assign gxb_pwrdn_in_sig[2] = pcs_pwrdn_out_sig[2];
    end      
endgenerate


generate if (MAX_CHANNELS > 2)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_2
          (
            .clk(pcs_clk_c2),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_2),
            .alt_sync(rx_syncstatus[2]),
            .alt_disperr(rx_disp_err[2]),
            .alt_ctrldetect(rx_kchar_2),
            .alt_errdetect(rx_char_err_gx[2]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[2]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[2]),
            .alt_runlengthviolation(rx_runlengthviolation[2]),
            .alt_patterndetect(rx_patterndetect[2]),
            .alt_runningdisp(rx_runningdisp[2]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_2),
            .altpcs_sync(link_status[2]),
            .altpcs_disperr(led_disp_err_2),
            .altpcs_ctrldetect(pcs_rx_kchar_2),
            .altpcs_errdetect(led_char_err_gx[2]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[2]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[2]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[2])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_2.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_2
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[2]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_2),
            .reconfig_togxb(reconfig_togxb_2),
            .reconfig_fromgxb(reconfig_fromgxb_2),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_2),
            .rx_datain (rxp_2),
            .rx_dataout (rx_frame_2),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[2]),
            .rx_errdetect (rx_char_err_gx[2]),
            .rx_patterndetect (rx_patterndetect[2]),
            .rx_rlv (rx_runlengthviolation[2]),
            .rx_seriallpbken (sd_loopback_2),
            .rx_syncstatus (rx_syncstatus[2]),
            .tx_clkout (pcs_clk_c2),
            .tx_ctrlenable (tx_kchar_2),
            .tx_datain (tx_frame_2),
            .tx_dataout (txp_2),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[2]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[2]),
            .rx_runningdisp(rx_runningdisp[2])
          );
   defparam
        the_altera_tse_gxb_gige_inst_2.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_2.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 8,
        the_altera_tse_gxb_gige_inst_2.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_2 = {17{1'b0}};
    assign led_char_err_gx[2] = 1'b0;
    assign link_status[2] = 1'b0;
    assign led_disp_err_2 = 1'b0;
    assign txp_2 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 3 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 3)
    begin          
        assign gxb_pwrdn_in_sig[3] = gxb_pwrdn_in_3;
        assign pcs_pwrdn_out_3 = pcs_pwrdn_out_sig[3];
    end
else
    begin
        assign gxb_pwrdn_in_sig[3] = pcs_pwrdn_out_sig[3];
    end      
endgenerate


generate if (MAX_CHANNELS > 3)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_3
          (
            .clk(pcs_clk_c3),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_3),
            .alt_sync(rx_syncstatus[3]),
            .alt_disperr(rx_disp_err[3]),
            .alt_ctrldetect(rx_kchar_3),
            .alt_errdetect(rx_char_err_gx[3]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[3]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[3]),
            .alt_runlengthviolation(rx_runlengthviolation[3]),
            .alt_patterndetect(rx_patterndetect[3]),
            .alt_runningdisp(rx_runningdisp[3]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_3),
            .altpcs_sync(link_status[3]),
            .altpcs_disperr(led_disp_err_3),
            .altpcs_ctrldetect(pcs_rx_kchar_3),
            .altpcs_errdetect(led_char_err_gx[3]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[3]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[3]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[3])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_3.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_3
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[3]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_3),
            .reconfig_togxb(reconfig_togxb_3),
            .reconfig_fromgxb(reconfig_fromgxb_3),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_3),
            .rx_datain (rxp_3),
            .rx_dataout (rx_frame_3),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[3]),
            .rx_errdetect (rx_char_err_gx[3]),
            .rx_patterndetect (rx_patterndetect[3]),
            .rx_rlv (rx_runlengthviolation[3]),
            .rx_seriallpbken (sd_loopback_3),
            .rx_syncstatus (rx_syncstatus[3]),
            .tx_clkout (pcs_clk_c3),
            .tx_ctrlenable (tx_kchar_3),
            .tx_datain (tx_frame_3),
            .tx_dataout (txp_3),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[3]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[3]),
            .rx_runningdisp(rx_runningdisp[3])
          );
   defparam
        the_altera_tse_gxb_gige_inst_3.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_3.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 12,
        the_altera_tse_gxb_gige_inst_3.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_3 = {17{1'b0}};
    assign led_char_err_gx[3] = 1'b0;
    assign link_status[3] = 1'b0;
    assign led_disp_err_3 = 1'b0;
    assign txp_3 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 4 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 4)
    begin          
        assign gxb_pwrdn_in_sig[4] = gxb_pwrdn_in_4;
        assign pcs_pwrdn_out_4 = pcs_pwrdn_out_sig[4];
    end
else
    begin
        assign gxb_pwrdn_in_sig[4] = pcs_pwrdn_out_sig[4];
    end      
endgenerate


generate if (MAX_CHANNELS > 4)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_4
          (
            .clk(pcs_clk_c4),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_4),
            .alt_sync(rx_syncstatus[4]),
            .alt_disperr(rx_disp_err[4]),
            .alt_ctrldetect(rx_kchar_4),
            .alt_errdetect(rx_char_err_gx[4]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[4]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[4]),
            .alt_runlengthviolation(rx_runlengthviolation[4]),
            .alt_patterndetect(rx_patterndetect[4]),
            .alt_runningdisp(rx_runningdisp[4]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_4),
            .altpcs_sync(link_status[4]),
            .altpcs_disperr(led_disp_err_4),
            .altpcs_ctrldetect(pcs_rx_kchar_4),
            .altpcs_errdetect(led_char_err_gx[4]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[4]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[4]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[4])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_4.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_4
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[4]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_4),
            .reconfig_togxb(reconfig_togxb_4),
            .reconfig_fromgxb(reconfig_fromgxb_4),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_4),
            .rx_datain (rxp_4),
            .rx_dataout (rx_frame_4),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[4]),
            .rx_errdetect (rx_char_err_gx[4]),
            .rx_patterndetect (rx_patterndetect[4]),
            .rx_rlv (rx_runlengthviolation[4]),
            .rx_seriallpbken (sd_loopback_4),
            .rx_syncstatus (rx_syncstatus[4]),
            .tx_clkout (pcs_clk_c4),
            .tx_ctrlenable (tx_kchar_4),
            .tx_datain (tx_frame_4),
            .tx_dataout (txp_4),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[4]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[4]),
            .rx_runningdisp(rx_runningdisp[4])
          );
   defparam
        the_altera_tse_gxb_gige_inst_4.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_4.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 16,
        the_altera_tse_gxb_gige_inst_4.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_4 = {17{1'b0}};
    assign led_char_err_gx[4] = 1'b0;
    assign link_status[4] = 1'b0;
    assign led_disp_err_4 = 1'b0;
    assign txp_4 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 5 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 5)
    begin          
        assign gxb_pwrdn_in_sig[5] = gxb_pwrdn_in_5;
        assign pcs_pwrdn_out_5 = pcs_pwrdn_out_sig[5];
    end
else
    begin
        assign gxb_pwrdn_in_sig[5] = pcs_pwrdn_out_sig[5];
    end      
endgenerate


generate if (MAX_CHANNELS > 5)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_5
          (
            .clk(pcs_clk_c5),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_5),
            .alt_sync(rx_syncstatus[5]),
            .alt_disperr(rx_disp_err[5]),
            .alt_ctrldetect(rx_kchar_5),
            .alt_errdetect(rx_char_err_gx[5]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[5]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[5]),
            .alt_runlengthviolation(rx_runlengthviolation[5]),
            .alt_patterndetect(rx_patterndetect[5]),
            .alt_runningdisp(rx_runningdisp[5]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_5),
            .altpcs_sync(link_status[5]),
            .altpcs_disperr(led_disp_err_5),
            .altpcs_ctrldetect(pcs_rx_kchar_5),
            .altpcs_errdetect(led_char_err_gx[5]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[5]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[5]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[5])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_5.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_5
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[5]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_5),
            .reconfig_togxb(reconfig_togxb_5),
            .reconfig_fromgxb(reconfig_fromgxb_5),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_5),
            .rx_datain (rxp_5),
            .rx_dataout (rx_frame_5),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[5]),
            .rx_errdetect (rx_char_err_gx[5]),
            .rx_patterndetect (rx_patterndetect[5]),
            .rx_rlv (rx_runlengthviolation[5]),
            .rx_seriallpbken (sd_loopback_5),
            .rx_syncstatus (rx_syncstatus[5]),
            .tx_clkout (pcs_clk_c5),
            .tx_ctrlenable (tx_kchar_5),
            .tx_datain (tx_frame_5),
            .tx_dataout (txp_5),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[5]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[5]),
            .rx_runningdisp(rx_runningdisp[5])
          );
   defparam
        the_altera_tse_gxb_gige_inst_5.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_5.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 20,
        the_altera_tse_gxb_gige_inst_5.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_5 = {17{1'b0}};
    assign led_char_err_gx[5] = 1'b0;
    assign link_status[5] = 1'b0;
    assign led_disp_err_5 = 1'b0;
    assign txp_5 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 6 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 6)
    begin          
        assign gxb_pwrdn_in_sig[6] = gxb_pwrdn_in_6;
        assign pcs_pwrdn_out_6 = pcs_pwrdn_out_sig[6];
    end
else
    begin
        assign gxb_pwrdn_in_sig[6] = pcs_pwrdn_out_sig[6];
    end      
endgenerate


generate if (MAX_CHANNELS > 6)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_6
          (
            .clk(pcs_clk_c6),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_6),
            .alt_sync(rx_syncstatus[6]),
            .alt_disperr(rx_disp_err[6]),
            .alt_ctrldetect(rx_kchar_6),
            .alt_errdetect(rx_char_err_gx[6]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[6]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[6]),
            .alt_runlengthviolation(rx_runlengthviolation[6]),
            .alt_patterndetect(rx_patterndetect[6]),
            .alt_runningdisp(rx_runningdisp[6]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_6),
            .altpcs_sync(link_status[6]),
            .altpcs_disperr(led_disp_err_6),
            .altpcs_ctrldetect(pcs_rx_kchar_6),
            .altpcs_errdetect(led_char_err_gx[6]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[6]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[6]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[6])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_6.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_6
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[6]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_6),
            .reconfig_togxb(reconfig_togxb_6),
            .reconfig_fromgxb(reconfig_fromgxb_6),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_6),
            .rx_datain (rxp_6),
            .rx_dataout (rx_frame_6),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[6]),
            .rx_errdetect (rx_char_err_gx[6]),
            .rx_patterndetect (rx_patterndetect[6]),
            .rx_rlv (rx_runlengthviolation[6]),
            .rx_seriallpbken (sd_loopback_6),
            .rx_syncstatus (rx_syncstatus[6]),
            .tx_clkout (pcs_clk_c6),
            .tx_ctrlenable (tx_kchar_6),
            .tx_datain (tx_frame_6),
            .tx_dataout (txp_6),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[6]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[6]),
            .rx_runningdisp(rx_runningdisp[6])
          );
   defparam
        the_altera_tse_gxb_gige_inst_6.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_6.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 24,
        the_altera_tse_gxb_gige_inst_6.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_6 = {17{1'b0}};
    assign led_char_err_gx[6] = 1'b0;
    assign link_status[6] = 1'b0;
    assign led_disp_err_6 = 1'b0;
    assign txp_6 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 7 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 7)
    begin          
        assign gxb_pwrdn_in_sig[7] = gxb_pwrdn_in_7;
        assign pcs_pwrdn_out_7 = pcs_pwrdn_out_sig[7];
    end
else
    begin
        assign gxb_pwrdn_in_sig[7] = pcs_pwrdn_out_sig[7];
    end      
endgenerate


generate if (MAX_CHANNELS > 7)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_7
          (
            .clk(pcs_clk_c7),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_7),
            .alt_sync(rx_syncstatus[7]),
            .alt_disperr(rx_disp_err[7]),
            .alt_ctrldetect(rx_kchar_7),
            .alt_errdetect(rx_char_err_gx[7]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[7]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[7]),
            .alt_runlengthviolation(rx_runlengthviolation[7]),
            .alt_patterndetect(rx_patterndetect[7]),
            .alt_runningdisp(rx_runningdisp[7]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_7),
            .altpcs_sync(link_status[7]),
            .altpcs_disperr(led_disp_err_7),
            .altpcs_ctrldetect(pcs_rx_kchar_7),
            .altpcs_errdetect(led_char_err_gx[7]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[7]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[7]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[7])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_7.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_7
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[7]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_7),
            .reconfig_togxb(reconfig_togxb_7),
            .reconfig_fromgxb(reconfig_fromgxb_7),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_7),
            .rx_datain (rxp_7),
            .rx_dataout (rx_frame_7),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[7]),
            .rx_errdetect (rx_char_err_gx[7]),
            .rx_patterndetect (rx_patterndetect[7]),
            .rx_rlv (rx_runlengthviolation[7]),
            .rx_seriallpbken (sd_loopback_7),
            .rx_syncstatus (rx_syncstatus[7]),
            .tx_clkout (pcs_clk_c7),
            .tx_ctrlenable (tx_kchar_7),
            .tx_datain (tx_frame_7),
            .tx_dataout (txp_7),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[7]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[7]),
            .rx_runningdisp(rx_runningdisp[7])
          );
   defparam
        the_altera_tse_gxb_gige_inst_7.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_7.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 24,
        the_altera_tse_gxb_gige_inst_7.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_7 = {17{1'b0}};
    assign led_char_err_gx[7] = 1'b0;
    assign link_status[7] = 1'b0;
    assign led_disp_err_7 = 1'b0;
    assign txp_7 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 8 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 8)
    begin          
        assign gxb_pwrdn_in_sig[8] = gxb_pwrdn_in_8;
        assign pcs_pwrdn_out_8 = pcs_pwrdn_out_sig[8];
    end
else
    begin
        assign gxb_pwrdn_in_sig[8] = pcs_pwrdn_out_sig[8];
    end      
endgenerate


generate if (MAX_CHANNELS > 8)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_8
          (
            .clk(pcs_clk_c8),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_8),
            .alt_sync(rx_syncstatus[8]),
            .alt_disperr(rx_disp_err[8]),
            .alt_ctrldetect(rx_kchar_8),
            .alt_errdetect(rx_char_err_gx[8]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[8]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[8]),
            .alt_runlengthviolation(rx_runlengthviolation[8]),
            .alt_patterndetect(rx_patterndetect[8]),
            .alt_runningdisp(rx_runningdisp[8]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_8),
            .altpcs_sync(link_status[8]),
            .altpcs_disperr(led_disp_err_8),
            .altpcs_ctrldetect(pcs_rx_kchar_8),
            .altpcs_errdetect(led_char_err_gx[8]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[8]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[8]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[8])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_8.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_8
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[8]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_8),
            .reconfig_togxb(reconfig_togxb_8),
            .reconfig_fromgxb(reconfig_fromgxb_8),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_8),
            .rx_datain (rxp_8),
            .rx_dataout (rx_frame_8),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[8]),
            .rx_errdetect (rx_char_err_gx[8]),
            .rx_patterndetect (rx_patterndetect[8]),
            .rx_rlv (rx_runlengthviolation[8]),
            .rx_seriallpbken (sd_loopback_8),
            .rx_syncstatus (rx_syncstatus[8]),
            .tx_clkout (pcs_clk_c8),
            .tx_ctrlenable (tx_kchar_8),
            .tx_datain (tx_frame_8),
            .tx_dataout (txp_8),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[8]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[8]),
            .rx_runningdisp(rx_runningdisp[8])
          );
   defparam
        the_altera_tse_gxb_gige_inst_8.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_8.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 32,
        the_altera_tse_gxb_gige_inst_8.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_8 = {17{1'b0}};
    assign led_char_err_gx[8] = 1'b0;
    assign link_status[8] = 1'b0;
    assign led_disp_err_8 = 1'b0;
    assign txp_8 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 9 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 9)
    begin          
        assign gxb_pwrdn_in_sig[9] = gxb_pwrdn_in_9;
        assign pcs_pwrdn_out_9 = pcs_pwrdn_out_sig[9];
    end
else
    begin
        assign gxb_pwrdn_in_sig[9] = pcs_pwrdn_out_sig[9];
    end      
endgenerate


generate if (MAX_CHANNELS > 9)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_9
          (
            .clk(pcs_clk_c9),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_9),
            .alt_sync(rx_syncstatus[9]),
            .alt_disperr(rx_disp_err[9]),
            .alt_ctrldetect(rx_kchar_9),
            .alt_errdetect(rx_char_err_gx[9]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[9]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[9]),
            .alt_runlengthviolation(rx_runlengthviolation[9]),
            .alt_patterndetect(rx_patterndetect[9]),
            .alt_runningdisp(rx_runningdisp[9]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_9),
            .altpcs_sync(link_status[9]),
            .altpcs_disperr(led_disp_err_9),
            .altpcs_ctrldetect(pcs_rx_kchar_9),
            .altpcs_errdetect(led_char_err_gx[9]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[9]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[9]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[9])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_9.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_9
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[9]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_9),
            .reconfig_togxb(reconfig_togxb_9),
            .reconfig_fromgxb(reconfig_fromgxb_9),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_9),
            .rx_datain (rxp_9),
            .rx_dataout (rx_frame_9),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[9]),
            .rx_errdetect (rx_char_err_gx[9]),
            .rx_patterndetect (rx_patterndetect[9]),
            .rx_rlv (rx_runlengthviolation[9]),
            .rx_seriallpbken (sd_loopback_9),
            .rx_syncstatus (rx_syncstatus[9]),
            .tx_clkout (pcs_clk_c9),
            .tx_ctrlenable (tx_kchar_9),
            .tx_datain (tx_frame_9),
            .tx_dataout (txp_9),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[9]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[9]),
            .rx_runningdisp(rx_runningdisp[9])
          );
   defparam
        the_altera_tse_gxb_gige_inst_9.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_9.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 36,
        the_altera_tse_gxb_gige_inst_9.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_9 = {17{1'b0}};
    assign led_char_err_gx[9] = 1'b0;
    assign link_status[9] = 1'b0;
    assign led_disp_err_9 = 1'b0;
    assign txp_9 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 10 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 10)
    begin          
        assign gxb_pwrdn_in_sig[10] = gxb_pwrdn_in_10;
        assign pcs_pwrdn_out_10 = pcs_pwrdn_out_sig[10];
    end
else
    begin
        assign gxb_pwrdn_in_sig[10] = pcs_pwrdn_out_sig[10];
    end      
endgenerate


generate if (MAX_CHANNELS > 10)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_10
          (
            .clk(pcs_clk_c10),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_10),
            .alt_sync(rx_syncstatus[10]),
            .alt_disperr(rx_disp_err[10]),
            .alt_ctrldetect(rx_kchar_10),
            .alt_errdetect(rx_char_err_gx[10]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[10]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[10]),
            .alt_runlengthviolation(rx_runlengthviolation[10]),
            .alt_patterndetect(rx_patterndetect[10]),
            .alt_runningdisp(rx_runningdisp[10]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_10),
            .altpcs_sync(link_status[10]),
            .altpcs_disperr(led_disp_err_10),
            .altpcs_ctrldetect(pcs_rx_kchar_10),
            .altpcs_errdetect(led_char_err_gx[10]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[10]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[10]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[10])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_10.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_10
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[10]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_10),
            .reconfig_togxb(reconfig_togxb_10),
            .reconfig_fromgxb(reconfig_fromgxb_10),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_10),
            .rx_datain (rxp_10),
            .rx_dataout (rx_frame_10),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[10]),
            .rx_errdetect (rx_char_err_gx[10]),
            .rx_patterndetect (rx_patterndetect[10]),
            .rx_rlv (rx_runlengthviolation[10]),
            .rx_seriallpbken (sd_loopback_10),
            .rx_syncstatus (rx_syncstatus[10]),
            .tx_clkout (pcs_clk_c10),
            .tx_ctrlenable (tx_kchar_10),
            .tx_datain (tx_frame_10),
            .tx_dataout (txp_10),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[10]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[10]),
            .rx_runningdisp(rx_runningdisp[10])
          );
   defparam
        the_altera_tse_gxb_gige_inst_10.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_10.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 40,
        the_altera_tse_gxb_gige_inst_10.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_10 = {17{1'b0}};
    assign led_char_err_gx[10] = 1'b0;
    assign link_status[10] = 1'b0;
    assign led_disp_err_10 = 1'b0;
    assign txp_10 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 11 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 11)
    begin          
        assign gxb_pwrdn_in_sig[11] = gxb_pwrdn_in_11;
        assign pcs_pwrdn_out_11 = pcs_pwrdn_out_sig[11];
    end
else
    begin
        assign gxb_pwrdn_in_sig[11] = pcs_pwrdn_out_sig[11];
    end      
endgenerate


generate if (MAX_CHANNELS > 11)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_11
          (
            .clk(pcs_clk_c11),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_11),
            .alt_sync(rx_syncstatus[11]),
            .alt_disperr(rx_disp_err[11]),
            .alt_ctrldetect(rx_kchar_11),
            .alt_errdetect(rx_char_err_gx[11]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[11]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[11]),
            .alt_runlengthviolation(rx_runlengthviolation[11]),
            .alt_patterndetect(rx_patterndetect[11]),
            .alt_runningdisp(rx_runningdisp[11]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_11),
            .altpcs_sync(link_status[11]),
            .altpcs_disperr(led_disp_err_11),
            .altpcs_ctrldetect(pcs_rx_kchar_11),
            .altpcs_errdetect(led_char_err_gx[11]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[11]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[11]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[11])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_11.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_11
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[11]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_11),
            .reconfig_togxb(reconfig_togxb_11),
            .reconfig_fromgxb(reconfig_fromgxb_11),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_11),
            .rx_datain (rxp_11),
            .rx_dataout (rx_frame_11),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[11]),
            .rx_errdetect (rx_char_err_gx[11]),
            .rx_patterndetect (rx_patterndetect[11]),
            .rx_rlv (rx_runlengthviolation[11]),
            .rx_seriallpbken (sd_loopback_11),
            .rx_syncstatus (rx_syncstatus[11]),
            .tx_clkout (pcs_clk_c11),
            .tx_ctrlenable (tx_kchar_11),
            .tx_datain (tx_frame_11),
            .tx_dataout (txp_11),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[11]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[11]),
            .rx_runningdisp(rx_runningdisp[11])
          );
   defparam
        the_altera_tse_gxb_gige_inst_11.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_11.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 44,
        the_altera_tse_gxb_gige_inst_11.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_11 = {17{1'b0}};
    assign led_char_err_gx[11] = 1'b0;
    assign link_status[11] = 1'b0;
    assign led_disp_err_11 = 1'b0;
    assign txp_11 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 12 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 12)
    begin          
        assign gxb_pwrdn_in_sig[12] = gxb_pwrdn_in_12;
        assign pcs_pwrdn_out_12 = pcs_pwrdn_out_sig[12];
    end
else
    begin
        assign gxb_pwrdn_in_sig[12] = pcs_pwrdn_out_sig[12];
    end      
endgenerate


generate if (MAX_CHANNELS > 12)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_12
          (
            .clk(pcs_clk_c12),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_12),
            .alt_sync(rx_syncstatus[12]),
            .alt_disperr(rx_disp_err[12]),
            .alt_ctrldetect(rx_kchar_12),
            .alt_errdetect(rx_char_err_gx[12]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[12]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[12]),
            .alt_runlengthviolation(rx_runlengthviolation[12]),
            .alt_patterndetect(rx_patterndetect[12]),
            .alt_runningdisp(rx_runningdisp[12]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_12),
            .altpcs_sync(link_status[12]),
            .altpcs_disperr(led_disp_err_12),
            .altpcs_ctrldetect(pcs_rx_kchar_12),
            .altpcs_errdetect(led_char_err_gx[12]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[12]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[12]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[12])
           ) ;
 		defparam
		the_altera_tse_gxb_aligned_rxsync_12.DEVICE_FAMILY = DEVICE_FAMILY;   

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_12
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[12]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_12),
            .reconfig_togxb(reconfig_togxb_12),
            .reconfig_fromgxb(reconfig_fromgxb_12),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_12),
            .rx_datain (rxp_12),
            .rx_dataout (rx_frame_12),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[12]),
            .rx_errdetect (rx_char_err_gx[12]),
            .rx_patterndetect (rx_patterndetect[12]),
            .rx_rlv (rx_runlengthviolation[12]),
            .rx_seriallpbken (sd_loopback_12),
            .rx_syncstatus (rx_syncstatus[12]),
            .tx_clkout (pcs_clk_c12),
            .tx_ctrlenable (tx_kchar_12),
            .tx_datain (tx_frame_12),
            .tx_dataout (txp_12),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[12]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[12]),
            .rx_runningdisp(rx_runningdisp[12])
          );
   defparam
        the_altera_tse_gxb_gige_inst_12.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_12.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 48,
        the_altera_tse_gxb_gige_inst_12.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_12 = {17{1'b0}};
    assign led_char_err_gx[12] = 1'b0;
    assign link_status[12] = 1'b0;
    assign led_disp_err_12 = 1'b0;
    assign txp_12 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 13 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 13)
    begin          
        assign gxb_pwrdn_in_sig[13] = gxb_pwrdn_in_13;
        assign pcs_pwrdn_out_13 = pcs_pwrdn_out_sig[13];
    end
else
    begin
        assign gxb_pwrdn_in_sig[13] = pcs_pwrdn_out_sig[13];
    end      
endgenerate


generate if (MAX_CHANNELS > 13)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_13
          (
            .clk(pcs_clk_c13),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_13),
            .alt_sync(rx_syncstatus[13]),
            .alt_disperr(rx_disp_err[13]),
            .alt_ctrldetect(rx_kchar_13),
            .alt_errdetect(rx_char_err_gx[13]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[13]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[13]),
            .alt_runlengthviolation(rx_runlengthviolation[13]),
            .alt_patterndetect(rx_patterndetect[13]),
            .alt_runningdisp(rx_runningdisp[13]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_13),
            .altpcs_sync(link_status[13]),
            .altpcs_disperr(led_disp_err_13),
            .altpcs_ctrldetect(pcs_rx_kchar_13),
            .altpcs_errdetect(led_char_err_gx[13]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[13]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[13]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[13])
           ) ;
 		defparam
		the_altera_tse_gxb_aligned_rxsync_13.DEVICE_FAMILY = DEVICE_FAMILY;   

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_13
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[13]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_13),
            .reconfig_togxb(reconfig_togxb_13),
            .reconfig_fromgxb(reconfig_fromgxb_13),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_13),
            .rx_datain (rxp_13),
            .rx_dataout (rx_frame_13),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[13]),
            .rx_errdetect (rx_char_err_gx[13]),
            .rx_patterndetect (rx_patterndetect[13]),
            .rx_rlv (rx_runlengthviolation[13]),
            .rx_seriallpbken (sd_loopback_13),
            .rx_syncstatus (rx_syncstatus[13]),
            .tx_clkout (pcs_clk_c13),
            .tx_ctrlenable (tx_kchar_13),
            .tx_datain (tx_frame_13),
            .tx_dataout (txp_13),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[13]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[13]),
            .rx_runningdisp(rx_runningdisp[13])
          );
   defparam
        the_altera_tse_gxb_gige_inst_13.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_13.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 52,
        the_altera_tse_gxb_gige_inst_13.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_13 = {17{1'b0}};
    assign led_char_err_gx[13] = 1'b0;
    assign link_status[13] = 1'b0;
    assign led_disp_err_13 = 1'b0;
    assign txp_13 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 14 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 14)
    begin          
        assign gxb_pwrdn_in_sig[14] = gxb_pwrdn_in_14;
        assign pcs_pwrdn_out_14 = pcs_pwrdn_out_sig[14];
    end
else
    begin
        assign gxb_pwrdn_in_sig[14] = pcs_pwrdn_out_sig[14];
    end      
endgenerate


generate if (MAX_CHANNELS > 14)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_14
          (
            .clk(pcs_clk_c14),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_14),
            .alt_sync(rx_syncstatus[14]),
            .alt_disperr(rx_disp_err[14]),
            .alt_ctrldetect(rx_kchar_14),
            .alt_errdetect(rx_char_err_gx[14]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[14]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[14]),
            .alt_runlengthviolation(rx_runlengthviolation[14]),
            .alt_patterndetect(rx_patterndetect[14]),
            .alt_runningdisp(rx_runningdisp[14]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_14),
            .altpcs_sync(link_status[14]),
            .altpcs_disperr(led_disp_err_14),
            .altpcs_ctrldetect(pcs_rx_kchar_14),
            .altpcs_errdetect(led_char_err_gx[14]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[14]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[14]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[14])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_14.DEVICE_FAMILY = DEVICE_FAMILY;
		
        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_14
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[14]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_14),
            .reconfig_togxb(reconfig_togxb_14),
            .reconfig_fromgxb(reconfig_fromgxb_14),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_14),
            .rx_datain (rxp_14),
            .rx_dataout (rx_frame_14),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[14]),
            .rx_errdetect (rx_char_err_gx[14]),
            .rx_patterndetect (rx_patterndetect[14]),
            .rx_rlv (rx_runlengthviolation[14]),
            .rx_seriallpbken (sd_loopback_14),
            .rx_syncstatus (rx_syncstatus[14]),
            .tx_clkout (pcs_clk_c14),
            .tx_ctrlenable (tx_kchar_14),
            .tx_datain (tx_frame_14),
            .tx_dataout (txp_14),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[14]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[14]),
            .rx_runningdisp(rx_runningdisp[14])
          );
   defparam
        the_altera_tse_gxb_gige_inst_14.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_14.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 56,
        the_altera_tse_gxb_gige_inst_14.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_14 = {17{1'b0}};
    assign led_char_err_gx[14] = 1'b0;
    assign link_status[14] = 1'b0;
    assign led_disp_err_14 = 1'b0;
    assign txp_14 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 15 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 15)
    begin          
        assign gxb_pwrdn_in_sig[15] = gxb_pwrdn_in_15;
        assign pcs_pwrdn_out_15 = pcs_pwrdn_out_sig[15];
    end
else
    begin
        assign gxb_pwrdn_in_sig[15] = pcs_pwrdn_out_sig[15];
    end      
endgenerate


generate if (MAX_CHANNELS > 15)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_15
          (
            .clk(pcs_clk_c15),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_15),
            .alt_sync(rx_syncstatus[15]),
            .alt_disperr(rx_disp_err[15]),
            .alt_ctrldetect(rx_kchar_15),
            .alt_errdetect(rx_char_err_gx[15]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[15]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[15]),
            .alt_runlengthviolation(rx_runlengthviolation[15]),
            .alt_patterndetect(rx_patterndetect[15]),
            .alt_runningdisp(rx_runningdisp[15]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_15),
            .altpcs_sync(link_status[15]),
            .altpcs_disperr(led_disp_err_15),
            .altpcs_ctrldetect(pcs_rx_kchar_15),
            .altpcs_errdetect(led_char_err_gx[15]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[15]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[15]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[15])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_15.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_15
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[15]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_15),
            .reconfig_togxb(reconfig_togxb_15),
            .reconfig_fromgxb(reconfig_fromgxb_15),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_15),
            .rx_datain (rxp_15),
            .rx_dataout (rx_frame_15),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[15]),
            .rx_errdetect (rx_char_err_gx[15]),
            .rx_patterndetect (rx_patterndetect[15]),
            .rx_rlv (rx_runlengthviolation[15]),
            .rx_seriallpbken (sd_loopback_15),
            .rx_syncstatus (rx_syncstatus[15]),
            .tx_clkout (pcs_clk_c15),
            .tx_ctrlenable (tx_kchar_15),
            .tx_datain (tx_frame_15),
            .tx_dataout (txp_15),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[15]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[15]),
            .rx_runningdisp(rx_runningdisp[15])
          );
   defparam
        the_altera_tse_gxb_gige_inst_15.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_15.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 60,
        the_altera_tse_gxb_gige_inst_15.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_15 = {17{1'b0}};
    assign led_char_err_gx[15] = 1'b0;
    assign link_status[15] = 1'b0;
    assign led_disp_err_15 = 1'b0;
    assign txp_15 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 16 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 16)
    begin          
        assign gxb_pwrdn_in_sig[16] = gxb_pwrdn_in_16;
        assign pcs_pwrdn_out_16 = pcs_pwrdn_out_sig[16];
    end
else
    begin
        assign gxb_pwrdn_in_sig[16] = pcs_pwrdn_out_sig[16];
    end      
endgenerate


generate if (MAX_CHANNELS > 16)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_16
          (
            .clk(pcs_clk_c16),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_16),
            .alt_sync(rx_syncstatus[16]),
            .alt_disperr(rx_disp_err[16]),
            .alt_ctrldetect(rx_kchar_16),
            .alt_errdetect(rx_char_err_gx[16]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[16]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[16]),
            .alt_runlengthviolation(rx_runlengthviolation[16]),
            .alt_patterndetect(rx_patterndetect[16]),
            .alt_runningdisp(rx_runningdisp[16]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_16),
            .altpcs_sync(link_status[16]),
            .altpcs_disperr(led_disp_err_16),
            .altpcs_ctrldetect(pcs_rx_kchar_16),
            .altpcs_errdetect(led_char_err_gx[16]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[16]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[16]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[16])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_16.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_16
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[16]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_16),
            .reconfig_togxb(reconfig_togxb_16),
            .reconfig_fromgxb(reconfig_fromgxb_16),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_16),
            .rx_datain (rxp_16),
            .rx_dataout (rx_frame_16),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[16]),
            .rx_errdetect (rx_char_err_gx[16]),
            .rx_patterndetect (rx_patterndetect[16]),
            .rx_rlv (rx_runlengthviolation[16]),
            .rx_seriallpbken (sd_loopback_16),
            .rx_syncstatus (rx_syncstatus[16]),
            .tx_clkout (pcs_clk_c16),
            .tx_ctrlenable (tx_kchar_16),
            .tx_datain (tx_frame_16),
            .tx_dataout (txp_16),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[16]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[16]),
            .rx_runningdisp(rx_runningdisp[16])
          );
   defparam
        the_altera_tse_gxb_gige_inst_16.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_16.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 64,
        the_altera_tse_gxb_gige_inst_16.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_16 = {17{1'b0}};
    assign led_char_err_gx[16] = 1'b0;
    assign link_status[16] = 1'b0;
    assign led_disp_err_16 = 1'b0;
    assign txp_16 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 17 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 17)
    begin          
        assign gxb_pwrdn_in_sig[17] = gxb_pwrdn_in_17;
        assign pcs_pwrdn_out_17 = pcs_pwrdn_out_sig[17];
    end
else
    begin
        assign gxb_pwrdn_in_sig[17] = pcs_pwrdn_out_sig[17];
    end      
endgenerate


generate if (MAX_CHANNELS > 17)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_17
          (
            .clk(pcs_clk_c17),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_17),
            .alt_sync(rx_syncstatus[17]),
            .alt_disperr(rx_disp_err[17]),
            .alt_ctrldetect(rx_kchar_17),
            .alt_errdetect(rx_char_err_gx[17]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[17]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[17]),
            .alt_runlengthviolation(rx_runlengthviolation[17]),
            .alt_patterndetect(rx_patterndetect[17]),
            .alt_runningdisp(rx_runningdisp[17]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_17),
            .altpcs_sync(link_status[17]),
            .altpcs_disperr(led_disp_err_17),
            .altpcs_ctrldetect(pcs_rx_kchar_17),
            .altpcs_errdetect(led_char_err_gx[17]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[17]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[17]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[17])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_17.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_17
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[17]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_17),
            .reconfig_togxb(reconfig_togxb_17),
            .reconfig_fromgxb(reconfig_fromgxb_17),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_17),
            .rx_datain (rxp_17),
            .rx_dataout (rx_frame_17),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[17]),
            .rx_errdetect (rx_char_err_gx[17]),
            .rx_patterndetect (rx_patterndetect[17]),
            .rx_rlv (rx_runlengthviolation[17]),
            .rx_seriallpbken (sd_loopback_17),
            .rx_syncstatus (rx_syncstatus[17]),
            .tx_clkout (pcs_clk_c17),
            .tx_ctrlenable (tx_kchar_17),
            .tx_datain (tx_frame_17),
            .tx_dataout (txp_17),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[17]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[17]),
            .rx_runningdisp(rx_runningdisp[17])
          );
   defparam
        the_altera_tse_gxb_gige_inst_17.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_17.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 68,
        the_altera_tse_gxb_gige_inst_17.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_17 = {17{1'b0}};
    assign led_char_err_gx[17] = 1'b0;
    assign link_status[17] = 1'b0;
    assign led_disp_err_17 = 1'b0;
    assign txp_17 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 18 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 18)
    begin          
        assign gxb_pwrdn_in_sig[18] = gxb_pwrdn_in_18;
        assign pcs_pwrdn_out_18 = pcs_pwrdn_out_sig[18];
    end
else
    begin
        assign gxb_pwrdn_in_sig[18] = pcs_pwrdn_out_sig[18];
    end      
endgenerate


generate if (MAX_CHANNELS > 18)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_18
          (
            .clk(pcs_clk_c18),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_18),
            .alt_sync(rx_syncstatus[18]),
            .alt_disperr(rx_disp_err[18]),
            .alt_ctrldetect(rx_kchar_18),
            .alt_errdetect(rx_char_err_gx[18]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[18]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[18]),
            .alt_runlengthviolation(rx_runlengthviolation[18]),
            .alt_patterndetect(rx_patterndetect[18]),
            .alt_runningdisp(rx_runningdisp[18]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_18),
            .altpcs_sync(link_status[18]),
            .altpcs_disperr(led_disp_err_18),
            .altpcs_ctrldetect(pcs_rx_kchar_18),
            .altpcs_errdetect(led_char_err_gx[18]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[18]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[18]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[18])
           ) ;
 		defparam
		the_altera_tse_gxb_aligned_rxsync_18.DEVICE_FAMILY = DEVICE_FAMILY;   

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_18
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[18]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_18),
            .reconfig_togxb(reconfig_togxb_18),
            .reconfig_fromgxb(reconfig_fromgxb_18),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_18),
            .rx_datain (rxp_18),
            .rx_dataout (rx_frame_18),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[18]),
            .rx_errdetect (rx_char_err_gx[18]),
            .rx_patterndetect (rx_patterndetect[18]),
            .rx_rlv (rx_runlengthviolation[18]),
            .rx_seriallpbken (sd_loopback_18),
            .rx_syncstatus (rx_syncstatus[18]),
            .tx_clkout (pcs_clk_c18),
            .tx_ctrlenable (tx_kchar_18),
            .tx_datain (tx_frame_18),
            .tx_dataout (txp_18),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[18]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[18]),
            .rx_runningdisp(rx_runningdisp[18])
          );
   defparam
        the_altera_tse_gxb_gige_inst_18.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_18.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 72,
        the_altera_tse_gxb_gige_inst_18.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_18 = {17{1'b0}};
    assign led_char_err_gx[18] = 1'b0;
    assign link_status[18] = 1'b0;
    assign led_disp_err_18 = 1'b0;
    assign txp_18 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 19 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 19)
    begin          
        assign gxb_pwrdn_in_sig[19] = gxb_pwrdn_in_19;
        assign pcs_pwrdn_out_19 = pcs_pwrdn_out_sig[19];
    end
else
    begin
        assign gxb_pwrdn_in_sig[19] = pcs_pwrdn_out_sig[19];
    end      
endgenerate


generate if (MAX_CHANNELS > 19)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_19
          (
            .clk(pcs_clk_c19),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_19),
            .alt_sync(rx_syncstatus[19]),
            .alt_disperr(rx_disp_err[19]),
            .alt_ctrldetect(rx_kchar_19),
            .alt_errdetect(rx_char_err_gx[19]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[19]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[19]),
            .alt_runlengthviolation(rx_runlengthviolation[19]),
            .alt_patterndetect(rx_patterndetect[19]),
            .alt_runningdisp(rx_runningdisp[19]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_19),
            .altpcs_sync(link_status[19]),
            .altpcs_disperr(led_disp_err_19),
            .altpcs_ctrldetect(pcs_rx_kchar_19),
            .altpcs_errdetect(led_char_err_gx[19]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[19]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[19]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[19])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_19.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_19
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[19]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_19),
            .reconfig_togxb(reconfig_togxb_19),
            .reconfig_fromgxb(reconfig_fromgxb_19),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_19),
            .rx_datain (rxp_19),
            .rx_dataout (rx_frame_19),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[19]),
            .rx_errdetect (rx_char_err_gx[19]),
            .rx_patterndetect (rx_patterndetect[19]),
            .rx_rlv (rx_runlengthviolation[19]),
            .rx_seriallpbken (sd_loopback_19),
            .rx_syncstatus (rx_syncstatus[19]),
            .tx_clkout (pcs_clk_c19),
            .tx_ctrlenable (tx_kchar_19),
            .tx_datain (tx_frame_19),
            .tx_dataout (txp_19),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[19]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[19]),
            .rx_runningdisp(rx_runningdisp[19])
          );
   defparam
        the_altera_tse_gxb_gige_inst_19.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_19.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 76,
        the_altera_tse_gxb_gige_inst_19.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_19 = {17{1'b0}};
    assign led_char_err_gx[19] = 1'b0;
    assign link_status[19] = 1'b0;
    assign led_disp_err_19 = 1'b0;
    assign txp_19 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 20 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 20)
    begin          
        assign gxb_pwrdn_in_sig[20] = gxb_pwrdn_in_20;
        assign pcs_pwrdn_out_20 = pcs_pwrdn_out_sig[20];
    end
else
    begin
        assign gxb_pwrdn_in_sig[20] = pcs_pwrdn_out_sig[20];
    end      
endgenerate


generate if (MAX_CHANNELS > 20)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_20
          (
            .clk(pcs_clk_c20),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_20),
            .alt_sync(rx_syncstatus[20]),
            .alt_disperr(rx_disp_err[20]),
            .alt_ctrldetect(rx_kchar_20),
            .alt_errdetect(rx_char_err_gx[20]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[20]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[20]),
            .alt_runlengthviolation(rx_runlengthviolation[20]),
            .alt_patterndetect(rx_patterndetect[20]),
            .alt_runningdisp(rx_runningdisp[20]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_20),
            .altpcs_sync(link_status[20]),
            .altpcs_disperr(led_disp_err_20),
            .altpcs_ctrldetect(pcs_rx_kchar_20),
            .altpcs_errdetect(led_char_err_gx[20]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[20]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[20]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[20])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_20.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_20
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[20]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_20),
            .reconfig_togxb(reconfig_togxb_20),
            .reconfig_fromgxb(reconfig_fromgxb_20),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_20),
            .rx_datain (rxp_20),
            .rx_dataout (rx_frame_20),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[20]),
            .rx_errdetect (rx_char_err_gx[20]),
            .rx_patterndetect (rx_patterndetect[20]),
            .rx_rlv (rx_runlengthviolation[20]),
            .rx_seriallpbken (sd_loopback_20),
            .rx_syncstatus (rx_syncstatus[20]),
            .tx_clkout (pcs_clk_c20),
            .tx_ctrlenable (tx_kchar_20),
            .tx_datain (tx_frame_20),
            .tx_dataout (txp_20),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[20]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[20]),
            .rx_runningdisp(rx_runningdisp[20])
          );
   defparam
        the_altera_tse_gxb_gige_inst_20.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_20.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 80,
        the_altera_tse_gxb_gige_inst_20.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_20 = {17{1'b0}};
    assign led_char_err_gx[20] = 1'b0;
    assign link_status[20] = 1'b0;
    assign led_disp_err_20 = 1'b0;
    assign txp_20 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 21 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 21)
    begin          
        assign gxb_pwrdn_in_sig[21] = gxb_pwrdn_in_21;
        assign pcs_pwrdn_out_21 = pcs_pwrdn_out_sig[21];
    end
else
    begin
        assign gxb_pwrdn_in_sig[21] = pcs_pwrdn_out_sig[21];
    end      
endgenerate


generate if (MAX_CHANNELS > 21)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_21
          (
            .clk(pcs_clk_c21),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_21),
            .alt_sync(rx_syncstatus[21]),
            .alt_disperr(rx_disp_err[21]),
            .alt_ctrldetect(rx_kchar_21),
            .alt_errdetect(rx_char_err_gx[21]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[21]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[21]),
            .alt_runlengthviolation(rx_runlengthviolation[21]),
            .alt_patterndetect(rx_patterndetect[21]),
            .alt_runningdisp(rx_runningdisp[21]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_21),
            .altpcs_sync(link_status[21]),
            .altpcs_disperr(led_disp_err_21),
            .altpcs_ctrldetect(pcs_rx_kchar_21),
            .altpcs_errdetect(led_char_err_gx[21]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[21]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[21]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[21])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_21.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_21
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[21]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_21),
            .reconfig_togxb(reconfig_togxb_21),
            .reconfig_fromgxb(reconfig_fromgxb_21),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_21),
            .rx_datain (rxp_21),
            .rx_dataout (rx_frame_21),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[21]),
            .rx_errdetect (rx_char_err_gx[21]),
            .rx_patterndetect (rx_patterndetect[21]),
            .rx_rlv (rx_runlengthviolation[21]),
            .rx_seriallpbken (sd_loopback_21),
            .rx_syncstatus (rx_syncstatus[21]),
            .tx_clkout (pcs_clk_c21),
            .tx_ctrlenable (tx_kchar_21),
            .tx_datain (tx_frame_21),
            .tx_dataout (txp_21),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[21]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[21]),
            .rx_runningdisp(rx_runningdisp[21])
          );
   defparam
        the_altera_tse_gxb_gige_inst_21.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_21.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 84,
        the_altera_tse_gxb_gige_inst_21.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_21 = {17{1'b0}};
    assign led_char_err_gx[21] = 1'b0;
    assign link_status[21] = 1'b0;
    assign led_disp_err_21 = 1'b0;
    assign txp_21 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 22 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 22)
    begin          
        assign gxb_pwrdn_in_sig[22] = gxb_pwrdn_in_22;
        assign pcs_pwrdn_out_22 = pcs_pwrdn_out_sig[22];
    end
else
    begin
        assign gxb_pwrdn_in_sig[22] = pcs_pwrdn_out_sig[22];
    end      
endgenerate


generate if (MAX_CHANNELS > 22)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_22
          (
            .clk(pcs_clk_c22),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_22),
            .alt_sync(rx_syncstatus[22]),
            .alt_disperr(rx_disp_err[22]),
            .alt_ctrldetect(rx_kchar_22),
            .alt_errdetect(rx_char_err_gx[22]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[22]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[22]),
            .alt_runlengthviolation(rx_runlengthviolation[22]),
            .alt_patterndetect(rx_patterndetect[22]),
            .alt_runningdisp(rx_runningdisp[22]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_22),
            .altpcs_sync(link_status[22]),
            .altpcs_disperr(led_disp_err_22),
            .altpcs_ctrldetect(pcs_rx_kchar_22),
            .altpcs_errdetect(led_char_err_gx[22]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[22]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[22]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[22])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_22.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_22
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[22]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_22),
            .reconfig_togxb(reconfig_togxb_22),
            .reconfig_fromgxb(reconfig_fromgxb_22),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_22),
            .rx_datain (rxp_22),
            .rx_dataout (rx_frame_22),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[22]),
            .rx_errdetect (rx_char_err_gx[22]),
            .rx_patterndetect (rx_patterndetect[22]),
            .rx_rlv (rx_runlengthviolation[22]),
            .rx_seriallpbken (sd_loopback_22),
            .rx_syncstatus (rx_syncstatus[22]),
            .tx_clkout (pcs_clk_c22),
            .tx_ctrlenable (tx_kchar_22),
            .tx_datain (tx_frame_22),
            .tx_dataout (txp_22),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[22]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[22]),
            .rx_runningdisp(rx_runningdisp[22])
          );
   defparam
        the_altera_tse_gxb_gige_inst_22.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_22.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 88,
        the_altera_tse_gxb_gige_inst_22.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_22 = {17{1'b0}};
    assign led_char_err_gx[22] = 1'b0;
    assign link_status[22] = 1'b0;
    assign led_disp_err_22 = 1'b0;
    assign txp_22 = 1'b0;
    end      
endgenerate



// #######################################################################
// ###############       CHANNEL 23 LOGIC/COMPONENTS       ###############
// #######################################################################

// Export powerdown signal or wire it internally
// ---------------------------------------------
generate if (EXPORT_PWRDN == 1 && MAX_CHANNELS > 23)
    begin          
        assign gxb_pwrdn_in_sig[23] = gxb_pwrdn_in_23;
        assign pcs_pwrdn_out_23 = pcs_pwrdn_out_sig[23];
    end
else
    begin
        assign gxb_pwrdn_in_sig[23] = pcs_pwrdn_out_sig[23];
    end      
endgenerate


generate if (MAX_CHANNELS > 23)
    begin  
    // Instantiation of the Alt2gxb and Alt4gxb block as the PMA for Stratix_II_GX ,ArriaGX and Stratix IV devices
    // ----------------------------------------------------------------------------------- 
    

        // Aligned Rx_sync from gxb
        // -------------------------------
        altera_tse_gxb_aligned_rxsync the_altera_tse_gxb_aligned_rxsync_23
          (
            .clk(pcs_clk_c23),
            .reset(MAC_PCS_reset),
            //input (from alt2gxb)
            .alt_dataout(rx_frame_23),
            .alt_sync(rx_syncstatus[23]),
            .alt_disperr(rx_disp_err[23]),
            .alt_ctrldetect(rx_kchar_23),
            .alt_errdetect(rx_char_err_gx[23]),
            .alt_rmfifodatadeleted(rx_rmfifodatadeleted[23]),
            .alt_rmfifodatainserted(rx_rmfifodatainserted[23]),
            .alt_runlengthviolation(rx_runlengthviolation[23]),
            .alt_patterndetect(rx_patterndetect[23]),
            .alt_runningdisp(rx_runningdisp[23]),
    
            //output (to PCS)
            .altpcs_dataout(pcs_rx_frame_23),
            .altpcs_sync(link_status[23]),
            .altpcs_disperr(led_disp_err_23),
            .altpcs_ctrldetect(pcs_rx_kchar_23),
            .altpcs_errdetect(led_char_err_gx[23]),
            .altpcs_rmfifodatadeleted(pcs_rx_rmfifodatadeleted[23]),
            .altpcs_rmfifodatainserted(pcs_rx_rmfifodatainserted[23]),
            .altpcs_carrierdetect(pcs_rx_carrierdetected[23])
           ) ;
		defparam
		the_altera_tse_gxb_aligned_rxsync_23.DEVICE_FAMILY = DEVICE_FAMILY;    

        // Altgxb in GIGE mode
        // --------------------
        altera_tse_gxb_gige_inst the_altera_tse_gxb_gige_inst_23
          (
            .cal_blk_clk (gxb_cal_blk_clk),
            .gxb_powerdown (gxb_pwrdn_in_sig[23]),
            .pll_inclk (ref_clk),
            .reconfig_clk(reconfig_clk_23),
            .reconfig_togxb(reconfig_togxb_23),
            .reconfig_fromgxb(reconfig_fromgxb_23),              
            .rx_analogreset (reset),
            .rx_cruclk (ref_clk),
            .rx_ctrldetect (rx_kchar_23),
            .rx_datain (rxp_23),
            .rx_dataout (rx_frame_23),
            .rx_digitalreset (pma_digital_rst2),
            .rx_disperr (rx_disp_err[23]),
            .rx_errdetect (rx_char_err_gx[23]),
            .rx_patterndetect (rx_patterndetect[23]),
            .rx_rlv (rx_runlengthviolation[23]),
            .rx_seriallpbken (sd_loopback_23),
            .rx_syncstatus (rx_syncstatus[23]),
            .tx_clkout (pcs_clk_c23),
            .tx_ctrlenable (tx_kchar_23),
            .tx_datain (tx_frame_23),
            .tx_dataout (txp_23),
            .tx_digitalreset (pma_digital_rst2),
            .rx_rmfifodatadeleted(rx_rmfifodatadeleted[23]),
            .rx_rmfifodatainserted(rx_rmfifodatainserted[23]),
            .rx_runningdisp(rx_runningdisp[23])
          );
   defparam
        the_altera_tse_gxb_gige_inst_23.ENABLE_ALT_RECONFIG = ENABLE_ALT_RECONFIG,
        the_altera_tse_gxb_gige_inst_23.STARTING_CHANNEL_NUMBER = STARTING_CHANNEL_NUMBER + 92,
        the_altera_tse_gxb_gige_inst_23.DEVICE_FAMILY = DEVICE_FAMILY; 
    end
else
    begin
    assign reconfig_fromgxb_23 = {17{1'b0}};
    assign led_char_err_gx[23] = 1'b0;
    assign link_status[23] = 1'b0;
    assign led_disp_err_23 = 1'b0;
    assign txp_23 = 1'b0; 
    end      
endgenerate


endmodule // module altera_tse_multi_mac_pcs_pma_gige