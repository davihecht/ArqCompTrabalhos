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
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY teste_somador4bits IS
END teste_somador4bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF teste_somador4bits IS

	COMPONENT Somador4Bit IS
		PORT(X, Y:  IN STD_LOGIC_VECTOR (3 downto 0);
	             Cin:   IN STD_LOGIC;
	             S:	    OUT STD_LOGIC_VECTOR (3 downto 0);
		     Cout:  OUT	STD_LOGIC);
	END COMPONENT;
	signal TestIn:   STD_LOGIC_VECTOR(8 downto 0) := "000000000";
	signal TestSOut: STD_LOGIC_VECTOR(3 downto 0);
	signal TestCout: STD_LOGIC;
	
begin
	TestIn <= TestIn + 1 after 10 ns;
	Testando: Somador4Bit PORT MAP (TestIn(3 downto 0), TestIn(7 downto 4), TestIn(8), TestSOut, TestCout);
	
end structural;