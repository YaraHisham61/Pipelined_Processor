library ieee;
  use ieee.std_logic_1164.all;
  -- use IEEE.STD_LOGIC_UNSIGNED.all;

package mempkg is
  type memory_array is array (NATURAL range <>) of STD_LOGIC_VECTOR;
end package;
use work.iipkg.all;
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_textio.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;
  use IEEE.numeric_std.all;
  use std.textio.all;

entity data_memory is
  port (
    Interrupt : in  STD_LOGIC;
    clk       : in  STD_LOGIC;
    se        : in  STD_LOGIC;
    ss        : in  STD_LOGIC;
    we        : in  STD_LOGIC;
    re        : in  STD_LOGIC;
    address   : in  STD_LOGIC_VECTOR(11 downto 0);
    datain1   : in  STD_LOGIC_VECTOR(15 downto 0);
    datain2   : in  STD_LOGIC_VECTOR(15 downto 0);
    dataout   : out STD_LOGIC_VECTOR(31 downto 0)
  );
end entity;

architecture memBehavioural of data_memory is
  signal ram              : memory_array(0 to 4095)(16 downto 0) := (others =>(others => '0'));
  signal init             : STD_LOGIC                            := '1';
  signal interruptaddress : STD_LOGIC_VECTOR(11 downto 0)        := "000000000010";
begin
  data_memory: process (all) is
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
          init <= '0';
        end if;
      end loop;
      file_close(memory_file);
    end if;
    if Interrupt = '1' then
      dataout <= ram(to_integer(unsigned((interruptaddress) + 1)))(15 downto 0) & ram(to_integer(unsigned((interruptaddress))))(15 downto 0);
    end if;
    if falling_edge(clk) then
      if (se = '0') then
        if we = '1' and ram(to_integer(unsigned(address)))(16) = '0' then
          ram(to_integer(unsigned(address) + 1))(15 downto 0) <= datain1;
          ram(to_integer(unsigned(address)))(15 downto 0) <= datain2;
        end if;
        --IF we = '1' AND ram(to_integer(unsigned(address) + 1))(16) = '0' THEN
        --   ram(to_integer(unsigned(address) + 1))(15 DOWNTO 0) <= datain2;
        --  END IF;
      end if;
    end if;
    if re = '1' and Interrupt = '0' then
      dataout <= ram(to_integer(unsigned((address) + 1)))(15 downto 0) & ram(to_integer(unsigned((address))))(15 downto 0);
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
end architecture;
