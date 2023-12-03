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

 process (opcode)
 begin
   -- Default values
   reg_read1  <= '1';
   branch  <= '0';
   immediate_value  <= '0';
   mem_write  <= '0';
   stack_write  <= '0';
   stack_read  <= '0';
   mem_read  <= '0';
   reg_write2  <= '0';
   reg_read3  <= '0';
   reg_read2  <= '0';
   reg_write1 <='1';
   protectAfree<='0';
   protectOfree  <= '0';
   inOout<='0';
   inAout<='0';


   -- Conditions
case opcode is
            when "0010000" =>
                alu_op <= "0001"; --not "0001" 
            when "0010011" =>
                alu_op <= "0010"; --neg "0010"
            when "0010001" =>
                alu_op <= "0011"; --incr "0011" 
            when "0010010" =>
                alu_op <= "0100"; --dec "0100" 
            when "0101111" =>
                alu_op <= "0101"; --swap "0101" 
            when "0110001" =>
                alu_op <= "0110"; --add "0110" 
            when "1100000" =>
                alu_op <= "0110"; --addi "0110" 
            when "0110010" =>
                alu_op <= "0111"; --sub "0111" 
            when "0110011" =>
                alu_op <= "1000"; --and "1000" 
            when "0110100" =>
                alu_op <= "1001"; --or "1001" 
            when "0110101" =>
                alu_op <= "1010"; --xor "1010" 
            when "0101110" =>
                alu_op <= "1011"; --compare "1011" 
            when "1010000" => 
                alu_op <= "1100"; --bitset "1100" ?????alu opeartion
            when "1011101" =>
                alu_op <= "1101"; --rcl "1101" 
            when "1011100" =>
                alu_op <= "1110"; --rcr "1110"
            when "0011100" =>
                alu_op <= "1111"; --jz "1111" 

      WHEN OTHERS =>
        alu_op <= "0000";

    END CASE;

    if opcode(6 downto 4)="000" or opcode="1010001" or opcode="0101110" or opcode (6 downto 3)="0011" or opcode (6 downto 1)="001010" or opcode="0010111" then
    reg_write1 <='0';
    end if;
   if opcode(6 downto 4) = "000" or opcode(6 downto 1) = "101111" or opcode ="0010110" or opcode (6 downto 1)="001010"   then
     reg_read1  <= '0';
   end if;
 
   if opcode(6 downto 2) = "00111" or opcode(6 downto 3)="0001" then
     branch  <= '1';
   end if;
 
   if opcode(6) = '1' then
     immediate_value  <= '1';
   end if;
 
   if opcode = "1010001" or opcode="0010111"  or opcode ="0011110"then
     mem_write  <= '1';
   end if;
 
   if opcode = "0010111"  or opcode ="0011110" then
     stack_write  <= '1';
   end if;
 
   if opcode(6 downto 3) = "0001" or opcode = "0010110"   then
     stack_read  <= '1';
   end if;
 
   if opcode(6 downto 2) = "00011" or opcode = "1011110" or opcode ="0010110" then
     mem_read  <= '1';
   end if;
 
   if opcode = "0101111" then
     reg_write2  <= '1';
   end if;
    if opcode = "0011010" then-- free write the bit to one and memwrite is raise and the bits not used in th instruction be all zero
     protectAfree  <= '1';
    end if;
    if opcode = "0011011" then-- protect write the bit to be zero
     protectAfree  <= '0';
   end if;

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