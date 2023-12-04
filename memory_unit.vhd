LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
--! Add the flags to the MSB of value or from (19 DOWNTO 16)
ENTITY memory_unit IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        memWrite : IN STD_LOGIC;
        memRead : IN STD_LOGIC;
        stackWrite : IN STD_LOGIC;
        stackRead : IN STD_LOGIC;
        protectOfree : IN STD_LOGIC;
        protectAfree : IN STD_LOGIC;
        branching : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        value : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        outMemory : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
    );
END ENTITY;
ARCHITECTURE memoryBehaviour OF memory_unit IS
    SIGNAL memoryOut : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    --* Initializing input of sp by 12 bit of ones(the end of the memo)
    SIGNAL stackIn : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000111111111110";
    SIGNAL stackOut : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL addressValue : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
BEGIN
    DM : ENTITY work.data_memory
        PORT MAP(
            clk => clk,
            address => address(11 DOWNTO 0),
            datain1 => value(15 DOWNTO 0),
            datain2 => value(31 DOWNTO 16),
            dataout => memoryOut,
            re => memRead,
            se => protectOfree,
            ss => protectAfree,
            we => memWrite
        );
    WITH memWrite OR memRead OR stackWrite OR stackRead SELECT
        outMemory <= value & memoryOut WHEN '1',
        value & address WHEN OTHERS;
    SP : ENTITY work.register_32bit
        PORT MAP(
            clk => clk,
            rst => rst,
            WE => stackWrite,
            inp => stackIn,
            outp => stackOut
        );
    WITH stackWrite SELECT
        stackIn <= stackOut + 2 WHEN '1',
        stackOut WHEN OTHERS;
    WITH stackRead SELECT
        stackIn <= stackOut - 2 WHEN '1',
        stackOut WHEN OTHERS;

    WITH(stackRead AND memRead) SELECT
    addressValue <= stackOut(11 DOWNTO 0) WHEN '1',
        address(11 DOWNTO 0) WHEN OTHERS;

END ARCHITECTURE;