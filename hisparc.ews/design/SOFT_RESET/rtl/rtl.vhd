-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'SOFT_RESET.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'SOFT_RESET' :
-- 
--   port(
--     CLKRD   : in     std_logic;
--     RESOUT  : out    std_logic;
--     SRESET  : in     std_logic;
--     TORESET : in     std_logic;
--     nHRESET : in     std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of SOFT_RESET is

signal SRESET_COUNT: std_logic_vector(3 downto 0);

begin

  RESOUT <= not SRESET_COUNT(3) or not nHRESET;
  
  process (CLKRD, nHRESET)
  begin
	  if nHRESET = '0' then
	    SRESET_COUNT <= (others => '1');                 
	  elsif CLKRD'event and CLKRD = '1' then
      if SRESET = '1' or TORESET = '1' then
	      SRESET_COUNT <= (others => '0');                 
	    elsif SRESET_COUNT /= "1111" then 
		    SRESET_COUNT <= SRESET_COUNT + "0001";
	    else
		    SRESET_COUNT <= SRESET_COUNT;
	    end if;
	  end if;
  end process;

end rtl ; -- of SOFT_RESET

