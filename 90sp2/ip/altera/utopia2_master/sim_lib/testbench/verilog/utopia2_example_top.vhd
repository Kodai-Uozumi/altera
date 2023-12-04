----------------------------------------------------------------------------
--  Utopia Level 2 MegaCore System Demonstration Testbench
----------------------------------------------------------------------------
--  Revision History:
--
--  V2.0     January 2004  Second Version
--
----------------------------------------------------------------------------
--  This testbench instantiates the Utopia Slave Rx & Tx MegaCores,
--  the Utopia Master Rx & Tx MegaCores,and provides a simple stimulus
--  to transmit/receive atm cells between these MegaCores.
--  The configuration of the testbench is by setting the 'generic's to the
--  desired values to simulate a particular Utopia bus architecture.
--
--  The default configuration is
--      - 1 Master (Rx/Tx) (fixed)
--      - 2 Slaves (Rx/Tx)
--      - MPHY mode
--      - 16 bit Utopia Bus
--      - 50MHz Utopia Clock
--      - 8 bit Slave User Bus
--      - 50MHz Slave User Bus Clock
--
----------------------------------------------------------------------------
--
--	Copyright (C) 1988-2004 Altera Corporation
--
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
----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity utopia2_example_top is 
port (
	
rx_clk              : in     std_logic;
tx_clk              : in     std_logic;
phy_rx_clk          : in     std_logic;
phy_tx_clk          : in     std_logic;
reset               : in     std_logic;
	
	
	
masterrx_atm_rx_data         : out    std_logic_vector(15 downto 0);
masterrx_atm_rx_soc          : out    std_logic;
masterrx_atm_rx_valid        : out    std_logic;
masterrx_atm_rx_enb          : in     std_logic;
masterrx_atm_rx_port         : in     std_logic_vector(4 downto 0);
masterrx_atm_rx_port_load    : in     std_logic;
masterrx_atm_rx_port_wait    : out    std_logic;
masterrx_atm_rx_port_stat    : out    std_logic_vector(30 downto 0);
masterrx_rx_data             : in     std_logic_vector(15 downto 0);
masterrx_rx_soc              : in     std_logic;
masterrx_rx_enb              : out    std_logic;
masterrx_rx_clav             : in     std_logic;
masterrx_rx_prty             : in     std_logic;
masterrx_rx_addr             : out    std_logic_vector(4 downto 0);
masterrx_rx_prty_pulse       : out    std_logic;
masterrx_rx_cell_pulse       : out    std_logic;
masterrx_rx_cell_err_pulse   : out    std_logic;

mastertx_atm_tx_data         : in     std_logic_vector(15 downto 0);
mastertx_atm_tx_soc          : in     std_logic;
mastertx_atm_tx_valid        : in     std_logic;
mastertx_atm_tx_enb          : out    std_logic;
mastertx_atm_tx_port         : in     std_logic_vector(4 downto 0);
mastertx_atm_tx_port_load    : in     std_logic;
mastertx_atm_tx_port_wait    : out    std_logic;
mastertx_atm_tx_port_stat    : out    std_logic_vector(30 downto 0);
mastertx_tx_data             : out    std_logic_vector(15 downto 0);
mastertx_tx_soc              : out    std_logic;
mastertx_tx_enb              : out    std_logic;
mastertx_tx_clav             : in     std_logic;
mastertx_tx_prty             : out    std_logic;
mastertx_tx_addr             : out    std_logic_vector(4 downto 0);
	

slavetx0_tx_data             : in     std_logic_vector(15 downto 0);
slavetx0_tx_soc              : in     std_logic;
slavetx0_tx_enb              : in     std_logic;
slavetx0_tx_clav             : out    std_logic;
slavetx0_tx_clav_enb         : out    std_logic;
slavetx0_tx_prty             : in     std_logic;
slavetx0_tx_addr             : in     std_logic_vector(4 downto 0);
slavetx0_phy_tx_data         : out    std_logic_vector(15 downto 0);
slavetx0_phy_tx_soc          : out    std_logic;
slavetx0_phy_tx_valid        : out    std_logic;
slavetx0_phy_tx_enb          : in     std_logic;
slavetx0_phy_tx_fifo_full    : out    std_logic;
slavetx0_tx_cell_pulse       : out    std_logic;
slavetx0_tx_prty_pulse       : out    std_logic;
slavetx0_tx_cell_err_pulse   : out    std_logic;
slavetx0_tx_cell_disc_pulse  : out    std_logic;
slavetx0_phy_tx_clav         : out    std_logic;

slavetx1_tx_data             : in     std_logic_vector(15 downto 0);
slavetx1_tx_soc              : in     std_logic;
slavetx1_tx_enb              : in     std_logic;
slavetx1_tx_clav             : out    std_logic;
slavetx1_tx_clav_enb         : out    std_logic;
slavetx1_tx_prty             : in     std_logic;
slavetx1_tx_addr             : in     std_logic_vector(4 downto 0);
slavetx1_phy_tx_data         : out    std_logic_vector(15 downto 0);
slavetx1_phy_tx_soc          : out    std_logic;
slavetx1_phy_tx_valid        : out    std_logic;
slavetx1_phy_tx_enb          : in     std_logic;
slavetx1_phy_tx_fifo_full    : out    std_logic;
slavetx1_tx_cell_pulse       : out    std_logic;
slavetx1_tx_prty_pulse       : out    std_logic;
slavetx1_tx_cell_err_pulse   : out    std_logic;
slavetx1_tx_cell_disc_pulse  : out    std_logic;
slavetx1_phy_tx_clav         : out    std_logic;

slaverx0_rx_data             : out    std_logic_vector(15 downto 0);
slaverx0_rx_soc              : out    std_logic;
slaverx0_rx_enb              : in     std_logic;
slaverx0_rx_clav             : out    std_logic;
slaverx0_rx_clav_enb         : out    std_logic;
slaverx0_rx_prty             : out    std_logic;
slaverx0_rx_addr             : in     std_logic_vector(4 downto 0);
slaverx0_phy_rx_data         : in     std_logic_vector(15 downto 0);
slaverx0_phy_rx_soc          : in     std_logic;
slaverx0_phy_rx_valid        : in     std_logic;
slaverx0_phy_rx_enb          : out    std_logic;
slaverx0_rx_bus_enb          : out    std_logic;
slaverx0_phy_rx_clav         : out    std_logic;

slaverx1_rx_data             : out    std_logic_vector(15 downto 0);
slaverx1_rx_soc              : out    std_logic;
slaverx1_rx_enb              : in     std_logic;
slaverx1_rx_clav             : out    std_logic;
slaverx1_rx_clav_enb         : out    std_logic;
slaverx1_rx_prty             : out    std_logic;
slaverx1_rx_addr             : in     std_logic_vector(4 downto 0);
slaverx1_phy_rx_data         : in     std_logic_vector(15 downto 0);
slaverx1_phy_rx_soc          : in     std_logic;
slaverx1_phy_rx_valid        : in     std_logic;
slaverx1_phy_rx_enb          : out    std_logic;
slaverx1_rx_bus_enb          : out    std_logic;
slaverx1_phy_rx_clav         : out    std_logic

	
);
  end;

