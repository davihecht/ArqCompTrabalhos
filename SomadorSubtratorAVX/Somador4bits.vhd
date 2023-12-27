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

ENTITY Somador4Bit IS
  PORT (
  --Inputs
  	X, Y: in STD_LOGIC_VECTOR (3 downto 0);
  	Cin: in STD_LOGIC;
  ------------------------------------------------------------------------------	
	S: out STD_LOGIC_VECTOR (3 downto 0);
	Cout: out STD_LOGIC
    );
END Somador4Bit;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF Somador4Bit IS

	COMPONENT FullAdder1bit IS
		PORT(A, B, Cin: in STD_LOGIC;
			  S, Cout: out	STD_LOGIC);
	END COMPONENT;
	signal c1, c2, c3: STD_LOGIC := '0';
	
begin
	FA1: FullAdder1bit PORT MAP (X(0), Y(0), Cin, S(0), c1);
	FA2: FullAdder1bit PORT MAP (X(1), Y(1), c1, S(1), c2);
	FA3: FullAdder1bit PORT MAP (X(2), Y(2), c2, S(2), c3);
	FA4: FullAdder1bit PORT MAP (X(3), Y(3), c3, S(3), Cout);

end structural;
