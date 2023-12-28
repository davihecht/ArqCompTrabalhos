LIBRARY ieee; 
USE ieee.std_logic_1164.all ; 

ENTITY RegistersMEMWB IS 
	-- Inputs
	PORT ( 
		in_RegWrite :   in STD_LOGIC; 
		in_MemToReg :   in STD_LOGIC;
		in_ReadMemData: in STD_LOGIC_VECTOR(31 downto 0);
		in_AddressMem:  in STD_LOGIC_VECTOR(31 downto 0);
		in_AddressRd:   in STD_LOGIC_VECTOR(4 downto 0);
		Reset, Clock:   in STD_LOGIC ; 
        ---------------------------------------------------	
	-- Outputs
		out_RegWrite :   out STD_LOGIC; 
		out_MemToReg :   out STD_LOGIC;
		out_ReadMemData: out STD_LOGIC_VECTOR(31 downto 0);
		out_AddressMem:  out STD_LOGIC_VECTOR(31 downto 0);
		out_AddressRd:   out STD_LOGIC_VECTOR(4 downto 0)
	); 
END RegistersMEMWB ; 

ARCHITECTURE structural OF RegistersMEMWB IS 
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
	R1: Register1bit  PORT MAP(in_RegWrite, Reset, Clock, out_RegWrite);
	R2: Register1bit  PORT MAP(in_MemToReg, Reset, Clock, out_MemToReg);
	R3: RegisterNbits GENERIC MAP(N=>32) PORT MAP(in_ReadMemData, Reset, Clock, out_ReadMemData);	
	R4: RegisterNbits GENERIC MAP(N=>32)  PORT MAP(in_AddressMem, Reset, Clock, out_AddressMem);
	R5: RegisterNbits GENERIC MAP(N=>5)  PORT MAP(in_AddressRd, Reset, Clock, out_AddressRd);

END structural ;