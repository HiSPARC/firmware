-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'CTD_and_CTP.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'CTD_and_CTP' :
-- 
--   port(
--     CLK200MHz               : in     std_logic;
--     COINC                   : in     std_logic;
--     CTD_OUT                 : out    std_logic_vector(31 downto 0);
--     CTD_TS_ONE_PPS_OUT      : out    std_logic_vector(31 downto 0);
--     CTP_TS_ONE_PPS_OUT      : out    std_logic_vector(31 downto 0);
--     LATITUDE_OUT            : out    std_logic_vector(31 downto 0);
--     LONGITUDE_OUT           : out    std_logic_vector(31 downto 0);
--     ONE_PPS                 : in     std_logic;
--     SYSRST                  : in     std_logic;
--     TS_ONE_PPS_READOUT_DONE : in     std_logic;
--     TS_ONE_PSS_VALID_OUT    : out    std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of CTD_and_CTP is

signal COINC_DEL: std_logic ;
signal CTD_COUNT: std_logic_vector(31 downto 0);
signal CTP_COUNT: std_logic_vector(31 downto 0);
signal LONGITUDE_VALUE: std_logic_vector(31 downto 0);
signal LATITUDE_VALUE: std_logic_vector(31 downto 0);
signal ONE_PPS_DEL1: std_logic ; -- One delay needed to synchronize the asynchronious ONE_PPS with the 200MHz
signal ONE_PPS_DEL2: std_logic ;
signal ONE_PPS_DEL3: std_logic ;
signal TS_ONE_PPS_READOUT_DONE_DEL1: std_logic ; -- One delay needed to synchronize the asynchronious TS_ONE_PPS_READOUT_DONE with the 200MHz
signal TS_ONE_PPS_READOUT_DONE_DEL2: std_logic ;

begin

  CTD_COUNT <= "01000100001100110010001000010001";
  CTP_COUNT <= "11011101110011001011101110101010";
  LONGITUDE_VALUE <= "01000100001100110010001000010001";
  LATITUDE_VALUE <= "11011101110011001011101110101010";

  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COINC_DEL <= '0';        
      ONE_PPS_DEL1 <= '0';        
      ONE_PPS_DEL2 <= '0';        
      ONE_PPS_DEL3 <= '0';        
      TS_ONE_PPS_READOUT_DONE_DEL1 <= '0';        
      TS_ONE_PPS_READOUT_DONE_DEL2 <= '0';        
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      COINC_DEL <= COINC;        
      ONE_PPS_DEL1 <= ONE_PPS;        
      ONE_PPS_DEL2 <= ONE_PPS_DEL1;        
      ONE_PPS_DEL3 <= ONE_PPS_DEL2;        
      TS_ONE_PPS_READOUT_DONE_DEL1 <= TS_ONE_PPS_READOUT_DONE;        
      TS_ONE_PPS_READOUT_DONE_DEL2 <= TS_ONE_PPS_READOUT_DONE_DEL1;        
    end if;
  end process;  


  -- Latch CTD_COUNT on positive edge of COINC
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      CTD_OUT <= "00000000000000000000000000000000";
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COINC = '1' and COINC_DEL = '0' then
        CTD_OUT <= CTD_COUNT;
	  end if;        
    end if;
  end process;  

  -- Latch values on positive edge of ONE_PPS
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      CTD_TS_ONE_PPS_OUT <= "00000000000000000000000000000000";
      CTP_TS_ONE_PPS_OUT <= "00000000000000000000000000000000";
      LONGITUDE_OUT <= "00000000000000000000000000000000";
      LATITUDE_OUT <= "00000000000000000000000000000000";
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if ONE_PPS_DEL1 = '1' and ONE_PPS_DEL2 = '0' then
        CTD_TS_ONE_PPS_OUT <= CTD_COUNT;
        CTP_TS_ONE_PPS_OUT <= CTP_COUNT;
        LONGITUDE_OUT <= LONGITUDE_VALUE;
        LATITUDE_OUT <= LATITUDE_VALUE;
      end if;
    end if;
  end process;  

  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TS_ONE_PSS_VALID_OUT <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if ONE_PPS_DEL2 = '1' and ONE_PPS_DEL3 = '0' then
        TS_ONE_PSS_VALID_OUT <= '1';
      elsif TS_ONE_PPS_READOUT_DONE_DEL1 = '1' and TS_ONE_PPS_READOUT_DONE_DEL2 = '0' then
        TS_ONE_PSS_VALID_OUT <= '0';
      end if;
    end if;
  end process;  

end rtl ; -- of CTD_and_CTP

