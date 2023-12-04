----------------------------------------------------------------------------
--  Utopia Level 2 MegaCore System Demonstration Testbench
----------------------------------------------------------------------------
--  Revision History:
--
--  V1.1     August 2002   First Version
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
--	Copyright (C) 1988-1999 Altera Corporation
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
use Std.Textio.all;
use work.master_tb_pack.all;
use work.all;
library altutm;
library altuts;

entity master_atlantic_tb is 
  generic ( UtCellSize          : integer := 54;
            UtBusWidth          : integer := 16;
            MasterUserCellSize  : integer := 54;
            UserCellSize        : integer := 54;
            UserBusWidth        : integer := 16;
            ParityEnable        : boolean := true;
            UtopiaClockPeriod   : time    := 20 ns;
            PhyClockPeriod      : time    := 20 ns;
            PHYMode             : string := "MPHY";
            num_slaves          : integer := 2
  
          );
  end;

architecture bench of master_atlantic_tb is

signal temp1 :std_logic;
signal temp2 :std_logic;
signal temp3 :integer;
signal AtmPauseCount : integer;
signal AtmTxValidVar : std_logic;
signal AtmCurrentCell : arr_integer;  
signal NextAtmCurrentCell : arr_integer;  
signal AtmCellINdex : integer;  
signal NextAtmCellINdex : integer;  
signal port_toggle : arr_integer;
signal tog_in : integer;
signal tog_out : integer;
signal nexttog_out : integer;
signal CellPattern : integer;
signal NextCellPattern : integer;
signal error_slave : arr_integer;
signal error_master : integer := 0;

  -------------------------------------------------------------------------
  -- Component declaration of Utopia Master Rx Megafunction
  -------------------------------------------------------------------------
  component masterrx
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

          rx_phy_mode         : in     std_logic_vector(1 downto 0);
          rx_user_bytes       : in     std_logic;
          rx_width            : in     std_logic;
          atm_rx_pipe_mode    : in     std_logic;
          rx_parity_check     : in     std_logic;
          rx_addr_range       : in     std_logic_vector(4 downto 0);
          rx_tt_en            : in     std_logic;
          rx_tt_mode          : in     std_logic;
          rx_tt_write         : in     std_logic;
          rx_tt_addr          : in     std_logic_vector(4 downto 0);
          rx_tt_data          : in     std_logic_vector(4 downto 0);
          rx_cell_adjust      : in     std_logic_vector(3 downto 0);

          rx_clk_in           : in     std_logic;
          reset               : in     std_logic
      );
  end component;



  -------------------------------------------------------------------------
  -- Component declaration of Utopia Master Tx Megafunction
  -------------------------------------------------------------------------
  component mastertx
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

          tx_phy_mode         : in     std_logic_vector(1 downto 0);
          tx_user_bytes       : in     std_logic;
          tx_width            : in     std_logic;
          atm_tx_pipe_mode    : in     std_logic;
          tx_parity_generate  : in     std_logic;
          tx_addr_range       : in     std_logic_vector(4 downto 0);
          tx_tt_en            : in     std_logic;
          tx_tt_mode          : in     std_logic;
          tx_tt_write         : in     std_logic;
          tx_tt_addr          : in     std_logic_vector(4 downto 0);
          tx_tt_data          : in     std_logic_vector(4 downto 0);
          tx_cell_adjust      : in     std_logic_vector(3 downto 0);

          tx_clk_in           : in     std_logic;
          reset               : in     std_logic
      );
  end component;




  -------------------------------------------------------------------------
  -- Component declaration of Utopia Slave Tx Megafunction
  -------------------------------------------------------------------------
  component slavetx_atlantic
    generic 
      (
          slave_utopia_width  : integer;
          slave_user_width    : integer
      );
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
          phy_tx_dat          : out    std_logic_vector(15 downto 0);
          phy_tx_sop          : out    std_logic;
          phy_tx_eop          : out    std_logic;
          phy_tx_val          : out    std_logic;
          phy_tx_ena          : in     std_logic;
          phy_tx_err          : out    std_logic;
          tx_phy_mode         : in     std_logic;
          tx_ut_width         : in     std_logic;
          tx_address          : in     std_logic_vector(4 downto 0);
          tx_discard_on_error : in     std_logic;
          tx_user_width       : in     std_logic;
          tx_user_bytes       : in     std_logic_vector(1 downto 0);
          tx_parity_check     : in     std_logic;
          tx_cell_pulse       : out    std_logic;
          tx_prty_pulse       : out    std_logic;
          tx_cell_err_pulse   : out    std_logic;
          tx_cell_disc_pulse  : out    std_logic;
          tx_cell_adjust      : in     std_logic_vector(3 downto 0);
          phy_tx_dav         : out    std_logic
      );
  end component;
  
  -------------------------------------------------------------------------
  -- Component declaration of Utopia Slave Rx Megafunction
  -------------------------------------------------------------------------
  component slaverx_atlantic
      generic (
          slave_utopia_width  : integer;
          slave_user_width    : integer
          );

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
          rx_phy_mode         : in     std_logic;
          rx_ut_width         : in     std_logic;
          rx_address          : in     std_logic_vector(4 downto 0);
          phy_rx_clk          : in     std_logic;
          phy_rx_dat          : in     std_logic_vector(15 downto 0);
          phy_rx_sop          : in     std_logic;
          phy_rx_eop          : in     std_logic;
          phy_rx_err          : in     std_logic;
          phy_rx_ena          : in     std_logic;
          rx_user_width       : in     std_logic;
          rx_user_bytes       : in     std_logic_vector(1 downto 0);
          rx_parity_generate  : in     std_logic;
          rx_bus_enb          : out    std_logic;
          rx_cell_adjust      : in     std_logic_vector(3 downto 0);
          phy_rx_dav          : out    std_logic
      );
  end component;
  
  component slave_user_if
      generic ( UserCellSize        : integer;
                UserBusWidth        : integer;
                UserBusSize         : integer;
                ParityEnable        : boolean;
                THold               : time;
                UtBusSize           : integer;
                MasterUserCellSize  : integer
              );

      port(
          reset               : in     std_logic;
          phy_tx_clk          : in     std_logic;
          phy_tx_data         : in     std_logic_vector(15 downto 0);
          phy_tx_soc          : in     std_logic;
          phy_tx_valid        : in     std_logic;
          phy_tx_enb          : buffer std_logic;
          phy_tx_fifo_full    : in     std_logic;
          tx_address          : in     std_logic_vector(4 downto 0);
          tx_discard_on_error : in     std_logic;
          tx_cell_pulse       : in     std_logic;
          tx_prty_pulse       : in     std_logic;
          tx_cell_err_pulse   : in     std_logic;
          tx_cell_disc_pulse  : in     std_logic;
          rx_address          : in     std_logic_vector(4 downto 0);
          phy_rx_clk          : in     std_logic;
          phy_rx_data         : out    std_logic_vector(15 downto 0);
          phy_rx_soc          : out    std_logic;
          phy_rx_valid        : out    std_logic;
          phy_rx_enb          : in     std_logic;
          error_found         : out    integer
          );

  end component;


  constant      UtBusSize           : integer := UtBusWidth / 8;
  constant      UserBusSize         : integer := UserBusWidth / 8;
  type          DATA_BUS_ARRAY      is array (1 to num_slaves) of std_logic_vector(15 downto 0);
  type          ADDRESS_ARRAY       is array (1 to num_slaves) of std_logic_vector(4 downto 0);


