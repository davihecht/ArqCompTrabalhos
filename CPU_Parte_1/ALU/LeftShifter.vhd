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

ENTITY LeftShifter IS
  PORT (
  --Inputs
  	X: in STD_LOGIC_VECTOR (31 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0)
    );
END LeftShifter;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF LeftShifter IS
begin	
	output <= std_logic_vector(unsigned(X) sll to_integer(unsigned(shifts)));

end structural;
