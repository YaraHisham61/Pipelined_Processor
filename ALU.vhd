library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  -- use IEEE.STD_LOGIC_ARITH.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;
  use ieee.numeric_std.all;

  use ieee.std_logic_1164.all;

entity ALU is
  -- GENERIC (n : integer <= 32);
  port (
    Reg1, Reg2 : in  STD_LOGIC_VECTOR(31 downto 0);
    Signals    : in  STD_LOGIC_VECTOR(3 downto 0);
    CCR        : in  STD_LOGIC_VECTOR(3 downto 0);
    RegOut     : out STD_LOGIC_VECTOR(31 downto 0);
    CCROut     : out STD_LOGIC_VECTOR(3 downto 0));
end entity;

architecture archALU of ALU is
  signal tempOut    : STD_LOGIC_VECTOR(32 downto 0);
  signal tempReg1   : STD_LOGIC_VECTOR(32 downto 0) := (others => '0');
  signal tempReg2   : STD_LOGIC_VECTOR(32 downto 0) := (others => '0');
  signal bitset     : STD_LOGIC_VECTOR(32 downto 0) := (others => '0');
  signal ones       : STD_LOGIC_VECTOR(32 downto 0);
  signal zeros      : STD_LOGIC_VECTOR(32 downto 0) := (others => '0');
  signal bit        : std_logic_vector(32 downto 0) := (others => '0');
  signal shift      : std_logic_vector(65 downto 0) := (others => '0');
  signal shift2     : std_logic_vector(65 downto 0) := (others => '0');
  signal shiftleft  : std_logic_vector(65 downto 0) := (others => '0');
  signal shiftleft2 : std_logic_vector(65 downto 0) := (others => '0');
begin
  -- how make rotate left with carry with numbers times to rotate
  -- how make rotate right with carry with numbers times to rotate
  zeros                                       <= (others => '0');
  ones                                        <= (0 => '1', others => '0');
  tempReg1                                    <= '0' & Reg1;
  tempReg2                                    <= '0' & Reg2;
  bit(to_integer(unsigned(Reg2(4 downto 0)))) <= '1';
  bitset                                      <= tempReg1 or bit;
  --rotate right
  shift(65 downto 33) <= CCR(2) & Reg1;
  shift2              <= shift srl to_integer(unsigned(Reg2));
  --rotate right
  shiftleft(32 downto 0) <= CCR(2) & Reg1;
  shiftleft2             <= shiftleft sll to_integer(unsigned(Reg2));
  tempOut                <= tempReg1                                            when Signals = "0000" else
                            not tempReg1                                        when Signals = "0001" else
                            zeros - tempReg1                                    when Signals = "0010" else
                            tempReg1 + ones                                     when Signals = "0011" else
                            tempReg1 - ones                                     when Signals = "0100" else
                            tempReg1                                            when Signals = "0101" else
                            tempReg1 + tempReg2                                 when Signals = "0110" else
                            tempReg1 - tempReg2                                 when Signals = "0111" else
                            tempReg1 and tempReg2                               when Signals = "1000" else
                            tempReg1 or tempReg2                                when Signals = "1001" else
                            tempReg1 xor tempReg2                               when Signals = "1010" else
                            tempReg1 - tempReg2                                 when Signals = "1011" else
                            bitset                                              when Signals = "1100" else
                            shift2(65 downto 33) or shift2(32 downto 0)         when Signals = "1110" else
                            shiftleft2(65 downto 33) or shiftleft2(32 downto 0) when Signals = "1101" else
                            tempReg2                                            when Signals = "1111";
  RegOut <= tempOut(31 downto 0);

  CCROut(0) <= '1' when tempOut(31 downto 0) = "00000000000000000000000000000000" and Signals /= "0000" else
               '0' when tempOut(31 downto 0) /= "00000000000000000000000000000000" and Signals /= "0000" else
               CCR(0);
  CCROut(1) <= tempOut(31) when Signals /= "0000" else CCR(1);
  CCROut(3) <= '0';
  CCROut(2) <= tempOut(32) when Signals = "0110" else
               tempOut(32) when Signals = "1110" else
               tempOut(32) when Signals = "1101" else
               tempOut(32) when Signals = "0111" else
               tempOut(32) when Signals = "1011" else
               CCR(2)      when Signals = "0000" else
               '0';
end architecture;
