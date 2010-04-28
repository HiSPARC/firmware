-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'a0' of 'LED_DRIVER.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'LED_DRIVER' :
-- 
--   port(
--     CLK10MHz : in     std_logic;
--     INP      : in     std_logic;
--     SYSRST   : in     std_logic;
--     nOUTP    : out    std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture a0 of LED_DRIVER is

signal LEDSHINE_COUNTER: std_logic_vector(20 downto 0); -- Full is about 0.2 seconds

begin

  process(CLK10MHz, SYSRST, INP)
  begin
    if (SYSRST = '1' or INP = '1') then
      LEDSHINE_COUNTER <= "000000000000000000000";
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if (LEDSHINE_COUNTER /= "111111111111111111111") then
        LEDSHINE_COUNTER <= LEDSHINE_COUNTER + "000000000000000000001";
      else
        LEDSHINE_COUNTER <= LEDSHINE_COUNTER; -- locks at full
      end if;
    end if;
  end process;

  nOUTP <= '0' when (LEDSHINE_COUNTER /= "111111111111111111111") else '1';

end architecture a0 ; -- of LED_DRIVER

