-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'a0' of 'LED_ONE_SHOT.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'LED_ONE_SHOT' :
-- 
--   port(
--     CLK10MHz : in     std_logic;
--     INP      : in     std_logic;
--     STARTUP  : in     std_logic;
--     SYSRST   : in     std_logic;
--     nOUTP    : out    std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture a0 of LED_ONE_SHOT is

signal LEDSHINE_COUNTER: std_logic_vector(20 downto 0); -- Full is about 0.2 seconds
signal LED_ON: std_logic;

begin

  process(CLK10MHz, SYSRST, INP)
  begin
    if (SYSRST = '1' or INP = '1') then
      LEDSHINE_COUNTER <= "000000000000000000000";
      LED_ON <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if (LEDSHINE_COUNTER /= "111111111111111111111") then
        LEDSHINE_COUNTER <= LEDSHINE_COUNTER + "000000000000000000001";
        LED_ON <= '1';
      else
        LEDSHINE_COUNTER <= LEDSHINE_COUNTER; -- locks at full
        LED_ON <= '0';
      end if;
    end if;
  end process;

  nOUTP <= STARTUP or not LED_ON;

end architecture a0 ; -- of LED_ONE_SHOT

