
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity executingUnit is
  port (
    executeWriteback      : out STD_LOGIC_VECTOR(63 downto 0);
    decodeExecute         : in  STD_LOGIC_VECTOR(63 downto 0);
    signalIn              : in  STD_LOGIC_VECTOR(3 downto 0);
    immvalue              : in  std_logic_vector(31 downto 0);
    clk, reset, immediate : in  std_logic;
    outwrite: in std_logic;
    readport:in std_logic
  );
end entity;

architecture executingArch of executingUnit is
  signal inport : std_logic_vector(31 downto 0);
  signal outexe : std_logic_vector(31 downto 0);
  component ALU is
    port (
      Reg1, Reg2 : in  STD_LOGIC_VECTOR(31 downto 0);
      Signals    : in  STD_LOGIC_VECTOR(3 downto 0);
      CCR        : in  STD_LOGIC_VECTOR(3 downto 0);
      RegOut     : out STD_LOGIC_VECTOR(31 downto 0);
      CCROut     : out STD_LOGIC_VECTOR(3 downto 0));
  end component;
  component mux_31x1 is
    port (
      input_0 : in  STD_LOGIC_VECTOR(31 downto 0);
      input_1 : in  STD_LOGIC_VECTOR(31 downto 0);
      sel     : in  STD_LOGIC;
      outMux  : out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component flagregister is
    port (
      clk  : in  STD_LOGIC;
      rst  : in  STD_LOGIC;
      WE   : in  STD_LOGIC;
      inp  : in  STD_LOGIC_VECTOR(3 downto 0);
      outp : out STD_LOGIC_VECTOR(3 downto 0)
    );
  end component;
  signal aluout  : std_logic_vector(31 downto 0);
  signal flagout : std_logic_vector(3 downto 0);
  signal flagin  : std_logic_vector(3 downto 0);
  signal outmux  : std_logic_vector(31 downto 0);
begin
  A: ALU
    port map (
      Reg1    => decodeExecute(31 downto 0),
      Reg2    => outmux,
      Signals => signalIn,
      CCR     => flagin,
      RegOut  => aluout,
      CCROut  => flagout);
outport:ENTITY work.register_32bit 
PORT map(
    clk =>clk,
    rst => reset,
    WE =>outwrite,
    inp => decodeExecute(31 downto 0),
    outp =>inport);

  m: mux_31x1
    port map (
      input_0 => decodeExecute(63 downto 32),
      input_1 => immvalue,
      sel     => immediate,
      outMux  => outmux
    );
    mout: mux_31x1
    port map (
      input_0 => aluout,
      input_1 => inport,
      sel     => readport,
      outMux  => outexe
    );
  F: flagregister
    port map (
      clk  => clk,
      rst  => reset,
      WE   => '1',
      inp  => flagin,
      outp => flagout
    );
  executeWriteback <=outmux &outexe;

end architecture;
