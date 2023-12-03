LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY decoder IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        weRegFile : IN STD_LOGIC;
        weAddress : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        writeValue : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        fetchDecodeReg : IN STD_LOGIC_VECTOR(91 DOWNTO 0);
        outDecode : OUT STD_LOGIC_VECTOR(91 DOWNTO 0)

    );
END ENTITY decoder;

ARCHITECTURE decodeArch OF decoder IS
    COMPONENT register_file IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            RegWrite : IN STD_LOGIC;
            RegDst : IN STD_LOGIC;
            Rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            WriteData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Out1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Out2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;

    COMPONENT mux_2x1 IS PORT (
        input_0 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        input_1 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        sel : IN STD_LOGIC;
        outMux : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
    END COMPONENT;

    COMPONENT CustomControlunit IS PORT (
        opcode : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
        mem_read, immediate_value, branch, mem_write, reg_write1, reg_write2, reg_read1, reg_read2, reg_read3, stack_read, stack_write, protectAfree, protectOfree, inOout, inAout : OUT STD_LOGIC;
        clk : IN STD_LOGIC;
        alu_op : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL out1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL outMux : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL outControl : STD_LOGIC_VECTOR(18 DOWNTO 0);
    SIGNAL outDecoder : STD_LOGIC_VECTOR(91 DOWNTO 0);

BEGIN
    r : register_file PORT MAP(
        clk => clk,
        rst => rst,
        RegWrite => weRegFile,
        RegDst => '1',
        Rsrc1 => fetchDecodeReg (5 DOWNTO 3),
        Rsrc2 => fetchDecodeReg (8 DOWNTO 6),
        Rdst => weAddress,
        WriteData => writeValue,
        Out1 => out1,
        Out2 => out2

    );
    m : mux_2x1 PORT MAP(
        input_0 => fetchDecodeReg (15 DOWNTO 9),
        input_1 => "0000000",
        sel => fetchDecodeReg (91),
        outMux => outMux);

    outDecoder <= out1 & out2 & fetchDecodeReg (8 DOWNTO 0);
    outDecode <= outDecoder;
END decodeArch;