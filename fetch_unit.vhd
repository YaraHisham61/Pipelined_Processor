LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- 32 Bit M[i+1]M[i]
ENTITY fetch_unit IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        valueEnable : IN STD_LOGIC;
        value : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        pcvalue:out std_logic_vector(31 downto 0)

    );
END ENTITY fetch_unit;

ARCHITECTURE rtl OF fetch_unit IS
    SIGNAL reg : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000010000000000000000";
    SIGNAL memLocation : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN
    PC : ENTITY work.register_32bit
        PORT MAP(
            clk => clk,
            rst => rst,
            WE => '1',
            inp => reg,
            outp => memLocation
        );
    IM : ENTITY work.instruction_memory
        PORT MAP(
         clk=>clk,
            address => memLocation(11 DOWNTO 0),
            dataout => instruction
        );
    PROCESS (clk)
    BEGIN
        IF falling_edge(clk) THEN
            IF valueEnable = '0' THEN
                reg <= (reg(31 DOWNTO 16) + 1) & (reg(31 DOWNTO 16));
            END IF;
            IF valueEnable = '1' THEN
                reg <= value;
            END IF;
        END IF;
        pcvalue<=memLocation;
    END PROCESS;

END ARCHITECTURE;