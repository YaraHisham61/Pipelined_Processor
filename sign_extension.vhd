LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY SignExtend IS
    PORT (
        in_num : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        out_num : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END SignExtend;

ARCHITECTURE SignExtendArch OF SignExtend IS
signal signed_16bit : signed(15 downto 0);
signal signed_32bit : signed(31 downto 0);
BEGIN 
    signed_16bit <= signed(in_num);
    signed_32bit <= resize(signed_16bit, signed_32bit'length);
    out_num <= std_logic_vector(signed_32bit);
END SignExtendArch;



