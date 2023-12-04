----------------------------------------------------------------------------
--  Utopia Level 2 MegaCore System Demonstration Testbench
----------------------------------------------------------------------------
--  Revision History:
--
--  V1.0     14th Sep 1999   First Version
--
----------------------------------------------------------------------------
--  This entity is used within the Utopia Level 2 MegaCore System Demonstration
--  Testbench to provide stimulus for the user interface of the Utopia
--  Slave Rx & Tx MegaCores.
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

entity slave_user_if is 
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
          phy_rx_soc          : out    std_logic := '0';
          phy_rx_valid        : out    std_logic;
          phy_rx_enb          : in     std_logic;
          error_found         : out    integer

      );

end;

architecture bench of slave_user_if is

signal PhyPauseCount : integer;
signal PhyRxValidVar : std_logic;
signal PhyCurrentCell : integer;  
signal NextPhyCurrentCell : integer;  
signal PhyCellINdex : integer;  
signal NextPhyCellINdex : integer;  
signal CellPattern : std_logic_vector(7 downto 0);
signal NextCellPattern : std_logic_vector(7 downto 0);
signal error_count : integer;  

begin


  -----------------------------------------------------------------------------------
  -- Phy Tx State Machine
  -----------------------------------------------------------------------------------
  -- Mimics the behaviour of a PHY interface to the Utopia slave by receiving cells
  -- from the Utopia Slave Tx when they become available.
  -- Data is transferred across the PHY interface when both Phy_Tx_Enb and Phy_Tx_Valid
  -- are '1'.  The start of a cell is indicated when Phy_Tx_SOC is '1'.
  -- For demonstration purposes only, Phy_Tx_Enb is asserted high then low in bursts of
  -- Phy_Pause (300) clock cycles.
  -- On receiving a cell an information message is printed with a hex representation
  -- of the received ATM cell.
  -----------------------------------------------------------------------------------
  PhyTxSM : process(phy_tx_clk, reset)
    constant Phy_Pause : integer := 300;
    variable Phy_Pause_Count : integer;  
    variable Phy_Cell_Index : integer;  
    variable Phy_Current_Cell : integer;  
    variable Received_Cell_Var : T_CELL;
    variable l : LINE;
    variable check_ok : integer;



    impure function check_cell (
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
    
    
    if    ((UserCellSize = 52) and (MasterUserCellSize = 53)) then
        ignore_gen_4 := true;
    elsif ((UserCellSize = 52) and (MasterUserCellSize = 54)) then
        ignore_gen_4 := true;
        ignore_gen_5 := true;
    elsif ((UserCellSize = 53) and (MasterUserCellSize = 54)) then
        ignore_gen_5 := true;
    elsif ((UserCellSize = 53) and (MasterUserCellSize = 52)) then
        ignore_in_4 := true;
    elsif ((UserCellSize = 54) and (MasterUserCellSize = 52)) then
        ignore_in_4 := true;
        ignore_in_5 := true;
    elsif ((UserCellSize = 54) and (MasterUserCellSize = 53)) then
        ignore_in_5 := true;
    end if;

    current_value := index+address ;
    for n in 0 to 27-1 loop
        if ((UtBusSize = UserBusSize) or (UtBusSize < UserBusSize)) then     -- don't invert the ordering
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

        if (UtBusSize < UserBusSize) then -- 8 bit for ATM, 16 for PHY
            data_in_inverted((((2*n+1) * 8) + 8 -1) downto ((2*n+1) * 8)) := data(((2*n * 8) + 8 -1) downto (2*n * 8));
            data_in_inverted(((2*n * 8) + 8 -1) downto (2*n * 8)) := data((((2*n+1) * 8) + 8 -1) downto ((2*n+1) * 8));
        end if;

    end loop;
    if (UtBusSize < UserBusSize) then -- 8 bit for ATM, 16 for PHY
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
                write(local_line, string'(" Data in        : "));
                write(local_line, Evec2hex(data_in, bigger_size * 8));
                writeline(output, local_line);
                write(local_line, NOW);
                write(local_line, string'(" Generated data : "));
                write(local_line, Evec2hex(data_to_compare, bigger_size * 8));
                writeline(output, local_line);

                write(local_line, NOW);
                write(local_line, string'(" Phy Transmit Data for the following (cellsize, address, cell_no, bussize) : "));
                write(local_line, celllength);
                write(local_line, string'(" "));
                write(local_line, address);
                write(local_line, string'(" "));
                write(local_line, index);
                write(local_line, string'(" "));
                write(local_line, UtBusSize);
                write(local_line, string'(" "));
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
      Phy_Pause_Count := 0;
      Phy_Cell_Index := (UserCellSize/UserBusSize);
      Phy_Tx_Enb <= '0';
      Phy_Current_Cell := 0;
      error_found <= 0;
      error_count <= 0;
    elsif phy_tx_clk'event and phy_tx_clk = '1' then
      ------------------------------------------------------------------
      -- Simulate reading from the PHY interface in
      -- bursts of PhyPauseCount clock cycles.  This is for demonstration
      -- purposes only.
      ------------------------------------------------------------------
      if (Phy_Pause_Count >= Phy_Pause) then
        Phy_Pause_Count := 0;
        Phy_Tx_Enb <= not Phy_Tx_Enb after THold;
      else
        Phy_Pause_Count := Phy_Pause_Count + 1;
      end if;

      ------------------------------------------------------------------
      -- Data is transferred across the PHY interface when both Phy_Tx_Enb
      -- and Phy_Tx_Valid are '1'.
      -- The start of a cell is indicated when PhyTxSOC is '1'.
      -- Each cell transfer is checked that it is the expected length.
      ------------------------------------------------------------------
      if ((Phy_Tx_Enb = '1') and (Phy_Tx_Valid = '1')) then
        if (Phy_Tx_SOC = '1') then
          if (Phy_Cell_Index /= (UserCellSize/UserBusSize)) then
            write(l, NOW);
            write(l, string'(" : Tx Slave Cell "));
            write(l, Phy_Current_Cell);
            write(l, string'(" Too Short "));
            writeline (output, l);
          end if;
          Phy_Cell_Index := 0;
        end if;

        -- Store the received cell data
        Received_Cell_Var(((Phy_Cell_Index * UserBusWidth) + UserBusWidth -1) downto (Phy_Cell_Index * UserBusWidth)) := Phy_Tx_Data(UserBusWidth-1 downto 0);
        
        -- At the end of a cell transfer an information message is printed,
        -- and the data is loaded into TxReceivedCell
        if (Phy_Cell_Index = ((UserCellSize/UserBusSize) -1)) then
          write(l, NOW);
          write(l, string'(" : Tx Slave "));
          write(l, conv_integer(tx_address));
          write(l, string'(" Cell "));
          write(l, Phy_Current_Cell);
          write(l, string'(" Received - "));
          write(l, Evec2hex(Received_Cell_Var, UserCellSize * 8));
          writeline (output, l);
          check_ok := check_cell (to_integer(tx_address), Received_Cell_Var, Phy_Current_Cell,UserBusSize,UserCellSize );
          write(l, NOW);
          write(l, string'(" : Slave Tx User Cell Check result "));
          write(l, check_ok);
          writeline(output, l);
          if (check_ok = 0) then
            error_found <= error_count + 1;
            error_count <= error_count + 1;
          end if;
          Phy_Current_Cell := Phy_Current_Cell + 1;
        end if;

        if (Phy_Cell_Index > ((UserCellSize/UserBusSize) - 1 )) then
          write(l, NOW);
          write(l, string'(" : Tx Slave Cell "));
          write(l, Phy_Current_Cell);
          write(l, string'(" Too Long "));
          writeline (output, l);
        end if;
        
        Phy_Cell_Index := Phy_Cell_Index + 1;
        
      end if;
      
    end if;
  end process;  




  -----------------------------------------------------------------------------------
  -- Phy Rx State Machine
  -----------------------------------------------------------------------------------
  -- Mimics the behaviour of a PHY interface to the Utopia Rx slave by transfering 
  -- cells to the Utopia Slave Rx when space in the fifo becomes available.
  -- Data is transferred across the PHY interface when both Phy_Rx_Enb and Phy_Rx_Valid
  -- are '1'.  The start of a cell is indicated when Phy_Rx_SOC is '1'.
  -- For demonstration purposes only, Phy_Rx_Enb is asserted high then low in bursts of
  -- Phy_Pause (300) clock cycles.
  -- The data in the cells consists of an incrementing pattern. i.e.
  -- Cell 0 Data : 00h 01h 02h 03h ...
  -- Cell 1 Data : 01h 02h 03h 04h ...
  -- ...  
  -- 
  -- On transmitting a cell an information message is printed.
  -----------------------------------------------------------------------------------
  PhyRxSM : process(phy_rx_clk, reset)
    constant PhyPause : integer := 300;
  begin
    if (reset = '0') then
      PhyPauseCount <= 0;
      PhyCellIndex <= 0;
      PhyRxValidVar <= '0';
      PhyCurrentCell <= 0;
      CellPattern <= (others => '0');
      
    elsif phy_rx_clk'event and phy_rx_clk = '1' then
      ------------------------------------------------------------------
      -- Simulate the user interface reading from the PHY interface in
      -- bursts of PhyPauseCount clock cycles.  This is for demonstration
      -- purposes only.
      ------------------------------------------------------------------
      if (PhyPauseCount >= PhyPause) then
        PhyPauseCount <= 0;
        PhyRxValidVar <= not PhyRxValidVar;
            
      else
        PhyPauseCount <= PhyPauseCount + 1;
      end if;
      PhyCurrentCell <= NextPhyCurrentCell;
      PhyCellIndex <= NextPhyCellIndex;
      CellPattern <= NextCellPattern;
    end if;
end process; 



process(PhyRxValidVar,Phy_Rx_Enb, PhyCellIndex, CellPattern )
    variable ReceivedCellVar : T_CELL;
    variable TempCellPattern : std_logic_vector(7 downto 0);
    variable l : LINE;
begin




--    Generate Phy_Rx_Valid, Phy_Rx_SOC and Phy_Rx_Data
      NextPhyCellIndex <= PhyCellIndex;
      NextPhyCurrentCell <= PhyCurrentCell;

      TempCellPattern := CellPattern;
 
 
      if ((PhyRxValidVar = '1') and (Phy_Rx_Enb = '1')) then
          Phy_Rx_Valid <= '1'after THold;
          if (PhyCellIndex = 0) then
            Phy_Rx_SOC <= '1' after THold;
          else
            Phy_Rx_SOC <= '0' after THold;
          end if;
          if (PhyCellIndex = 0) then 
            TempCellPattern := std_logic_vector(to_unsigned(PhyCurrentCell + to_integer(rx_address), 8));
          else
            TempCellPattern := TempCellPattern + 1;
          end if;
    

          if (UserBusWidth = 8) then
            Phy_Rx_Data(7 downto 0) <= TempCellPattern after THold;
            Phy_Rx_Data(15 downto 8) <= (others => '0') after THold;
          else
            Phy_Rx_Data(7 downto 0) <= TempCellPattern after THold;
            TempCellPattern := TempCellPattern + 1;
            Phy_Rx_Data(15 downto 8) <= TempCellPattern after THold;
          end if;

          if (PhyCellIndex = (UserCellSize/UserBusSize)) then
            NextPhyCellIndex <= 0;
            write(l, NOW);
            write(l, string'(" : Rx Slave "));
            write(l, conv_integer(rx_address));
            write(l, string'(" Cell "));
            write(l, PhyCurrentCell);
            write(l, string'(" Transmitted "));
            writeline (output, l);
            NextPhyCurrentCell <= PhyCurrentCell + 1;
          else
            NextPhyCellIndex <= PhyCellIndex + 1;
          end if;
      else
          Phy_Rx_Valid <= '0' after THold;
          Phy_Rx_Data((UserBusWidth-1) downto 0) <= (others => 'X') after THold;
          Phy_Rx_SOC <= '0' after THold;   --- <-- changed this to "0" for the case of multiple instances in the example_tb

      end if;         
 
    NextCellPattern <= TempCellPattern;

  end process;  


end bench;
