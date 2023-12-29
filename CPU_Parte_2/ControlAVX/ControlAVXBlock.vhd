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
	ALUOp:                                   out STD_LOGIC_VECTOR(3 downto 0)
    );
END Control;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF Control IS
	signal outputs: STD_LOGIC_VECTOR(13 downto 0);

begin	
	with OpCode select outputs <=
		"00100000000010" when "0110011", --R-type
		"11110000000000" when "0000011", --lw
		"1X001000000000" when "0100011", --sw
		"0X000100000001" when "1100011", --beq/bne
		"10100000000011" when "0010011", --I-type
		"X010001000XXXX" when "1101111", --UJ-jal
		"10100001000000" when "1100111", --I-jalr
		"X010000010XXXX" when "0110111", --U-lui
		"X010000001XXXX" when "0010111", --U-auipc
		"00100000000100" when "0111011", --R-AVX
		"10100000001000" when "0011011", --I-AVX-4Bits
		"10100000001001" when "0011111", --I-AVX-8Bits
		"10100000001010" when "0101011", --I-AVX-16Bits
		"10100000001011" when "0001011", --I-AVX-32Bits
		"00000000000000" when others;

	ALUSrc <= outputs(13);
	MemtoReg <= outputs(12);
	RegWrite <= outputs(11);
	MemRead <= outputs(10);
	MemWrite <= outputs(9);
	Branch <= outputs(8);
	Jump <= outputs(7);
	JumpR <= outputs(6);
	Lui <= outputs(5);
	Auipc <= outputs(4);
	ALUOp <= outputs(3 downto 0);
	
end structural;
