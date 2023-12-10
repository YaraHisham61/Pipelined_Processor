library ieee;
  use ieee.std_logic_1164.all;
  --  use IEEE.STD_LOGIC_UNSIGNED.all;

package registerPkg is
  type memory_array is array (NATURAL range <>) of STD_LOGIC_VECTOR;
end package;
use work.iipkg.all;
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_textio.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;
  use IEEE.numeric_std.all;
  use std.textio.all;

entity register_file is
  port (
    clk        : in  STD_LOGIC;
    rst        : in  STD_LOGIC;
    RegWrite   : in  STD_LOGIC;
    RegWrite2  : in  STD_LOGIC;
    RegDst     : in  STD_LOGIC;
    Rsrc1      : in  STD_LOGIC_VECTOR(2 downto 0);
    Rsrc2      : in  STD_LOGIC_VECTOR(2 downto 0);
    Rdst       : in  STD_LOGIC_VECTOR(2 downto 0);
    Rdst2      : in  STD_LOGIC_VECTOR(2 downto 0);
    WriteData  : in  STD_LOGIC_VECTOR(31 downto 0);
    WriteData2 : in  STD_LOGIC_VECTOR(31 downto 0);
    Out1       : out STD_LOGIC_VECTOR(31 downto 0);
    Out2       : out STD_LOGIC_VECTOR(31 downto 0)
  );
end entity;

architecture Behavioral of register_file is
  signal init          : STD_LOGIC                     := '1';
  signal enable0       : STD_LOGIC                     := '1';
  signal enable1       : STD_LOGIC                     := '1';
  signal enable2       : STD_LOGIC                     := '1';
  signal enable3       : STD_LOGIC                     := '1';
  signal enable4       : STD_LOGIC                     := '1';
  signal enable5       : STD_LOGIC                     := '1';
  signal enable6       : STD_LOGIC                     := '1';
  signal enable7       : STD_LOGIC                     := '1';
  signal reg0          : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal reg1          : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal reg2          : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal reg3          : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal reg4          : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal reg5          : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal reg6          : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal reg7          : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal output0       : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal output1       : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal output2       : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal output3       : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal output4       : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal output5       : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal output6       : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal output7       : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal writeAddress  : STD_LOGIC_VECTOR(2 downto 0)  := (others => '0');
  signal writeAddress2 : STD_LOGIC_VECTOR(2 downto 0)  := (others => '0');

