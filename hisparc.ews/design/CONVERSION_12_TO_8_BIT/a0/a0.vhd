-- EASE/HDL begin --------------------------------------------------------------
-- 
-- Architecture 'a0' of entity 'CONVERSION_12_TO_8_BIT'.
-- 
--------------------------------------------------------------------------------
-- 
-- Copy of the interface declaration:
-- 
--   port(
--     CLKRD              : in     std_logic;
--     CONVERSION_CLK     : in     std_logic;
--     CONV_DATA_READY    : out    std_logic;
--     CTD_IN             : in     std_logic_vector(31 downto 0);
--     CTD_OUT            : out    std_logic_vector(31 downto 0);
--     DATA_OUT           : out    std_logic_vector(7 downto 0);
--     DATA_OUT_CH1       : in     std_logic_vector(11 downto 0);
--     DATA_OUT_CH2       : in     std_logic_vector(11 downto 0);
--     DATA_READY_CH1     : in     std_logic;
--     DATA_READY_CH2     : in     std_logic;
--     DATA_VALID_CH1     : in     std_logic;
--     DATA_VALID_CH2     : in     std_logic;
--     FIFO_EMPTY         : in     std_logic;
--     GPS_TS_IN          : in     std_logic_vector(55 downto 0);
--     GPS_TS_OUT         : out    std_logic_vector(55 downto 0);
--     RDEN_CH1           : out    std_logic;
--     RDEN_CH2           : out    std_logic;
--     SYSRST             : in     std_logic;
--     TOTAL_TIME_3X      : in     integer range 6000 downto 0;
--     TOTAL_TIME_6X      : out    integer range 12000 downto 0;
--     TRIGGER_PATTERN    : out    std_logic_vector(15 downto 0);
--     TRIGGER_PATTERN_IN : in     std_logic_vector(15 downto 0);
--     WE                 : out    std_logic;
--     WR_ADDRESS         : out    integer range 12020 downto 0);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture a0 of CONVERSION_12_TO_8_BIT is

signal PHASE1: std_logic;
signal PHASE2: std_logic;
signal PHASE: std_logic_vector(1 downto 0);
signal WR_ADDRESS_CNT: integer range 12020 downto 0;
signal DATA_OUT_TMP: std_logic_vector(3 downto 0);
signal WE_TMP: std_logic;
signal WE_DEL: std_logic;
signal FIFO_EMPTY_DEL: std_logic;
signal CHANNEL_SELECT: std_logic;
signal CHANNEL_SELECT_PRE1: std_logic;
signal CHANNEL_SELECT_PRE2: std_logic;
signal RDEN_SELECT: std_logic;
signal DATA_SELECT: std_logic_vector(11 downto 0);
signal WR_ADDRESS_SELECT_BEGIN: integer range 12020 downto 0;
signal WR_ADDRESS_SELECT_END: integer range 12020 downto 0;
signal TOTAL_TIME_6X_TMP: integer range 12000 downto 0;
signal DATA_VALID_SELECT: std_logic;

