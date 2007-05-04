-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'RAM_SELECT_PLUS_EXTRA.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'RAM_SELECT_PLUS_EXTRA' :
-- 
--   port(
--     CLK200MHz          : in     std_logic;
--     CLKRD              : in     std_logic;
--     COINC_TO_END_TIME  : in     std_logic;
--     COINC_TO_END_TIME1 : out    std_logic;
--     COINC_TO_END_TIME2 : out    std_logic;
--     CTD_IN             : in     std_logic_vector(31 downto 0);
--     CTD_OUT            : out    std_logic_vector(31 downto 0);
--     DATA_OUT           : out    std_logic_vector(11 downto 0);
--     DATA_OUT1          : in     std_logic_vector(11 downto 0);
--     DATA_OUT2          : in     std_logic_vector(11 downto 0);
--     DATA_READY         : out    std_logic;
--     DATA_READY1        : in     std_logic;
--     DATA_READY2        : in     std_logic;
--     DATA_VALID         : out    std_logic;
--     GPS_TS_IN          : in     std_logic_vector(55 downto 0);
--     GPS_TS_OUT         : out    std_logic_vector(55 downto 0);
--     RDEN               : in     std_logic;
--     RDEN1              : out    std_logic;
--     RDEN2              : out    std_logic;
--     READOUT_BUSY1      : in     std_logic;
--     READOUT_BUSY2      : in     std_logic;
--     SYSRST             : in     std_logic;
--     TRIGGER_PATTERN    : out    std_logic_vector(15 downto 0);
--     TRIGGER_PATTERN_IN : in     std_logic_vector(15 downto 0));
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of RAM_SELECT_PLUS_EXTRA is
 
signal READY: std_logic_vector(1 downto 0);  
signal DATA_READY1_DEL: std_logic;  
signal DATA_READY2_DEL: std_logic;  
signal COINC_TO_END_TIME1_TMP: std_logic;  
signal COINC_TO_END_TIME2_TMP: std_logic;  
signal TRIGGER_PATTERN_TIME1: std_logic_vector(15 downto 0);  
signal TRIGGER_PATTERN_TIME2: std_logic_vector(15 downto 0);  
signal CTD_TIME1: std_logic_vector(31 downto 0);  
signal CTD_TIME2: std_logic_vector(31 downto 0);  
signal GPS_TS_TIME1: std_logic_vector(55 downto 0);  
signal GPS_TS_TIME2: std_logic_vector(55 downto 0);  
signal DATA_READY2: std_logic;  

begin
  
  -- Data is valid at the start of BUSY. Readout has to be done till the totaltime is reached 
  -- BUSY is longer true than the totaltime.
