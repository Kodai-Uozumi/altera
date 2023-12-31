// --------------------------------------------------------------------------------
//| Avalon ST Packets to MM Master Transaction Component
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps
module altera_avalon_packets_to_master (

      // Interface: clk
      input              clk,
      input              reset_n,
      // Interface: ST in
      output reg         in_ready,
      input              in_valid,
      input      [ 7: 0] in_data,
      input              in_startofpacket,
      input              in_endofpacket,

      // Interface: ST out 
      input              out_ready,
      output reg         out_valid,
      output reg [ 7: 0] out_data,
      output reg         out_startofpacket,
      output reg         out_endofpacket,

      // Interface: MM out
      output reg [31: 0] address,
      input      [31: 0] readdata,
      output reg         read,
      output reg         write,
      output reg [ 3: 0] byteenable,
      output reg [31: 0] writedata,
      input              waitrequest,
      input              readdatavalid
      
);

   // ---------------------------------------------------------------------
   //| Parameter Declarations
   // ---------------------------------------------------------------------
   parameter EXPORT_MASTER_SIGNALS = 0;

   // ---------------------------------------------------------------------
   //| Command Declarations
   // ---------------------------------------------------------------------
   localparam CMD_WRITE_NON_INCR = 8'h00;
   localparam CMD_WRITE_INCR     = 8'h04;
   localparam CMD_READ_NON_INCR  = 8'h10;
   localparam CMD_READ_INCR      = 8'h14;
   
   // ---------------------------------------------------------------------
   //| Signal Declarations
   // ---------------------------------------------------------------------

   reg  [ 3: 0]  state;
   reg  [ 7: 0]  command;
   reg  [ 1: 0]  current_byte; //, result_byte;
   reg  [ 15: 0] counter;
   reg  [ 23: 0] read_data_buffer;
   reg           in_ready_0;
   reg           first_trans, last_trans;
   reg  [ 3: 0]  unshifted_byteenable;
   wire enable;

   localparam READY          = 4'b0000, 
              GET_EXTRA      = 4'b0001,
              GET_SIZE1      = 4'b0010,
              GET_SIZE2      = 4'b0011,
              GET_ADDR1      = 4'b0100,
              GET_ADDR2      = 4'b0101,
              GET_ADDR3      = 4'b0110,
              GET_ADDR4      = 4'b0111,
              GET_WRITE_DATA = 4'b1000,      
              WRITE_WAIT     = 4'b1001,
              RETURN_PACKET  = 4'b1010,
              READ_ASSERT    = 4'b1011,
              READ_DATA_WAIT = 4'b1100,
              READ_SEND_ISSUE= 4'b1101,
              READ_SEND_WAIT = 4'b1110;
   
   
   // ---------------------------------------------------------------------
   //| Thingofamagick
   // ---------------------------------------------------------------------

   assign enable = (in_ready & in_valid);

   always @*
