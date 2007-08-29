-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'LED_ONE_SHOT.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'LED_ONE_SHOT' :
-- 
--   port(
--     CLK10MHz : in     std_logic;
--     INP      : in     std_logic;
--     SYSRST   : in     std_logic;
--     nOUTP    : out    std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of LED_ONE_SHOT is

signal LEDSHINE_COUNTER: std_logic_vector(20 downto 0); -- Full is about 0.2 seconds
signal INP_DEL: std_logic;

begin
    
  process(CLK10MHz,SYSRST,INP)
  begin
    if SYSRST = '1' then
      INP_DEL <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      INP_DEL <= INP;
    end if;
  end process;  

  process(CLK10MHz,SYSRST,INP)
  begin
    if SYSRST = '1' then
      LEDSHINE_COUNTER <= "111111111111111111111";
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if INP = '1' and INP_DEL = '0' then
        LEDSHINE_COUNTER <= "000000000000000000000";
      elsif LEDSHINE_COUNTER /= "111111111111111111111" then
        LEDSHINE_COUNTER <= LEDSHINE_COUNTER + "000000000000000000001";
      else   
        LEDSHINE_COUNTER <= LEDSHINE_COUNTER; -- locks at full
      end if;
    end if;
  end process;  

  nOUTP <= '0' when LEDSHINE_COUNTER /= "111111111111111111111" else '1'; 


end rtl ; -- of LED_ONE_SHOT

