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

ENTITY MUX21_4Bits IS
  PORT (
  ------------------------------------------------------------------------------
  --Insert input ports below
    X, Y:     in STD_LOGIC_VECTOR (3 downto 0);                 
    seletor:  IN STD_LOGIC;
  ------------------------------------------------------------------------------
  --Insert output ports below
    saida:    out STD_LOGIC_VECTOR (3 downto 0)
    );
END MUX21_4Bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF MUX21_4Bits IS

BEGIN
	saida(0) <= (NOT(seletor) AND X(0)) OR (seletor AND Y(0));
	saida(1) <= (NOT(seletor) AND X(1)) OR (seletor AND Y(1));
	saida(2) <= (NOT(seletor) AND X(2)) OR (seletor AND Y(2));
	saida(3) <= (NOT(seletor) AND X(3)) OR (seletor AND Y(3));
	--with seletor select
    	--	saida <= X when '0',
     --     	    Y when others;
	
END structural;
