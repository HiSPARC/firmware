-- EASE/HDL begin --------------------------------------------------------------
-- 
-- Architecture 'a0' of entity 'FIFO_SELECT'.
-- 
--------------------------------------------------------------------------------
-- 
-- Copy of the interface declaration:
-- 
--   port(
--     BLOCK_COINC             : out    std_logic;
--     CLK200MHz               : in     std_logic;
--     CLKRD                   : in     std_logic;
--     COINC_TO_END_TIME       : in     std_logic;
--     COINC_TO_END_TIME_FIFO1 : out    std_logic;
--     COINC_TO_END_TIME_FIFO2 : out    std_logic;
--     CTD_IN                  : in     std_logic_vector(31 downto 0);
--     CTD_OUT                 : out    std_logic_vector(31 downto 0);
--     DATA_OUT1_CH1           : in     std_logic_vector(11 downto 0);
--     DATA_OUT1_CH2           : in     std_logic_vector(11 downto 0);
--     DATA_OUT2_CH1           : in     std_logic_vector(11 downto 0);
--     DATA_OUT2_CH2           : in     std_logic_vector(11 downto 0);
--     DATA_OUT_CH1            : out    std_logic_vector(11 downto 0);
--     DATA_OUT_CH2            : out    std_logic_vector(11 downto 0);
--     DATA_READY1_CH1         : in     std_logic;
--     DATA_READY1_CH2         : in     std_logic;
--     DATA_READY2_CH1         : in     std_logic;
--     DATA_READY2_CH2         : in     std_logic;
--     DATA_READY_CH1          : out    std_logic;
--     DATA_READY_CH2          : out    std_logic;
--     DATA_VALID_CH1          : out    std_logic;
--     DATA_VALID_CH2          : out    std_logic;
--     GPS_TS_IN               : in     std_logic_vector(55 downto 0);
--     GPS_TS_OUT              : out    std_logic_vector(55 downto 0);
--     RDEN1_CH1               : out    std_logic;
--     RDEN1_CH2               : out    std_logic;
--     RDEN2_CH1               : out    std_logic;
--     RDEN2_CH2               : out    std_logic;
--     RDEN_CH1                : in     std_logic;
--     RDEN_CH2                : in     std_logic;
--     READOUT_BUSY1_CH1       : in     std_logic;
--     READOUT_BUSY1_CH2       : in     std_logic;
--     READOUT_BUSY2_CH1       : in     std_logic;
--     READOUT_BUSY2_CH2       : in     std_logic;
--     SYSRST                  : in     std_logic;
--     TRIGGER_PATTERN         : out    std_logic_vector(15 downto 0);
--     TRIGGER_PATTERN_IN      : in     std_logic_vector(15 downto 0));
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture a0 of FIFO_SELECT is

signal COINC_TO_END_TIME_DEL1: std_logic;
signal COINC_SWITCH: std_logic_vector(1 downto 0); -- bit0 is gates coinc to channel 1 and bit1 to channel 2
signal BLOCK_SWITCH: std_logic_vector(1 downto 0); -- bit0 is set at a coinc to channel 1 and bit1 is set at a coinc to channel 2; end of readout of the channel, clears the bit
signal DATA_READY1: std_logic; -- active when there is latched data in one of the first fifo's
signal DATA_READY2: std_logic; -- active when there is latched data in one of the second fifo's
signal DATA_READY1_DEL1: std_logic; -- delay's to synchronize it with the 200MHz
signal DATA_READY2_DEL1: std_logic; -- delay's to synchronize it with the 200MHz
signal DATA_READY1_DEL2: std_logic;
signal DATA_READY2_DEL2: std_logic;
signal DATA_READY_FIFO1: std_logic;
signal DATA_READY_FIFO2: std_logic;
signal READY: std_logic_vector(1 downto 0); -- bit0 selects FIFO1 and bit1 selects FIFO2
signal COINC_TO_FIFO1: std_logic;
signal COINC_TO_FIFO1_DEL1: std_logic;
signal COINC_TO_FIFO2: std_logic;
signal COINC_TO_FIFO2_DEL1: std_logic;
signal RDEN_CH2_DEL1: std_logic;
signal TRIGGER_PATTERN_TIME1: std_logic_vector(15 downto 0);
signal TRIGGER_PATTERN_TIME2: std_logic_vector(15 downto 0);
signal CTD_TIME1: std_logic_vector(31 downto 0);
signal CTD_TIME2: std_logic_vector(31 downto 0);
signal GPS_TS_TIME1: std_logic_vector(55 downto 0);
signal GPS_TS_TIME2: std_logic_vector(55 downto 0);

