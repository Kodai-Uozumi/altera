//              Copyright 2006-2007 Mentor Graphics Corporation          
//                           All Rights Reserved.                           
//                                                                          
//              THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY             
//            INFORMATION WHICH IS THE PROPERTY OF MENTOR GRAPHICS          
//           CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE         
//                                  TERMS.                                  
//                                                                          
//
/***********************************************************************
 * PURPOSE       This file is part of the 0-In CheckerWare.
 *               It describes the Ethernet MII Monitor.
 *
 * DESCRIPTION   This monitor checks the 100 Mbps Etherent frames for
 *               alignment related violations and malformed packets by 
 *               observing the MII (100 Mbps Media Independent I/F).
 *               This module internally instantiates two link monitors,
 *               one each for the Tx link and the Rx link respectively. 
 *               
 * REFERENCE     802.3 IEEE Standard for Information Technology, CSMA/CD
 *               access method and physical layer specifications, 2002
 *
 * INPUTS        areset - asynchronous reset (active high)
 *               reset  - synchronous reset (active high)
 *               tx_clk - transmit interface clock
 *               txd    - transmit data (4-bit SDR)
 *               tx_en  - transmit enable 
 *               tx_er  - transmit error
 *               rx_clk - receive interface clock
 *               rxd    - receive data (4-bit SDR)
 *               rx_dv  - receive data valid
 *               rx_er  - receive error
 *               col    - collision detect
 *               crs    - carrier sense
 *
 *
 * MONITOR INSTANTIATION
 *                  
 *                                  + +
 *                                  | |
 *                                  | |
 *                  +---------------+-+----------------+
 *                  |    LLC - Logical Link Control    |
 *                  +----------------------------------+
 *                  |      MAC Control (optional)      |  L
 *                  +----------------------------------+  I
 *                  |    MAC - Media Access Control    |  N
 *                  +----------------------------------+  K
 *                  |   RS - Reconciliation Sublayer   |
 *                  |                                  |  L
 *                  |        +---------------+         |  A
 *                  |        |  MII MONITOR  |         |  Y
 *                  |        +------+-+------+         |  E
 *                  |               | |                |  R
 *                  +---------------+-+----------------+
 *                                  | |
 *                                  | | MII
 *                                  | |
 *                  +---------------+-+----------------+  P
 *                  |               | |                |  H
 *                  |        +------+-+------+         |  Y
 *                  |        |  MII MONITOR  |         | 
 *                  |        +---------------+         |  L
 *                  |                                  |  A
 *                  |  PCS - Physical Coding Sublayer  |  Y
 *                  +----------------------------------+  E
 *                  | PMA - Physical Medium Attachment |  R
 *                  +---------------+-+----------------+
 *                                  | |
 *                                  | |
 *                                  + +
 *
 *
 * LAST MODIFIED 10 October 2005
 *
 *********************************************************************/