//      in_ready = in_ready_0 & out_ready;
      in_ready = in_ready_0;
   
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
            in_ready_0        <= 1'b0;
            out_startofpacket <= 1'b0;
            out_endofpacket   <= 1'b0;
            out_valid         <= 1'b0;
            out_data          <=  'b0;
            read              <= 1'b0;
            write             <= 1'b0;
            byteenable        <=  'b0;
            writedata         <=  'b0;
            address           <=  'b0;
            counter           <=  'b0;
            command           <=  'b0;
            first_trans       <= 1'b0;
            last_trans        <= 1'b0;
            state             <= 'b0;
            current_byte      <= 'b0;
          //  result_byte       <= 'b0;
            read_data_buffer  <= 'b0;
            unshifted_byteenable <= 'b0;
      end else begin
            address[1:0]      <= 'b0;
 
            if (out_ready) begin
              out_startofpacket <= 1'b0;
              out_endofpacket   <= 1'b0;
              out_valid         <= 1'b0;
            end
            in_ready_0 <= 1'b0;
            
            if (counter >= 3)      unshifted_byteenable <= 4'b1111;
            else if (counter == 3) unshifted_byteenable <= 4'b0111;
            else if (counter == 2) unshifted_byteenable <= 4'b0011;
            else if (counter == 1) unshifted_byteenable <= 4'b0001;

            case (state)
              READY : begin
                   out_valid         <= 1'b0;
                   in_ready_0        <= 1'b1;
              end
              GET_EXTRA : begin
                   in_ready_0        <= 1'b1;
                   byteenable        <=  'b0;
                   if (enable) state <= GET_SIZE1;
              end

              GET_SIZE1 : begin
                   in_ready_0        <= 1'b1;
                   //load counter on reads only
                   counter[15:8]     <= command[4]?in_data:8'b0;
                   if (enable) state <= GET_SIZE2;
              end

              GET_SIZE2 : begin
                   in_ready_0        <= 1'b1;
                   //load counter on reads only
                   counter[7:0]      <= command[4]?in_data:8'b0;
                   if (enable) state <= GET_ADDR1;
              end
              
              GET_ADDR1 : begin
                in_ready_0        <= 1'b1;
                first_trans       <= 1'b1;
                last_trans        <= 1'b0;
                address[31:24]    <= in_data;
                if (enable) state <= GET_ADDR2;
              end

              GET_ADDR2 : begin
                in_ready_0        <= 1'b1;
                address[23:16]    <= in_data;
                if (enable) state <= GET_ADDR3;
              end

              GET_ADDR3 : begin
                in_ready_0        <= 1'b1;
                address[15:8]     <= in_data;
                if (enable) state <= GET_ADDR4;
              end

              GET_ADDR4 : begin
                in_ready_0        <= 1'b1;
                address[7:2]      <= in_data[7:2];
                current_byte      <= in_data[1:0];
                if (enable) begin
                      if (command == CMD_WRITE_NON_INCR | command == CMD_WRITE_INCR) begin
                        state <= GET_WRITE_DATA; //writes
                        in_ready_0 <= 1'b1;
                      end
                      else if (command == CMD_READ_NON_INCR | command == CMD_READ_INCR) begin
                        state   <= READ_ASSERT; //reads
                        in_ready_0 <= 1'b0;
                      end
                      else begin
                        //nops
                        //treat all unrecognized commands as nops as well
                        state <= RETURN_PACKET; 
                        out_startofpacket <= 1'b1;
                        out_data <= (8'h80 | command);
                        out_valid <= 1'b1;
                        current_byte <= 'h0;
                        in_ready_0 <= 1'b0;
                      end
                end
              end

              GET_WRITE_DATA : begin
                        in_ready_0 <= 1; 
                        if (enable) begin
                          counter <= counter + 1'b1;
                          //2 bit, should wrap by itself
                          current_byte <= current_byte + 1'b1;
                          if (in_endofpacket || current_byte == 3) 
                          begin
                             in_ready_0 <= 0;
                             write      <= 1'b1;
                             state      <= WRITE_WAIT;
                          end
                        end
                        if (in_endofpacket) begin
                          last_trans <= 1'b1;
                        end
                        // handle byte writes properly
                        // drive data pins based on addresses
                        case (current_byte)
                          0: begin
                            writedata[7:0]   <= in_data;
                            byteenable[0]    <= 1;
                          end
                          1: begin
                            writedata[15:8]  <= in_data;
                            byteenable[1]    <= 1;
                          end
                          2: begin
                            writedata[23:16] <= in_data;
                            byteenable[2]    <= 1;
                          end
                          3: begin
                            writedata[31:24] <= in_data;
                            byteenable[3]    <= 1;
                          end
                        endcase
              end

              WRITE_WAIT : begin
                        in_ready_0 <= 0;
                        write      <= 1'b1;
                        if (~waitrequest) begin
                           write <= 1'b0;
                           state <= GET_WRITE_DATA;
                           in_ready_0 <= 1;
                           byteenable <= 'b0;
                           if (command[2] == 1'b1) begin
                              //increment address, but word-align it
                              address[31:2] <= (address[31:2] + 1'b1);
                           end
                           if (last_trans) begin
                              state <= RETURN_PACKET;
                              out_startofpacket <= 1'b1;
                              out_data <= (8'h80 | command);
                              out_valid <= 1'b1;
                              current_byte <= 'h0;
                              in_ready_0 <= 1'b0;
                           end
                        end
              end
              
              RETURN_PACKET : begin
                        out_valid <= 1'b1;
                        if (out_ready) begin
                           case (current_byte)
                          //   0: begin
                          //     out_startofpacket <= 1'b1;
                          //     out_data <= (8'h80 | command);
                          //   end
                             0: begin
                               out_data <= 8'b0;
                             end
                             1: begin
                               out_data <= counter[15:8];
                             end
                             2: begin
                               out_endofpacket <= 1'b1;
                               out_data <= counter[7:0];
                             end
                             default: begin
                          //     out_data <= 8'b0;
                          //     out_startofpacket <= 1'b0;
                          //     out_endofpacket <= 1'b0;
                             end
                           endcase
                           current_byte <= current_byte + 1'b1;
                           if (current_byte == 3) begin
                              state     <= READY;
                              out_valid <= 1'b0;
                           end
                           else                   state     <= RETURN_PACKET;
                        end
              end
              READ_ASSERT : begin
                        if (current_byte == 3) byteenable <= unshifted_byteenable << 3;
                        if (current_byte == 2) byteenable <= unshifted_byteenable << 2;
                        if (current_byte == 1) byteenable <= unshifted_byteenable << 1;
                        if (current_byte == 0) byteenable <= unshifted_byteenable;
//                        byteenable <= unshifted_byteenable << current_byte;
                        read             <= 1;
                        state            <= READ_DATA_WAIT;
              end
              READ_DATA_WAIT : begin
                        read             <= waitrequest;
                        read_data_buffer <= readdata[31:8];
                        out_data         <= readdata[7:0];
                        //wait for read data here.  if not waitrequested, or later
                        //if readdatavalid, then go to send data state
                        if (~waitrequest & readdatavalid) begin
                           state <= READ_SEND_ISSUE;
                        end
              end
              READ_SEND_ISSUE : begin
                        out_valid <= 1'b1;
                        out_startofpacket <= 'h0;
                        out_endofpacket   <= 'h0;
                        if (counter == 1) begin
                           out_endofpacket <= 1'b1;
                        end 
                        if (first_trans) begin
                           first_trans <= 1'b0;
                           out_startofpacket <= 1'b1;
                        end
                        case (current_byte)
                          3: begin
                             out_data        <= read_data_buffer[23:16];
                          end
                          2: begin
                             out_data        <= read_data_buffer[15:8];
                          end
                          1: begin
                             out_data        <= read_data_buffer[7:0];
                          end
                          default: begin
                             out_data        <= out_data; 
                          end
                        endcase
                        state <= READ_SEND_WAIT;
              end
              READ_SEND_WAIT : begin
                        out_valid <= 1'b1;
                        if (out_ready) begin
                           counter <= counter - 1'b1;
                           current_byte <= current_byte + 1'b1;
                           out_valid <= 1'b0;
                           // count down on the number of bytes to read
                           // shift current byte location within word
                           // if increment address, add it, so the next read
                           // can use it, if more reads are required
                           
                           // no more bytes to send - go to READY state
                           if (counter == 1) begin
                              state <= READY;
                           // end of current word, but we have more bytes to
                           // read - go back to READ_ASSERT
                           end else if (current_byte == 3) begin
                              if (command[2] == 1'b1) begin
                                 //increment address, but word-align it
                                 address[31:2] <= (address[31:2] + 1'b1);
                              end
                              state <= READ_ASSERT;
                           // continue sending current word
                           end else begin
                              state <= READ_SEND_ISSUE;
                           end
                           //maybe add in_ready_0 here so we are ready to go
                           //right away
                        end 
              end
           endcase
           if (enable & in_startofpacket) begin
              state <= GET_EXTRA;
              command           <= in_data;
              in_ready_0 <= 1'b1;
           end
      end  // end else
   end  // end always block
endmodule
