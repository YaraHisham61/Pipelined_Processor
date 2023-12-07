LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- use IEEE.STD_LOGIC_UNSIGNED.all;

PACKAGE mempkg IS
    TYPE memory_array IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR;
END PACKAGE;
USE work.iipkg.ALL;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

ENTITY data_memory IS
    PORT (
        clk : IN STD_LOGIC;
        se : IN STD_LOGIC;
        ss : IN STD_LOGIC;
        we : IN STD_LOGIC;
        re : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        datain1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        datain2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE memBehavioural OF data_memory IS
    SIGNAL ram : memory_array(0 TO 4095)(16 DOWNTO 0) := (OTHERS => (OTHERS => '0'));
    SIGNAL init : STD_LOGIC := '1';
BEGIN
    data_memory : PROCESS (ALL) IS
        FILE memory_file : text OPEN READ_MODE IS "data_in.txt";
        VARIABLE file_line : line;
        VARIABLE temp_data : STD_LOGIC_VECTOR(16 DOWNTO 0);
    BEGIN
        IF (init = '1') THEN
            FOR i IN ram'RANGE LOOP
                IF NOT endfile(memory_file) THEN
                    readline(memory_file, file_line);
                    read(file_line, temp_data);
                    ram(i) <= temp_data;
                ELSE
                    init <= '0'; -- Move this outside the loop
                END IF;
            END LOOP;
            file_close(memory_file); -- Move file closing outside the loop
        END IF;
        IF (se = '0') THEN
            IF we = '1' AND ram(to_integer(unsigned(address)))(16) = '0' THEN
                ram(to_integer(unsigned(address)))(15 DOWNTO 0) <= datain1;
                ram(to_integer(unsigned(address) + 1))(15 DOWNTO 0) <= datain2;
            END IF;
            --IF we = '1' AND ram(to_integer(unsigned(address) + 1))(16) = '0' THEN
            --   ram(to_integer(unsigned(address) + 1))(15 DOWNTO 0) <= datain2;
            --  END IF;
            IF re = '1' THEN
                dataout <= ram(to_integer(unsigned((address) + 1)))(15 DOWNTO 0) & ram(to_integer(unsigned((address))))(15 DOWNTO 0);
            END IF;
        END IF;
        IF se = '1' THEN
            IF ss = '0' THEN
                ram(to_integer(unsigned(address))) <= (OTHERS => '0');
                ram(to_integer(unsigned(address) + 1)) <= (OTHERS => '0');
            ELSE
                ram(to_integer(unsigned(address)))(16) <= '1';
                ram(to_integer(unsigned(address) + 1))(16) <= '1';
            END IF;
        END IF;
    END PROCESS;
    -- WITH we AND NOT ram(to_integer(unsigned(address)))(16) AND NOT se SELECT
    -- ram(to_integer(unsigned(address)))(15 DOWNTO 0) <= datain1 WHEN '1',
    -- ram(to_integer(unsigned(address)))(15 DOWNTO 0) WHEN OTHERS;
    -- WITH se AND ss SELECT
    --     ram(to_integer(unsigned(address)))(16) <= '1' WHEN'1',
    --     ram(to_integer(unsigned(address)))(16) WHEN OTHERS;
    -- WITH se AND ss SELECT
    --     ram(to_integer(unsigned(address) + 1))(16) <= '1' WHEN'1',
    --     ram(to_integer(unsigned(address) + 1))(16) WHEN OTHERS;
    -- WITH se AND NOT ss SELECT
    --     ram(to_integer(unsigned(address) + 1)) <= (OTHERS => '0') WHEN'1',
    --     ram(to_integer(unsigned(address) + 1)) WHEN OTHERS;
    -- WITH se AND NOT ss SELECT
    --     ram(to_integer(unsigned(address))) <= (OTHERS => '0') WHEN '1',
    --     ram(to_integer(unsigned(address))) WHEN OTHERS;
    -- dataout <= ram(to_integer(unsigned((address) + 1)))(15 DOWNTO 0) & ram(to_integer(unsigned((address))))(15 DOWNTO 0);
END ARCHITECTURE;