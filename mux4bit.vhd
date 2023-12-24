library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.STD_LOGIC_ARITH.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;

entity mux_4bit is
  port (input_0 : in  STD_LOGIC_VECTOR(3 downto 0);
        input_1 : in  STD_LOGIC_VECTOR(3 downto 0);
        sel     : in  STD_LOGIC;
        outMux  : out STD_LOGIC_VECTOR(3 downto 0));
end entity;

architecture Behavioral of mux_4bit is
begin
  process (sel, input_0, input_1)
  begin
    if sel = '0' then
      outMux <= input_0;
    else
      outMux <= input_1;
    end if;
  end process;
end architecture;
