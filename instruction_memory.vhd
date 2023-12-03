LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY instruction_memory IS
    PORT (
        we : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY instruction_memory;

ARCHITECTURE InstMemoryRtl OF instruction_memory IS
    TYPE ram_type IS ARRAY (0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ram : ram_type;

BEGIN
    WITH we SELECT
        ram(to_integer(unsigned(address))) <= datain WHEN '1',
        ram(to_integer(unsigned(address))) WHEN OTHERS;

    dataout <= ram(to_integer(unsigned((address))));

END ARCHITECTURE;