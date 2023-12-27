LIBRARY ieee; 
USE ieee.std_logic_1164.all ; 

ENTITY RegistersIFID IS 
	-- Inputs
	PORT ( 
		in_InstAddress: in STD_LOGIC_VECTOR(7 downto 0);
		in_Instruction: in STD_LOGIC_VECTOR(31 downto 0);
		Reset, Clock:   in STD_LOGIC ;
        ---------------------------------------------------	
	-- Outputs
		out_InstAddress: out STD_LOGIC_VECTOR(7 downto 0);
		out_Instruction: out STD_LOGIC_VECTOR(31 downto 0)
	); 
END RegistersIFID ; 

ARCHITECTURE structural OF RegistersIFID IS 
	COMPONENT RegisterNbits IS
		GENERIC(N: in integer);
		PORT(D : IN STD_LOGIC_VECTOR(N-1 downto 0); 
                     Clear, Clock: IN STD_LOGIC ; 	
		     Q : OUT STD_LOGIC_VECTOR(N-1 downto 0) 
		);
	END COMPONENT;

	COMPONENT Register1bit IS
		PORT(D : IN STD_LOGIC; 
                     Clear, Clock: IN STD_LOGIC ; 	
		     Q : OUT STD_LOGIC 
		);
	END COMPONENT;
BEGIN 
	R1: RegisterNbits GENERIC MAP(N=>8) PORT MAP(in_InstAddress, Reset, Clock, out_InstAddress);	
	R2: RegisterNbits GENERIC MAP(N=>32)  PORT MAP(in_Instruction, Reset, Clock, out_Instruction);
END structural ;