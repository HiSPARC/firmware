-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'a0' of 'WINDOW_MAKER.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'WINDOW_MAKER' :
-- 
--   port(
--     CLK200MHz         : in     std_logic;
--     COINC_TO_END_TIME : out    std_logic;
--     END_OF_COINC      : in     std_logic;
--     POST_TIME         : in     integer range 1600 downto 0;
--     SYSRST            : in     std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture a0 of WINDOW_MAKER is

signal COINC_DEL1: std_logic ; -- COINC after one clockcycle  
signal COINC_TO_END_TIME_TMP: std_logic ; -- Time from negative edge of COINC to end of POST_TIME  
signal COINC_TO_END_TIME_CNT: integer range 1600 downto 0 ; -- Counter from COINC to end of POST_TIME

begin
  
  COINC_TO_END_TIME <= COINC_TO_END_TIME_TMP;
  
  -- COINC delay
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COINC_DEL1 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      COINC_DEL1 <= END_OF_COINC;
    end if;
  end process;  

  -- COINC_TO_END_TIME_TMP starts at a negative edge of COINC and stops when COINC_TO_END_TIME_CNT reaches POST_TIME
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COINC_TO_END_TIME_TMP <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if END_OF_COINC = '1' and COINC_DEL1 = '0' then -- on a positive edge of END_OF_COINC
        COINC_TO_END_TIME_TMP <= '1'; 
      elsif COINC_TO_END_TIME_CNT > POST_TIME then
        COINC_TO_END_TIME_TMP <= '0';
      end if;
    end if;
  end process;  

  -- COINC_TO_END_TIME_CNT starts when COINC_TO_END_TIME_TMP = '1'
  -- and counts as long COINC_TO_END_TIME_TMP is valid 
  -- and resets when COINC_TO_END_TIME_TMP = '0'
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COINC_TO_END_TIME_CNT <= 0;
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COINC_TO_END_TIME_TMP = '1' then 
        COINC_TO_END_TIME_CNT <= COINC_TO_END_TIME_CNT + 1;
      else
        COINC_TO_END_TIME_CNT <= 0;
      end if;
    end if;
  end process;  
 
end architecture a0 ; -- of WINDOW_MAKER