begin
-- PHASE1 and PHASE2 are made to divide two periods of CLKRD in four parts
-- each part has the lenght of CONVERSION_CLK
  PHASE(0) <= PHASE1;
  PHASE(1) <= PHASE2;

  WR_ADDRESS <= WR_ADDRESS_CNT;
  WE <= WE_TMP;
  TOTAL_TIME_6X <= TOTAL_TIME_6X_TMP;

  process(CLKRD,DATA_VALID_SELECT)
  begin
    if DATA_VALID_SELECT = '0' then
      PHASE1 <= '0';
    elsif (CLKRD'event and CLKRD = '1') then
      PHASE1 <= not PHASE1;
    end if;
  end process;

  process(CLKRD,DATA_VALID_SELECT)
  begin
    if DATA_VALID_SELECT = '0' then
      PHASE2 <= '0';
    elsif (CLKRD'event and CLKRD = '0') then
      PHASE2 <= PHASE1;
    end if;
  end process;

  process(CONVERSION_CLK,DATA_SELECT,WR_ADDRESS_CNT)
  begin
    if (CONVERSION_CLK'event and CONVERSION_CLK = '1') then
      if DATA_VALID_SELECT = '1' then
        if WR_ADDRESS_CNT < WR_ADDRESS_SELECT_END - 1 then
          case PHASE is
            -- In the first part the most significant 8 data bits from the ADCs
            -- go to the output (input for FIFO) and the other 4 bits to a temporary register
            when "10" => DATA_OUT <= DATA_SELECT(11 downto 4);
                         DATA_OUT_TMP <= DATA_SELECT(3 downto 0);
                         WR_ADDRESS_CNT <= WR_ADDRESS_CNT +1;

            -- The write address counter for the FIFO will not change
            -- The counter only increments in the other 3 parts
            when "00" => DATA_OUT <= DATA_SELECT(11 downto 4);
                         DATA_OUT_TMP <= DATA_SELECT(3 downto 0);
                         WR_ADDRESS_CNT <= WR_ADDRESS_CNT;

            -- In this part the data from the temporary register (this are the least
            -- significant bits of the former data) go to the most significant bits
            -- of the FIFO data and the least significant bits of the FIFO will be
            -- the most significant bits of the new input data.
            when "01" => DATA_OUT(7 downto 4) <= DATA_OUT_TMP;
                         DATA_OUT(3 downto 0) <= DATA_SELECT(11 downto 8);
                         DATA_OUT_TMP <= DATA_SELECT(3 downto 0);
                         WR_ADDRESS_CNT <= WR_ADDRESS_CNT + 1;

            -- In the last part the least significant bits of the new input data
            -- go to the FIFO
            when "11" => DATA_OUT <= DATA_SELECT(7 downto 0);
                         DATA_OUT_TMP <= DATA_SELECT(3 downto 0);
                         WR_ADDRESS_CNT <= WR_ADDRESS_CNT + 1;
            when others => DATA_OUT <= DATA_SELECT(11 downto 4);
                         DATA_OUT_TMP <= DATA_SELECT(3 downto 0);
                         WR_ADDRESS_CNT <= WR_ADDRESS_CNT;
          end case;
          WE_TMP <= '1';
        else
          WR_ADDRESS_CNT <= WR_ADDRESS_CNT;
          DATA_OUT <= "00000000";
          DATA_OUT_TMP <= "0000";
          WE_TMP <= '0';
        end if;
      else
        WR_ADDRESS_CNT <= WR_ADDRESS_SELECT_BEGIN;
      end if;
    end if;
  end process;

  -- Delays
  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      WE_DEL <= '0';
      FIFO_EMPTY_DEL <= '1';
    elsif (CLKRD'event and CLKRD = '1') then
      WE_DEL <= WE_TMP;
      FIFO_EMPTY_DEL <= FIFO_EMPTY;
    end if;
  end process;

  -- Read enable must go false at the end of writing the FIFO and true when readout has finished
  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      RDEN_SELECT <= '1';
    elsif (CLKRD'event and CLKRD = '1') then
      if WE_TMP = '0' and WE_DEL = '1' and CHANNEL_SELECT = '1' then
        RDEN_SELECT <= '0';
      elsif FIFO_EMPTY = '1' and FIFO_EMPTY_DEL = '0' then
        RDEN_SELECT <= '1';
      end if;
    end if;
  end process;

  -- Data conversion (CONV_DATA_READY) must go true at the end of writing the FIFO and false when readout starts
  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      CONV_DATA_READY <= '0';
    elsif (CLKRD'event and CLKRD = '1') then
      if WE_TMP = '0' and WE_DEL = '1' and CHANNEL_SELECT = '1' then
        CONV_DATA_READY <= '1';
      elsif FIFO_EMPTY = '0' and FIFO_EMPTY_DEL = '1' then
        CONV_DATA_READY <= '0';
      end if;
    end if;
  end process;

  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      CHANNEL_SELECT <= '0';
      CHANNEL_SELECT_PRE1 <= '0';
      CHANNEL_SELECT_PRE2 <= '0';
    elsif (CLKRD'event and CLKRD = '1') then
      CHANNEL_SELECT_PRE2 <= CHANNEL_SELECT_PRE1;
      CHANNEL_SELECT <= CHANNEL_SELECT_PRE2;
      if WR_ADDRESS_CNT >= TOTAL_TIME_3X - 1 and WR_ADDRESS_CNT < TOTAL_TIME_6X_TMP - 1 then
        CHANNEL_SELECT_PRE1 <= '1';
      else
        CHANNEL_SELECT_PRE1 <= '0';
      end if;
    end if;
  end process;

  -- Read enable select. If CHANNEL_SELECT = channel 1 then RDEN_CH1 has to be selected and RDEN_CH2 has to be zero
  -- If CHANNEL_SELECT = channel 2 then RDEN_CH2 has to be selected and RDEN_CH1 has to be zero
  RDEN_CH1 <= RDEN_SELECT when CHANNEL_SELECT = '0' else '0';
  RDEN_CH2 <= RDEN_SELECT when CHANNEL_SELECT = '1' else '0';

  -- The input data is from channel 1 when CHANNEL_SELECT = 0 or from channel 2 when CHANNEL_SELECT = 1
  DATA_SELECT <= DATA_OUT_CH1 when CHANNEL_SELECT = '0' else DATA_OUT_CH2;

  -- Data valid is from channel 1 when CHANNEL_SELECT = 0 or from channel 2 when CHANNEL_SELECT = 1
  DATA_VALID_SELECT <= DATA_VALID_CH1 when CHANNEL_SELECT = '0' else DATA_VALID_CH2;

  -- FIFO write address has to begin at zero and has to stop at 3 times the total time when doing channel 1
  -- FIFO write address has to begin at 3 times the total time and has to stop at 6 times the total time when doing channel 2
  TOTAL_TIME_6X_TMP <= TOTAL_TIME_3X + TOTAL_TIME_3X;
  WR_ADDRESS_SELECT_BEGIN <= 0 when CHANNEL_SELECT = '0' else TOTAL_TIME_3X;
  WR_ADDRESS_SELECT_END <= TOTAL_TIME_3X when CHANNEL_SELECT = '0' else TOTAL_TIME_6X_TMP;

  -- Take over TRIGGER_PATTERN, GPS_TS and CTD
  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      TRIGGER_PATTERN <= "0000000000000000";
      GPS_TS_OUT <= "00000000000000000000000000000000000000000000000000000000";
      CTD_OUT <= "00000000000000000000000000000000";
    elsif (CLKRD'event and CLKRD = '1') then
      if WE_TMP = '0' and WE_DEL = '1' and CHANNEL_SELECT = '1' then
        TRIGGER_PATTERN <= TRIGGER_PATTERN_IN;
        GPS_TS_OUT <= GPS_TS_IN;
        CTD_OUT <= CTD_IN;
      end if;
    end if;
  end process;

end architecture a0 ; -- of CONVERSION_12_TO_8_BIT

