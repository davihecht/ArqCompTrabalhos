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


ENTITY RemovePadding32 IS
  PORT (
  	MemAddressPadded:   in STD_LOGIC_VECTOR (31 downto 0);
  ------------------------------------------------------------------------------	
	MemAddress:         out STD_LOGIC_VECTOR (23 downto 0)
    );
END RemovePadding32;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF RemovePadding32 IS

begin	

	MemAddress <= MemAddressPadded(23 downto 0);

end structural;