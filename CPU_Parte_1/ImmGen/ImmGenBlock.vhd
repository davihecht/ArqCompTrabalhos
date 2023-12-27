LIBRARY ieee; 
USE ieee.std_logic_1164.all ; 

ENTITY ImmGenBlock IS 
	PORT ( 
		instruction: in STD_LOGIC_VECTOR (31 downto 0);
        ---------------------------------------------------	
		immediate: out STD_LOGIC_VECTOR (31 downto 0)
	); 
END ImmGenBlock ; 

ARCHITECTURE dataflow OF ImmGenBlock IS 
	signal opcode:       STD_LOGIC_VECTOR (6 downto 0);
	signal immediate_I, immediate_S, imm_buff: STD_LOGIC_VECTOR (11 downto 0);
	signal padding:      STD_LOGIC_VECTOR (19 downto 0);
	signal imm_sign:     STD_LOGIC; 
BEGIN
	opcode <= instruction(6 downto 0);
	immediate_I <= instruction(31 downto 20);
	immediate_S <= instruction(31 downto 25) & instruction(12 downto 8);
	
	with opcode select imm_buff <=
		immediate_S when "0100011",
		immediate_I when others;

	imm_sign <= imm_buff(11);

	with imm_sign select padding <=
		"11111111111111111111" when '1',
		"00000000000000000000" when others;
		
	immediate <= padding & imm_buff;

END dataflow ;
