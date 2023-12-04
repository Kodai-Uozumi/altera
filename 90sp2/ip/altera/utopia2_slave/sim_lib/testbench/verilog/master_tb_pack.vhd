library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use Std.Textio.all;

package master_tb_pack is

  -- Type declarations for UTOPIA cells
  constant THold : time := 1 ns;
  constant CellBits : integer := 54 * 8;

  subtype T_CELL is std_logic_vector(CellBits-1 downto 0);    


  function Evec2hex (Value: Std_logic_vector; Length: integer:=0) return String;

  function UtAddrInc (Value: integer) return integer;

  function bool_to_int (Value: boolean) return integer;

  function phy_mode (Value: string) return integer;
 
  function to_integer (value : std_logic_vector) return integer;

  type arr_integer is array (31 downto 0) of integer;

end master_tb_pack;



package body master_tb_pack is

  function Evec2hex (Value: Std_logic_vector; Length: integer:= 0) return String is
    constant LengthValue : integer := value'length * bool_to_int(Length = 0) + Length;
  	variable result: String(1 to (LengthValue)/4);    --Length
    variable nibble: Std_logic_vector(3 downto 0);
  begin
  	For I in 1 to result'length loop
  	nibble := Value(4*I-1 downto 4*(I-1));
  	case nibble is
    	when "0000" => result(result'right - I + 1):='0';
    	when "0001" => result(result'right - I + 1):='1';
    	when "0010" => result(result'right - I + 1):='2';
    	when "0011" => result(result'right - I + 1):='3';
    	when "0100" => result(result'right - I + 1):='4';
    	when "0101" => result(result'right - I + 1):='5';
    	when "0110" => result(result'right - I + 1):='6';
    	when "0111" => result(result'right - I + 1):='7';
    	when "1000" => result(result'right - I + 1):='8';
    	when "1001" => result(result'right - I + 1):='9';
    	when "1010" => result(result'right - I + 1):='A';
    	when "1011" => result(result'right - I + 1):='B';
    	when "1100" => result(result'right - I + 1):='C';
    	when "1101" => result(result'right - I + 1):='D';
    	when "1110" => result(result'right - I + 1):='E';
    	when "1111" => result(result'right - I + 1):='F';
    	when others => result(result'right - I + 1):='X';
  	end case;
  	end loop;
  	return result;
  end Evec2Hex;

  function UtAddrInc (Value: integer) return integer is
  begin
    if (Value = 30) then
      return 0;
    else
      return Value + 1;
    end if;
  end UtAddrInc;

  function bool_to_int (Value: boolean) return integer is
  begin
    if (Value = true) then
      return 1;
    else
      return 0;
    end if;
  end bool_to_int;

  function phy_mode (Value: string) return integer is
  begin
  	if (Value = "MPHY")	then
	  return 1;
	end if;
  	if (Value = "SPHYOctetHandshake") then
	  return 2;
	end if;
  	if (Value = "SPHYCellHandshake") then
	  return 3;
	end if;
	return 0;
  end phy_mode;

  function to_integer (value : std_logic_vector)
           return integer is
  begin
      return to_integer(unsigned(value));
  end to_integer;


end master_tb_pack;

