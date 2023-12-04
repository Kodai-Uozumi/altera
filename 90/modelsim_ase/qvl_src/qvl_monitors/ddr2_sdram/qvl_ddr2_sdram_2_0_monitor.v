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
 * PURPOSE      This file is part of 0-In CheckerWare.
 *              It describes the DDR2 SDRAM monitor.
 *
 * REFERENCE    JESD79-2 DDR2 SDRAM Specification,
 *              JEDEC Solid State Technology Association, September 2003
 *
 * DESCRIPTION  This monitor checks if the DDR2 SDRAM memory interface 
 *              functions properly.
 *
 * INPUTS       areset       - Asynchronous reset.
 *              reset        - Synchronous reset.
 *              ck           - Input differential clock.
 *              ck_n         - Input differential clock.
 *              cke          - Clock Enable. 
 *              cs_n         - Chip Select. 
 *              ras_n        - Row Address Strobe.   
 *              cas_n        - Column Address Strobe. 
 *              we_n         - Write Enable. 
 *              dm_rdqs      - Data Mask / Read data strobe (only in x8 mode).
 *              ba           - Bank Address.
 *              a            - Address bus. 
 *              dq           - Data bus - {D7:D0} - used for x4 and x8 modes.
 *              dqs          - Data Strobe for port "dq".
 *              ldqs         - Data Strobe for port "ldq".
 *              ldm          - Data Mask for port "ldq".
 *              udqs         - Data Strobe for port "udq".
 *              udm          - Data Mask for port "udq".
 *              mode_register_in - Mode register input.
 *              ex_mode_register_in - Extended mode register input.
 *
 * 
 * USAGE        The monitor should be instantiated as shown below:
 *
 *
 *            +---------------+                          +---------------+
 *            |               |---        ck          -->|               | 
 *            | +-----------+ |---        ck_n        -->|               | 
 *            | |DDR2 SDRAM | |---        cke         -->|  DDR2 SDRAM   | 
 *            | |Monitor    | |---        cs_n        -->|               | 
 *            | +-----------+ |---        ras_n       -->|               | 
 *            |               |---        cas_n       -->|               | 
 *            |               |---        we_n        -->|               | 
 *            | DDR2 SDRAM    |---        dm_rdqs     -->|               | 
 *            | Controller    |---        ba          -->|               | 
 *            |               |---        a           -->|               | 
 *            |               |<--        dq          -->|               | 
 *            |               |<--        dqs         -->|               | 
 *            |               |<--        ldq         -->|               | 
 *            |               |<--        ldqs        -->|               |
 *            |               |<--        ldm         -->|               |
 *            |               |<--        udq         -->|               |
 *            |               |<--        udqs        -->|               |
 *            |               |<--        udm         -->|               |
 *            |               |<-- mode_register_in   -->|               |
 *            |               |<- ex_mode_register_in -->|               |
 *            |               |                          |               |
 *            +---------------+                          +---------------+
 *
 *                                        (OR)
 *
 *            +---------------+                          +---------------+
 *            |               |---        ck          -->|               | 
 *            |               |---        ck_n        -->|               | 
 *            |               |---        cke         -->|  DDR2 SDRAM   | 
 *            |               |---        cs_n        -->|               | 
 *            | DDR2 SDRAM    |---        ras_n       -->|               | 
 *            | Controller    |---        cas_n       -->|               | 
 *            |               |---        we_n        -->|               | 
 *            |               |---        dm_rdqs     -->| +-----------+ |
 *            |               |---        ba          -->| |DDR2 SDRAM | | 
 *            |               |---        a           -->| |Monitor    | |
 *            |               |<--        dq          -->| +-----------+ |
 *            |               |<--        dqs         -->|               | 
 *            |               |<--        ldq         -->|               | 
 *            |               |<--        ldqs        -->|               | 
 *            |               |<--        ldm         -->|               | 
 *            |               |<--        udq         -->|               | 
 *            |               |<--        udqs        -->|               | 
 *            |               |<--        udm         -->|               | 
 *            |               |<-- mode_register_in   -->|               |
 *            |               |<- ex_mode_register_in -->|               |
 *            |               |                          |               |
 *            +---------------+                          +---------------+
 *
 * LAST MODIFIED : 06 April 2006.
 *
 **************************************************************************/

