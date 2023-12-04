//-----------------------------------------------------------------------
//-----------------------------------------------------------------------
//
// title        : reference design for pos-phy level 3 link sink (rx) top level architecture
// project      : pos-phy
//
// description	: reference design for altera pos-phy level 3 core
//
// copyright 1999, 2000 (c) altera corporation
// all rights reserved
//
//-----------------------------------------------------------------------
//-----------------------------------------------------------------------
//-----------------------------------------------------------------------
// main entity, the reference design testbench
//-----------------------------------------------------------------------
  `timescale 1ns / 1ns
module auk_pac_mrx_ref ();

   parameter dpav_width = 1; 
   parameter addr_width = 0; 
   parameter data_width = 32; 
   parameter mod_width = 2; 
   parameter custom_width = 32; 
   parameter parity_mode = 1'b1; 

   function generate_parity;
      input[data_width - 1:0] data; 

      reg result; 

      begin
         begin : xhdl_0
            integer i;
            for(i = 0; i <= data_width - 1; i = i + 1)
            begin
               result = result ^ data[i]; 
            end
         end 
         generate_parity = result; 
      end
   endfunction

   function [7:0] generate_incrementing_data;
      input[7:0] data; 

      reg[7:0] result; 

      begin
         begin : xhdl_1
               result[3:0] = data[3:0] + 1; 
               result[7:4] = data[7:4] + 1; 
         end 
         generate_incrementing_data = result; 
      end
   endfunction


   reg clk_ina; 
   reg reset_ina; 
   wire rd_outa; 
   wire sx_ina; 
   reg[data_width - 1:0] data_ina; 
   reg val_ina; 
   reg sop_ina; 
   reg eop_ina; 
   reg err_ina; 
   reg prty_ina; 
   reg[mod_width - 1:0] mod_ina; 
   reg clk_inb; 
   reg reset_inb; 
   wire dav_outb; 
   reg rd_inb; 
   wire[data_width - 1:0] data_outb; 
   wire val_outb; 
   wire sop_outb; 
   wire eop_outb; 
   wire err_outb; 
   wire prty_outb; 
   wire[mod_width - 1:0] mod_outb; 
   reg delayed_rd_inb; 


	assign sx_ina = 0;
   initial
   begin
      reset_ina <= 1'b1;

      data_ina <= 0;
      val_ina <= 1'b0;
      sop_ina <= 1'b0;
      eop_ina <= 1'b0;
      err_ina <= 1'b0;
      prty_ina <= 1'b0;
      mod_ina <= 0;
      clk_inb <= 1'b0;
      reset_inb <= 1'b1;
      rd_inb <= 1'b0;
      delayed_rd_inb <= 1'b0;
   end

   auk_pac_mrx_pl3_link mrx (
   		.a_rfclk(clk_ina), 
   		.a_rreset_n(reset_ina), 
   		.a_renb(rd_outa), 
   		.a_rval(val_ina), 
   		.a_rdat(data_ina), 
   		.a_rsop(sop_ina), 
   		.a_reop(eop_ina), 
   		.a_rerr(err_ina), 
   		.a_rprty(prty_ina), 
   		.a_rmod(mod_ina), 
   		.b_clk(clk_inb), 
   		.b_reset_n(reset_inb), 
   		.b_dav(dav_outb), 
   		.b_ena(rd_inb), 
   		.b_val(val_outb), 
   		.b_dat(data_outb), 
   		.b_sop(sop_outb), 
   		.b_eop(eop_outb), 
   		.b_err(err_outb), 
   		.b_par(prty_outb), 
   		.b_mty(mod_outb)
   		); 

   always 
   begin : pos_phy_clk_gen
      while ($time <= 50000)
      begin
         clk_ina <= 1'b0 ; 
         #5; 
         clk_ina <= 1'b1 ; 
         #5; 
      end 
      forever #100000; 
   end 

   always 
   begin : atlantic_clk_gen
      while ($time <= 50000)
      begin
         clk_inb <= 1'b0 ; 
         #5; 
         clk_inb <= 1'b1 ; 
         #5; 
      end 
      forever #100000; 
   end 

   reg[data_width - 1:0] dat; 

   always 
   begin : send_data_to_pos_phy
      reset_pulse; 
      delay_n_clocks(6); 
      generate_posphy_data_packet(0, 12); 
      delay_n_clocks(6); 
      generate_posphy_data_packet(1, 63); 
      delay_n_clocks(2); 
      generate_posphy_data_packet(2, 61); 
      delay_n_clocks(2); 
      generate_posphy_data_packet(3, 3); 
      delay_n_clocks(2); 
      generate_posphy_data_packet(4, 128); 
      generate_posphy_data_packet(5, 256); 
      forever #100000; 
   end

   task reset_pulse;

      begin
         reset_ina <= 1'b0 ; 
         @(posedge clk_ina); 
         reset_ina <= 1'b1 ; 
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
               @(posedge clk_ina); 
            end
         end 
      end
   endtask

   task generate_posphy_data_packet;
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
      reg[data_width - 1:0] dat; 
     reg[7:0] temp_dat ; 
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
            num_cycles = (packet_length * 8) / data_width; 
         end
         else
         begin
            num_cycles = 1; 
         end 
         begin : xhdl_4
            while (1'b1)
            begin
               while (rd_outa)
               begin
                  @(posedge clk_ina); 
               end 
               val = 1'b1; 
               begin : xhdl_3
                  integer i;
                  for(i = (data_width / 8) - 1; i >= 0; i = i - 1)
                  begin
//			   		$display ($time, packet_number, temp_dat2);
                     if (sop & i == (data_width / 8) - 1)
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
                      /*
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
                      */
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
                        end/*
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
                        end*/

                     end 
                     par = ^dat; 
                     temp_dat = generate_incrementing_data(temp_dat); 
                  end
               end 
//			   $display("------ packet number ", packet_number, " -- ",packet_length,bytes_sent, data_width," " ,  mty, " ", eop); 
               if (packet_length - bytes_sent <= (data_width / 8))
               begin
                  eop = 1'b1; 
                  mty = ((data_width / 8) - (packet_length % (data_width / 8))); 
//				  $display(data_width / 8," ",packet_length, " ",(packet_length % (data_width / 8)), "  -- result : ", mty );
               end 
			   else
			   begin
				 mty = 0;
			   end
               data_ina <= dat ; 
               prty_ina <= par ; 
               sop_ina <= sop ; 
               eop_ina <= eop ; 
               mod_ina <= mty ; 
               err_ina <= err ; 
               val_ina <= val ; 
               @(posedge clk_ina); 
               bytes_sent = bytes_sent + (data_width / 8 - mty); 
               if (sop)
               begin
                  sop = 1'b0; 
                  sop_ina <= sop ; 
               end 
               if (eop)
               begin
                  eop_ina <= 1'b0 ; 
                  val_ina <= 1'b0 ; 
                  mod_ina <= 0 ;
                  @(posedge clk_ina); 
                   
//				  $display("going out of the loop, bytes sent ", bytes_sent," mty : ", mty);
                  disable xhdl_4; 
               end 
            end
         end 
      end
   endtask 

   always 
   begin : pipeline_enable
      while (1'b1)
      begin
         @(posedge clk_inb); 
         delayed_rd_inb <= rd_inb ; 
      end 
   end 

   reg simulation_passed; 
      reg l; 
   always 
   begin : listen_for_data_on_atlantic
//      reg simulation_passed; 
      simulation_passed = 1'b1;
      reset_pulse_xhdl5; 
      delay_n_clocks_xhdl6(6); 
      receive_atlantic_data_packet(0, 12); 
      receive_atlantic_data_packet(1, 63); 
      receive_atlantic_data_packet(2, 61); 
      receive_atlantic_data_packet(3, 3); 
      receive_atlantic_data_packet(4, 128); 
      receive_atlantic_data_packet(5, 256); 
      if (simulation_passed)
      begin
         $display("** simulation passed **. (note)"); 
		 $stop;
      end
      else
      begin
         $display("############# simulation failed #############. (note)");
         $stop; 
      end 
      forever #100000; 
   end

   task reset_pulse_xhdl5;

      begin
         reset_inb <= 1'b0 ; 
         @(posedge clk_inb); 
         reset_inb <= 1'b1 ; 
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
               @(posedge clk_inb); 
            end
         end 
      end
   endtask

   task receive_atlantic_data_packet;
      input packet_number; 
      integer packet_number;
      input packet_length; 
      integer packet_length;

      reg[7:0] recvd_dat; 
      reg[7:0] temp_dat; 
      integer bytes_received; 
      integer num_errs; 

      begin
		bytes_received = 0;
		num_errs = 0;
        recvd_dat = 0;
        temp_dat = 0;
         begin : xhdl_8
//		$display (bytes_received , packet_length);
            while (bytes_received < packet_length)
            begin
               if (dav_outb)
               begin
                  rd_inb <= 1'b1 ; 
               end
               else
               begin
                  rd_inb <= 1'b0 ; 
               end 
               if (val_outb & delayed_rd_inb)
               begin
                  if (!sop_outb)
                  begin
                     $display("receive_atlantic_data_packet(): missing sop signal! (error)"); 
                     num_errs = num_errs + 1; 
                  end
                  else
                  begin
                     temp_dat = packet_number; 
                     recvd_dat = data_outb[data_width - 1:data_width - 8]; 
                     bytes_received = bytes_received + 1; 
                     if (recvd_dat != temp_dat)
                     begin
                        $display("receive_atlantic_data_packet(): invalid packet number! (error)"); 
                        num_errs = num_errs + 1; 
                     end 
                     if (^data_outb ^ prty_outb == parity_mode)
                     begin
                        $display("receive_atlantic_data_packet(): parity error! (error)"); 
                        num_errs = num_errs + 1; 
                     end 
                     disable xhdl_8; 
                  end 
               end 
               @(posedge clk_inb); 
            end
         end 
         begin : xhdl_10
            while (1'b1)
            begin
               if (dav_outb)
               begin
                  rd_inb <= 1'b1 ; 
               end
               else
               begin
                  rd_inb <= 1'b0 ; 
               end 
               if (val_outb & delayed_rd_inb)
               begin
                  begin : xhdl_9
                     integer i;
//					 $display($time, "valoutb and delayed ", data_outb);
                     for(i = (data_width / 8) - 1; i >= 0; i = i - 1)
                     begin
                        if (i == (data_width / 8) - 1 & sop_outb)
                        begin
                           temp_dat = 0; 
                        end
                        else
                        begin
                           temp_dat = generate_incrementing_data(temp_dat); 
//                           recvd_dat = data_outb[(i * 8) + 7:(i * 8) + 0]; 
                           recvd_dat = data_outb >> (i*8); 
                           bytes_received = bytes_received + 1; 
                           if (recvd_dat != temp_dat)
                           begin
                              $display("receive_atlantic_data_packet(): invalid data received! (error)"); 
                              num_errs = num_errs + 1; 
                           end 
                           if ((generate_parity(data_outb) ^ prty_outb) == parity_mode)
                           begin
                              $display("receive_atlantic_data_packet(): parity error! (error)"); 
                              num_errs = num_errs + 1; 
                           end 
                           if ((eop_outb) & (mod_outb == i))
                           begin
                              disable xhdl_9; 
                           end 
                        end 
                     end
                  end 
               end 
               if (eop_outb)
               begin
                  @(posedge clk_inb); 
                  disable xhdl_10; 
               end 
               @(posedge clk_inb); 
            end
         end 
         if (bytes_received != packet_length)
         begin
            $display("receive_atlantic_data_packet(): wrong number of bytes in packet! (error)",bytes_received, " ",  packet_length); 
            num_errs = num_errs + 1; 
         end 
         if (num_errs == 0)
         begin
            $display("receive_atlantic_data_packet(): succesfully received packet number ", packet_number, ", length ", bytes_received," bytes." ); 
         end
         else
         begin
            simulation_passed = 1'b0; 
         end 
      end
   endtask 
endmodule
