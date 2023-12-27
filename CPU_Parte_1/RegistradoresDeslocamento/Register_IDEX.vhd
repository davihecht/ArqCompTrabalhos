LIBRARY ieee; 
USE ieee.std_logic_1164.all ; 

ENTITY RegistersIDEX IS 
	-- Inputs
	PORT ( 
		in_RegWrite :   in STD_LOGIC;
		in_MemToReg :   in STD_LOGIC;
		in_Branch :     in STD_LOGIC;
		in_MemRead :    in STD_LOGIC;
		in_MemWrite :   in STD_LOGIC;
		in_ALUOp :      in STD_LOGIC_VECTOR(1 downto 0);
		in_ALUSrc :     in STD_LOGIC;
		in_InstAddress: in STD_LOGIC_VECTOR(7 downto 0);
		in_DataRs1:     in STD_LOGIC_VECTOR(31 downto 0);
		in_DataRs2:     in STD_LOGIC_VECTOR(31 downto 0);
		in_Immediate:   in STD_LOGIC_VECTOR(31 downto 0);
		in_funct7_10:   in STD_LOGIC;
		in_funct3:      in STD_LOGIC_VECTOR(2 downto 0);
		in_AddressRd:   in STD_LOGIC_VECTOR(4 downto 0);
		Reset, Clock:   in STD_LOGIC ;
        ---------------------------------------------------	
	-- Outputs
		out_RegWrite :   out STD_LOGIC;
		out_MemToReg :   out STD_LOGIC;
		out_Branch :     out STD_LOGIC;
		out_MemRead :    out STD_LOGIC;
		out_MemWrite :   out STD_LOGIC;
		out_ALUOp :      out STD_LOGIC_VECTOR(1 downto 0);
		out_ALUSrc :     out STD_LOGIC;
		out_InstAddress: out STD_LOGIC_VECTOR(7 downto 0);
		out_DataRs1:     out STD_LOGIC_VECTOR(31 downto 0);
		out_DataRs2:     out STD_LOGIC_VECTOR(31 downto 0);
		out_Immediate:   out STD_LOGIC_VECTOR(31 downto 0);
		out_funct7_10:   out STD_LOGIC;
		out_funct3:      out STD_LOGIC_VECTOR(2 downto 0);
		out_AddressRd:   out STD_LOGIC_VECTOR(4 downto 0)
	); 
END RegistersIDEX ; 

ARCHITECTURE structural OF RegistersIDEX IS 
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
	R1:  Register1bit  PORT MAP(in_RegWrite, Reset, Clock, out_RegWrite);
	R2:  Register1bit  PORT MAP(in_MemToReg, Reset, Clock, out_MemToReg);
	R3:  Register1bit  PORT MAP(in_Branch, Reset, Clock, out_Branch);
	R4:  Register1bit  PORT MAP(in_MemRead, Reset, Clock, out_MemRead);
	R5:  Register1bit  PORT MAP(in_MemWrite, Reset, Clock, out_MemWrite);
	R6:  RegisterNbits GENERIC MAP(N=>2)  PORT MAP(in_ALUOp, Reset, Clock, out_ALUOp);
	R7:  Register1bit  PORT MAP(in_ALUSrc, Reset, Clock, out_ALUSrc);
	R8:  RegisterNbits GENERIC MAP(N=>8) PORT MAP(in_InstAddress, Reset, Clock, out_InstAddress);
	R9:  RegisterNbits GENERIC MAP(N=>32) PORT MAP(in_DataRs1, Reset, Clock, out_DataRs1);
	R10: RegisterNbits GENERIC MAP(N=>32) PORT MAP(in_DataRs2, Reset, Clock, out_DataRs2);
	R11: RegisterNbits GENERIC MAP(N=>32) PORT MAP(in_Immediate, Reset, Clock, out_Immediate);
	R12: Register1bit  PORT MAP(in_funct7_10, Reset, Clock, out_funct7_10);
	R13: RegisterNbits GENERIC MAP(N=>3)  PORT MAP(in_funct3, Reset, Clock, out_funct3);
	R14: RegisterNbits GENERIC MAP(N=>5)  PORT MAP(in_AddressRd, Reset, Clock, out_AddressRd);
END structural;