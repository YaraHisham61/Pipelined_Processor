library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;

entity processor is
  port (
    clk : in STD_LOGIC;
    rst : in STD_LOGIC
  );
end entity;

architecture rtl of processor is
  signal memoryToBranch : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

  signal memoryEnable   : STD_LOGIC                     := '0';
  signal inpPipe1       : STD_LOGIC_VECTOR(91 downto 0) := (others => '0');
  signal outPipe1       : STD_LOGIC_VECTOR(91 downto 0) := (others => '0');
  signal inpPipe2       : STD_LOGIC_VECTOR(91 downto 0) := (others => '0');
  signal outPipe2       : STD_LOGIC_VECTOR(91 downto 0) := (others => '0');
  signal inpPipe3       : STD_LOGIC_VECTOR(91 downto 0) := (others => '0');
  signal outPipe3       : STD_LOGIC_VECTOR(91 downto 0) := (others => '0');
  signal outControl     : STD_LOGIC_VECTOR(18 downto 0);
  signal outDecode      : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
  signal outpc          : std_logic_vector(31 downto 0);

begin
             inpPipe2 <= outControl & outPipe1(8 downto 0) & outDecode;
  FU: entity work.fetch_unit
      port map (
      clk         => clk,
      rst         => rst,
      value       => memoryToBranch,
      instruction => inpPipe1(15 downto 0),
      valueEnable => memoryEnable,
      pcvalue     => outpc);
  pipe1: entity work.piplinereg
    port map (
      clk  => clk,
      rst  => rst,
      inp  => inpPipe1,
      outp => outPipe1
    );
  pipe2: entity work.piplinereg
    port map (
      clk  => clk,
      rst  => rst,
      inp  => inpPipe2,
      outp => outPipe2
    );
  pipe3: entity work.piplinereg
    port map (
      clk  => clk,
      rst  => rst,
      inp  => inpPipe3,
      outp => outPipe3
    );
  ID: entity work.decoder
    port map (
      clk        => clk,
      rst        => rst,
      pc         => outpc,
      branch     => outControl(2),
      memwrite   => outControl(3),
      outDecode  => outDecode,
      inst       => outPipe1(15 downto 0),
      weAddress  => "101",
      writeValue => "00000000000100000000000100000011",
      weRegFile  => '1'
    );

  CU: entity work.CustomControlunit
    port map (
      opcode          => outPipe1(15 downto 9),
      mem_read        => outControl(0),
      immediate_value => outControl(1),
      branch          => outControl(2),
      mem_write       => outControl(3),
      reg_write1      => outControl(4),
      reg_write2      => outControl(5),
      reg_read1       => outControl(6),
      reg_read2       => outControl(7),
      reg_read3       => outControl(8),
      stack_read      => outControl(9),
      stack_write     => outControl(10),
      protectAfree    => outControl(11),
      protectOfree    => outControl(12),
      inOout          => outControl(13),
      inAout          => outControl(14),
      clk             => clk,
      alu_op          => outControl(18 downto 15)
    );
  EX: entity work.executingUnit
    port map (
      executeWriteback => inpPipe3(31 downto 0),
      decodeExecute    => outPipe2(63 downto 0),
      signalIn         => outPipe2(91 downto 88),
      immvalue         => "00000000000000000000000000000000",
      clk              => clk,
      reset            => rst,
      immediate        => outPipe2(73)
    );

end architecture;
