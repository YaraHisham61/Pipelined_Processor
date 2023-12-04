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
  signal Imm      : STD_LOGIC_VECTOR(32 downto 0);
  signal tempOut  : STD_LOGIC_VECTOR(32 downto 0) := (others => '0');
  signal tempCCR  : STD_LOGIC_VECTOR(3 downto 0)  := (others => '0');
  signal tempReg1 : STD_LOGIC_VECTOR(32 downto 0) := (others => '0');
  signal tempReg2 : STD_LOGIC_VECTOR(32 downto 0) := (others => '0');

begin
  -- Imm <= (to_integer(unsigned(Reg2)) => '1', others => '0');
  tempCCR  <= CCR;
  tempReg1 <= Reg1(31) & Reg1;
  tempReg2 <= Reg2(31) & Reg2;
  tempOut  <= (others => '0') when Signals = "0000" else
  not tempReg1                                      when Signals = "0001" else
                              0 - tempReg1          when Signals = "0010" else
                              tempReg1 + 1          when Signals = "0011" else
                              tempReg1 - 1          when Signals = "0100" else
                              -- tempReg1 + 1 when Signals="0101" else
  tempReg1 + tempReg2   when Signals = "0110" else
                              tempReg1 + tempReg2   when Signals = "0111" else
                              tempReg1 - tempReg2   when Signals = "1000" else
                              tempReg1 and tempReg2 when Signals = "1001" else
                              tempReg1 or tempReg2  when Signals = "1010" else
                              tempReg1 xor tempReg2 when Signals = "1011" else
                              tempReg1 - tempReg2   when Signals = "1100" else
                              -- tempReg1 + 1 when Signals="1101" else
  tempReg1 + 1          when Signals = "1110" else
                              tempReg1 + 1          when Signals = "1111" else

                               process (reset, Signals, Reg1, Reg2)

  begin
    if reset = '1' then
      tempOut <= (others => '0');
      tempCCR <= (others => '0');
    else
      case Signals is
        when "0000" =>
          -- NOP
          tempOut <= (others => '0');
          tempCCR <= CCR;
        when "0001" =>
          -- NOT
          -- IF rising_edge(clk) THEN
          tempOut <= not Reg1;
          if tempOut = "00000000000000000000000000000000" then
            tempCCR(0) <= '1';
          else
            tempCCR(0) <= '0';
          end if;
          if tempOut(31) = '1' then
            tempCCR(1) <= '1';
          else
            tempCCR(1) <= '0';
          end if;
          -- END IF;
        when "0010" =>
          -- NEG
          -- IF rising_edge(clk) THEN
          tempOut <= 0 - Reg1;
          if tempOut = "00000000000000000000000000000000" then
            tempCCR(0) <= '1';
          else
            tempCCR(0) <= '0';
          end if;
          if tempOut < "00000000000000000000000000000000" then
            tempCCR(1) <= '1';
          else
            tempCCR(1) <= '0';
          end if;
          -- END IF;
        when "0011" =>
          -- INC
          -- IF rising_edge(clk) THEN
          tempOut <= Reg1 + 1;
          if tempOut = "00000000000000000000000000000000" then
            tempCCR(0) <= '1';
          else
            tempCCR(0) <= '0';
          end if;
          if tempOut < "00000000000000000000000000000000" then
            tempCCR(1) <= '1';
          else
            tempCCR(1) <= '0';
          end if;
          -- END IF;
        when "0100" =>
          -- DEC
          -- IF rising_edge(clk) THEN
          tempOut <= Reg1 - 1;
          if tempOut = "00000000000000000000000000000000" then
            tempCCR(0) <= '1';
          else
            tempCCR(0) <= '0';
          end if;
          if tempOut < "00000000000000000000000000000000" then
            tempCCR(1) <= '1';
          else
            tempCCR(1) <= '0';
          end if;
          -- END IF;
        when "0101" =>
          -- SEWP
          -- IF rising_edge(clk) THEN
          -- SWAP
          -- END IF;
        when "0110" =>
          -- ADD
          -- IF rising_edge(clk) THEN
          tempOut <= Reg1 + Reg2;
          if tempOut = "00000000000000000000000000000000" then
            tempCCR(0) <= '1';
          else
            tempCCR(0) <= '0';
          end if;
          if tempOut < "00000000000000000000000000000000" then
            tempCCR(1) <= '1';
          else
            tempCCR(1) <= '0';
          end if;
          -- END IF;
        when "0111" =>
          -- ADDI
          -- IF rising_edge(clk) THEN
          tempOut <= Reg1 + Reg2;
          if tempOut = "00000000000000000000000000000000" then
            tempCCR(0) <= '1';
          else
            tempCCR(0) <= '0';
          end if;
          if tempOut < "00000000000000000000000000000000" then
            tempCCR(1) <= '1';
          else
            tempCCR(1) <= '0';
          end if;
          -- END IF;
        when "1000" =>
          -- SUB
          -- IF rising_edge(clk) THEN
          tempOut <= Reg1 - Reg2;
          if tempOut = "00000000000000000000000000000000" then
            tempCCR(0) <= '1';
          else
            tempCCR(0) <= '0';
          end if;
          if tempOut < "00000000000000000000000000000000" then
            tempCCR(1) <= '1';
          else
            tempCCR(1) <= '0';
          end if;
          -- END IF;
        when "1001" =>
          -- AND
          -- IF rising_edge(clk) THEN
          tempOut <= Reg1 and Reg2;
          if tempOut = "00000000000000000000000000000000" then
            tempCCR(0) <= '1';
          else
            tempCCR(0) <= '0';
          end if;
          if tempOut < "00000000000000000000000000000000" then
            tempCCR(1) <= '1';
          else
            tempCCR(1) <= '0';
          end if;

        when "1010" =>
          -- OR
          -- IF rising_edge(clk) THEN
          tempOut <= Reg1 or Reg2;
          if tempOut = "00000000000000000000000000000000" then
            tempCCR(0) <= '1';
          else
            tempCCR(0) <= '0';
          end if;
          if tempOut < "00000000000000000000000000000000" then
            tempCCR(1) <= '1';
          else
            tempCCR(1) <= '0';
          end if;

          -- END IF;
        when "1011" =>
          -- XOR
          -- IF rising_edge(clk) THEN
          tempOut <= Reg1 xor Reg2;
          if tempOut = "00000000000000000000000000000000" then
            tempCCR(0) <= '1';
          else
            tempCCR(0) <= '0';
          end if;
          if tempOut < "00000000000000000000000000000000" then
            tempCCR(1) <= '1';
          else
            tempCCR(1) <= '0';
          end if;

          -- END IF;
        when "1100" =>
          -- CMP
          -- IF rising_edge(clk) THEN
          tempOut <= Reg1 - Reg2;
          if tempOut = "00000000000000000000000000000000" then
            tempCCR(0) <= '1';
          else
            tempCCR(0) <= '0';
          end if;
          if tempOut < "00000000000000000000000000000000" then
            tempCCR(1) <= '1';
          else
            tempCCR(1) <= '0';
          end if;

          -- END IF;
        when "1101" =>
          -- BITSET
          -- if rising_edge(clk) then
          --   if Reg2 >= 0 and Reg2 <= 31 then
          --     -- Imm <= to_integer(Reg2(15 downto 0));
          --     tempCCR(2) <= Reg1(imm);
          --     tempOut(imm) <= '1';
          --   else
          --     tempCCR(2) <= '0';
          --   end if;
          -- end if;
        when "1110" =>
          -- RCL
          -- IF rising_edge(clk) THEN
          tempOut <= (Reg1(30 downto 0) & tempCCR(2));
          if tempOut = "00000000000000000000000000000000" then
            tempCCR(0) <= '1';
          else
            tempCCR(0) <= '0';
          end if;
          tempCCR(2) <= Reg1(0);
          if tempOut < "00000000000000000000000000000000" then
            tempCCR(1) <= '1';
          else
            tempCCR(1) <= '0';
          end if;
          -- END IF;
        when "1111" =>
          -- RCR
          -- IF rising_edge(clk) THEN
          tempOut <= (tempCCR(2) & Reg1(31 downto 1));
          tempCCR(2) <= Reg1(0);
          if tempOut = "00000000000000000000000000000000" then
            tempCCR(0) <= '1';
          else
            tempCCR(0) <= '0';
          end if;
          if tempOut < "00000000000000000000000000000000" then
            tempCCR(1) <= '1';
          else
            tempCCR(1) <= '0';
          end if;
        when others => tempOut <= "00000000000000000000000000000000";
      end case;
    end if;

  end process;
  CCROut <= tempCCR;
  RegOut <= tempOut;
end architecture;
