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

ENTITY FullAdder1bit IS
  PORT (
  --Inputs
    A, B, Cin: in STD_LOGIC;
  ------------------------------------------------------------------------------
  --Outputs
    S, Cout: out STD_LOGIC
   );
END FullAdder1bit;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE dataflow OF FullAdder1bit IS

BEGIN

	S <= Cin XOR (A XOR B);
	Cout <= (A AND Cin) OR (B AND Cin) OR (A AND B);

END dataflow;
