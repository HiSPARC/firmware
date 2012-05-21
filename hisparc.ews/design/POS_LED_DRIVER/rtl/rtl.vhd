-- EASE/HDL begin --------------------------------------------------------------
-- 
-- Architecture 'rtl' of entity 'POS_LED_DRIVER'.
-- 
--------------------------------------------------------------------------------
-- 
-- Copy of the interface declaration:
-- 
--   port(
--     CLK10MHz : in     std_logic;
--     INP      : in     std_logic;
--     OUTP     : out    std_logic;
--     SYSRST   : in     std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of POS_LED_DRIVER is

signal LEDSHINE_COUNTER: std_logic_vector(21 downto 0); -- Full is about 0.4 seconds

begin
    
  process(CLK10MHz,SYSRST,INP)
  begin
    if SYSRST = '1' or INP = '1' then
      LEDSHINE_COUNTER <= "0000000000000000000000";
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if LEDSHINE_COUNTER /= "1111111111111111111111" then
        LEDSHINE_COUNTER <= LEDSHINE_COUNTER + "0000000000000000000001";
      else   
        LEDSHINE_COUNTER <= LEDSHINE_COUNTER; -- locks at full
      end if;
    end if;
  end process;  

  OUTP <= '1' when LEDSHINE_COUNTER /= "1111111111111111111111" else '0'; 

end rtl ; -- of POS_LED_DRIVER

