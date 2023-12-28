LIBRARY ieee; 
USE ieee.std_logic_1164.all ; 


ENTITY MUX32Bits IS 
	PORT ( 
		input_0: in STD_LOGIC_VECTOR (31 downto 0);
		input_1: in STD_LOGIC_VECTOR (31 downto 0);
		opt:     in STD_LOGIC;
        ---------------------------------------------------	
		output:  out STD_LOGIC_VECTOR (31 downto 0)
	); 
END MUX32Bits ; 

ARCHITECTURE dataflow OF MUX32Bits IS 

BEGIN	
	with opt select output <=
		input_0 when '0',
		input_1 when others;

END dataflow ;
