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

ENTITY Somador32bits IS
  PORT (
  --Inputs
  	X, Y:   in STD_LOGIC_VECTOR (31 downto 0);
	Cin:    in STD_LOGIC;
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0);
	Cout:   out STD_LOGIC
    );
END Somador32bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF Somador32bits IS

	COMPONENT FullAdder1bit IS
		PORT(A, B: in STD_LOGIC;
  		     Cin:  in STD_LOGIC;
           	     S:    out STD_LOGIC;
	             Cout: out STD_LOGIC
		);
	END COMPONENT;

	signal cin_aux: STD_LOGIC_VECTOR (32 downto 0);
begin	
	cin_aux (0) <= Cin;
	--Cout <= cin_aux(0);

	G1: for i in 0 to 31 GENERATE
		FA_i: FullAdder1bit PORT MAP(
					X(i),
					Y(i),
					cin_aux(i),
					output(i),
					cin_aux(i+1)
					);
	End GENERATE G1;
	Cout <= cin_aux(32);

end structural;

