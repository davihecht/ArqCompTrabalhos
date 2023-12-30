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


ENTITY Padding32 IS
  PORT (
  	InstAddress:   in STD_LOGIC_VECTOR (23 downto 0);
  ------------------------------------------------------------------------------	
	InstPadded:    out STD_LOGIC_VECTOR (31 downto 0)
    );
END Padding32;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF Padding32 IS

begin	

	InstPadded <= "00000000" & InstAddress;

end structural;