--------------------------------------------------------------
-- Signals for interfacing to the Utopia Master Rx
--------------------------------------------------------------
  signal        atm_rx_data         : std_logic_vector(15 downto 0);
  signal        atm_rx_soc          : std_logic;
  signal        atm_rx_valid        : std_logic;
  signal        atm_rx_enb          : std_logic;

  signal        atm_rx_port         : std_logic_vector(4 downto 0);
  signal        atm_rx_port_load    : std_logic;
  signal        atm_rx_port_wait    : std_logic;
  signal        atm_rx_port_stat    : std_logic_vector(30 downto 0);


  signal        rx_prty_pulse       : std_logic;
  signal        master_rx_cell_pulse: std_logic;
  signal        rx_cell_err_pulse   : std_logic;

  signal        rx_clk_in           : std_logic;

  -- Config
  signal        master_rx_phy_mode  : std_logic_vector(1 downto 0);
  signal        master_rx_user_bytes: std_logic;
  signal        rx_width            : std_logic;
  signal        rx_parity_check     : std_logic;
  signal        rx_addr_range       : std_logic_vector(4 downto 0);
  signal        rx_tt_en            : std_logic := '0';
  signal        rx_tt_mode          : std_logic := '0';
  signal        rx_tt_write         : std_logic;
  signal        rx_tt_addr          : std_logic_vector(4 downto 0);
  signal        rx_tt_data          : std_logic_vector(4 downto 0);



--------------------------------------------------------------
-- Signals for interfacing to the Utopia Master Tx
--------------------------------------------------------------
  signal        atm_tx_data         : std_logic_vector(15 downto 0);
  signal        atm_tx_soc          : std_logic;
  signal        atm_tx_valid        : std_logic;
  signal        atm_tx_enb          : std_logic;

  signal        atm_tx_port         : std_logic_vector(4 downto 0);
  signal        atm_tx_port_load    : std_logic;
  signal        atm_tx_port_wait    : std_logic;
  signal        atm_tx_port_stat    : std_logic_vector(30 downto 0);

  signal        tx_clk_in           : std_logic;

  -- Config
  signal        master_tx_phy_mode  : std_logic_vector(1 downto 0);
  signal        master_tx_user_bytes: std_logic;
  signal        tx_width            : std_logic;
  signal        tx_parity_generate  : std_logic;
  signal        tx_addr_range       : std_logic_vector(4 downto 0);
  signal        tx_tt_en            : std_logic := '0';
  signal        tx_tt_mode          : std_logic := '0';
  signal        tx_tt_write         : std_logic;
  signal        tx_tt_addr          : std_logic_vector(4 downto 0);
  signal        tx_tt_data          : std_logic_vector(4 downto 0);

--------------------------------------------------------------
-- Signals for interfacing to the Utopia Slave Tx
--------------------------------------------------------------
  signal        reset               : std_logic := '0';
  signal        tx_clk              : std_logic := '0';
  signal        tx_data             : std_logic_vector(15 downto 0):= (others => '0');
  signal        tx_soc              : std_logic := '0';
  signal        tx_enb              : std_logic := '1';
  signal        tx_clav             : std_logic_vector(1 to num_slaves);
  signal        tx_clav_tri         : std_logic;
  signal        tx_clav_enb         : std_logic_vector(1 to num_slaves);
  signal        tx_prty             : std_logic := '0';
  signal        tx_addr             : std_logic_vector(4 downto 0) := "11111";
  signal        phy_tx_clk          : std_logic := '0';
  signal        phy_tx_data         : DATA_BUS_ARRAY;
  signal        phy_tx_soc          : std_logic_vector(1 to num_slaves);
  signal        phy_tx_eop          : std_logic_vector(1 to num_slaves);
  signal        phy_tx_err          : std_logic_vector(1 to num_slaves);
  signal        phy_tx_valid        : std_logic_vector(1 to num_slaves);
  signal        phy_tx_enb          : std_logic_vector(1 to num_slaves) := (others => '0');
  signal        phy_tx_fifo_full    : std_logic_vector(1 to num_slaves);
  signal        phy_tx_fifo_empty   : std_logic_vector(1 to num_slaves);
  signal        phy_tx_prty_error   : std_logic_vector(1 to num_slaves);
  signal        tx_cell_pulse       : std_logic_vector(1 to num_slaves);
  signal        tx_prty_pulse       : std_logic_vector(1 to num_slaves);
  signal        tx_cell_err_pulse   : std_logic_vector(1 to num_slaves);
  signal        tx_cell_disc_pulse  : std_logic_vector(1 to num_slaves);

  -- Config
  signal        tx_user_width       : std_logic;
  signal        tx_ut_width         : std_logic;
  signal        tx_address          : ADDRESS_ARRAY;
  signal        tx_discard_on_error : std_logic := '0';       -- No discard
  signal        slave_tx_user_bytes : std_logic_vector(1 downto 0);
  signal        slave_tx_phy_mode   : std_logic;
  signal        tx_parity_check     : std_logic;