`include "std_qvl_defines.h"


`qvlmodule qvl_ddr2_sdram_2_0_monitor (ck,
				 ck_n,
				 areset,
				 reset,
				 cke,
				 cs_n,
				 ras_n, 
				 cas_n,
				 we_n,
				 dm_rdqs,
				 ba,
				 a,
				 dq,
				 dqs,
				 ldqs,
				 ldm,
				 udqs,
				 udm,
				 mode_register_in,
				 ex_mode_register_in
                                );

  parameter Constraints_Mode = 0; // 0in constraint
  wire [31:0] pw_Constraints_Mode = Constraints_Mode;

  parameter CONTROLLER_SIDE = 1; // 1 implies monitor is instantiated on the
                                 // controller side. else memory side  
  wire [31:0] pw_CONTROLLER_SIDE = CONTROLLER_SIDE;

  parameter ROW_ADDR_WIDTH = 16; // Size of address bus equals row_addr_width
  wire [31:0] pw_ROW_ADDR_WIDTH = ROW_ADDR_WIDTH;

  parameter DATA_BUS_WIDTH = 8; // Width of the Data Bus configuration
  wire [31:0] pw_DATA_BUS_WIDTH = DATA_BUS_WIDTH;

  parameter DLL_TRACKING_ENABLE = 1;
  wire [31:0] pw_DLL_TRACKING_ENABLE = DLL_TRACKING_ENABLE;

  parameter TRAS = 6; // Active to precharge command
  wire [31:0] pw_TRAS = TRAS;

  parameter TRCD = 2; // Active to read/write delay
  wire [31:0] pw_TRCD = TRCD;

  parameter TRP = 2; // Precharge command period
  wire [31:0] pw_TRP = TRP;

  parameter TRRD = 1; // Bank A activate to bank B activate
  wire [31:0] pw_TRRD = TRRD;

  parameter TCCD = 2; // CAS A to CAS B delay
  wire [31:0] pw_TCCD = TCCD;

  parameter TRTW = 4; // Read to write turnaround time
  wire [31:0] pw_TRTW = TRTW;

  parameter TWTR = 1; // Write to read turnaround time
  wire [31:0] pw_TWTR = TWTR;

  parameter TWR = 2; // Write recovery time
  wire [31:0] pw_TWR = TWR;

  parameter TRFC = 9; // Auto-refresh to auto-refresh or activation period
  wire [31:0] pw_TRFC = TRFC;

  parameter TXSNR = 10; // Exit self-refresh to a non-read command delay
  wire [31:0] pw_TXSNR = TXSNR;

  parameter TXSRD = 200; // Exit self-refresh to a read command delay
  wire [31:0] pw_TXSRD = TXSRD;

  parameter TMRD = 2; // Mode register set command cycle time
  wire [31:0] pw_TMRD = TMRD;

  parameter  AUTOPRECHARGE_ENABLE_ADDRESS_BIT = 10;
  wire [31:0] pw_AUTOPRECHARGE_ENABLE_ADDRESS_BIT =
              AUTOPRECHARGE_ENABLE_ADDRESS_BIT;

  //The following parameter is used to enable/disable the
  //read before write checker.

  parameter  READ_BEFORE_WRITE_CHECK_ENABLE = 1;
  wire [31:0] pw_READ_BEFORE_WRITE_CHECK_ENABLE =
              READ_BEFORE_WRITE_CHECK_ENABLE;

  // The following parameters added to verify the power down exit 
  // latencies for non read and read commands
  
  parameter TXP = 2; // Precharge power down to non read command time 
  wire [31:0] pw_TXP = TXP;
  
  parameter TXARD = 2; // Active power down to read command, fast exit 
  wire [31:0] pw_TXARD = TXARD;
 
  // The following parameter defines the width of the bank address
  parameter BANK_ADDR_WIDTH = 3;
  wire [31:0] pw_BANK_ADDR_WIDTH = BANK_ADDR_WIDTH;

  parameter ENABLE_PRECHARGE_TO_IDLE_BANK = 0;
  wire [31:0] pw_ENABLE_PRECHARGE_TO_IDLE_BANK = ENABLE_PRECHARGE_TO_IDLE_BANK;

  parameter BYPASS_INIT = 0;
  wire [31:0] pw_BYPASS_INIT = BYPASS_INIT;

  //The following parameter is used to enable/disable the
  //data checker.
  parameter  DATA_CHECK_ENABLE = 1;
  wire [31:0] pw_DATA_CHECK_ENABLE = DATA_CHECK_ENABLE;

  // Use the following parameter to configure the monitor to support the new 
  // DDR2 SDRAM specification (1.0) of September 2003
  parameter ZI_DDR2_SDRAM_2_0 = 1;
  wire [31:0] pw_DDR2_SDRAM_2_0 = ZI_DDR2_SDRAM_2_0;


  // The following parameter is used to define the width of the DM bus. This 
  // is used only if the monitor is operated in place of the old version, which
  // allows fully configurable data bus width and thereby the data mask bus.
  parameter ZI_DM_WIDTH = 1;
  wire [31:0] pw_DM_WIDTH = ZI_DM_WIDTH;

  // The following parameter defines the width of the dm port, which is used 
  // only if the DM is used as a bus, in case of old version of the monitor.
  parameter ZI_DM_RDQS_WIDTH = (ZI_DDR2_SDRAM_2_0 === 1) ? 1 : ZI_DM_WIDTH;

  parameter ZI_MODE_REG_WIDTH = ROW_ADDR_WIDTH + BANK_ADDR_WIDTH;
 
  input ck;
  input ck_n;
  input areset; 
  input reset;
  input cke;
  input cs_n;
  input ras_n; 
  input cas_n; 
  input we_n;
  input [ZI_DM_RDQS_WIDTH-1:0] dm_rdqs;
  input [BANK_ADDR_WIDTH-1:0] ba;
  input [ROW_ADDR_WIDTH-1:0] a;
  input [DATA_BUS_WIDTH-1:0] dq; 
  input dqs;
  input ldqs;
  input ldm;
  input udqs;
  input udm;
  input [ZI_MODE_REG_WIDTH-1:0] mode_register_in;
  input [ZI_MODE_REG_WIDTH-1:0] ex_mode_register_in;


  wire areset_sampled; 
  wire reset_sampled;
  wire cke_sampled;
  wire cs_n_sampled;
  wire ras_n_sampled; 
  wire cas_n_sampled; 
  wire we_n_sampled;
  wire [ZI_DM_RDQS_WIDTH-1:0] dm_rdqs_sampled;
  wire [BANK_ADDR_WIDTH-1:0] ba_sampled;
  wire [ROW_ADDR_WIDTH-1:0] a_sampled;
  wire [DATA_BUS_WIDTH-1:0] dq_sampled; 
  wire dqs_sampled;
  wire ldqs_sampled;
  wire ldm_sampled;
  wire udqs_sampled;
  wire udm_sampled;
  wire [ZI_MODE_REG_WIDTH-1:0] mode_register_in_sampled;
  wire [ZI_MODE_REG_WIDTH-1:0] ex_mode_register_in_sampled;

  assign `QVL_DUT2CHX_DELAY areset_sampled = areset;  
  assign `QVL_DUT2CHX_DELAY reset_sampled = reset;
  assign `QVL_DUT2CHX_DELAY cke_sampled = cke; 
  assign `QVL_DUT2CHX_DELAY cs_n_sampled = cs_n;
  assign `QVL_DUT2CHX_DELAY ras_n_sampled = ras_n; 
  assign `QVL_DUT2CHX_DELAY cas_n_sampled = cas_n; 
  assign `QVL_DUT2CHX_DELAY we_n_sampled = we_n;
  assign `QVL_DUT2CHX_DELAY dm_rdqs_sampled = dm_rdqs;
  assign `QVL_DUT2CHX_DELAY ba_sampled = ba;
  assign `QVL_DUT2CHX_DELAY a_sampled = a;
  assign `QVL_DUT2CHX_DELAY dq_sampled = dq; 
  assign `QVL_DUT2CHX_DELAY dqs_sampled = dqs;
  assign `QVL_DUT2CHX_DELAY ldqs_sampled = ldqs;
  assign `QVL_DUT2CHX_DELAY ldm_sampled = ldm;
  assign `QVL_DUT2CHX_DELAY udqs_sampled = udqs;
  assign `QVL_DUT2CHX_DELAY udm_sampled = udm;
  assign `QVL_DUT2CHX_DELAY mode_register_in_sampled = mode_register_in;
  assign `QVL_DUT2CHX_DELAY ex_mode_register_in_sampled = ex_mode_register_in;       



