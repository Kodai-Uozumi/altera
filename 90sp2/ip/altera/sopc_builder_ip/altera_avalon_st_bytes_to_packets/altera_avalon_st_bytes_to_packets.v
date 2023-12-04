// --------------------------------------------------------------------------------
//| Avalon ST Bytes to Packet
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps
module altera_avalon_st_bytes_to_packets (

      // Interface: clk
      input              clk,
      input              reset_n,
      // Interface: ST out with packets
      input              out_ready,
      output reg         out_valid,
      output reg [7: 0]  out_data,
      output reg [7: 0]  out_channel,
      output reg         out_startofpacket,
      output reg         out_endofpacket,

      // Interface: ST in 
      output reg         in_ready,
      input              in_valid,
      input      [7: 0]  in_data
);

   // ---------------------------------------------------------------------
   //| Signal Declarations
   // ---------------------------------------------------------------------

   reg  received_esc, received_channel;
   wire escape_char, sop_char, eop_char, channel_char;

   // data out mux.  
   // we need it twice (data & channel out), so use a wire here 
   wire [7:0] data_out;

   // ---------------------------------------------------------------------
   //| Thingofamagick
   // ---------------------------------------------------------------------

   assign sop_char     = (in_data == 8'h7a);
   assign eop_char     = (in_data == 8'h7b);
   assign channel_char = (in_data == 8'h7c);
   assign escape_char  = (in_data == 8'h7d);

   assign data_out = received_esc ? (in_data ^ 8'h20) : in_data;
   
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         received_esc <= 0;
         received_channel <= 0;
         out_startofpacket <= 0;
         out_endofpacket <= 0;
      end else begin
         if (in_valid) begin
            if (received_esc) begin
               //if we got esc char, after next byte is consumed, quit esc mode
               if (out_ready | received_channel) received_esc <= 0;
            end else begin
               if (escape_char)    received_esc <= 1;
               if (sop_char)       out_startofpacket <= 1;
               if (eop_char)       out_endofpacket <= 1;
               if (channel_char)   received_channel <= 1;
            end
            if (received_channel & (received_esc | (~sop_char & ~eop_char & ~escape_char & ~channel_char))) begin
                  received_channel <= 0;
            end
            if (out_ready  & out_valid) begin
               out_startofpacket <= 0;
               out_endofpacket <= 0;
            end 
         end
      end
   end

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         out_channel <= 'h0;
      end else begin
         if ((out_ready | ~out_valid) & in_valid) begin
            if (received_channel & (received_esc | (~sop_char & ~eop_char & ~escape_char & ~channel_char))) begin
               out_channel <= data_out;
            end
         end
      end
   end
   always @* begin
      //we choose not to pipeline here.  We can process special characters when
      //in_ready, but in a chain of microcores, backpressure path is usually
      //time critical, so we keep it simple here.
      in_ready = out_ready;

      //out_valid when in_valid, except when we are processing the special
      //characters.  However, if we are in escape received mode, then we are
      //valid
      out_valid = 0;
      if ((out_ready | ~out_valid) && in_valid) begin
         out_valid = 1;
         if (received_esc) begin 
           if (received_channel) out_valid = 0;
         end else begin
            if (sop_char | eop_char | escape_char | channel_char | received_channel) out_valid = 0;
         end
      end

      out_data = data_out; 
   end
endmodule
