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

ENTITY AluAVX IS
  PORT (
  --Inputs
  	X, Y:    in STD_LOGIC_VECTOR (31 downto 0);
	op:      in STD_LOGIC_VECTOR (3 downto 0);
	vecSize: in STD_LOGIC_VECTOR (1 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0);
	zero:   out STD_LOGIC
    );
END AluAVX;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF AluAVX IS

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

	COMPONENT LeftShifterAVX IS
		PORT(
			X:         in STD_LOGIC_VECTOR (31 downto 0);
  			shifts:    in STD_LOGIC_VECTOR (4 downto 0);
			vecSize:   in STD_LOGIC_VECTOR (1 downto 0);
			resultado: out STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

	COMPONENT RightShifterAVX IS
		PORT(
			X:         in STD_LOGIC_VECTOR (31 downto 0);
  			shifts:    in STD_LOGIC_VECTOR (4 downto 0);
			vecSize:   in STD_LOGIC_VECTOR (1 downto 0);
			resultado: out STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

	COMPONENT SomadorSubtratorAVX IS
		PORT(
			A_i        : IN  std_logic_vector(31 DOWNTO 0); -- input vector 1
    			B_i        : IN  std_logic_vector(31 DOWNTO 0); -- input vector 2
    			mode_i     : IN  std_logic;                     -- Mode: Add or Sub
    			vecSize_i  : IN  std_logic_vector(1 DOWNTO 0);  -- Size: 00 = 4 bits, 01 = 8, 10 = 16, 11 = 32
    			S_o        : OUT std_logic_vector(31 DOWNTO 0)  -- Result vector
		);
	END COMPONENT;

	signal cout_buffer, zero_buffer, not_zero_buffer: STD_LOGIC := '1';
	signal not_Y :                                 STD_LOGIC_VECTOR (31 downto 0);
	signal output_AND, output_OR, output_ADD:      STD_LOGIC_VECTOR (31 downto 0);
	signal output_SUB, output_XOR, output_SLL:     STD_LOGIC_VECTOR (31 downto 0);
	signal output_SRL:                             STD_LOGIC_VECTOR (31 downto 0);
	signal output_SLLAVX, output_SRLAVX:           STD_LOGIC_VECTOR (31 downto 0);
	signal Y_high_buffer: 	                       STD_LOGIC_VECTOR (26 downto 0);
	signal output_SLLAVX_buff, output_SRLAVX_buff: STD_LOGIC_VECTOR (31 downto 0);
	signal output_SLL_buff, output_SRL_buff:       STD_LOGIC_VECTOR (31 downto 0);
	signal output_ADDSUB_AVX:                      STD_LOGIC_VECTOR (31 downto 0);
	signal mode_add_subb:			       STD_LOGIC;

begin	

	not_Y <= NOT Y;

	AND_OP: AND32bits PORT MAP(X, Y, output_AND);
	OR_OP:  OR32bits PORT MAP(X, Y, output_OR);
	ADD_OP: Somador32Bits PORT MAP(X, Y, '0', output_ADD, cout_buffer);
	SUB_OP: Somador32bits PORT MAP(X, not_Y, '1', output_SUB, cout_buffer);
	XOR_OP: XOR32bits PORT MAP(X, Y, output_XOR);
	SLL_OP: LeftShifter PORT MAP(X, Y(4 downto 0), output_SLL_buff);
	SRL_OP: RightShifter PORT MAP(X, Y(4 downto 0), output_SRL_buff);

	SLLAVX_OP: LeftShifterAVX PORT MAP(X, Y(4 downto 0), vecSize, output_SLLAVX_buff);
	SRLAVX_OP: RightShifterAVX PORT MAP(X, Y(4 downto 0), vecSize, output_SRLAVX_buff);

	-- Putting output_Shift = "0000...00" if shifts >= 32.
	Y_high_buffer <= Y(31 downto 5);
	with Y_high_buffer select output_SLL <=
		output_SLL_buff when "000000000000000000000000000",
		(others => '0') when others;
	with Y_high_buffer select output_SRL <=
		output_SRL_buff when "000000000000000000000000000",
		(others => '0') when others;
	with Y_high_buffer select output_SLLAVX <=
		output_SLLAVX_buff when "000000000000000000000000000",
		(others => '0') when others;
	with Y_high_buffer select output_SRLAVX <=
		output_SRLAVX_buff when "000000000000000000000000000",
		(others => '0') when others;

	-- ADDSUB AVX

	-- "Add" if begins with '0', "Sub" if begins with '1'. Result only used if it is the ADD or SUB op
	mode_add_subb <= op(3);

	ADDSUB_AVX_OP: SomadorSubtratorAVX PORT MAP(X, Y, mode_add_subb, vecSize, output_ADDSUB_AVX);


	--zero_shift: process(Y_high_buffer)
	--begin
	--	if (Y_high_buffer = "000000000000000000000000000") then
	--		output_SLL <= (others => '0');
	--		output_SRL <= (others => '0');
	--		output_SLLAVX <= (others => '0');
	--		output_SRLAVX <= (others => '0');
		--else
	--		output_SLL <= output_SLL_buff;
	--		output_SRL <= output_SRL_buff;
	--		output_SLLAVX <= output_SLLAVX_buff;
	--		output_SRLAVX <= output_SRLAVX_buff;
	--	end if;
	--end process zero_shift;
	

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
		output_OR  when "0001",
		output_ADD when "0010",
		output_SUB when "0110",
		output_XOR when "0100",
		output_SLL when "1000",
		output_SRL when "1100",
		output_SLLAVX when "0011",
		output_SRLAVX when "0101",
		output_ADDSUB_AVX when "0111",
		output_ADDSUB_AVX when "1010",
		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" when others;
	
end structural;


---------------------
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

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY RightShifter IS
  PORT (
  --Inputs
  	X: in STD_LOGIC_VECTOR (31 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0)
    );
END RightShifter;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF RightShifter IS
begin	
	output <= std_logic_vector(unsigned(X) srl to_integer(unsigned(shifts)));

end structural;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY LeftShifter IS
  PORT (
  --Inputs
  	X: in STD_LOGIC_VECTOR (31 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0)
    );
END LeftShifter;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF LeftShifter IS
begin	
	output <= std_logic_vector(unsigned(X) sll to_integer(unsigned(shifts)));

end structural;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY OR32bits IS
  PORT (
  --Inputs
  	X, Y: in STD_LOGIC_VECTOR (31 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0)
    );
END OR32bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF OR32bits IS
begin	
	output <= X OR Y;

end structural;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY XOR32bits IS
  PORT (
  --Inputs
  	X, Y: in STD_LOGIC_VECTOR (31 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0)
    );
END XOR32bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF XOR32bits IS
begin	
	output <= X XOR Y;

end structural;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY AND32bits IS
  PORT (
  --Inputs
  	X, Y: in STD_LOGIC_VECTOR (31 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0)
    );
END AND32bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF AND32bits IS
begin	
	output <= X AND Y;

end structural;

----------------
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

----------------------- RIGHT SHIFTER AVX 

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY RightShifterAVX IS
  PORT (
  --Inputs
    	X: 		in STD_LOGIC_VECTOR (31 downto 0); 
	shifts:         in STD_LOGIC_VECTOR (4 downto 0); 
    	vecSize:        in STD_LOGIC_VECTOR (1 downto 0);
  ------------------------------------------------------------------------------
  --Outputs
    	resultado:      out STD_LOGIC_VECTOR (31 downto 0)
    );
END RightShifterAVX;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF RightShifterAVX IS

	COMPONENT RightShifterAVX4Bits IS
		PORT(
			X:      in STD_LOGIC_VECTOR (31 downto 0);
  			shifts: in STD_LOGIC_VECTOR (4 downto 0);
			output: out STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

	COMPONENT RightShifterAVX8Bits IS
		PORT(
			X:      in STD_LOGIC_VECTOR (31 downto 0);
  			shifts: in STD_LOGIC_VECTOR (4 downto 0);
			output: out STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

	COMPONENT RightShifterAVX16Bits IS
		PORT(
			X:      in STD_LOGIC_VECTOR (31 downto 0);
  			shifts: in STD_LOGIC_VECTOR (4 downto 0);
			output: out STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

	COMPONENT RightShifterAVX32Bits IS
		PORT(
			X:      in STD_LOGIC_VECTOR (31 downto 0);
  			shifts: in STD_LOGIC_VECTOR (4 downto 0);
			output: out STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

	signal output_avx4, output_avx8, output_avx16, output_avx32:  STD_LOGIC_VECTOR (31 downto 0);
	
begin
	
	RS_4: RightShifterAVX4Bits PORT MAP (X, shifts, output_avx4);
	RS_8: RightShifterAVX8Bits PORT MAP (X, shifts, output_avx8); 
	RS_16: RightShifterAVX16Bits PORT MAP (X, shifts, output_avx16); 
	RS_32: RightShifterAVX32Bits PORT MAP (X, shifts, output_avx32); 

	with vecSize select resultado <=
		output_avx4 when "00",
		output_avx8 when "01",
		output_avx16 when "10",
		output_avx32 when "11",
		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" when others;

END structural;


----------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY RightShifterAVX32Bits IS
  PORT (
  --Inputs
  	X:      in STD_LOGIC_VECTOR (31 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0)
    );
END RightShifterAVX32Bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE dataflow OF RightShifterAVX32Bits IS
	COMPONENT RightShifter32Bits IS
		PORT(X:       in STD_LOGIC_VECTOR (31 downto 0);
           	     shifts:  in STD_LOGIC_VECTOR (4 downto 0);
	             output:  out STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

begin	
	RS32: RightShifter32Bits PORT MAP(X, shifts, output);

end dataflow;

---------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY RightShifterAVX16Bits IS
  PORT (
  --Inputs
  	X:      in STD_LOGIC_VECTOR (31 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0)
    );
END RightShifterAVX16Bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE dataflow OF RightShifterAVX16Bits IS
	COMPONENT RightShifter16Bits IS
		PORT(X:       in STD_LOGIC_VECTOR (15 downto 0);
           	     shifts:  in STD_LOGIC_VECTOR (4 downto 0);
	             output:  out STD_LOGIC_VECTOR (15 downto 0)
		);
	END COMPONENT;

begin	
	RS16_1: RightShifter16Bits PORT MAP(X(15 downto 0), shifts, output(15 downto 0));
	RS16_2: RightShifter16Bits PORT MAP(X(31 downto 16), shifts, output(31 downto 16));

end dataflow;

---------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY RightShifterAVX8Bits IS
  PORT (
  --Inputs
  	X:      in STD_LOGIC_VECTOR (31 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0)
    );
END RightShifterAVX8Bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE dataflow OF RightShifterAVX8Bits IS
	COMPONENT RightShifter8Bits IS
		PORT(X:       in STD_LOGIC_VECTOR (7 downto 0);
           	     shifts:  in STD_LOGIC_VECTOR (4 downto 0);
	             output:  out STD_LOGIC_VECTOR (7 downto 0)
		);
	END COMPONENT;

begin	
	G1: for i in 0 to 3 GENERATE
		RS_i: RightShifter8Bits PORT MAP(
					X(i*8+7 downto i*8), 
					shifts, 
					output(i*8+7 downto i*8)
					);
	End GENERATE G1;
end dataflow;

--------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY RightShifterAVX4Bits IS
  PORT (
  --Inputs
  	X:      in STD_LOGIC_VECTOR (31 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0)
    );
END RightShifterAVX4Bits; 

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE dataflow OF RightShifterAVX4Bits IS
	COMPONENT RightShifter4Bits IS
		PORT(X:       in STD_LOGIC_VECTOR (3 downto 0);
           	     shifts:  in STD_LOGIC_VECTOR (4 downto 0);
	             output:  out STD_LOGIC_VECTOR (3 downto 0)
		);
	END COMPONENT;

begin	
	G1: for i in 0 to 7 GENERATE
		RS_i: RightShifter4Bits PORT MAP(
					X(i*4+3 downto i*4), 
					shifts, 
					output(i*4+3 downto i*4)
					);
	End GENERATE G1;
end dataflow;

--------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY RightShifter32Bits IS
  PORT (
  --Inputs
  	X:      in STD_LOGIC_VECTOR (31 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0)
    );
END RightShifter32Bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE dataflow OF RightShifter32Bits IS
begin	
	output <= std_logic_vector(unsigned(X) srl to_integer(unsigned(shifts)));

end dataflow;

--------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY RightShifter16Bits IS
  PORT (
  --Inputs
  	X:      in STD_LOGIC_VECTOR (15 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (15 downto 0)
    );
END RightShifter16Bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE dataflow OF RightShifter16Bits IS
begin	
	output <= std_logic_vector(unsigned(X) srl to_integer(unsigned(shifts)));

end dataflow;

---------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY RightShifter8Bits IS
  PORT (
  --Inputs
  	X:      in STD_LOGIC_VECTOR (7 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (7 downto 0)
    );
END RightShifter8Bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE dataflow OF RightShifter8Bits IS
begin	
	output <= std_logic_vector(unsigned(X) srl to_integer(unsigned(shifts)));

end dataflow;

--------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY RightShifter4Bits IS
  PORT (
  --Inputs
  	X:      in STD_LOGIC_VECTOR (3 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (3 downto 0)
    );
END RightShifter4Bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE dataflow OF RightShifter4Bits IS
begin	
	output <= std_logic_vector(unsigned(X) srl to_integer(unsigned(shifts)));

end dataflow;

---------

----------------------- LEFT SHIFTER AVX

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY LeftShifterAVX IS
  PORT (
  --Inputs
    	X: 		in STD_LOGIC_VECTOR (31 downto 0); 
	shifts:         in STD_LOGIC_VECTOR (4 downto 0); 
    	vecSize:        in STD_LOGIC_VECTOR (1 downto 0);
  ------------------------------------------------------------------------------
  --Outputs
    	resultado:      out STD_LOGIC_VECTOR (31 downto 0)
    );
END LeftShifterAVX;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF LeftShifterAVX IS

	COMPONENT LeftShifterAVX4Bits IS
		PORT(
			X:      in STD_LOGIC_VECTOR (31 downto 0);
  			shifts: in STD_LOGIC_VECTOR (4 downto 0);
			output: out STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

	COMPONENT LeftShifterAVX8Bits IS
		PORT(
			X:      in STD_LOGIC_VECTOR (31 downto 0);
  			shifts: in STD_LOGIC_VECTOR (4 downto 0);
			output: out STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

	COMPONENT LeftShifterAVX16Bits IS
		PORT(
			X:      in STD_LOGIC_VECTOR (31 downto 0);
  			shifts: in STD_LOGIC_VECTOR (4 downto 0);
			output: out STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

	COMPONENT LeftShifterAVX32Bits IS
		PORT(
			X:      in STD_LOGIC_VECTOR (31 downto 0);
  			shifts: in STD_LOGIC_VECTOR (4 downto 0);
			output: out STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

	signal output_avx4, output_avx8, output_avx16, output_avx32:  STD_LOGIC_VECTOR (31 downto 0);
	
begin
	
	LS_4: LeftShifterAVX4Bits PORT MAP (X, shifts, output_avx4);
	LS_8: LeftShifterAVX8Bits PORT MAP (X, shifts, output_avx8); 
	LS_16: LeftShifterAVX16Bits PORT MAP (X, shifts, output_avx16); 
	LS_32: LeftShifterAVX32Bits PORT MAP (X, shifts, output_avx32); 

	with vecSize select resultado <=
		output_avx4 when "00",
		output_avx8 when "01",
		output_avx16 when "10",
		output_avx32 when "11",
		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" when others;

END structural;


----------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY LeftShifter4Bits IS
  PORT (
  --Inputs
  	X:      in STD_LOGIC_VECTOR (3 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (3 downto 0)
    );
END LeftShifter4Bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE dataflow OF LeftShifter4Bits IS
begin	
	output <= std_logic_vector(unsigned(X) sll to_integer(unsigned(shifts)));

end dataflow;


-----
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY LeftShifter8Bits IS
  PORT (
  --Inputs
  	X:      in STD_LOGIC_VECTOR (7 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (7 downto 0)
    );
END LeftShifter8Bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE dataflow OF LeftShifter8Bits IS
begin	
	output <= std_logic_vector(unsigned(X) sll to_integer(unsigned(shifts)));

end dataflow;



-----
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY LeftShifter16Bits IS
  PORT (
  --Inputs
  	X:      in STD_LOGIC_VECTOR (15 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (15 downto 0)
    );
END LeftShifter16Bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE dataflow OF LeftShifter16Bits IS
begin	
	output <= std_logic_vector(unsigned(X) sll to_integer(unsigned(shifts)));

end dataflow;


----

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY LeftShifter32Bits IS
  PORT (
  --Inputs
  	X:      in STD_LOGIC_VECTOR (31 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0)
    );
END LeftShifter32Bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE dataflow OF LeftShifter32Bits IS
begin	
	output <= std_logic_vector(unsigned(X) sll to_integer(unsigned(shifts)));

end dataflow;


-----
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY LeftShifterAVX4Bits IS
  PORT (
  --Inputs
  	X:      in STD_LOGIC_VECTOR (31 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0)
    );
END LeftShifterAVX4Bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE dataflow OF LeftShifterAVX4Bits IS
	COMPONENT LeftShifter4Bits IS
		PORT(X:       in STD_LOGIC_VECTOR (3 downto 0);
           	     shifts:  in STD_LOGIC_VECTOR (4 downto 0);
	             output:  out STD_LOGIC_VECTOR (3 downto 0)
		);
	END COMPONENT;

begin	
	G1: for i in 0 to 7 GENERATE
		LS_i: LeftShifter4Bits PORT MAP(
					X(i*4+3 downto i*4), 
					shifts, 
					output(i*4+3 downto i*4)
					);
	End GENERATE G1;
end dataflow;


----
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY LeftShifterAVX8Bits IS
  PORT (
  --Inputs
  	X:      in STD_LOGIC_VECTOR (31 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0)
    );
END LeftShifterAVX8Bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE dataflow OF LeftShifterAVX8Bits IS
	COMPONENT LeftShifter8Bits IS
		PORT(X:       in STD_LOGIC_VECTOR (7 downto 0);
           	     shifts:  in STD_LOGIC_VECTOR (4 downto 0);
	             output:  out STD_LOGIC_VECTOR (7 downto 0)
		);
	END COMPONENT;

begin	
	G1: for i in 0 to 3 GENERATE
		LS_i: LeftShifter8Bits PORT MAP(
					X(i*8+7 downto i*8), 
					shifts, 
					output(i*8+7 downto i*8)
					);
	End GENERATE G1;
end dataflow;

----
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY LeftShifterAVX16Bits IS
  PORT (
  --Inputs
  	X:      in STD_LOGIC_VECTOR (31 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0)
    );
END LeftShifterAVX16Bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE dataflow OF LeftShifterAVX16Bits IS
	COMPONENT LeftShifter16Bits IS
		PORT(X:       in STD_LOGIC_VECTOR (15 downto 0);
           	     shifts:  in STD_LOGIC_VECTOR (4 downto 0);
	             output:  out STD_LOGIC_VECTOR (15 downto 0)
		);
	END COMPONENT;

begin	
	LS16_1: LeftShifter16Bits PORT MAP(X(15 downto 0), shifts, output(15 downto 0));
	LS16_2: LeftShifter16Bits PORT MAP(X(31 downto 16), shifts, output(31 downto 16));

end dataflow;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY LeftShifterAVX32Bits IS
  PORT (
  --Inputs
  	X:      in STD_LOGIC_VECTOR (31 downto 0);
  	shifts: in STD_LOGIC_VECTOR (4 downto 0);
  ------------------------------------------------------------------------------	
	output: out STD_LOGIC_VECTOR (31 downto 0)
    );
END LeftShifterAVX32Bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE dataflow OF LeftShifterAVX32Bits IS
	COMPONENT LeftShifter32Bits IS
		PORT(X:       in STD_LOGIC_VECTOR (31 downto 0);
           	     shifts:  in STD_LOGIC_VECTOR (4 downto 0);
	             output:  out STD_LOGIC_VECTOR (31 downto 0)
		);
	END COMPONENT;

begin	
	LS32: LeftShifter32Bits PORT MAP(X, shifts, output);

end dataflow;


----------------------- SOMADOR SUBTRATOR AVX

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY SomadorSubtratorAVX IS
  PORT (
  ------------------------------------------------------------------------------
  --Insert input ports below
    A_i        : IN  std_logic_vector(31 DOWNTO 0); -- input vector 1
    B_i        : IN  std_logic_vector(31 DOWNTO 0); -- input vector 2
    mode_i     : IN  std_logic;                     -- Mode: Add or Sub
    vecSize_i  : IN  std_logic_vector(1 DOWNTO 0);  -- Size: 00 = 4 bits, 01 = 8, 10 = 16, 11 = 32
  ------------------------------------------------------------------------------
  --Insert output ports below
    S_o        : OUT std_logic_vector(31 DOWNTO 0) -- Result vector
    );
END SomadorSubtratorAVX;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF SomadorSubtratorAVX IS
	COMPONENT ALU4bits IS
		PORT(X, Y:         IN  STD_LOGIC_VECTOR (3 downto 0);
  		     seletor, Cin: IN  STD_LOGIC;
  		     Juntar:       IN  STD_LOGIC;
         	     resultado:    OUT STD_LOGIC_VECTOR (3 downto 0);
	      	     Cout:         OUT STD_LOGIC
		);
	END COMPONENT;
	signal juntar, resultado: STD_LOGIC_VECTOR (7 downto 0); 
	signal cin_i:  STD_LOGIC_VECTOR (8 downto 0); 
	
BEGIN
	cin_i(0) <= '0'; -- Just to initialize, doesn't matter
	juntar(0) <= '0';

	-- When vecSize_i == 01
	juntar(1) <= vecSize_i(1) OR vecSize_i(0);
	juntar(3) <= juntar(1);
	juntar(5) <= juntar(3);
	juntar(7) <= juntar(5); 

	-- When vecSize_i == 10
	juntar(2) <= vecSize_i(1);
	juntar(6) <= juntar(2);

	-- When vecSize_i == 11
	juntar(4) <= vecSize_i(1) AND vecSize_i(0);

	G1: for i in 0 to 7 GENERATE
		func_i: ALU4bits PORT MAP(
					A_i(i*4+3 downto i*4),
					B_i(i*4+3 downto i*4),
					mode_i,
					cin_i(i),
					juntar(i),
					S_o(i*4+3 downto i*4),
					cin_i(i+1)
					);
	End GENERATE G1;

END structural;


-------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY ALU4bits IS
  PORT (
  --Inputs
    X, Y:          IN STD_LOGIC_VECTOR (3 downto 0); 
    seletor, Cin:  IN STD_LOGIC; -- Cin = Cout-1 (se primeiro, n importa, lógica desse código ignorará)
    Juntar: 	   IN STD_LOGIC; -- Se junta com a ALU anterior para formar tamanho maior de bits.
  ------------------------------------------------------------------------------
  --Outputs
    resultado:     OUT STD_LOGIC_VECTOR (3 downto 0); 
    Cout:          OUT STD_LOGIC
    );
END ALU4bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF ALU4bits IS

	COMPONENT Somador4Bits IS
		PORT(X, Y: in STD_LOGIC_VECTOR (3 downto 0);
  			Cin:  in STD_LOGIC;
               S:    out STD_LOGIC_VECTOR (3 downto 0);
	          Cout: out STD_LOGIC
		);
	END COMPONENT;
	COMPONENT MUX21_4Bits IS
		PORT(X, Y:          IN STD_LOGIC_VECTOR (3 downto 0);
			seletor:   IN STD_LOGIC;
  			saida:     OUT STD_LOGIC_VECTOR (3 downto 0)
		);
	END COMPONENT;
	signal operando_2:  STD_LOGIC_VECTOR (3 downto 0);
	signal cin_somador: STD_LOGIC;
	signal not_Y:       STD_LOGIC_VECTOR (3 downto 0);
	
begin
	--NOT Y
	not_Y <= NOT Y;

	-- Coloca como operando o Y invertido se for escolhido a subtração
	MUX_21: MUX21_4Bits PORT MAP(Y, not_Y, seletor, operando_2);

	
	-- Lógica para determinar o cin considerando o Juntar e a seleção Add/Sub
	cin_somador <= (NOT (Juntar) AND seletor) OR (Juntar AND Cin);


	ALU_4BIT: Somador4Bits PORT MAP (X, operando_2, cin_somador, resultado, Cout); 
	
END structural;


---------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY MUX21_4Bits IS
  PORT (
  ------------------------------------------------------------------------------
  --Insert input ports below
    X, Y:     in STD_LOGIC_VECTOR (3 downto 0);                 
    seletor:  IN STD_LOGIC;
  ------------------------------------------------------------------------------
  --Insert output ports below
    saida:    out STD_LOGIC_VECTOR (3 downto 0)
    );
END MUX21_4Bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF MUX21_4Bits IS

BEGIN
	saida(0) <= (NOT(seletor) AND X(0)) OR (seletor AND Y(0));
	saida(1) <= (NOT(seletor) AND X(1)) OR (seletor AND Y(1));
	saida(2) <= (NOT(seletor) AND X(2)) OR (seletor AND Y(2));
	saida(3) <= (NOT(seletor) AND X(3)) OR (seletor AND Y(3));
	
END structural;


LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Somador4Bits IS
  PORT (
  --Inputs
  	X, Y: in STD_LOGIC_VECTOR (3 downto 0);
  	Cin: in STD_LOGIC;
  ------------------------------------------------------------------------------	
	S: out STD_LOGIC_VECTOR (3 downto 0);
	Cout: out STD_LOGIC
    );
END Somador4Bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF Somador4Bits IS

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

