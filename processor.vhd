library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;

entity processor is
  port (
    clk       : in  STD_LOGIC;
    rst       : in  STD_LOGIC;
    inPort    : in  STD_LOGIC_VECTOR(31 downto 0);
    outPort   : out STD_LOGIC_VECTOR(31 downto 0);
    Interrupt : in  STD_LOGIC
  );
end entity;

architecture rtl of processor is
  signal fetch_rst       : STD_LOGIC_VECTOR(15 downto 0);
  signal inpPipe1        : STD_LOGIC_VECTOR(93 downto 0) := (others => '0');
  signal outPipe1        : STD_LOGIC_VECTOR(93 downto 0) := (others => '0');
  signal inpPipe2        : STD_LOGIC_VECTOR(93 downto 0) := (others => '0');
  signal outPipe2        : STD_LOGIC_VECTOR(93 downto 0) := (others => '0');
  signal inpPipe3        : STD_LOGIC_VECTOR(93 downto 0) := (others => '0');
  signal outPipe3        : STD_LOGIC_VECTOR(93 downto 0) := (others => '0');
  signal inpPipe4        : STD_LOGIC_VECTOR(93 downto 0) := (others => '0');
  signal outPipe4        : STD_LOGIC_VECTOR(93 downto 0) := (others => '0');
  signal loaduse         : STD_LOGIC_VECTOR(93 downto 0) := (others => '0');
  signal loaduse1        : STD_LOGIC_VECTOR(93 downto 0) := (others => '0');
  signal loaduse3        : STD_LOGIC_VECTOR(93 downto 0) := (others => '0');
  signal outControl      : STD_LOGIC_VECTOR(19 downto 0);
  signal outDecode       : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
  signal outMemory       : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
  signal outExcute       : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
  signal outFetch        : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
  signal outExtend       : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal outpc           : std_logic_vector(31 downto 0);
  signal inPortsig       : std_logic_vector(31 downto 0);
  signal outsig          : std_logic;
  signal returnDecode    : std_logic                     := '0';
  signal returnExcute    : std_logic                     := '0';
  signal pcChange        : std_logic                     := '0';
  signal returnSignal    : std_logic                     := '0';
  signal jump            : std_logic;
  signal zeroflagsig     : std_logic;
  signal flagout         : std_logic_vector(3 downto 0);
  signal resetpipe2      : std_logic                     := '0';
  signal interruptay7aga : std_logic                     := '0';
  signal stduse          : std_logic                     := '0';
  signal pcjump          : std_logic_vector(31 downto 0);
  signal pcinterrupt     : std_logic_vector(31 downto 0) := (others => '0');
  signal pcvalue         : std_logic_vector(31 downto 0) := (others => '0');
  signal fullForward     : std_logic_vector(63 downto 0);
  signal stdcontrol      : std_logic_vector(18 downto 0);

