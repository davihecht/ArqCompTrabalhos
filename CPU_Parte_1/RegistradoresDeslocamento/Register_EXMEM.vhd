LIBRARY ieee; 
USE ieee.std_logic_1164.all ; 

ENTITY RegistersEXMEM IS 
	-- Inputs
	PORT ( 
		in_RegWrite :      in STD_LOGIC; 
		in_MemToReg :      in STD_LOGIC;
		in_JumpR:          in STD_LOGIC;
		in_Jump:           in STD_LOGIC;
		in_Auipc:          in STD_LOGIC;
		in_Branch :        in STD_LOGIC;
		in_MemRead :       in STD_LOGIC;  
		in_MemWrite :      in STD_LOGIC;  
		in_JumpBranchAdd:  in STD_LOGIC_VECTOR(31 downto 0);
		in_Zero:           in STD_LOGIC;
		in_ALUResult:      in STD_LOGIC_VECTOR(31 downto 0);    
		in_DataRs2:        in STD_LOGIC_VECTOR(31 downto 0);
		in_AddressRd:      in STD_LOGIC_VECTOR(4 downto 0);
		Reset, Clock:      in STD_LOGIC ; 
        ---------------------------------------------------	
	-- Outputs
		out_RegWrite :     out STD_LOGIC; 
		out_MemToReg :     out STD_LOGIC;
		out_JumpR:         out STD_LOGIC;
		out_Jump:          out STD_LOGIC;
		out_Auipc:         out STD_LOGIC;
		out_Branch :       out STD_LOGIC;
		out_MemRead :      out STD_LOGIC;  
		out_MemWrite :     out STD_LOGIC;  
		out_JumpBranchAdd: out STD_LOGIC_VECTOR(31 downto 0);
		out_Zero:          out STD_LOGIC;
		out_ALUResult:     out STD_LOGIC_VECTOR(31 downto 0);
		out_DataRs2:       out STD_LOGIC_VECTOR(31 downto 0);
		out_AddressRd:     out STD_LOGIC_VECTOR(4 downto 0)
	); 
END RegistersEXMEM ; 

ARCHITECTURE structural OF RegistersEXMEM IS 
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
	R3:  Register1bit  PORT MAP(in_JumpR, Reset, Clock, out_JumpR);
	R4:  Register1bit  PORT MAP(in_Jump, Reset, Clock, out_Jump);
	R5:  Register1bit  PORT MAP(in_Auipc, Reset, Clock, out_Auipc);
	R6:  Register1bit  PORT MAP(in_Branch, Reset, Clock, out_Branch);
	R7:  Register1bit  PORT MAP(in_MemRead, Reset, Clock, out_MemRead);
	R8:  Register1bit  PORT MAP(in_MemWrite, Reset, Clock, out_MemWrite);
	R9:  RegisterNbits GENERIC MAP(N=>32) PORT MAP(in_JumpBranchAdd, Reset, Clock, out_JumpBranchAdd);
	R10: Register1bit  PORT MAP(in_Zero, Reset, Clock, out_Zero);
	R11: RegisterNbits GENERIC MAP(N=>32) PORT MAP(in_DataRs2, Reset, Clock, out_DataRs2);
	R12: RegisterNbits GENERIC MAP(N=>5)  PORT MAP(in_AddressRd, Reset, Clock, out_AddressRd);
END structural ;
