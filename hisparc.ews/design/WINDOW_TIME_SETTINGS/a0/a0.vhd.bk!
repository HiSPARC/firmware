-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'a0' of 'WINDOW_TIME_SETTINGS.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'WINDOW_TIME_SETTINGS' :
-- 
--   port(
--     COINC_TIME    : out    integer range 1000 downto 0;
--     POST_TIME     : out    integer range 1600 downto 0;
--     TOTAL_TIME    : out    integer range 2000 downto 0;
--     TOTAL_TIME_3X : out    integer range 6000 downto 0);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture a0 of WINDOW_TIME_SETTINGS is

signal PRE_TIME_SET: integer range 400 downto 0;-- The maximum PRE_TIME_SET can be 2 us. This are 400 steps of 5 ns. 
signal COINC_TIME_SET: integer range 1000 downto 0;-- The maximum COINC_TIME_SET can be 5 us. This are 1000 steps of 5 ns.  
signal POST_TIME_SET: integer range 1600 downto 0;-- The maximum POST_TIME_SET can be 8 us. This are 1600 steps of 5 ns.  
signal TOTAL_TIME_TMP: integer range 2000 downto 0;-- The maximum TOTAL_TIME can be 10 us. This are 2000 steps of 5 ns. 

begin
  PRE_TIME_SET <= 5;
  POST_TIME_SET <= 10;
  COINC_TIME_SET <= 10;
  COINC_TIME <= COINC_TIME_SET;
  POST_TIME <= POST_TIME_SET;
  TOTAL_TIME_TMP <= PRE_TIME_SET + COINC_TIME_SET + POST_TIME_SET when (PRE_TIME_SET + COINC_TIME_SET + POST_TIME_SET) <= 2000 else TOTAL_TIME_TMP;
  TOTAL_TIME <= TOTAL_TIME_TMP;
  TOTAL_TIME_3X <= TOTAL_TIME_TMP + TOTAL_TIME_TMP + TOTAL_TIME_TMP;
  
end a0 ; -- of WINDOW_TIME_SETTINGS

