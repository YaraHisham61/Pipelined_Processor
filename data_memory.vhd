
library ieee;
  use ieee.std_logic_1164.all;
  -- use IEEE.STD_LOGIC_UNSIGNED.all;

package jjpkg is
  type memory_array is array (NATURAL range <>) of STD_LOGIC_VECTOR;
end package;
use work.jjpkg.all;
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_textio.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;
  use IEEE.numeric_std.all;
  use std.textio.all;

entity data_memory is
  port (
    clk     : in  STD_LOGIC;
    se      : in  STD_LOGIC;
    ss      : in  STD_LOGIC;
    we      : in  STD_LOGIC;
    re      : in  STD_LOGIC;
    address : in  STD_LOGIC_VECTOR(11 downto 0);
    datain1 : in  STD_LOGIC_VECTOR(15 downto 0);
    datain2 : in  STD_LOGIC_VECTOR(15 downto 0);
    dataout : out STD_LOGIC_VECTOR(31 downto 0)
  );
end entity;

architecture DataMemoryRtl of data_memory is
  signal ram  : memory_array(0 to 4095)(16 downto 0);
  signal init : std_logic := '1';
begin
  data_memory: process (clk) is
    file memory_file : text open READ_MODE is "data_in.txt";
    variable file_line : line;
    variable temp_data : STD_LOGIC_VECTOR(16 downto 0);
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

    if rising_edge(clk) then
      if (se = '0') then
        if we = '1' and ram(to_integer(unsigned(address)))(16) = '0' then
          ram(to_integer(unsigned(address)))(15 downto 0) <= datain1;
          ram(to_integer(unsigned(address) + 1))(15 downto 0) <= datain2;
        end if;
        --IF we = '1' AND ram(to_integer(unsigned(address) + 1))(16) = '0' THEN
        --   ram(to_integer(unsigned(address) + 1))(15 DOWNTO 0) <= datain2;
        --  END IF;
        if re = '1' then
          dataout <= ram(to_integer(unsigned((address) + 1)))(15 downto 0) & ram(to_integer(unsigned((address))))(15 downto 0);
        end if;
      end if;
    end if;
    if se = '1' then
      if ss = '0' then
        ram(to_integer(unsigned(address))) <= (others => '0');
        ram(to_integer(unsigned(address) + 1)) <= (others => '0');
      else
        ram(to_integer(unsigned(address)))(16) <= '1';
        ram(to_integer(unsigned(address) + 1))(16) <= '1';
      end if;
    end if;

  end process;

end architecture;
