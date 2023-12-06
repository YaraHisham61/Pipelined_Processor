LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- use IEEE.STD_LOGIC_UNSIGNED.all;

PACKAGE iipkg IS
  TYPE memory_array IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR;
END PACKAGE;
USE work.iipkg.ALL;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

ENTITY instruction_memory IS
  PORT (
    clk : IN STD_LOGIC;
    address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE InstMemoryRtl OF instruction_memory IS
  --   type ram_type is array (0 to 4095) of STD_LOGIC_VECTOR(15 downto 0);
  SIGNAL ram : memory_array(0 TO 4095)(15 DOWNTO 0);
  SIGNAL init : STD_LOGIC := '1';
  --   signal raminit : memory_array(0 to 4095)(15 downto 0);
BEGIN
  initialize_memory : PROCESS (clk) IS
    FILE memory_file : text OPEN READ_MODE IS "data.txt";
    VARIABLE file_line : line;
    VARIABLE temp_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
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

    IF (rising_edge(clk)) THEN
      dataout <= ram(to_integer(unsigned((address))));
    END IF;
  END PROCESS;
END ARCHITECTURE;