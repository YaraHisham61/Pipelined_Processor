library ieee;
use ieee.std_logic_1164.all;


entity Controlunit is
  port (
    opcode: in std_logic_vector (4 downto 0);
   mem_read,immediate_value,branch,mem_write,reg_write1,reg_write2,reg_read1,reg_read2,reg_read3,stack_read,stack_write: out std_logic;
   clk  : in  std_logic;
   alu_op : out STD_LOGIC_VECTOR(3 downto 0)
  );
end Controlunit;

architecture ControlunitTraditionalArch of Controlunit is
begin
    process (opcode,clk)
begin
---signal reset
              immediate_value<='0';
               mem_read <= '0';
                branch <= '0';
                mem_write <= '0';
                reg_write1 <= '0';
                reg_write2 <= '0';
                reg_read1 <= '0';
                reg_read2 <= '0';
                reg_read3 <= '0';
                stack_read  <= '0';
                stack_write <= '0';
                alu_op <= "0000";
        case opcode is
            when "00000" =>
                alu_op <= "0000"; --nop "0000"
               

            when "00001" =>
                mem_read <= '1';
                stack_read  <= '1';
                alu_op <= "0000"; --ret "0000"
               
             when "00010" =>
                 mem_read <= '1';
                stack_read  <= '1';
                alu_op <= "0000"; --rlt "0000" flag restore

             when "00011" =>
                reg_write1 <= '1';
                reg_read1 <= '1';
                alu_op <= "0001"; --not "0001" 

           when "00100" =>
                reg_write1 <= '1';
                reg_read1 <= '1';
                alu_op <= "0010"; --neg "0010"
            when "00101" =>
                reg_write1 <= '1';
                reg_read1 <= '1';
                alu_op <= "0011"; --incr "0011" 
            when "00110" =>
                reg_write1 <= '1';
                reg_read1 <= '1';
                alu_op <= "0100"; --dec "0100" 
------out in ports to be implemented?????----------------
            when "00111" =>
                reg_write1 <= '1';
                reg_read1 <= '1';
                reg_write2 <= '1';
                reg_read2 <= '1';
                alu_op <= "0101"; --swap "0101" 
            when "01000" =>
                reg_write1 <= '1';
                reg_read1 <= '1';
                reg_read3 <= '1';
                reg_read2 <= '1';
                alu_op <= "0110"; --add "0110" 
            when "01001" =>
                reg_write1 <= '1';
                reg_read1 <= '1';
                immediate_value <= '1';
                reg_read2 <= '1';
                alu_op <= "0110"; --addi "0110" 
            when "01010" =>
                reg_write1 <= '1';
                reg_read1 <= '1';
                reg_read3 <= '1';
                reg_read2 <= '1';
                alu_op <= "0111"; --sub "0111" 
            when "01011" =>
                reg_write1 <= '1';
                reg_read1 <= '1';
                reg_read3 <= '1';
                reg_read2 <= '1';
                alu_op <= "1000"; --and "1000" 

            when "01100" =>
                reg_write1 <= '1';
                reg_read1 <= '1';
                reg_read3 <= '1';
                reg_read2 <= '1';
                alu_op <= "1001"; --or "1001" 
           when "01101" =>
                reg_write1 <= '1';
                reg_read1 <= '1';
                reg_read3 <= '1';
                reg_read2 <= '1';
                alu_op <= "1010"; --xor "1010" 
        when "01110" =>
                reg_read1 <= '1';
                reg_read2 <= '1';
                alu_op <= "1011"; --compare "1011" 
        when "01111" =>
                reg_read1 <= '1';
                immediate_value <= '1';
                reg_write1<= '1';
                alu_op <= "1100"; --bitset "1100" ?????alu opeartion
        when "10000" =>
                reg_read1 <= '1';
                immediate_value <= '1';
                reg_write1<= '1';
                alu_op <= "1101"; --rcl "1101" 
        when "10001" =>
                reg_read1 <= '1';
                immediate_value <= '1';
                reg_write1<= '1';
                alu_op <= "1110"; --rcr "1110"
        when "10010" =>
                reg_read1 <= '1';
                stack_write<= '1';
                alu_op <= "0000"; --push "0000"
        when "10011" =>
                reg_write1 <= '1';
                stack_read<= '1';
                alu_op <= "0000"; --pop "0000"
        when "10100" =>
                immediate_value<= '1';
                reg_write1 <= '1';
                alu_op <= "0000"; --ldm "0000"
        when "10101" =>
                 immediate_value<= '1';
                mem_read <= '1';
                reg_write1 <= '1';
                alu_op <= "0000"; --ldd "0000"
        when "10110" =>
                immediate_value<= '1';
                mem_write <= '1';
                reg_read1 <= '1';
                alu_op <= "0000"; --std "0000"
---------------protect and free to be implemented in future----------
        when "10111" =>
                branch <= '1';
                reg_read1 <= '1';
                alu_op <= "1111"; --jz "1111" 
        when "11000" =>
                branch <= '1';
                reg_read1 <= '1';
                alu_op <= "0000"; --jmp "0000" 
        when "11001" =>
                branch <= '1';
                reg_read1 <= '1';
                alu_op <= "0000"; --call "0000" 
       when others=>
 immediate_value<='0';
               mem_read <= '0';
                branch <= '0';
                mem_write <= '0';
                reg_write1 <= '0';
                reg_write2 <= '0';
                reg_read1 <= '0';
                reg_read2 <= '0';
                reg_read3 <= '0';
                stack_read  <= '0';
                stack_write <= '0';
                alu_op <= "0000";
        end case;


end process ;
end ControlunitTraditionalArch;