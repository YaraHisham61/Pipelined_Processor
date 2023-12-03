
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity executingUnit is
    port(

    executeWriteback :  out STD_LOGIC_VECTOR(91 DOWNTO 0);

    decodeExecute :  IN STD_LOGIC_VECTOR(91 DOWNTO 0);
    clk,reset:IN std_logic

    );
end entity executingUnit;

architecture executingArch of executingUnit IS
COMPONENT ALU IS
PORT (
    Reg1, Reg2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    Signals : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    CCR : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    clk : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    RegOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    CCROut : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
 END COMPONENT;
 Component mux_2x1 IS Port ( 
    input_0 :  IN STD_LOGIC_VECTOR( 6 DOWNTO 0);
    input_1 : IN STD_LOGIC_VECTOR( 6 DOWNTO 0);
    sel     : in STD_LOGIC;
    outMux  : out STD_LOGIC_VECTOR( 6 DOWNTO 0));
END COMPONENT;
 COMPONENT flagregister IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        WE : IN STD_LOGIC;
        inp : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        outp : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END COMPONENT;
signal aluout :std_logic_vector(31 downto 0);
signal flagout:std_logic_vector(3 downto 0);
signal flagin:std_logic_vector(3 downto 0);

    begin
        A : ALU port map(
            Reg1 => decodeExecute(31 downto 0),
            Reg2 =>decodeExecute(63 downto 32),
            Signals =>decodeExecute(91 downto 88),
            CCR =>flagout,
            clk =>clk,
            reset =>reset,
            RegOut =>aluout,
            CCROut =>flagin);

            F:flagregister port map(
                clk =>clk,
                rst =>reset,
                WE =>'1',
                inp =>flagin,
                outp =>flagout
            );
            executeWriteback <= aluout&decodeExecute(91 downto 32);


    end executingArch;
