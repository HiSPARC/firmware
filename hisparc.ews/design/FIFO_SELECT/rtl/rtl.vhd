-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'FIFO_SELECT.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'FIFO_SELECT' :
-- 
--   port(
--     BLOCK_COINC            : out    std_logic;
--     CLK200MHz              : in     std_logic;
--     CLKRD                  : in     std_logic;
--     COINC_TO_END_TIME      : in     std_logic;
--     COINC_TO_END_TIME1_CH1 : out    std_logic;
--     COINC_TO_END_TIME1_CH2 : out    std_logic;
--     COINC_TO_END_TIME2_CH1 : out    std_logic;
--     COINC_TO_END_TIME2_CH2 : out    std_logic;
--     CTD_IN                 : in     std_logic_vector(31 downto 0);
--     CTD_OUT                : out    std_logic_vector(31 downto 0);
--     DATA_OUT1_CH1          : in     std_logic_vector(11 downto 0);
--     DATA_OUT1_CH2          : in     std_logic_vector(11 downto 0);
--     DATA_OUT2_CH1          : in     std_logic_vector(11 downto 0);
--     DATA_OUT2_CH2          : in     std_logic_vector(11 downto 0);
--     DATA_OUT_CH1           : out    std_logic_vector(11 downto 0);
--     DATA_OUT_CH2           : out    std_logic_vector(11 downto 0);
--     DATA_READY1_CH1        : in     std_logic;
--     DATA_READY1_CH2        : in     std_logic;
--     DATA_READY2_CH1        : in     std_logic;
--     DATA_READY2_CH2        : in     std_logic;
--     DATA_READY_CH1         : out    std_logic;
--     DATA_READY_CH2         : out    std_logic;
--     DATA_VALID_CH1         : out    std_logic;
--     DATA_VALID_CH2         : out    std_logic;
--     GPS_TS_IN              : in     std_logic_vector(55 downto 0);
--     GPS_TS_OUT             : out    std_logic_vector(55 downto 0);
--     RDEN1_CH1              : out    std_logic;
--     RDEN1_CH2              : out    std_logic;
--     RDEN2_CH1              : out    std_logic;
--     RDEN2_CH2              : out    std_logic;
--     RDEN_CH1               : in     std_logic;
--     RDEN_CH2               : in     std_logic;
--     READOUT_BUSY1_CH1      : in     std_logic;
--     READOUT_BUSY1_CH2      : in     std_logic;
--     READOUT_BUSY2_CH1      : in     std_logic;
--     READOUT_BUSY2_CH2      : in     std_logic;
--     SYSRST                 : in     std_logic;
--     TRIGGER_PATTERN        : out    std_logic_vector(15 downto 0);
--     TRIGGER_PATTERN_IN     : in     std_logic_vector(15 downto 0));
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of FIFO_SELECT is

signal COINC_TO_END_TIME1_TMP: std_logic;  
signal COINC_TO_END_TIME2_TMP: std_logic;  
signal COINC_TO_END_TIME1_TMP_DEL: std_logic;  
signal COINC_TO_END_TIME2_TMP_DEL: std_logic;  
signal COINC_SWITCH: std_logic_vector(1 downto 0); -- bit0 is DATA_READY1 and bit1 is DATA_READY2
signal DATA_READY_FIFO1: std_logic;  
signal DATA_READY_FIFO2: std_logic;  
signal READY: std_logic_vector(1 downto 0); -- bit0 selects FIFO1 and bit1 selects FIFO2
signal RDEN_CH2_DEL1: std_logic;  
signal TRIGGER_PATTERN_TIME1: std_logic_vector(15 downto 0);  
signal TRIGGER_PATTERN_TIME2: std_logic_vector(15 downto 0);  
signal CTD_TIME1: std_logic_vector(31 downto 0);  
signal CTD_TIME2: std_logic_vector(31 downto 0);  
signal GPS_TS_TIME1: std_logic_vector(55 downto 0);  
signal GPS_TS_TIME2: std_logic_vector(55 downto 0);  


