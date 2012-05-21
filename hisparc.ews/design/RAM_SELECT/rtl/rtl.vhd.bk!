-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'RAM_SELECT.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'RAM_SELECT' :
-- 
--   port(
--     CLK200MHz          : in     std_logic;
--     CLKRD              : in     std_logic;
--     COINC_TO_END_TIME  : in     std_logic;
--     COINC_TO_END_TIME1 : out    std_logic;
--     COINC_TO_END_TIME2 : out    std_logic;
--     DATA_OUT           : out    std_logic_vector(11 downto 0);
--     DATA_OUT1          : in     std_logic_vector(11 downto 0);
--     DATA_OUT2          : in     std_logic_vector(11 downto 0);
--     DATA_READY         : out    std_logic;
--     DATA_READY1        : in     std_logic;
--     DATA_READY2        : in     std_logic;
--     DATA_VALID         : out    std_logic;
--     RDEN               : in     std_logic;
--     RDEN1              : out    std_logic;
--     RDEN2              : out    std_logic;
--     READOUT_BUSY1      : in     std_logic;
--     READOUT_BUSY2      : in     std_logic;
--     SYSRST             : in     std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of RAM_SELECT is
 
signal READY: std_logic_vector(1 downto 0);  
signal DATA_READY1_DEL: std_logic;  
signal DATA_READY2_DEL: std_logic;  
signal COINC_TO_END_TIME1_TMP: std_logic;  
signal COINC_TO_END_TIME2_TMP: std_logic;  
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

  process(READY,DATA_OUT1,DATA_READY1,DATA_OUT2,DATA_READY2,RDEN,COINC_TO_END_TIME)
  begin
    case(READY) is
      when "00" => DATA_OUT <= DATA_OUT1;        
                   DATA_READY <= DATA_READY1;
                   RDEN1 <= RDEN;
                   RDEN2 <= '0';
                   COINC_TO_END_TIME1_TMP <= COINC_TO_END_TIME;
                   COINC_TO_END_TIME2_TMP <= '0';
      when "01" => DATA_OUT <= DATA_OUT1;        
                   DATA_READY <= DATA_READY1;
                   RDEN1 <= RDEN;
                   RDEN2 <= '0';
                   COINC_TO_END_TIME1_TMP <= '0';
                   COINC_TO_END_TIME2_TMP <= COINC_TO_END_TIME;
      when "10" => DATA_OUT <= DATA_OUT2;        
                   DATA_READY <= DATA_READY2;
                   RDEN1 <= '0';
                   RDEN2 <= RDEN;
                   COINC_TO_END_TIME1_TMP <= COINC_TO_END_TIME;
                   COINC_TO_END_TIME2_TMP <= '0';
      when "11" => DATA_OUT <= DATA_OUT1; -- never assigned       
                   DATA_READY <= DATA_READY1;
                   RDEN1 <= RDEN;
                   RDEN2 <= '0';
                   COINC_TO_END_TIME1_TMP <= COINC_TO_END_TIME;
                   COINC_TO_END_TIME2_TMP <= '0';
    end case;
  end process; 

end rtl ; -- of RAM_SELECT

