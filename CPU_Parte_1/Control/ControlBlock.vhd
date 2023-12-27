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

ENTITY Control IS
  PORT (
  --Inputs
  	OpCode: in STD_LOGIC_VECTOR (6 downto 0);
  ------------------------------------------------------------------------------	
	ALUSrc, MemtoReg, RegWrite, MemRead: out STD_LOGIC;
	MemWrite, Branch: 		     out STD_LOGIC;
	ALUOp: 				     out STD_LOGIC_VECTOR(1 downto 0)
    );
END Control;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF Control IS
	signal outputs: STD_LOGIC_VECTOR(7 downto 0);

begin	
	with OpCode select outputs <=
		"00100010" when "0110011",
		"11110000" when "0000011",
		"1X001000" when "0100011",
		"0X000101" when "1100011",
		"10100011" when "0010011",
		"00000000" when others;

	ALUSrc <= outputs(7);
	MemtoReg <= outputs(6);
	RegWrite <= outputs(5);
	MemRead <= outputs(4);
	MemWrite <= outputs(3);
	Branch <= outputs(2);
	ALUOp <= outputs(1 downto 0);
	
end structural;
