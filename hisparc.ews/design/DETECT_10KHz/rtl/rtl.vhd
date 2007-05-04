-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'DETECT_10KHz.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'DETECT_10KHz' :
-- 
--   port(
--     CLK10MHz : in     std_logic;
--     GPS10KHz : in     std_logic;
--     MASTER   : out    std_logic;
--     SYSRST   : in     std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of DETECT_10KHz is

signal GPS10KHz_DEL1: std_logic; -- GPS10KHz after one 10MHz period
signal GPS10KHz_DEL2: std_logic; -- GPS10KHz after two 10MHz periods
signal LIFETIME_10KHz_COUNTER: std_logic_vector(11 downto 0);

begin

-- The LIFETIME_10KHz_COUNTER is a free running counter, which can be resetted
-- at a upgoing edge of the GPS10KHz signal. If this signal is present, the counter
-- will not come to its maximum. The MSB bit will be high, when there is
-- no GPS10KHz signal.

  MASTER <= not LIFETIME_10KHz_COUNTER(11);
  
  -- Delays
  process(CLK10MHz,SYSRST)
  begin
    if SYSRST = '1' then
      GPS10KHz_DEL1 <= '0';
      GPS10KHz_DEL2 <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      GPS10KHz_DEL1 <= GPS10KHz; 
      GPS10KHz_DEL2 <= GPS10KHz_DEL1; 
    end if;
  end process;  
  
  process(CLK10MHz,SYSRST)
  begin
    if SYSRST = '1' then
      LIFETIME_10KHz_COUNTER <= "000000000000";
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if GPS10KHz_DEL1 = '1' and GPS10KHz_DEL2 = '0' then
        LIFETIME_10KHz_COUNTER <= "000000000000"; -- GPS10KHz present
      elsif LIFETIME_10KHz_COUNTER = "111111111111" then
        LIFETIME_10KHz_COUNTER <= LIFETIME_10KHz_COUNTER;
      else   
        LIFETIME_10KHz_COUNTER <= LIFETIME_10KHz_COUNTER + "000000000001";
      end if;
    end if;
  end process;  
  

end rtl ; -- of DETECT_10KHz

