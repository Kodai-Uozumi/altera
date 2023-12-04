//--------------------------------------------------------------------------------------------------
// (c)2003 Altera Corporation. All rights reserved.
//
// Altera products are protected under numerous U.S. and foreign patents,
// maskwork rights, copyrights and other intellectual property laws.
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Altera Reference Design License
// Agreement (either as signed by you or found at www.altera.com).  By using
// this reference design file, you indicate your acceptance of such terms and
// conditions between you and Altera Corporation.  In the event that you do not
// agree with such terms and conditions, you may not use the reference design
// file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an �as-is� basis and as an
// accommodation and therefore all warranties, representations or guarantees of
// any kind (whether express, implied or statutory) including, without
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or
// require that this reference design file be used in combination with any
// other product not provided by Altera.
//--------------------------------------------------------------------------------------------------


module sdi_tr_reconfig_multi # (parameter NUM_CHS = 4)
  (
   input                        rst,
   input  [3:0]                 write_ctrl,
   input  [1:0]                 rx_std_ch0,
   input  [1:0]                 rx_std_ch1,
   input  [1:0]                 rx_std_ch2,
   input  [1:0]                 rx_std_ch3,   
   input                        reconfig_clk,
   input  [67:0]                reconfig_fromgxb, // only 1 per quad
   output [3:0]                 sdi_reconfig_done,
   output [3:0]                 reconfig_togxb
  );

  
   wire [4:0]                   rom_address;
   wire                         rom_clk_enable;
   wire [15:0]                  reconfig_data;

   wire [15:0]                  ch0_rom_data;
   wire [15:0]                  ch1_rom_data;
   wire [15:0]                  ch2_rom_data;
   wire [15:0]                  ch3_rom_data;

   wire                         busy;
   reg                          start_reconfig;
   reg                          reconfig_in_progress;
   wire [3:0]                   ch_reconfig_done;
   wire [3:0]                   ch_request;
   reg  [1:0]                   ch_select;
   reg  [1:0]                   std_select;
   reg  [3:0]                   wait_count;
   
   

