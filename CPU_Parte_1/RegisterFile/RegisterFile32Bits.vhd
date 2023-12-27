library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
  port(
    clk:          in  std_logic;
    RegWrite:     in  std_logic;
    AddressRs1, AddressRs2, AddressRd: in  std_logic_vector(4 downto 0);
    DataWriteRd:    in  std_logic_vector(31 downto 0);
    ReadRs1:        out std_logic_vector(31 downto 0);
    ReadRs2:        out std_logic_vector(31 downto 0)
    );
end register_file;


architecture behavioral of register_file is
  type registerFile is array(0 to 31) of std_logic_vector(31 downto 0);
  signal registers : registerFile;
begin

  registers(0) <= "00000000000000000000000000000000"; -- Falta ajeitar esse x0

  regFile : process (clk) is
  begin
    if rising_edge(clk) then
      -- Read A and B before bypass
      ReadRs1 <= registers(to_integer(unsigned(AddressRs1)));
      ReadRs2 <= registers(to_integer(unsigned(AddressRs2)));
      -- Write and bypass
      if RegWrite = '1' AND AddressRd /= "00000" then
        registers(to_integer(unsigned(AddressRd))) <= DataWriteRd;  -- Write
        if AddressRs1 = AddressRd then  -- Bypass for read Rs1
          ReadRs1 <= DataWriteRd;
        end if;
        if AddressRs2 = AddressRd then  -- Bypass for read Rs2
          ReadRs2 <= DataWriteRd;
        end if;
      end if;
    end if;
  end process;
end behavioral;
