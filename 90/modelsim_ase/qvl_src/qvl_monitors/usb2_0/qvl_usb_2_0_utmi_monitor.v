//              Copyright 2006-2007 Mentor Graphics Corporation
//                           All Rights Reserved.
//
//              THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY
//            INFORMATION WHICH IS THE PROPERTY OF MENTOR GRAPHICS
//           CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE
//                                  TERMS.
//
//                   Questa Verification Library (QVL)
//
/*************************************************************************
*
* PURPOSE     This file is part of Questa Verification Library (QVL).
*
* DESCRIPTION This monitor checks the USB 2.0 UTMI interface for compliance 
*             with UTMI specification and USB 2.0 specification and protocol.
*
* REFERENCES  Universal Serial Bus Specification, Revision 2.0, April 27,
*             2000.
*             Errata for USB 2.0 specification, May 28, 2002.
*             Errata for USB 2.0 specification, December 7, 2000.
*             USB 2.0 Transceiver Macrocell Interface Specification, 
*             Revision 1.05, Mar 29, 2001.
*
* INPUTS      clock                   - Clock.
*             reset                   - Synchronous reset, active high.
*             areset                  - Asynchronous reset, active high.
*
*             tx_valid                - Transmit data valid signal.
*             tx_valid_h              - Transmit data valid high signal.
*             tx_ready                - Transmit data ready signal.
*             data_in_low             - 8-Bit parallel USB data input.
*             data_in_high            - 8-Bit parallel USB data input. This
*                                       bus carries the high order byte
*
*             rx_valid                - Receive data valid signal.
*             rx_valid_h              - Receive data valid high signal.
*             data_out_low            - 8-Bit parallel USB data output.
*             data_out_high           - 8-Bit parallel USB data output. This
*                                       bus carries the high order byte.
*             rx_active               - Receive active signal
*             rx_error                - Receive error signal
*             
*             databus16_8             - Selects between 8 bit or 16 bit.
*             line_state              - Signal which reflects current state
*                                       of the USB bus.
*             xcvr_select             - Selects between FS/HS transceivers.
*             term_select             - Selects between FS/HS terminations.
*             address                 - Device address.
*             end_point_config        - End point configuration input.
*
*             // Signals to support Bi-Directional interfaces.
*     
*             data_low                - 8-Bit parallel USB input and output.
*             data_high               - 8-Bit parallel USB input and output.
*             valid_h                 - Valid high signal.
*
* NOTES
*
*        1. Bidirectional signals are required if the UTMI is bidirectional.
*
*        2. If the UTMI interface is 8 bit, then signals/ports related to 
*           16 bit interface need not be hooked up.
*
*
* MONITOR INSTANTIATION
*
*
*  Monitor is instantiated in the Host to track the transactions of the
*  downstream port of the host(Downstream port of root hub).
*
*       +----------------+                          +-----------------+
*       |                |                          |                 |  
*       | +-----------+  |                          |                 |  
*       | | Monitor   |  |                          |                 |  
*       | +-----------+  |     USB Bus              |     HUB or      |  
*       |                |<------------------------>|                 |  
*       |  HOST          |    Full speed or         |     FUNCTION    |
*       |                |    High speed            |                 |  
*       |                |                          |                 |  
*       |                |                          |                 |  
*       |                |                          |                 |  
*       +----------------+                          +-----------------+
*
*  Monitor is instantiated in the Device to track the transactions of the
*  upstream port of the Device. (Device can be Hub or Function)
*
*       +----------------+                          +-----------------+
*       |                |                          |                 |  
*       |                |                          | +-------------+ |
*       |                |                          | | Monitor     | |
*       |                |      USB Bus             | +-------------+ |
*       |                |<------------------------>|     HUB or      |  
*       |                |      Full speed or       |                 |  
*       |  HOST          |      High speed          |    FUNCTION     |  
*       |                |                          |                 |  
*       |                |                          |                 |  
*       |                |                          |                 |  
*       +----------------+                          +-----------------+
*
*  Monitor is instantiated in the Hub to track the transactions of the
*  downstream port of the Hub.
*
*        +----------------+                          +-----------------+
*        |                |                          |                 | 
*        | +-----------+  |                          |                 | 
*        | | Monitor   |  |                          |                 | 
*        | +-----------+  |     USB Bus              |     HUB or      | 
*        |                |<------------------------>|                 | 
*        |  HUB           |   Full or Low speed or   |   FUNCTION      | 
*        |                |      High speed          |                 | 
*        |                |                          |                 | 
*        |                |                          |                 | 
*        |                |                          |                 | 
*        +----------------+                          +-----------------+
*
*
***************************************************************************/

