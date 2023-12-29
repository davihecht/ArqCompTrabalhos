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
	RegWrite, MemtoReg, JumpR, Jump, Auipc:  out STD_LOGIC;
	Branch, MemRead, MemWrite, Lui, ALUSrc:  out STD_LOGIC;
	ALUOp: 				         out STD_LOGIC_VECTOR(1 downto 0)
	
    );
END Control;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF Control IS
	signal outputs: STD_LOGIC_VECTOR(11 downto 0);

begin	
 
	with OpCode select outputs <=
		"001000000010" when "0110011", --R-type
		"111100000000" when "0000011", --lw
		"1X0010000000" when "0100011", --sw
		"0X0001000001" when "1100011", --beq/bne
		"101000000011" when "0010011", --I-type
		"X010001000XX" when "1101111", --UJ-jal
		"101000010000" when "1100111", --I-jalr
		"X010000010XX" when "0110111", --U-lui
		"X010000001XX" when "0010111", --U-auipc
		"000000000000" when others;

	ALUSrc <= outputs(11);
	MemtoReg <= outputs(10);
	RegWrite <= outputs(9);
	MemRead <= outputs(8);
	MemWrite <= outputs(7);
	Branch <= outputs(6);
	Jump <= outputs(5);
	JumpR <= outputs(4);
	Lui <= outputs(3);
	Auipc <= outputs(2);
	ALUOp <= outputs(1 downto 0);
	
end structural;
