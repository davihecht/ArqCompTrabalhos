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
	signal opcode:                                STD_LOGIC_VECTOR (6 downto 0);
	signal immediate_I, immediate_S, imm_buff_IS: STD_LOGIC_VECTOR (11 downto 0);
	signal immediate_U, immediate_UJ:             STD_LOGIC_VECTOR (19 downto 0);
	signal padding_I, padding_S:                  STD_LOGIC_VECTOR (19 downto 0);
	signal padding_U, padding_UJ:		      STD_LOGIC_VECTOR (11 downto 0);
	signal imm_sign_I, imm_sign_S, imm_sign_U:    STD_LOGIC;
	signal imm_sign_UJ:			      STD_LOGIC;
	signal imm_I, imm_S, imm_U, imm_UJ:           STD_LOGIC_VECTOR (31 downto 0);

 
BEGIN
	opcode <= instruction(6 downto 0);
	immediate_I  <= instruction(31 downto 20);
	immediate_S  <= instruction(31 downto 25) & instruction(12 downto 8);
	immediate_U  <= instruction(31 downto 12);

	immediate_UJ(19)           <= instruction(31);
	immediate_UJ(18 downto 11) <= instruction(19 downto 12);
	immediate_UJ(10)           <= instruction(20);
	immediate_UJ(9 downto 0)   <= instruction(30 downto 21);

	-- Padding all immediates
	imm_sign_I  <= immediate_I(11);
	imm_sign_S  <= immediate_S(11);
	imm_sign_U  <= immediate_U(19);
	imm_sign_UJ <= immediate_UJ(19);
	
	with imm_sign_I select padding_I <=
		(others => '1') when '1',
		(others => '0') when others;
	imm_I <= padding_I & immediate_I;

	with imm_sign_S select padding_S <=
		(others => '1') when '1',
		(others => '0') when others;
	imm_S <= padding_S & immediate_S;

	with imm_sign_U select padding_U <=
		(others => '1') when '1',
		(others => '0') when others;
	imm_U <= padding_U & immediate_U;

	with imm_sign_UJ select padding_UJ <=
		(others => '1') when '1',
		(others => '0') when others;
	imm_UJ <= padding_UJ & immediate_UJ;
	
	-- Selecting immediate according to OpCode
	with opcode select immediate <=
		imm_S  when "0100011", --S-sw
		imm_I  when "0010011", --I-Type
		imm_I  when "0000011", --lw
		imm_I  when "0011011", --I-4-AVX
		imm_I  when "0011111", --I-8-AVX
		imm_I  when "0101011", --I-16-AVX
		imm_I  when "0001011", --I-32-AVX
		imm_U  when "0110111", --U-lui
		imm_U  when "0010111", --U-auipc
		imm_UJ when "1101111", --UJ-jal
		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" when others;

END dataflow ;
