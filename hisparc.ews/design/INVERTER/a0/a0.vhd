-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'a0' of 'INVERTER.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'INVERTER' :
-- 
--   port(
--     INP  : in     std_logic;
--     OUTP : out    std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture a0 of INVERTER is

begin

  OUTP <= not INP;

end architecture a0 ; -- of INVERTER

