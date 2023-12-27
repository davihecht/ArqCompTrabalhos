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
use ieee.numeric_std.all;

ENTITY ALU4bits IS
  PORT (
  --Inputs
    X, Y:          IN STD_LOGIC_VECTOR (3 downto 0); 
    seletor, Cin:  IN STD_LOGIC; -- Cin = Cout-1 (se primeiro, n importa, lógica desse código ignorará)
    Juntar: 	    IN STD_LOGIC; -- Se junta com a ALU anterior para formar tamanho maior de bits.
  ------------------------------------------------------------------------------
  --Outputs
    resultado:     OUT STD_LOGIC_VECTOR (3 downto 0); 
    Cout:          OUT STD_LOGIC
    );
END ALU4bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF ALU4bits IS

	COMPONENT Somador4Bit IS
		PORT(X, Y: in STD_LOGIC_VECTOR (3 downto 0);
  			Cin:  in STD_LOGIC;
               S:    out STD_LOGIC_VECTOR (3 downto 0);
	          Cout: out STD_LOGIC
		);
	END COMPONENT;
	COMPONENT MUX21_4Bits IS
		PORT(X, Y:          IN STD_LOGIC_VECTOR (3 downto 0);
			seletor:   IN STD_LOGIC;
  			saida:     OUT STD_LOGIC_VECTOR (3 downto 0)
		);
	END COMPONENT;
	signal operando_2:  STD_LOGIC_VECTOR (3 downto 0);
	signal cin_somador: STD_LOGIC;
	signal not_Y:       STD_LOGIC_VECTOR (3 downto 0);
	
begin
	--NOT Y
	not_Y <= NOT Y;

	-- Coloca como operando o Y invertido se for escolhido a subtração
	MUX_21: MUX21_4Bits PORT MAP(Y, not_Y, seletor, operando_2);

	
	-- Lógica para determinar o cin considerando o Juntar e a seleção Add/Sub
	cin_somador <= (NOT (Juntar) AND seletor) OR (Juntar AND Cin);


	ALU_4BIT: Somador4Bit PORT MAP (X, operando_2, cin_somador, resultado, Cout); 
	
END structural;
