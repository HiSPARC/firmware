-- EASE/HDL begin --------------------------------------------------------------
-- 
-- Architecture 'rtl' of entity 'LED_SELECT'.
-- 
--------------------------------------------------------------------------------
-- 
-- Copy of the interface declaration:
-- 
--   port(
--     LED_PATTERN    : out    std_logic_vector(3 downto 0);
--     MASTER         : in     std_logic;
--     MASTER_PATTERN : in     std_logic_vector(3 downto 0);
--     SLAVE_PATTERN  : in     std_logic_vector(3 downto 0));
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of LED_SELECT is

begin

  LED_PATTERN <= MASTER_PATTERN when MASTER = '1' else SLAVE_PATTERN;

end rtl ; -- of LED_SELECT

