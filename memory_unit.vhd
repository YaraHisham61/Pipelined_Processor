
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
  use IEEE.STD_LOGIC_ARITH.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;
  --! Add the flags to the MSB of value or from (19 DOWNTO 16)

entity memory_unit is
  port (
    clk          : in  STD_LOGIC;
    rst          : in  STD_LOGIC;
    memWrite     : in  STD_LOGIC;
    memRead      : in  STD_LOGIC;
    stackWrite   : in  STD_LOGIC;
    stackRead    : in  STD_LOGIC;
    protectOfree : in  STD_LOGIC;
    protectAfree : in  STD_LOGIC;
    branching    : in  STD_LOGIC;
    address      : in  STD_LOGIC_VECTOR(31 downto 0);
    value        : in  STD_LOGIC_VECTOR(31 downto 0);
    outMemory    : out STD_LOGIC_VECTOR(63 downto 0)
  );
end entity;

architecture memoryBehaviour of memory_unit is
  signal memoryOut : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  --* Initializing input of sp by 12 bit of ones(the end of the memo)
  signal stackIn      : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000111111111101";
  signal stackOut     : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal addressValue : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
begin

  stackIn <= stackOut + 2 when stackRead = '1' and memRead = '1' else
             stackOut - 2 when (stackWrite = '1' and memWrite = '1') or branching = '1' else
             stackIn;
  addressValue <= stackOut(11 downto 0) + 2 when stackRead = '1' and memRead = '1' else
                  stackOut(11 downto 0)     when (stackWrite = '1' and memWrite = '1') or branching = '1' else
                  address(11 downto 0)      when not (stackWrite = '1' and memWrite = '1') and not (stackRead = '1' and memRead = '1') and not branching = '1' else
                  addressValue;

  DM: entity work.data_memory
    port map (
      clk       => clk,
      address   => addressValue,
      datain1   => value(31 downto 16),
      datain2   => value(15 downto 0),
      dataout   => memoryOut,
      re        => memRead,
      se        => protectOfree,
      ss        => protectAfree,
      we        => memWrite
    );
  with memWrite or memRead or stackWrite or stackRead select
    outMemory <= value & memoryOut when '1',
                 address & value   when others;
  SP: entity work.stack_pointer
    port map (
      clk  => clk,
      rst  => rst,
      WE   => '1',
      inp  => stackIn,
      outp => stackOut
    );

  -- process (all)
  -- begin
  --   if (stackWrite = '1' and memWrite = '1') or branching = '1' then
  --     addressValue <= stackOut(11 downto 0);
  --     stackIn <= stackOut - 2;
  --   end if;
  --   if not (stackWrite = '1' and memWrite = '1') and not (stackRead = '1' and memRead = '1') and not branching = '1' then
  --     addressValue <= address(11 downto 0);
  --   end if;
  --   if stackRead = '1' and memRead = '1' then
  --     stackIn <= stackOut + 2;
  --     addressValue <= stackOut(11 downto 0);
  --   end if;
  -- end process;
end architecture;
