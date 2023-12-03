LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY CustomControlunit IS
  PORT (
    opcode : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
    mem_read, immediate_value, branch, mem_write, reg_write1, reg_write2, reg_read1, reg_read2, reg_read3, stack_read, stack_write, protectAfree, protectOfree, inOout, inAout : OUT STD_LOGIC;
    clk : IN STD_LOGIC;
    alu_op : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END CustomControlunit;

ARCHITECTURE ControlunitTraditionalArch OF CustomControlunit IS
  --    signal  mem_read ,immediate_value ,branch ,mem_write ,reg_write1 ,reg_write2 ,reg_read1 ,reg_read2 ,reg_read3 ,stack_read ,stack_write :  std_logic;
BEGIN

  -- reg_read1 <='0' when opcode(6 downto 4)="000" or opcode(6 downto 1)="101111" else '0';
  --  branch  <='1' when opcode(6 downto 2) ="00111" else '0';
  --  immediate_value  <= '1' when opcode(6) ='1' else '0';
  -- mem_write  <='1' when opcode ="1010001" else '0';
  -- stack_write <='1' when opcode ="0010111" else '0';
  -- stack_read  <='1' when opcode(6 downto 4)="000" or opcode="1010001" else '0';
  -- mem_read  <='1' when opcode(6 downto 3)="0001" or opcode="1011110" else '0';
  -- reg_write2 <='1' when opcode="0101111" else '0';
  --  reg_read3 <='1' when opcode(6 downto 4)="011"else '0';
  --  reg_read2 <='1' when opcode(6 downto 4)="011" or opcode (5 downto 4)="10" else '0';

  PROCESS (opcode)
  BEGIN
    -- Default values
    reg_read1 <= '1';
    branch <= '0';
    immediate_value <= '0';
    mem_write <= '0';
    stack_write <= '0';
    stack_read <= '0';
    mem_read <= '0';
    reg_write2 <= '0';
    reg_read3 <= '0';
    reg_read2 <= '0';
    reg_write1 <= '1';
    protectAfree <= '0';
    protectOfree <= '1';
    inOout <= '0';
    inAout <= "0";
    -- Conditions
    CASE opcode IS
      WHEN "0010000" =>
        alu_op <= "0001"; --not "0001" 
      WHEN "0010011" =>
        alu_op <= "0010"; --neg "0010"
      WHEN "0010001" =>
        alu_op <= "0011"; --incr "0011" 
      WHEN "0010010" =>
        alu_op <= "0100"; --dec "0100" 
      WHEN "0101111" =>
        alu_op <= "0101"; --swap "0101" 
      WHEN "0110001" =>
        alu_op <= "0110"; --add "0110" 
      WHEN "1100000" =>
        alu_op <= "0110"; --addi "0110" 
      WHEN "0110010" =>
        alu_op <= "0111"; --sub "0111" 
      WHEN "0110011" =>
        alu_op <= "1000"; --and "1000" 
      WHEN "0110100" =>
        alu_op <= "1001"; --or "1001" 
      WHEN "0110101" =>
        alu_op <= "1010"; --xor "1010" 
      WHEN "0101110" =>
        alu_op <= "1011"; --compare "1011" 
      WHEN "1010000" =>
        alu_op <= "1100"; --bitset "1100" ?????alu opeartion
      WHEN "1011101" =>
        alu_op <= "1101"; --rcl "1101" 
      WHEN "1011100" =>
        alu_op <= "1110"; --rcr "1110"
      WHEN "0011100" =>
        alu_op <= "1111"; --jz "1111" 

      WHEN OTHERS =>
        alu_op <= "0000";

    END CASE;

    IF opcode(6 DOWNTO 4) = "000" OR opcode = "1010001" OR opcode = "0101110" OR opcode (6 DOWNTO 3) = "0011" OR opcode (6 DOWNTO 1) = "001010" OR opcode = "0010111" THEN
      reg_write1 <= '0';
    END IF;
    IF opcode(6 DOWNTO 4) = "000" OR opcode(6 DOWNTO 1) = "101111" OR opcode = "0010110" OR opcode (6 DOWNTO 1) = "001010" THEN
      reg_read1 <= '0';
    END IF;

    IF opcode(6 DOWNTO 2) = "00111" OR opcode(6 DOWNTO 3) = "0001" THEN
      branch <= '1';
    END IF;

    IF opcode(6) = '1' THEN
      immediate_value <= '1';
    END IF;

    IF opcode = "1010001" OR opcode = "0010111" OR opcode = "0011110"THEN
      mem_write <= '1';
    END IF;

    IF opcode = "0010111" OR opcode = "0011110" THEN
      stack_write <= '1';
    END IF;

    IF opcode(6 DOWNTO 3) = "0001" OR opcode = "0010110" THEN
      stack_read <= '1';
    END IF;

    IF opcode(6 DOWNTO 2) = "00011" OR opcode = "1011110" OR opcode = "0010110" THEN
      mem_read <= '1';
    END IF;

    IF opcode = "0101111" THEN
      reg_write2 <= '1';
    END IF;
    IF opcode = "0011010" THEN-- free write the bit to one and memwrite is raise and the bits not used in th instruction be all zero
      protectAfree <= '1';
    END IF;
  END IF;
  IF opcode = "0011011" THEN-- protect write the bit to be zero
    protectAfree <= '0';
  END IF;

  IF opcode (6 DOWNTO 1) = "001101" THEN-- protect write the bit to be zero
    protectOfree <= '1';
  END IF;
  IF opcode(6 DOWNTO 4) = "011" THEN
    reg_read3 <= '1';
  END IF;

  IF opcode(6 DOWNTO 4) = "011" OR opcode(5 DOWNTO 4) = "10" THEN
    reg_read2 <= '1';
  END IF;

  --    reg_read1 <= reg_read1 ;
  --    branch <= branch ;
  --    immediate_value <= immediate_value ;
  --    mem_write <= mem_write ;
  --    stack_write <= stack_write ;
  --    stack_read <= stack_read ;
  --    mem_read <= mem_read ;
  --    reg_write2 <= reg_write2 ;
  --    reg_read3 <= reg_read3 ;
  --    reg_read2 <= reg_read2 ;
  --    reg_write1<=reg_write1 ;

END PROCESS;
END ControlunitTraditionalArch;