architecture rtl of utopia2_example_top is


  -------------------------------------------------------------------------
  -- Component declaration of Utopia Master Rx Megafunction
  -------------------------------------------------------------------------
  component masterrx_example
      port(
          atm_rx_data         : out    std_logic_vector(15 downto 0);
          atm_rx_soc          : out    std_logic;
          atm_rx_valid        : out    std_logic;
          atm_rx_enb          : in     std_logic;

          atm_rx_port         : in     std_logic_vector(4 downto 0);
          atm_rx_port_load    : in     std_logic;
          atm_rx_port_wait    : out    std_logic;
          atm_rx_port_stat    : out    std_logic_vector(30 downto 0);

          rx_data             : in     std_logic_vector(15 downto 0);
          rx_soc              : in     std_logic;
          rx_enb              : out    std_logic;
          rx_clav             : in     std_logic;
          rx_prty             : in     std_logic;
          rx_addr             : out    std_logic_vector(4 downto 0);

          rx_prty_pulse       : out    std_logic;
          rx_cell_pulse       : out    std_logic;
          rx_cell_err_pulse   : out    std_logic;

          rx_clk_in           : in     std_logic;
          reset               : in     std_logic
      );
  end component;



  -------------------------------------------------------------------------
  -- Component declaration of Utopia Master Tx Megafunction
  -------------------------------------------------------------------------
  component mastertx_example
      port(
          atm_tx_data         : in     std_logic_vector(15 downto 0);
          atm_tx_soc          : in     std_logic;
          atm_tx_valid        : in     std_logic;
          atm_tx_enb          : out    std_logic;

          atm_tx_port         : in     std_logic_vector(4 downto 0);
          atm_tx_port_load    : in     std_logic;
          atm_tx_port_wait    : out    std_logic;
          atm_tx_port_stat    : out    std_logic_vector(30 downto 0);

          tx_data             : out    std_logic_vector(15 downto 0);
          tx_soc              : out    std_logic;
          tx_enb              : out    std_logic;
          tx_clav             : in     std_logic;
          tx_prty             : out    std_logic;
          tx_addr             : out    std_logic_vector(4 downto 0);


          tx_clk_in           : in     std_logic;
          reset               : in     std_logic
      );
  end component;




  -------------------------------------------------------------------------
  -- Component declaration of Utopia Slave Tx Megafunction
  -------------------------------------------------------------------------
  component slavetx0_example
      port(
          reset               : in     std_logic;
          tx_clk              : in     std_logic;
          tx_data             : in     std_logic_vector(15 downto 0);
          tx_soc              : in     std_logic;
          tx_enb              : in     std_logic;
          tx_clav             : out    std_logic;
          tx_clav_enb         : out    std_logic;
          tx_prty             : in     std_logic;
          tx_addr             : in     std_logic_vector(4 downto 0);
          phy_tx_clk          : in     std_logic;
          phy_tx_data         : out    std_logic_vector(15 downto 0);
          phy_tx_soc          : out    std_logic;
          phy_tx_valid        : out    std_logic;
          phy_tx_enb          : in     std_logic;
          phy_tx_fifo_full    : out    std_logic;
          tx_cell_pulse       : out    std_logic;
          tx_prty_pulse       : out    std_logic;
          tx_cell_err_pulse   : out    std_logic;
          tx_cell_disc_pulse  : out    std_logic;
          phy_tx_clav         : out    std_logic
      );
  end component;

  component slavetx1_example
      port(
          reset               : in     std_logic;
          tx_clk              : in     std_logic;
          tx_data             : in     std_logic_vector(15 downto 0);
          tx_soc              : in     std_logic;
          tx_enb              : in     std_logic;
          tx_clav             : out    std_logic;
          tx_clav_enb         : out    std_logic;
          tx_prty             : in     std_logic;
          tx_addr             : in     std_logic_vector(4 downto 0);
          phy_tx_clk          : in     std_logic;
          phy_tx_data         : out    std_logic_vector(15 downto 0);
          phy_tx_soc          : out    std_logic;
          phy_tx_valid        : out    std_logic;
          phy_tx_enb          : in     std_logic;
          phy_tx_fifo_full    : out    std_logic;
          tx_cell_pulse       : out    std_logic;
          tx_prty_pulse       : out    std_logic;
          tx_cell_err_pulse   : out    std_logic;
          tx_cell_disc_pulse  : out    std_logic;
          phy_tx_clav         : out    std_logic
      );
  end component;
  
  -------------------------------------------------------------------------
  -- Component declaration of Utopia Slave Rx Megafunction
  -------------------------------------------------------------------------
  component slaverx0_example
      port(
          reset               : in     std_logic;
          rx_clk              : in     std_logic;
          rx_data             : out    std_logic_vector(15 downto 0);
          rx_soc              : out    std_logic;
          rx_enb              : in     std_logic;
          rx_clav             : out    std_logic;
          rx_clav_enb         : out    std_logic;
          rx_prty             : out    std_logic;
          rx_addr             : in     std_logic_vector(4 downto 0);
          phy_rx_clk          : in     std_logic;
          phy_rx_data         : in     std_logic_vector(15 downto 0);
          phy_rx_soc          : in     std_logic;
          phy_rx_valid        : in     std_logic;
          phy_rx_enb          : out    std_logic;
          rx_bus_enb          : out    std_logic;
          phy_rx_clav         : out    std_logic
      );
  end component;

  component slaverx1_example
      port(
          reset               : in     std_logic;
          rx_clk              : in     std_logic;
          rx_data             : out    std_logic_vector(15 downto 0);
          rx_soc              : out    std_logic;
          rx_enb              : in     std_logic;
          rx_clav             : out    std_logic;
          rx_clav_enb         : out    std_logic;
          rx_prty             : out    std_logic;
          rx_addr             : in     std_logic_vector(4 downto 0);
          phy_rx_clk          : in     std_logic;
          phy_rx_data         : in     std_logic_vector(15 downto 0);
          phy_rx_soc          : in     std_logic;
          phy_rx_valid        : in     std_logic;
          phy_rx_enb          : out    std_logic;
          rx_bus_enb          : out    std_logic;
          phy_rx_clav         : out    std_logic
      );
  end component;
  
















