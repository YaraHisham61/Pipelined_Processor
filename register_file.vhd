LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- use IEEE.STD_LOGIC_UNSIGNED.all;

PACKAGE registerPkg IS
    TYPE memory_array IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR;
END PACKAGE;
USE work.iipkg.ALL;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;
ENTITY register_file IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        RegWrite : IN STD_LOGIC;
        RegDst : IN STD_LOGIC;
        Rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WriteData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Out1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Out2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END register_file;

ARCHITECTURE Behavioral OF register_file IS
    SIGNAL init : STD_LOGIC := '1';
    SIGNAL enable0 : STD_LOGIC := '1';
    SIGNAL enable1 : STD_LOGIC := '1';
    SIGNAL enable2 : STD_LOGIC := '1';
    SIGNAL enable3 : STD_LOGIC := '1';
    SIGNAL enable4 : STD_LOGIC := '1';
    SIGNAL enable5 : STD_LOGIC := '1';
    SIGNAL enable6 : STD_LOGIC := '1';
    SIGNAL enable7 : STD_LOGIC := '1';
    SIGNAL reg0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reg1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reg2 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reg3 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reg4 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reg5 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reg6 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reg7 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL output0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL output1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL output2 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL output3 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL output4 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL output5 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL output6 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL output7 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL writeAddress : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');

BEGIN

    R0 : ENTITY work.register_32bit
        PORT MAP(
            clk => clk,
            rst => rst,
            WE => enable0,
            inp => reg0,
            outp => output0
        );
    R1 : ENTITY work.register_32bit
        PORT MAP(
            clk => clk,
            rst => rst,
            WE => enable1,
            inp => reg1,
            outp => output1
        );
    R2 : ENTITY work.register_32bit
        PORT MAP(
            clk => clk,
            rst => rst,
            WE => enable2,
            inp => reg2,
            outp => output2
        );
    R3 : ENTITY work.register_32bit
        PORT MAP(
            clk => clk,
            rst => rst,
            WE => enable3,
            inp => reg3,
            outp => output3
        );
    R4 : ENTITY work.register_32bit
        PORT MAP(
            clk => clk,
            rst => rst,
            WE => enable4,
            inp => reg4,
            outp => output4
        );
    R5 : ENTITY work.register_32bit
        PORT MAP(
            clk => clk,
            rst => rst,
            WE => enable5,
            inp => reg5,
            outp => output5
        );
    R6 : ENTITY work.register_32bit
        PORT MAP(
            clk => clk,
            rst => rst,
            WE => enable6,
            inp => reg6,
            outp => output6
        );
    R7 : ENTITY work.register_32bit
        PORT MAP(
            clk => clk,
            rst => rst,
            WE => enable7,
            inp => reg7,
            outp => output7
        );

    WITH Rsrc1 SELECT
        Out1 <= output0 WHEN "000",
        output1 WHEN "001",
        output2 WHEN "010",
        output3 WHEN "011",
        output4 WHEN "100",
        output5 WHEN "101",
        output6 WHEN "110",
        output7 WHEN OTHERS;
    WITH Rsrc2 SELECT
        Out2 <= output0 WHEN "000",
        output1 WHEN "001",
        output2 WHEN "010",
        output3 WHEN "011",
        output4 WHEN "100",
        output5 WHEN "101",
        output6 WHEN "110",
        output7 WHEN OTHERS;
    WITH RegDst SELECT
        writeAddress <= Rdst WHEN '1',
        Rsrc2 WHEN OTHERS;
    sync : PROCESS (clk)
        FILE register_file : text OPEN READ_MODE IS "registers.txt";
        VARIABLE file_line : line;
        VARIABLE temp_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    BEGIN
        IF (init = '1') THEN
            IF NOT endfile(register_file) THEN
                FOR i IN 0 TO 7 LOOP
                    readline(register_file, file_line);
                    read(file_line, temp_data);
                    CASE i IS
                        WHEN 0 =>
                            reg0 <= temp_data;
                        WHEN 1 =>
                            reg1 <= temp_data;
                        WHEN 2 =>
                            reg2 <= temp_data;
                        WHEN 3 =>
                            reg3 <= temp_data;
                        WHEN 4 =>
                            reg4 <= temp_data;
                        WHEN 5 =>
                            reg5 <= temp_data;
                        WHEN 6 =>
                            reg6 <= temp_data;
                        WHEN 7 =>
                            reg7 <= temp_data;
                    END CASE;
                END LOOP;
                init <= '0';
            END IF;
            file_close(register_file); -- Move file closing outside the loop
        END IF;
        IF falling_edge(clk) THEN
            enable0 <= '0';
            enable1 <= '0';
            enable2 <= '0';
            enable3 <= '0';
            enable4 <= '0';
            enable5 <= '0';
            enable6 <= '0';
            enable7 <= '0';
            IF (RegWrite = '1') THEN
                CASE writeAddress IS
                    WHEN "000" =>
                        enable0 <= '1';
                        reg0 <= WriteData;
                    WHEN "001" =>
                        enable1 <= '1';
                        reg1 <= WriteData;
                    WHEN "010" =>
                        enable2 <= '1';
                        reg2 <= WriteData;
                    WHEN "011" =>
                        enable3 <= '1';
                        reg3 <= WriteData;
                    WHEN "100" =>
                        enable4 <= '1';
                        reg4 <= WriteData;
                    WHEN "101" =>
                        enable5 <= '1';
                        reg5 <= WriteData;
                    WHEN "110" =>
                        enable6 <= '1';
                        reg6 <= WriteData;
                    WHEN OTHERS =>
                        enable7 <= '1';
                        reg7 <= WriteData;
                END CASE;
            END IF;
            IF (RegWrite = '0') THEN
                CASE Rsrc1 IS
                    WHEN "000" =>
                      
                        reg0 <= WriteData;
                    WHEN "001" =>
                       
                        reg1 <= WriteData;
                    WHEN "010" =>
                        
                        reg2 <= WriteData;
                    WHEN "011" =>
                        
                        reg3 <= WriteData;
                    WHEN "100" =>
                        
                        reg4 <= WriteData;
                    WHEN "101" =>
                       
                        reg5 <= WriteData;
                    WHEN "110" =>
                       
                        reg6 <= WriteData;
                    WHEN OTHERS =>
                      
                        reg7 <= WriteData;
                END CASE;
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE;