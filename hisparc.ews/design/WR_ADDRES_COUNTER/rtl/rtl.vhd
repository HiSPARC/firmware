-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'WR_ADDRES_COUNTER.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'WR_ADDRES_COUNTER' :
-- 
--   port(
--     BEGIN_PRE_TIME_OUT : out    integer range 2020 downto 0;
--     CLK200MHz          : in     std_logic;
--     COINC_TO_END_TIME  : in     std_logic;
--     MASTER             : in     std_logic;
--     RDEN_CH1           : in     std_logic;
--     RDEN_CH2           : in     std_logic;
--     SYSRST             : in     std_logic;
--     TOTAL_TIME         : in     integer range 2000 downto 0;
--     WE                 : out    std_logic;
--     WR_ADDRESS         : out    integer range 2020 downto 0);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of WR_ADDRES_COUNTER is

signal TAKE_DATA: std_logic ; -- RAMs are in write mode when true
signal BEGIN_PRE_TIME: integer range 2020 downto 0 ; -- write address at begin of PRE_TIME 
signal BEGIN_PRE_TIME_MASTER: integer range 2020 downto 0 ;  
signal BEGIN_PRE_TIME_SLAVE: integer range 2020 downto 0 ;  
signal END_POST_TIME: integer range 2020 downto 0 ; -- write address at end of POST_TIME 
signal WR_ADDRESS_TMP: integer range 2020 downto 0 ;  
signal COINC_TO_END_TIME_DEL: std_logic ;
signal RDEN_DEL1: std_logic ;
signal RDEN_DEL2: std_logic ;

begin
  -- Distract BEGIN_PRE_TIME with 10 (50ns) to adjust COINC with the stored event in the FIFO
--  BEGIN_PRE_TIME_MASTER <= END_POST_TIME - TOTAL_TIME - 10 when (END_POST_TIME >= TOTAL_TIME + 10) else (2011 - TOTAL_TIME + END_POST_TIME);
--  BEGIN_PRE_TIME_SLAVE <= END_POST_TIME - TOTAL_TIME - 12 when (END_POST_TIME >= TOTAL_TIME + 12) else (2009 - TOTAL_TIME + END_POST_TIME);
--  BEGIN_PRE_TIME_MASTER <= END_POST_TIME - TOTAL_TIME - 12 when (END_POST_TIME >= TOTAL_TIME + 12) else (2009 - TOTAL_TIME + END_POST_TIME);
--  BEGIN_PRE_TIME_SLAVE <= END_POST_TIME - TOTAL_TIME - 14 when (END_POST_TIME >= TOTAL_TIME + 14) else (2007 - TOTAL_TIME + END_POST_TIME);
  BEGIN_PRE_TIME_MASTER <= END_POST_TIME - TOTAL_TIME - 16 when (END_POST_TIME >= TOTAL_TIME + 16) else (2005 - TOTAL_TIME + END_POST_TIME);
  BEGIN_PRE_TIME_SLAVE <= END_POST_TIME - TOTAL_TIME - 18 when (END_POST_TIME >= TOTAL_TIME + 18) else (2003 - TOTAL_TIME + END_POST_TIME);
  BEGIN_PRE_TIME <= BEGIN_PRE_TIME_MASTER when MASTER = '1' else BEGIN_PRE_TIME_SLAVE;
--  BEGIN_PRE_TIME <= END_POST_TIME - TOTAL_TIME when (END_POST_TIME >= TOTAL_TIME) else (2021 - TOTAL_TIME + END_POST_TIME);
  WR_ADDRESS <= WR_ADDRESS_TMP;
  
  BEGIN_PRE_TIME_OUT <= BEGIN_PRE_TIME;

  
  -- delays
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COINC_TO_END_TIME_DEL <= '0';
      RDEN_DEL1 <= '0';
      RDEN_DEL2 <= '0';
      WE <= '1';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      COINC_TO_END_TIME_DEL <= COINC_TO_END_TIME;
      RDEN_DEL1 <= RDEN_CH1;
      RDEN_DEL2 <= RDEN_DEL1;
      WE <= TAKE_DATA and not RDEN_CH1 and not RDEN_CH2;
    end if;
  end process;  
    
  -- Data taking TAKE_DATA stops at end of COINC_TO_END_TIME and starts again after the FIFO has been readout
  -- and determine END_POST_TIME
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TAKE_DATA <= '1';
      END_POST_TIME <= 0;
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COINC_TO_END_TIME = '0' and COINC_TO_END_TIME_DEL = '1' then -- on a negative edge of COINC_TO_END_TIME
        TAKE_DATA <= '0';
        END_POST_TIME <= WR_ADDRESS_TMP;
      elsif RDEN_DEL1 = '0' and RDEN_DEL2 = '1' then -- on a negative edge of RDEN_CH1
        TAKE_DATA <= '1';
      end if;
    end if;
  end process;  

  -- WR_ADDRESS_TMP
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      WR_ADDRESS_TMP <= 0;
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if TAKE_DATA = '1' then
        if WR_ADDRESS_TMP = 2020 then
          WR_ADDRESS_TMP <= 0;
        else
          WR_ADDRESS_TMP <= WR_ADDRESS_TMP + 1;
        end if;
      else
        WR_ADDRESS_TMP <= WR_ADDRESS_TMP; 
      end if;  
    end if;
  end process;  


end rtl ; -- of WR_ADDRES_COUNTER

