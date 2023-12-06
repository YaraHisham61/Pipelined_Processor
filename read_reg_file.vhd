library ieee;
  use ieee.std_logic_1164.all;

package my_pkg is
  type memory_array is array (NATURAL range <>) of STD_LOGIC_VECTOR;
end package;
use work.my_pkg.all;

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_textio.all;
  use IEEE.STD_LOGIC_ARITH.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;
  use std.textio.all;

entity reg_initialization is
  port (
    reg : out memory_array(0 to 7)(31 downto 0)
  );
end entity;

architecture arch_reg_initialization of reg_initialization is

begin
  initialize_memory: process
    file memory_file : text open READ_MODE is "data.txt";
    variable file_line : line;
    variable temp_data : STD_LOGIC_VECTOR(31 downto 0);
  begin

    for i in reg'RANGE loop
      if not endfile(memory_file) then
        readline(memory_file, file_line);
        read(file_line, temp_data);
        reg(i) <= temp_data;

      else
        file_close(memory_file);
        wait;
      end if;
    end loop;

  end process;

end architecture;