begin
  stdcontrol(18 downto 0) <= outControl(18 downto 0) when stduse = '0' else outControl(18 downto 4) & '0' & outControl(2 downto 0);
  loaduse1                <= inpPipe1 when stduse = '0' else outPipe1;
  loaduse                 <= inpPipe2; --stduse = '0' else outPipe2;
  loaduse3                <= inpPipe3; --stduse = '0' else outPipe3;
  pcvalue                 <= outpc when outPipe1(92) = '0' else outPipe1(47 downto 16);
  stduse                  <= '1' when (inpPipe3(72 downto 70) = inpPipe2(69 downto 67) or inpPipe3(72 downto 70) = inpPipe2(66 downto 64)) and inpPipe3(73) = '1' and inpPipe3(77) = '1' and inpPipe2(79) = '1' else '0';
  pcinterrupt             <= flagout & outPipe3(27 downto 0) when outPipe3(92) = '1' else outPipe3(31 downto 0);
  interruptay7aga         <= '1' when outPipe3(92) = '1' else '0';
  inpPipe1(92)            <= '0' when outPipe4(92) = '1' and pcChange = '1' else Interrupt;
  inpPipe2(92)            <= outPipe1(92);
  inpPipe3(92)            <= outPipe2(92);
  inpPipe4(92)            <= outPipe3(92);
  inpPipe2(93)            <= outControl(19) when stduse = '0' else '0';
  inpPipe3(93)            <= outPipe2(93);
  inpPipe4(93)            <= outPipe3(93);
  inpPipe2(91 downto 0)   <= stdcontrol & outPipe1(8 downto 0) & fullForward when resetpipe2 = '0' else (others => '0');
  inpPipe3(91 downto 32)  <= outPipe2(91 downto 64) & outExcute(63 downto 32);
  inpPipe3(31 downto 0)   <= inPortsig;
  inpPipe4(91 downto 0)   <= outPipe3(91 downto 64) & outMemory;
  inpPipe1(15 downto 0)   <= fetch_rst;
  inpPipe1(47 downto 16)  <= outpc;
  pcChange                <= jump or returnSignal or interruptay7aga;
  jump                    <= '1' when ((outPipe1(15 downto 9) = "0011101" or outPipe1(15 downto 9) = "0011110") and outControl(2) = '1') or resetpipe2 = '1' else '0';
  fetch_rst               <= "0000000000000000" when jump = '1' or resetpipe2 = '1' or returnDecode = '1' or returnExcute = '1' or returnSignal = '1' or inpPipe1(92) = '1' else outFetch;
  resetpipe2              <= '1' when (zeroflagsig = '1' and outPipe2(75) = '1' and outPipe2(93) = '1') or rst = '1' else '0';
  pcjump                  <= outMemory(31 downto 0)    when returnSignal = '1' or rst = '1' else
                             outPipe2(31 downto 0)     when resetpipe2 = '1' else
                             fullForward(63 downto 32) when jump = '1' else
                                                  (others => '0');
  returnDecode <= '1' when outPipe1(15 downto 12) = "0001" or outPipe1(92) = '1' else '0';
  returnExcute <= '1' when (outPipe2(82) = '1' and outPipe2(75) = '1') or outPipe2(92) = '1' else '0';
  returnSignal <= '1' when (outPipe3(82) = '1' and outPipe3(75) = '1') or outPipe3(92) = '1' else '0';

  fullForward(31 downto 0) <= inPortsig               when (inpPipe3(66 downto 64) = inpPipe2(69 downto 67)) and inpPipe3(91 downto 88) = "0101" else
                              outExcute(63 downto 32) when (inpPipe3(69 downto 67) = inpPipe2(69 downto 67)) and inpPipe3(91 downto 88) = "0101" else
                              --Swap in Excute
  inPortsig               when ((inpPipe3(72 downto 70) = inpPipe2(69 downto 67)) and inpPipe3(91 downto 88) /= "0000" and inpPipe3(77) = '1' and inpPipe2(79) = '1') or ((inpPipe3(72 downto 70) = inpPipe2(69 downto 67)) and inpPipe3(86) = '1') else
                              inPortsig               when ((inpPipe3(72 downto 70) = inpPipe2(69 downto 67)) and inpPipe3(91 downto 88) /= "0000" and inpPipe3(77) = '1') or ((inpPipe3(72 downto 70) = inpPipe2(69 downto 67)) and inpPipe3(86) = '1') else
                              outMemory(31 downto 0)  when (inpPipe4(66 downto 64) = inpPipe2(69 downto 67)) and inpPipe4(91 downto 88) = "0101" else
                              outMemory(63 downto 32) when (inpPipe4(69 downto 67) = inpPipe2(69 downto 67)) and inpPipe4(91 downto 88) = "0101" else
                              --Swap in Memory
  outMemory(31 downto 0)  when (inpPipe4(72 downto 70) = inpPipe2(69 downto 67)) and inpPipe4(77) = '1' and inpPipe2(75) = '0' else
                              outPipe4(31 downto 0)   when (outPipe4(72 downto 70) = inpPipe2(69 downto 67)) and outPipe4(77) = '1' else

                              outDecode(31 downto 0);

  fullForward(63 downto 32) <= outExcute(31 downto 0)  when (inpPipe3(66 downto 64) = inpPipe2(66 downto 64)) and inpPipe3(91 downto 88) = "0101" else
                               outExcute(63 downto 32) when (inpPipe3(69 downto 67) = inpPipe2(66 downto 64)) and inpPipe3(91 downto 88) = "0101" else
                               --Swap in Excute
  outExcute(31 downto 0)  when (inpPipe3(72 downto 70) = inpPipe2(66 downto 64)) and inpPipe3(91 downto 88) /= "0000" and inpPipe3(77) = '1' and inpPipe2(79) = '1' else
                               outExcute(31 downto 0)  when (inpPipe3(72 downto 70) = inpPipe2(66 downto 64)) and inpPipe3(91 downto 88) /= "0000" and inpPipe3(77) = '1' else
                               outMemory(31 downto 0)  when (inpPipe4(66 downto 64) = inpPipe2(66 downto 64)) and inpPipe4(91 downto 88) = "0101" else
                               outMemory(63 downto 32) when (inpPipe4(69 downto 67) = inpPipe2(66 downto 64)) and inpPipe4(91 downto 88) = "0101" else
                               --Swap in Memory 
  outMemory(31 downto 0)  when (inpPipe4(72 downto 70) = inpPipe2(66 downto 64)) and inpPipe4(77) = '1' else
                               outPipe4(31 downto 0)   when (outPipe4(72 downto 70) = inpPipe2(66 downto 64)) and outPipe4(77) = '1' else
                               outDecode(63 downto 32);

  FU: entity work.fetch_unit
    port map (
      clk         => clk,
      rst         => '0',
      value       => pcjump,
      instruction => outFetch,
      valueEnable => pcChange,
      pcvalue     => outpc,
      stduse      => stduse);
  pipe1: entity work.piplinereg
    port map (
      clk  => clk,
      rst  => resetpipe2,
      inp  => loaduse1,
      outp => outPipe1
    );
  pipe2: entity work.piplinereg
    port map (
      clk  => clk,
      rst  => rst,
      inp  => loaduse,
      outp => outPipe2
    );
  pipe3: entity work.piplinereg
    port map (
      clk  => clk,
      rst  => rst,
      inp  => loaduse3,
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
      clk         => clk,
      rst         => rst,
      pc          => pcvalue, --ret and call 
      branch      => outControl(2),
      memwrite    => outControl(3),
      outDecode   => outDecode,
      inst        => outPipe1(15 downto 0),
      weAddress   => outPipe4(72 downto 70),
      weAddress2  => outPipe4(66 downto 64),
      writeValue  => outPipe4(31 downto 0),
      writeValue2 => outPipe4(63 downto 32),
      weRegFile   => outPipe4(77),
      weRegFile2  => outPipe4(78),
      yarab       => outPipe2(74),
      Interrupt   => outPipe1(92)
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
      flagwrite       => outControl(7),
      reg_read3       => outControl(8),
      stack_read      => outControl(9),
      stack_write     => outControl(10),
      protectAfree    => outControl(11),
      protectOfree    => outControl(12),
      inOout          => outControl(13),
      inAout          => outControl(14),
      clk             => clk,
      alu_op          => outControl(18 downto 15),
      Interrupt       => outPipe1(92),
      jz              => outControl(19)
    );
  EX: entity work.executingUnit
    port map (
      executeWriteback => outExcute,
      decodeExecute    => outPipe2(63 downto 0),
      signalIn         => outPipe2(91 downto 88),
      immvalue         => outExtend,
      clk              => clk,
      reset            => rst,
      immediate        => outPipe2(74),
      zeroflag         => zeroflagsig,
      flagsel          => inpPipe4(80),
      flagstore        => outMemory(31 downto 28),
      flagOutSignal    => flagout
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
              address      => outPipe3(63 downto 32),
              value        => pcinterrupt,
              outMemory    => outMemory,
              Interrupt    => outPipe3(92)
    );
  SIX: entity work.sign_extension
    port map (en      => outPipe2(74),
              in_num  => outPipe1(15 downto 0),
              out_num => outExtend
    );
                  outport <= outPipe2(31 downto 0) when outPipe2(87) = '1';
                  outsig  <= not outPipe2(87) and outPipe2(86);
  portout: entity work.mux_31x1
      port map (
      input_0 => outExcute(31 downto 0),
      input_1 => inPort,
      sel     => outsig,
      outMux  => inPortsig
    );
end architecture;
