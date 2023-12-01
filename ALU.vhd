LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ALU IS
  -- GENERIC (n : integer <= 32);
  PORT (
    Reg1, Reg2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    Signals : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    CCR : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    clk : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    RegOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    CCROut : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END ENTITY;

ARCHITECTURE archALU OF ALU IS
  SIGNAL Imm : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL tempOut : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL tempCCR : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');

BEGIN
  -- Imm <= (to_integer(unsigned(Reg2)) => '1', others => '0');
  PROCESS (clk, reset, Signals)
  BEGIN
    IF reset = '1' THEN
      tempOut <= (OTHERS => '0');
      tempCCR <= (OTHERS => '0');
    ELSE
      CASE Signals IS
        WHEN "0000" =>
          -- NOP
          tempOut <= (OTHERS => '0');
          tempCCR <= CCR;
        WHEN "0001" =>
          -- NOT
          -- IF rising_edge(clk) THEN
          tempOut <= NOT Reg1;
          IF tempOut = "00000000000000000000000000000000" THEN
            tempCCR(0) <= '1';
          END IF;
          tempCCR(1) <= tempOut(tempOut'left);
          -- END IF;
        WHEN "0010" =>
          -- NEG
          -- IF rising_edge(clk) THEN
          tempOut <= 0 - Reg1;
          IF tempOut = "00000000000000000000000000000000" THEN
            tempCCR(0) <= '1';
          END IF;
          tempCCR(1) <= tempOut(tempOut'left);
          -- END IF;
        WHEN "0011" =>
          -- INC
          -- IF rising_edge(clk) THEN
          tempOut <= Reg1 + 1;
          IF tempOut = "00000000000000000000000000000000" THEN
            tempCCR(0) <= '1';
          END IF;
          tempCCR(1) <= tempOut(tempOut'left);
          -- END IF;
        WHEN "0100" =>
          -- DEC
          -- IF rising_edge(clk) THEN
          tempOut <= Reg1 - 1;
          IF tempOut = "00000000000000000000000000000000" THEN
            tempCCR(0) <= '1';
          END IF;
          tempCCR(1) <= tempOut(tempOut'left);
          -- END IF;
        WHEN "0101" =>
          -- SEWP
          -- IF rising_edge(clk) THEN
          -- SWAP
          -- END IF;
        WHEN "0110" =>
          -- ADD
          -- IF rising_edge(clk) THEN
          tempOut <= Reg1 + Reg2;
          IF tempOut = "00000000000000000000000000000000" THEN
            tempCCR(0) <= '1';
          END IF;
          tempCCR(1) <= tempOut(tempOut'left);
          -- END IF;
        WHEN "0111" =>
          -- ADDI
          -- IF rising_edge(clk) THEN
          tempOut <= Reg1 + Reg2;
          IF tempOut = "00000000000000000000000000000000" THEN
            tempCCR(0) <= '1';
          END IF;
          tempCCR(1) <= tempOut(tempOut'left);
          -- END IF;
        WHEN "1000" =>
          -- SUB
          -- IF rising_edge(clk) THEN
          tempOut <= Reg1 - Reg2;
          IF tempOut = "00000000000000000000000000000000" THEN
            tempCCR(0) <= '1';
          END IF;
          tempCCR(1) <= tempOut(tempOut'left);
          -- END IF;
        WHEN "1001" =>
          -- AND
          -- IF rising_edge(clk) THEN
          tempOut <= Reg1 AND Reg2;
          IF tempOut = "00000000000000000000000000000000" THEN
            tempCCR(0) <= '1';
          END IF;
          tempCCR(1) <= tempOut(tempOut'left);
          -- END IF;
        WHEN "1010" =>
          -- OR
          -- IF rising_edge(clk) THEN
          tempOut <= Reg1 OR Reg2;
          IF tempOut = "00000000000000000000000000000000" THEN
            tempCCR(0) <= '1';
          END IF;
          tempCCR(1) <= tempOut(tempOut'left);
          -- END IF;
        WHEN "1011" =>
          -- XOR
          -- IF rising_edge(clk) THEN
          tempOut <= Reg1 XOR Reg2;
          IF tempOut = "00000000000000000000000000000000" THEN
            tempCCR(0) <= '1';
          END IF;
          tempCCR(1) <= tempOut(tempOut'left);
          -- END IF;
        WHEN "1100" =>
          -- CMP
          -- IF rising_edge(clk) THEN
          tempOut <= Reg1 - Reg2;
          IF tempOut = "00000000000000000000000000000000" THEN
            tempCCR(0) <= '1';
          END IF;
          tempCCR(1) <= tempOut(tempOut'left);
          -- END IF;
        WHEN "1101" =>
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
        WHEN "1110" =>
          -- RCL
          -- IF rising_edge(clk) THEN
          IF tempOut = "00000000000000000000000000000000" THEN
            tempCCR(0) <= '1';
          END IF;
          tempCCR(2) <= Reg1(0);
          -- END IF;
        WHEN "1111" =>
          -- RCR
          -- IF rising_edge(clk) THEN
          --imm no set
          tempOut <= (tempCCR(2) & Reg1(31 DOWNTO 1));
          tempCCR(2) <= Reg1(0);
          -- END IF;
          -- when "1111" =>
          --   -- LDM
          --   if rising_edge(clk) then
          --     tempOut <= Reg2;
          --     if tempOut = "00000000000000000000000000000000" then
          --       tempCCR(0) <= '1';
          --     end if;
          --     tempCCR(1) <= tempOut(tempOut'left);
          --   end if;
        WHEN OTHERS => tempCCR(0) <= '1';
      END CASE;
    END IF;
    CCROut <= tempCCR;
    RegOut <= tempOut;
  END PROCESS;
END ARCHITECTURE;