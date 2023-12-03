LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY processor IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC
    );
END ENTITY processor;

ARCHITECTURE rtl OF processor IS
    SIGNAL memoryToBranch : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL instruction : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL memoryEnable : STD_LOGIC := '0';
    SIGNAL inpPipe1 : STD_LOGIC_VECTOR(91 DOWNTO 0) := (OTHERS => '0');
    SIGNAL outPipe1 : STD_LOGIC_VECTOR(91 DOWNTO 0) := (OTHERS => '0');
    SIGNAL inpPipe2 : STD_LOGIC_VECTOR(91 DOWNTO 0) := (OTHERS => '0');
    SIGNAL outPipe2 : STD_LOGIC_VECTOR(91 DOWNTO 0) := (OTHERS => '0');
    SIGNAL outControl : STD_LOGIC_VECTOR(18 DOWNTO 0);
    SIGNAL outDecode : STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');

BEGIN
    inpPipe2 <= outControl & outPipe1(8 DOWNTO 0) & outDecode;
    FU : ENTITY work.fetch_unit
        PORT MAP(
            clk => clk,
            rst => rst,
            value => memoryToBranch,
            instruction => inpPipe1(15 DOWNTO 0),
            valueEnable => memoryEnable
        );
    pipe1 : ENTITY work.piplinereg
        PORT MAP(
            clk => clk,
            rst => rst,
            inp => inpPipe1,
            outp => outPipe1
        );
    pipe2 : ENTITY work.piplinereg
        PORT MAP(
            clk => clk,
            rst => rst,
            inp => inpPipe2,
            outp => outPipe2
        );
    ID : ENTITY work.decoder
        PORT MAP(
            clk => clk,
            rst => rst,
            outDecode => outDecode,
            inst => outPipe1 (15 DOWNTO 0),
            weAddress => "101",
            writeValue => "00000000000100000000000100000011",
            weRegFile => '1'
        );

    CU : ENTITY work.CustomControlunit PORT MAP(
        opcode => outPipe1 (15 DOWNTO 9),
        mem_read => outControl(0),
        immediate_value => outControl(1),
        branch => outControl(2),
        mem_write => outControl(3),
        reg_write1 => outControl(4),
        reg_write2 => outControl(5),
        reg_read1 => outControl(6),
        reg_read2 => outControl(7),
        reg_read3 => outControl(8),
        stack_read => outControl(9),
        stack_write => outControl(10),
        protectAfree => outControl(11),
        protectOfree => outControl(12),
        inOout => outControl(13),
        inAout => outControl(14),
        clk => clk,
        alu_op => outControl(18 DOWNTO 15)
        );

END ARCHITECTURE;