------------------------------
begin

  masterrx_example_dut : masterrx_example
      port map (
          atm_rx_data         => masterrx_atm_rx_data         ,
          atm_rx_soc          => masterrx_atm_rx_soc          ,
          atm_rx_valid        => masterrx_atm_rx_valid        ,
          atm_rx_enb          => masterrx_atm_rx_enb          ,
                              
          atm_rx_port         => masterrx_atm_rx_port         ,
          atm_rx_port_load    => masterrx_atm_rx_port_load    ,
          atm_rx_port_wait    => masterrx_atm_rx_port_wait    ,
          atm_rx_port_stat    => masterrx_atm_rx_port_stat    ,
                              
          rx_data             => masterrx_rx_data             ,
          rx_soc              => masterrx_rx_soc              ,
          rx_enb              => masterrx_rx_enb              ,
          rx_clav             => masterrx_rx_clav             ,
          rx_prty             => masterrx_rx_prty             ,
          rx_addr             => masterrx_rx_addr             ,
                              
          rx_prty_pulse       => masterrx_rx_prty_pulse       ,
          rx_cell_pulse       => masterrx_rx_cell_pulse       ,
          rx_cell_err_pulse   => masterrx_rx_cell_err_pulse   ,

          rx_clk_in           => rx_clk,
          reset               => reset
      );
  



  -------------------------------------------------------------------------
  -- Component declaration of Utopia Master Tx Megafunction
  -------------------------------------------------------------------------
  mastertx_example_dut : mastertx_example
      port map(
          atm_tx_data         => mastertx_atm_tx_data         ,
          atm_tx_soc          => mastertx_atm_tx_soc          ,
          atm_tx_valid        => mastertx_atm_tx_valid        ,
          atm_tx_enb          => mastertx_atm_tx_enb          ,
                              
          atm_tx_port         => mastertx_atm_tx_port         ,
          atm_tx_port_load    => mastertx_atm_tx_port_load    ,
          atm_tx_port_wait    => mastertx_atm_tx_port_wait    ,
          atm_tx_port_stat    => mastertx_atm_tx_port_stat    ,
                              
          tx_data             => mastertx_tx_data             ,
          tx_soc              => mastertx_tx_soc              ,
          tx_enb              => mastertx_tx_enb              ,
          tx_clav             => mastertx_tx_clav             ,
          tx_prty             => mastertx_tx_prty             ,
          tx_addr             => mastertx_tx_addr             ,
                              
                              
          tx_clk_in           => tx_clk           ,
          reset               => reset               
      );
  




  -------------------------------------------------------------------------
  -- Component declaration of Utopia Slave Tx Megafunction
  -------------------------------------------------------------------------
  slavetx0_example_dut :  slavetx0_example
      port map (
          reset               => reset               ,
          tx_clk              => tx_clk              ,
          tx_data             => slavetx0_tx_data             ,
          tx_soc              => slavetx0_tx_soc              ,
          tx_enb              => slavetx0_tx_enb              ,
          tx_clav             => slavetx0_tx_clav             ,
          tx_clav_enb         => slavetx0_tx_clav_enb         ,
          tx_prty             => slavetx0_tx_prty             ,
          tx_addr             => slavetx0_tx_addr             ,
          phy_tx_clk          => phy_tx_clk          ,
          phy_tx_data         => slavetx0_phy_tx_data         ,
          phy_tx_soc          => slavetx0_phy_tx_soc          ,
          phy_tx_valid        => slavetx0_phy_tx_valid        ,
          phy_tx_enb          => slavetx0_phy_tx_enb          ,
          phy_tx_fifo_full    => slavetx0_phy_tx_fifo_full    ,
          tx_cell_pulse       => slavetx0_tx_cell_pulse       ,
          tx_prty_pulse       => slavetx0_tx_prty_pulse       ,
          tx_cell_err_pulse   => slavetx0_tx_cell_err_pulse   ,
          tx_cell_disc_pulse  => slavetx0_tx_cell_disc_pulse  ,
          phy_tx_clav         => slavetx0_phy_tx_clav         
      );
  

  slavetx1_example_dut :  slavetx1_example
      port map (
          reset               => reset             ,
          tx_clk              => tx_clk            ,
          tx_data             => slavetx1_tx_data           ,
          tx_soc              => slavetx1_tx_soc            ,
          tx_enb              => slavetx1_tx_enb            ,
          tx_clav             => slavetx1_tx_clav           ,
          tx_clav_enb         => slavetx1_tx_clav_enb       ,
          tx_prty             => slavetx1_tx_prty           ,
          tx_addr             => slavetx1_tx_addr           ,
          phy_tx_clk          => phy_tx_clk        ,
          phy_tx_data         => slavetx1_phy_tx_data       ,
          phy_tx_soc          => slavetx1_phy_tx_soc        ,
          phy_tx_valid        => slavetx1_phy_tx_valid      ,
          phy_tx_enb          => slavetx1_phy_tx_enb        ,
          phy_tx_fifo_full    => slavetx1_phy_tx_fifo_full  ,
          tx_cell_pulse       => slavetx1_tx_cell_pulse     ,
          tx_prty_pulse       => slavetx1_tx_prty_pulse     ,
          tx_cell_err_pulse   => slavetx1_tx_cell_err_pulse ,
          tx_cell_disc_pulse  => slavetx1_tx_cell_disc_pulse,
          phy_tx_clav         => slavetx1_phy_tx_clav       
      );
  
  
  -------------------------------------------------------------------------
  -- Component declaration of Utopia Slave Rx Megafunction
  -------------------------------------------------------------------------
  slaverx0_example_dut :  slaverx0_example
      port map (
          reset               => reset           ,
          rx_clk              => rx_clk          ,
          rx_data             => slaverx0_rx_data         ,
          rx_soc              => slaverx0_rx_soc          ,
          rx_enb              => slaverx0_rx_enb          ,
          rx_clav             => slaverx0_rx_clav         ,
          rx_clav_enb         => slaverx0_rx_clav_enb     ,
          rx_prty             => slaverx0_rx_prty         ,
          rx_addr             => slaverx0_rx_addr         ,
          phy_rx_clk          => phy_rx_clk      ,
          phy_rx_data         => slaverx0_phy_rx_data     ,
          phy_rx_soc          => slaverx0_phy_rx_soc      ,
          phy_rx_valid        => slaverx0_phy_rx_valid    ,
          phy_rx_enb          => slaverx0_phy_rx_enb      ,
          rx_bus_enb          => slaverx0_rx_bus_enb      ,
          phy_rx_clav         => slaverx0_phy_rx_clav     
      );
  

  slaverx1_example_dut :  slaverx1_example
      port map(
          reset               => reset             ,
          rx_clk              => rx_clk            ,
          rx_data             => slaverx1_rx_data           ,
          rx_soc              => slaverx1_rx_soc            ,
          rx_enb              => slaverx1_rx_enb            ,
          rx_clav             => slaverx1_rx_clav           ,
          rx_clav_enb         => slaverx1_rx_clav_enb       ,
          rx_prty             => slaverx1_rx_prty           ,
          rx_addr             => slaverx1_rx_addr           ,
          phy_rx_clk          => phy_rx_clk        ,
          phy_rx_data         => slaverx1_phy_rx_data       ,
          phy_rx_soc          => slaverx1_phy_rx_soc        ,
          phy_rx_valid        => slaverx1_phy_rx_valid      ,
          phy_rx_enb          => slaverx1_phy_rx_enb        ,
          rx_bus_enb          => slaverx1_rx_bus_enb        ,
          phy_rx_clav         => slaverx1_phy_rx_clav       
      );
  

end  rtl;


 
 
  
  
  

  
  
  
