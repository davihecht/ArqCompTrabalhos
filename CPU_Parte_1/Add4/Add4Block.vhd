LIBRARY ieee; 
USE ieee.std_logic_1164.all ; 


ENTITY Add4PC IS 
	PORT ( 
		PCAddress:    in STD_LOGIC_VECTOR (31 downto 0);
        ---------------------------------------------------	
		NextAddress:  out STD_LOGIC_VECTOR (31 downto 0);
		Cout:         out STD_LOGIC                   -- Provavelmente significa que voltou pro início
	); 
END Add4PC ;  -- O que fazer quando chegar na última instrução.

ARCHITECTURE dataflow OF Add4PC IS 

	COMPONENT Somador32Bits IS
		PORT(X, Y: in STD_LOGIC_VECTOR (31 downto 0);
  		     Cin:  in STD_LOGIC;
           	     output:    out STD_LOGIC_VECTOR (31 downto 0);
	             Cout: out STD_LOGIC
		);
	END COMPONENT;

BEGIN	
	ADD_4: Somador32Bits PORT MAP(PCAddress, "00000000000000000000000000000100", '0', NextAddress, Cout);

END dataflow ;
