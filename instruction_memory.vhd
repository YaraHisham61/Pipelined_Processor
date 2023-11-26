LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY InstMemory IS
    PORT (
        clk : IN STD_LOGIC;
        we : IN STD_LOGIC;
        re : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY InstMemory;

ARCHITECTURE InstMemoryRtl OF InstMemory IS
    TYPE ram_type IS ARRAY (0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ram : ram_type;

BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF we = '1'THEN
                ram(to_integer(unsigned(address))) <= datain;
            END IF;
            IF re = '1' THEN
                dataout <= ram(to_integer(unsigned((address))));
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE;