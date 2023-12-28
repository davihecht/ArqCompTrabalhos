LIBRARY ieee; 
USE ieee.std_logic_1164.all ; 

ENTITY PC IS 
	PORT ( 
		NewAddress:   in STD_LOGIC_VECTOR(31 downto 0);
		Reset, Clock:  in STD_LOGIC;
        ---------------------------------------------------	
		PCAddress:     out STD_LOGIC_VECTOR(31 downto 0)
	);
END PC ;

ARCHITECTURE structural OF PC IS
	COMPONENT RegisterNbits IS
		GENERIC(N: in integer);
		PORT(D : IN STD_LOGIC_VECTOR(N-1 downto 0); 
                     Clear, Clock: IN STD_LOGIC ; 	
		     Q : OUT STD_LOGIC_VECTOR(N-1 downto 0) 
		);
	END COMPONENT;
BEGIN 	
	PC_R: RegisterNbits GENERIC MAP(N=>32) PORT MAP(NewAddress, Reset, Clock, PCAddress);

END structural;
