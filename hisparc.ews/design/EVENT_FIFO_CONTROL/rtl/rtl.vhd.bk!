-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'EVENT_FIFO_CONTROL.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'EVENT_FIFO_CONTROL' :
-- 
--   port(
--     CLKRD            : in     std_logic;
--     DATA_READY_CONV  : in     std_logic;
--     DOUT_VALID       : out    std_logic;
--     EVENT_DATA_READY : out    std_logic;
--     FIFO_EMPTY       : out    std_logic;
--     RDCLOCK          : out    std_logic;
--     RDEN             : in     std_logic;
--     RD_ADDRESS       : out    integer range 12020 downto 0;
--     SYSRST           : in     std_logic;
--     TOTAL_TIME_6X    : in     integer range 12000 downto 0);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of EVENT_FIFO_CONTROL is

signal DATA_READY_CONV_DEL: std_logic;
signal DATA_VALID_TMP: std_logic;
signal DATA_VALID_TMP2: std_logic;
signal EVENT_DATA_READY_TMP: std_logic;
signal EVENT_DATA_READY_TMP2: std_logic;
signal RDEN_TMP: std_logic; -- needed to synchronize read enable
signal RD_ADDRESS_TMP: integer range 12020 downto 0;


begin

  RD_ADDRESS <= RD_ADDRESS_TMP;
  RDCLOCK <= CLKRD;
  DOUT_VALID <= DATA_VALID_TMP2 and EVENT_DATA_READY_TMP2;
  EVENT_DATA_READY <= EVENT_DATA_READY_TMP;
  FIFO_EMPTY <= not EVENT_DATA_READY_TMP;
  
  -- Delay's
  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      DATA_READY_CONV_DEL <= '0';
      DATA_VALID_TMP2 <= '0';
      EVENT_DATA_READY_TMP2 <= '0';
      RDEN_TMP <= '0';
    elsif (CLKRD'event and CLKRD = '1') then
      DATA_READY_CONV_DEL <= DATA_READY_CONV;
      DATA_VALID_TMP2 <= DATA_VALID_TMP;
      EVENT_DATA_READY_TMP2 <= EVENT_DATA_READY_TMP;
      RDEN_TMP <= RDEN;
    end if;
  end process;  
  

  -- EVENT_DATA_READY must be valid if DATA_READY_CONV goes true.
  -- in other words: the USB device gets the signal that there is data in the FIFO to readout.
  -- EVENT_DATA_READY must go low at the end of readout.
  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      EVENT_DATA_READY_TMP <= '0';
    elsif (CLKRD'event and CLKRD = '1') then
      -- on a positive edge of DATA_READY_CONV
      if DATA_READY_CONV = '1' and DATA_READY_CONV_DEL = '0' then
        EVENT_DATA_READY_TMP <= '1';
      elsif RD_ADDRESS_TMP > TOTAL_TIME_6X - 1 then
        EVENT_DATA_READY_TMP <= '0';
      else
        EVENT_DATA_READY_TMP <= EVENT_DATA_READY_TMP;
      end if;  
    end if;
  end process;  

  -- This signal is true when the data from the FIFO is valid.
  -- DATA_VALID must be valid if DATA_READY_CONV goes true and USB asks for readout.
  -- DATA_VALID must go low at the end of readout.
  process(CLKRD,SYSRST)
  begin
    if SYSRST = '1' then
      DATA_VALID_TMP <= '0';
      RD_ADDRESS_TMP <= 0;
    elsif (CLKRD'event and CLKRD = '1') then
      if EVENT_DATA_READY_TMP = '1' then
        if RDEN_TMP = '1' then
          DATA_VALID_TMP <= '1';
          RD_ADDRESS_TMP <= RD_ADDRESS_TMP + 1;
        else
          DATA_VALID_TMP <= '0';
          RD_ADDRESS_TMP <= RD_ADDRESS_TMP;
        end if;
      else    
        RD_ADDRESS_TMP <= 0;        
        DATA_VALID_TMP <= '0';
      end if;  
    end if;
  end process;  



end rtl ; -- of EVENT_FIFO_CONTROL

