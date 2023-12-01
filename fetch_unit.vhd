LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fetch_unit IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;

    );
END ENTITY fetch_unit;

ARCHITECTURE rtl OF fetch_unit IS

BEGIN
    PC : ENTITY work.register_32bit
        PORT MAP(
            clk => clk,
            rst => rst,
            WE => '0',
            inp => reg,
            outp => output0
        );
END ARCHITECTURE;