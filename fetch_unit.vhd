
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
  signal reg         : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";
  signal memLocation : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal inputpc: STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";
begin
  PC: entity work.pcPointer
    port map (
      clk  => clk,
      reset  => rst,
      data_in  => inputpc,
      data_out => memLocation
    );
  IM: entity work.instruction_memory
    port map (
      clk     => clk,
      address => memLocation(11 downto 0),
      dataout => instruction
    );
reg<=memLocation;
pcvalue<=memLocation;
pcmux:entity work.mux_31x1
port map (
input_0 => reg+1,
input_1 => value,
sel     => valueEnable,
outMux  => inputpc
);

  -- process (clk)
  -- begin
  --     if valueEnable = '0' then
  --       reg <= reg + 1;
  --     end if;
  --     if valueEnable = '1' then
  --       reg <= value;
  --     end if;
  --   pcvalue <= memLocation;
  -- end process;

end architecture;
