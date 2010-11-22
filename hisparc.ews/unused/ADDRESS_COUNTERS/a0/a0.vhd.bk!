-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'a0' of 'ADDRESS_COUNTERS.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'ADDRESS_COUNTERS' :
-- 
--   port(
--     CLK200MHz         : in     std_logic;
--     CLKRD             : in     std_logic;
--     COINC_TO_END_TIME : in     std_logic;
--     DATA_OUT          : out    std_logic_vector(11 downto 0);
--     DATA_OUT_NEG      : in     std_logic_vector(11 downto 0);
--     DATA_OUT_POS      : in     std_logic_vector(11 downto 0);
--     DATA_READY        : out    std_logic;
--     MASTER            : in     std_logic;
--     RDEN              : in     std_logic;
--     RD_ADDRESS        : out    integer range 2020 downto 0;
--     READOUT_BUSY      : out    std_logic;
--     SYSRST            : in     std_logic;
--     TOTAL_TIME        : in     integer range 2000 downto 0;
--     WE                : out    std_logic;
--     WR_ADDRESS        : out    integer range 2020 downto 0);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture a0 of ADDRESS_COUNTERS is

signal TAKE_DATA: std_logic ; -- RAMs are in write mode when true
signal BEGIN_PRE_TIME: integer range 2020 downto 0 ; -- write address at begin of PRE_TIME 
signal BEGIN_PRE_TIME_MASTER: integer range 2020 downto 0 ;  
signal BEGIN_PRE_TIME_SLAVE: integer range 2020 downto 0 ;  
signal END_POST_TIME: integer range 2020 downto 0 ; -- write address at end of POST_TIME 
signal WR_ADDRESS_TMP: integer range 2020 downto 0 ;  
signal RD_ADDRESS_TMP: integer range 2020 downto 0 ;  
signal POS_NEG_PHASE: std_logic ; -- help signal to determine the positive or negative RAM; high means positive
signal COINC_TO_END_TIME_DEL: std_logic ;
signal READOUT_BUSY_DEL1: std_logic ;
signal READOUT_BUSY_DEL2: std_logic ;
signal READOUT_BUSY_TMP: std_logic ;
signal DATA_READY_PRE: std_logic ;
signal DATA_READY_TMP: std_logic ;
signal DATA_OUT_TMP: std_logic_vector(11 downto 0);



begin
  -- Distract BEGIN_PRE_TIME with 10 (50ns) to adjust COINC with the stored event in the FIFO
  BEGIN_PRE_TIME_MASTER <= END_POST_TIME - TOTAL_TIME - 10 when (END_POST_TIME >= TOTAL_TIME + 10) else (2009 - TOTAL_TIME + END_POST_TIME);
  BEGIN_PRE_TIME_SLAVE <= END_POST_TIME - TOTAL_TIME - 12 when (END_POST_TIME >= TOTAL_TIME + 12) else (2007 - TOTAL_TIME + END_POST_TIME);
  BEGIN_PRE_TIME <= BEGIN_PRE_TIME_MASTER when MASTER = '1' else BEGIN_PRE_TIME_SLAVE;
--  BEGIN_PRE_TIME <= END_POST_TIME - TOTAL_TIME when (END_POST_TIME >= TOTAL_TIME) else (2019 - TOTAL_TIME + END_POST_TIME);
  WR_ADDRESS <= WR_ADDRESS_TMP;
  RD_ADDRESS <= RD_ADDRESS_TMP;
  DATA_READY <= DATA_READY_TMP;
  
  
  -- delays
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COINC_TO_END_TIME_DEL <= '0';
      READOUT_BUSY_DEL1 <= '0';
      READOUT_BUSY_DEL2 <= '0';
      WE <= '1';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      COINC_TO_END_TIME_DEL <= COINC_TO_END_TIME;
      READOUT_BUSY_DEL1 <= READOUT_BUSY_TMP;
      READOUT_BUSY_DEL2 <= READOUT_BUSY_DEL1;
      WE <= TAKE_DATA;
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
      elsif READOUT_BUSY_DEL1 = '0' and READOUT_BUSY_DEL2 = '1' then -- on a negative edge of READOUT_BUSY
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

  -- DATA_READY is valid when the FIFOs are not taking data
  -- not TAKE_DATA is synchronized with the readoutclock
  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      DATA_READY_TMP <= '0';
      DATA_READY_PRE <= '0';
    elsif (CLKRD'event and CLKRD = '1') then
      DATA_READY_PRE <= not TAKE_DATA;
      DATA_READY_TMP <= DATA_READY_PRE;
      READOUT_BUSY <= READOUT_BUSY_TMP;
    end if;
  end process;  

  -- RD_ADDRESS and toggle outputbus
  process(CLKRD)
  begin
    if (CLKRD'event and CLKRD = '1') then
      if RDEN = '1' then
        if POS_NEG_PHASE = '1' then
          RD_ADDRESS_TMP <= RD_ADDRESS_TMP;
        else
          if RD_ADDRESS_TMP = 2020 then
            RD_ADDRESS_TMP <= 0;
          else
            RD_ADDRESS_TMP <= RD_ADDRESS_TMP + 1;
          end if;
        end if;
        POS_NEG_PHASE <= not POS_NEG_PHASE;
        READOUT_BUSY_TMP <= '1';          
      else
        RD_ADDRESS_TMP <= BEGIN_PRE_TIME;
        POS_NEG_PHASE <= '1'; 
        READOUT_BUSY_TMP <= '0';
      end if;  
    end if;
  end process;  
  
  DATA_OUT_TMP <= DATA_OUT_POS  when POS_NEG_PHASE = '1' else DATA_OUT_NEG;
  DATA_OUT <= DATA_OUT_TMP when READOUT_BUSY_TMP = '1' else "000000000000";

end architecture a0 ; -- of ADDRESS_COUNTERS

