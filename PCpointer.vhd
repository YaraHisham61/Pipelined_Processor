library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pcPointer is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR(31 downto 0);
           data_out : out STD_LOGIC_VECTOR(31 downto 0));
end pcPointer;

architecture PCBehavioral of pcPointer is
    signal reg : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin
    process (clk, reset)
    begin
        if reset = '1' then
            reg <= (others => '0');
        elsif rising_edge(clk) then        
                reg <= data_in;
        end if;
    end process;

    data_out <= reg;
end PCBehavioral;