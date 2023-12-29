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

ENTITY ALUControl IS
  PORT (
  --Inputs
  	ALUOp:  in STD_LOGIC_VECTOR (1 downto 0);
	instruction: in STD_LOGIC_VECTOR (31 downto 0);
  ------------------------------------------------------------------------------	
	op:     out STD_LOGIC_VECTOR (3 downto 0)
    );
END ALUControl;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF ALUControl IS
	signal funct3:         STD_LOGIC_VECTOR (2 downto 0);
	signal funct7_30:      STD_LOGIC;

	signal funct7func3:    STD_LOGIC_VECTOR(3 downto 0);
	signal op_buffer_R, op_buffer_I, op_buffer_benq: STD_LOGIC_VECTOR(3 downto 0);

begin	
	
	funct3 <= instruction(14 downto 12);
	funct7_30 <= instruction(30);

	funct7func3(3) <= funct7_30;
	funct7func3(2 downto 0) <= funct3;

	with funct7func3 select op_buffer_R <=
		"0010" when "0000", --add
		"0110" when "1000", --sub
		"0000" when "0111", --AND
		"0001" when "0110", --OR
		"0100" when "0100", --XOR
		"1000" when "0001", --SLL
		"1100" when "0101", --SRL
		"1111" when others;	    --invalid

	with funct3 select op_buffer_I <=
		"0010" when "000", --addi
		"0000" when "111", --ANDi
		"0001" when "110", --ORi
		"0100" when "100", --XORi
		"1000" when "001", --SLLi
		"1100" when "101", --SRLi
		"1111" when others;         --invalid

	with funct3 select op_buffer_benq <=
		"XXX1" when "000", --beq
		"1110" when "001", --bne
		"1111" when others;         --invalid

	
	with ALUOp select op <=
		"0010" when "00", --lw/sw/jalr
		op_buffer_benq when "01",
		op_buffer_R when "10",
		op_buffer_I when "11",
		"1111" when others;
	
end structural;
