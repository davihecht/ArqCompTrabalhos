LIBRARY ieee; 
USE ieee.std_logic_1164.all ; 

ENTITY Register1bit IS 
	PORT ( 
		D : IN STD_LOGIC; 
		Clear, Clock: IN STD_LOGIC ; 
        ---------------------------------------------------	
		Q : OUT STD_LOGIC 
	); 
END Register1bit ; 

ARCHITECTURE Behavior OF Register1bit IS 

BEGIN 
	PROCESS ( Clear, Clock ) 
	BEGIN 
		IF Clear= '1' THEN 
			Q <= '0';
		ELSIF Clock 'EVENT AND Clock = '1' THEN Q <= D ; 
		END IF ; 
	END PROCESS ; 
END Behavior ;
