LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY decoder IS
PORT(
    clk: IN STD_LOGIC;
    rst: IN STD_LOGIC;
    weRegFile : IN STD_LOGIC;
    weAddress : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    writeValue : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    fetchDecodeReg :  IN STD_LOGIC_VECTOR(91 DOWNTO 0);
    outDecode : OUT STD_LOGIC_VECTOR(91 DOWNTO 0)
);
END ENTITY decoder;

architecture decodeArch of decoder IS
COMPONENT register_file IS
 PORT( clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        RegWrite : IN STD_LOGIC;
        RegDst : IN STD_LOGIC;
        Rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WriteData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Out1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Out2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
 END COMPONENT;

Component mux_2x1 IS Port ( 
    input_0 :  IN STD_LOGIC_VECTOR( 6 DOWNTO 0);
    input_1 : IN STD_LOGIC_VECTOR( 6 DOWNTO 0);
    sel     : in STD_LOGIC;
    outMux  : out STD_LOGIC_VECTOR( 6 DOWNTO 0));
END COMPONENT;

COMPONENT CustomControlunit IS port (
    opcode: in std_logic_vector (6 downto 0);
    mem_read,immediate_value,branch,mem_write,reg_write1,reg_write2,reg_read1,reg_read2,reg_read3,stack_read,stack_write,protectAfree,protectOfree,inOout,inAout: out std_logic;
    clk  : in  std_logic;
    alu_op : out STD_LOGIC_VECTOR(3 downto 0)
  );
END COMPONENT;

Signal out1 :  STD_LOGIC_VECTOR( 31 DOWNTO 0);
Signal out2 :  STD_LOGIC_VECTOR( 31 DOWNTO 0);
Signal outMux :  STD_LOGIC_VECTOR( 6 DOWNTO 0);
Signal outControl :  STD_LOGIC_VECTOR( 18 DOWNTO 0);
Signal outDecoder :  STD_LOGIC_VECTOR( 91 DOWNTO 0);

begin
    r: register_file PORT MAP (
        clk => clk,
        rst => rst,
        RegWrite => weRegFile,
        RegDst => '1',
        Rsrc1 => fetchDecodeReg (5 DOWNTO 3) ,
        Rsrc2 => fetchDecodeReg (8 DOWNTO 6),
        Rdst => weAddress,
        WriteData => writeValue,
        Out1 => out1,
        Out2 => out2

    );
    m: mux_2x1 PORT MAP (
    input_0 => fetchDecodeReg (15 DOWNTO 9),
    input_1 => "0000000",
    sel     => fetchDecodeReg (91),
    outMux  => outMux );

    c: CustomControlunit PORT MAP (
    opcode => fetchDecodeReg (15 DOWNTO 9),
    mem_read => outControl(0),
    immediate_value => outControl(1),
    branch=>outControl(2),
    mem_write => outControl(3),
    reg_write1 => outControl(4),
    reg_write2 => outControl(5),
    reg_read1=> outControl(6),
    reg_read2=> outControl(7),
    reg_read3=> outControl(8),
    stack_read=> outControl(9),
    stack_write=> outControl(10),
    protectAfree=> outControl(11),
    protectOfree=> outControl(12),
    inOout=> outControl(13),
    inAout=>  outControl(14),
    clk  => clk,
    alu_op => outControl(18 DOWNTO 15)
    );
    

outDecoder  <=   outControl&  fetchDecodeReg (8 DOWNTO 0)&out2&  out1 ; 
outDecode <= outDecoder;
end decodeArch;
