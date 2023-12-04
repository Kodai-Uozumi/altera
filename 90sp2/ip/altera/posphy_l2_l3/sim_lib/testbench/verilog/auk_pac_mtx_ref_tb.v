//-----------------------------------------------------------------------
//-----------------------------------------------------------------------
//
// Title        : Reference design for POS-PHY Level 3 Link Source (Tx) top level architecture
// Project      : Pos-Phy
//
// Description	: Reference design for Altera POS-PHY Level 3 Core
//
// Copyright 1999, 2000 (c) Altera Corporation
// All rights reserved
//
//-----------------------------------------------------------------------
//-----------------------------------------------------------------------
//-----------------------------------------------------------------------
// Main entity, the reference design testbench
//-----------------------------------------------------------------------
`timescale 1ns / 1ns
module auk_pac_mtx_ref ();

   parameter DPAV_WIDTH = 1; 
   parameter ADDR_WIDTH = 0; 
   parameter DATA_WIDTH = 32; 
   parameter MOD_WIDTH = 2; 
   parameter CUSTOM_WIDTH = 32; 
   parameter PARITY_MODE = 1'b1; 

   function generate_parity;
      input[DATA_WIDTH - 1:0] data; 

      reg result; 

      begin
         result = ^data; 
         generate_parity = result; 
      end
   endfunction

   function [7:0] generate_incrementing_data;
      input[7:0] data; 

      reg[7:0] result; 

      begin
         result[3:0] = data[3:0] + 1; 
         result[7:4] = data[7:4] + 1; 
         generate_incrementing_data = result; 
      end
   endfunction
   reg clk_inA; 
   reg reset_inA; 
   reg[0:0] dpav_inA; 
   wire wr_outA; 
   wire sx_outA; 
   wire[DATA_WIDTH - 1:0] data_outA; 
   wire sop_outA; 
   wire eop_outA; 
   wire err_outA; 
   wire prty_outA; 
   wire[1:0] mod_outA; 
   wire dav_outB; 
   reg wr_inB; 
   reg[DATA_WIDTH - 1:0] data_inB; 
   reg sop_inB; 
   reg eop_inB; 
   reg err_inB; 
   reg prty_inB; 
   reg[1:0] mod_inB; 
   reg clk_inB; 
   reg reset_inB; 

   initial
   begin
      reset_inA <= 1'b1;
      dpav_inA <= 1'b0;
      wr_inB <= 1'b0;
      sop_inB <= 1'b0;
      eop_inB <= 1'b0;
      err_inB <= 1'b0;
      prty_inB <= 1'b0;
      clk_inB <= 1'b0;
      reset_inB <= 1'b1;
   end

   auk_pac_mtx_pl3_link mtx   ( .a_dtpa(dpav_inA), 
                                .a_tenb(wr_outA), 
                                .a_tdat(data_outA), 
                                .a_tsop(sop_outA), 
                                .a_teop(eop_outA), 
                                .a_terr(err_outA), 
                                .a_tprty(prty_outA), 
                                .a_tmod(mod_outA), 
                                .a_tfclk(clk_inA), 
                                .a_treset_n(reset_inA), 
                                .b_dav(dav_outB), 
                                .b_ena(wr_inB), 
                                .b_dat(data_inB), 
                                .b_sop(sop_inB), 
                                .b_eop(eop_inB), 
                                .b_err(err_inB), 
                                .b_par(prty_inB), 
                                .b_mty(mod_inB), 
                                .b_clk(clk_inB), 
                                .b_reset_n(reset_inB)); 


   always 
   begin : pos_phy_clk_gen
      while ($time <= 50000)
      begin
         clk_inA <= 1'b0 ; 
         #5; 
         clk_inA <= 1'b1 ; 
         #5; 
      end 
      forever #100000; 
   end 

   always 
   begin : atlantic_clk_gen
      while ($time <= 50000)
      begin
         clk_inB <= 1'b0 ; 
         #5; 
         clk_inB <= 1'b1 ; 
         #5; 
      end 
      forever #100000; 
   end 

   always 
   begin : send_data_to_atlantic
      reset_pulse; 
      delay_n_clocks(6); 
      generate_atlantic_data_packet(0, 64); 
      delay_n_clocks(4); 
      generate_atlantic_data_packet(1, 63); 
      generate_atlantic_data_packet(2, 61); 
      delay_n_clocks(2); 
      generate_atlantic_data_packet(3, 3); 
      delay_n_clocks(2); 
      generate_atlantic_data_packet(4, 128); 
      generate_atlantic_data_packet(5, 256); 
      forever #100000; 
   end

   task reset_pulse;

      begin
         reset_inB <= 1'b0 ; 
         @(posedge clk_inB); 
         reset_inB <= 1'b1 ; 
      end
   endtask

   task delay_n_clocks;
      input delay; 
      integer delay;

      begin
         begin : xhdl_2
            integer i;
            for(i = 1; i <= delay; i = i + 1)
            begin
               @(posedge clk_inB); 
            end
         end 
      end
   endtask

   task generate_atlantic_data_packet;
      input packet_number; 
      integer packet_number;
      input packet_length; 
      integer packet_length;

      reg sop; 
      reg eop; 
      reg err; 
      reg val; 
      reg par; 
      reg[1:0] mty; 
      reg[DATA_WIDTH - 1:0] dat; 
      reg[7:0] temp_dat; 
      integer num_cycles; 
      integer bytes_sent; 

      begin
         sop = 1'b1;
         eop = 1'b0;
         err = 1'b0;
         val = 1'b0;
         par = 1'b0;
         mty = 0;
         dat = 0;
         temp_dat = 0;
         bytes_sent = 0;
         if (packet_length > 4)
         begin
            num_cycles = (packet_length * 8) / DATA_WIDTH; 
         end
         else
         begin
            num_cycles = 1; 
         end 
         begin : xhdl_4
            while (1'b1)
            begin
               while (!dav_outB)
               begin
                   val = 1'b0; 
                   wr_inB <= val ; 
                  @(posedge clk_inB); 
               end 
               val = 1'b1; 
               begin : xhdl_3
                  integer i;
                  for(i = (DATA_WIDTH / 8) - 1; i >= 0; i = i - 1)
                  begin
                     if (sop & i == (DATA_WIDTH / 8) - 1)
                     begin
//                        dat[(i * 8) + 7:(i * 8) + 0] = packet_number;
                        if (i == 0)
                        begin
                        dat [7:0] = packet_number;
                        end
                        if (i == 1)
                        begin
                        dat [15:8] = packet_number;
                        end
                        if (i == 2)
                        begin
                        dat [23:16] = packet_number;
                        end
                        if (i == 3)
                        begin
                        dat [31:24] = packet_number;
                        end
                        if (i == 4)
                        begin
                        dat [39:32] = packet_number;
                        end
                        if (i == 5)
                        begin
                        dat [47:40] = packet_number;
                        end
                        if (i == 6)
                        begin
                        dat [55:48] = packet_number;
                        end
                        if (i == 7)
                        begin
                        dat [63:56] = packet_number;
                        end
                     end
                     else
                     begin
//                        dat[(i * 8) + 7:(i * 8) + 0] = temp_dat; 
                        if (i == 0)
                        begin
                        dat [7:0] = temp_dat;
                        end
                        if (i == 1)
                        begin
                        dat [15:8] = temp_dat;
                        end
                        if (i == 2)
                        begin
                        dat [23:16] = temp_dat;
                        end
                        if (i == 3)
                        begin
                        dat [31:24] = temp_dat;
                        end
                        if (i == 4)
                        begin
                        dat [39:32] = temp_dat;
                        end
                        if (i == 5)
                        begin
                        dat [47:40] = temp_dat;
                        end
                        if (i == 6)
                        begin
                        dat [55:48] = temp_dat;
                        end
                        if (i == 7)
                        begin
                        dat [63:56] = temp_dat;
                        end

                     end 
                     par = generate_parity(dat); 
                     temp_dat = generate_incrementing_data(temp_dat); 
                  end
               end 
               if (packet_length - bytes_sent <= (DATA_WIDTH / 8))
               begin
                  eop = 1'b1; 
                  mty = (DATA_WIDTH / 8 - (packet_length % (DATA_WIDTH / 8))); 
               end 
               data_inB <= dat ; 
               prty_inB <= par ; 
               sop_inB <= sop ; 
               eop_inB <= eop ; 
               mod_inB <= mty ; 
               err_inB <= err ; 
               wr_inB <= val ; 
               @(posedge clk_inB); 
               bytes_sent = bytes_sent + (DATA_WIDTH / 8 - mty); 
               if (sop)
               begin
                  sop = 1'b0; 
                  sop_inB <= sop ; 
               end 
               if (eop)
               begin
                  eop_inB <= 1'b0 ; 
                  wr_inB <= 1'b0 ; 
                  mod_inB <= {2{1'b0}} ; 
                  @(posedge clk_inB); 
                  disable xhdl_4; 
               end 
            end
         end 
      end
   endtask 

   reg simulation_passed; 
   always 
   begin : listen_for_data_on_posphy
      reg l; 
      simulation_passed = 1'b1;
      reset_pulse_xhdl5; 
      delay_n_clocks_xhdl6(3); 
      receive_posphy_data_packet(0, 64); 
      receive_posphy_data_packet(1, 63); 
      receive_posphy_data_packet(2, 61); 
      receive_posphy_data_packet(3, 3); 
      receive_posphy_data_packet(4, 128); 
      receive_posphy_data_packet(5, 256); 
      if (simulation_passed)
      begin
         $display("** Simulation PASSED **. (note)"); 
		 $stop;
      end
      else
      begin
         $display("############# Simulation FAILED #############. (note)"); 
		 $stop;
      end 
      forever #100000; 
   end

   task reset_pulse_xhdl5;

      begin
         reset_inA <= 1'b0 ; 
         @(posedge clk_inA); 
         reset_inA <= 1'b1 ; 
      end
   endtask

   task delay_n_clocks_xhdl6;
      input delay; 
      integer delay;

      begin
         begin : xhdl_7
            integer i;
            for(i = 1; i <= delay; i = i + 1)
            begin
               @(posedge clk_inA); 
            end
         end 
      end
   endtask

   task receive_posphy_data_packet;
      input packet_number; 
      integer packet_number;
      input packet_length; 
      integer packet_length;

      reg[7:0] recvd_dat; 
      reg[7:0] temp_dat; 
      integer bytes_received; 
      integer num_errs; 

      begin
         recvd_dat = 0;
         temp_dat = 0;
         bytes_received = 0;
         num_errs = 0;
         dpav_inA[0] <= 1'b1 ; 
         while (wr_outA)
         begin
            @(posedge clk_inA); 
         end 
         begin : xhdl_8
            while (bytes_received < packet_length)
            begin
               if (!wr_outA)
               begin
                  if (!sop_outA)
                  begin
                     $display("receive_posphy_data_packet(): missing sop signal! (ERROR)"); 
                     num_errs = num_errs + 1; 
                  end 
                  if (sop_outA)
                  begin
                     temp_dat = packet_number; 
                     recvd_dat = data_outA[DATA_WIDTH - 1:DATA_WIDTH - 8]; 
                     bytes_received = bytes_received + 1; 
                     if (recvd_dat != temp_dat)
                     begin
                        $display("receive_posphy_data_packet(): invalid packet number! (ERROR)"); 
                        num_errs = num_errs + 1; 
                     end 
                     if ((generate_parity(data_outA) ^ prty_outA) == PARITY_MODE)
                     begin
                        $display("receive_posphy_data_packet(): parity error! (ERROR)"); 
                        num_errs = num_errs + 1; 
                     end 
                     disable xhdl_8; 
                  end 
               end 
            end
         end 
         begin : xhdl_10
            while (bytes_received < packet_length)
            begin
               if (!wr_outA)
               begin
                  begin : xhdl_9
                     integer i;
                     for(i = (DATA_WIDTH / 8) - 1; i >= 0; i = i - 1)
                     begin
                        while (wr_outA)
                        begin
                           @(posedge clk_inA); 
                        end 
                        if (i == (DATA_WIDTH / 8) - 1 & sop_outA)
                        begin
                           temp_dat = {8{1'b0}}; 
                        end
                        else
                        begin
                           temp_dat = generate_incrementing_data(temp_dat); 
                           recvd_dat = data_outA >> (i*8); 
                           bytes_received = bytes_received + 1; 
                           if (recvd_dat != temp_dat)
                           begin
                              $display("receive_posphy_data_packet(): invalid data received! (ERROR)"); 
                              num_errs = num_errs + 1; 
                           end 
                           if ((generate_parity(data_outA) ^ prty_outA) == PARITY_MODE)
                           begin
                              $display("receive_posphy_data_packet(): parity error! (ERROR)"); 
                              num_errs = num_errs + 1; 
                           end 
                           if ((eop_outA) & (mod_outA == i))
                           begin
                              disable xhdl_9; 
                           end 
                        end 
                     end
                  end 
               end 
               if (eop_outA)
               begin
                  @(posedge clk_inA); 
                  disable xhdl_10; 
               end 
               @(posedge clk_inA); 
            end
         end 
         if (bytes_received != packet_length)
         begin
            $display("receive_posphy_data_packet(): wrong number of bytes in packet! (ERROR)"); 
            num_errs = num_errs + 1; 
         end 
         if (num_errs == 0)
         begin
            $display("receive_posphy_data_packet(): succesfully received packet number ", packet_number, ", length ",bytes_received," bytes."  ); 
         end
         else
         begin
            simulation_passed = 1'b0; 
         end 
         dpav_inA[0] <= 1'b0 ; 
      end
   endtask 
endmodule
