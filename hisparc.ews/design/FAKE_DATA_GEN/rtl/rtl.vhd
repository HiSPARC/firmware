-- EASE/HDL begin --------------------------------------------------------------
-- 
-- Architecture 'rtl' of entity 'FAKE_DATA_GEN'.
-- 
--------------------------------------------------------------------------------
-- 
-- Copy of the interface declaration:
-- 
--   port(
--     CLK200MHz     : in     std_logic;
--     FAKE_DATA_NEG : out    std_logic_vector(11 downto 0);
--     FAKE_DATA_POS : out    std_logic_vector(11 downto 0);
--     SYSRST        : in     std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of FAKE_DATA_GEN is

signal DATA_PLUS_TWO: std_logic_vector(11 downto 0);
signal FAKE_DATA_POS_TMP: std_logic_vector(11 downto 0);

begin

-- Fake data generator
-- Increment positive fake data by two
  DATA_PLUS_TWO(0) <= '0';
  FAKE_DATA_POS <= FAKE_DATA_POS_TMP;
  
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      DATA_PLUS_TWO(11 downto 1) <= (others => '0');
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      DATA_PLUS_TWO(11 downto 1) <= DATA_PLUS_TWO(11 downto 1) + "00000000001";
    end if;
  end process;

-- Take over DATA_PLUS_TWO on positive edge to get FAKE_DATA_POS
  process(CLK200MHz)
  begin
    if (CLK200MHz'event and CLK200MHz = '1') then
      FAKE_DATA_POS_TMP <= DATA_PLUS_TWO;
    end if;
  end process;

-- Increment FAKE_DATA_POS by one
  process(CLK200MHz)
  begin
    if (CLK200MHz'event and CLK200MHz = '0') then -- negative edge
      FAKE_DATA_NEG <= FAKE_DATA_POS_TMP + "000000000001";
    end if;
  end process;

end architecture rtl ; -- of FAKE_DATA_GEN

