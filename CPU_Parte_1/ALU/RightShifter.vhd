--------------------------------------------------------------------------------
-- Project :
-- File    :
-- Autor   :
-- Date    :
--
--------------------------------------------------------------------------------
-- Description :
--
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY RightShifter IS
  PORT (
  --Inputs
  	X: in STD_LOGIC_VECTOR (31 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0)
    );
END RightShifter;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF RightShifter IS
begin	
	output <= std_logic_vector(unsigned(X) srl to_integer(unsigned(shifts)));

end structural;