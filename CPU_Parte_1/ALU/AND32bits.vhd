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

ENTITY AND32bits IS
  PORT (
  --Inputs
  	X, Y: in STD_LOGIC_VECTOR (31 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0)
    );
END AND32bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF AND32bits IS
begin	
	output <= X AND Y;

end structural;