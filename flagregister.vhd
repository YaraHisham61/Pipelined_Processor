LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- WE --> Write Enable
ENTITY flagregister IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        WE : IN STD_LOGIC;
        inp : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        outp : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END flagregister;

ARCHITECTURE flagarch OF flagregister IS
    SIGNAL enable : STD_LOGIC := '1';
    signal inport:std_logic;
    SIGNAL temp : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    signal init:std_logic:='1';
BEGIN
process (clk)begin
  if(init='1') then
    inport<='0';
    init<='0';
    end if;
    inport<=WE;
end process;

-- inport<='0' when init='1'else '1';
-- init<='0' when init='1'else'0';
    WITH inport SELECT
        temp <= inp WHEN '1',
        temp WHEN OTHERS;
    dffs : FOR i IN 3 DOWNTO 0 GENERATE
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