--------------------------------------------------------------
-- Signals for interfacing to the Utopia Slave Rx
--------------------------------------------------------------
  signal        rx_clk              : std_logic := '0';
  signal        rx_addr             : std_logic_vector(4 downto 0) := "11111";
  signal        rx_enb              : std_logic := '1';

  signal        rx_data             : DATA_BUS_ARRAY;
  signal        rx_data_tri         : std_logic_vector(15 downto 0);
  signal        rx_soc              : std_logic_vector(1 to num_slaves);
  signal        rx_soc_tri          : std_logic;
  signal        rx_clav             : std_logic_vector(1 to num_slaves);
  signal        rx_clav_tri         : std_logic;
  signal        rx_clav_enb         : std_logic_vector(1 to num_slaves);
  signal        rx_prty             : std_logic_vector(1 to num_slaves);
  signal        rx_prty_tri         : std_logic;
  signal        rx_bus_enb          : std_logic_vector(1 to num_slaves);

  signal        slave_rx_cell_pulse : std_logic_vector(1 to num_slaves);

  signal        phy_rx_clk          : std_logic := '0';

  signal        phy_rx_data         : DATA_BUS_ARRAY := ( others => (others => '0'));
  signal        phy_rx_soc          : std_logic_vector(1 to num_slaves) := (others => '0');
  signal        phy_rx_valid        : std_logic_vector(1 to num_slaves) := (others => '0');
  signal        phy_rx_enb          : std_logic_vector(1 to num_slaves) := (others => '1');
  signal        phy_rx_dav          : std_logic_vector(1 to num_slaves);
  signal        phy_zero            : std_logic := '0';
  -- Config
  signal        rx_address          : ADDRESS_ARRAY;
  signal        slave_rx_phy_mode   : std_logic;
  signal        rx_ut_width         : std_logic;
  signal        rx_user_width       : std_logic;
  signal        slave_rx_user_bytes : std_logic_vector(1 downto 0);
  signal        rx_parity_generate  : std_logic;

  -- Utopia Slave TX Testbench Signals
  signal        TxAddressPhaseNext  : std_logic;
  signal        TxPollActiveAddress : std_logic;
  signal        TxClavStatus        : std_logic;
  signal        TxLastAddress       : integer;
  
  type          TxStateT is (IDLE, SELECTS, TRANSMIT);
  signal        TxState : TxStateT;
  signal        TxReceivedCell : T_CELL;
  

  -- Utopia Slave RX Testbench Signals
  signal        RxLastAddress       : integer;
  
  signal        RxReceivedCell : T_CELL;
    
  signal        user_interface_pipeline_mode : std_logic := '0';

  signal		Temp_FRED : integer	:= 0;

  signal 		phy_mode_used : integer := phy_mode( Value => PHYMode);
    
  constant slave_utopia_width : integer := 15;
  constant slave_user_width : integer := 15;
  
  signal cell_adjust : std_logic_vector (3 downto 0) := (others => '0');

