LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY DFF IS
    PORT (
        clk, D, rst, en : IN STD_LOGIC;
        Q : OUT STD_LOGIC);
END DFF;
ARCHITECTURE DFF_arch OF DFF IS
BEGIN
    PROCESS (clk, en, D, rst)
    BEGIN
        IF (en = '0') THEN
            Q <= 'Z';
        ELSIF (rst = '1') THEN
            Q <= '0';
        ELSIF (rising_edge(clk)) THEN
            Q <= D;
        END IF;
    END PROCESS;
END DFF_arch;