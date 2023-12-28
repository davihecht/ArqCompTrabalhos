LIBRARY ieee; 
USE ieee.std_logic_1164.all ; 


ENTITY AddSum IS 
	PORT ( 
		PCAddress:     in STD_LOGIC_VECTOR (31 downto 0);
		offset_bytes:  in STD_LOGIC_VECTOR (31 downto 0);
        ---------------------------------------------------	
		output_branch: out STD_LOGIC_VECTOR (31 downto 0);
		Cout:          out STD_LOGIC                   
	); 
END AddSum ;  -- O que fazer quando chegar na última instrução.

ARCHITECTURE dataflow OF AddSum IS 

	COMPONENT Somador32Bits IS
		PORT(X, Y:      in STD_LOGIC_VECTOR (31 downto 0);
  		     Cin:       in STD_LOGIC;
           	     output:    out STD_LOGIC_VECTOR (31 downto 0);
	             Cout:      out STD_LOGIC
		);
	END COMPONENT;

BEGIN	
	ADD_SUM: Somador32Bits PORT MAP(PCAddress, offset_bytes, '0', output_branch, Cout);

END dataflow ;
