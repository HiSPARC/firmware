-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'SLAVE_DETECTOR.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'SLAVE_DETECTOR' :
-- 
--   port(
--     CLK10MHz      : in     std_logic;
--     CLK200MHz     : in     std_logic;
--     SH1           : in     std_logic;
--     SH1_SYNCHR    : out    std_logic;
--     SH2           : in     std_logic;
--     SH2_SYNCHR    : out    std_logic;
--     SL1           : in     std_logic;
--     SL1_SYNCHR    : out    std_logic;
--     SL2           : in     std_logic;
--     SL2_SYNCHR    : out    std_logic;
--     SLAVE_PRESENT : out    std_logic;
--     SYSRST        : in     std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of SLAVE_DETECTOR is

signal SH1_DEL1: std_logic; -- SH1 after one 200MHz period
signal SH2_DEL1: std_logic; -- SH2 after one 200MHz period
signal SL1_DEL1: std_logic; -- SL1 after one 200MHz period
signal SL2_DEL1: std_logic; -- SL2 after one 200MHz period
signal SH1_DEL2: std_logic; -- SH1 after two 200MHz periods
signal SH2_DEL2: std_logic; -- SH2 after two 200MHz periods
signal SL1_DEL2: std_logic; -- SL1 after two 200MHz periods
signal SL2_DEL2: std_logic; -- SL2 after two 200MHz periods
signal HIT_ON_SH1: std_logic; -- Look within a SAMPLE period if SH1 went low
signal HIT_ON_SH2: std_logic; -- Look within a SAMPLE period if SH2 went low
signal HIT_ON_SL1: std_logic; -- Look within a SAMPLE period if SL1 went low
signal HIT_ON_SL2: std_logic; -- Look within a SAMPLE period if SL2 went low
signal HIT_ON_SH1_COUNTER: std_logic_vector(7 downto 0); -- The period is 25.6us. This covers at least 2 coincidence windows.
signal HIT_ON_SH2_COUNTER: std_logic_vector(7 downto 0); -- The period is 25.6us. This covers at least 2 coincidence windows.
signal HIT_ON_SL1_COUNTER: std_logic_vector(7 downto 0); -- The period is 25.6us. This covers at least 2 coincidence windows.
signal HIT_ON_SL2_COUNTER: std_logic_vector(7 downto 0); -- The period is 25.6us. This covers at least 2 coincidence windows.

begin

  SLAVE_PRESENT <= '1' when (SL1 = '0' or SL2 = '0' or SH1 = '0' or SH2 = '0' or HIT_ON_SL1 = '1' or HIT_ON_SL2 = '1' or HIT_ON_SH1 = '1' or HIT_ON_SH2 = '1') else '0';
  SL1_SYNCHR <= SL1_DEL1;
  SH1_SYNCHR <= SH1_DEL1;
  SL2_SYNCHR <= SL2_DEL1;
  SH2_SYNCHR <= SH2_DEL1;
  
  -- Delays
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      SH1_DEL1 <= '1';
      SH2_DEL1 <= '1';
      SL1_DEL1 <= '1';
      SL2_DEL1 <= '1';
      SH1_DEL2 <= '1';
      SH2_DEL2 <= '1';
      SL1_DEL2 <= '1';
      SL2_DEL2 <= '1';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      SH1_DEL1 <= SH1; 
      SH2_DEL1 <= SH2; 
      SL1_DEL1 <= SL1; 
      SL2_DEL1 <= SL2; 
      SH1_DEL2 <= SH1_DEL1; 
      SH2_DEL2 <= SH2_DEL1; 
      SL1_DEL2 <= SL1_DEL1; 
      SL2_DEL2 <= SL2_DEL1; 
    end if;
  end process;  
      
  -- 25.6us stretcher for HIT_ON_SL1
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      HIT_ON_SL1 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then 
      if SL1_DEL1 = '1' and SL1_DEL2 = '0' then  -- On an upgoing egde of SL1
        HIT_ON_SL1 <= '1'; 
      elsif HIT_ON_SL1_COUNTER = "11111111" then
        HIT_ON_SL1 <= '0';
      end if;
    end if;
  end process;  

  process(CLK10MHz,SYSRST)
  begin
    if SYSRST = '1' then
      HIT_ON_SL1_COUNTER <= "00000000";
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if HIT_ON_SL1 = '0' then -- HIT_ON_SL1 = '0' makes end of stretcher window
        HIT_ON_SL1_COUNTER <= "00000000";
      else
        HIT_ON_SL1_COUNTER <= HIT_ON_SL1_COUNTER + 1;
      end if;
    end if;
  end process;  
  
  -- 25.6us stretcher for HIT_ON_SL2
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      HIT_ON_SL2 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then 
      if SL2_DEL1 = '1' and SL2_DEL2 = '0' then  -- On an upgoing egde of SL2
        HIT_ON_SL2 <= '1'; 
      elsif HIT_ON_SL2_COUNTER = "11111111" then
        HIT_ON_SL2 <= '0';
      end if;
    end if;
  end process;  

  process(CLK10MHz,SYSRST)
  begin
    if SYSRST = '1' then
      HIT_ON_SL2_COUNTER <= "00000000";
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if HIT_ON_SL2 = '0' then -- HIT_ON_SL2 = '0' makes end of stretcher window
        HIT_ON_SL2_COUNTER <= "00000000";
      else
        HIT_ON_SL2_COUNTER <= HIT_ON_SL2_COUNTER + 1;
      end if;
    end if;
  end process;  

  -- 25.6us stretcher for HIT_ON_SH1
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      HIT_ON_SH1 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then 
      if SH1_DEL1 = '1' and SH1_DEL2 = '0' then  -- On an upgoing egde of SH1
        HIT_ON_SH1 <= '1'; 
      elsif HIT_ON_SH1_COUNTER = "11111111" then
        HIT_ON_SH1 <= '0';
      end if;
    end if;
  end process;  

  process(CLK10MHz,SYSRST)
  begin
    if SYSRST = '1' then
      HIT_ON_SH1_COUNTER <= "00000000";
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if HIT_ON_SH1 = '0' then -- HIT_ON_SH1 = '0' makes end of stretcher window
        HIT_ON_SH1_COUNTER <= "00000000";
      else
        HIT_ON_SH1_COUNTER <= HIT_ON_SH1_COUNTER + 1;
      end if;
    end if;
  end process;  

  -- 25.6us stretcher for HIT_ON_SH2
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      HIT_ON_SH2 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then 
      if SH2_DEL1 = '1' and SH2_DEL2 = '0' then  -- On an upgoing egde of SH2
        HIT_ON_SH2 <= '1'; 
      elsif HIT_ON_SH2_COUNTER = "11111111" then
        HIT_ON_SH2 <= '0';
      end if;
    end if;
  end process;  

  process(CLK10MHz,SYSRST)
  begin
    if SYSRST = '1' then
      HIT_ON_SH2_COUNTER <= "00000000";
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if HIT_ON_SH2 = '0' then -- HIT_ON_SH2 = '0' makes end of stretcher window
        HIT_ON_SH2_COUNTER <= "00000000";
      else
        HIT_ON_SH2_COUNTER <= HIT_ON_SH2_COUNTER + 1;
      end if;
    end if;
  end process;  

end rtl ; -- of SLAVE_DETECTOR

