library ieee;
  use ieee.std_logic_1164.all;
  -- WE --> Write Enable

entity piplinereg is
  port (
    clk  : in  STD_LOGIC;
    rst  : in  STD_LOGIC;
    inp  : in  STD_LOGIC_VECTOR(92 downto 0);
    outp : out STD_LOGIC_VECTOR(92 downto 0)
  );
end entity;

architecture piplineregarch of piplinereg is
  signal enable : STD_LOGIC                     := '1';
  signal temp   : STD_LOGIC_VECTOR(92 downto 0) := (others => '0');
begin
  temp <= inp;
  dffs: for i in 92 downto 0 generate
    dff: entity work.DFFF
      port map (
        clk => clk,
        rst => rst,
        en  => enable,
        D   => temp(i),
        Q   => outp(i)
      );
  end generate;
end architecture;