`include "std_qvl_defines.h"
`qvlmodule qvl_gigabit_ethernet_mii_monitor (areset,
                                             reset,
                                             tx_clk,
                                             txd,
                                             tx_en,
                                             tx_er,
                                             rx_clk,
                                             rxd,
                                             rx_dv,
                                             rx_er,
                                             col,
                                             crs
                                            );

  // Parameter Constraints_Mode = 0, will configure some checks in this
  // monitor as constraints during formal analysis.

  parameter Constraints_Mode = 0;
  wire [31:0] pw_Constraints_Mode = Constraints_Mode;

  // Parameter MAC_SIDE = 1, will indicate as to which side of the  MII link
  // the monitor is instantiated. This parameter, along with the Constraints
  // Mode parameter is used in constraining the correct side in case of the
  // formal analysis.

  parameter MAC_SIDE = 1;
  wire [31:0] pw_MAC_SIDE = MAC_SIDE;

  // Set this parameter to the desired length of Jumbo frames. The default
  // length of Jumbo frames is taken to be 9K bytes (9126 bytes).

  parameter JUMBO_FRAME_DATA_LENGTH = 9126;
  wire [31:0] pw_JUMBO_FRAME_DATA_LENGTH = JUMBO_FRAME_DATA_LENGTH;

  // Set this parameter to 0 to disable checking for usage of reserved 
  // values in fields. By default, these checks will be performed.

  parameter RESERVED_VALUE_CHECK_ENABLE = 1;
  wire [31:0] pw_RESERVED_VALUE_CHECK_ENABLE = RESERVED_VALUE_CHECK_ENABLE;

  // Set this parameter to 1 if the monitor is instantiated on a Half 
  // Duplex link. The default value of 1 indicates that the monitor is 
  // instantiated on a full duplex interface.

  parameter HALF_DUPLEX = 0;
  wire [31:0] pw_HALF_DUPLEX = HALF_DUPLEX;

  parameter ZI_CONSTRAINT_MAC_SIDE = (Constraints_Mode == 1 &&
				      MAC_SIDE == 1);
  parameter ZI_CONSTRAINT_PHY_SIDE = (Constraints_Mode == 1 &&
				      MAC_SIDE == 0);

  input areset;
  input reset;
  input tx_clk;
  input [3:0] txd;
  input tx_en;
  input tx_er;
  input rx_clk;
  input [3:0] rxd;
  input rx_dv;
  input rx_er;
  input col;
  input crs;

  wire areset_sampled;
  wire reset_sampled;
  wire [3:0] txd_sampled;
  wire tx_en_sampled;
  wire tx_er_sampled;
  wire [3:0] rxd_sampled;
  wire rx_dv_sampled;
  wire rx_er_sampled;
  wire col_sampled;
  wire crs_sampled;

 
   assign `QVL_DUT2CHX_DELAY areset_sampled = areset;
   assign `QVL_DUT2CHX_DELAY reset_sampled = reset;
   assign `QVL_DUT2CHX_DELAY txd_sampled = txd;
   assign `QVL_DUT2CHX_DELAY tx_en_sampled = tx_en;
   assign `QVL_DUT2CHX_DELAY tx_er_sampled = tx_er;
   assign `QVL_DUT2CHX_DELAY rxd_sampled = rxd;
   assign `QVL_DUT2CHX_DELAY rx_dv_sampled = rx_dv;
   assign `QVL_DUT2CHX_DELAY rx_er_sampled = rx_er;
   assign `QVL_DUT2CHX_DELAY col_sampled = col;
   assign `QVL_DUT2CHX_DELAY crs_sampled = crs;

   qvl_gigabit_ethernet_mii_logic
     #(.Constraints_Mode(Constraints_Mode),
      .MAC_SIDE(MAC_SIDE),
      .JUMBO_FRAME_DATA_LENGTH(JUMBO_FRAME_DATA_LENGTH),
      .RESERVED_VALUE_CHECK_ENABLE(RESERVED_VALUE_CHECK_ENABLE),
      .HALF_DUPLEX(HALF_DUPLEX),
      .ZI_CONSTRAINT_MAC_SIDE(ZI_CONSTRAINT_MAC_SIDE),
      .ZI_CONSTRAINT_PHY_SIDE(ZI_CONSTRAINT_PHY_SIDE)
      )
   qvl_gigabit_ethernet_mii(.tx_clk(tx_clk),
                             .rx_clk(rx_clk),
                             .areset(areset_sampled),
                             .reset(reset_sampled),
                             .txd(txd_sampled),
                             .tx_en(tx_en_sampled),
                             .tx_er(tx_er_sampled),
                             .rxd(rxd_sampled),
                             .rx_dv(rx_dv_sampled),
                             .rx_er(rx_er_sampled),
                             .col(col_sampled),
                             .crs(crs_sampled)
                           );

`qvlendmodule // qvl_gigabit_ethernet_mii_monitor
