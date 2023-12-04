LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY stack_pointer IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        WE : IN STD_LOGIC;
        inp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        outp : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END stack_pointer;

ARCHITECTURE stackBehavioural OF stack_pointer IS
    SIGNAL enable : STD_LOGIC := '1';
    SIGNAL temp : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL inpTemp : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000111111111101";
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF rst = '1' THEN
                outp <= "00000000000000000000111111111101";
            END IF;
            IF (rst = '0' AND we = '1') THEN
                outp <= inp;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;