// State machine to handle reconfig requests from multiple cores --  
// could be modified for round robin sharing.  

   // State machine parameters
   reg          [1:0] state;
   parameter    [1:0] IDLE                              = 2'b00;
   parameter    [1:0] START_RECONFIG_STATE              = 2'b01;
   parameter    [1:0] RECONFIG_IN_PROGRESS_STATE        = 2'b10;

   // Delay lines needed since we're clock domain crossing.
   reg [1:0]       ch0_rq_dly;
   reg [1:0]       ch1_rq_dly;
   reg [1:0]       ch2_rq_dly;
   reg [1:0]       ch3_rq_dly;
   
   always @ (posedge reconfig_clk or posedge rst )
     begin
        if (rst) begin
           ch0_rq_dly        <= 2'b00;
           ch1_rq_dly        <= 2'b00;
           ch2_rq_dly        <= 2'b00;
           ch3_rq_dly        <= 2'b00;
        end
        else begin
           ch0_rq_dly <= {ch0_rq_dly[0], write_ctrl[0]};
           ch1_rq_dly <= {ch1_rq_dly[0], write_ctrl[1]};
           ch2_rq_dly <= {ch2_rq_dly[0], write_ctrl[2]};
           ch3_rq_dly <= {ch3_rq_dly[0], write_ctrl[3]};
        end // else: !if(rst)
     end // always @ (posedge reconfig_clk or posedge rst )


   
   reg [3:0] ch_reconfig_done_reg;
   
   
   always @ (posedge reconfig_clk or posedge rst )
     begin
        if (rst) begin
           ch_reconfig_done_reg <= 4'b0000;
        end
        else begin
           // use for loop
           if (ch_request[0] == 1'b1) begin
              ch_reconfig_done_reg[0] <= 1'b0;
              if (set_reconfig_done[0] == 1'b1)
                ch_reconfig_done_reg[0] <= 1'b1;
           end
           if (ch_request[1] == 1'b1) begin
              ch_reconfig_done_reg[1] <= 1'b0;
              if (set_reconfig_done[1] == 1'b1)
                ch_reconfig_done_reg[1] <= 1'b1;
           end
           if (ch_request[2] == 1'b1) begin
              ch_reconfig_done_reg[2] <= 1'b0;
              if (set_reconfig_done[2] == 1'b1)
                ch_reconfig_done_reg[2] <= 1'b1;
           end
           if (ch_request[3] == 1'b1) begin
              ch_reconfig_done_reg[3] <= 1'b0;
              if (set_reconfig_done[3] == 1'b1)
                ch_reconfig_done_reg[3] <= 1'b1;
           end
        end
     end // always @ (posedge reconfig_clk or posedge rst )
 
   


reg [3:0] set_reconfig_done;


   assign ch_request = ({ch3_rq_dly[1], ch2_rq_dly[1], ch1_rq_dly[1], ch0_rq_dly[1]});
   
   
   always @ (posedge reconfig_clk or posedge rst )
     begin
        if (rst) begin
           start_reconfig       <= 1'b0;
           reconfig_in_progress <= 1'b0;
           wait_count           <= 4'b1111;
           state                <= IDLE;
           ch_select            <= 2'b00;
           
        end
        else begin
           
           start_reconfig <= 1'b0;
           set_reconfig_done <= 4'b0000;
           
           case (state)

             IDLE : 
               begin
                  // check for requesting input
                  // priority is implicit in statement order
                  // ch0 is highest priority.
                  if (ch_request[3]) begin
                     ch_select <= 2'b11;
                     state <= START_RECONFIG_STATE;
                  end
                  if (ch_request[2]) begin
                     ch_select <= 2'b10;
                     state <= START_RECONFIG_STATE;
                  end
                  if (ch_request[1]) begin
                     ch_select <= 2'b01;
                     state <= START_RECONFIG_STATE;
                  end
                  if (ch_request[0]) begin
                     ch_select <= 2'b00;
                     state <= START_RECONFIG_STATE;
                  end

               end

             START_RECONFIG_STATE :
               begin
                  // generate single clock wide pulse to start reconfig counter below
                  start_reconfig <= 1'b1;
                  reconfig_in_progress <= 1'b1; // equivalent to not done
                   
                  state <= RECONFIG_IN_PROGRESS_STATE;
               end

             RECONFIG_IN_PROGRESS_STATE :
               begin
                  // wait for reconfig to start before checking
                  // done isn't immediately de asserted.
                  if (wait_count == 0) begin

                     if (reconfig_done) begin
                        // this test is to check the requesting channel
                        // has deasserted its request before returning
                        // to the IDLE state.
                        reconfig_in_progress <= 1'b0;
                        set_reconfig_done[ch_select] <= 1'b1;
                        if (ch_request[ch_select] == 1'b0) begin
                           // only go back to idle state when request is deasserted
                           state <= IDLE;
                           wait_count <= 4'b1111;
                        end
                     end
                  end // if (wait_count == 0)
                  else wait_count <= wait_count -1;
               end
             
             default :
               state <= IDLE;

           endcase // case(state)
        end // else: !if(rst)
     end // always @ (posedge reconfig_clk or posedge rst )
   

   
// These roms holds the MIF file for the GXB setup, it's set as the 3G/SD version.
// For HD, the sdi_mif_intercept code adjusts word 23 to allow the refclk divider
// to be set.

// Four different instances are requried as each instance has the MIF file set
// as part of the instance.

  
sdi_ch0_rom   sdi_ch0_rom_inst
  (                       
    .clock(reconfig_clk),                    
    .clken(rom_clk_enable),
    .address(rom_address),
    .q(ch0_rom_data)
    );
   
sdi_ch1_rom   sdi_ch1_rom_inst
  (                       
    .clock(reconfig_clk),                    
    .clken(rom_clk_enable),
    .address(rom_address),
    .q(ch1_rom_data)
    );

sdi_ch2_rom   sdi_ch2_rom_inst
  (                       
    .clock(reconfig_clk),                    
    .clken(rom_clk_enable),
    .address(rom_address),
    .q(ch2_rom_data)
    );

sdi_ch3_rom   sdi_ch3_rom_inst
  (                       
    .clock(reconfig_clk),                    
    .clken(rom_clk_enable),
    .address(rom_address),
    .q(ch3_rom_data)
    );


// select which rom is to be used for reconfig
   
   reg  [15:0]  rom_data_mux_out;
   
   always @ (*)
     begin
        case (ch_select)
          2'b00 : rom_data_mux_out <= ch0_rom_data;
          2'b01 : rom_data_mux_out <= ch1_rom_data;
          2'b10 : rom_data_mux_out <= ch2_rom_data;
          2'b11 : rom_data_mux_out <= ch3_rom_data;
          default : rom_data_mux_out <= ch0_rom_data;
        endcase // case(ch_select)
     end
  

// select the std_select port for the requesting channel   
   always @ (*)
     begin
        case (ch_select)
          2'b00 : std_select <= rx_std_ch0;
          2'b01 : std_select <= rx_std_ch1;
          2'b10 : std_select <= rx_std_ch2;
          2'b11 : std_select <= rx_std_ch3;
          default : std_select <= rx_std_ch0;
        endcase // case(ch_select)
     end



 
   assign ch_reconfig_done[0] = (~ch_select[1] & ~ch_select[0]) ? ~reconfig_in_progress : 1'b1;
   assign ch_reconfig_done[1] = (~ch_select[1] &  ch_select[0]) ? ~reconfig_in_progress : 1'b1;
   assign ch_reconfig_done[2] = ( ch_select[1] & ~ch_select[0]) ? ~reconfig_in_progress : 1'b1;
   assign ch_reconfig_done[3] = ( ch_select[1] &  ch_select[0]) ? ~reconfig_in_progress : 1'b1;  

   assign sdi_reconfig_done = ch_reconfig_done_reg;  

                                          
// Only one word has to chage between HD and 3G, this block simply intercepts that
// word out of the 3G rom and replaces it with the HD value.  This is conditional on
// HD being selected.


   sdi_mif_intercept  sdi_mif_intercept_inst
     (
      .reconfig_address    (rom_address),
      .rom_data_in         (rom_data_mux_out),
      .select_hd           (std_select[0] & ~std_select[1]), // when HD = 1, otherwise 0
      .rom_data_out        (reconfig_data)   
      );

// multi channel reconfig, includes logical channel address.

 sdi_4_ch_alt2gxb_reconfig    sdi_alt2gxb_reconfig_inst
     (
    .logical_channel_address({ch_select,2'b00}),                            // 4 bit input       
    .reconfig_clk(reconfig_clk),                                            // common input
    .reconfig_data(reconfig_data),                                          // 16 bit rom input
    .reconfig_togxb(reconfig_togxb[2:0]),                                   // 3 bit output
    .reconfig_address_en(rom_clk_enable),                                   // 1 bit rom read
    .reconfig_address_out(rom_address),                                     // rom read address
    .channel_reconfig_done (reconfig_done),                                 // 1 bit output
    .write_all(reconfig_userlogic_write),                                   // 1 bit input    
    .reconfig_fromgxb({2'b00, reconfig_fromgxb[17], reconfig_fromgxb[0]}),  // 4 bit input
    .busy(busy)
    );

   
// this state machine kicks off the reconfig.  It asserts the reconfig_userlogic_write
// signal for one clock only, for each address that the reconfig block requires.
// This pulse is asserted 4 clocks after the request is made in order that the rom output
// has settled.  This could likely be reduced to 1 clock, though the DPRIO formatting time
// dominates.     
 
reg[1:0] cnt;
reg[1:0] write_state;
reg reconfig_userlogic_write;   
   
   always @ (posedge reconfig_clk or posedge rst) begin
      if (rst) begin
         cnt <= 2'b00;
         reconfig_userlogic_write <= 1'b0;
         write_state <= 2'b00;
         end
      else begin
         reconfig_userlogic_write <= 1'b0;
         case (write_state)
          
           2'b00: begin // IDLE
              cnt <= 2'b00;
              if (start_reconfig) write_state <= 2'b01;
              else write_state <= 2'b00;
              end
      
           2'b01: begin // wait whilst reconfig it busy, then go to write word state
              reconfig_userlogic_write <= 1'b0;
              cnt <= 2'b00;
              if (rom_address <= 27 && ~busy) begin       
                 write_state <= 2'b10;
                 end
              else begin       
                 write_state <= 2'b01;
                 end
              end
    
           2'b10: begin // write word state
              cnt <= cnt + 1; //this counter gives enough clock cycles for data out
                              //  from memory after address change
              if (cnt == 2'b01) begin
                 reconfig_userlogic_write <= 1'b1;
                 write_state <= 2'b11;
                 end
              else begin
                 reconfig_userlogic_write <= 1'b0;
                 write_state <= 2'b10;
                 end
       
              end
    
           2'b11: begin // check for final word, or go back to "in progress" state.
              if (rom_address == 27)
                write_state <= 2'b00;
              else
                write_state <= 2'b01;   
    
              end
    endcase
     
    end
   end

endmodule
