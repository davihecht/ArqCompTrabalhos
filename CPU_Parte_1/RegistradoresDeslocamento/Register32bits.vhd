LIBRARY ieee; 
USE ieee.std_logic_1164.all ; 

ENTITY Register32Bits IS 
	PORT ( 
		D : IN STD_LOGIC_VECTOR(31 DOWNTO 0) ; 
		Clear, Clock: IN STD_LOGIC ; 
        ---------------------------------------------------	
		Q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
	); 
END Register32Bits ; 

ARCHITECTURE Behavior OF Register32Bits IS 

BEGIN 
	PROCESS ( Clear, Clock ) 
	BEGIN 
		IF Clear= '1' THEN 
			Q <= "00000000000000000000000000000000" ; 
		ELSIF Clock 'EVENT AND Clock = '1' THEN Q <= D ; 
		END IF ; 
	END PROCESS ; 
END Behavior ;
