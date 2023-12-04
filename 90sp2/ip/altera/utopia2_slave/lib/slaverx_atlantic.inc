--	Copyright (C) 1988-2000 Altera Corporation

--	Any megafunction design, and related net list (encrypted or decrypted),
--	support information, device programming or simulation file, and any other
--	associated documentation or information provided by Altera or a partner
--	under Altera's Megafunction Partnership Program may be used only to
--	program PLD devices (but not masked PLD devices) from Altera.  Any other
--	use of such megafunction design, net list, support information, device
--	programming or simulation file, or any other related documentation or
--	information is prohibited for any other purpose, including, but not
--	limited to modification, reverse engineering, de-compiling, or use with
--	any other silicon devices, unless such use is explicitly licensed under
--	a separate agreement with Altera or a megafunction partner.  Title to
--	the intellectual property, including patents, copyrights, trademarks,
--	trade secrets, or maskworks, embodied in any such megafunction design,
--	net list, support information, device programming or simulation file, or
--	any other related documentation or information provided by Altera or a
--	megafunction partner, remains with Altera, the megafunction partner, or
--	their respective licensors.  No other licenses, including any licenses
--	needed under any third party's intellectual property, are provided herein.

FUNCTION slaverx_atlantic 	(
					phy_rx_clk, 
					phy_rx_sop, 
					phy_rx_eop, 
					phy_rx_err, 
					phy_rx_ena, 
					reset, 
					rx_clk, 
					rx_enb, 
					rx_parity_generate, 
					rx_phy_mode, 
					rx_user_width, 
					rx_ut_width, 
					rx_address[4..0], 
					rx_addr[4..0], 
					rx_user_bytes[1..0], 
					phy_rx_dat[slave_user_width..0]
					)
	WITH 			(
				   	slave_utopia_width,
					slave_user_width
					)
    RETURNS			(
    				phy_rx_dav, 
    				rx_bus_enb, 
    				rx_clav, 
    				rx_clav_enb, 
    				rx_prty, 
    				rx_soc, 
    				rx_data[slave_utopia_width..0]
    				);

