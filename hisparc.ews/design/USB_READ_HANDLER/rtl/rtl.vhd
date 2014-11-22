-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'USB_READ_HANDLER.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'USB_READ_HANDLER' :
-- 
--   port(
--     ADC_A0                      : out    std_logic;
--     ADC_A1                      : out    std_logic;
--     ADC_DATA_IN                 : in     std_logic_vector(7 downto 0);
--     ADC_MODE                    : out    std_logic;
--     ADC_nCS                     : out    std_logic;
--     ADC_nINT                    : in     std_logic;
--     ADC_nRD                     : out    std_logic;
--     ADC_nWR_RDY                 : in     std_logic;
--     CLK10MHz                    : in     std_logic;
--     CLKRD                       : in     std_logic;
--     COINC_TIME                  : out    integer range 1000 downto 0;
--     COINC_TIME_OUT              : out    std_logic_vector(15 downto 0);
--     DAC_A0                      : out    std_logic;
--     DAC_A1                      : out    std_logic;
--     DAC_A2                      : out    std_logic;
--     DAC_DATA_0                  : out    std_logic;
--     DAC_DATA_1                  : out    std_logic;
--     DAC_DATA_2                  : out    std_logic;
--     DAC_DATA_3                  : out    std_logic;
--     DAC_DATA_4                  : out    std_logic;
--     DAC_DATA_5                  : out    std_logic;
--     DAC_DATA_6                  : out    std_logic;
--     DAC_DATA_7                  : out    std_logic;
--     DAC_nCLR                    : out    std_logic;
--     DAC_nCS1                    : out    std_logic;
--     DAC_nCS2                    : out    std_logic;
--     DAC_nLDAC                   : out    std_logic;
--     DAC_nRD                     : out    std_logic;
--     DAC_nWR                     : out    std_logic;
--     GPS_PROG_ENABLE             : out    std_logic;
--     MASTER                      : in     std_logic;
--     ONE_PPS                     : in     std_logic;
--     PARAMETER_LIST              : out    std_logic_vector(271 downto 0);
--     PARAMETER_LIST_READOUT_DONE : in     std_logic;
--     PARAMETER_LIST_VALID        : out    std_logic;
--     POST_TIME                   : out    integer range 1600 downto 0;
--     POST_TIME_OUT               : out    std_logic_vector(15 downto 0);
--     PRE_TIME_OUT                : out    std_logic_vector(15 downto 0);
--     READ_ERROR_DATA             : out    std_logic_vector(7 downto 0);
--     READ_ERROR_READOUT_DONE     : in     std_logic;
--     READ_ERROR_VALID            : out    std_logic;
--     SERIAL_NUMBER               : in     std_logic_vector(9 downto 0);
--     SLAVE_PRESENT               : in     std_logic;
--     SOFT_RESET                  : out    std_logic;
--     SYSRST                      : in     std_logic;
--     THH1                        : out    std_logic_vector(11 downto 0);
--     THH2                        : out    std_logic_vector(11 downto 0);
--     THL1                        : out    std_logic_vector(11 downto 0);
--     THL2                        : out    std_logic_vector(11 downto 0);
--     TOTAL_TIME                  : out    integer range 2000 downto 0;
--     TOTAL_TIME_3X               : out    integer range 6000 downto 0;
--     TR_CONDITION                : out    std_logic_vector(7 downto 0);
--     USB_DATA_IN                 : in     std_logic_vector(7 downto 0);
--     USB_RD                      : out    std_logic;
--     USB_RXF                     : in     std_logic;
--     USB_WRITE_BUSY              : in     std_logic;
--     USB_WRITE_ENABLE            : out    std_logic;
--     USB_WRITE_REQUEST           : in     std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of USB_READ_HANDLER is

signal PRE_TIME_SET: integer range 400 downto 0;-- The maximum PRE_TIME_SET can be 2 us. This are 400 steps of 5 ns. 
signal COINC_TIME_SET: integer range 1000 downto 0;-- The maximum COINC_TIME_SET can be 5 us. This are 1000 steps of 5 ns.  
signal POST_TIME_SET: integer range 1600 downto 0;-- The maximum POST_TIME_SET can be 8 us. This are 1600 steps of 5 ns.  
signal TOTAL_TIME_TMP: integer range 2000 downto 0;-- The maximum TOTAL_TIME can be 10 us. This are 2000 steps of 5 ns. 
signal PRE_TIME_LOAD: std_logic_vector(15 downto 0);
signal COINC_TIME_LOAD: std_logic_vector(15 downto 0);
signal POST_TIME_LOAD: std_logic_vector(15 downto 0);
signal PRE_TIME_TMP: std_logic_vector(15 downto 0);
signal COINC_TIME_TMP: std_logic_vector(15 downto 0);
signal POST_TIME_TMP: std_logic_vector(15 downto 0);

signal CH1_OFFSET_ADJ_POS: std_logic_vector(7 downto 0);
signal CH1_OFFSET_ADJ_POS_DEL: std_logic_vector(7 downto 0);
signal SET_CH1_OFFSET_ADJ_POS: std_logic;
signal CLR_CH1_OFFSET_ADJ_POS: std_logic;

signal CH1_OFFSET_ADJ_NEG: std_logic_vector(7 downto 0);
signal CH1_OFFSET_ADJ_NEG_DEL: std_logic_vector(7 downto 0);
signal SET_CH1_OFFSET_ADJ_NEG: std_logic;
signal CLR_CH1_OFFSET_ADJ_NEG: std_logic;

signal CH2_OFFSET_ADJ_POS: std_logic_vector(7 downto 0);
signal CH2_OFFSET_ADJ_POS_DEL: std_logic_vector(7 downto 0);
signal SET_CH2_OFFSET_ADJ_POS: std_logic;
signal CLR_CH2_OFFSET_ADJ_POS: std_logic;

signal CH2_OFFSET_ADJ_NEG: std_logic_vector(7 downto 0);
signal CH2_OFFSET_ADJ_NEG_DEL: std_logic_vector(7 downto 0);
signal SET_CH2_OFFSET_ADJ_NEG: std_logic;
signal CLR_CH2_OFFSET_ADJ_NEG: std_logic;

signal CH1_GAIN_ADJ_POS: std_logic_vector(7 downto 0);
signal CH1_GAIN_ADJ_POS_DEL: std_logic_vector(7 downto 0);
signal SET_CH1_GAIN_ADJ_POS: std_logic;
signal CLR_CH1_GAIN_ADJ_POS: std_logic;

signal CH1_GAIN_ADJ_NEG: std_logic_vector(7 downto 0);
signal CH1_GAIN_ADJ_NEG_DEL: std_logic_vector(7 downto 0);
signal SET_CH1_GAIN_ADJ_NEG: std_logic;
signal CLR_CH1_GAIN_ADJ_NEG: std_logic;

signal CH2_GAIN_ADJ_POS: std_logic_vector(7 downto 0);
signal CH2_GAIN_ADJ_POS_DEL: std_logic_vector(7 downto 0);
signal SET_CH2_GAIN_ADJ_POS: std_logic;
signal CLR_CH2_GAIN_ADJ_POS: std_logic;

signal CH2_GAIN_ADJ_NEG: std_logic_vector(7 downto 0);
signal CH2_GAIN_ADJ_NEG_DEL: std_logic_vector(7 downto 0);
signal SET_CH2_GAIN_ADJ_NEG: std_logic;
signal CLR_CH2_GAIN_ADJ_NEG: std_logic;

signal COMMON_OFFSET_ADJ: std_logic_vector(7 downto 0);
signal COMMON_OFFSET_ADJ_DEL: std_logic_vector(7 downto 0);
signal SET_COMMON_OFFSET_ADJ: std_logic;
signal CLR_COMMON_OFFSET_ADJ: std_logic;

signal FULL_SCALE_ADJ: std_logic_vector(7 downto 0);
signal FULL_SCALE_ADJ_DEL: std_logic_vector(7 downto 0);
signal SET_FULL_SCALE_ADJ: std_logic;
signal CLR_FULL_SCALE_ADJ: std_logic;

signal CH1_INTEGRATOR: std_logic_vector(7 downto 0);
signal CH1_INTEGRATOR_DEL: std_logic_vector(7 downto 0);
signal SET_CH1_INTEGRATOR: std_logic;
signal CLR_CH1_INTEGRATOR: std_logic;

signal CH2_INTEGRATOR: std_logic_vector(7 downto 0);
signal CH2_INTEGRATOR_DEL: std_logic_vector(7 downto 0);
signal SET_CH2_INTEGRATOR: std_logic;
signal CLR_CH2_INTEGRATOR: std_logic;

signal COMP_THRES_LOW: std_logic_vector(7 downto 0);
signal COMP_THRES_LOW_DEL: std_logic_vector(7 downto 0);
signal SET_COMP_THRES_LOW: std_logic;
signal CLR_COMP_THRES_LOW: std_logic;

signal COMP_THRES_HIGH: std_logic_vector(7 downto 0);
signal COMP_THRES_HIGH_DEL: std_logic_vector(7 downto 0);
signal SET_COMP_THRES_HIGH: std_logic;
signal CLR_COMP_THRES_HIGH: std_logic;

signal CH1_PMT_HV_ADJ: std_logic_vector(7 downto 0);
signal CH1_PMT_HV_ADJ_DEL: std_logic_vector(7 downto 0);
signal SET_CH1_PMT_HV_ADJ: std_logic;
signal CLR_CH1_PMT_HV_ADJ: std_logic;

signal CH2_PMT_HV_ADJ: std_logic_vector(7 downto 0);
signal CH2_PMT_HV_ADJ_DEL: std_logic_vector(7 downto 0);
signal SET_CH2_PMT_HV_ADJ: std_logic;
signal CLR_CH2_PMT_HV_ADJ: std_logic;

signal CH1_THRES_LOW: std_logic_vector(15 downto 0);
signal CH1_THRES_HIGH: std_logic_vector(15 downto 0);
signal CH2_THRES_LOW: std_logic_vector(15 downto 0);
signal CH2_THRES_HIGH: std_logic_vector(15 downto 0);

signal SPARE_BYTES: std_logic_vector(31 downto 0);

signal CH1_PMT_SUPPLY_CURR: std_logic_vector(7 downto 0);
signal CH2_PMT_SUPPLY_CURR: std_logic_vector(7 downto 0);
signal STATUS: std_logic_vector(7 downto 0);
signal VERSION: std_logic_vector(23 downto 0);
signal SOFTWARE_VERSION: std_logic_vector(7 downto 0);

signal WRITE_PARAMETER_LIST: std_logic;
signal WRITE_PARAMETER_LIST_DEL: std_logic;
signal PARAMETER_LIST_READOUT_DONE_DEL1: std_logic;
signal READ_ERROR: std_logic;
signal READ_ERROR_READOUT_DONE_DEL1: std_logic;

signal USB_RXF_DEL: std_logic;
signal USB_RXF_OR: std_logic;
signal USB_READ_ENABLE: std_logic;
signal USB_READ_BUSY: std_logic;
signal START_READING: std_logic;
signal STOP_READING: std_logic;
signal USB_WRITE_REQUEST_DEL1: std_logic;
signal USB_WRITE_REQUEST_DEL2: std_logic;
signal USB_WRITE_REQUEST_DEL3: std_logic;
signal USB_WRITE_REQUEST_DEL4: std_logic;
signal RD_TMP: std_logic;
signal READ_COUNT: integer range 41 downto 0; -- Send message can be maximum 39 bytes (1 extra for error notification)
signal READ_COUNT_DEL: integer range 41 downto 0; 
signal END_BYTE: std_logic_vector(2 downto 0); -- Place of end byte (66h)
signal RD_DATA_TMP1: std_logic_vector(7 downto 0);
signal RD_DATA_TMP2: std_logic_vector(7 downto 0);
signal RD_DATA_TMP3: std_logic_vector(7 downto 0);
signal RD_DATA_TMP4: std_logic_vector(7 downto 0);
signal RD_DATA_TMP5: std_logic_vector(7 downto 0);
signal RD_DATA_TMP6: std_logic_vector(7 downto 0);
signal RD_DATA_TMP7: std_logic_vector(7 downto 0);
signal RD_DATA_TMP8: std_logic_vector(7 downto 0);
signal RD_DATA_TMP9: std_logic_vector(7 downto 0);
signal RD_DATA_TMP10: std_logic_vector(7 downto 0);
signal RD_DATA_TMP11: std_logic_vector(7 downto 0);
signal RD_DATA_TMP12: std_logic_vector(7 downto 0);
signal RD_DATA_TMP13: std_logic_vector(7 downto 0);
signal RD_DATA_TMP14: std_logic_vector(7 downto 0);
signal RD_DATA_TMP15: std_logic_vector(7 downto 0);
signal RD_DATA_TMP16: std_logic_vector(7 downto 0);
signal RD_DATA_TMP17: std_logic_vector(7 downto 0);
signal RD_DATA_TMP18: std_logic_vector(7 downto 0);
signal RD_DATA_TMP19: std_logic_vector(7 downto 0);
signal RD_DATA_TMP20: std_logic_vector(7 downto 0);
signal RD_DATA_TMP21: std_logic_vector(7 downto 0);
signal RD_DATA_TMP22: std_logic_vector(7 downto 0);
signal RD_DATA_TMP23: std_logic_vector(7 downto 0);
signal RD_DATA_TMP24: std_logic_vector(7 downto 0);
signal RD_DATA_TMP25: std_logic_vector(7 downto 0);
signal RD_DATA_TMP26: std_logic_vector(7 downto 0);
signal RD_DATA_TMP27: std_logic_vector(7 downto 0);
signal RD_DATA_TMP28: std_logic_vector(7 downto 0);
signal RD_DATA_TMP29: std_logic_vector(7 downto 0);
signal RD_DATA_TMP30: std_logic_vector(7 downto 0);
signal RD_DATA_TMP31: std_logic_vector(7 downto 0);
signal RD_DATA_TMP32: std_logic_vector(7 downto 0);
signal RD_DATA_TMP33: std_logic_vector(7 downto 0);
signal RD_DATA_TMP34: std_logic_vector(7 downto 0);
signal RD_DATA_TMP35: std_logic_vector(7 downto 0);
signal RD_DATA_TMP36: std_logic_vector(7 downto 0);
signal RD_DATA_TMP37: std_logic_vector(7 downto 0);
signal RD_DATA_TMP38: std_logic_vector(7 downto 0);
signal RD_DATA_TMP39: std_logic_vector(7 downto 0);

signal PRELOAD_DACS: std_logic;
signal PRELOAD_DACS_DEL1: std_logic;
signal PRELOAD_DACS_DEL2: std_logic;
signal PRELOAD_DAC_COUNT: std_logic_vector(2 downto 0);
signal WR_DACS: std_logic;
signal DAC_DATA_OUT: std_logic_vector(7 downto 0);

signal ONE_PPS_DEL1: std_logic;
signal ONE_PPS_DEL2: std_logic;
signal SET_CURR_ADC: std_logic;
signal CLR_CURR_ADC: std_logic;
signal CURR_ADC_COUNT: integer range 75 downto 0; 


begin

  STATUS(6 downto 2) <= "00000";
  STATUS(1) <= SLAVE_PRESENT;
  STATUS(0) <= MASTER;
  GPS_PROG_ENABLE <= STATUS(7);
  SOFTWARE_VERSION <= "00000001";
  VERSION(23 downto 16) <= SOFTWARE_VERSION;
  VERSION(15 downto 10) <= "000000";
  VERSION(9) <= not SERIAL_NUMBER(9);
  VERSION(8) <= not SERIAL_NUMBER(8);
  VERSION(7) <= not SERIAL_NUMBER(7);
  VERSION(6) <= not SERIAL_NUMBER(6);
  VERSION(5) <= not SERIAL_NUMBER(5);
  VERSION(4) <= not SERIAL_NUMBER(4);
  VERSION(3) <= not SERIAL_NUMBER(3);
  VERSION(2) <= not SERIAL_NUMBER(2);
  VERSION(1) <= not SERIAL_NUMBER(1);
  VERSION(0) <= not SERIAL_NUMBER(0);
  THL1 <= CH1_THRES_LOW(11 downto 0);
  THH1 <= CH1_THRES_HIGH(11 downto 0);
  THL2 <= CH2_THRES_LOW(11 downto 0);
  THH2 <= CH2_THRES_HIGH(11 downto 0);
--  PRE_TIME_TMP <= PRE_TIME_LOAD when PRE_TIME_LOAD <= "0000000110010000" else "0000000110010000"; -- 400
--  COINC_TIME_TMP <= COINC_TIME_LOAD when COINC_TIME_LOAD <= "0000001111101000" else "0000001111101000"; -- 1000
--  POST_TIME_TMP <= POST_TIME_LOAD when POST_TIME_LOAD <= "0000011001000000" else "0000011001000000"; -- 1600
  PRE_TIME_OUT <= PRE_TIME_TMP;
  COINC_TIME_OUT <= COINC_TIME_TMP;
  POST_TIME_OUT <= POST_TIME_TMP;
  PRE_TIME_SET <= to_integer(unsigned(PRE_TIME_TMP)) ;
  POST_TIME_SET <= to_integer(unsigned(POST_TIME_TMP)) ;
  COINC_TIME_SET <= to_integer(unsigned(COINC_TIME_TMP)) ;
  COINC_TIME <= COINC_TIME_SET;
  POST_TIME <= POST_TIME_SET;
--  TOTAL_TIME_TMP <= PRE_TIME_SET + COINC_TIME_SET + POST_TIME_SET when (PRE_TIME_SET + COINC_TIME_SET + POST_TIME_SET) <= 2000 else TOTAL_TIME_TMP;
  TOTAL_TIME <= TOTAL_TIME_TMP;
  TOTAL_TIME_3X <= TOTAL_TIME_TMP + TOTAL_TIME_TMP + TOTAL_TIME_TMP;
    
  ADC_MODE <= '0';
  ADC_nCS <= '0';
  ADC_A1 <= '0';

  process(CLK10MHz)
  begin
    if (CLK10MHz'event and CLK10MHz = '1') then
      if PRE_TIME_LOAD <= "0000000110010000" then -- 400
        PRE_TIME_TMP <= PRE_TIME_LOAD;
      else  
        PRE_TIME_TMP <= "0000000110010000";
      end if;
      if COINC_TIME_LOAD <= "0000001111101000" then -- 1000
        COINC_TIME_TMP <= COINC_TIME_LOAD;
      else  
        COINC_TIME_TMP <= "0000001111101000";
      end if;
      if POST_TIME_LOAD <= "0000011001000000" then -- 1600
        POST_TIME_TMP <= POST_TIME_LOAD;
      else  
        POST_TIME_TMP <= "0000011001000000";
      end if;
      if (PRE_TIME_SET + COINC_TIME_SET + POST_TIME_SET) <= 2000 then 
        TOTAL_TIME_TMP <= PRE_TIME_SET + COINC_TIME_SET + POST_TIME_SET;
      else  
        TOTAL_TIME_TMP <= 2000; -- Limit on 2000
      end if;
    end if;
  end process;  

  PARAMETER_LIST(7 downto 0) <= CH1_OFFSET_ADJ_POS;
  PARAMETER_LIST(15 downto 8) <= CH1_OFFSET_ADJ_NEG;
  PARAMETER_LIST(23 downto 16) <= CH2_OFFSET_ADJ_POS;
  PARAMETER_LIST(31 downto 24) <= CH2_OFFSET_ADJ_NEG;
  PARAMETER_LIST(39 downto 32) <= CH1_GAIN_ADJ_POS;
  PARAMETER_LIST(47 downto 40) <= CH1_GAIN_ADJ_NEG;
  PARAMETER_LIST(55 downto 48) <= CH2_GAIN_ADJ_POS;
  PARAMETER_LIST(63 downto 56) <= CH2_GAIN_ADJ_NEG;
  PARAMETER_LIST(71 downto 64) <= COMMON_OFFSET_ADJ;
  PARAMETER_LIST(79 downto 72) <= FULL_SCALE_ADJ;
  PARAMETER_LIST(87 downto 80) <= CH1_INTEGRATOR;
  PARAMETER_LIST(95 downto 88) <= CH2_INTEGRATOR;
  PARAMETER_LIST(103 downto 96) <= COMP_THRES_LOW;
  PARAMETER_LIST(111 downto 104) <= COMP_THRES_HIGH;
  PARAMETER_LIST(119 downto 112) <= CH1_PMT_HV_ADJ;
  PARAMETER_LIST(127 downto 120) <= CH2_PMT_HV_ADJ;
  PARAMETER_LIST(143 downto 128) <= CH1_THRES_LOW;
  PARAMETER_LIST(159 downto 144) <= CH1_THRES_HIGH;
  PARAMETER_LIST(175 downto 160) <= CH2_THRES_LOW;
  PARAMETER_LIST(191 downto 176) <= CH2_THRES_HIGH;
  PARAMETER_LIST(199 downto 192) <= STATUS;
  PARAMETER_LIST(231 downto 200) <= SPARE_BYTES;
  PARAMETER_LIST(239 downto 232) <= CH1_PMT_SUPPLY_CURR;
  PARAMETER_LIST(247 downto 240) <= CH2_PMT_SUPPLY_CURR;
  PARAMETER_LIST(271 downto 248) <= VERSION;


  USB_WRITE_ENABLE <= not USB_READ_ENABLE;
  USB_RD <= RD_TMP;
  DAC_nWR <= WR_DACS;
  DAC_nLDAC <= '0';
  DAC_nCLR <= '1';
  DAC_nRD <= '1';
  DAC_DATA_0 <= DAC_DATA_OUT(0);
  DAC_DATA_1 <= DAC_DATA_OUT(1);
  DAC_DATA_2 <= DAC_DATA_OUT(2);
  DAC_DATA_3 <= DAC_DATA_OUT(3);
  DAC_DATA_4 <= DAC_DATA_OUT(4);
  DAC_DATA_5 <= DAC_DATA_OUT(5);
  DAC_DATA_6 <= DAC_DATA_OUT(6);
  DAC_DATA_7 <= DAC_DATA_OUT(7);
  
  process(CLK10MHz,SYSRST)
  begin
    if SYSRST = '1' then
      PRELOAD_DACS_DEL1 <= '0';        
      PRELOAD_DACS_DEL2 <= '0';        
      CH1_OFFSET_ADJ_POS_DEL <= "00000000";        
      CH1_OFFSET_ADJ_NEG_DEL <= "00000000";        
      CH2_OFFSET_ADJ_POS_DEL <= "00000000";        
      CH2_OFFSET_ADJ_NEG_DEL <= "00000000";        
      CH1_GAIN_ADJ_POS_DEL <= "00000000";        
      CH1_GAIN_ADJ_NEG_DEL <= "00000000";        
      CH2_GAIN_ADJ_POS_DEL <= "00000000";        
      CH2_GAIN_ADJ_NEG_DEL <= "00000000";        
      COMMON_OFFSET_ADJ_DEL <= "00000000";        
      FULL_SCALE_ADJ_DEL <= "00000000";        
      CH1_INTEGRATOR_DEL <= "00000000";        
      CH2_INTEGRATOR_DEL <= "00000000";        
      COMP_THRES_LOW_DEL <= "00000000";        
      COMP_THRES_HIGH_DEL <= "00000000";        
      CH1_PMT_HV_ADJ_DEL <= "00000000";        
      CH2_PMT_HV_ADJ_DEL <= "00000000";        
      ONE_PPS_DEL1 <= '0';        
      ONE_PPS_DEL2 <= '0';        
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      PRELOAD_DACS_DEL1 <= PRELOAD_DACS;        
      PRELOAD_DACS_DEL2 <= PRELOAD_DACS_DEL1;        
      CH1_OFFSET_ADJ_POS_DEL <= CH1_OFFSET_ADJ_POS;        
      CH1_OFFSET_ADJ_NEG_DEL <= CH1_OFFSET_ADJ_NEG;        
      CH2_OFFSET_ADJ_POS_DEL <= CH2_OFFSET_ADJ_POS;        
      CH2_OFFSET_ADJ_NEG_DEL <= CH2_OFFSET_ADJ_NEG;        
      CH1_GAIN_ADJ_POS_DEL <= CH1_GAIN_ADJ_POS;        
      CH1_GAIN_ADJ_NEG_DEL <= CH1_GAIN_ADJ_NEG;        
      CH2_GAIN_ADJ_POS_DEL <= CH2_GAIN_ADJ_POS;        
      CH2_GAIN_ADJ_NEG_DEL <= CH2_GAIN_ADJ_NEG;        
      COMMON_OFFSET_ADJ_DEL <= COMMON_OFFSET_ADJ;        
      FULL_SCALE_ADJ_DEL <= FULL_SCALE_ADJ;        
      CH1_INTEGRATOR_DEL <= CH1_INTEGRATOR;        
      CH2_INTEGRATOR_DEL <= CH2_INTEGRATOR;        
      COMP_THRES_LOW_DEL <= COMP_THRES_LOW;        
      COMP_THRES_HIGH_DEL <= COMP_THRES_HIGH;        
      CH1_PMT_HV_ADJ_DEL <= CH1_PMT_HV_ADJ;        
      CH2_PMT_HV_ADJ_DEL <= CH2_PMT_HV_ADJ;        
      ONE_PPS_DEL1 <= ONE_PPS;        
      ONE_PPS_DEL2 <= ONE_PPS_DEL1;        
    end if;
  end process;  

  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      WRITE_PARAMETER_LIST_DEL <= '0';        
      PARAMETER_LIST_READOUT_DONE_DEL1 <= '0';        
      READ_ERROR_READOUT_DONE_DEL1 <= '0';        
      USB_WRITE_REQUEST_DEL1 <= '0';        
      USB_WRITE_REQUEST_DEL2 <= '0';        
      USB_WRITE_REQUEST_DEL3 <= '0';        
      USB_WRITE_REQUEST_DEL4 <= '0';        
    elsif (CLKRD'event and CLKRD = '1') then
      WRITE_PARAMETER_LIST_DEL <= WRITE_PARAMETER_LIST;        
      PARAMETER_LIST_READOUT_DONE_DEL1 <= PARAMETER_LIST_READOUT_DONE;        
      READ_ERROR_READOUT_DONE_DEL1 <= READ_ERROR_READOUT_DONE;        
      USB_WRITE_REQUEST_DEL1 <= USB_WRITE_REQUEST;        
      USB_WRITE_REQUEST_DEL2 <= USB_WRITE_REQUEST_DEL1;        
      USB_WRITE_REQUEST_DEL3 <= USB_WRITE_REQUEST_DEL2;        
      USB_WRITE_REQUEST_DEL4 <= USB_WRITE_REQUEST_DEL3;        
    end if;
  end process;  

  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      PARAMETER_LIST_VALID <= '0';
    elsif (CLKRD'event and CLKRD = '1') then
      if WRITE_PARAMETER_LIST = '1' and WRITE_PARAMETER_LIST_DEL = '0' then
        PARAMETER_LIST_VALID <= '1';
      elsif PARAMETER_LIST_READOUT_DONE = '1' and PARAMETER_LIST_READOUT_DONE_DEL1 = '0' then
        PARAMETER_LIST_VALID <= '0';
      end if;
    end if;
  end process;  

  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      READ_ERROR_VALID <= '0';
    elsif (CLKRD'event and CLKRD = '1') then
      if READ_ERROR = '1' then
        READ_ERROR_VALID <= '1';
      elsif READ_ERROR_READOUT_DONE = '1' and READ_ERROR_READOUT_DONE_DEL1 = '0' then
        READ_ERROR_VALID <= '0';
      end if;
    end if;
  end process;  

  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      USB_RXF_DEL <= '1';        
    elsif (CLKRD'event and CLKRD = '0') then
      USB_RXF_DEL <= USB_RXF;        
    end if;
  end process;  

  USB_RXF_OR <= USB_RXF_DEL and USB_RXF;


  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      USB_READ_ENABLE <= '1'; -- Default (on power up) USB is in read mode
      START_READING <= '0';
    elsif (CLKRD'event and CLKRD = '1') then
      if USB_WRITE_BUSY = '1' or USB_READ_BUSY = '1' then -- if writing or reading is busy then do nothing
        USB_READ_ENABLE <= USB_READ_ENABLE;
        START_READING <= '0';
      elsif USB_RXF_OR = '0' then -- reading has first priority; USB_RXF = '0' when there is data to readout
        START_READING <= '1';
        USB_READ_ENABLE <= '1';
      elsif USB_WRITE_REQUEST = '1' or USB_WRITE_REQUEST_DEL1 = '1' or USB_WRITE_REQUEST_DEL2 = '1' or USB_WRITE_REQUEST_DEL3 = '1' or USB_WRITE_REQUEST_DEL4 = '1' then  -- Delay time needed for USB_WRITE_BUSY to react on USB_WRITE_ENABLE
        USB_READ_ENABLE <= '0';
        START_READING <= '0';
      else
        USB_READ_ENABLE <= '1';
        START_READING <= '0';
      end if;
    end if;
  end process;  

  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      USB_READ_BUSY <= '0'; 
    elsif (CLKRD'event and CLKRD = '1') then
      if START_READING = '1' then 
        USB_READ_BUSY <= '1'; 
      elsif STOP_READING = '1' or READ_ERROR = '1' then 
        USB_READ_BUSY <= '0';
      else
        USB_READ_BUSY <= USB_READ_BUSY; 
      end if;
    end if;
  end process;  

  process(CLKRD,SYSRST,READ_COUNT,USB_DATA_IN)
  begin
    if SYSRST = '1' then
      RD_TMP <= '1'; 
      READ_COUNT <= 0;
      READ_COUNT_DEL <= 0;        
      RD_DATA_TMP1 <= "00000000";
      RD_DATA_TMP2 <= "00000000";
      RD_DATA_TMP3 <= "00000000";
      RD_DATA_TMP4 <= "00000000";
      RD_DATA_TMP5 <= "00000000";
      RD_DATA_TMP6 <= "00000000";
      RD_DATA_TMP7 <= "00000000";
      RD_DATA_TMP8 <= "00000000";
      RD_DATA_TMP9 <= "00000000";
      RD_DATA_TMP10 <= "00000000";
      RD_DATA_TMP11 <= "00000000";
      RD_DATA_TMP12 <= "00000000";
      RD_DATA_TMP13 <= "00000000";
      RD_DATA_TMP14 <= "00000000";
      RD_DATA_TMP15 <= "00000000";
      RD_DATA_TMP16 <= "00000000";
      RD_DATA_TMP17 <= "00000000";
      RD_DATA_TMP18 <= "00000000";
      RD_DATA_TMP19 <= "00000000";
      RD_DATA_TMP20 <= "00000000";
      RD_DATA_TMP21 <= "00000000";
      RD_DATA_TMP22 <= "00000000";
      RD_DATA_TMP23 <= "00000000";
      RD_DATA_TMP24 <= "00000000";
      RD_DATA_TMP25 <= "00000000";
      RD_DATA_TMP26 <= "00000000";
      RD_DATA_TMP27 <= "00000000";
      RD_DATA_TMP28 <= "00000000";
      RD_DATA_TMP29 <= "00000000";
      RD_DATA_TMP30 <= "00000000";
      RD_DATA_TMP31 <= "00000000";
      RD_DATA_TMP32 <= "00000000";
      RD_DATA_TMP33 <= "00000000";
      RD_DATA_TMP34 <= "00000000";
      RD_DATA_TMP35 <= "00000000";
      RD_DATA_TMP36 <= "00000000";
      RD_DATA_TMP37 <= "00000000";
      RD_DATA_TMP38 <= "00000000";
      RD_DATA_TMP39 <= "00000000";
    elsif (CLKRD'event and CLKRD = '1') then
      if USB_READ_BUSY = '1' and READ_ERROR = '0' and STOP_READING = '0' then
        if USB_RXF_OR = '0' then 
          if RD_TMP = '1' then 
            RD_TMP <= '0'; 
            READ_COUNT <= READ_COUNT + 1;
          else 
            RD_TMP <= '1';
      		READ_COUNT_DEL <= READ_COUNT;        
      		case (READ_COUNT) is
    		  when 1 => RD_DATA_TMP1 <= USB_DATA_IN; 
      		  when 2 => RD_DATA_TMP2 <= USB_DATA_IN; 
       	 	  when 3 => RD_DATA_TMP3 <= USB_DATA_IN; 
      		  when 4 => RD_DATA_TMP4 <= USB_DATA_IN; 
      		  when 5 => RD_DATA_TMP5 <= USB_DATA_IN; 
      		  when 6 => RD_DATA_TMP6 <= USB_DATA_IN; 
      		  when 7 => RD_DATA_TMP7 <= USB_DATA_IN; 
      		  when 8 => RD_DATA_TMP8 <= USB_DATA_IN; 
      		  when 9 => RD_DATA_TMP9 <= USB_DATA_IN; 
      		  when 10 => RD_DATA_TMP10 <= USB_DATA_IN; 
      		  when 11 => RD_DATA_TMP11 <= USB_DATA_IN; 
      		  when 12 => RD_DATA_TMP12 <= USB_DATA_IN; 
      		  when 13 => RD_DATA_TMP13 <= USB_DATA_IN; 
      		  when 14 => RD_DATA_TMP14 <= USB_DATA_IN; 
      		  when 15 => RD_DATA_TMP15 <= USB_DATA_IN; 
      		  when 16 => RD_DATA_TMP16 <= USB_DATA_IN; 
      		  when 17 => RD_DATA_TMP17 <= USB_DATA_IN; 
      		  when 18 => RD_DATA_TMP18 <= USB_DATA_IN; 
      		  when 19 => RD_DATA_TMP19 <= USB_DATA_IN; 
      		  when 20 => RD_DATA_TMP20 <= USB_DATA_IN; 
      		  when 21 => RD_DATA_TMP21 <= USB_DATA_IN; 
      		  when 22 => RD_DATA_TMP22 <= USB_DATA_IN; 
        	  when 23 => RD_DATA_TMP23 <= USB_DATA_IN; 
      		  when 24 => RD_DATA_TMP24 <= USB_DATA_IN; 
      		  when 25 => RD_DATA_TMP25 <= USB_DATA_IN; 
      		  when 26 => RD_DATA_TMP26 <= USB_DATA_IN; 
      		  when 27 => RD_DATA_TMP27 <= USB_DATA_IN; 
      		  when 28 => RD_DATA_TMP28 <= USB_DATA_IN; 
      		  when 29 => RD_DATA_TMP29 <= USB_DATA_IN; 
      		  when 30 => RD_DATA_TMP30 <= USB_DATA_IN; 
      		  when 31 => RD_DATA_TMP31 <= USB_DATA_IN; 
      		  when 32 => RD_DATA_TMP32 <= USB_DATA_IN; 
      		  when 33 => RD_DATA_TMP33 <= USB_DATA_IN; 
      		  when 34 => RD_DATA_TMP34 <= USB_DATA_IN; 
      		  when 35 => RD_DATA_TMP35 <= USB_DATA_IN; 
      		  when 36 => RD_DATA_TMP36 <= USB_DATA_IN; 
      		  when 37 => RD_DATA_TMP37 <= USB_DATA_IN; 
      		  when 38 => RD_DATA_TMP38 <= USB_DATA_IN; 
      		  when 39 => RD_DATA_TMP39 <= USB_DATA_IN; 
      		  when others => -- Do nothing
      		end case;
          end if;
        end if;
      else
        RD_TMP <= '1'; 
        READ_COUNT <= 0;
        READ_COUNT_DEL <= 0;
      end if;
    end if;
  end process;  

  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
	  READ_ERROR <= '0';
  	  READ_ERROR_DATA <= "00000000";
	  STOP_READING <= '0';
      END_BYTE <= "000";
    elsif (CLKRD'event and CLKRD = '1') then
      if USB_READ_BUSY = '1' and READ_ERROR = '0' and STOP_READING = '0' then
        if READ_COUNT_DEL = 1 then
          if RD_DATA_TMP1 /= "10011001" then
            READ_ERROR <= '1';
  			READ_ERROR_DATA <= "10011001"; -- Missing start byte
          end if;
        end if;
        if READ_COUNT_DEL = 2 then
          if RD_DATA_TMP2 = "01010101" or RD_DATA_TMP2 = "11111111" then
            END_BYTE <= "001"; -- END_BYTE = 3
          elsif RD_DATA_TMP2 = "00010000" or RD_DATA_TMP2 = "00010001" or RD_DATA_TMP2 = "00010010" or RD_DATA_TMP2 = "00010011" or RD_DATA_TMP2 = "00010100" or RD_DATA_TMP2 = "00010101" or RD_DATA_TMP2 = "00010110" or RD_DATA_TMP2 = "00010111" or RD_DATA_TMP2 = "00011000" or RD_DATA_TMP2 = "00011001" or RD_DATA_TMP2 = "00011010" or RD_DATA_TMP2 = "00011011" or RD_DATA_TMP2 = "00011100" or RD_DATA_TMP2 = "00011101" or RD_DATA_TMP2 = "00011110" or RD_DATA_TMP2 = "00011111" or RD_DATA_TMP2 = "00110000" or RD_DATA_TMP2 = "00110100" then
            END_BYTE <= "010"; -- END_BYTE = 4
          elsif RD_DATA_TMP2 = "00100000" or RD_DATA_TMP2 = "00100001" or RD_DATA_TMP2 = "00100010" or RD_DATA_TMP2 = "00100011" or RD_DATA_TMP2 = "00110001" or RD_DATA_TMP2 = "00110010" or RD_DATA_TMP2 = "00110011" then
            END_BYTE <= "011"; -- END_BYTE = 5
          elsif RD_DATA_TMP2 = "00110101" then
            END_BYTE <= "100"; -- END_BYTE = 7
          elsif RD_DATA_TMP2 = "01010000" then
            END_BYTE <= "101"; -- END_BYTE = 38
          else
            READ_ERROR <= '1';
  			READ_ERROR_DATA <= "10001001"; -- Wrong ID 89h
          end if;
        end if;
        if READ_COUNT_DEL = 3 and END_BYTE = "001" then
          if RD_DATA_TMP3 = "01100110" then
            STOP_READING <= '1';
          else
            READ_ERROR <= '1';            
  			READ_ERROR_DATA <= RD_DATA_TMP2; -- Message ID
          end if;
        end if;
        if READ_COUNT_DEL = 4 and END_BYTE = "010" then
          if RD_DATA_TMP4 = "01100110" then
            STOP_READING <= '1';
          else
            READ_ERROR <= '1';            
  			READ_ERROR_DATA <= RD_DATA_TMP2; -- Message ID
          end if;
        end if;
        if READ_COUNT_DEL = 5 and END_BYTE = "011" then
          if RD_DATA_TMP5 = "01100110" then
            STOP_READING <= '1';
          else
            READ_ERROR <= '1';            
  			READ_ERROR_DATA <= RD_DATA_TMP2; -- Message ID
          end if;
        end if;
        if READ_COUNT_DEL = 7 and END_BYTE = "100" then
          if RD_DATA_TMP7 = "01100110" then
            STOP_READING <= '1';
          else
            READ_ERROR <= '1';            
  			READ_ERROR_DATA <= RD_DATA_TMP2; -- Message ID
          end if;
        end if;
        if READ_COUNT_DEL = 39 and END_BYTE = "101" then
          if RD_DATA_TMP39 = "01100110" then
            STOP_READING <= '1';
          else
            READ_ERROR <= '1';            
  			READ_ERROR_DATA <= RD_DATA_TMP2; -- Message ID
          end if;
        end if;
        if READ_COUNT_DEL = 40 then
          READ_ERROR <= '1';            
  		  READ_ERROR_DATA <= "01100110"; -- Missing stop byte
        end if;
      else
	    READ_ERROR <= '0';
	    STOP_READING <= '0';
        END_BYTE <= "000";
      end if;
    end if;
  end process;  


  process(CLKRD,SYSRST,RD_DATA_TMP2,RD_DATA_TMP3,RD_DATA_TMP4,RD_DATA_TMP5,RD_DATA_TMP6,RD_DATA_TMP7,RD_DATA_TMP8,RD_DATA_TMP9,RD_DATA_TMP10,RD_DATA_TMP11,RD_DATA_TMP12,RD_DATA_TMP13,RD_DATA_TMP14,RD_DATA_TMP15,RD_DATA_TMP16,RD_DATA_TMP17,RD_DATA_TMP18,RD_DATA_TMP19,RD_DATA_TMP20,RD_DATA_TMP21,RD_DATA_TMP22,RD_DATA_TMP23,RD_DATA_TMP24,RD_DATA_TMP25,RD_DATA_TMP26,RD_DATA_TMP27,RD_DATA_TMP28,RD_DATA_TMP29,RD_DATA_TMP30,RD_DATA_TMP31,RD_DATA_TMP32,RD_DATA_TMP33,RD_DATA_TMP34,RD_DATA_TMP35,RD_DATA_TMP36,RD_DATA_TMP37)
  begin
    if SYSRST = '1' then
	  CH1_OFFSET_ADJ_POS <= "10000000";
	  CH1_OFFSET_ADJ_NEG <= "10000000";
	  CH2_OFFSET_ADJ_POS <= "10000000";
	  CH2_OFFSET_ADJ_NEG <= "10000000";
	  CH1_GAIN_ADJ_POS <= "10000000";
	  CH1_GAIN_ADJ_NEG <= "10000000";
	  CH2_GAIN_ADJ_POS <= "10000000";
	  CH2_GAIN_ADJ_NEG <= "10000000";
	  COMMON_OFFSET_ADJ <= "00000000";
	  FULL_SCALE_ADJ <= "00000000";
	  CH1_INTEGRATOR <= "11111111";
	  CH2_INTEGRATOR <= "11111111";
	  COMP_THRES_LOW <= "01011000";
	  COMP_THRES_HIGH <= "11100110";
	  CH1_PMT_HV_ADJ <= "00000000";
	  CH2_PMT_HV_ADJ <= "00000000";
	  CH1_THRES_LOW <= "0000000001000000";
	  CH1_THRES_HIGH <= "0000000100000000";
	  CH2_THRES_LOW <= "0000000001111100";
	  CH2_THRES_HIGH <= "0000000010000000";
  	  TR_CONDITION <= "00001000";-- any high signals
	  PRE_TIME_LOAD <= "0000000000000101"; -- 5
	  COINC_TIME_LOAD <= "0000000000001010"; -- 10
	  POST_TIME_LOAD <= "0000000000001010"; -- 10 
	  SPARE_BYTES <= (others => '0');
      STATUS(7) <= '0';
      WRITE_PARAMETER_LIST <= '0';
      SOFT_RESET <= '0';	  
    elsif (CLKRD'event and CLKRD = '1') then
      if STOP_READING = '1' then
    	case (RD_DATA_TMP2) is
      	  when "00010000" => CH1_OFFSET_ADJ_POS <= RD_DATA_TMP3; 
      	  when "00010001" => CH1_OFFSET_ADJ_NEG <= RD_DATA_TMP3; 
      	  when "00010010" => CH2_OFFSET_ADJ_POS <= RD_DATA_TMP3; 
      	  when "00010011" => CH2_OFFSET_ADJ_NEG <= RD_DATA_TMP3; 
      	  when "00010100" => CH1_GAIN_ADJ_POS <= RD_DATA_TMP3; 
      	  when "00010101" => CH1_GAIN_ADJ_NEG <= RD_DATA_TMP3; 
      	  when "00010110" => CH2_GAIN_ADJ_POS <= RD_DATA_TMP3; 
      	  when "00010111" => CH2_GAIN_ADJ_NEG <= RD_DATA_TMP3; 
      	  when "00011000" => COMMON_OFFSET_ADJ <= RD_DATA_TMP3; 
      	  when "00011001" => FULL_SCALE_ADJ <= RD_DATA_TMP3; 
      	  when "00011010" => CH1_INTEGRATOR <= RD_DATA_TMP3; 
      	  when "00011011" => CH2_INTEGRATOR <= RD_DATA_TMP3; 
      	  when "00011100" => COMP_THRES_LOW <= RD_DATA_TMP3; 
      	  when "00011101" => COMP_THRES_HIGH <= RD_DATA_TMP3; 
      	  when "00011110" => CH1_PMT_HV_ADJ <= RD_DATA_TMP3; 
      	  when "00011111" => CH2_PMT_HV_ADJ <= RD_DATA_TMP3; 
      	  when "00100000" => CH1_THRES_LOW(15 downto 8) <= RD_DATA_TMP3;
      	  					 CH1_THRES_LOW(7 downto 0) <= RD_DATA_TMP4; 
      	  when "00100001" => CH1_THRES_HIGH(15 downto 8) <= RD_DATA_TMP3;
      	  					 CH1_THRES_HIGH(7 downto 0) <= RD_DATA_TMP4; 
      	  when "00100010" => CH2_THRES_LOW(15 downto 8) <= RD_DATA_TMP3; 
      	  					 CH2_THRES_LOW(7 downto 0) <= RD_DATA_TMP4; 
      	  when "00100011" => CH2_THRES_HIGH(15 downto 8) <= RD_DATA_TMP3;
      	  					 CH2_THRES_HIGH(7 downto 0) <= RD_DATA_TMP4; 
     	  when "00110000" => TR_CONDITION <= RD_DATA_TMP3; 
      	  when "00110001" => PRE_TIME_LOAD(15 downto 8) <= RD_DATA_TMP3;
      	  					 PRE_TIME_LOAD(7 downto 0) <= RD_DATA_TMP4; 
      	  when "00110010" => COINC_TIME_LOAD(15 downto 8) <= RD_DATA_TMP3;
      	  					 COINC_TIME_LOAD(7 downto 0) <= RD_DATA_TMP4; 
      	  when "00110011" => POST_TIME_LOAD(15 downto 8) <= RD_DATA_TMP3;
      	  					 POST_TIME_LOAD(7 downto 0) <= RD_DATA_TMP4; 
      	  when "00110100" => STATUS(7) <= RD_DATA_TMP3(7);
      	  when "00110101" => SPARE_BYTES(31 downto 24) <= RD_DATA_TMP3;
      	  					 SPARE_BYTES(23 downto 16) <= RD_DATA_TMP4;
      	  					 SPARE_BYTES(15 downto 8) <= RD_DATA_TMP5;
      	  					 SPARE_BYTES(7 downto 0) <= RD_DATA_TMP6; 
      	  when "01010000" => CH1_OFFSET_ADJ_POS <= RD_DATA_TMP3;
      	  					 CH1_OFFSET_ADJ_NEG <= RD_DATA_TMP4; 
      	  					 CH2_OFFSET_ADJ_POS <= RD_DATA_TMP5; 
      	  					 CH2_OFFSET_ADJ_NEG <= RD_DATA_TMP6; 
      	  					 CH1_GAIN_ADJ_POS <= RD_DATA_TMP7; 
      	  					 CH1_GAIN_ADJ_NEG <= RD_DATA_TMP8; 
      	  					 CH2_GAIN_ADJ_POS <= RD_DATA_TMP9; 
      	  					 CH2_GAIN_ADJ_NEG <= RD_DATA_TMP10; 
      	  					 COMMON_OFFSET_ADJ <= RD_DATA_TMP11; 
      	  					 FULL_SCALE_ADJ <= RD_DATA_TMP12; 
      	  					 CH1_INTEGRATOR <= RD_DATA_TMP13; 
      	  					 CH2_INTEGRATOR <= RD_DATA_TMP14; 
      	  					 COMP_THRES_LOW <= RD_DATA_TMP15; 
      	  					 COMP_THRES_HIGH <= RD_DATA_TMP16; 
      	  					 CH1_PMT_HV_ADJ <= RD_DATA_TMP17; 
      	  					 CH2_PMT_HV_ADJ <= RD_DATA_TMP18; 
      	  					 CH1_THRES_LOW(15 downto 8) <= RD_DATA_TMP19; 
      	  					 CH1_THRES_LOW(7 downto 0) <= RD_DATA_TMP20; 
      	  					 CH1_THRES_HIGH(15 downto 8) <= RD_DATA_TMP21; 
      	  					 CH1_THRES_HIGH(7 downto 0) <= RD_DATA_TMP22; 
      	  					 CH2_THRES_LOW(15 downto 8) <= RD_DATA_TMP23; 
      	  					 CH2_THRES_LOW(7 downto 0) <= RD_DATA_TMP24; 
      	  					 CH2_THRES_HIGH(15 downto 8) <= RD_DATA_TMP25; 
      	  					 CH2_THRES_HIGH(7 downto 0) <= RD_DATA_TMP26; 
      	  					 TR_CONDITION <= RD_DATA_TMP27; 
      	  					 PRE_TIME_LOAD(15 downto 8) <= RD_DATA_TMP28; 
      	  					 PRE_TIME_LOAD(7 downto 0) <= RD_DATA_TMP29; 
      	  					 COINC_TIME_LOAD(15 downto 8) <= RD_DATA_TMP30; 
      	  					 COINC_TIME_LOAD(7 downto 0) <= RD_DATA_TMP31; 
      	  					 POST_TIME_LOAD(15 downto 8) <= RD_DATA_TMP32; 
      	  					 POST_TIME_LOAD(7 downto 0) <= RD_DATA_TMP33; 
      	  					 STATUS(7) <= RD_DATA_TMP34(7); 
      	  					 SPARE_BYTES(31 downto 24) <= RD_DATA_TMP35; 
      	  					 SPARE_BYTES(23 downto 16) <= RD_DATA_TMP36; 
      	  					 SPARE_BYTES(15 downto 8) <= RD_DATA_TMP37; 
      	  					 SPARE_BYTES(7 downto 0) <= RD_DATA_TMP38; 
      	  when "01010101" => WRITE_PARAMETER_LIST <= '1';
      	  when "11111111" => SOFT_RESET <= '1';
		  when others =>  -- Do nothing
    	end case;
      else  
        WRITE_PARAMETER_LIST <= '0';
        SOFT_RESET <= '0';
      end if;
    end if;
  end process;  

  process(CLK10MHz,SYSRST)
  begin
    if SYSRST = '1' then
      PRELOAD_DAC_COUNT <= "000";        
      PRELOAD_DACS <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if PRELOAD_DAC_COUNT /= "111" then
        PRELOAD_DAC_COUNT <= PRELOAD_DAC_COUNT + "001";
        PRELOAD_DACS <= '0';
      else
        PRELOAD_DAC_COUNT <= PRELOAD_DAC_COUNT;
        PRELOAD_DACS <= '1';              
      end if;
    end if;
  end process;  

  process(CLK10MHz,PRELOAD_DACS)
  begin
    if PRELOAD_DACS = '0' then
      SET_CH1_OFFSET_ADJ_POS <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if (PRELOAD_DACS_DEL1 = '1' and PRELOAD_DACS_DEL2 = '0') or (CH1_OFFSET_ADJ_POS /= CH1_OFFSET_ADJ_POS_DEL) then
        SET_CH1_OFFSET_ADJ_POS <= '1';
      elsif CLR_CH1_OFFSET_ADJ_POS = '1' then
        SET_CH1_OFFSET_ADJ_POS <= '0';              
      end if;
    end if;
  end process;  

  process(CLK10MHz,PRELOAD_DACS)
  begin
    if PRELOAD_DACS = '0' then
      SET_CH1_OFFSET_ADJ_NEG <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if (PRELOAD_DACS_DEL1 = '1' and PRELOAD_DACS_DEL2 = '0') or (CH1_OFFSET_ADJ_NEG /= CH1_OFFSET_ADJ_NEG_DEL) then
        SET_CH1_OFFSET_ADJ_NEG <= '1';
      elsif CLR_CH1_OFFSET_ADJ_NEG = '1' then
        SET_CH1_OFFSET_ADJ_NEG <= '0';              
      end if;
    end if;
  end process;  

  process(CLK10MHz,PRELOAD_DACS)
  begin
    if PRELOAD_DACS = '0' then
      SET_CH2_OFFSET_ADJ_POS <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if (PRELOAD_DACS_DEL1 = '1' and PRELOAD_DACS_DEL2 = '0') or (CH2_OFFSET_ADJ_POS /= CH2_OFFSET_ADJ_POS_DEL) then
        SET_CH2_OFFSET_ADJ_POS <= '1';
      elsif CLR_CH2_OFFSET_ADJ_POS = '1' then
        SET_CH2_OFFSET_ADJ_POS <= '0';              
      end if;
    end if;
  end process;  

  process(CLK10MHz,PRELOAD_DACS)
  begin
    if PRELOAD_DACS = '0' then
      SET_CH2_OFFSET_ADJ_NEG <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if (PRELOAD_DACS_DEL1 = '1' and PRELOAD_DACS_DEL2 = '0') or (CH2_OFFSET_ADJ_NEG /= CH2_OFFSET_ADJ_NEG_DEL) then
        SET_CH2_OFFSET_ADJ_NEG <= '1';
      elsif CLR_CH2_OFFSET_ADJ_NEG = '1' then
        SET_CH2_OFFSET_ADJ_NEG <= '0';              
      end if;
    end if;
  end process;  

  process(CLK10MHz,PRELOAD_DACS)
  begin
    if PRELOAD_DACS = '0' then
      SET_CH1_GAIN_ADJ_POS <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if (PRELOAD_DACS_DEL1 = '1' and PRELOAD_DACS_DEL2 = '0') or (CH1_GAIN_ADJ_POS /= CH1_GAIN_ADJ_POS_DEL) then
        SET_CH1_GAIN_ADJ_POS <= '1';
      elsif CLR_CH1_GAIN_ADJ_POS = '1' then
        SET_CH1_GAIN_ADJ_POS <= '0';              
      end if;
    end if;
  end process;  

  process(CLK10MHz,PRELOAD_DACS)
  begin
    if PRELOAD_DACS = '0' then
      SET_CH1_GAIN_ADJ_NEG <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if (PRELOAD_DACS_DEL1 = '1' and PRELOAD_DACS_DEL2 = '0') or (CH1_GAIN_ADJ_NEG /= CH1_GAIN_ADJ_NEG_DEL) then
        SET_CH1_GAIN_ADJ_NEG <= '1';
      elsif CLR_CH1_GAIN_ADJ_NEG = '1' then
        SET_CH1_GAIN_ADJ_NEG <= '0';              
      end if;
    end if;
  end process;  

  process(CLK10MHz,PRELOAD_DACS)
  begin
    if PRELOAD_DACS = '0' then
      SET_CH2_GAIN_ADJ_POS <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if (PRELOAD_DACS_DEL1 = '1' and PRELOAD_DACS_DEL2 = '0') or (CH2_GAIN_ADJ_POS /= CH2_GAIN_ADJ_POS_DEL) then
        SET_CH2_GAIN_ADJ_POS <= '1';
      elsif CLR_CH2_GAIN_ADJ_POS = '1' then
        SET_CH2_GAIN_ADJ_POS <= '0';              
      end if;
    end if;
  end process;  

  process(CLK10MHz,PRELOAD_DACS)
  begin
    if PRELOAD_DACS = '0' then
      SET_CH2_GAIN_ADJ_NEG <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if (PRELOAD_DACS_DEL1 = '1' and PRELOAD_DACS_DEL2 = '0') or (CH2_GAIN_ADJ_NEG /= CH2_GAIN_ADJ_NEG_DEL) then
        SET_CH2_GAIN_ADJ_NEG <= '1';
      elsif CLR_CH2_GAIN_ADJ_NEG = '1' then
        SET_CH2_GAIN_ADJ_NEG <= '0';              
      end if;
    end if;
  end process;  

  process(CLK10MHz,PRELOAD_DACS)
  begin
    if PRELOAD_DACS = '0' then
      SET_COMMON_OFFSET_ADJ <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if (PRELOAD_DACS_DEL1 = '1' and PRELOAD_DACS_DEL2 = '0') or (COMMON_OFFSET_ADJ /= COMMON_OFFSET_ADJ_DEL) then
        SET_COMMON_OFFSET_ADJ <= '1';
      elsif CLR_COMMON_OFFSET_ADJ = '1' then
        SET_COMMON_OFFSET_ADJ <= '0';              
      end if;
    end if;
  end process;  

  process(CLK10MHz,PRELOAD_DACS)
  begin
    if PRELOAD_DACS = '0' then
      SET_FULL_SCALE_ADJ <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if (PRELOAD_DACS_DEL1 = '1' and PRELOAD_DACS_DEL2 = '0') or (FULL_SCALE_ADJ /= FULL_SCALE_ADJ_DEL) then
        SET_FULL_SCALE_ADJ <= '1';
      elsif CLR_FULL_SCALE_ADJ = '1' then
        SET_FULL_SCALE_ADJ <= '0';              
      end if;
    end if;
  end process;  

  process(CLK10MHz,PRELOAD_DACS)
  begin
    if PRELOAD_DACS = '0' then
      SET_CH1_INTEGRATOR <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if (PRELOAD_DACS_DEL1 = '1' and PRELOAD_DACS_DEL2 = '0') or (CH1_INTEGRATOR /= CH1_INTEGRATOR_DEL) then
        SET_CH1_INTEGRATOR <= '1';
      elsif CLR_CH1_INTEGRATOR = '1' then
        SET_CH1_INTEGRATOR <= '0';              
      end if;
    end if;
  end process;  

  process(CLK10MHz,PRELOAD_DACS)
  begin
    if PRELOAD_DACS = '0' then
      SET_CH2_INTEGRATOR <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if (PRELOAD_DACS_DEL1 = '1' and PRELOAD_DACS_DEL2 = '0') or (CH2_INTEGRATOR /= CH2_INTEGRATOR_DEL) then
        SET_CH2_INTEGRATOR <= '1';
      elsif CLR_CH2_INTEGRATOR = '1' then
        SET_CH2_INTEGRATOR <= '0';              
      end if;
    end if;
  end process;  

  process(CLK10MHz,PRELOAD_DACS)
  begin
    if PRELOAD_DACS = '0' then
      SET_COMP_THRES_LOW <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if (PRELOAD_DACS_DEL1 = '1' and PRELOAD_DACS_DEL2 = '0') or (COMP_THRES_LOW /= COMP_THRES_LOW_DEL) then
        SET_COMP_THRES_LOW <= '1';
      elsif CLR_COMP_THRES_LOW = '1' then
        SET_COMP_THRES_LOW <= '0';              
      end if;
    end if;
  end process;  

  process(CLK10MHz,PRELOAD_DACS)
  begin
    if PRELOAD_DACS = '0' then
      SET_COMP_THRES_HIGH <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if (PRELOAD_DACS_DEL1 = '1' and PRELOAD_DACS_DEL2 = '0') or (COMP_THRES_HIGH /= COMP_THRES_HIGH_DEL) then
        SET_COMP_THRES_HIGH <= '1';
      elsif CLR_COMP_THRES_HIGH = '1' then
        SET_COMP_THRES_HIGH <= '0';              
      end if;
    end if;
  end process;  

  process(CLK10MHz,PRELOAD_DACS)
  begin
    if PRELOAD_DACS = '0' then
      SET_CH1_PMT_HV_ADJ <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if (PRELOAD_DACS_DEL1 = '1' and PRELOAD_DACS_DEL2 = '0') or (CH1_PMT_HV_ADJ /= CH1_PMT_HV_ADJ_DEL) then
        SET_CH1_PMT_HV_ADJ <= '1';
      elsif CLR_CH1_PMT_HV_ADJ = '1' then
        SET_CH1_PMT_HV_ADJ <= '0';              
      end if;
    end if;
  end process;  

  process(CLK10MHz,PRELOAD_DACS)
  begin
    if PRELOAD_DACS = '0' then
      SET_CH2_PMT_HV_ADJ <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if (PRELOAD_DACS_DEL1 = '1' and PRELOAD_DACS_DEL2 = '0') or (CH2_PMT_HV_ADJ /= CH2_PMT_HV_ADJ_DEL) then
        SET_CH2_PMT_HV_ADJ <= '1';
      elsif CLR_CH2_PMT_HV_ADJ = '1' then
        SET_CH2_PMT_HV_ADJ <= '0';              
      end if;
    end if;
  end process;  

-- Changes are done because of channelswap on the board.
-- The DAC outputs to the analog channels are driven with the register of the other
-- E.g. If you set the offset of channel 1 (by software), the offset of channel 2 will be set instead
  process(CLK10MHz,SYSRST)
  begin
    if SYSRST = '1' then
      WR_DACS <= '1';
      DAC_A2 <= '0';
      DAC_A1 <= '0';
      DAC_A0 <= '0';
      DAC_nCS1 <= '1';
      DAC_nCS2 <= '1';
      DAC_DATA_OUT <= "00000000";        
      CLR_CH1_OFFSET_ADJ_POS <= '0';
      CLR_CH1_OFFSET_ADJ_NEG <= '0';
      CLR_CH2_OFFSET_ADJ_POS <= '0';
      CLR_CH2_OFFSET_ADJ_NEG <= '0';
      CLR_CH1_GAIN_ADJ_POS <= '0';
      CLR_CH1_GAIN_ADJ_NEG <= '0';
      CLR_CH2_GAIN_ADJ_POS <= '0';
      CLR_CH2_GAIN_ADJ_NEG <= '0';
      CLR_COMMON_OFFSET_ADJ <= '0';
      CLR_FULL_SCALE_ADJ <= '0';
      CLR_CH1_INTEGRATOR <= '0';
      CLR_CH2_INTEGRATOR <= '0';
      CLR_COMP_THRES_LOW <= '0';
      CLR_COMP_THRES_HIGH <= '0';
      CLR_CH1_PMT_HV_ADJ <= '0';
      CLR_CH2_PMT_HV_ADJ <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if SET_CH1_OFFSET_ADJ_POS = '1' then
        if WR_DACS = '1' then
          DAC_DATA_OUT <= CH1_OFFSET_ADJ_POS;
--          DAC_A2 <= '1';
--          DAC_A1 <= '0';
--          DAC_A0 <= '0';
--          DAC_nCS1 <= '0';
--          DAC_nCS2 <= '1';
          DAC_A2 <= '1';
          DAC_A1 <= '1';
          DAC_A0 <= '0';
          DAC_nCS1 <= '0';
          DAC_nCS2 <= '1';
          WR_DACS <= '0';
          CLR_CH1_OFFSET_ADJ_POS <= '1';
        else
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '1';
          WR_DACS <= '1';
          CLR_CH1_OFFSET_ADJ_POS <= '0';
        end if;
      elsif SET_CH1_OFFSET_ADJ_NEG = '1' then
        if WR_DACS = '1' then
          DAC_DATA_OUT <= CH1_OFFSET_ADJ_NEG;
--          DAC_A2 <= '1';
--          DAC_A1 <= '0';
--          DAC_A0 <= '1';
--          DAC_nCS1 <= '0';
--          DAC_nCS2 <= '1';
          DAC_A2 <= '1';
          DAC_A1 <= '1';
          DAC_A0 <= '1';
          DAC_nCS1 <= '0';
          DAC_nCS2 <= '1';
          WR_DACS <= '0';
          CLR_CH1_OFFSET_ADJ_NEG <= '1';
        else
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '1';
          WR_DACS <= '1';
          CLR_CH1_OFFSET_ADJ_NEG <= '0';
        end if;
      elsif SET_CH2_OFFSET_ADJ_POS = '1' then
        if WR_DACS = '1' then
          DAC_DATA_OUT <= CH2_OFFSET_ADJ_POS;
--          DAC_A2 <= '1';
--          DAC_A1 <= '1';
--          DAC_A0 <= '0';
--          DAC_nCS1 <= '0';
--          DAC_nCS2 <= '1';
          DAC_A2 <= '1';
          DAC_A1 <= '0';
          DAC_A0 <= '0';
          DAC_nCS1 <= '0';
          DAC_nCS2 <= '1';
          WR_DACS <= '0';
          CLR_CH2_OFFSET_ADJ_POS <= '1';
        else
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '1';
          WR_DACS <= '1';
          CLR_CH2_OFFSET_ADJ_POS <= '0';
        end if;
      elsif SET_CH2_OFFSET_ADJ_NEG = '1' then
        if WR_DACS = '1' then
          DAC_DATA_OUT <= CH2_OFFSET_ADJ_NEG;
--          DAC_A2 <= '1';
--          DAC_A1 <= '1';
--          DAC_A0 <= '1';
--          DAC_nCS1 <= '0';
--          DAC_nCS2 <= '1';
          DAC_A2 <= '1';
          DAC_A1 <= '0';
          DAC_A0 <= '1';
          DAC_nCS1 <= '0';
          DAC_nCS2 <= '1';
          WR_DACS <= '0';
          CLR_CH2_OFFSET_ADJ_NEG <= '1';
        else
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '1';
          WR_DACS <= '1';
          CLR_CH2_OFFSET_ADJ_NEG <= '0';
        end if;
      elsif SET_CH1_GAIN_ADJ_POS = '1' then
        if WR_DACS = '1' then
          DAC_DATA_OUT <= CH1_GAIN_ADJ_POS;
--          DAC_A2 <= '1';
--          DAC_A1 <= '0';
--          DAC_A0 <= '0';
--          DAC_nCS1 <= '1';
--          DAC_nCS2 <= '0';
          DAC_A2 <= '1';
          DAC_A1 <= '0';
          DAC_A0 <= '1';
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '0';
          WR_DACS <= '0';
          CLR_CH1_GAIN_ADJ_POS <= '1';
        else
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '1';
          WR_DACS <= '1';
          CLR_CH1_GAIN_ADJ_POS <= '0';
        end if;
      elsif SET_CH1_GAIN_ADJ_NEG = '1' then
        if WR_DACS = '1' then
          DAC_DATA_OUT <= CH1_GAIN_ADJ_NEG;
--          DAC_A2 <= '1';
--          DAC_A1 <= '0';
--          DAC_A0 <= '1';
--          DAC_nCS1 <= '1';
--          DAC_nCS2 <= '0';
          DAC_A2 <= '1';
          DAC_A1 <= '1';
          DAC_A0 <= '1';
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '0';
          WR_DACS <= '0';
          CLR_CH1_GAIN_ADJ_NEG <= '1';
        else
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '1';
          WR_DACS <= '1';
          CLR_CH1_GAIN_ADJ_NEG <= '0';
        end if;
      elsif SET_CH2_GAIN_ADJ_POS = '1' then
        if WR_DACS = '1' then
          DAC_DATA_OUT <= CH2_GAIN_ADJ_POS;
--          DAC_A2 <= '1';
--          DAC_A1 <= '1';
--          DAC_A0 <= '0';
--          DAC_nCS1 <= '1';
--          DAC_nCS2 <= '0';
          DAC_A2 <= '1';
          DAC_A1 <= '0';
          DAC_A0 <= '0';
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '0';
          WR_DACS <= '0';
          CLR_CH2_GAIN_ADJ_POS <= '1';
        else
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '1';
          WR_DACS <= '1';
          CLR_CH2_GAIN_ADJ_POS <= '0';
        end if;
      elsif SET_CH2_GAIN_ADJ_NEG = '1' then
        if WR_DACS = '1' then
          DAC_DATA_OUT <= CH2_GAIN_ADJ_NEG;
--          DAC_A2 <= '1';
--          DAC_A1 <= '1';
--          DAC_A0 <= '1';
--          DAC_nCS1 <= '1';
--          DAC_nCS2 <= '0';
          DAC_A2 <= '1';
          DAC_A1 <= '1';
          DAC_A0 <= '0';
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '0';
          WR_DACS <= '0';
          CLR_CH2_GAIN_ADJ_NEG <= '1';
        else
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '1';
          WR_DACS <= '1';
          CLR_CH2_GAIN_ADJ_NEG <= '0';
        end if;
      elsif SET_COMMON_OFFSET_ADJ = '1' then
        if WR_DACS = '1' then
          DAC_DATA_OUT <= COMMON_OFFSET_ADJ;
          DAC_A2 <= '0';
          DAC_A1 <= '1';
          DAC_A0 <= '0';
          DAC_nCS1 <= '0';
          DAC_nCS2 <= '1';
          WR_DACS <= '0';
          CLR_COMMON_OFFSET_ADJ <= '1';
        else
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '1';
          WR_DACS <= '1';
          CLR_COMMON_OFFSET_ADJ <= '0';
        end if;
      elsif SET_FULL_SCALE_ADJ = '1' then
        if WR_DACS = '1' then
          DAC_DATA_OUT <= FULL_SCALE_ADJ;
          DAC_A2 <= '0';
          DAC_A1 <= '1';
          DAC_A0 <= '1';
          DAC_nCS1 <= '0';
          DAC_nCS2 <= '1';
          WR_DACS <= '0';
          CLR_FULL_SCALE_ADJ <= '1';
        else
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '1';
          WR_DACS <= '1';
          CLR_FULL_SCALE_ADJ <= '0';
        end if;
      elsif SET_CH1_INTEGRATOR = '1' then
        if WR_DACS = '1' then
          DAC_DATA_OUT <= CH1_INTEGRATOR;
--          DAC_A2 <= '0';
--          DAC_A1 <= '1';
--          DAC_A0 <= '0';
--          DAC_nCS1 <= '1';
--          DAC_nCS2 <= '0';
          DAC_A2 <= '0';
          DAC_A1 <= '1';
          DAC_A0 <= '1';
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '0';
          WR_DACS <= '0';
          CLR_CH1_INTEGRATOR <= '1';
        else
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '1';
          WR_DACS <= '1';
          CLR_CH1_INTEGRATOR <= '0';
        end if;
      elsif SET_CH2_INTEGRATOR = '1' then
        if WR_DACS = '1' then
          DAC_DATA_OUT <= CH2_INTEGRATOR;
--          DAC_A2 <= '0';
--          DAC_A1 <= '1';
--          DAC_A0 <= '1';
--          DAC_nCS1 <= '1';
--          DAC_nCS2 <= '0';
          DAC_A2 <= '0';
          DAC_A1 <= '1';
          DAC_A0 <= '0';
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '0';
          WR_DACS <= '0';
          CLR_CH2_INTEGRATOR <= '1';
        else
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '1';
          WR_DACS <= '1';
          CLR_CH2_INTEGRATOR <= '0';
        end if;
      elsif SET_COMP_THRES_LOW = '1' then
        if WR_DACS = '1' then
          DAC_DATA_OUT <= COMP_THRES_LOW;
          DAC_A2 <= '0';
          DAC_A1 <= '0';
          DAC_A0 <= '0';
          DAC_nCS1 <= '0';
          DAC_nCS2 <= '1';
          WR_DACS <= '0';
          CLR_COMP_THRES_LOW <= '1';
        else
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '1';
          WR_DACS <= '1';
          CLR_COMP_THRES_LOW <= '0';
        end if;
      elsif SET_COMP_THRES_HIGH = '1' then
        if WR_DACS = '1' then
          DAC_DATA_OUT <= COMP_THRES_HIGH;
          DAC_A2 <= '0';
          DAC_A1 <= '0';
          DAC_A0 <= '1';
          DAC_nCS1 <= '0';
          DAC_nCS2 <= '1';
          WR_DACS <= '0';
          CLR_COMP_THRES_HIGH <= '1';
        else
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '1';
          WR_DACS <= '1';
          CLR_COMP_THRES_HIGH <= '0';
        end if;
      elsif SET_CH1_PMT_HV_ADJ = '1' then
        if WR_DACS = '1' then
          DAC_DATA_OUT <= CH1_PMT_HV_ADJ;
          DAC_A2 <= '0';
          DAC_A1 <= '0';
          DAC_A0 <= '0';
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '0';
          WR_DACS <= '0';
          CLR_CH1_PMT_HV_ADJ <= '1';
        else
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '1';
          WR_DACS <= '1';
          CLR_CH1_PMT_HV_ADJ <= '0';
        end if;
      elsif SET_CH2_PMT_HV_ADJ = '1' then
        if WR_DACS = '1' then
          DAC_DATA_OUT <= CH2_PMT_HV_ADJ;
          DAC_A2 <= '0';
          DAC_A1 <= '0';
          DAC_A0 <= '1';
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '0';
          WR_DACS <= '0';
          CLR_CH2_PMT_HV_ADJ <= '1';
        else
          DAC_nCS1 <= '1';
          DAC_nCS2 <= '1';
          WR_DACS <= '1';
          CLR_CH2_PMT_HV_ADJ <= '0';
        end if;
      end if;
    end if;
  end process;  

  -- Readout Current ADCs
  process(CLK10MHz,SYSRST)
  begin
    if SYSRST = '1' then
      SET_CURR_ADC <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if ONE_PPS_DEL1 = '1' and ONE_PPS_DEL2 = '0' then  -- Starts at ONE_PPS
        SET_CURR_ADC <= '1';
      elsif CLR_CURR_ADC = '1' then
        SET_CURR_ADC <= '0';              
      end if;
    end if;
  end process;  

  process(CLK10MHz,SYSRST,CURR_ADC_COUNT,ADC_DATA_IN)
  begin
    if SYSRST = '1' then
      CH1_PMT_SUPPLY_CURR <= "00000000";
      CH2_PMT_SUPPLY_CURR <= "00000000";
      CLR_CURR_ADC <= '0';
      ADC_nRD <= '1';
      ADC_A0 <= '0';
      CURR_ADC_COUNT <= 0;
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if SET_CURR_ADC = '1' then
        CURR_ADC_COUNT <= CURR_ADC_COUNT + 1;
    	case (CURR_ADC_COUNT) is
      	  when 1 => ADC_A0 <= '0'; ADC_nRD <= '1';
      	  when 8 => ADC_A0 <= '0'; ADC_nRD <= '0'; -- 700ns aquisition time
      	  when 36 => ADC_A0 <= '1'; ADC_nRD <= '1'; CH1_PMT_SUPPLY_CURR <= ADC_DATA_IN; -- 2800ns conversion time
      	  when 43 => ADC_A0 <= '1'; ADC_nRD <= '0'; -- 700ns aquisition time
      	  when 71 => ADC_A0 <= '0'; ADC_nRD <= '1'; CH2_PMT_SUPPLY_CURR <= ADC_DATA_IN; CLR_CURR_ADC <= '1'; -- 2800ns conversion time
		  when others =>  -- Do nothing
    	end case;
      else
        CLR_CURR_ADC <= '0';
        ADC_nRD <= '1';
        ADC_A0 <= '0';
        CURR_ADC_COUNT <= 0;
      end if;
    end if;
  end process;  


end rtl ; -- of USB_READ_HANDLER