--  DATA_VALID <= READOUT_BUSY1 or READOUT_BUSY2;
  DATA_VALID <= READOUT_BUSY1;
  DATA_READY2 <= '0';

  process(CLK200MHz)
  begin
    if (CLK200MHz'event and CLK200MHz = '1') then
      COINC_TO_END_TIME1 <= COINC_TO_END_TIME1_TMP;
      COINC_TO_END_TIME2 <= COINC_TO_END_TIME2_TMP;
    end if;
  end process;  

  -- delay's
  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      DATA_READY1_DEL <= '0';
      DATA_READY2_DEL <= '0';
    elsif (CLKRD'event and CLKRD = '1') then
      DATA_READY1_DEL <= DATA_READY1;
      DATA_READY2_DEL <= DATA_READY2;
    end if;
  end process;  
  
  -- Determine which channel has to be readout
  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      READY <= "00";
    elsif (CLKRD'event and CLKRD = '1') then
    
      -- if DATA_READY2 = '0' and an upgoing edge of DATA_READY1
      -- or
      -- if DATA_READY1 = '1' and a downgoing edge of DATA_READY2
      -- Select channel 1
      if (DATA_READY2 = '0' and DATA_READY1 = '1' and DATA_READY1_DEL = '0') or
         (DATA_READY1 = '1' and DATA_READY2 = '0' and DATA_READY2_DEL = '1') then
        READY <= "01";
        
      -- if DATA_READY1 = '0' and an upgoing edge of DATA_READY2
      -- or
      -- if DATA_READY2 = '1' and a downgoing edge of DATA_READY1
      -- Select channel 2
      elsif (DATA_READY1 = '0' and DATA_READY2 = '1' and DATA_READY2_DEL = '0') or
            (DATA_READY2 = '1' and DATA_READY1 = '0' and DATA_READY1_DEL = '1') then
        READY <= "10";
        
      -- if DATA_READY1 = '0' and a downgoing edge of DATA_READY2
      -- or
      -- if DATA_READY2 = '0' and a downgoing edge of DATA_READY1
      -- Deselect channels
      elsif (DATA_READY1 = '0' and DATA_READY2 = '0' and DATA_READY2_DEL = '1') or
            (DATA_READY2 = '0' and DATA_READY1 = '0' and DATA_READY1_DEL = '1') then
        READY <= "00";
      end if;
    end if;
  end process; 


  -- Determine which channel has to be readout
  process(READY,DATA_OUT1,DATA_READY1,DATA_OUT2,DATA_READY2,RDEN,COINC_TO_END_TIME,TRIGGER_PATTERN_TIME1,GPS_TS_TIME1,CTD_TIME1,TRIGGER_PATTERN_TIME2,GPS_TS_TIME2,CTD_TIME2)
  begin
    case(READY) is
      when "00" => DATA_OUT <= DATA_OUT1;        
                   DATA_READY <= DATA_READY1;
                   RDEN1 <= RDEN;
                   RDEN2 <= '0';
                   COINC_TO_END_TIME1_TMP <= COINC_TO_END_TIME;
                   COINC_TO_END_TIME2_TMP <= '0';
                   TRIGGER_PATTERN <= TRIGGER_PATTERN_TIME1;
                   GPS_TS_OUT <= GPS_TS_TIME1;
                   CTD_OUT <= CTD_TIME1;
      when "01" => DATA_OUT <= DATA_OUT1;        
                   DATA_READY <= DATA_READY1;
                   RDEN1 <= RDEN;
                   RDEN2 <= '0';
                   COINC_TO_END_TIME1_TMP <= '0';
                   COINC_TO_END_TIME2_TMP <= COINC_TO_END_TIME;
                   TRIGGER_PATTERN <= TRIGGER_PATTERN_TIME1;
                   GPS_TS_OUT <= GPS_TS_TIME1;
                   CTD_OUT <= CTD_TIME1;
      when "10" => DATA_OUT <= DATA_OUT2;        
                   DATA_READY <= DATA_READY2;
                   RDEN1 <= '0';
                   RDEN2 <= RDEN;
                   COINC_TO_END_TIME1_TMP <= COINC_TO_END_TIME;
                   COINC_TO_END_TIME2_TMP <= '0';
                   TRIGGER_PATTERN <= TRIGGER_PATTERN_TIME2;
                   GPS_TS_OUT <= GPS_TS_TIME2;
                   CTD_OUT <= CTD_TIME2;
      when "11" => DATA_OUT <= DATA_OUT1; -- never assigned        
                   DATA_READY <= DATA_READY1;
                   RDEN1 <= RDEN;
                   RDEN2 <= '0';
                   COINC_TO_END_TIME1_TMP <= COINC_TO_END_TIME;
                   COINC_TO_END_TIME2_TMP <= '0';
                   TRIGGER_PATTERN <= TRIGGER_PATTERN_TIME1;
                   GPS_TS_OUT <= GPS_TS_TIME1;
                   CTD_OUT <= CTD_TIME1;
    end case;
  end process; 

  -- Latch TRIGGER_PATTERN on positive edge of COINC_TO_END_TIME1
  process(COINC_TO_END_TIME1_TMP,SYSRST)
  begin
    if SYSRST = '1' then
      TRIGGER_PATTERN_TIME1 <= "0000000000000000";
    elsif (COINC_TO_END_TIME1_TMP'event and COINC_TO_END_TIME1_TMP = '1') then
--      if COINC_TO_END_TIME1_TMP = '1' and COINC_TO_END_TIME1_DEL = '0' then
        TRIGGER_PATTERN_TIME1 <= TRIGGER_PATTERN_IN;
--	  end if;        
    end if;
  end process;  

  -- Latch TRIGGER_PATTERN on positive edge of COINC_TO_END_TIME2
  process(COINC_TO_END_TIME2_TMP,SYSRST)
  begin
    if SYSRST = '1' then
      TRIGGER_PATTERN_TIME2 <= "0000000000000000";
    elsif (COINC_TO_END_TIME2_TMP'event and COINC_TO_END_TIME2_TMP = '1') then
--      if COINC_TO_END_TIME2_TMP = '1' and COINC_TO_END_TIME2_DEL = '0' then
        TRIGGER_PATTERN_TIME2 <= TRIGGER_PATTERN_IN;
--	  end if;        
    end if;
  end process;  

  -- Latch GPS_TS on positive edge of COINC_TO_END_TIME1
  process(COINC_TO_END_TIME1_TMP,SYSRST)
  begin
    if SYSRST = '1' then
      GPS_TS_TIME1 <= "00000000000000000000000000000000000000000000000000000000";
    elsif (COINC_TO_END_TIME1_TMP'event and COINC_TO_END_TIME1_TMP = '1') then
--      if COINC_TO_END_TIME1_TMP = '1' and COINC_TO_END_TIME1_DEL = '0' then
        GPS_TS_TIME1 <= GPS_TS_IN;
--	  end if;        
    end if;
  end process;  

  -- Latch GPS_TS on positive edge of COINC_TO_END_TIME2
  process(COINC_TO_END_TIME2_TMP,SYSRST)
  begin
    if SYSRST = '1' then
      GPS_TS_TIME2 <= "00000000000000000000000000000000000000000000000000000000";
    elsif (COINC_TO_END_TIME2_TMP'event and COINC_TO_END_TIME2_TMP = '1') then
--      if COINC_TO_END_TIME2_TMP = '1' and COINC_TO_END_TIME2_DEL = '0' then
        GPS_TS_TIME2 <= GPS_TS_IN;
--	  end if;        
    end if;
  end process;  

  -- Latch CTD on positive edge of COINC_TO_END_TIME1
  process(COINC_TO_END_TIME1_TMP,SYSRST)
  begin
    if SYSRST = '1' then
      CTD_TIME1 <= "00000000000000000000000000000000";
    elsif (COINC_TO_END_TIME1_TMP'event and COINC_TO_END_TIME1_TMP = '1') then
--      if COINC_TO_END_TIME1_TMP = '1' and COINC_TO_END_TIME1_DEL = '0' then
        CTD_TIME1 <= CTD_IN;
--	  end if;        
    end if;
  end process;  

  -- Latch CTD on positive edge of COINC_TO_END_TIME2
  process(COINC_TO_END_TIME2_TMP,SYSRST)
  begin
    if SYSRST = '1' then
      CTD_TIME2 <= "00000000000000000000000000000000";
    elsif (COINC_TO_END_TIME2_TMP'event and COINC_TO_END_TIME2_TMP = '1') then
--      if COINC_TO_END_TIME2_TMP = '1' and COINC_TO_END_TIME2_DEL = '0' then
        CTD_TIME2 <= CTD_IN;
--	  end if;        
    end if;
  end process;  

end rtl ; -- of RAM_SELECT_PLUS_EXTRA

