LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- WE --> Write Enable
ENTITY register_32bit IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        WE : IN STD_LOGIC;
        inp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        outp : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END register_32bit;

ARCHITECTURE RegisterArch OF register_32bit IS
    SIGNAL enable : STD_LOGIC := '1';
    SIGNAL temp : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN
    WITH WE SELECT
        temp <= inp WHEN '1',
        temp WHEN OTHERS;
    dffs : FOR i IN 31 DOWNTO 0 GENERATE
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