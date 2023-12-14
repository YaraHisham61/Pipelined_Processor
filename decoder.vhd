library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity decoder is
  port (
    clk              : in  STD_LOGIC;
    rst              : in  STD_LOGIC;
    weRegFile        : in  STD_LOGIC;
    weRegFile2       : in  STD_LOGIC;
    weAddress        : in  STD_LOGIC_VECTOR(2 downto 0);
    weAddress2       : in  STD_LOGIC_VECTOR(2 downto 0);
    writeValue       : in  STD_LOGIC_VECTOR(31 downto 0);
    writeValue2      : in  STD_LOGIC_VECTOR(31 downto 0);
    inst             : in  STD_LOGIC_VECTOR(15 downto 0);
    pc               : in  STD_LOGIC_VECTOR(31 downto 0);
    branch, memwrite : in  std_logic;
    outDecode        : out STD_LOGIC_VECTOR(63 downto 0);
    yarab            : in  Std_Logic
  );
end entity;

architecture decodeArch of decoder is
  component register_file is
    port (
      clk        : in  STD_LOGIC;
      rst        : in  STD_LOGIC;
      RegWrite   : in  STD_LOGIC;
      RegWrite2  : in  STD_LOGIC;
      RegDst     : in  STD_LOGIC;
      Rsrc1      : in  STD_LOGIC_VECTOR(2 downto 0);
      Rsrc2      : in  STD_LOGIC_VECTOR(2 downto 0);
      Rdst       : in  STD_LOGIC_VECTOR(2 downto 0);
      Rdst2      : in  STD_LOGIC_VECTOR(2 downto 0);
      WriteData  : in  STD_LOGIC_VECTOR(31 downto 0);
      WriteData2 : in  STD_LOGIC_VECTOR(31 downto 0);
      Out1       : out STD_LOGIC_VECTOR(31 downto 0);
      Out2       : out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;

  component mux_2x1 is
    port (
      input_0 : in  STD_LOGIC_VECTOR(6 downto 0);
      input_1 : in  STD_LOGIC_VECTOR(6 downto 0);
      sel     : in  STD_LOGIC;
      outMux  : out STD_LOGIC_VECTOR(6 downto 0));
  end component;
  component mux_31x1 is
    port (
      input_0 : in  STD_LOGIC_VECTOR(31 downto 0);
      input_1 : in  STD_LOGIC_VECTOR(31 downto 0);
      sel     : in  STD_LOGIC;
      outMux  : out STD_LOGIC_VECTOR(31 downto 0));
  end component;

  component CustomControlunit is
    port (
      opcode                                                                                                                                                                     : in  STD_LOGIC_VECTOR(6 downto 0);
      mem_read, immediate_value, branch, mem_write, reg_write1, reg_write2, reg_read1, reg_read2, reg_read3, stack_read, stack_write, protectAfree, protectOfree, inOout, inAout : out STD_LOGIC;
      clk                                                                                                                                                                        : in  STD_LOGIC;
      alu_op                                                                                                                                                                     : out STD_LOGIC_VECTOR(3 downto 0)
    );
  end component;

  signal out1      : STD_LOGIC_VECTOR(31 downto 0);
  signal out2      : STD_LOGIC_VECTOR(31 downto 0);
  signal outbigmux : STD_LOGIC_VECTOR(31 downto 0);

  signal outMux     : STD_LOGIC_VECTOR(6 downto 0);
  signal outC       : STD_LOGIC_VECTOR(18 downto 0);
  signal outDecoder : STD_LOGIC_VECTOR(63 downto 0);
  signal selector   : std_logic;

begin
  r: register_file
    port map (
      clk        => clk,
      rst        => rst,
      RegWrite   => weRegFile,
      RegWrite2  => weRegFile2,
      RegDst     => '1',
      Rsrc2      => inst(2 downto 0),
      Rsrc1      => inst(5 downto 3),
      Rdst       => weAddress,
      Rdst2      => weAddress2,
      WriteData  => writeValue,
      WriteData2 => writeValue2,
      Out1       => out1,
      Out2       => out2
    );
     selector <= branch and memwrite;
  m: mux_2x1
      port map (
      input_0 => inst(15 downto 9),
      input_1 => "0000000",
      sel     => yarab, -- ?? ????? ??? ???? stall 
      outMux  => outMux);

  big: mux_31x1
    port map (
      input_0 => out1,
      input_1 => pc,
      sel     => selector,
      outMux  => outbigmux);

  outDecoder <= out2 & outbigmux;
  outDecode  <= outDecoder;
end architecture;