begin

  COINC_TO_END_TIME_FIFO1 <= COINC_TO_FIFO1;
  COINC_TO_END_TIME_FIFO2 <= COINC_TO_FIFO2;

  -- DATA_READY_FIFO is true when there is data in both fifo's of the channels made on the same COINC
  DATA_READY_FIFO1 <= DATA_READY1_CH1 and DATA_READY1_CH2;
  DATA_READY_FIFO2 <= DATA_READY2_CH1 and DATA_READY2_CH2;

  -- BLOCK_COINC if FIFO's1 and FIFO's2 are full
  BLOCK_COINC <= '1' when BLOCK_SWITCH = "11" else '0';

  DATA_READY1 <= DATA_READY1_CH1 or DATA_READY1_CH2;
  DATA_READY2 <= DATA_READY2_CH1 or DATA_READY2_CH2;

  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COINC_SWITCH <= "00";
      BLOCK_SWITCH <= "00";
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if DATA_READY1_DEL1 = '0' and  DATA_READY1_DEL2 = '1' then -- on a falling edge of DATA_READY1, the first fifo's have been read out
        COINC_SWITCH(0) <= '0'; -- Clear coinc_switch0
        BLOCK_SWITCH(0) <= '0'; -- Clear block_switch0
      elsif DATA_READY2_DEL1 = '0' and  DATA_READY2_DEL2 = '1' then -- on a falling edge of DATA_READY2, the second fifo's have been read out
        COINC_SWITCH(1) <= '0'; -- Clear coinc_switch1
        BLOCK_SWITCH(1) <= '0'; -- Clear block_switch1
      elsif BLOCK_SWITCH /= "11" and (COINC_SWITCH = "00" or COINC_SWITCH = "10") and COINC_TO_END_TIME = '1' and  COINC_TO_END_TIME_DEL1 = '0' then -- on a rising edge of COINC_TO_END_TIME and COINC_SWITCH(0) = '0'
        COINC_SWITCH <= "01"; -- Set coinc_switch0
        BLOCK_SWITCH(0) <= '1'; -- Set block_switch0
      elsif BLOCK_SWITCH /= "11" and COINC_SWITCH = "01" and COINC_TO_END_TIME = '1' and  COINC_TO_END_TIME_DEL1 = '0' then -- on a rising edge of COINC_TO_END_TIME and COINC_SWITCH(0) = '1' and COINC_SWITCH(1) = '0'
        COINC_SWITCH <= "10"; -- Set coinc_switch1
        BLOCK_SWITCH(1) <= '1'; -- Set block_switch1
      end if;
    end if;
  end process;

  -- COINC Multiplexer
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COINC_TO_FIFO1 <= '0';
      COINC_TO_FIFO2 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COINC_SWITCH = "01" then
        COINC_TO_FIFO1 <= COINC_TO_END_TIME_DEL1;
      elsif COINC_SWITCH = "10" then
        COINC_TO_FIFO2 <= COINC_TO_END_TIME_DEL1;
      else
        COINC_TO_FIFO1 <= '0';
        COINC_TO_FIFO2 <= '0';
      end if;
    end if;
  end process;

  -- delay's  on CLK200MHz
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COINC_TO_END_TIME_DEL1 <= '0';
      DATA_READY1_DEL1 <= '0';
      DATA_READY1_DEL2 <= '0';
      DATA_READY2_DEL1 <= '0';
      DATA_READY2_DEL2 <= '0';
      COINC_TO_FIFO1_DEL1 <= '0';
      COINC_TO_FIFO2_DEL1 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      COINC_TO_END_TIME_DEL1 <= COINC_TO_END_TIME;
      DATA_READY1_DEL1 <= DATA_READY1;
      DATA_READY1_DEL2 <= DATA_READY1_DEL1;
      DATA_READY2_DEL1 <= DATA_READY2;
      DATA_READY2_DEL2 <= DATA_READY2_DEL1;
      COINC_TO_FIFO1_DEL1 <= COINC_TO_FIFO1;
      COINC_TO_FIFO2_DEL1 <= COINC_TO_FIFO2;
    end if;
  end process;

  -- delay's  on CLKRD
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

  -- For a master COINC_TO_END_TIME is 20ns delayed
  -- This is to compensate for the slave to master time (cable, drivers)
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      GPS_TS_TIME1 <= "00000000000000000000000000000000000000000000000000000000";
      CTD_TIME1 <= "00000000000000000000000000000000";
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COINC_TO_FIFO1 = '1' and COINC_TO_FIFO1_DEL1 = '0' then
        GPS_TS_TIME1 <= GPS_TS_IN;
        CTD_TIME1 <= CTD_IN;
      end if;
    end if;
  end process;

  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      GPS_TS_TIME2 <= "00000000000000000000000000000000000000000000000000000000";
      CTD_TIME2 <= "00000000000000000000000000000000";
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COINC_TO_FIFO2 = '1' and COINC_TO_FIFO2_DEL1 = '0' then
        GPS_TS_TIME2 <= GPS_TS_IN;
        CTD_TIME2 <= CTD_IN;
      end if;
    end if;
  end process;

  -- Latch TRIGGER_PATTERN on negative edge of COINC_TO_FIFO1
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TRIGGER_PATTERN_TIME1 <= "0000000000000000";
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COINC_TO_FIFO1 = '0' and COINC_TO_FIFO1_DEL1 = '1' then
        TRIGGER_PATTERN_TIME1 <= TRIGGER_PATTERN_IN;
      end if;
    end if;
  end process;

  -- Latch TRIGGER_PATTERN on negative edge of COINC_TO_FIFO2
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TRIGGER_PATTERN_TIME2 <= "0000000000000000";
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COINC_TO_FIFO2 = '0' and COINC_TO_FIFO2_DEL1 = '1' then
        TRIGGER_PATTERN_TIME2 <= TRIGGER_PATTERN_IN;
      end if;
    end if;
  end process;

end architecture a0 ; -- of FIFO_SELECT

