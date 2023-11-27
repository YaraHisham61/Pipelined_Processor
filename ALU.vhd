library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.STD_LOGIC_ARITH.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;
  use IEEE.NUMERIC_STD.all;

entity ALU is
  -- GENERIC (n : integer := 32);
  port (
    Reg1, Reg2 : in  std_logic_vector(31 downto 0);
    Signals    : in  std_logic_vector(3 downto 0);
    CCR        : in  std_logic_vector(3 downto 0);
    clk        : in  std_logic;
    reset      : in  std_logic;
    RegOut     : out std_logic_vector(31 downto 0);
    CCROut     : out std_logic_vector(3 downto 0));
end entity;

architecture archALU of ALU is
  signal Imm : std_logic_vector(31 downto 0);
begin
  -- Imm <= (to_integer(unsigned(Reg2)) => '1', others => '0');
  process (clk, reset, Signals)
    variable tempOut : std_logic_vector(31 downto 0) := (others => '0');
    variable tempCCR : std_logic_vector(3 downto 0)  := (others => '0');
  begin
    if reset = '1' then
      tempOut := (others => '0');
      tempCCR := (others => '0');
    else
      case Signals is
        when "0000" =>
          -- NOP
          tempOut := (others => '0');
          tempCCR := CCR;
        when "0001" =>
          -- NOT
          if rising_edge(clk) then
            tempOut := not Reg1;
            if tempOut = "00000000000000000000000000000000" then
              tempCCR(0) := '1';
            end if;
            tempCCR(1) := tempOut(tempOut'left);
          end if;
        when "0010" =>
          -- NEG
          if rising_edge(clk) then
            tempOut := 0 - Reg1;
            if tempOut = "00000000000000000000000000000000" then
              tempCCR(0) := '1';
            end if;
            tempCCR(1) := tempOut(tempOut'left);
          end if;
        when "0011" =>
          -- INC
          if rising_edge(clk) then
            tempOut := Reg1 + 1;
            if tempOut = "00000000000000000000000000000000" then
              tempCCR(0) := '1';
            end if;
            tempCCR(1) := tempOut(tempOut'left);
          end if;
        when "0100" =>
          -- DEC
          if rising_edge(clk) then
            tempOut := Reg1 - 1;
            if tempOut = "00000000000000000000000000000000" then
              tempCCR(0) := '1';
            end if;
            tempCCR(1) := tempOut(tempOut'left);
          end if;
        when "0101" =>
          -- SEWP
          if rising_edge(clk) then
            -- SWAP
          end if;
        when "0110" =>
          -- ADD
          if rising_edge(clk) then
            tempOut := Reg1 + Reg2;
            if tempOut = "00000000000000000000000000000000" then
              tempCCR(0) := '1';
            end if;
            tempCCR(1) := tempOut(tempOut'left);
          end if;
        when "0111" =>
          -- ADDI
          if rising_edge(clk) then
            tempOut := Reg1 + Reg2;
            if tempOut = "00000000000000000000000000000000" then
              tempCCR(0) := '1';
            end if;
            tempCCR(1) := tempOut(tempOut'left);
          end if;
        when "1000" =>
          -- SUB
          if rising_edge(clk) then
            tempOut := Reg1 - Reg2;
            if tempOut = "00000000000000000000000000000000" then
              tempCCR(0) := '1';
            end if;
            tempCCR(1) := tempOut(tempOut'left);
          end if;
        when "1001" =>
          -- AND
          if rising_edge(clk) then
            tempOut := Reg1 and Reg2;
            if tempOut = "00000000000000000000000000000000" then
              tempCCR(0) := '1';
            end if;
            tempCCR(1) := tempOut(tempOut'left);
          end if;
        when "1010" =>
          -- OR
          if rising_edge(clk) then
            tempOut := Reg1 or Reg2;
            if tempOut = "00000000000000000000000000000000" then
              tempCCR(0) := '1';
            end if;
            tempCCR(1) := tempOut(tempOut'left);
          end if;
        when "1011" =>
          -- XOR
          if rising_edge(clk) then
            tempOut := Reg1 xor Reg2;
            if tempOut = "00000000000000000000000000000000" then
              tempCCR(0) := '1';
            end if;
            tempCCR(1) := tempOut(tempOut'left);
          end if;
        when "1100" =>
          -- CMP
          if rising_edge(clk) then
            tempOut := Reg1 - Reg2;
            if tempOut = "00000000000000000000000000000000" then
              tempCCR(0) := '1';
            end if;
            tempCCR(1) := tempOut(tempOut'left);
          end if;
        when "1101" =>
          -- BITSET
          -- if rising_edge(clk) then
          --   if Reg2 >= 0 and Reg2 <= 31 then
          --     -- Imm <= to_integer(Reg2(15 downto 0));
          --     tempCCR(2) := Reg1(imm);
          --     tempOut(imm) := '1';
          --   else
          --     tempCCR(2) := '0';
          --   end if;
          -- end if;
        when "1110" =>
          -- RCL
          if rising_edge(clk) then
            if tempOut = "00000000000000000000000000000000" then
              tempCCR(0) := '1';
            end if;
            tempCCR(2) := Reg1(0);
          end if;
        when "1111" =>
          -- RCR
          if rising_edge(clk) then
            --imm no set
            tempOut := (tempCCR(2) & Reg1(31 downto 1));
            tempCCR(2) := Reg1(0);
          end if;
          -- when "1111" =>
          --   -- LDM
          --   if rising_edge(clk) then
          --     tempOut := Reg2;
          --     if tempOut = "00000000000000000000000000000000" then
          --       tempCCR(0) := '1';
          --     end if;
          --     tempCCR(1) := tempOut(tempOut'left);
          --   end if;
        when others => tempCCR(0) := '1';
      end case;
    end if;
    CCROut <= tempCCR;
    RegOut <= tempOut;
  end process;
end architecture;
