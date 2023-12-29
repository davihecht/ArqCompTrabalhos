--------------------------------------------------------------------------------
-- Project :
-- File    :
-- Autor   :
-- Date    :
--
--------------------------------------------------------------------------------
-- Description :
--
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY SomadorVetorialAVX IS
  PORT (
  ------------------------------------------------------------------------------
  --Insert input ports below
    A_i        : IN  std_logic_vector(31 DOWNTO 0); -- input vector 1
    B_i        : IN  std_logic_vector(31 DOWNTO 0); -- input vector 2
    mode_i     : IN  std_logic;                     -- Mode: Add or Sub
    vecSize_i  : IN  std_logic_vector(1 DOWNTO 0);  -- Size: 00 = 4 bits, 01 = 8, 10 = 16, 11 = 32
  ------------------------------------------------------------------------------
  --Insert output ports below
    S_o        : OUT std_logic_vector(31 DOWNTO 0) -- Result vector
    );
END SomadorVetorialAVX;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF SomadorVetorialAVX IS
	COMPONENT ALU4bits IS
		PORT(X, Y:         IN  STD_LOGIC_VECTOR (3 downto 0);
  		     seletor, Cin: IN  STD_LOGIC;
  		     Juntar:       IN  STD_LOGIC;
         	     resultado:    OUT STD_LOGIC_VECTOR (3 downto 0);
	      	     Cout:         OUT STD_LOGIC
		);
	END COMPONENT;
	signal juntar, resultado: STD_LOGIC_VECTOR (7 downto 0); 
	signal cin_i:  STD_LOGIC_VECTOR (8 downto 0); 
	
BEGIN
	cin_i(0) <= '0'; -- Just to initialize, doesn't matter
	juntar(0) <= '0';

	-- When vecSize_i == 01
	juntar(1) <= vecSize_i(1) OR vecSize_i(0);
	juntar(3) <= juntar(1);
	juntar(5) <= juntar(3);
	juntar(7) <= juntar(5); 

	-- When vecSize_i == 10
	juntar(2) <= vecSize_i(1);
	juntar(6) <= juntar(2);

	-- When vecSize_i == 11
	juntar(4) <= vecSize_i(1) AND vecSize_i(0);

	G1: for i in 0 to 7 GENERATE
		func_i: ALU4bits PORT MAP(
					A_i(i*4+3 downto i*4),
					B_i(i*4+3 downto i*4),
					mode_i,
					cin_i(i),
					juntar(i),
					S_o(i*4+3 downto i*4),
					cin_i(i+1)
					);
	End GENERATE G1;

END structural;
