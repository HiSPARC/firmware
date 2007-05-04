-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'CLK_DIV.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'CLK_DIV' :
-- 
--   port(
--     CLK10MHz : in     std_logic;
--     CLKRD    : out    std_logic;
--     SYSRST   : in     std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of CLK_DIV is

signal CLKRD_TMP: std_logic;

begin
  CLKRD <= CLKRD_TMP;

  process(CLK10MHz,SYSRST)
  begin
  	if SYSRST = '1' then
  	  CLKRD_TMP <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '0') then -- let op: CLKRD gaat op een negatieve flank
  	  CLKRD_TMP <=  not CLKRD_TMP;
    end if;
  end process;

end rtl ; -- of CLK_DIV

