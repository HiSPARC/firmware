-- EASE/HDL begin --------------------------------------------------------------
-- 
-- Architecture 'a0' of entity 'INVERTER'.
-- 
--------------------------------------------------------------------------------
-- 
-- Copy of the interface declaration:
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

