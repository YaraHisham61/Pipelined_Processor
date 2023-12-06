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

  signal memoryEnable : STD_LOGIC                     := '0';
  signal inpPipe1     : STD_LOGIC_VECTOR(91 downto 0) := (others => '0');
  signal outPipe1     : STD_LOGIC_VECTOR(91 downto 0) := (others => '0');
  signal inpPipe2     : STD_LOGIC_VECTOR(91 downto 0) := (others => '0');
  signal outPipe2     : STD_LOGIC_VECTOR(91 downto 0) := (others => '0');
  signal inpPipe3     : STD_LOGIC_VECTOR(91 downto 0) := (others => '0');
  signal outPipe3     : STD_LOGIC_VECTOR(91 downto 0) := (others => '0');
  signal inpPipe4     : STD_LOGIC_VECTOR(91 downto 0) := (others => '0');
  signal outPipe4     : STD_LOGIC_VECTOR(91 downto 0) := (others => '0');
  signal outControl   : STD_LOGIC_VECTOR(18 downto 0);
  signal outDecode    : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
  signal outMemory    : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
  signal outExcute    : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
  signal outFetch     : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
  signal outExtend    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal outpc        : std_logic_vector(31 downto 0);

begin
             inpPipe2              <= outControl & outPipe1(8 downto 0) & outDecode;
             inpPipe3              <= outPipe2(91 downto 64) & outExcute;
             inpPipe4              <= outPipe3(91 downto 64) & outMemory(31 downto 0) & outMemory(63 downto 32);
             inpPipe1(15 downto 0) <= outFetch;
  FU: entity work.fetch_unit
      port map (
      clk         => clk,
      rst         => rst,
      value       => memoryToBranch,
      instruction => outFetch,
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
  pipe4: entity work.piplinereg
    port map (
      clk  => clk,
      rst  => rst,
      inp  => inpPipe4,
      outp => outPipe4
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
      weAddress  => outPipe4(72 downto 70),
      writeValue => outPipe4(63 downto 32),
      weRegFile  => outPipe4(77),
      yarab      => outPipe2(74)
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
      executeWriteback => outExcute,
      decodeExecute    => outPipe2(63 downto 0),
      signalIn         => outPipe2(91 downto 88),
      immvalue         => outExtend,
      clk              => clk,
      reset            => rst,
      immediate        => outPipe2(74)
    );
  ME: entity work.memory_unit
    port map (clk          => clk,
              rst          => rst,
              memWrite     => outPipe3(76),
              memRead      => outPipe3(73),
              stackWrite   => outPipe3(83),
              stackRead    => outPipe3(82),
              protectOfree => outPipe3(85),
              protectAfree => outPipe3(84),
              branching    => outPipe3(75),
              address      => inpPipe3(63 downto 32),
              value        => inpPipe3(31 downto 0),
              outMemory    => outMemory
    );
  SIX: entity work.sign_extension
    port map (en      => outPipe2(74),
              in_num  => outPipe1(15 downto 0),
              out_num => outExtend
    );

end architecture;
