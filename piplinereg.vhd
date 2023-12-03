LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- WE --> Write Enable
ENTITY piplinereg IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        inp : IN STD_LOGIC_VECTOR(91 DOWNTO 0);
        outp : OUT STD_LOGIC_VECTOR(91 DOWNTO 0)
    );
END piplinereg;

ARCHITECTURE piplineregarch OF piplinereg IS
    SIGNAL enable : STD_LOGIC := '1';
    SIGNAL temp : STD_LOGIC_VECTOR(91 DOWNTO 0) := (OTHERS => '0');
BEGIN
    temp <= inp;
    dffs : FOR i IN 91 DOWNTO 0 GENERATE
        dff : ENTITY work.DFFF
            PORT MAP(
                clk => clk,
                rst => rst,
                en => enable,
                D => temp(i),
                Q => outp(i)
            );
    END GENERATE;
END ARCHITECTURE;