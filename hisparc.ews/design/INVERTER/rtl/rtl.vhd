-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'INVERTER.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'INVERTER' :
-- 
--   port(
--     INP  : in     std_logic;
--     OUTP : out    std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of INVERTER is

begin
  OUTP <= not INP;
end rtl ; -- of INVERTER

