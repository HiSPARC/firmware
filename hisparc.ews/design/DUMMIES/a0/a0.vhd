-- EASE/HDL begin --------------------------------------------------------------
-- 
-- Architecture 'a0' of entity 'DUMMIES'.
-- 
--------------------------------------------------------------------------------
-- 
-- Copy of the interface declaration:
-- 
--   port(
--     CLK10MHz   : in     std_logic;
--     INTF1_IO   : in     std_logic_vector(2 downto 0);
--     INTF2_IO   : in     std_logic_vector(7 downto 0);
--     LED4       : out    std_logic;
--     LED5       : out    std_logic;
--     LED6       : out    std_logic;
--     LED7       : out    std_logic;
--     SYSRST     : in     std_logic;
--     USB_nPWREN : in     std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture a0 of DUMMIES is

begin

-- The ADC input signals are not connected

-- LED1 is used for SLAVE_PRESENT
-- LED2 is used for MASTER (GPS PRESENT)
-- LED3 is used for COINC
  LED4 <= '0';
  LED5 <= '0';
  LED6 <= '0';
  LED7 <= '0';

end architecture a0 ; -- of DUMMIES

