//              Copyright 2006-2007 Mentor Graphics Corporation
//                           All Rights Reserved.
//
//              THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY
//            INFORMATION WHICH IS THE PROPERTY OF MENTOR GRAPHICS
//           CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE
//                                  TERMS.
//
//                    Questa Verification Library (QVL) 


`include "std_qvl_defines.h"

`qvlmodule qvl_multi_clock_fifo (enq_clk,
                                 deq_clk,
                                 enq_reset_n,
                                 deq_reset_n,
                                 active,
                                 enq_active,
                                 deq_active,
                                 enq,
                                 deq,
                                 full,
                                 empty,
                                 enq_data,
                                 deq_data,
                                 preload
                              );

  parameter severity_level = `QVL_ERROR;
  parameter property_type = `QVL_ASSERT;
  parameter msg = "QVL_VIOLATION : ";
  parameter coverage_level = `QVL_COVER_NONE;
  
  parameter width = 1; //width of enq_data
  parameter depth = 1; // Depth of the FIFO
  parameter latency = 0; // without an enqueues in the same clock cycle
  parameter preload_count = 0; // if 0 preload data is not
                                    //enqueued into the FIFO
  parameter high_water = 0;
  parameter full_check = 0; //default off
  parameter empty_check = 0; // default off
  parameter value_check = 0; //default off

// internal parameter
  parameter preload_data_width = ((preload_count == 0) ? width:
                                  (preload_count * width)); 
 
  parameter internal_high_water = (high_water != 0) ? high_water :
                                    ((depth === 1) ? 1 : depth-1);                     

  input                          enq_clk;
  input                          deq_clk;
  input                          enq_reset_n;
  input                          deq_reset_n;
  input                          active;
  input                          enq_active;
  input                          deq_active;
  input                          enq;
  input                          deq;
  input                          full;
  input                          empty;
  input [width-1:0]         enq_data;
  input [width-1:0]         deq_data;
  input [preload_data_width-1:0] preload;

  wire enqueue_fire;
  wire dequeue_fire;
  wire value_fire;
  wire full_fire;
  wire empty_fire;

  //Statistics signals
  wire [63:0]         enqueues;
  wire [63:0]         dequeues;
  wire [63:0]         enqueues_and_dequeues;
  wire [63:0]         maximum_fifo_entries;
  wire [63:0]         current_fifo_entries;
  wire [width-1:0]    expected_deq_data;
  wire [width-1:0]    last_enq_data;
  wire [63:0]         full_count;
  wire [63:0]         empty_count;
  wire [63:0]         high_water_count;
  wire [63:0]         fire_count;

  wire                enq_reset_n_sampled;
  wire                deq_reset_n_sampled;
  wire                active_sampled;
  wire                enq_active_sampled;
  wire                deq_active_sampled;
  wire                enq_sampled;
  wire                deq_sampled;
  wire                full_sampled;
  wire                empty_sampled;
  wire [width-1:0]    enq_data_sampled;
  wire [width-1:0]    deq_data_sampled;

  wire [preload_data_width-1:0] preload_sampled;

  assign `QVL_DUT2CHX_DELAY enq_reset_n_sampled = enq_reset_n;
  assign `QVL_DUT2CHX_DELAY deq_reset_n_sampled = deq_reset_n;
  assign `QVL_DUT2CHX_DELAY active_sampled      = active;
  assign `QVL_DUT2CHX_DELAY enq_active_sampled  = enq_active;
  assign `QVL_DUT2CHX_DELAY deq_active_sampled  = deq_active;
  assign `QVL_DUT2CHX_DELAY enq_sampled         = enq;
  assign `QVL_DUT2CHX_DELAY deq_sampled         = deq;
  assign `QVL_DUT2CHX_DELAY full_sampled        = full;
  assign `QVL_DUT2CHX_DELAY empty_sampled       = empty;
  assign `QVL_DUT2CHX_DELAY enq_data_sampled    = enq_data;
  assign `QVL_DUT2CHX_DELAY deq_data_sampled    = deq_data;
  assign `QVL_DUT2CHX_DELAY preload_sampled     = preload;


 qvl_multi_clock_fifo_assertions
   #(.severity_level(severity_level),
     .property_type (property_type),
     .msg(msg),  
     .coverage_level(coverage_level),
     .DEPTH(depth),
     .ENQ_WORD_SIZE(width),
     .DEQ_WORD_SIZE(width),     
     .HIGH_WATER(internal_high_water),
     .ADDR_WIDTH(`qvl_log2(depth)),
     .PRELOAD_WIDTH (preload_data_width),
     .PRELOAD_ITEM_WIDTH (width),
     .PRELOAD_ITEM_COUNT (preload_count),
     .PRELOAD_SPECIFIED ((preload_count !== 0) ? 1'b1: 1'b0 ),
     .LATENCY (latency),
     .VALUE_CHECK(value_check > 0),
     .FULL_CHECK(full_check > 0),
     .EMPTY_CHECK(empty_check > 0)
    )
     qvl_multi_clock_fifo_chx( .active         (active_sampled),  
                   .areset         (1'b0), 
                   .enq_reset      (~enq_reset_n_sampled),
                   .deq_reset      (~deq_reset_n_sampled),
                   .enq_active     (enq_active_sampled), 
                   .deq_active     (deq_active_sampled),
                   .enq_clock      (enq_clk), 
                   .deq_clock      (deq_clk), 
                   .enq            (enq_sampled), 
                   .deq            (deq_sampled),
                   .full           (full_sampled),
                   .empty          (empty_sampled),     
                   .enq_data       (enq_data_sampled), 
                   .deq_data       (deq_data_sampled),
                   .enqueue        (1'b1),
                   .dequeue        (1'b1), 
                   .value          (value_check == 1),    
                   .full_check     (full_check == 1),
                   .empty_check    (empty_check == 1),
                   .preload        (preload_sampled), 
                   .enqueue_fire   (enqueue_fire),
                   .dequeue_fire   (dequeue_fire),
                   .value_fire     (value_fire),
                   .full_fire      (full_fire),
                   .empty_fire     (empty_fire),
                   .enqueues       (enqueues),
                   .dequeues       (dequeues),
                   .enqueues_and_dequeues    (enqueues_and_dequeues),
                   .maximum_fifo_entries     (maximum_fifo_entries),
                   .current_fifo_entries     (current_fifo_entries),
                   .expected_deq_data        (expected_deq_data),
                   .last_enq_data            (last_enq_data),
                   .full_count               (full_count),
                   .empty_count              (empty_count),
                   .high_water_count         (high_water_count),
                   .support                  (1'b1),
                   .fire_count               (fire_count)
                );

`qvlendmodule 