begin

  ---------------------------------------------------------------------------
  -- Configure the MegaCores with the information set by the testbench
  -- generics.
  ---------------------------------------------------------------------------
  process
    variable l : LINE;

  begin

    write(l, string'("----------------------------------------------------------------------------"));writeline (output, l);
    write(l, string'("--         Utopia Level 2 MegaCore System Demonstration Testbench         --"));writeline (output, l);
    write(l, string'("----------------------------------------------------------------------------"));writeline (output, l);
    write(l, string'("--                              Version 1.0                               --"));writeline (output, l);
    write(l, string'("----------------------------------------------------------------------------"));writeline (output, l);
    write(l, string'("-- PhyMode: "));

    case phy_mode_used is
      when 1 =>
        master_tx_phy_mode <= "00"; 
        slave_tx_phy_mode <=  '0';
        master_rx_phy_mode <= "00"; 
        slave_rx_phy_mode <=  '0';
        write(l, string'("MPHY"));
      when 2 =>
        master_tx_phy_mode <= "01"; 
        slave_tx_phy_mode <=  '1';
        master_rx_phy_mode <= "01"; 
        slave_rx_phy_mode <=  '1';
        write(l, string'("SPHYOctet"));
      when 3 =>
        master_tx_phy_mode <= "11"; 
        slave_tx_phy_mode <=  '1';
        master_rx_phy_mode <= "11"; 
        slave_rx_phy_mode <=  '1';
        write(l, string'("SPHYCell"));
      when others => assert false report "PHY Mode Error";
    end case;

    write(l, string'("   UtopiaBusWidth: "));
    write(l, UtBusWidth);
    case MasterUserCellSize is
      when 52 =>
        if  (UtBusWidth = 8) then
            rx_ut_width <= '0';
            tx_ut_width <= '0';
            tx_width <= '0';
            rx_width <= '0';
        else
            rx_ut_width <= '1';
            tx_ut_width <= '1';
            tx_width <= '1';
            rx_width <= '1';
        end if;
      when 53 =>
        assert (UtBusWidth = 8) report "Bus Width not 8 for 53 byte Ut Cell)";
        rx_ut_width <= '0';
        tx_ut_width <= '0';
        tx_width <= '0';
        rx_width <= '0';
      when 54 =>
        assert (UtBusWidth = 16) report "Bus Width not 16 for 54 byte Ut Cell)";
        rx_ut_width <= '1';
        tx_ut_width <= '1';
        tx_width <= '1';
        rx_width <= '1';
      when others => assert false report "Illegal MasterUserCellSize";
    end case;

    write(l, string'("   Slaves: "));
    write(l, num_slaves);
    writeline (output, l);
    tx_addr_range <= std_logic_vector(to_unsigned(num_slaves-1, 5));
    rx_addr_range <= std_logic_vector(to_unsigned(num_slaves-1, 5));

    for I in 1 to num_slaves loop
      tx_address(I) <= std_logic_vector(to_unsigned(I-1, 5));
      rx_address(I) <= std_logic_vector(to_unsigned(I-1, 5));
    end loop; 

    write(l, string'("-- SlaveUserCellSize: "));
    case UserCellSize is
      when 52 =>
        slave_tx_user_bytes <= "00";
        slave_rx_user_bytes <= "00";
        write(l, string'("52"));
      when 53 =>
        slave_tx_user_bytes <= "01";
        slave_rx_user_bytes <= "01";
        assert (UserBusWidth = 8) report "Only a User Bus Width of 8 is allowed for 53 bytes cells";
        write(l, string'("53"));
      when 54 =>
        slave_tx_user_bytes <= "10";
        slave_rx_user_bytes <= "10";
        write(l, string'("54"));
      when others =>
        assert false report "Illegal UserCellSize";
    end case;


    write(l, string'("   SlaveUserBusWidth: "));
    if (UserBusWidth = 8) then
      rx_user_width <= '0';
      tx_user_width <= '0';
      write(l, string'("8"));
    else
      rx_user_width <= '1';
      tx_user_width <= '1';
      write(l, string'("16"));
    end if;


    write(l, string'("   MasterUserCellSize: "));
    case MasterUserCellSize is
      when 52 =>
        master_tx_user_bytes <= '0';
        master_rx_user_bytes <= '0';
        write(l, string'("52"));
      when 53 =>
        master_tx_user_bytes <= '1';
        master_rx_user_bytes <= '1';
        assert (UtBusWidth = 8) report "Only a Master User Bus Width of 8 is allowed for 53 bytes cells";
        write(l, string'("53"));
      when 54 =>
        master_tx_user_bytes <= '1';
        master_rx_user_bytes <= '1';
        assert (UtBusWidth = 16) report "Only a Master User Bus Width of 16 is allowed for 54 bytes cells";
        write(l, string'("54"));
      when others =>
        assert false report "Illegal MasterUserCellSize";
    end case;
    writeline (output, l);

    write(l, string'("-- Parity: "));
    if (ParityEnable) then
      rx_parity_check <= '1';
      tx_parity_check <= '1';
      rx_parity_generate <= '1';
      tx_parity_generate <= '1';
      write(l, string'("YES"));
    else
      rx_parity_check <= '0';
      tx_parity_check <= '0';
      rx_parity_generate <= '0';
      tx_parity_generate <= '0';
      write(l, string'("NO"));
    end if;
    writeline (output, l);
    write(l, string'("----------------------------------------------------------------------------"));writeline (output, l);

    wait;

  end process;


  -------------------------------------------------------------------------
  -- Instantaiation of Utopia Master Tx Megafunction
  -------------------------------------------------------------------------

  mastertx_dut1: mastertx   port map
  (
      atm_tx_data         => atm_tx_data,
      atm_tx_soc          => atm_tx_soc,
      atm_tx_valid        => atm_tx_valid,
      atm_tx_enb          => atm_tx_enb,

      atm_tx_port         => atm_tx_port,
      atm_tx_port_load    => atm_tx_port_load,
      atm_tx_port_wait    => atm_tx_port_wait,
      atm_tx_port_stat    => atm_tx_port_stat,

      tx_data             => tx_data,
      tx_soc              => tx_soc,
      tx_enb              => tx_enb,
      tx_clav             => tx_clav_tri,
      tx_prty             => tx_prty,
      tx_addr             => tx_addr,

      tx_phy_mode         => master_tx_phy_mode,
      tx_user_bytes       => master_tx_user_bytes,
      tx_width            => tx_width,
      atm_tx_pipe_mode    => user_interface_pipeline_mode,
      tx_parity_generate  => tx_parity_generate,
      tx_addr_range       => tx_addr_range,
      tx_tt_mode          => tx_tt_mode,
      tx_tt_en            => tx_tt_en,
      tx_tt_write         => tx_tt_write,
      tx_tt_addr          => tx_tt_addr,
      tx_tt_data          => tx_tt_data,
      tx_cell_adjust         => cell_adjust,

      tx_clk_in           => tx_clk,
      reset               => reset               
  );


  -------------------------------------------------------------------------
  -- Instantaiation of Utopia Master Rx Megafunction
  -------------------------------------------------------------------------

  masterrx_dut1: masterrx   port map
  (
      atm_rx_data         => atm_rx_data,
      atm_rx_soc          => atm_rx_soc,
      atm_rx_valid        => atm_rx_valid,
      atm_rx_enb          => atm_rx_enb,

      atm_rx_port         => atm_rx_port,
      atm_rx_port_load    => atm_rx_port_load,
      atm_rx_port_wait    => atm_rx_port_wait,
      atm_rx_port_stat    => atm_rx_port_stat,

      rx_data             => rx_data_tri,
      rx_soc              => rx_soc_tri,
      rx_enb              => rx_enb,
      rx_clav             => rx_clav_tri,
      rx_prty             => rx_prty_tri,
      rx_addr             => rx_addr,

      rx_prty_pulse       => rx_prty_pulse,
      rx_cell_pulse       => master_rx_cell_pulse,
      rx_cell_err_pulse   => rx_cell_err_pulse,

      rx_phy_mode         => master_rx_phy_mode,
      rx_user_bytes       => master_rx_user_bytes,
      rx_width            => rx_width,
      atm_rx_pipe_mode    => user_interface_pipeline_mode,
      rx_parity_check     => rx_parity_check,
      rx_addr_range       => rx_addr_range,
      rx_tt_mode          => rx_tt_mode,
      rx_tt_en            => rx_tt_en,
      rx_tt_write         => rx_tt_write,
      rx_tt_addr          => rx_tt_addr,
      rx_tt_data          => rx_tt_data,
      rx_cell_adjust      => cell_adjust,
      
      rx_clk_in           => rx_clk,
      reset               => reset               
  );




  GEN_SLAVES : for I in 1 to num_slaves generate

    -------------------------------------------------------------------------
    -- Instantaiation of Utopia Slave Tx Megafunction
    -------------------------------------------------------------------------
    slavetx_dut: slavetx_atlantic   
    generic map
    (
          slave_utopia_width => slave_utopia_width,
          slave_user_width   => slave_user_width
    )
    port map
    (
        reset               => reset,           
        tx_clk              => tx_clk,           
        tx_data             => tx_data,          
        tx_soc              => tx_soc,           
        tx_enb              => tx_enb,           
        tx_clav             => tx_clav(I),          
        tx_clav_enb         => tx_clav_enb(I),       
        tx_prty             => tx_prty,          
        tx_addr             => tx_addr,          
        phy_tx_clk          => phy_tx_clk,        
        phy_tx_dat          => phy_tx_data(I),       
        phy_tx_sop          => phy_tx_soc(I),        
        phy_tx_eop          => phy_tx_eop(I),        
        phy_tx_err          => phy_tx_err(I),        
        phy_tx_val          => phy_tx_valid(I),      
        phy_tx_ena          => phy_tx_enb(I),        
        tx_phy_mode         => slave_tx_phy_mode,       
        tx_ut_width         => tx_ut_width,       
        tx_address          => tx_address(I),       
        tx_discard_on_error => tx_discard_on_error,
        tx_user_width       => tx_user_width,     
        tx_user_bytes       => slave_tx_user_bytes,     
        tx_parity_check     => tx_parity_check,
        tx_cell_pulse       => tx_cell_pulse(I),     
        tx_prty_pulse       => tx_prty_pulse(I),     
        tx_cell_err_pulse   => tx_cell_err_pulse(I),  
        tx_cell_adjust         => cell_adjust,
        tx_cell_disc_pulse  => tx_cell_disc_pulse(I) 


    );
    -- Generate tristateable TxClav signal
    tx_clav_tri <=  'Z' when tx_clav_enb(I) = '0' else
                    tx_clav(I) when tx_clav_enb(I) = '1' else
                    'X';

    -------------------------------------------------------------------------
    -- Instantaiation of Utopia Slave Rx Megafunction
    -------------------------------------------------------------------------

    slaverx_duty: slaverx_atlantic   
    generic map
    (
          slave_utopia_width => slave_utopia_width,
          slave_user_width   => slave_user_width
    )
    port map
    (
        reset               => reset,           
        rx_clk              => rx_clk,           
        rx_data             => rx_data(I),          
        rx_soc              => rx_soc(I),           
        rx_enb              => rx_enb,           
        rx_clav             => rx_clav(I),          
        rx_clav_enb         => rx_clav_enb(I),       
        rx_prty             => rx_prty(I),          
        rx_addr             => rx_addr,          
        rx_phy_mode         => slave_rx_phy_mode,       
        rx_ut_width         => rx_ut_width,       
        rx_address          => rx_address(I),       
        phy_rx_clk          => phy_rx_clk,        
        phy_rx_dat          => phy_rx_data(I),       
        phy_rx_sop          => phy_rx_soc(I),        
        phy_rx_eop          => phy_zero,        
        phy_rx_err          => phy_zero,        
        phy_rx_ena          => phy_rx_valid(I),
        phy_rx_dav          => phy_rx_enb(I),        
        rx_user_width       => rx_user_width,  
        rx_cell_adjust      => cell_adjust,
        rx_parity_generate  => rx_parity_generate,       
        rx_user_bytes       => slave_rx_user_bytes,     
        rx_bus_enb          => rx_bus_enb(I)       
    );

    -- Generate tristateable RxClav signal
    rx_clav_tri <=  'Z' when rx_clav_enb(I) = '0' else
                  rx_clav(I) when rx_clav_enb(I) = '1' else
                  'X';

    -- Generate tristateable RxData signal
    rx_data_tri <=  (others => 'Z') when rx_bus_enb(I) = '0' else
                  rx_data(I) when rx_bus_enb(I) = '1' else
                  (others => 'X');

    -- Generate tristateable RxSOC signal
    rx_soc_tri  <=  'Z' when rx_bus_enb(I) = '0' else
                  rx_soc(I) when rx_bus_enb(I) = '1' else
                  'X';

    -- Generate tristateable RxPrty signal
    rx_prty_tri  <=  'Z' when rx_bus_enb(I) = '0' else
                  rx_prty(I) when rx_bus_enb(I) = '1' else
                  'X';



    slave_user: slave_user_if
      generic map ( UserCellSize  => UserCellSize,
                    UserBusWidth  => UserBusWidth,
                    UserBusSize   => UserBusSize,
                    ParityEnable  => ParityEnable,
                    THold         => THold,
                    UtBusSize          => UtBusSize, 
                    MasterUserCellSize => MasterUserCellSize 
                  )

      port map (
                  reset               => reset,           
                  phy_tx_clk          => phy_tx_clk,        
                  phy_tx_data         => phy_tx_data(I),       
                  phy_tx_soc          => phy_tx_soc(I),        
                  phy_tx_valid        => phy_tx_valid(I),      
                  phy_tx_enb          => phy_tx_enb(I),        
                  phy_tx_fifo_full    => phy_tx_fifo_full(I),   
                  tx_address          => tx_address(I),       
                  tx_discard_on_error => tx_discard_on_error,
                  tx_cell_pulse       => tx_cell_pulse(I),     
                  tx_prty_pulse       => tx_prty_pulse(I),     
                  tx_cell_err_pulse   => tx_cell_err_pulse(I),  
                  tx_cell_disc_pulse  => tx_cell_disc_pulse(I),
                  rx_address          => rx_address(I),       
                  phy_rx_clk          => phy_rx_clk,        
                  phy_rx_data         => phy_rx_data(I),       
                  phy_rx_soc          => phy_rx_soc(I),        
                  phy_rx_valid        => phy_rx_valid(I),      
                  phy_rx_enb          => phy_rx_enb(I),
                  error_found         => error_slave(I)

              );



  end generate GEN_SLAVES;


  -- Asynchronous reset
  reset <= '0', '1' after 100 ns;

  -- Generate clocks for Utopia slave tx
  tx_clk <= not tx_clk after (UtopiaClockPeriod/2);
  phy_tx_clk <= not phy_tx_clk after (PhyClockPeriod/2);

  -- Generate clocks for Utopia slave rx
  rx_clk <= not rx_clk after (UtopiaClockPeriod/2);
  phy_rx_clk <= not phy_rx_clk after (PhyClockPeriod/2);

  sim_stop :process
  variable m,n : integer;
  variable total_errors : integer;
  variable local_line : LINE;
  begin
    for m in 0 to 5000 loop
        wait until (rx_clk'event and rx_clk = '1');
    end loop;
    
    total_errors := error_master;
    write(local_line, string'(" Master "));
    write(local_line, string'(" Errors  : "));
    write(local_line,error_master);
    writeline(output, local_line);

    for n in 1 to num_slaves loop
        total_errors := total_errors + error_slave(n);
        write(local_line, string'(" Slave  : "));
        write(local_line,n );
        write(local_line, string'(" Errors  : "));
        write(local_line,error_slave(n));
        writeline(output, local_line);
    end loop;
    if (total_errors /=0) then
        assert false report "simulation FAILED" severity FAILURE;
    else
        assert false report "simulation PASSED" severity FAILURE;
    end if;
  end  process;
  -----------------------------------------------------------------------------------
  -- Atm Tx State Machine
  -----------------------------------------------------------------------------------
  -- Mimics the behaviour of a PHY interface to the Utopia Tx Master by transfering 
  -- cells to the Utopia Master Tx when space in the fifo becomes available.
  -- Data is transferred across the PHY interface when both Atm_Tx_Enb and Atm_Tx_Valid
  -- are '1'.  The start of a cell is indicated when Atm_Tx_SOC is '1'.
  -- For demonstration purposes only, Atm_Tx_Enb is asserted high then low in bursts of
  -- AtmPause (300) clock cycles.
  -- The data in the cells consists of an incrementing pattern. i.e.
  -- Cell 0 Data : 00h 01h 02h 03h ...
  -- Cell 1 Data : 01h 02h 03h 04h ...
  -- ...  
  -- 
  -- On transmitting a cell an information message is printed.
  -----------------------------------------------------------------------------------

  AtmTxSM : process(tx_clk, reset)
    constant AtmPause : integer := 300;
    variable I : integer;
    variable m :integer;
  begin                                     
    if (reset = '0') then
      AtmPauseCount <= 0;
      AtmCellIndex <= 0;
      AtmTxValidVar <= '0';
      CellPattern <= 0;
      for m in 0 to 31 loop
        AtmCurrentCell(m) <= 0;
        port_toggle(m) <= 0;
      end loop;
        tog_in <= 0;
        tog_out <= 0;

        TxLastAddress <= 30;
      
    elsif phy_rx_clk'event and phy_rx_clk = '1' then
      ------------------------------------------------------------------
      -- Simulate the user interface reading from the PHY interface in
      -- bursts of AtmPauseCount clock cycles.  This is for demonstration
      -- purposes only.
      ------------------------------------------------------------------
      if (AtmPauseCount >= AtmPause) then
        AtmPauseCount <= 0;
        AtmTxValidVar <= not AtmTxValidVar;
            
      else
        AtmPauseCount <= AtmPauseCount + 1;
      end if;
      AtmCurrentCell <= NextAtmCurrentCell;
      AtmCellIndex <= NextAtmCellIndex;
      tog_out <= nexttog_out;
      CellPattern <= NextCellPattern;
        ------------------------------------------------------------------
        -- Decide which slave to start transmitting to
        ------------------------------------------------------------------
      if (AtmTxValidVar = '1') then
        if ((atm_tx_port_wait = '0') and (atm_tx_port_load = '0')) then
          I := UtAddrInc(TxLastAddress);
          address_loop: while (I /= TxLastAddress) loop --for I in 0 to 30 loop
            if (atm_tx_port_stat(I) = '1') then
              atm_tx_port_load <= '1';
              atm_tx_port <= std_logic_vector(to_unsigned(I, 5));
              TxLastAddress <= I;
              port_toggle(tog_in) <= I;
              if (tog_in = 1) then
                tog_in <= 0;
              else
                tog_in <= tog_in + 1;
              end if;
              exit address_loop;
            end if;
            I := UtAddrInc(I);
          end loop;
        else
          atm_tx_port_load <= '0';
          atm_tx_port <= std_logic_vector(to_unsigned(0, 5));
        end if;
      end if;

    end if;
end process; 




process(AtmTxValidVar,Atm_Tx_Enb, AtmCellIndex,tog_out,CellPattern)
    variable ReceivedCellVar : T_CELL;
    variable TempCellPattern : std_logic_vector(7 downto 0);
    variable l : LINE;
begin




--    Generate Atm_Tx_Valid, Atm_Tx_SOC and Atm_Tx_Data
      NextAtmCellIndex <= AtmCellIndex;
      NextAtmCurrentCell <= AtmCurrentCell;
      nexttog_out <= tog_out;
      TempCellPattern := std_logic_vector(to_unsigned(CellPattern, 8));
 
 
      if ((AtmTxValidVar = '1') and (Atm_Tx_Enb = '1')) then
          Atm_Tx_Valid <= '1'after THold;
          if (AtmCellIndex = 0) then
            Atm_Tx_SOC <= '1' after THold;
          else
            Atm_Tx_SOC <= '0' after THold;
          end if;
          if (AtmCellIndex = 0) then 
            TempCellPattern := std_logic_vector(to_unsigned(AtmCurrentCell(port_toggle(tog_out))+port_toggle(tog_out), 8));
          else
            TempCellPattern := TempCellPattern + 1;
          end if;
    

          if (UtBusWidth = 8) then
            Atm_Tx_Data(7 downto 0) <= TempCellPattern after THold;
            Atm_Tx_Data(15 downto 8) <= (others => '0') after THold;
          else
            Atm_Tx_Data(7 downto 0) <= TempCellPattern after THold;
            TempCellPattern := TempCellPattern + 1;
            Atm_Tx_Data(15 downto 8) <= TempCellPattern after THold;
          end if;

          if (AtmCellIndex = (MasterUserCellSize/UtBusSize)) then
            NextAtmCellIndex <= 0;
            write(l, NOW);
            write(l, string'(" : Tx Atm Cell "));
            write(l, AtmCurrentCell(port_toggle(tog_out)));
            write(l, string'(" to Slave "));
            write(l, port_toggle(tog_out));
            write(l, string'(" Transmitted "));
            writeline (output, l);
            if (tog_out = 1) then
              nexttog_out <= 0;
            else
              nexttog_out <= tog_out + 1;
            end if;
            NextAtmCurrentCell(port_toggle(tog_out)) <= AtmCurrentCell(port_toggle(tog_out)) + 1;
          else
            NextAtmCellIndex <= AtmCellIndex + 1;
          end if;
      else
          Atm_Tx_Valid <= '0' after THold;
          Atm_Tx_Data((UserBusWidth-1) downto 0) <= (others => 'X') after THold;
          Atm_Tx_SOC <= 'X' after THold;

      end if;         
    
    NextCellPattern <= to_integer(TempCellPattern);
 
  end process;  

  -----------------------------------------------------------------------------------
  -- Atm Rx State Machine
  -----------------------------------------------------------------------------------
  -- Mimics the behaviour of an ATM interface to the Utopia Master Rx by receiving cells
  -- from the Utopia Master Rx when they become available.
  -- Data is transferred across the ATM interface when both Atm_Rx_Enb and Atm_Rx_Valid
  -- are '1'.  The start of a cell is indicated when Atm_Rx_SOC is '1'.
  -- For demonstration purposes only, Atm_Rx_Enb is asserted high then low in bursts of
  -- Atm_Pause (300) clock cycles.
  -- On receiving a cell an information message is printed with a hex representation
  -- of the received ATM cell.
  -----------------------------------------------------------------------------------
  AtmRxSM : process(rx_clk, reset)
    constant Atm_Pause : integer := 300;
    variable Atm_Pause_Count : integer;  
    variable Atm_Cell_Index : integer;  
    variable Atm_Current_Cell : arr_integer;  
    variable Received_Cell_Var : T_CELL;
    variable I : integer;
    variable l : LINE;
    variable check_ok : integer;
    variable m : integer;
    variable port_toggle : arr_integer;
    variable tog_in : integer;
    variable tog_out : integer;


    function check_cell (
                        address : integer ; 
                        data : T_CELL;
                        index : integer;
                        bussize : integer;
                        celllength : integer
                        )
        return integer is
    variable data_to_compare : T_CELL;
    variable data_in_inverted : T_CELL;
    variable data_in : T_CELL;
    variable current_value : integer;
    variable n : integer;
    variable local_line : LINE;
    variable ignore_gen_4 : boolean;
    variable ignore_gen_5 : boolean;
    variable ignore_in_4 : boolean;
    variable ignore_in_5 : boolean;
    variable first_error : boolean;
    variable smaller_size : integer;
    variable bigger_size : integer;
    variable index_in : integer;
    variable index_gen : integer;

    begin

    ignore_gen_4 := false;
    ignore_gen_5 := false;
    ignore_in_4 := false;
    ignore_in_5 := false;   
    first_error := true;
        
    if (UserCellSize < MasterUserCellSIze) then
        smaller_size := UserCellSize;
        bigger_size := MasterUserCellSIze;
    else
        smaller_size := MasterUserCellSIze;
        bigger_size := UserCellSize;
    end if; 
    
                                                
    if    ((MasterUserCellSize = 52) and ( UserCellSize = 53)) then
        ignore_gen_4 := true;
    elsif ((MasterUserCellSize = 52) and (UserCellSize = 54)) then
        ignore_gen_4 := true;
        ignore_gen_5 := true;
    elsif ((MasterUserCellSize = 53) and (UserCellSize = 54)) then
        ignore_gen_5 := true;
    elsif ((MasterUserCellSize = 53) and (UserCellSize = 52)) then
        ignore_in_4 := true;
    elsif ((MasterUserCellSize = 54) and (UserCellSize = 52)) then
        ignore_in_4 := true;
        ignore_in_5 := true;
    elsif ((MasterUserCellSize = 54) and (UserCellSize = 53)) then
        ignore_in_5 := true;
    end if;

    current_value := index+address ;
    for n in 0 to 27-1 loop
        if ((UtBusSize = UserBusSize) or (UserBusSize < UtBusSize)) then     -- don't invert the ordering
            data_to_compare(((2*n * 8) + 8 -1) downto (2*n * 8)) := std_logic_vector(to_unsigned(current_value,8));
            current_value := current_value + 1;
            data_to_compare((((2*n+1) * 8) + 8 -1) downto ((2*n+1) * 8)) := std_logic_vector(to_unsigned(current_value,8));
            current_value := current_value + 1;
        else -- invert the ordering, either the data_in or the generated data.
             -- when MasterBus is 8 and Utopia is 16, inverse the data_in, otherwise inverse the data_gen
            data_to_compare((((2*n+1) * 8) + 8 -1) downto ((2*n+1) * 8)) := std_logic_vector(to_unsigned(current_value,8));
            current_value := current_value + 1;
            data_to_compare(((2*n * 8) + 8 -1) downto (2*n * 8)) := std_logic_vector(to_unsigned(current_value,8));
            current_value := current_value + 1;
        end if;

        if (UserBusSize < UtBusSize ) then -- 8 bit for ATM, 16 for PHY
            data_in_inverted((((2*n+1) * 8) + 8 -1) downto ((2*n+1) * 8)) := data(((2*n * 8) + 8 -1) downto (2*n * 8));
            data_in_inverted(((2*n * 8) + 8 -1) downto (2*n * 8)) := data((((2*n+1) * 8) + 8 -1) downto ((2*n+1) * 8));
        end if;

    end loop;
    if (UserBusSize < UtBusSize) then -- 8 bit for ATM, 16 for PHY
        data_in := data_in_inverted;
    else
        data_in := data;
    end if;


    index_in := 0;
    index_gen := 0;

    for n in 0 to smaller_size -1 loop
        if ((n = 4) and  (ignore_gen_4)) then 
            index_gen := index_gen + 1;
            if (ignore_gen_5) then index_gen := index_gen + 1; end if; 
        end if;
        if ((n = 5) and  (ignore_gen_5) and (ignore_gen_4=false)) then index_gen := index_gen + 1; end if;
        if ((n = 4) and  (ignore_in_4))  then 
            index_in := index_in + 1; 
            if (ignore_in_5) then index_in := index_in + 1; end if; 
        end if;
        if ((n = 5) and  (ignore_in_5) and (ignore_in_4 = false))  then index_in := index_in + 1; end if;
        if (data_to_compare(((index_gen * 8) + 8 -1) downto (index_gen * 8)) /= data_in(((index_in * 8) + 8 -1) downto (index_in * 8))) then
            if (first_error) then -- display error message only the first time.
                first_error := false;
                write(local_line, NOW);
                write(local_line, string'(" Atm Transmit Data for the following  : "));
            end if;
            write(local_line, n);
            write(local_line,string'(" ("));
            write(local_line,to_integer(data_in(((index_in * 8) + 8 -1) downto (index_in * 8))));
            write(local_line,string'(" , "));
            write(local_line,to_integer(data_to_compare(((index_gen * 8) + 8 -1) downto (index_gen * 8))));
            write(local_line,string'(" )"));
        end if;
        index_gen := index_gen + 1;
        index_in := index_in + 1; 
    end loop;

    if (first_error = false) then  -- there was an error
        writeline(output, local_line);
        return 0;
    else
        return 1;
    end if;



    end check_cell;

                         

  begin
    if (reset = '0') then
      Atm_Pause_Count := 0;
      Atm_Cell_Index := (MasterUserCellSize/UtBusSize);
      Atm_Rx_Enb <= '0';
      tog_in := 0;
      tog_out := 0;
      port_toggle(0) := 0;
      port_toggle(1) := 0;
      port_toggle(2) := 0;
      for m in 0 to 31 loop
        Atm_Current_Cell(m) := 0;
      end loop;
      RxLastAddress <= 30;
      error_master <= 0;
    elsif rx_clk'event and rx_clk = '1' then

      ------------------------------------------------------------------
      -- Decide which slave to start receiving from
      ------------------------------------------------------------------
      if ((atm_rx_port_wait = '0') and (atm_rx_port_load = '0')) then
        I := UtAddrInc(RxLastAddress);
        address_loop: while (true) loop
          if (atm_rx_port_stat(I) = '1') then
            atm_rx_port_load <= '1';
            atm_rx_port <= std_logic_vector(to_unsigned(I, 5));
            RxLastAddress <= I;
            port_toggle(tog_in) := I;
            if (tog_in = 2) then -- toggle the port storage position
                tog_in := 0;
            else
                tog_in := tog_in + 1;
            end if;
            exit address_loop;
          end if;
          if (I = RxLastAddress) then
            exit address_loop;
          end if;
          I := UtAddrInc(I);
        end loop;
      else
        atm_rx_port_load <= '0';
        atm_rx_port <= std_logic_vector(to_unsigned(0, 5));
      end if;


      ------------------------------------------------------------------
      -- Simulate reading from the Atm interface in
      -- bursts of AtmPauseCount clock cycles.  This is for demonstration
      -- purposes only.
      ------------------------------------------------------------------
      if (Atm_Pause_Count >= Atm_Pause) then
        Atm_Pause_Count := 0;
        Atm_Rx_Enb <= not Atm_Rx_Enb after THold;
      else
        Atm_Pause_Count := Atm_Pause_Count + 1;
      end if;

      ------------------------------------------------------------------
      -- Data is transferred across the Atm interface when both Atm_Rx_Enb
      -- and Atm_Rx_Valid are '1'.
      -- The start of a cell is indicated when Atm_Rx_SOC is '1'.
      -- Each cell transfer is checked that it is exactly 53 bytes long.
      ------------------------------------------------------------------
      if ((Atm_Rx_Enb = '1') and (Atm_Rx_Valid = '1')) then
        if (Atm_Rx_SOC = '1') then
          if (Atm_Cell_Index /= (MasterUserCellSize/UtBusSize)) then
            write(l, NOW);
            write(l, string'(" : Atm Rx User Cell "));
            write(l, Atm_Current_Cell(port_toggle(tog_out)));
            write(l, string'(" Too Short "));
            writeline (output, l);
          end if;
          Atm_Cell_Index := 0;
        end if;

        -- Store the received cell data
        Received_Cell_Var(((Atm_Cell_Index * UtBusWidth) + UtBusWidth -1) downto (Atm_Cell_Index * UtBusWidth)) := Atm_Rx_Data(UtBusWidth-1 downto 0);
        
        -- At the end of a cell transfer an information message is printed,
        -- and the data is loaded into RxReceivedCell
        if (Atm_Cell_Index = ((MasterUserCellSize/UtBusSize) -1)) then
          write(l, NOW);
          write(l, string'(" : Atm Rx User Cell "));
          write(l, Atm_Current_Cell(port_toggle(tog_out)));
          write(l, string'(" from port "));
          write(l, port_toggle(tog_out));
          write(l, string'(" Received - "));
          write(l, Evec2hex(Received_Cell_Var, MasterUserCellSize * 8));
          writeline (output, l);
          check_ok := check_cell (port_toggle(tog_out), Received_Cell_Var, Atm_Current_Cell(port_toggle(tog_out)),UtBusSize,MasterUserCellSize );
          write(l, NOW);
          write(l, string'(" : Atm Rx User Cell Check result "));
          write(l, check_ok);
          writeline(output, l);
          Atm_Current_Cell(port_toggle(tog_out)) := Atm_Current_Cell(port_toggle(tog_out)) + 1;
          if (check_ok = 0) then 
            error_master <= error_master + 1;
          end if;
          if (tog_out = 2) then -- toggle the port storage position
              tog_out := 0;
          else
              tog_out := tog_out + 1;
          end if;

        end if;

        if (Atm_Cell_Index > ((MasterUserCellSize/UtBusSize) - 1 )) then
          write(l, NOW);
          write(l, string'(" : Atm Rx User Cell "));
          write(l, Atm_Current_Cell(to_integer(atm_rx_port)));
          write(l, string'(" Too Long "));
          writeline (output, l);
        end if;
        
        Atm_Cell_Index := Atm_Cell_Index + 1;
        
      end if;
      
    end if;
  end process;  





end;

