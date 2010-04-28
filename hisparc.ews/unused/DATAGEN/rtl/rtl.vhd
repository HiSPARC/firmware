-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'DATAGEN.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'DATAGEN' :
-- 
--   port(
--     DATA_OUT1 : out    std_logic_vector(11 downto 0);
--     DATA_OUT2 : out    std_logic_vector(11 downto 0));
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of DATAGEN is

begin
DATA_OUT1 <= "000000100000"; 
DATA_OUT2 <= "110000000000"; 
end architecture rtl ; -- of DATAGEN