begin
             writeAddress2 <= Rdst when RegWrite2 = '1' else Rdst2;
             writeAddress  <= Rdst2 when RegWrite2 = '1' else Rdst;
  R0: entity work.register_32bit
      port map (
      clk  => clk,
      rst  => rst,
      WE   => enable0,
      inp  => reg0,
      outp => output0
    );
  R1: entity work.register_32bit
    port map (
      clk  => clk,
      rst  => rst,
      WE   => enable1,
      inp  => reg1,
      outp => output1
    );
  R2: entity work.register_32bit
    port map (
      clk  => clk,
      rst  => rst,
      WE   => enable2,
      inp  => reg2,
      outp => output2
    );
  R3: entity work.register_32bit
    port map (
      clk  => clk,
      rst  => rst,
      WE   => enable3,
      inp  => reg3,
      outp => output3
    );
  R4: entity work.register_32bit
    port map (
      clk  => clk,
      rst  => rst,
      WE   => enable4,
      inp  => reg4,
      outp => output4
    );
  R5: entity work.register_32bit
    port map (
      clk  => clk,
      rst  => rst,
      WE   => enable5,
      inp  => reg5,
      outp => output5
    );
  R6: entity work.register_32bit
    port map (
      clk  => clk,
      rst  => rst,
      WE   => enable6,
      inp  => reg6,
      outp => output6
    );
  R7: entity work.register_32bit
    port map (
      clk  => clk,
      rst  => rst,
      WE   => enable7,
      inp  => reg7,
      outp => output7
    );

  Out1 <= output0 when Rsrc1 = "000" else
          output1 when Rsrc1 = "001" else
          output2 when Rsrc1 = "010" else
          output3 when Rsrc1 = "011" else
          output4 when Rsrc1 = "100" else
          output5 when Rsrc1 = "101" else
          output6 when Rsrc1 = "110" else
          output7 when Rsrc1 = "111";
  Out2 <= output0 when Rsrc2 = "000" else
          output1 when Rsrc2 = "001" else
          output2 when Rsrc2 = "010" else
          output3 when Rsrc2 = "011" else
          output4 when Rsrc2 = "100" else
          output5 when Rsrc2 = "101" else
          output6 when Rsrc2 = "110" else
          output7 when Rsrc2 = "111";

  -- with RegDst select
  --   writeAddress <= Rdst  when '1',
  --                   Rsrc2 when others;

  sync: process (clk)
    file register_file : text open READ_MODE is "registers.txt";
    variable file_line : line;
    variable temp_data : STD_LOGIC_VECTOR(31 downto 0);
  begin
    if (init = '1') then
      if not endfile(register_file) then
        for i in 0 to 7 loop
          readline(register_file, file_line);
          read(file_line, temp_data);
          case i is
            when 0 =>
              reg0 <= temp_data;
            when 1 =>
              reg1 <= temp_data;
            when 2 =>
              reg2 <= temp_data;
            when 3 =>
              reg3 <= temp_data;
            when 4 =>
              reg4 <= temp_data;
            when 5 =>
              reg5 <= temp_data;
            when 6 =>
              reg6 <= temp_data;
            when 7 =>
              reg7 <= temp_data;
          end case;
        end loop;
        init <= '0';
      end if;
      file_close(register_file); -- Move file closing outside the loop
    end if;
    if falling_edge(clk) then
      enable0 <= '0';
      enable1 <= '0';
      enable2 <= '0';
      enable3 <= '0';
      enable4 <= '0';
      enable5 <= '0';
      enable6 <= '0';
      enable7 <= '0';
      if (RegWrite = '1') then
        case writeAddress is
          when "000" =>
            enable0 <= '1';
            reg0 <= WriteData;
          when "001" =>
            enable1 <= '1';
            reg1 <= WriteData;
          when "010" =>
            enable2 <= '1';
            reg2 <= WriteData;
          when "011" =>
            enable3 <= '1';
            reg3 <= WriteData;
          when "100" =>
            enable4 <= '1';
            reg4 <= WriteData;
          when "101" =>
            enable5 <= '1';
            reg5 <= WriteData;
          when "110" =>
            enable6 <= '1';
            reg6 <= WriteData;
          when others =>
            enable7 <= '1';
            reg7 <= WriteData;
        end case;
        if (RegWrite = '1') then
          case writeAddress is
            when "000" =>
              enable0 <= '1';
              reg0 <= WriteData;
            when "001" =>
              enable1 <= '1';
              reg1 <= WriteData;
            when "010" =>
              enable2 <= '1';
              reg2 <= WriteData;
            when "011" =>
              enable3 <= '1';
              reg3 <= WriteData;
            when "100" =>
              enable4 <= '1';
              reg4 <= WriteData;
            when "101" =>
              enable5 <= '1';
              reg5 <= WriteData;
            when "110" =>
              enable6 <= '1';
              reg6 <= WriteData;
            when others =>
              enable7 <= '1';
              reg7 <= WriteData;
          end case;
        end if;
        if (RegWrite = '0') then
          case Rsrc1 is
            when "000" =>

              reg0 <= WriteData;
            when "001" =>

              reg1 <= WriteData;
            when "010" =>

              reg2 <= WriteData;
            when "011" =>

              reg3 <= WriteData;
            when "100" =>

              reg4 <= WriteData;
            when "101" =>

              reg5 <= WriteData;
            when "110" =>

              reg6 <= WriteData;
            when others =>

              reg7 <= WriteData;
          end case;
        end if;
        if (RegWrite2 = '1') then
          case writeAddress2 is
            when "000" =>
              enable0 <= '1';
              reg0 <= WriteData2;
            when "001" =>
              enable1 <= '1';
              reg1 <= WriteData2;
            when "010" =>
              enable2 <= '1';
              reg2 <= WriteData2;
            when "011" =>
              enable3 <= '1';
              reg3 <= WriteData2;
            when "100" =>
              enable4 <= '1';
              reg4 <= WriteData2;
            when "101" =>
              enable5 <= '1';
              reg5 <= WriteData2;
            when "110" =>
              enable6 <= '1';
              reg6 <= WriteData2;
            when others =>
              enable7 <= '1';
              reg7 <= WriteData2;
          end case;
        end if;
      end if;
    end if;
  end process;
end architecture;
