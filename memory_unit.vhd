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
    SIGNAL stackIn : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000111111111101";
    SIGNAL stackOut : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL addressValue : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
BEGIN
    DM : ENTITY work.data_memory
        PORT MAP(
            clk => clk,
            address => addressValue,
            datain1 => value(31 DOWNTO 16),
            datain2 => value(15 DOWNTO 0),
            dataout => memoryOut,
            re => memRead,
            se => protectOfree,
            ss => protectAfree,
            we => memWrite
        );
    WITH memWrite OR memRead OR stackWrite OR stackRead SELECT
        outMemory <= value & memoryOut(15 DOWNTO 0) & memoryOut(31 DOWNTO 16) WHEN '1',
        value & address WHEN OTHERS;
    SP : ENTITY work.stack_pointer
        PORT MAP(
            clk => clk,
            rst => rst,
            WE => '1',
            inp => stackIn,
            outp => stackOut
        );
    PROCESS (clk)
    BEGIN
        IF falling_edge(clk) THEN
            IF (stackWrite = '1' AND memWrite = '1') THEN
                stackIn <= stackOut - 2;
                addressValue <= stackOut(11 DOWNTO 0);
            END IF;
            IF NOT(stackWrite = '1' AND memWrite = '1') AND NOT (stackRead = '1' AND memRead = '1') THEN
                addressValue <= address(11 DOWNTO 0);
            END IF;
            IF stackRead = '1' AND memRead = '1' THEN
                stackIn <= stackOut + 2;
                addressValue <= stackOut(11 DOWNTO 0);
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;