library ieee;
  use ieee.std_logic_1164.all;
  -- use IEEE.STD_LOGIC_UNSIGNED.all;

package iipkg is
  type memory_array is array (NATURAL range <>) of STD_LOGIC_VECTOR;
end package;
use work.iipkg.all;
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_textio.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;
  use IEEE.numeric_std.all;
  use std.textio.all;

entity instruction_memory is
  port (
    clk     : in  std_logic;
    address : in  STD_LOGIC_VECTOR(11 downto 0);
    dataout : out STD_LOGIC_VECTOR(15 downto 0)
  );
end entity;

architecture InstMemoryRtl of instruction_memory is
  --   type ram_type is array (0 to 4095) of STD_LOGIC_VECTOR(15 downto 0);
  signal ram  : memory_array(0 to 4095)(15 downto 0);
  signal init : std_logic := '1';
  --   signal raminit : memory_array(0 to 4095)(15 downto 0);
begin
  initialize_memory: process (clk) is
    file memory_file : text open READ_MODE is "data.txt";
    variable file_line : line;
    variable temp_data : STD_LOGIC_VECTOR(15 downto 0);
  begin

    if (init = '1') then
      for i in ram'RANGE loop
        if not endfile(memory_file) then
          readline(memory_file, file_line);
          read(file_line, temp_data);
          ram(i) <= temp_data;
        else
          init <= '0'; -- Move this outside the loop
        end if;
      end loop;
      file_close(memory_file); -- Move file closing outside the loop
    end if;

    if (rising_edge(clk)) then
      dataout <= ram(to_integer(unsigned((address))));
    end if;
  end process;

end architecture;
