library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.STD_LOGIC_ARITH.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;
  use ieee.numeric_std.all;
  use std.STANDARD.NATURAL;

  use ieee.std_logic_1164.all;

entity ALU is
  -- GENERIC (n : integer <= 32);
  port (
    Reg1, Reg2 : in  STD_LOGIC_VECTOR(31 downto 0);
    Signals    : in  STD_LOGIC_VECTOR(3 downto 0);
    CCR        : in  STD_LOGIC_VECTOR(3 downto 0);
    clk        : in  STD_LOGIC;
    RegOut     : out STD_LOGIC_VECTOR(31 downto 0);
    CCROut     : out STD_LOGIC_VECTOR(3 downto 0));
end entity;

architecture archALU of ALU is
  signal Imm      : STD_LOGIC_VECTOR(32 downto 0);
  signal tempOut  : STD_LOGIC_VECTOR(32 downto 0) := (others => '0');
  signal tempCCR  : STD_LOGIC_VECTOR(3 downto 0)  := (others => '0');
  signal tempReg1 : STD_LOGIC_VECTOR(32 downto 0) := (others => '0');
  signal tempReg2 : STD_LOGIC_VECTOR(32 downto 0) := (others => '0');
  signal ones     : STD_LOGIC_VECTOR(32 downto 0);
  signal zeros    : STD_LOGIC_VECTOR(32 downto 0);
begin

  -- Imm <= (to_integer(unsigned(Reg2)) => '1', others => '0');
  tempCCR  <= CCR;
  zeros    <= (others => '0');
  ones     <= (0 => '1', others => '0');
  tempReg1 <= Reg1(31) & Reg1;
  tempReg2 <= Reg2(31) & Reg2;
  tempOut  <= not tempReg1          when Signals = "0001" else
              0 - tempReg1          when Signals = "0010" else
              tempReg1 + 1          when Signals = "0011" else
              tempReg1 - 1          when Signals = "0100" else
              tempReg1 + tempReg2   when Signals = "0110" else
              tempReg1 + tempReg2   when Signals = "0111" else
              tempReg1 - tempReg2   when Signals = "1000" else
              tempReg1 and tempReg2 when Signals = "1001" else
              tempReg1 or tempReg2  when Signals = "1010" else
              tempReg1 xor tempReg2 when Signals = "1011" else
              tempReg1 - tempReg2   when Signals = "1100" else
                                                  (others => '0');

  aluu: process (clk)
  begin
    if clk'event and clk = '1' then
      CCROut(0) <= '1' when tempOut(31 downto 0) = "00000000000000000000000000000000"
    else
      '0';
      CCROut(1) <= tempOut(31);
      CCROut(3) <= '0';
      case Signals is
        when "0011" =>
          CCROut(2) <= tempOut(32);
        when "0100" =>
          CCROut(2) <= tempOut(32);
        when "0101" =>
          CCROut(2) <= tempOut(32);
        when "0110" =>
          CCROut(2) <= tempOut(32);
        when "0111" =>
          CCROut(2) <= tempOut(32);
        when others => CCROut(2) <= '0';
      end case;
      RegOut <= tempOut(31 downto 0);
    end if;

  end process;
end architecture;
