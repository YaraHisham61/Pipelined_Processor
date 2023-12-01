LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY data_memory IS
    PORT (
        clk : IN STD_LOGIC;
        se : IN STD_LOGIC;
        ss : IN STD_LOGIC;
        we : IN STD_LOGIC;
        re : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY data_memory;

ARCHITECTURE rtl OF data_memory IS
    TYPE ram_type IS ARRAY (0 TO 4095) OF STD_LOGIC_VECTOR(16 DOWNTO 0);
    SIGNAL ram : ram_type := (OTHERS => (OTHERS => '0'));

BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF (se = '0') THEN
                IF we = '1' AND ram(to_integer(unsigned(address)))(16) = '0' THEN
                    ram(to_integer(unsigned(address)))(15 DOWNTO 0) <= datain;
                END IF;
                IF re = '1' THEN
                    dataout <= ram(to_integer(unsigned((address))))(15 DOWNTO 0);
                END IF;
            END IF;
        END IF;
        IF se = '1' THEN
            IF ss = '0' THEN
                ram(to_integer(unsigned(address))) <= (OTHERS => '0');
            ELSE
                ram(to_integer(unsigned(address)))(16) <= '1';
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;