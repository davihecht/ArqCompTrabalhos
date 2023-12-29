LIBRARY ieee; 
USE ieee.std_logic_1164.all ; 


ENTITY MUX31_32Bits IS 
	PORT ( 
		input_0: in STD_LOGIC_VECTOR (31 downto 0);
		input_1: in STD_LOGIC_VECTOR (31 downto 0);
		input_2: in STD_LOGIC_VECTOR (31 downto 0);
		opt:     in STD_LOGIC_VECTOR (1 downto 0);
        ---------------------------------------------------	
		output:  out STD_LOGIC_VECTOR (31 downto 0)
	); 
END MUX31_32Bits ; 

ARCHITECTURE dataflow OF MUX31_32Bits IS 

BEGIN	
	with opt select output <=
		input_0 when "00",
		input_1 when "01",
		input_2 when others;

END dataflow ;
