--	Copyright (C) 1988-1999 Altera Corporation

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

FUNCTION slavetx_atlantic (
					phy_tx_clk, 
					phy_tx_ena, 
					reset, 
					tx_clk, 
					tx_discard_on_error, 
					tx_enb, 
					tx_parity_check, 
					tx_phy_mode, 
					tx_prty, 
					tx_soc, 
					tx_user_width, 
					tx_ut_width, 
					tx_address[4..0], 
					tx_addr[4..0], 
					tx_data[slave_utopia_width..0], 
					tx_user_bytes[1..0]
					)
	WITH (
					slave_utopia_width,
		   			slave_user_width
					)
    RETURNS (
    				phy_tx_sop, 
    				phy_tx_eop, 
    				phy_tx_err, 
    				phy_tx_val, 
    				phy_tx_dav, 
    				tx_cell_disc_pulse, 
    				tx_cell_err_pulse, 
    				tx_cell_pulse, 
    				tx_clav, 
    				tx_clav_enb, 
    				tx_prty_pulse, 
    				phy_tx_dat[slave_user_width..0]
    				);


