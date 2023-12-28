LIBRARY ieee; 
USE ieee.std_logic_1164.all ; 

ENTITY RegisterNbits IS 
	GENERIC (N: integer := 1);
	PORT ( 
		D : IN STD_LOGIC_VECTOR(N-1 downto 0);
		Clear, Clock: IN STD_LOGIC ;
        ---------------------------------------------------	
		Q : OUT STD_LOGIC_VECTOR(N-1 downto 0)
	);
END RegisterNbits ;

ARCHITECTURE Behavior OF RegisterNbits IS

BEGIN 
	PROCESS ( Clear, Clock )
	BEGIN 
		IF Clear= '1' THEN
			Q <= (others => '0');
		ELSIF Clock 'EVENT AND Clock = '1' THEN Q <= D ;
		END IF ;
	END PROCESS ;
END Behavior;
