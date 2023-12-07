
library ieee;
  use ieee.std_logic_1164.all;
  use IEEE.STD_LOGIC_ARITH.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;
  use IEEE.NUMERIC_STD.all;

  -- 32 Bit M[i+1]M[i]

entity fetch_unit is
  port (
    clk         : in  STD_LOGIC;
    rst         : in  STD_LOGIC;
    valueEnable : in  STD_LOGIC;
    value       : in  STD_LOGIC_VECTOR(31 downto 0);
    instruction : out STD_LOGIC_VECTOR(15 downto 0);
    pcvalue     : out std_logic_vector(31 downto 0)
  );
end entity;

architecture rtl of fetch_unit is
  signal reg         : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000010000000000000000";
  signal memLocation : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin
  PC: entity work.register_32bit
    port map (
      clk  => clk,
      rst  => rst,
      WE   => '1',
      inp  => reg,
      outp => memLocation
    );
  IM: entity work.instruction_memory
    port map (
      clk     => clk,
      address => memLocation(11 downto 0),
      dataout => instruction
    );

  process (clk)
  begin
    if falling_edge(clk) then
      if valueEnable = '0' then
        reg <= (reg(31 downto 16) + 1) &(reg(31 downto 16));
      end if;
      if valueEnable = '1' then
        reg <= value;
      end if;
    end if;
    pcvalue <= memLocation;
  end process;

end architecture;