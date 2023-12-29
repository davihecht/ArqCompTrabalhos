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

ENTITY ALU IS
  PORT (
  --Inputs
  	X, Y:   in STD_LOGIC_VECTOR (31 downto 0);
	op:     in STD_LOGIC_VECTOR (3 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0);
	zero:   out STD_LOGIC
    );
END ALU;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF ALU IS

	COMPONENT Somador32Bits IS
		PORT(X, Y: in STD_LOGIC_VECTOR (31 downto 0);
  		     Cin:  in STD_LOGIC;
           	     output:    out STD_LOGIC_VECTOR (31 downto 0);
	             Cout: out STD_LOGIC
		);
	END COMPONENT;

	COMPONENT Subtrator32bits IS
		PORT(X, Y:    in STD_LOGIC_VECTOR (31 downto 0);
  		     Cin:     in STD_LOGIC;
           	     output:  out STD_LOGIC_VECTOR (31 downto 0);
	             Cout:    out STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT RightShifter IS
		PORT(X:       in STD_LOGIC_VECTOR (31 downto 0);
           	     shifts:  in STD_LOGIC_VECTOR (4 downto 0);
	             output:  out STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

	COMPONENT LeftShifter IS
		PORT(X:       in STD_LOGIC_VECTOR (31 downto 0);
           	     shifts:  in STD_LOGIC_VECTOR (4 downto 0);
	             output:  out STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

	COMPONENT OR32bits IS
		PORT(X, Y:    in STD_LOGIC_VECTOR (31 downto 0);
           	     output: out STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

	COMPONENT XOR32bits IS
		PORT(X, Y:    in STD_LOGIC_VECTOR (31 downto 0);
           	     output: out STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

	COMPONENT AND32bits IS
		PORT(X, Y:    in STD_LOGIC_VECTOR (31 downto 0);
           	     output: out STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

	signal cout_buffer, zero_buffer, not_zero_buffer: STD_LOGIC := '1';
	signal not_Y :       STD_LOGIC_VECTOR (31 downto 0);
	signal output_AND, output_OR, output_ADD:   STD_LOGIC_VECTOR (31 downto 0);
	signal output_SUB, output_XOR, output_SLL:  STD_LOGIC_VECTOR (31 downto 0);
	signal output_SRL:   STD_LOGIC_VECTOR (31 downto 0);	

begin	

	not_Y <= NOT Y;

	AND_OP: AND32bits PORT MAP(X, Y, output_AND);
	OR_OP: OR32bits PORT MAP(X, Y, output_OR);
	ADD_OP: Somador32Bits PORT MAP(X, Y, '0', output_ADD, cout_buffer);
	SUB_OP: Somador32bits PORT MAP(X, not_Y, '1', output_SUB, cout_buffer);
	XOR_OP: XOR32bits PORT MAP(X, Y, output_XOR);
	SLL_OP: LeftShifter PORT MAP(X, Y(4 downto 0), output_SLL);
	SRL_OP: RightShifter PORT MAP(X, Y(4 downto 0), output_SRL);

	--beq
	with output_SUB select zero_buffer <=
		'1' when "00000000000000000000000000000000",
		'0' when others;
	
	--bnq
	not_zero_buffer <= NOT zero_buffer;

	with op select zero <=
		not_zero_buffer when "1110", --bnq
		zero_buffer when others;     --beq	 	


	with op select output <=
		output_AND when "0000",
		output_OR when "0001",
		output_ADD when "0010",
		output_SUB when "0110",
		output_XOR when "0100",
		output_SLL when "1000",
		output_SRL when "1100",
		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" when others;
	
end structural;