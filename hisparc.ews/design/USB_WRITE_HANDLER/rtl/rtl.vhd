-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'USB_WRITE_HANDLER.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'USB_WRITE_HANDLER' :
-- 
--   port(
--     ALTITUDE                    : in     std_logic_vector(63 downto 0);
--     CLK10MHz                    : in     std_logic;
--     CLKRD                       : in     std_logic;
--     COINC_TIME                  : in     std_logic_vector(15 downto 0);
--     COMPDATA                    : in     std_logic_vector(127 downto 0);
--     COMPDATA_READOUT_DONE       : out    std_logic;
--     COMPDATA_VALID              : in     std_logic;
--     CTD_IN                      : in     std_logic_vector(31 downto 0);
--     CTD_TS_ONE_PPS              : in     std_logic_vector(31 downto 0);
--     CTP_TS_ONE_PPS              : in     std_logic_vector(31 downto 0);
--     EVENT_DATA_IN               : in     std_logic_vector(7 downto 0);
--     EVENT_READOUT_BUSY          : in     std_logic;
--     EVENT_WR                    : out    std_logic;
--     EVENT_WR_EN                 : in     std_logic;
--     GPS_TS_IN                   : in     std_logic_vector(55 downto 0);
--     GPS_TS_ONE_PPS              : in     std_logic_vector(55 downto 0);
--     LATITUDE                    : in     std_logic_vector(63 downto 0);
--     LONGITUDE                   : in     std_logic_vector(63 downto 0);
--     NEW_DATA_WHILE_READOUT      : out    std_logic;
--     PARAMETER_LIST              : in     std_logic_vector(271 downto 0);
--     PARAMETER_LIST_READOUT_DONE : out    std_logic;
--     PARAMETER_LIST_VALID        : in     std_logic;
--     POST_TIME                   : in     std_logic_vector(15 downto 0);
--     PRE_TIME                    : in     std_logic_vector(15 downto 0);
--     READ_ERROR_DATA             : in     std_logic_vector(7 downto 0);
--     READ_ERROR_READOUT_DONE     : out    std_logic;
--     READ_ERROR_VALID            : in     std_logic;
--     SAT_INFO                    : in     std_logic_vector(487 downto 0);
--     SECOND_MESSAGE_ALLOWED      : in     std_logic;
--     SEND_EVENT_DATA             : out    std_logic;
--     START_WRITE_EVENT           : in     std_logic;
--     SYSRST                      : in     std_logic;
--     TEMP                        : in     std_logic_vector(31 downto 0);
--     TH_COUNTERS_IN              : in     std_logic_vector(63 downto 0);
--     TRIGGER_PATTERN             : in     std_logic_vector(15 downto 0);
--     TR_CONDITION                : in     std_logic_vector(7 downto 0);
--     TS_ONE_PPS_READOUT_DONE     : out    std_logic;
--     TS_ONE_PPS_VALID_INPUT      : in     std_logic;
--     USB_DATA_OUT                : out    std_logic_vector(7 downto 0);
--     USB_TXE                     : in     std_logic;
--     USB_WR                      : out    std_logic;
--     USB_WRITE_BUSY              : out    std_logic;
--     USB_WRITE_ENABLE            : in     std_logic;
--     USB_WRITE_REQUEST           : out    std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of USB_WRITE_HANDLER is

signal WR_TMP: std_logic ;
signal WRITE_EVENT_MODE: std_logic ; -- True when event data is send to computer
signal WRITE_EVENT_MODE_DEL: std_logic ; 
signal WRITE_GPS_MODE: std_logic ; -- True when data of GPS counters is send to computer
signal WRITE_GPS_MODE_DEL: std_logic ;  
signal WRITE_PARAMETER_LIST_MODE: std_logic ; -- True when PARAMETER_LIST is send to computer
signal WRITE_PARAMETER_LIST_MODE_DEL: std_logic ;  
signal WRITE_READ_ERROR_MODE: std_logic ; -- True when READ_ERROR data is send to computer
signal WRITE_READ_ERROR_MODE_DEL: std_logic ;  
signal WRITE_COMP_MODE: std_logic ; -- True when data of comperators is send to computer
signal WRITE_COMP_MODE_DEL: std_logic ;  
signal START_WRITE_EVENT_PRIOR: std_logic ; 
signal START_WRITE_EVENT_PRIOR_DEL: std_logic ; 
signal START_WRITE_GPS_COUNT_PRIOR: std_logic ; 
signal START_WRITE_GPS_COUNT_PRIOR_DEL: std_logic ; 
signal START_WRITE_PARAMETER_LIST_PRIOR: std_logic ; 
signal START_WRITE_PARAMETER_LIST_PRIOR_DEL: std_logic ; 
signal START_WRITE_READ_ERROR_PRIOR: std_logic ; 
signal START_WRITE_READ_ERROR_PRIOR_DEL: std_logic ; 
signal START_WRITE_COMP_DATA_PRIOR: std_logic ; 
signal START_WRITE_COMP_DATA_PRIOR_DEL: std_logic ; 
signal ADDITIONAL_DATA_COUNT: integer range 22 downto 0;
signal WRITE_ENABLE_ADDITIONAL_DATA: std_logic ; 
signal WRITE_ENABLE_ADDITIONAL_DATA_DEL1: std_logic ; 
signal WR_ADDITIONAL_DATA: std_logic ; 
signal WR_ADDITIONAL_DATA_DEL: std_logic ; 
signal USB_WR_EN: std_logic ; 
signal EVENT_READOUT_BUSY_DEL: std_logic ; 
signal SEND_EVENT_DATA_TMP: std_logic ; 
signal WR_END_BYTE: std_logic ; 
signal WR_END_BYTE_DEL: std_logic ; 
signal WR_END_BYTE_ENABLE: std_logic ; 
signal WR_END_BYTE_ENABLE_DEL1: std_logic ; 
signal ADDITIONAL_DATA_TMP: std_logic_vector(7 downto 0); 
signal USB_DATA_PRE: std_logic_vector(7 downto 0); 
signal USB_DATA: std_logic_vector(7 downto 0); 
signal USB_DATA_MODE_PRE: std_logic_vector(2 downto 0); 
signal USB_DATA_MODE: std_logic_vector(4 downto 0); 
signal WR_GPS_DATA_ENABLE: std_logic ; 
signal WR_GPS_DATA_ENABLE_DEL: std_logic ; 
signal GPS_DATA_COUNT: integer range 87 downto 0;
signal GPS_DATA_TMP: std_logic_vector(7 downto 0); 
signal WR_GPS_DATA: std_logic ; 
signal WR_GPS_DATA_DEL: std_logic ; 
signal WR_PARAMETER_LIST_ENABLE: std_logic ; 
signal WR_PARAMETER_LIST_ENABLE_DEL: std_logic ; 
signal PARAMETER_LIST_COUNT: integer range 79 downto 0;
signal WR_PARAMETER_LIST: std_logic ; 
signal WR_PARAMETER_LIST_DEL: std_logic ; 
signal PARAMETER_LIST_TMP: std_logic_vector(7 downto 0); 
signal WR_READ_ERROR_ENABLE: std_logic ; 
signal WR_READ_ERROR_ENABLE_DEL: std_logic ; 
signal READ_ERROR_COUNT: integer range 4 downto 0;
signal WR_READ_ERROR: std_logic ; 
signal WR_READ_ERROR_DEL: std_logic ; 
signal READ_ERROR_TMP: std_logic_vector(7 downto 0); 
signal WR_COMP_DATA_ENABLE: std_logic ; 
signal WR_COMP_DATA_ENABLE_DEL: std_logic ; 
signal COMP_DATA_COUNT: integer range 19 downto 0;
signal COMP_DATA_TMP: std_logic_vector(7 downto 0); 
signal WR_COMP_DATA: std_logic ; 
signal WR_COMP_DATA_DEL: std_logic ; 

signal TS_ONE_PPS_VALID_IN: std_logic ; 
signal TS_ONE_PPS_VALID_IN_DEL: std_logic ; 
signal START_WRITE_EVENT_DEL: std_logic ; 
signal PARAMETER_LIST_VALID_DEL: std_logic ; 
signal READ_ERROR_VALID_DEL: std_logic ; 
signal COMPDATA_VALID_DEL: std_logic ; 
signal USB_WRITE_BUSY_TMP: std_logic ; 
signal USB_BUSYHOLD_COUNT: std_logic_vector(3 downto 0); -- Forces a gap between 2 BUSY signals
signal USB_WRITE_HOLDOFF_COUNTER: std_logic_vector(6 downto 0); 


begin

  TS_ONE_PPS_VALID_IN <= TS_ONE_PPS_VALID_INPUT and SECOND_MESSAGE_ALLOWED; -- Enable One second message with bit 1 of spare bytes

  USB_WRITE_REQUEST <= TS_ONE_PPS_VALID_IN or START_WRITE_EVENT or PARAMETER_LIST_VALID or READ_ERROR_VALID or COMPDATA_VALID;
  USB_WRITE_BUSY_TMP <= WRITE_EVENT_MODE or WRITE_GPS_MODE or WRITE_PARAMETER_LIST_MODE or WRITE_READ_ERROR_MODE or WRITE_COMP_MODE;
  USB_WRITE_BUSY <= USB_WRITE_BUSY_TMP;
  USB_WR <= WR_TMP;
  USB_WR_EN <= WRITE_ENABLE_ADDITIONAL_DATA or EVENT_WR_EN or WR_END_BYTE_ENABLE or WR_GPS_DATA_ENABLE or WR_PARAMETER_LIST_ENABLE or WR_READ_ERROR_ENABLE or WR_COMP_DATA_ENABLE;
  SEND_EVENT_DATA <= SEND_EVENT_DATA_TMP;
  WR_ADDITIONAL_DATA <= WR_TMP when WRITE_ENABLE_ADDITIONAL_DATA = '1' else '0';
  EVENT_WR <= WR_TMP when SEND_EVENT_DATA_TMP = '1' else '0';
  WR_END_BYTE <= WR_TMP when WR_END_BYTE_ENABLE = '1' else '0';
  USB_DATA_MODE_PRE(0) <= WRITE_ENABLE_ADDITIONAL_DATA;
  USB_DATA_MODE_PRE(1) <= SEND_EVENT_DATA_TMP;
  USB_DATA_MODE_PRE(2) <= WR_END_BYTE_ENABLE;
  USB_DATA_MODE(0) <= WRITE_ENABLE_ADDITIONAL_DATA or SEND_EVENT_DATA_TMP or WR_END_BYTE_ENABLE;
  USB_DATA_MODE(1) <= WR_GPS_DATA_ENABLE;
  USB_DATA_MODE(2) <= WR_PARAMETER_LIST_ENABLE;
  USB_DATA_MODE(3) <= WR_READ_ERROR_ENABLE;
  USB_DATA_MODE(4) <= WR_COMP_DATA_ENABLE;
  WR_GPS_DATA <= WR_TMP when WR_GPS_DATA_ENABLE = '1' else '0';
  TS_ONE_PPS_READOUT_DONE <= not WR_GPS_DATA_ENABLE and WR_GPS_DATA_ENABLE_DEL;
  WR_PARAMETER_LIST <= WR_TMP when WR_PARAMETER_LIST_ENABLE = '1' else '0';
  PARAMETER_LIST_READOUT_DONE <= not WR_PARAMETER_LIST_ENABLE and WR_PARAMETER_LIST_ENABLE_DEL;
  WR_READ_ERROR <= WR_TMP when WR_READ_ERROR_ENABLE = '1' else '0';
  READ_ERROR_READOUT_DONE <= not WR_READ_ERROR_ENABLE and WR_READ_ERROR_ENABLE_DEL;
  WR_COMP_DATA <= WR_TMP when WR_COMP_DATA_ENABLE = '1' else '0';
  COMPDATA_READOUT_DONE <= not WR_COMP_DATA_ENABLE and WR_COMP_DATA_ENABLE_DEL;
  
  process(CLKRD,SYSRST)
  begin
  	if SYSRST = '1' then
  	  WRITE_EVENT_MODE_DEL <= '0';
  	  WRITE_ENABLE_ADDITIONAL_DATA_DEL1 <= '0';
  	  EVENT_READOUT_BUSY_DEL <= '0';
  	  WR_END_BYTE_ENABLE_DEL1 <= '0';
  	  START_WRITE_EVENT_PRIOR_DEL <= '0';
  	  START_WRITE_GPS_COUNT_PRIOR_DEL <= '0';
  	  START_WRITE_PARAMETER_LIST_PRIOR_DEL <= '0';
  	  START_WRITE_READ_ERROR_PRIOR_DEL <= '0';
  	  START_WRITE_COMP_DATA_PRIOR_DEL <= '0';
  	  WRITE_GPS_MODE_DEL <= '0';
  	  WR_GPS_DATA_ENABLE_DEL <= '0';
  	  WRITE_PARAMETER_LIST_MODE_DEL <= '0';
  	  WR_PARAMETER_LIST_ENABLE_DEL <= '0';
  	  WRITE_READ_ERROR_MODE_DEL <= '0';
  	  WR_READ_ERROR_ENABLE_DEL <= '0';
  	  WRITE_COMP_MODE_DEL <= '0';
  	  WR_COMP_DATA_ENABLE_DEL <= '0';
    elsif (CLKRD'event and CLKRD = '1') then 
  	  WRITE_EVENT_MODE_DEL <= WRITE_EVENT_MODE;
  	  WRITE_ENABLE_ADDITIONAL_DATA_DEL1 <= WRITE_ENABLE_ADDITIONAL_DATA;
  	  EVENT_READOUT_BUSY_DEL <= EVENT_READOUT_BUSY;
  	  WR_END_BYTE_ENABLE_DEL1 <= WR_END_BYTE_ENABLE;
  	  START_WRITE_EVENT_PRIOR_DEL <= START_WRITE_EVENT_PRIOR;
  	  START_WRITE_GPS_COUNT_PRIOR_DEL <= START_WRITE_GPS_COUNT_PRIOR;
  	  START_WRITE_PARAMETER_LIST_PRIOR_DEL <= START_WRITE_PARAMETER_LIST_PRIOR;
  	  START_WRITE_READ_ERROR_PRIOR_DEL <= START_WRITE_READ_ERROR_PRIOR;
  	  START_WRITE_COMP_DATA_PRIOR_DEL <= START_WRITE_COMP_DATA_PRIOR;
  	  WRITE_GPS_MODE_DEL <= WRITE_GPS_MODE;
  	  WR_GPS_DATA_ENABLE_DEL <= WR_GPS_DATA_ENABLE;
  	  WRITE_PARAMETER_LIST_MODE_DEL <= WRITE_PARAMETER_LIST_MODE;
  	  WR_PARAMETER_LIST_ENABLE_DEL <= WR_PARAMETER_LIST_ENABLE;
  	  WRITE_READ_ERROR_MODE_DEL <= WRITE_READ_ERROR_MODE;
  	  WR_READ_ERROR_ENABLE_DEL <= WR_READ_ERROR_ENABLE;
  	  WRITE_COMP_MODE_DEL <= WRITE_COMP_MODE;
  	  WR_COMP_DATA_ENABLE_DEL <= WR_COMP_DATA_ENABLE;
    end if;
  end process;

  process(CLKRD,SYSRST)
  begin
  	if SYSRST = '1' then
  	  TS_ONE_PPS_VALID_IN_DEL <= '0';
  	  START_WRITE_EVENT_DEL <= '0';
  	  PARAMETER_LIST_VALID_DEL <= '0';
  	  READ_ERROR_VALID_DEL <= '0';
  	  COMPDATA_VALID_DEL <= '0';
  	  NEW_DATA_WHILE_READOUT <= '0';
    elsif (CLKRD'event and CLKRD = '1') then 
  	  TS_ONE_PPS_VALID_IN_DEL <= TS_ONE_PPS_VALID_IN;
  	  START_WRITE_EVENT_DEL <= START_WRITE_EVENT;
  	  PARAMETER_LIST_VALID_DEL <= PARAMETER_LIST_VALID;
  	  READ_ERROR_VALID_DEL <= READ_ERROR_VALID;
  	  COMPDATA_VALID_DEL <= COMPDATA_VALID;
  	  if USB_WRITE_BUSY_TMP = '1' and 
  	   ((TS_ONE_PPS_VALID_IN = '1' and TS_ONE_PPS_VALID_IN_DEL = '0') or 
  	    (START_WRITE_EVENT = '1' and START_WRITE_EVENT_DEL = '0') or 
  	    (PARAMETER_LIST_VALID = '1' and PARAMETER_LIST_VALID_DEL = '0') or 
  	    (READ_ERROR_VALID = '1' and READ_ERROR_VALID_DEL = '0') or 
  	    (COMPDATA_VALID = '1' and COMPDATA_VALID_DEL = '0')) then
  	    NEW_DATA_WHILE_READOUT <= '1';
  	  else   
  	    NEW_DATA_WHILE_READOUT <= '0';
      end if;
    end if;
  end process;
 
  process(CLK10MHz,SYSRST)
  begin
  	if SYSRST = '1' then
      WR_ADDITIONAL_DATA_DEL <= '0';
      WR_END_BYTE_DEL <= '0';
      WR_GPS_DATA_DEL <= '0';
      WR_PARAMETER_LIST_DEL <= '0';
      WR_READ_ERROR_DEL <= '0';
      WR_COMP_DATA_DEL <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then 
  	  WR_ADDITIONAL_DATA_DEL <= WR_ADDITIONAL_DATA;
  	  WR_END_BYTE_DEL <= WR_END_BYTE;
  	  WR_GPS_DATA_DEL <= WR_GPS_DATA;
  	  WR_PARAMETER_LIST_DEL <= WR_PARAMETER_LIST;
  	  WR_READ_ERROR_DEL <= WR_READ_ERROR;
  	  WR_COMP_DATA_DEL <= WR_COMP_DATA;
    end if;
  end process;

  -- Priority encoding for writing to USB
  process(CLKRD,SYSRST)
  begin
  	if SYSRST = '1' then
   	  START_WRITE_EVENT_PRIOR <= '0';
      START_WRITE_GPS_COUNT_PRIOR <= '0'; 
      START_WRITE_PARAMETER_LIST_PRIOR <= '0'; 
      START_WRITE_READ_ERROR_PRIOR <= '0'; 
      START_WRITE_COMP_DATA_PRIOR <= '0'; 
      USB_BUSYHOLD_COUNT <= "0000"; 
    elsif (CLKRD'event and CLKRD = '1') then
      if USB_WRITE_ENABLE = '1' then 
        if USB_WRITE_BUSY_TMP = '0' then  -- if there is no writing to USB
          if USB_BUSYHOLD_COUNT > "1000" then 
            USB_BUSYHOLD_COUNT <= USB_BUSYHOLD_COUNT; 
            if TS_ONE_PPS_VALID_IN = '1' then -- Start WRITE_GPS_MODE
              START_WRITE_GPS_COUNT_PRIOR <= '1'; 
            elsif START_WRITE_EVENT = '1' then -- Start WRITE_EVENT_MODE
              START_WRITE_EVENT_PRIOR <= '1'; 
            elsif COMPDATA_VALID = '1' then -- Start WRITE_COMP_MODE
              START_WRITE_COMP_DATA_PRIOR <= '1'; 
            elsif PARAMETER_LIST_VALID = '1' then -- Start WRITE_PARAMETER_LIST_MODE
              START_WRITE_PARAMETER_LIST_PRIOR <= '1'; 
            elsif READ_ERROR_VALID = '1' then -- Start WRITE_READ_ERROR_MODE
              START_WRITE_READ_ERROR_PRIOR <= '1'; 
            end if;
          else
            USB_BUSYHOLD_COUNT <= USB_BUSYHOLD_COUNT + "0001"; 
          end if;
	      else  
	  	    START_WRITE_EVENT_PRIOR <= '0';
	        START_WRITE_GPS_COUNT_PRIOR <= '0'; 
	        START_WRITE_PARAMETER_LIST_PRIOR <= '0'; 
	        START_WRITE_READ_ERROR_PRIOR <= '0'; 
	        START_WRITE_COMP_DATA_PRIOR <= '0'; 
          USB_BUSYHOLD_COUNT <= "0000"; 
	      end if;
      end if;
    end if;
  end process;

---------------------------------- Write event data --------------------------------------------------
  process(CLKRD,SYSRST)
  begin
  	if SYSRST = '1' then
  	  WRITE_EVENT_MODE <= '0';
    elsif (CLKRD'event and CLKRD = '1') then 
  	  if WR_END_BYTE_ENABLE = '0' and WR_END_BYTE_ENABLE_DEL1 = '1' then -- At downgoing edge of WR_END_BYTE_ENABLE
  	    WRITE_EVENT_MODE <= '0';
      elsif WRITE_EVENT_MODE = '1' then -- WRITE_EVENT_MODE locks itself
  	    WRITE_EVENT_MODE <= WRITE_EVENT_MODE;
      elsif START_WRITE_EVENT_PRIOR = '1' and START_WRITE_EVENT_PRIOR_DEL = '0' then -- Start WRITE_EVENT_MODE
  	    WRITE_EVENT_MODE <= '1';
      end if;
    end if;
  end process;

  -- Write ADDITIONAL_DATA
  process(CLK10MHz,SYSRST)
  begin
  	if SYSRST = '1' then
  	  ADDITIONAL_DATA_COUNT <= 22;
    elsif (CLK10MHz'event and CLK10MHz = '1') then 
      if WRITE_EVENT_MODE = '1' and WRITE_EVENT_MODE_DEL = '0' then  -- upgoing edge of WRITE_EVENT_MODE
  	    ADDITIONAL_DATA_COUNT <= 22;
      elsif WR_ADDITIONAL_DATA = '1' and WR_ADDITIONAL_DATA_DEL = '0' then  -- upgoing edge of WR_ADDITIONAL_DATA
        ADDITIONAL_DATA_COUNT <= ADDITIONAL_DATA_COUNT - 1;
      end if;
    end if;
  end process;

  process(CLK10MHz,SYSRST)
  begin
  	if SYSRST = '1' then
  	  WRITE_ENABLE_ADDITIONAL_DATA <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then 
      if WRITE_EVENT_MODE = '1' and WRITE_EVENT_MODE_DEL = '0' then  -- upgoing edge of WRITE_EVENT_MODE
  	    WRITE_ENABLE_ADDITIONAL_DATA <= '1';
      elsif WR_ADDITIONAL_DATA = '0' and WR_ADDITIONAL_DATA_DEL = '1' and ADDITIONAL_DATA_COUNT = 0 then  -- downgoing edge of WR_ADDITIONAL_DATA
  	    WRITE_ENABLE_ADDITIONAL_DATA <= '0';
      end if;
    end if;
  end process;

  -- Write event data
  process(CLKRD,SYSRST)
  begin
  	if SYSRST = '1' then
  	  SEND_EVENT_DATA_TMP <= '0';
    elsif (CLKRD'event and CLKRD = '1') then 
      if WRITE_ENABLE_ADDITIONAL_DATA = '0' and WRITE_ENABLE_ADDITIONAL_DATA_DEL1 = '1' then  -- downgoing edge of WRITE_ENABLE_TRIGGER_PATTERN
  	    SEND_EVENT_DATA_TMP <= '1';
      elsif EVENT_READOUT_BUSY = '0' and EVENT_READOUT_BUSY_DEL = '1' then  -- downgoing edge of EVENT_READOUT_BUSY
  	    SEND_EVENT_DATA_TMP <= '0';
      end if;
    end if;
  end process;

  -- Write end byte
  process(CLK10MHz,SYSRST)
  begin
  	if SYSRST = '1' then
  	  WR_END_BYTE_ENABLE <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then 
      if EVENT_READOUT_BUSY = '0' and EVENT_READOUT_BUSY_DEL = '1' then  -- downgoing edge of EVENT_READOUT_BUSY
  	    WR_END_BYTE_ENABLE <= '1';
      elsif WR_END_BYTE = '0' and WR_END_BYTE_DEL = '1' then  -- downgoing edge of WR_END_BYTE
  	    WR_END_BYTE_ENABLE <= '0';
      end if;
    end if;
  end process;


  process(CLKRD,SYSRST)
  begin
  	if SYSRST = '1' then
  	  USB_WRITE_HOLDOFF_COUNTER <= "0000000";
  	  WR_TMP <= '0';
    elsif (CLKRD'event and CLKRD = '1') then 
  	  if USB_WR_EN = '1' and USB_WRITE_HOLDOFF_COUNTER = "0000000" then
   	    if USB_TXE = '0' then
          WR_TMP <= not WR_TMP;
        else  
          WR_TMP <= '0';
		end if;
	  else 
        WR_TMP <= '0';
      end if;
  	  USB_WRITE_HOLDOFF_COUNTER <= USB_WRITE_HOLDOFF_COUNTER + "0000001";
    end if;
  end process;

  process(ADDITIONAL_DATA_COUNT,TR_CONDITION,TRIGGER_PATTERN,PRE_TIME,COINC_TIME,POST_TIME,GPS_TS_IN,CTD_IN)
  begin
    case (ADDITIONAL_DATA_COUNT) is
      when 21 => ADDITIONAL_DATA_TMP <= "10011001"; -- 99h
      when 20 => ADDITIONAL_DATA_TMP <= "10100000"; -- A0h
      when 19 => ADDITIONAL_DATA_TMP <= TR_CONDITION; 
      when 18 => ADDITIONAL_DATA_TMP <= TRIGGER_PATTERN(15 downto 8); 
      when 17 => ADDITIONAL_DATA_TMP <= TRIGGER_PATTERN(7 downto 0); 
      when 16 => ADDITIONAL_DATA_TMP <= PRE_TIME(15 downto 8); 
      when 15 => ADDITIONAL_DATA_TMP <= PRE_TIME(7 downto 0); 
      when 14 => ADDITIONAL_DATA_TMP <= COINC_TIME(15 downto 8); 
      when 13 => ADDITIONAL_DATA_TMP <= COINC_TIME(7 downto 0); 
      when 12 => ADDITIONAL_DATA_TMP <= POST_TIME(15 downto 8); 
      when 11 => ADDITIONAL_DATA_TMP <= POST_TIME(7 downto 0); 
      when 10 => ADDITIONAL_DATA_TMP <= GPS_TS_IN(55 downto 48); 
      when 9 => ADDITIONAL_DATA_TMP <= GPS_TS_IN(47 downto 40); 
      when 8 => ADDITIONAL_DATA_TMP <= GPS_TS_IN(39 downto 32); 
      when 7 => ADDITIONAL_DATA_TMP <= GPS_TS_IN(31 downto 24); 
      when 6 => ADDITIONAL_DATA_TMP <= GPS_TS_IN(23 downto 16); 
      when 5 => ADDITIONAL_DATA_TMP <= GPS_TS_IN(15 downto 8); 
      when 4 => ADDITIONAL_DATA_TMP <= GPS_TS_IN(7 downto 0); 
      when 3 => ADDITIONAL_DATA_TMP <= CTD_IN(31 downto 24); 
      when 2 => ADDITIONAL_DATA_TMP <= CTD_IN(23 downto 16); 
      when 1 => ADDITIONAL_DATA_TMP <= CTD_IN(15 downto 8); 
      when 0 => ADDITIONAL_DATA_TMP <= CTD_IN(7 downto 0); 
      when others => ADDITIONAL_DATA_TMP <= "00000000";
    end case;
  end process;

  process(USB_DATA_MODE_PRE,ADDITIONAL_DATA_TMP,EVENT_DATA_IN)
  begin
    case (USB_DATA_MODE_PRE) is
      when "001" => USB_DATA_PRE <= ADDITIONAL_DATA_TMP; 
      when "010" => USB_DATA_PRE <= EVENT_DATA_IN; 
      when "100" => USB_DATA_PRE <= "01100110"; -- 66h
      when others => USB_DATA_PRE <= "00000000";
    end case;
  end process;


---------------------------------- GPS counter data --------------------------------------------------
  process(CLKRD,SYSRST)
  begin
  	if SYSRST = '1' then
  	  WRITE_GPS_MODE <= '0';
    elsif (CLKRD'event and CLKRD = '1') then 
      if WR_GPS_DATA_ENABLE = '0' and WR_GPS_DATA_ENABLE_DEL = '1' then -- At downgoing edge of WR_GPS_DATA_ENABLE
  	    WRITE_GPS_MODE <= '0';
      elsif WRITE_GPS_MODE = '1' then -- WRITE_GPS_MODE locks itself
  	    WRITE_GPS_MODE <= WRITE_GPS_MODE;
      elsif START_WRITE_GPS_COUNT_PRIOR = '1' and START_WRITE_GPS_COUNT_PRIOR_DEL = '0' then -- Start WRITE_GPS_MODE
  	    WRITE_GPS_MODE <= '1';
      end if;
    end if;
  end process;

  process(CLK10MHz,SYSRST)
  begin
  	if SYSRST = '1' then
  	  GPS_DATA_COUNT <= 87;
    elsif (CLK10MHz'event and CLK10MHz = '1') then 
      if WRITE_GPS_MODE = '1' and WRITE_GPS_MODE_DEL = '0' then  -- upgoing edge of WRITE_GPS_MODE
  	    GPS_DATA_COUNT <= 87;
      elsif WR_GPS_DATA = '1' and WR_GPS_DATA_DEL = '0' then  -- upgoing edge of WR_GPS_DATA
        GPS_DATA_COUNT <= GPS_DATA_COUNT - 1;
      end if;
    end if;
  end process;

  process(CLK10MHz,SYSRST)
  begin
  	if SYSRST = '1' then
  	  WR_GPS_DATA_ENABLE <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then 
      if WRITE_GPS_MODE = '1' and WRITE_GPS_MODE_DEL = '0' then  -- upgoing edge of WRITE_GPS_MODE
  	    WR_GPS_DATA_ENABLE <= '1';
      elsif WR_GPS_DATA = '0' and WR_GPS_DATA_DEL = '1' and GPS_DATA_COUNT = 0 then  -- downgoing edge of WR_GPS_DATA
  	    WR_GPS_DATA_ENABLE <= '0';
      end if;
    end if;
  end process;

  process(GPS_DATA_COUNT,GPS_TS_ONE_PPS,CTP_TS_ONE_PPS,CTD_TS_ONE_PPS,TH_COUNTERS_IN,SAT_INFO)
  begin
    case (GPS_DATA_COUNT) is
      when 86 => GPS_DATA_TMP <= "10011001"; -- 99h
      when 85 => GPS_DATA_TMP <= "10100100"; -- A4h
      when 84 => GPS_DATA_TMP <= GPS_TS_ONE_PPS(55 downto 48); 
      when 83 => GPS_DATA_TMP <= GPS_TS_ONE_PPS(47 downto 40); 
      when 82 => GPS_DATA_TMP <= GPS_TS_ONE_PPS(39 downto 32); 
      when 81 => GPS_DATA_TMP <= GPS_TS_ONE_PPS(31 downto 24); 
      when 80 => GPS_DATA_TMP <= GPS_TS_ONE_PPS(23 downto 16); 
      when 79 => GPS_DATA_TMP <= GPS_TS_ONE_PPS(15 downto 8); 
      when 78 => GPS_DATA_TMP <= GPS_TS_ONE_PPS(7 downto 0); 
      when 77 => GPS_DATA_TMP <= CTP_TS_ONE_PPS(31 downto 24); 
      when 76 => GPS_DATA_TMP <= CTP_TS_ONE_PPS(23 downto 16); 
      when 75 => GPS_DATA_TMP <= CTP_TS_ONE_PPS(15 downto 8); 
      when 74 => GPS_DATA_TMP <= CTP_TS_ONE_PPS(7 downto 0); 
      when 73 => GPS_DATA_TMP <= CTD_TS_ONE_PPS(31 downto 24); 
      when 72 => GPS_DATA_TMP <= CTD_TS_ONE_PPS(23 downto 16); 
      when 71 => GPS_DATA_TMP <= CTD_TS_ONE_PPS(15 downto 8); 
      when 70 => GPS_DATA_TMP <= CTD_TS_ONE_PPS(7 downto 0); 
      when 69 => GPS_DATA_TMP <= TH_COUNTERS_IN(63 downto 56); 
      when 68 => GPS_DATA_TMP <= TH_COUNTERS_IN(55 downto 48); 
      when 67 => GPS_DATA_TMP <= TH_COUNTERS_IN(47 downto 40); 
      when 66 => GPS_DATA_TMP <= TH_COUNTERS_IN(39 downto 32); 
      when 65 => GPS_DATA_TMP <= TH_COUNTERS_IN(31 downto 24); 
      when 64 => GPS_DATA_TMP <= TH_COUNTERS_IN(23 downto 16); 
      when 63 => GPS_DATA_TMP <= TH_COUNTERS_IN(15 downto 8); 
      when 62 => GPS_DATA_TMP <= TH_COUNTERS_IN(7 downto 0); 
      when 61 => GPS_DATA_TMP <= SAT_INFO(487 downto 480); 
      when 60 => GPS_DATA_TMP <= SAT_INFO(479 downto 472); 
      when 59 => GPS_DATA_TMP <= SAT_INFO(471 downto 464); 
      when 58 => GPS_DATA_TMP <= SAT_INFO(463 downto 456); 
      when 57 => GPS_DATA_TMP <= SAT_INFO(455 downto 448); 
      when 56 => GPS_DATA_TMP <= SAT_INFO(447 downto 440); 
      when 55 => GPS_DATA_TMP <= SAT_INFO(439 downto 432); 
      when 54 => GPS_DATA_TMP <= SAT_INFO(431 downto 424); 
      when 53 => GPS_DATA_TMP <= SAT_INFO(423 downto 416); 
      when 52 => GPS_DATA_TMP <= SAT_INFO(415 downto 408); 
      when 51 => GPS_DATA_TMP <= SAT_INFO(407 downto 400); 
      when 50 => GPS_DATA_TMP <= SAT_INFO(399 downto 392); 
      when 49 => GPS_DATA_TMP <= SAT_INFO(391 downto 384); 
      when 48 => GPS_DATA_TMP <= SAT_INFO(383 downto 376); 
      when 47 => GPS_DATA_TMP <= SAT_INFO(375 downto 368); 
      when 46 => GPS_DATA_TMP <= SAT_INFO(367 downto 360); 
      when 45 => GPS_DATA_TMP <= SAT_INFO(359 downto 352); 
      when 44 => GPS_DATA_TMP <= SAT_INFO(351 downto 344); 
      when 43 => GPS_DATA_TMP <= SAT_INFO(343 downto 336); 
      when 42 => GPS_DATA_TMP <= SAT_INFO(335 downto 328); 
      when 41 => GPS_DATA_TMP <= SAT_INFO(327 downto 320); 
      when 40 => GPS_DATA_TMP <= SAT_INFO(319 downto 312); 
      when 39 => GPS_DATA_TMP <= SAT_INFO(311 downto 304); 
      when 38 => GPS_DATA_TMP <= SAT_INFO(303 downto 296); 
      when 37 => GPS_DATA_TMP <= SAT_INFO(295 downto 288); 
      when 36 => GPS_DATA_TMP <= SAT_INFO(287 downto 280); 
      when 35 => GPS_DATA_TMP <= SAT_INFO(279 downto 272); 
      when 34 => GPS_DATA_TMP <= SAT_INFO(271 downto 264); 
      when 33 => GPS_DATA_TMP <= SAT_INFO(263 downto 256); 
      when 32 => GPS_DATA_TMP <= SAT_INFO(255 downto 248); 
      when 31 => GPS_DATA_TMP <= SAT_INFO(247 downto 240); 
      when 30 => GPS_DATA_TMP <= SAT_INFO(239 downto 232); 
      when 29 => GPS_DATA_TMP <= SAT_INFO(231 downto 224); 
      when 28 => GPS_DATA_TMP <= SAT_INFO(223 downto 216); 
      when 27 => GPS_DATA_TMP <= SAT_INFO(215 downto 208); 
      when 26 => GPS_DATA_TMP <= SAT_INFO(207 downto 200); 
      when 25 => GPS_DATA_TMP <= SAT_INFO(199 downto 192); 
      when 24 => GPS_DATA_TMP <= SAT_INFO(191 downto 184); 
      when 23 => GPS_DATA_TMP <= SAT_INFO(183 downto 176); 
      when 22 => GPS_DATA_TMP <= SAT_INFO(175 downto 168); 
      when 21 => GPS_DATA_TMP <= SAT_INFO(167 downto 160); 
      when 20 => GPS_DATA_TMP <= SAT_INFO(159 downto 152); 
      when 19 => GPS_DATA_TMP <= SAT_INFO(151 downto 144); 
      when 18 => GPS_DATA_TMP <= SAT_INFO(143 downto 136); 
      when 17 => GPS_DATA_TMP <= SAT_INFO(135 downto 128); 
      when 16 => GPS_DATA_TMP <= SAT_INFO(127 downto 120); 
      when 15 => GPS_DATA_TMP <= SAT_INFO(119 downto 112); 
      when 14 => GPS_DATA_TMP <= SAT_INFO(111 downto 104); 
      when 13 => GPS_DATA_TMP <= SAT_INFO(103 downto 96); 
      when 12 => GPS_DATA_TMP <= SAT_INFO(95 downto 88); 
      when 11 => GPS_DATA_TMP <= SAT_INFO(87 downto 80); 
      when 10 => GPS_DATA_TMP <= SAT_INFO(79 downto 72); 
      when 9 => GPS_DATA_TMP <= SAT_INFO(71 downto 64); 
      when 8 => GPS_DATA_TMP <= SAT_INFO(63 downto 56); 
      when 7 => GPS_DATA_TMP <= SAT_INFO(55 downto 48); 
      when 6 => GPS_DATA_TMP <= SAT_INFO(47 downto 40); 
      when 5 => GPS_DATA_TMP <= SAT_INFO(39 downto 32); 
      when 4 => GPS_DATA_TMP <= SAT_INFO(31 downto 24); 
      when 3 => GPS_DATA_TMP <= SAT_INFO(23 downto 16); 
      when 2 => GPS_DATA_TMP <= SAT_INFO(15 downto 8); 
      when 1 => GPS_DATA_TMP <= SAT_INFO(7 downto 0); 
      when 0 => GPS_DATA_TMP <= "01100110"; -- 66h 
      when others => GPS_DATA_TMP <= "00000000";
    end case;
  end process;

---------------------------------- Comparator data --------------------------------------------------
  process(CLKRD,SYSRST)
  begin
  	if SYSRST = '1' then
  	  WRITE_COMP_MODE <= '0';
    elsif (CLKRD'event and CLKRD = '1') then 
      if WR_COMP_DATA_ENABLE = '0' and WR_COMP_DATA_ENABLE_DEL = '1' then -- At downgoing edge of WR_COMP_DATA_ENABLE
  	    WRITE_COMP_MODE <= '0';
      elsif WRITE_COMP_MODE = '1' then -- WRITE_GPS_MODE locks itself
  	    WRITE_COMP_MODE <= WRITE_COMP_MODE;
      elsif START_WRITE_COMP_DATA_PRIOR = '1' and START_WRITE_COMP_DATA_PRIOR_DEL = '0' then -- Start WRITE_COMP_MODE
  	    WRITE_COMP_MODE <= '1';
      end if;
    end if;
  end process;

  process(CLK10MHz,SYSRST)
  begin
  	if SYSRST = '1' then
  	  COMP_DATA_COUNT <= 19;
    elsif (CLK10MHz'event and CLK10MHz = '1') then 
      if WRITE_COMP_MODE = '1' and WRITE_COMP_MODE_DEL = '0' then  -- upgoing edge of WRITE_COMP_MODE
  	    COMP_DATA_COUNT <= 19;
      elsif WR_COMP_DATA = '1' and WR_COMP_DATA_DEL = '0' then  -- upgoing edge of WR_COMP_DATA
        COMP_DATA_COUNT <= COMP_DATA_COUNT - 1;
      end if;
    end if;
  end process;

  process(CLK10MHz,SYSRST)
  begin
  	if SYSRST = '1' then
  	  WR_COMP_DATA_ENABLE <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then 
      if WRITE_COMP_MODE = '1' and WRITE_COMP_MODE_DEL = '0' then  -- upgoing edge of WRITE_COMP_MODE
  	    WR_COMP_DATA_ENABLE <= '1';
      elsif WR_COMP_DATA = '0' and WR_COMP_DATA_DEL = '1' and COMP_DATA_COUNT = 0 then  -- downgoing edge of WR_COMP_DATA
  	    WR_COMP_DATA_ENABLE <= '0';
      end if;
    end if;
  end process;

  process(COMP_DATA_COUNT,COMPDATA)
  begin
    case (COMP_DATA_COUNT) is
      when 18 => COMP_DATA_TMP <= "10011001"; -- 99h
      when 17 => COMP_DATA_TMP <= "10100010"; -- A2h
      when 16 => COMP_DATA_TMP <= COMPDATA(127 downto 120); 
      when 15 => COMP_DATA_TMP <= COMPDATA(119 downto 112); 
      when 14 => COMP_DATA_TMP <= COMPDATA(111 downto 104); 
      when 13 => COMP_DATA_TMP <= COMPDATA(103 downto 96); 
      when 12 => COMP_DATA_TMP <= COMPDATA(95 downto 88); 
      when 11 => COMP_DATA_TMP <= COMPDATA(87 downto 80); 
      when 10 => COMP_DATA_TMP <= COMPDATA(79 downto 72); 
      when 9 => COMP_DATA_TMP <= COMPDATA(71 downto 64); 
      when 8 => COMP_DATA_TMP <= COMPDATA(63 downto 56); 
      when 7 => COMP_DATA_TMP <= COMPDATA(55 downto 48); 
      when 6 => COMP_DATA_TMP <= COMPDATA(47 downto 40); 
      when 5 => COMP_DATA_TMP <= COMPDATA(39 downto 32); 
      when 4 => COMP_DATA_TMP <= COMPDATA(31 downto 24); 
      when 3 => COMP_DATA_TMP <= COMPDATA(23 downto 16); 
      when 2 => COMP_DATA_TMP <= COMPDATA(15 downto 8); 
      when 1 => COMP_DATA_TMP <= COMPDATA(7 downto 0); 
      when 0 => COMP_DATA_TMP <= "01100110"; -- 66h 
      when others => COMP_DATA_TMP <= "00000000";
    end case;
  end process;


---------------------------------- PARAMETER_LIST data --------------------------------------------------
  process(CLKRD,SYSRST)
  begin
  	if SYSRST = '1' then
  	  WRITE_PARAMETER_LIST_MODE <= '0';
    elsif (CLKRD'event and CLKRD = '1') then 
      if WR_PARAMETER_LIST_ENABLE = '0' and WR_PARAMETER_LIST_ENABLE_DEL = '1' then -- At downgoing edge of WR_PARAMETER_LIST_ENABLE
  	    WRITE_PARAMETER_LIST_MODE <= '0';
      elsif WRITE_PARAMETER_LIST_MODE = '1' then -- WRITE_PARAMETER_LIST_MODE locks itself
  	    WRITE_PARAMETER_LIST_MODE <= WRITE_PARAMETER_LIST_MODE;
      elsif START_WRITE_PARAMETER_LIST_PRIOR = '1' and START_WRITE_PARAMETER_LIST_PRIOR_DEL = '0' then -- Start WRITE_PARAMETER_LIST_MODE
  	    WRITE_PARAMETER_LIST_MODE <= '1';
      end if;
    end if;
  end process;

  process(CLK10MHz,SYSRST)
  begin
  	if SYSRST = '1' then
  	  PARAMETER_LIST_COUNT <= 79;
    elsif (CLK10MHz'event and CLK10MHz = '1') then 
      if WRITE_PARAMETER_LIST_MODE = '1' and WRITE_PARAMETER_LIST_MODE_DEL = '0' then  -- upgoing edge of WRITE_PARAMETER_LIST_MODE
  	    PARAMETER_LIST_COUNT <= 79;
      elsif WR_PARAMETER_LIST = '1' and WR_PARAMETER_LIST_DEL = '0' then  -- upgoing edge of WR_PARAMETER_LIST
        PARAMETER_LIST_COUNT <= PARAMETER_LIST_COUNT - 1;
      end if;
    end if;
  end process;

  process(CLK10MHz,SYSRST)
  begin
  	if SYSRST = '1' then
  	  WR_PARAMETER_LIST_ENABLE <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then 
      if WRITE_PARAMETER_LIST_MODE = '1' and WRITE_PARAMETER_LIST_MODE_DEL = '0' then  -- upgoing edge of WRITE_PARAMETER_LIST_MODE
  	    WR_PARAMETER_LIST_ENABLE <= '1';
      elsif WR_PARAMETER_LIST = '0' and WR_PARAMETER_LIST_DEL = '1' and PARAMETER_LIST_COUNT = 0 then  -- downgoing edge of WR_PARAMETER_LIST
  	    WR_PARAMETER_LIST_ENABLE <= '0';
      end if;
    end if;
  end process;

  process(PARAMETER_LIST_COUNT,PARAMETER_LIST,TR_CONDITION,PRE_TIME,COINC_TIME,POST_TIME,GPS_TS_ONE_PPS,LONGITUDE,LATITUDE,ALTITUDE,TEMP)
  begin
    case (PARAMETER_LIST_COUNT) is
      when 78 => PARAMETER_LIST_TMP <= "10011001"; -- 99h
      when 77 => PARAMETER_LIST_TMP <= "01010101"; -- 55h
      when 76 => PARAMETER_LIST_TMP <= PARAMETER_LIST(7 downto 0);-- CH1_OFFSET_ADJ_POS 
      when 75 => PARAMETER_LIST_TMP <= PARAMETER_LIST(15 downto 8);-- CH1_OFFSET_ADJ_NEG 
      when 74 => PARAMETER_LIST_TMP <= PARAMETER_LIST(23 downto 16);-- CH2_OFFSET_ADJ_POS 
      when 73 => PARAMETER_LIST_TMP <= PARAMETER_LIST(31 downto 24);-- CH2_OFFSET_ADJ_NEG 
      when 72 => PARAMETER_LIST_TMP <= PARAMETER_LIST(39 downto 32);-- CH1_GAIN_ADJ_POS 
      when 71 => PARAMETER_LIST_TMP <= PARAMETER_LIST(47 downto 40);-- CH1_GAIN_ADJ_NEG 
      when 70 => PARAMETER_LIST_TMP <= PARAMETER_LIST(55 downto 48);-- CH2_GAIN_ADJ_POS 
      when 69 => PARAMETER_LIST_TMP <= PARAMETER_LIST(63 downto 56);-- CH2_GAIN_ADJ_NEG 
      when 68 => PARAMETER_LIST_TMP <= PARAMETER_LIST(71 downto 64);-- COMMON_OFFSET_ADJ 
      when 67 => PARAMETER_LIST_TMP <= PARAMETER_LIST(79 downto 72);-- FULL_SCALE_ADJ 
      when 66 => PARAMETER_LIST_TMP <= PARAMETER_LIST(87 downto 80);-- CH1_INTEGRATOR 
      when 65 => PARAMETER_LIST_TMP <= PARAMETER_LIST(95 downto 88);-- CH2_INTEGRATOR 
      when 64 => PARAMETER_LIST_TMP <= PARAMETER_LIST(103 downto 96);-- COMP_THRES_LOW 
      when 63 => PARAMETER_LIST_TMP <= PARAMETER_LIST(111 downto 104);-- COMP_THRES_HIGH 
      when 62 => PARAMETER_LIST_TMP <= PARAMETER_LIST(119 downto 112);-- CH1_PMT_HV_ADJ 
      when 61 => PARAMETER_LIST_TMP <= PARAMETER_LIST(127 downto 120);-- CH2_PMT_HV_ADJ 
      when 60 => PARAMETER_LIST_TMP <= PARAMETER_LIST(143 downto 136);-- CH1_THRES_LOW - higher byte
      when 59 => PARAMETER_LIST_TMP <= PARAMETER_LIST(135 downto 128);-- CH1_THRES_LOW - lower byte
      when 58 => PARAMETER_LIST_TMP <= PARAMETER_LIST(159 downto 152);-- CH1_THRES_HIGH - higher byte 
      when 57 => PARAMETER_LIST_TMP <= PARAMETER_LIST(151 downto 144);-- CH1_THRES_HIGH - lower byte 
      when 56 => PARAMETER_LIST_TMP <= PARAMETER_LIST(175 downto 168);-- CH2_THRES_LOW - higher byte 
      when 55 => PARAMETER_LIST_TMP <= PARAMETER_LIST(167 downto 160);-- CH2_THRES_LOW - lower byte 
      when 54 => PARAMETER_LIST_TMP <= PARAMETER_LIST(191 downto 184);-- CH2_THRES_HIGH - higher byte 
      when 53 => PARAMETER_LIST_TMP <= PARAMETER_LIST(183 downto 176);-- CH2_THRES_HIGH - lower byte 
      when 52 => PARAMETER_LIST_TMP <= TR_CONDITION; 
      when 51 => PARAMETER_LIST_TMP <= PRE_TIME(15 downto 8); 
      when 50 => PARAMETER_LIST_TMP <= PRE_TIME(7 downto 0); 
      when 49 => PARAMETER_LIST_TMP <= COINC_TIME(15 downto 8); 
      when 48 => PARAMETER_LIST_TMP <= COINC_TIME(7 downto 0); 
      when 47 => PARAMETER_LIST_TMP <= POST_TIME(15 downto 8); 
      when 46 => PARAMETER_LIST_TMP <= POST_TIME(7 downto 0); 
      when 45 => PARAMETER_LIST_TMP <= PARAMETER_LIST(199 downto 192);-- STATUS 
      when 44 => PARAMETER_LIST_TMP <= PARAMETER_LIST(231 downto 224);-- SPARE_BYTES - highest byte 
      when 43 => PARAMETER_LIST_TMP <= PARAMETER_LIST(223 downto 216); 
      when 42 => PARAMETER_LIST_TMP <= PARAMETER_LIST(215 downto 208); 
      when 41 => PARAMETER_LIST_TMP <= PARAMETER_LIST(207 downto 200);-- SPARE_BYTES - lowest byte 
      when 40 => PARAMETER_LIST_TMP <= PARAMETER_LIST(239 downto 232);-- CH1_PMT_SUPPLY_CURR 
      when 39 => PARAMETER_LIST_TMP <= PARAMETER_LIST(247 downto 240);-- CH2_PMT_SUPPLY_CURR 
      when 38 => PARAMETER_LIST_TMP <= GPS_TS_ONE_PPS(55 downto 48); 
      when 37 => PARAMETER_LIST_TMP <= GPS_TS_ONE_PPS(47 downto 40); 
      when 36 => PARAMETER_LIST_TMP <= GPS_TS_ONE_PPS(39 downto 32); 
      when 35 => PARAMETER_LIST_TMP <= GPS_TS_ONE_PPS(31 downto 24); 
      when 34 => PARAMETER_LIST_TMP <= GPS_TS_ONE_PPS(23 downto 16); 
      when 33 => PARAMETER_LIST_TMP <= GPS_TS_ONE_PPS(15 downto 8); 
      when 32 => PARAMETER_LIST_TMP <= GPS_TS_ONE_PPS(7 downto 0); 
      when 31 => PARAMETER_LIST_TMP <= LONGITUDE(63 downto 56); 
      when 30 => PARAMETER_LIST_TMP <= LONGITUDE(55 downto 48); 
      when 29 => PARAMETER_LIST_TMP <= LONGITUDE(47 downto 40); 
      when 28 => PARAMETER_LIST_TMP <= LONGITUDE(39 downto 32); 
      when 27 => PARAMETER_LIST_TMP <= LONGITUDE(31 downto 24); 
      when 26 => PARAMETER_LIST_TMP <= LONGITUDE(23 downto 16); 
      when 25 => PARAMETER_LIST_TMP <= LONGITUDE(15 downto 8); 
      when 24 => PARAMETER_LIST_TMP <= LONGITUDE(7 downto 0); 
      when 23 => PARAMETER_LIST_TMP <= LATITUDE(63 downto 56); 
      when 22 => PARAMETER_LIST_TMP <= LATITUDE(55 downto 48); 
      when 21 => PARAMETER_LIST_TMP <= LATITUDE(47 downto 40); 
      when 20 => PARAMETER_LIST_TMP <= LATITUDE(39 downto 32); 
      when 19 => PARAMETER_LIST_TMP <= LATITUDE(31 downto 24); 
      when 18 => PARAMETER_LIST_TMP <= LATITUDE(23 downto 16); 
      when 17 => PARAMETER_LIST_TMP <= LATITUDE(15 downto 8); 
      when 16 => PARAMETER_LIST_TMP <= LATITUDE(7 downto 0); 
      when 15 => PARAMETER_LIST_TMP <= ALTITUDE(63 downto 56); 
      when 14 => PARAMETER_LIST_TMP <= ALTITUDE(55 downto 48); 
      when 13 => PARAMETER_LIST_TMP <= ALTITUDE(47 downto 40); 
      when 12 => PARAMETER_LIST_TMP <= ALTITUDE(39 downto 32); 
      when 11 => PARAMETER_LIST_TMP <= ALTITUDE(31 downto 24); 
      when 10 => PARAMETER_LIST_TMP <= ALTITUDE(23 downto 16); 
      when 9 => PARAMETER_LIST_TMP <= ALTITUDE(15 downto 8); 
      when 8 => PARAMETER_LIST_TMP <= ALTITUDE(7 downto 0); 
      when 7 => PARAMETER_LIST_TMP <= TEMP(31 downto 24); 
      when 6 => PARAMETER_LIST_TMP <= TEMP(23 downto 16); 
      when 5 => PARAMETER_LIST_TMP <= TEMP(15 downto 8); 
      when 4 => PARAMETER_LIST_TMP <= TEMP(7 downto 0); 
      when 3 => PARAMETER_LIST_TMP <= PARAMETER_LIST(271 downto 264);-- VERSION - highest byte 
      when 2 => PARAMETER_LIST_TMP <= PARAMETER_LIST(263 downto 256); 
      when 1 => PARAMETER_LIST_TMP <= PARAMETER_LIST(255 downto 248);-- VERSION - lowest byte 
      when 0 => PARAMETER_LIST_TMP <= "01100110"; -- 66h 
      when others => PARAMETER_LIST_TMP <= "00000000";
    end case;
  end process;

---------------------------------- READ_ERROR data --------------------------------------------------
  process(CLKRD,SYSRST)
  begin
  	if SYSRST = '1' then
  	  WRITE_READ_ERROR_MODE <= '0';
    elsif (CLKRD'event and CLKRD = '1') then 
      if WR_READ_ERROR_ENABLE = '0' and WR_READ_ERROR_ENABLE_DEL = '1' then -- At downgoing edge of WR_READ_ERROR_ENABLE
  	    WRITE_READ_ERROR_MODE <= '0';
      elsif WRITE_READ_ERROR_MODE = '1' then -- WRITE_READ_ERROR_MODE locks itself
  	    WRITE_READ_ERROR_MODE <= WRITE_READ_ERROR_MODE;
      elsif START_WRITE_READ_ERROR_PRIOR = '1' and START_WRITE_READ_ERROR_PRIOR_DEL = '0' then -- Start WRITE_READ_ERROR_MODE
  	    WRITE_READ_ERROR_MODE <= '1';
      end if;
    end if;
  end process;

  process(CLK10MHz,SYSRST)
  begin
  	if SYSRST = '1' then
  	  READ_ERROR_COUNT <= 4;
    elsif (CLK10MHz'event and CLK10MHz = '1') then 
      if WRITE_READ_ERROR_MODE = '1' and WRITE_READ_ERROR_MODE_DEL = '0' then  -- upgoing edge of WRITE_READ_ERROR_MODE
  	    READ_ERROR_COUNT <= 4;
      elsif WR_READ_ERROR = '1' and WR_READ_ERROR_DEL = '0' then  -- upgoing edge of WR_READ_ERROR
        READ_ERROR_COUNT <= READ_ERROR_COUNT - 1;
      end if;
    end if;
  end process;

  process(CLK10MHz,SYSRST)
  begin
  	if SYSRST = '1' then
  	  WR_READ_ERROR_ENABLE <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then 
      if WRITE_READ_ERROR_MODE = '1' and WRITE_READ_ERROR_MODE_DEL = '0' then  -- upgoing edge of WRITE_READ_ERROR_MODE
  	    WR_READ_ERROR_ENABLE <= '1';
      elsif WR_READ_ERROR = '0' and WR_READ_ERROR_DEL = '1' and READ_ERROR_COUNT = 0 then  -- downgoing edge of WR_READ_ERROR
  	    WR_READ_ERROR_ENABLE <= '0';
      end if;
    end if;
  end process;

  process(READ_ERROR_COUNT,READ_ERROR_DATA)
  begin
    case (READ_ERROR_COUNT) is
      when 3 => READ_ERROR_TMP <= "10011001"; -- 99h
      when 2 => READ_ERROR_TMP <= "10001000"; -- 88h
      when 1 => READ_ERROR_TMP <= READ_ERROR_DATA; 
      when 0 => READ_ERROR_TMP <= "01100110"; -- 66h 
      when others => READ_ERROR_TMP <= "00000000";
    end case;
  end process;

  process(USB_DATA_MODE,USB_DATA_PRE,GPS_DATA_TMP,COMP_DATA_TMP,PARAMETER_LIST_TMP,READ_ERROR_TMP)
  begin
    case (USB_DATA_MODE) is
      when "00001" => USB_DATA <= USB_DATA_PRE; 
      when "00010" => USB_DATA <= GPS_DATA_TMP; 
      when "00100" => USB_DATA <= PARAMETER_LIST_TMP; 
      when "01000" => USB_DATA <= READ_ERROR_TMP; 
      when "10000" => USB_DATA <= COMP_DATA_TMP; 
      when others => USB_DATA <= "00000000";
    end case;
  end process;

  USB_DATA_OUT <= USB_DATA when USB_WRITE_ENABLE = '1' else "ZZZZZZZZ";


    
end rtl ; -- of USB_WRITE_HANDLER