qvl_ddr2_sdram_2_0_logic #(Constraints_Mode,
                           CONTROLLER_SIDE,
                           ROW_ADDR_WIDTH,
                           DATA_BUS_WIDTH,
                           DLL_TRACKING_ENABLE,
                           TRAS,
                           TRCD,
                           TRP,
                           TRRD,
                           TCCD,
                           TRTW,
                           TWTR,
                           TWR,
                           TRFC,
                           TXSNR,
                           TXSRD,
                           TMRD,
                           AUTOPRECHARGE_ENABLE_ADDRESS_BIT,
                           READ_BEFORE_WRITE_CHECK_ENABLE,
                           TXP, // default value of TXP
                           TXARD, // default value of TXARD
                           BANK_ADDR_WIDTH, // BANK_ADDR_WIDTH for 4 banks + 1 bit always 0
                           ENABLE_PRECHARGE_TO_IDLE_BANK, // defaut value of ENABLE_PRECHARGE_TO_IDLE_BANK
                           BYPASS_INIT, // No BYPASS_INIT supported for this version
                           ZI_DDR2_SDRAM_2_0,  // Previous version of monitor ZI_DDR2_SDRAM_2_0
                           DATA_CHECK_ENABLE,
                           ZI_DM_WIDTH 
                           )
                   MONITOR0 (
                   .ck (ck),
                   .ck_n(ck_n),
                   .reset (reset_sampled),
                   .areset (areset_sampled),
                   .cke (cke_sampled),
                   .cs_n (cs_n_sampled),
                   .ras_n (ras_n_sampled),
                   .cas_n (cas_n_sampled),
                   .we_n (we_n_sampled),
                   .dm_rdqs (dm_sampled),
                   .ba (ba_sampled),
                   .a (a_sampled), 
                   .dq (dq_sampled),
                   .dqs (dqs_sampled),
                   .ldqs(ldqs_sampled),
                   .ldm(ldm_sampled),
                   .udqs(udqs_sampled),
                   .udm(udm_sampled),
                   .mode_register_in(mode_register_in_sampled),
                   .ex_mode_register_in(ex_mode_register_in_sampled) 
                   );


`qvlendmodule // qvl_ddr2_sdram_2_0_monitor
