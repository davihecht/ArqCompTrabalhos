LIBRARY ieee; 
USE ieee.std_logic_1164.all ; 
USE ieee.numeric_std.all;


ENTITY ShiftLeft1 IS 
	PORT ( 
		offset:      in STD_LOGIC_VECTOR (31 downto 0);
        ---------------------------------------------------	
		offset_bytes: out STD_LOGIC_VECTOR (31 downto 0)
	); 
END ShiftLeft1 ; 

ARCHITECTURE dataflow OF ShiftLeft1 IS 
	
BEGIN
	offset_bytes <= std_logic_vector(unsigned(offset) sll 1);

END dataflow ;
