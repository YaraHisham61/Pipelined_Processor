library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux_2x1 is
    Port ( input_0 :  IN STD_LOGIC_VECTOR( 6 DOWNTO 0);
           input_1 : IN STD_LOGIC_VECTOR( 6 DOWNTO 0);
           sel     : in STD_LOGIC;
           outMux  : out STD_LOGIC_VECTOR( 6 DOWNTO 0));
end mux_2x1;

architecture Behavioral of mux_2x1 is
begin
    process(sel, input_0, input_1)
    begin
        if sel = '0' then
            outMux <= input_0;
        else
            outMux <= input_1;
        end if;
    end process;
end Behavioral;