begin


  -- DATA_READY_FIFO is true when there is data in both fifo's of the channels made on the same COINC
  DATA_READY_FIFO1 <= DATA_READY1_CH1 and DATA_READY1_CH2;
  DATA_READY_FIFO2 <= DATA_READY2_CH1 and DATA_READY2_CH2;

  -- BLOCK_COINC if FIFO's1 and FIFO's2 are full
  BLOCK_COINC <= ((DATA_READY1_CH1 or READOUT_BUSY1_CH1) and (DATA_READY2_CH1 or READOUT_BUSY2_CH1)) 
              or ((DATA_READY1_CH2 or READOUT_BUSY1_CH2) and (DATA_READY2_CH2 or READOUT_BUSY2_CH2));

  COINC_SWITCH(0) <= DATA_READY1_CH1 or DATA_READY1_CH2;
  COINC_SWITCH(1) <= DATA_READY2_CH1 or DATA_READY2_CH2;

  -- COINC Multiplexer
  process(COINC_SWITCH,COINC_TO_END_TIME)
  begin
    case(COINC_SWITCH) is
      when "00" => COINC_TO_END_TIME1_TMP <= COINC_TO_END_TIME;
                   COINC_TO_END_TIME2_TMP <= '0';
      when "01" => COINC_TO_END_TIME1_TMP <= '0';       
                   COINC_TO_END_TIME2_TMP <= COINC_TO_END_TIME;
      when "10" => COINC_TO_END_TIME1_TMP <= COINC_TO_END_TIME;        
                   COINC_TO_END_TIME2_TMP <= '0';
      when "11" => COINC_TO_END_TIME1_TMP <= '0';        
                   COINC_TO_END_TIME2_TMP <= '0';
      when others =>
    end case;
  end process; 


  -- This is done to please the fitter for timing requirements
  process(CLK200MHz)
  begin
    if (CLK200MHz'event and CLK200MHz = '1') then
      COINC_TO_END_TIME1_CH1 <= COINC_TO_END_TIME1_TMP;
      COINC_TO_END_TIME2_CH1 <= COINC_TO_END_TIME2_TMP;
      COINC_TO_END_TIME1_CH2 <= COINC_TO_END_TIME1_TMP;
      COINC_TO_END_TIME2_CH2 <= COINC_TO_END_TIME2_TMP;
      COINC_TO_END_TIME1_TMP_DEL <= COINC_TO_END_TIME1_TMP;
      COINC_TO_END_TIME2_TMP_DEL <= COINC_TO_END_TIME2_TMP;
    end if;
  end process;  

  -- delay's
  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      RDEN_CH2_DEL1 <= '0';
    elsif (CLKRD'event and CLKRD = '1') then
      RDEN_CH2_DEL1 <= RDEN_CH2;
    end if;
  end process;  
 
  -- Determine which channel has to be readout
  -- A event in both FIFO's of the channels have been written to the next FIFO at the end of RDEN_CH2
  -- Thus at the end of RDEN_CH2 a new situation must be checked
  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      READY <= "00"; -- default state
    elsif (CLKRD'event and CLKRD = '1') then
      if (READY = "11") or (RDEN_CH2 = '0' and RDEN_CH2_DEL1 = '1') then -- clear READY
        READY <= "00"; -- default state
      elsif READY(0) = '1' or READY(1) = '1' then -- Latch READY if there is data in one of the FIFO's
        READY <= READY;
      else -- if there is no data the FIFO's
        READY(0) <= DATA_READY_FIFO1;
        READY(1) <= DATA_READY_FIFO2;
      end if;
    end if;
  end process; 

  -- Multiplexer
  process(READY,DATA_OUT1_CH1,DATA_OUT2_CH1,DATA_OUT1_CH2,DATA_OUT2_CH2,
          DATA_READY1_CH1,DATA_READY2_CH1,DATA_READY1_CH2,DATA_READY2_CH2,
          RDEN_CH1,RDEN_CH2,
          READOUT_BUSY1_CH1,READOUT_BUSY2_CH1,READOUT_BUSY1_CH2,READOUT_BUSY2_CH2,
          TRIGGER_PATTERN_TIME1,GPS_TS_TIME1,CTD_TIME1,TRIGGER_PATTERN_TIME2,GPS_TS_TIME2,CTD_TIME2)
  begin
    case(READY) is
      when "00" => DATA_OUT_CH1 <= DATA_OUT1_CH1;        
                   DATA_READY_CH1 <= '0';
                   RDEN1_CH1 <= '0';
                   RDEN2_CH1 <= '0';
--                   COINC_TO_END_TIME1_TMP <= COINC_TO_END_TIME;
--                   COINC_TO_END_TIME2_TMP <= '0';
                   DATA_OUT_CH2 <= DATA_OUT1_CH2;        
                   DATA_READY_CH2 <= '0';
                   DATA_VALID_CH1 <= '0';
                   DATA_VALID_CH2 <= '0';
                   RDEN1_CH2 <= '0';
                   RDEN2_CH2 <= '0';
                   TRIGGER_PATTERN <= TRIGGER_PATTERN_TIME1;
                   GPS_TS_OUT <= GPS_TS_TIME1;
                   CTD_OUT <= CTD_TIME1;
      when "01" => DATA_OUT_CH1 <= DATA_OUT1_CH1;        
                   DATA_READY_CH1 <= DATA_READY1_CH1;
                   RDEN1_CH1 <= RDEN_CH1;
                   RDEN2_CH1 <= '0';
--                   COINC_TO_END_TIME1_TMP <= '0';
--                   COINC_TO_END_TIME2_TMP <= COINC_TO_END_TIME;
                   DATA_OUT_CH2 <= DATA_OUT1_CH2;        
                   DATA_READY_CH2 <= DATA_READY1_CH2;
                   DATA_VALID_CH1 <= READOUT_BUSY1_CH1;
                   DATA_VALID_CH2 <= READOUT_BUSY1_CH2;
                   RDEN1_CH2 <= RDEN_CH2;
                   RDEN2_CH2 <= '0';
                   TRIGGER_PATTERN <= TRIGGER_PATTERN_TIME1;
                   GPS_TS_OUT <= GPS_TS_TIME1;
                   CTD_OUT <= CTD_TIME1;
      when "10" => DATA_OUT_CH1 <= DATA_OUT2_CH1;        
                   DATA_READY_CH1 <= DATA_READY2_CH1;
                   RDEN1_CH1 <= '0';
                   RDEN2_CH1 <= RDEN_CH1;
--                   COINC_TO_END_TIME1_TMP <= COINC_TO_END_TIME;
--                   COINC_TO_END_TIME2_TMP <= '0';
                   DATA_OUT_CH2 <= DATA_OUT2_CH2;        
                   DATA_READY_CH2 <= DATA_READY2_CH2;
                   DATA_VALID_CH1 <= READOUT_BUSY2_CH1;
                   DATA_VALID_CH2 <= READOUT_BUSY2_CH2;
                   RDEN1_CH2 <= '0';
                   RDEN2_CH2 <= RDEN_CH2;
                   TRIGGER_PATTERN <= TRIGGER_PATTERN_TIME2;
                   GPS_TS_OUT <= GPS_TS_TIME2;
                   CTD_OUT <= CTD_TIME2;
      when "11" => DATA_OUT_CH1 <= DATA_OUT1_CH1; -- never assigned        
                   DATA_READY_CH1 <= '0';
                   RDEN1_CH1 <= '0';
                   RDEN2_CH1 <= '0';
--                   COINC_TO_END_TIME1_TMP <= COINC_TO_END_TIME;
--                   COINC_TO_END_TIME2_TMP <= '0';
                   DATA_OUT_CH2 <= DATA_OUT1_CH2;        
                   DATA_READY_CH2 <= '0';
                   DATA_VALID_CH1 <= '0';
                   DATA_VALID_CH2 <= '0';
                   RDEN1_CH2 <= '0';
                   RDEN2_CH2 <= '0';
                   TRIGGER_PATTERN <= TRIGGER_PATTERN_TIME1;
                   GPS_TS_OUT <= GPS_TS_TIME1;
                   CTD_OUT <= CTD_TIME1;
      when others =>
    end case;
  end process; 

  -- Latch TRIGGER_PATTERN on positive edge of COINC_TO_END_TIME1
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TRIGGER_PATTERN_TIME1 <= "0000000000000000";
      GPS_TS_TIME1 <= "00000000000000000000000000000000000000000000000000000000";
      CTD_TIME1 <= "00000000000000000000000000000000";
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COINC_TO_END_TIME1_TMP = '1' and COINC_TO_END_TIME1_TMP_DEL = '0' then
        TRIGGER_PATTERN_TIME1 <= TRIGGER_PATTERN_IN;
        GPS_TS_TIME1 <= GPS_TS_IN;
        CTD_TIME1 <= CTD_IN;
      end if;
    end if;
  end process;  

  -- Latch TRIGGER_PATTERN on positive edge of COINC_TO_END_TIME2
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TRIGGER_PATTERN_TIME2 <= "0000000000000000";
      GPS_TS_TIME2 <= "00000000000000000000000000000000000000000000000000000000";
      CTD_TIME2 <= "00000000000000000000000000000000";
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COINC_TO_END_TIME2_TMP = '1' and COINC_TO_END_TIME2_TMP_DEL = '0' then
        TRIGGER_PATTERN_TIME2 <= TRIGGER_PATTERN_IN;
        GPS_TS_TIME2 <= GPS_TS_IN;
        CTD_TIME2 <= CTD_IN;
      end if;
    end if;
  end process;  

--
--  -- Latch TRIGGER_PATTERN on positive edge of COINC_TO_END_TIME1
--  process(COINC_TO_END_TIME1_TMP,SYSRST)
--  begin
--    if SYSRST = '1' then
--      TRIGGER_PATTERN_TIME1 <= "0000000000000000";
--    elsif (COINC_TO_END_TIME1_TMP'event and COINC_TO_END_TIME1_TMP = '1') then
--      TRIGGER_PATTERN_TIME1 <= TRIGGER_PATTERN_IN;
--    end if;
--  end process;  
--
--  -- Latch TRIGGER_PATTERN on positive edge of COINC_TO_END_TIME2
--  process(COINC_TO_END_TIME2_TMP,SYSRST)
--  begin
--    if SYSRST = '1' then
--      TRIGGER_PATTERN_TIME2 <= "0000000000000000";
--    elsif (COINC_TO_END_TIME2_TMP'event and COINC_TO_END_TIME2_TMP = '1') then
--      TRIGGER_PATTERN_TIME2 <= TRIGGER_PATTERN_IN;
--    end if;
--  end process;  
--
--  -- Latch GPS_TS on positive edge of COINC_TO_END_TIME1
--  process(COINC_TO_END_TIME1_TMP,SYSRST)
--  begin
--    if SYSRST = '1' then
--      GPS_TS_TIME1 <= "00000000000000000000000000000000000000000000000000000000";
--    elsif (COINC_TO_END_TIME1_TMP'event and COINC_TO_END_TIME1_TMP = '1') then
--      GPS_TS_TIME1 <= GPS_TS_IN;
--    end if;
--  end process;  
--
--  -- Latch GPS_TS on positive edge of COINC_TO_END_TIME2
--  process(COINC_TO_END_TIME2_TMP,SYSRST)
--  begin
--    if SYSRST = '1' then
--      GPS_TS_TIME2 <= "00000000000000000000000000000000000000000000000000000000";
--    elsif (COINC_TO_END_TIME2_TMP'event and COINC_TO_END_TIME2_TMP = '1') then
--      GPS_TS_TIME2 <= GPS_TS_IN;
--    end if;
--  end process;  
--
--  -- Latch CTD on positive edge of COINC_TO_END_TIME1
--  process(COINC_TO_END_TIME1_TMP,SYSRST)
--  begin
--    if SYSRST = '1' then
--      CTD_TIME1 <= "00000000000000000000000000000000";
--    elsif (COINC_TO_END_TIME1_TMP'event and COINC_TO_END_TIME1_TMP = '1') then
--      CTD_TIME1 <= CTD_IN;
--    end if;
--  end process;  
--
--  -- Latch CTD on positive edge of COINC_TO_END_TIME2
--  process(COINC_TO_END_TIME2_TMP,SYSRST)
--  begin
--    if SYSRST = '1' then
--      CTD_TIME2 <= "00000000000000000000000000000000";
--    elsif (COINC_TO_END_TIME2_TMP'event and COINC_TO_END_TIME2_TMP = '1') then
--      CTD_TIME2 <= CTD_IN;
--    end if;
--  end process;  

end rtl ; -- of FIFO_SELECT

