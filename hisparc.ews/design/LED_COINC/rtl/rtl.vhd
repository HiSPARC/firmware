-- EASE/HDL begin --------------------------------------------------------------
-- 
-- Architecture 'rtl' of entity 'LED_COINC'.
-- 
--------------------------------------------------------------------------------
-- 
-- Copy of the interface declaration:
-- 
--   port(
--     CLK10MHz    : in     std_logic;
--     CLK200MHz   : in     std_logic;
--     HIT_PATTERN : out    std_logic_vector(7 downto 0);
--     M1          : in     std_logic;
--     M2          : in     std_logic;
--     S1          : in     std_logic;
--     S2          : in     std_logic;
--     STROBE      : out    std_logic;
--     SYSRST      : in     std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of LED_COINC is

signal M1_DEL: std_logic ;
signal M2_DEL: std_logic ;
signal S1_DEL: std_logic ;
signal S2_DEL: std_logic ;
signal M1_DEL2: std_logic ;
signal M2_DEL2: std_logic ;
signal S1_DEL2: std_logic ;
signal S2_DEL2: std_logic ;

-- 2 Hit signals
signal M1M2: std_logic ;-- Hitpattern "00001100"
signal M1S1: std_logic ;-- Hitpattern "00001010"
signal M1S2: std_logic ;-- Hitpattern "00001001"
signal M2S1: std_logic ;-- Hitpattern "00000110"
signal M2S2: std_logic ;-- Hitpattern "00000101"
signal S1S2: std_logic ;-- Hitpattern "00000011"
signal M1M2_DEL: std_logic ;
signal M1S1_DEL: std_logic ;
signal M1S2_DEL: std_logic ;
signal M2S1_DEL: std_logic ;
signal M2S2_DEL: std_logic ;
signal S1S2_DEL: std_logic ;

-- 3 Hit signals
signal M1M2S1: std_logic ;-- Hitpattern "11100000"
signal M1M2S2: std_logic ;-- Hitpattern "11010000"
signal M2S1S2: std_logic ;-- Hitpattern "10110000"
signal S1S2M1: std_logic ;-- Hitpattern "01110000"
signal M1M2S1_DEL: std_logic ;
signal M1M2S2_DEL: std_logic ;
signal M2S1S2_DEL: std_logic ;
signal S1S2M1_DEL: std_logic ;

signal HOLDOFF: std_logic ;
signal HOLDOFF_10MHz: std_logic ;
signal HOLDOFF_200MHz_START: std_logic ;
signal HOLDOFF_200MHz_SYNCHR1: std_logic ;
signal HOLDOFF_200MHz_SYNCHR2: std_logic ;
signal HOLDOFF_COUNTER: std_logic_vector(23 downto 0); -- Full is about 1.6 seconds

begin

  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      M1_DEL <= '0';
      M2_DEL <= '0';
      S1_DEL <= '0';
      S2_DEL <= '0';
      M1_DEL2 <= '0';
      M2_DEL2 <= '0';
      S1_DEL2 <= '0';
      S2_DEL2 <= '0';
      M1M2 <= '0';
      M1S1 <= '0';
      M1S2 <= '0';
      M2S1 <= '0';
      M2S2 <= '0';
      S1S2 <= '0';
      M1M2_DEL <= '0';
      M1S1_DEL <= '0';
      M1S2_DEL <= '0';
      M2S1_DEL <= '0';
      M2S2_DEL <= '0';
      S1S2_DEL <= '0';
      M1M2S1 <= '0';
      M1M2S2 <= '0';
      M2S1S2 <= '0';
      S1S2M1 <= '0';
      M1M2S1_DEL <= '0';
      M1M2S2_DEL <= '0';
      M2S1S2_DEL <= '0';
      S1S2M1_DEL <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      M1_DEL <= M1;        
      M2_DEL <= M2;        
      S1_DEL <= S1;        
      S2_DEL <= S2;        
      M1_DEL2 <= M1_DEL;        
      M2_DEL2 <= M2_DEL;        
      S1_DEL2 <= S1_DEL;        
      S2_DEL2 <= S2_DEL;        
      M1M2 <= M1 and M2;        
      M1M2_DEL <= M1M2;        
      M1S1 <= M1 and S1;        
      M1S1_DEL <= M1S1;        
      M1S2 <= M1 and S2;        
      M1S2_DEL <= M1S2;        
      M2S1 <= M2 and S1;        
      M2S1_DEL <= M2S1;        
      M2S2 <= M2 and S2;        
      M2S2_DEL <= M2S2;        
      S1S2 <= S1 and S2;        
      S1S2_DEL <= S1S2;        
      M1M2S1 <= M1 and M2 and S1;        
      M1M2S1_DEL <= M1M2S1;        
      M1M2S2 <= M1 and M2 and S2;        
      M1M2S2_DEL <= M1M2S2;        
      M2S1S2 <= M2 and S1 and S2;        
      M2S1S2_DEL <= M2S1S2;        
      S1S2M1 <= S1 and S2 and M1;        
      S1S2M1_DEL <= S1S2M1;        
    end if;
  end process;  

  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      HOLDOFF_200MHz_START <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if HOLDOFF = '0' and HOLDOFF_200MHz_START = '0' then
        if   (M1M2S1 = '0' and M1M2S1_DEL = '1') 
          or (M1M2S2 = '0' and M1M2S2_DEL = '1') 
          or (M2S1S2 = '0' and M2S1S2_DEL = '1') 
          or (S1S2M1 = '0' and S1S2M1_DEL = '1') then
          HOLDOFF_200MHz_START <= '1';
          HIT_PATTERN(7) <= M1_DEL2;
          HIT_PATTERN(6) <= M2_DEL2;
          HIT_PATTERN(5) <= S1_DEL2;
          HIT_PATTERN(4) <= S2_DEL2;
          HIT_PATTERN(3 downto 0) <= "0000";
        elsif (M1M2 = '0' and M1M2_DEL = '1') 
          or  (M1S1 = '0' and M1S1_DEL = '1') 
          or  (M1S2 = '0' and M1S2_DEL = '1') 
          or  (M2S1 = '0' and M2S1_DEL = '1') 
          or  (M2S2 = '0' and M2S2_DEL = '1') 
          or  (S1S2 = '0' and S1S2_DEL = '1') then
          HOLDOFF_200MHz_START <= '1';
          HIT_PATTERN(3) <= M1_DEL2;
          HIT_PATTERN(2) <= M2_DEL2;
          HIT_PATTERN(1) <= S1_DEL2;
          HIT_PATTERN(0) <= S2_DEL2;
          HIT_PATTERN(7 downto 4) <= "0000";
        end if;
      else
        HOLDOFF_200MHz_START <= '0';
      end if;
    end if;
  end process;  

  process(CLK10MHz,SYSRST,HOLDOFF_200MHz_START)
  begin
    if SYSRST = '1' or HOLDOFF_200MHz_START = '1' then
      HOLDOFF_COUNTER <= "000000000000000000000000";
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if HOLDOFF_COUNTER /= "111111111111111111111111" then
        HOLDOFF_COUNTER <= HOLDOFF_COUNTER + "000000000000000000000001";
      else   
        HOLDOFF_COUNTER <= HOLDOFF_COUNTER; -- locks at full
      end if;
    end if;
  end process;  

  HOLDOFF_10MHz <= '1' when HOLDOFF_COUNTER /= "111111111111111111111111" else '0'; 

  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      HOLDOFF_200MHz_SYNCHR1 <= '0';
      HOLDOFF_200MHz_SYNCHR2 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      HOLDOFF_200MHz_SYNCHR1 <= HOLDOFF_10MHz;
      HOLDOFF_200MHz_SYNCHR2 <= HOLDOFF_200MHz_SYNCHR1;
    end if;
  end process;  

  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      HOLDOFF <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if HOLDOFF_200MHz_SYNCHR1 = '0' and HOLDOFF_200MHz_SYNCHR2 = '1' then -- negative edge
        HOLDOFF <= '0';
      elsif HOLDOFF_200MHz_START = '1' then
        HOLDOFF <= '1';
      end if;
    end if;
  end process;  

  process(CLK10MHz,SYSRST)
  begin
    if SYSRST = '1' then
      STROBE <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      STROBE <= HOLDOFF_10MHz;
    end if;
  end process;  

end rtl ; -- of LED_COINC