`include "std_qvl_defines.h"

`qvlmodule qvl_usb_2_0_utmi_monitor (
                                   clock,
                                   reset,
                                   areset,
                              
                                   // Transmit Interface

                                   tx_valid,
                                   data_in_low,
                                   tx_valid_h,
                                   data_in_high,
                                   tx_ready,

                                   // Receive Interface

                                   rx_valid,
                                   data_out_low,
                                   rx_valid_h,
                                   data_out_high,
                                   rx_active,
                                   rx_error,

                                   // Control interface

                                   databus16_8,
                                   line_state, 
                                   xcvr_select,
                                   term_select,
                                   op_mode,

                                   // Bi directional 

                                   data_low,
                                   data_high,
                                   valid_h,

                                   // Configuration inputs
 
                                   address,
                                   end_point_config
                                   );

  // Parameter Constraints_Mode = 1 will configure some checks in this 
  // monitor as constraints during 0-In Search.

  parameter Constraints_Mode = 0; 
  wire [31:0] pw_Constraints_Mode = Constraints_Mode;

  // Parameter PORT_TYPE configures the port type which will be tracked by
  // the monitor. PORT_TYPE = 0 configures the monitor to track the
  // transactions of the downstream port of the Host. PORT_TYPE = 1
  // configures the monitor to track the transactions of the upstream port
  // of Hub. PORT_TYPE = 2 configures the monitor to track the transactions
  // of the downstream port of Hub. PORT_TYPE = 3 configures the monitor to
  // track transactions of upstream port of a function. This information,
  // along with the value of parameter Constraints_Mode will decide the checks
  // to be turned into constraints during 0-In Search.

  parameter PORT_TYPE = 0;                             
  wire [31:0] pw_PORT_TYPE = PORT_TYPE;

  // Parameter UTMI_SIDE indicates on which side of the interface, monitor
  // is instantiated. By default monitor is assumed to be instantiated on
  // the SIE side of the interface. 

  parameter UTMI_SIDE = 0;
  wire [31:0] pw_UTMI_SIDE = UTMI_SIDE;

  // Parameter BI_DIRECTIONAL configures the monitor to track the
  // UTMI interface.

  parameter BI_DIRECTIONAL = 0;
  wire [31:0] pw_BI_DIRECTIONAL = BI_DIRECTIONAL;

  // Parameter DEVICE_SPEED configures the monitor for FS/HS, FS only, LS only
  // mode of operation. Set this parameter to 1 if the UTM is FS only, Set this
  // parameter to 2 if the UTM is LS only. By default, monitor is configured to
  // track FS/HS interface.

  parameter DEVICE_SPEED = 0;
  wire [31:0] pw_DEVICE_SPEED = DEVICE_SPEED;

  // Parameter NUMBER_OF_ENDPOINTS configures the number of end points
  // to be tracked by the monitor. By default, monitor is configured
  // to track only one end point.

  parameter NUMBER_OF_ENDPOINTS = 1;
  wire [31:0] pw_NUMBER_OF_ENDPOINTS = NUMBER_OF_ENDPOINTS;
 
  // Parameter FRAME_INTERVAL_COUNT indicates the number of clock cycles
  // between two successive SOF packets (USB specification specifies
  // an interval of 1ms between frames. This time duration needs to be mapped
  // into number of clock cycles).

  parameter FRAME_INTERVAL_COUNT = 7500;
  wire [31:0] pw_FRAME_INTERVAL_COUNT = FRAME_INTERVAL_COUNT;

  // Parameter SEQUENCE_BIT_TRACKING_ENABLE configures the monitor to
  // track data toggle synchronization.

  parameter SEQUENCE_BIT_TRACKING_ENABLE = 1;
  wire [31:0] pw_SEQUENCE_BIT_TRACKING_ENABLE = SEQUENCE_BIT_TRACKING_ENABLE;
 
  // Parameter PACKET_ISSUE_CHECK_ENABLE configures the monitor to fire
  // for illegal issue of token, requests. By default monitor fires
  // for above mentioned conditions. Example : If IN token is issued
  // to OUT only end point then monitor check fires when this parameter
  // is set to 1. Similarly if undefined requests other than standard
  // requests, device class requests are issued then monitor checks
  // fire when this parameter is set to 1.
 
  parameter PACKET_ISSUE_CHECK_ENABLE = 1;
  wire [31:0] pw_PACKET_ISSUE_CHECK_ENABLE = PACKET_ISSUE_CHECK_ENABLE;

  // parameter RX_ACTIVE_DEASSERT_TO_TX_VALID_ASSERT_DELAY configures the
  // delay between the deassertion of the RxActive and assertion of TxValid
  // assertion

  parameter RX_ACTIVE_DEASSERT_TO_TX_VALID_ASSERT_DELAY_MIN = 5;
  wire [31:0] pw_RX_ACTIVE_DEASSERT_TO_TX_VALID_ASSERT_DELAY_MIN = 
                       RX_ACTIVE_DEASSERT_TO_TX_VALID_ASSERT_DELAY_MIN;

  parameter RX_ACTIVE_DEASSERT_TO_TX_VALID_ASSERT_DELAY_MAX = 24;
  wire [31:0] pw_RX_ACTIVE_DEASSERT_TO_TX_VALID_ASSERT_DELAY_MAX = 
                       RX_ACTIVE_DEASSERT_TO_TX_VALID_ASSERT_DELAY_MAX;

  // parameter TX_VALID_DEASSERT_TO_RX_ACTIVE_ASSERT_DELAY configures the
  // delay between the deassertion of the TxValid and assertion of
  // RxActive.

  parameter TX_VALID_DEASSERT_TO_RX_ACTIVE_ASSERT_DELAY_MIN = 6;
  wire [31:0] pw_TX_VALID_DEASSERT_TO_RX_ACTIVE_ASSERT_DELAY_MIN = 
                   TX_VALID_DEASSERT_TO_RX_ACTIVE_ASSERT_DELAY_MIN;

  parameter TX_VALID_DEASSERT_TO_RX_ACTIVE_ASSERT_DELAY_MAX = 37;
  wire [31:0] pw_TX_VALID_DEASSERT_TO_RX_ACTIVE_ASSERT_DELAY_MAX = 
                   TX_VALID_DEASSERT_TO_RX_ACTIVE_ASSERT_DELAY_MAX;

  // Parameter TIME_OUT_COUNT configures the number of clk cycles
  // after which device or host is required to time out.

  parameter TIME_OUT_COUNT = 800;
  wire [31:0] pw_TIME_OUT_COUNT = TIME_OUT_COUNT;

  // Parameter OTG_DEVICE configures the monitor to track OTG compliant
  // USB devices. By default, non OTG compliant devices are tracked.

  parameter OTG_DEVICE = 0;
  wire [31:0] pw_OTG_DEVICE = OTG_DEVICE;

  // Parameter HUB_TURNAR_TIMEOUT_16BIT configures the monitor to track 
  // the turn around timeout period in case databus16_8 is set for 16 bit
  
  parameter HUB_TURNAR_TIMEOUT_16BIT = 45000;
  wire [12:0] pw_HUB_TURNAR_TIMEOUT_16BIT = HUB_TURNAR_TIMEOUT_16BIT; 

  // Parameter HUB_TURNAR_TIMEOUT_8BIT configures the monitor to track 
  // the turn around timeout period in case databus16_8 is set for 8 bit
  
  parameter HUB_TURNAR_TIMEOUT_8BIT = 90000;
  wire [12:0] pw_HUB_TURNAR_TIMEOUT_8BIT = HUB_TURNAR_TIMEOUT_8BIT; 

  // Parameter HUB_CHIRP_TIMEOUT_16BIT configures the monitor to track
  // the timeout period for a K or J chirp in 16 bit mode
  
  parameter HUB_CHIRP_TIMEOUT_16BIT = 1800;
  wire [11:0] pw_HUB_CHIRP_TIMEOUT_16BIT = HUB_CHIRP_TIMEOUT_16BIT;	

  // Parameter HUB_CHIRP_TIMEOUT_8BIT configures the monitor to track
  // the timeout period for a K or J chirp in 8 bit mode
  
  parameter HUB_CHIRP_TIMEOUT_8BIT = 3600;
  wire [11:0] pw_HUB_CHIRP_TIMEOUT_8BIT = HUB_CHIRP_TIMEOUT_8BIT;	
  
  // Parameter TERM_SEL_DEASS_AFTER_HS_DETECT_TIMEOUT_8BIT configures the 
  // monitor to timeout when term_select signal does not deassert till 
  // 500 us after HS has been detected.

  parameter TERM_SEL_DEASS_AFTER_HS_DETECT_TIMEOUT_8BIT = 30000; 
  wire [14:0] pw_TERM_SEL_DEASS_AFTER_HS_DETECT_TIMEOUT_8BIT = 
                 TERM_SEL_DEASS_AFTER_HS_DETECT_TIMEOUT_8BIT;	

  // Parameter TERM_SEL_DEASS_AFTER_HS_DETECT_TIMEOUT_16BIT configures the 
  // monitor to timeout when term_select signal does not deassert till 
  // 500 us after HS has been detected.

  parameter TERM_SEL_DEASS_AFTER_HS_DETECT_TIMEOUT_16BIT = 15000; 
  wire [14:0] pw_TERM_SEL_DEASS_AFTER_HS_DETECT_TIMEOUT_16BIT = 
                 TERM_SEL_DEASS_AFTER_HS_DETECT_TIMEOUT_16BIT;	

  // Parameters related to Inter PAcket delay, Max PAcket Size.

  // Input port declarations.

  input clock; // Active on the rising edge only.
  input reset; // Active high. 
  input areset; // Active high.

  input tx_valid; // Transmit data 'data_in_low' is valid.
  input [7:0] data_in_low; 

  input tx_valid_h; // Transmit data 'data_in_high' is valid.
  input [7:0] data_in_high;
 
  input tx_ready; // Transmit ready signal

  input rx_valid; // Receive data 'data_out_low' is valid.
  input [7:0] data_out_low; 

  input rx_valid_h; // Receive data 'data_out_high' is valid.
  input [7:0] data_out_high;
  input rx_active;
  input rx_error;

  input databus16_8; // 1 - 16 bit, 0 - 8 bit interface.
  input [1:0] line_state; // Line status signal.
  input xcvr_select; // Selects between FS and HS transceiver
  input term_select; // Selects between FS and HS termination
  input [1:0] op_mode; // Selects between normal and disable NRZI and bit stuffing 

  input [7:0] data_low; // Bidirectional data
  input [7:0] data_high; // Bidirectional data
  input valid_h; // 'data_high' is valid.

  input [6:0] address; // Address of the device.
  input [NUMBER_OF_ENDPOINTS * 21 - 1:0] end_point_config; // End point info.

  parameter MAC_LAYER_CONSTRAINT = (UTMI_SIDE == 0 && Constraints_Mode);
  parameter PHY_LAYER_CONSTRAINT = (UTMI_SIDE == 1 && Constraints_Mode);

  // Input port declarations.

  wire reset_sampled; 
  wire areset_sampled; 
  wire tx_valid_sampled; 
  wire [7:0] data_in_low_sampled; 
  wire tx_valid_h_sampled;
  wire [7:0] data_in_high_sampled;
  wire tx_ready_sampled; 
  wire rx_valid_sampled;
  wire [7:0] data_out_low_sampled; 
  wire rx_valid_h_sampled;
  wire [7:0] data_out_high_sampled;
  wire rx_active_sampled;
  wire rx_error_sampled;
  wire databus16_8_sampled;
  wire [1:0] line_state_sampled;
  wire xcvr_select_sampled;
  wire term_select_sampled;
  wire [1:0] op_mode_sampled;
  wire [7:0] data_low_sampled;
  wire [7:0] data_high_sampled;
  wire valid_h_sampled;
  wire [6:0] address_sampled;
  wire [NUMBER_OF_ENDPOINTS * 21 - 1:0] end_point_config_sampled;

  // Assignments

  assign `QVL_DUT2CHX_DELAY reset_sampled            = reset;
  assign `QVL_DUT2CHX_DELAY areset_sampled           = areset;
  assign `QVL_DUT2CHX_DELAY tx_valid_sampled         = tx_valid;
  assign `QVL_DUT2CHX_DELAY data_in_low_sampled      = data_in_low;
  assign `QVL_DUT2CHX_DELAY tx_valid_h_sampled       = tx_valid_h;
  assign `QVL_DUT2CHX_DELAY data_in_high_sampled     = data_in_high;
  assign `QVL_DUT2CHX_DELAY tx_ready_sampled         = tx_ready;
  assign `QVL_DUT2CHX_DELAY rx_valid_sampled         = rx_valid;
  assign `QVL_DUT2CHX_DELAY data_out_low_sampled     = data_out_low;
  assign `QVL_DUT2CHX_DELAY rx_valid_h_sampled       = rx_valid_h;
  assign `QVL_DUT2CHX_DELAY data_out_high_sampled    = data_out_high;
  assign `QVL_DUT2CHX_DELAY rx_active_sampled        = rx_active;
  assign `QVL_DUT2CHX_DELAY rx_error_sampled         = rx_error;
  assign `QVL_DUT2CHX_DELAY databus16_8_sampled      = databus16_8;
  assign `QVL_DUT2CHX_DELAY line_state_sampled       = line_state;
  assign `QVL_DUT2CHX_DELAY xcvr_select_sampled      = xcvr_select;
  assign `QVL_DUT2CHX_DELAY op_mode_sampled          = op_mode;
  assign `QVL_DUT2CHX_DELAY term_select_sampled      = term_select;
  assign `QVL_DUT2CHX_DELAY data_low_sampled         = data_low;
  assign `QVL_DUT2CHX_DELAY data_high_sampled        = data_high;
  assign `QVL_DUT2CHX_DELAY valid_h_sampled          = valid_h;
  assign `QVL_DUT2CHX_DELAY address_sampled          = address;
  assign `QVL_DUT2CHX_DELAY end_point_config_sampled = end_point_config;

  qvl_usb_2_0_utmi_logic        #(
                                  .Constraints_Mode (Constraints_Mode),
                                  .PORT_TYPE (PORT_TYPE),
                                  .UTMI_SIDE (UTMI_SIDE),
                                  .BI_DIRECTIONAL (BI_DIRECTIONAL),
                                  .DEVICE_SPEED (DEVICE_SPEED),
                                  .NUMBER_OF_ENDPOINTS (NUMBER_OF_ENDPOINTS),
                                  .FRAME_INTERVAL_COUNT (FRAME_INTERVAL_COUNT),
                                  .SEQUENCE_BIT_TRACKING_ENABLE (SEQUENCE_BIT_TRACKING_ENABLE),
                                  .PACKET_ISSUE_CHECK_ENABLE (PACKET_ISSUE_CHECK_ENABLE),
                                  .RX_ACTIVE_DEASSERT_TO_TX_VALID_ASSERT_DELAY_MIN (RX_ACTIVE_DEASSERT_TO_TX_VALID_ASSERT_DELAY_MIN),
                                  .RX_ACTIVE_DEASSERT_TO_TX_VALID_ASSERT_DELAY_MAX (RX_ACTIVE_DEASSERT_TO_TX_VALID_ASSERT_DELAY_MAX),
                                  .TX_VALID_DEASSERT_TO_RX_ACTIVE_ASSERT_DELAY_MIN (TX_VALID_DEASSERT_TO_RX_ACTIVE_ASSERT_DELAY_MIN),
                                  .TX_VALID_DEASSERT_TO_RX_ACTIVE_ASSERT_DELAY_MAX (TX_VALID_DEASSERT_TO_RX_ACTIVE_ASSERT_DELAY_MAX),
                                  .TIME_OUT_COUNT (TIME_OUT_COUNT),
                                  .OTG_DEVICE (OTG_DEVICE)
                                  )
  qvl_usb_2_0_utmi (
	           .clock            (clock),
                   .reset            (reset_sampled),
                   .areset           (areset_sampled),
                   .tx_valid         (tx_valid_sampled),
                   .data_in_low      (data_in_low_sampled),
                   .tx_valid_h       (tx_valid_h_sampled),
                   .data_in_high     (data_in_high_sampled),
                   .tx_ready         (tx_ready_sampled),
                   .rx_valid         (rx_valid_sampled),
                   .data_out_low     (data_out_low_sampled),
                   .rx_valid_h       (rx_valid_h_sampled),
                   .data_out_high    (data_out_high_sampled),
                   .rx_active        (rx_active_sampled),
                   .rx_error         (rx_error_sampled),
                   .databus16_8      (databus16_8_sampled),
                   .line_state       (line_state_sampled),
                   .xcvr_select      (xcvr_select_sampled),
                   .term_select      (term_select_sampled),
                   .op_mode          (op_mode_sampled),
                   .data_low         (data_low_sampled),
                   .data_high        (data_high_sampled),
                   .valid_h          (valid_h_sampled),
                   .address          (address_sampled),
                   .end_point_config (end_point_config_sampled)
                   );

`qvlendmodule


