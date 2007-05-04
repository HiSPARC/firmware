-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'TRIGGER_AND_THRESHOLD_SETTINGS.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'TRIGGER_AND_THRESHOLD_SETTINGS' :
-- 
--   port(
--     THH1       : out    std_logic_vector(11 downto 0);
--     THH2       : out    std_logic_vector(11 downto 0);
--     THL1       : out    std_logic_vector(11 downto 0);
--     THL2       : out    std_logic_vector(11 downto 0);
--     TR_PATTERN : out    std_logic_vector(4 downto 0));
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of TRIGGER_AND_THRESHOLD_SETTINGS is

signal THRESHOLD_LOW1_SET: std_logic_vector(11 downto 0);
signal THRESHOLD_LOW2_SET: std_logic_vector(11 downto 0);
signal THRESHOLD_HIGH1_SET: std_logic_vector(11 downto 0);
signal THRESHOLD_HIGH2_SET: std_logic_vector(11 downto 0);
signal TR_PATTERN_SET: std_logic_vector(4 downto 0);

begin

THRESHOLD_LOW1_SET <= "000001000000";
THRESHOLD_LOW2_SET <= "000001111100";
THRESHOLD_HIGH1_SET <= "000100000000";
THRESHOLD_HIGH2_SET <= "000010000000";
TR_PATTERN_SET <= "00001";-- any high signals
THL1 <= THRESHOLD_LOW1_SET;
THL2 <= THRESHOLD_LOW2_SET;
THH1 <= THRESHOLD_HIGH1_SET;
THH2 <= THRESHOLD_HIGH2_SET;
TR_PATTERN <= TR_PATTERN_SET;

end rtl ; -- of TRIGGER_AND_THRESHOLD_SETTINGS

