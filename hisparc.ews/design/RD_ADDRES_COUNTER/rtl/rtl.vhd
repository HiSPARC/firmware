-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'RD_ADDRES_COUNTER.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'RD_ADDRES_COUNTER' :
-- 
--   port(
--     BEGIN_PRE_TIME    : in     integer range 2020 downto 0;
--     CLK200MHz         : in     std_logic;
--     CLKRD             : in     std_logic;
--     COINC_TO_END_TIME : in     std_logic;
--     DATA_OUT          : out    std_logic_vector(11 downto 0);
--     DATA_OUT_NEG      : in     std_logic_vector(11 downto 0);
--     DATA_OUT_POS      : in     std_logic_vector(11 downto 0);
--     DATA_READY        : out    std_logic;
--     RDEN              : in     std_logic;
--     RD_ADDRESS        : out    integer range 2020 downto 0;
--     READOUT_BUSY      : out    std_logic;
--     SYSRST            : in     std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of RD_ADDRES_COUNTER is

signal TAKE_DATA: std_logic ; -- RAMs are in write mode when true
signal RD_ADDRESS_TMP: integer range 2020 downto 0 ;  
signal POS_NEG_PHASE: std_logic ; -- help signal to determine the positive or negative RAM; high means positive
signal READOUT_BUSY_TMP: std_logic ;
signal DATA_READY_PRE: std_logic ;
signal DATA_OUT_TMP: std_logic_vector(11 downto 0);
signal COINC_TO_END_TIME_DEL: std_logic ;
signal RDEN_DEL1: std_logic ;
signal RDEN_DEL2: std_logic ;

begin

  RD_ADDRESS <= RD_ADDRESS_TMP;
      
  -- delays
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COINC_TO_END_TIME_DEL <= '0';
      RDEN_DEL1 <= '0';
      RDEN_DEL2 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      COINC_TO_END_TIME_DEL <= COINC_TO_END_TIME;
      RDEN_DEL1 <= RDEN;
      RDEN_DEL2 <= RDEN_DEL1;
    end if;
  end process;  

  -- Data taking TAKE_DATA stops at end of COINC_TO_END_TIME and starts again after the FIFO has been readout
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TAKE_DATA <= '1';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COINC_TO_END_TIME = '0' and COINC_TO_END_TIME_DEL = '1' then -- on a negative edge of COINC_TO_END_TIME
        TAKE_DATA <= '0';
      elsif RDEN_DEL1 = '0' and RDEN_DEL2 = '1' then -- on a negative edge of RDEN
        TAKE_DATA <= '1';
      end if;
    end if;
  end process;  

  -- DATA_READY is valid when the FIFOs are not taking data
  -- not TAKE_DATA is synchronized with the readoutclock
  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      DATA_READY_PRE <= '0';
    elsif (CLKRD'event and CLKRD = '1') then
      DATA_READY_PRE <= not TAKE_DATA;
      DATA_READY <= DATA_READY_PRE;
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

end rtl ; -- of RD_ADDRES_COUNTER

