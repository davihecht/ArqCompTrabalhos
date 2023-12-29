LIBRARY ieee; 
USE ieee.std_logic_1164.all ; 

ENTITY RegistersIDEX IS 
	-- Inputs
	PORT ( 
		in_RegWrite :   in STD_LOGIC;
		in_MemToReg :   in STD_LOGIC;
		in_JumpR:       in STD_LOGIC;
		in_Jump:        in STD_LOGIC;
		in_Auipc:       in STD_LOGIC;
		in_Branch :     in STD_LOGIC;
		in_PCNext:      in STD_LOGIC_VECTOR(31 downto 0);
		in_MemRead :    in STD_LOGIC;
		in_MemWrite :   in STD_LOGIC;
		in_Lui:         in STD_LOGIC;
		in_ALUOp :      in STD_LOGIC_VECTOR(1 downto 0);
		in_ALUSrc :     in STD_LOGIC;
		in_InstAddress: in STD_LOGIC_VECTOR(31 downto 0);
		in_DataRs1:     in STD_LOGIC_VECTOR(31 downto 0);
		in_DataRs2:     in STD_LOGIC_VECTOR(31 downto 0);
		in_Immediate:   in STD_LOGIC_VECTOR(31 downto 0);
		in_instruction: in STD_LOGIC_VECTOR(31 downto 0);
		Reset, Clock:   in STD_LOGIC ;
        ---------------------------------------------------	
	-- Outputs
		out_RegWrite :   out STD_LOGIC;
		out_MemToReg :   out STD_LOGIC;
		out_JumpR:       out STD_LOGIC;
		out_Jump:        out STD_LOGIC;
		out_Auipc:       out STD_LOGIC;
		out_Branch :     out STD_LOGIC;
		out_PCNext:      out STD_LOGIC_VECTOR(31 downto 0);
		out_MemRead :    out STD_LOGIC;
		out_MemWrite :   out STD_LOGIC;
		out_Lui:         out STD_LOGIC;
		out_ALUOp :      out STD_LOGIC_VECTOR(1 downto 0);
		out_ALUSrc :     out STD_LOGIC;
		out_InstAddress: out STD_LOGIC_VECTOR(31 downto 0);
		out_DataRs1:     out STD_LOGIC_VECTOR(31 downto 0);
		out_DataRs2:     out STD_LOGIC_VECTOR(31 downto 0);
		out_Immediate:   out STD_LOGIC_VECTOR(31 downto 0);
		out_funct7_30:   out STD_LOGIC;
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

	signal in_funct7_30:  STD_LOGIC;
	signal in_funct3:     STD_LOGIC_VECTOR(2 downto 0);
	signal in_AddressRd:  STD_LOGIC_VECTOR(4 downto 0);

BEGIN 

	in_AddressRd <= in_instruction(11 downto 7);
	in_funct3 <= in_instruction(14 downto 12);
	in_funct7_30 <= in_instruction(30);

	R1:  Register1bit  PORT MAP(in_RegWrite, Reset, Clock, out_RegWrite);
	R2:  Register1bit  PORT MAP(in_MemToReg, Reset, Clock, out_MemToReg);
	R3:  Register1bit  PORT MAP(in_JumpR, Reset, Clock, out_JumpR);
	R4:  Register1bit  PORT MAP(in_Jump, Reset, Clock, out_Jump);
	R5:  Register1bit  PORT MAP(in_Auipc, Reset, Clock, out_Auipc);
	R6:  Register1bit  PORT MAP(in_Branch, Reset, Clock, out_Branch);
	R7:  RegisterNbits  GENERIC MAP(N=>32) PORT MAP(in_PCNext, Reset, Clock, out_PCNext);
	R8:  Register1bit  PORT MAP(in_MemRead, Reset, Clock, out_MemRead);
	R9:  Register1bit  PORT MAP(in_MemWrite, Reset, Clock, out_MemWrite);
	R10:  Register1bit  PORT MAP(in_Lui, Reset, Clock, out_Lui);
	R11:  RegisterNbits GENERIC MAP(N=>2)  PORT MAP(in_ALUOp, Reset, Clock, out_ALUOp);
	R12:  Register1bit  PORT MAP(in_ALUSrc, Reset, Clock, out_ALUSrc);
	R13:  RegisterNbits GENERIC MAP(N=>32) PORT MAP(in_InstAddress, Reset, Clock, out_InstAddress);
	R14:  RegisterNbits GENERIC MAP(N=>32) PORT MAP(in_DataRs1, Reset, Clock, out_DataRs1);
	R15: RegisterNbits GENERIC MAP(N=>32) PORT MAP(in_DataRs2, Reset, Clock, out_DataRs2);
	R16: RegisterNbits GENERIC MAP(N=>32) PORT MAP(in_Immediate, Reset, Clock, out_Immediate);
	R17: Register1bit  PORT MAP(in_funct7_30, Reset, Clock, out_funct7_30);
	R18: RegisterNbits GENERIC MAP(N=>3)  PORT MAP(in_funct3, Reset, Clock, out_funct3);
	R19: RegisterNbits GENERIC MAP(N=>5)  PORT MAP(in_AddressRd, Reset, Clock, out_AddressRd);

END structural;