library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.STD_LOGIC_ARITH.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_1164.all;

entity ALU is
  -- GENERIC (n : integer <= 32);
  port (
    Reg1, Reg2 : in  STD_LOGIC_VECTOR(31 downto 0);
    Signals    : in  STD_LOGIC_VECTOR(3 downto 0);
    CCR        : in  STD_LOGIC_VECTOR(3 downto 0);
    clk        : in  STD_LOGIC;
    reset      : in  STD_LOGIC;
    RegOut     : out STD_LOGIC_VECTOR(31 downto 0);
    CCROut     : out STD_LOGIC_VECTOR(3 downto 0));
end entity;

architecture archALU of ALU is
  signal tempOut  : STD_LOGIC_VECTOR(32 downto 0) := (others => '0');
  signal tempCCR  : STD_LOGIC_VECTOR(3 downto 0)  := (others => '0');
  signal tempReg1 : STD_LOGIC_VECTOR(32 downto 0) := (others => '0');
  signal tempReg2 : STD_LOGIC_VECTOR(32 downto 0) := (others => '0');

begin

  tempCCR  <= CCR;
  tempReg1 <= Reg1(31) & Reg1;
  tempReg2 <= Reg2(31) & Reg2;
  tempOut  <= (others => '0') when Signals = "0000" else
  not tempReg1                                      when Signals = "0001" else
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

  process (reset, Signals, Reg1, Reg2, tempCCR, tempOut, tempReg1, tempReg2)
  begin
    if reset = '1' then
      tempOut <= (others => '0');
      tempCCR <= (others => '0');
    else
      if (tempOut = "000000000000000000000000000000000") then
        tempCCR(0) <= '1';
      else
        tempCCR(0) <= '0';
      end if;
      if (tempOut(31) < '1') then
        tempCCR(1) <= '1';
      else
        tempCCR(1) <= '0';
      end if;
      if (tempOut(32) < '1') then
        tempCCR(2) <= '1';
      else
        tempCCR(2) <= '0';
      end if;
      tempCCR(3) <= '0';
    end if;
    CCROut <= tempCCR;
    RegOut <= tempOut(31 downto 0);
  end process;
end architecture;
