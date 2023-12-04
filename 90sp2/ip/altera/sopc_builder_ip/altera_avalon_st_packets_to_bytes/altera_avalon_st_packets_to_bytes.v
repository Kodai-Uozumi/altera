// --------------------------------------------------------------------------------
//| Avalon ST Packets to Bytes Component
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps
module altera_avalon_st_packets_to_bytes (

      // Interface: clk
      input              clk,
      input              reset_n,
      // Interface: ST in with packets
      output reg         in_ready,
      input              in_valid,
      input      [7: 0]  in_data,
      input      [7: 0]  in_channel,
      input              in_startofpacket,
      input              in_endofpacket,

      // Interface: ST out 
      input              out_ready,
      output reg         out_valid,
      output reg [7: 0]  out_data
);

   // ---------------------------------------------------------------------
   //| Signal Declarations
   // ---------------------------------------------------------------------

   reg  sent_esc, sent_sop, sent_eop;
   reg  sent_channel_char, channel_escaped, sent_channel; 
   reg  [8:0] stored_channel;

   wire channel_changed, channel_needs_esc;
   wire need_sop, need_eop, need_esc, need_channel;

   // ---------------------------------------------------------------------
   //| Thingofamagick
   // ---------------------------------------------------------------------

   assign need_esc = (in_data == 8'h7a |
                      in_data == 8'h7b | 
                      in_data == 8'h7c | 
                      in_data == 8'h7d); 
   assign need_eop = (in_endofpacket);
   assign need_sop = (in_startofpacket);
   assign need_channel = (need_sop | channel_changed);

   assign channel_changed = (in_channel != stored_channel);
   assign channel_needs_esc = (in_channel == 8'h7a |
                               in_channel == 8'h7b |
                               in_channel == 8'h7c |
                               in_channel == 8'h7d); 

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         sent_esc <= 0; 
         sent_sop <= 0; 
         sent_eop <= 0; 
         sent_channel <= 0; 
         channel_escaped <= 0;
         sent_channel_char <= 0;
         out_data <= 0;
         out_valid <= 0;
      end else begin
         if (out_ready)
           out_valid <= 0;
      
         if ((out_ready | ~out_valid) && in_valid)
           out_valid <= 1; 
           
         if ((out_ready | ~out_valid) && in_valid) begin
            if (need_channel & ~sent_channel) begin
                 if (~sent_channel_char) begin
                    sent_channel_char <= 1;
                    out_data <= 8'h7c;
                 end else if (channel_needs_esc & ~channel_escaped) begin
                    out_data <= 8'h7d;
                    channel_escaped <= 1;
                 end else if (~sent_channel) begin
                    sent_channel <= 1;
                    if (channel_needs_esc) out_data <= in_channel ^ 8'h20;
                    else                   out_data <= in_channel;
                 end
            end else if (need_sop & ~sent_sop) begin
                 sent_sop <= 1;
                 out_data <= 8'h7a;
            end else if (need_eop & ~sent_eop) begin
                 sent_eop <= 1;
                 out_data <= 8'h7b;
            end else if (need_esc & ~sent_esc) begin
                 sent_esc <= 1;
                 out_data <= 8'h7d;
            end else begin
                 if (sent_esc)    out_data <= in_data ^ 8'h20;
                 else             out_data <= in_data;
                 sent_esc <= 0; 
                 sent_sop <= 0; 
                 sent_eop <= 0; 
                 sent_channel <= 0; 
                 channel_escaped <= 0;
                 sent_channel_char <= 0;
            end
         end
      end
   end

   //channel related signals 
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         //extra bit in stored_channel to force reset
         stored_channel <= 9'h1ff;
      end else begin
         //update stored_channel only when it is sent out
         if (sent_channel) begin
            stored_channel <= in_channel;
         end
      end
   end

   always @* begin
      
      // in_ready.  Low when:
      // back pressured, or when
      // we are outputting a control character, which means that one of 
      // {escape_char, start of packet, end of packet, channel} 
      // needs to be, but has not yet, been handled.
      in_ready = (out_ready | !out_valid) & in_valid & (~need_esc | sent_esc)
                 & (~need_sop | sent_sop) 
                 & (~need_eop | sent_eop)
                 & (~need_channel | sent_channel);
      
/*      out_data = (need_sop & ~sent_sop) ? 8'h7a :
                 (need_eop & ~sent_eop) ? 8'h7b : 
                 (need_channel & ~sent_channel) ?
                   (
                    (~sent_channel_char) ? 8'h7c :
                    (channel_needs_esc & ~channel_escaped) ? 8'h7d : 
                    (channel_needs_esc & channel_escaped) ? in_channel ^ 8'h20 : in_channel
                   ) :
                 (need_esc & ~sent_esc) ? 8'h7d : 
                 (sent_esc) ? in_data ^ 8'h20 :
                 in_data;
*/
   end
endmodule
