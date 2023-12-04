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

`include "std_qvl_defines.h"

`qvlmodule qvl_same_bit (clk,
                         reset_n,
                         active,
                         test_expr
                        );

  parameter severity_level = `QVL_ERROR;
  parameter property_type = `QVL_ASSERT;
  parameter msg = "QVL_VIOLATION : ";
  parameter coverage_level = `QVL_COVER_NONE;
  parameter width = 2;
  parameter match_xz = 0; 

  input clk; 
  input reset_n;
  input active;
  input [width-1:0] test_expr; 

  wire same_bit_fire;

  wire [63:0] evaluations;
  wire [63:0] all_bits_zero;
  wire [63:0] all_bits_one;

  wire reset_n_sampled;
  wire active_sampled;
  wire [width-1:0] test_expr_sampled;

  assign `QVL_DUT2CHX_DELAY reset_n_sampled   = reset_n;
  assign `QVL_DUT2CHX_DELAY active_sampled    = active;
  assign `QVL_DUT2CHX_DELAY test_expr_sampled = test_expr;
  
  qvl_same_bit_assertions
    #(.severity_level (severity_level),
      .property_type (property_type),
      .msg (msg),
      .coverage_level (coverage_level),
      .WIDTH (width),
      .MATCH_XZ (match_xz > 0)
     )
      qvl_same_bit_chx (.active                   (active_sampled),
                        .clock                    (clk),
                        .reset                    (~reset_n_sampled),
                        .areset                   (1'b0),
                        .zivar                    (test_expr_sampled),
                        .used                     (1'b1), 
                        .used_cond                (1'b1), 
                        .same_bit                 (1'b1),
                        .same_bit_fire            (same_bit_fire),
                        .evaluations              (evaluations),
                        .all_bits_zero            (all_bits_zero),
                        .all_bits_one             (all_bits_one),
                        .support                  (1'b1)
                      );

`qvlendmodule
