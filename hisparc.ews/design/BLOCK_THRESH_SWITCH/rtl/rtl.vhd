-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'BLOCK_THRESH_SWITCH.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'BLOCK_THRESH_SWITCH' :
-- 
--   port(
--     BLOCK_COINC : in     std_logic;
--     CLK200MHz   : in     std_logic;
--     MASTER      : in     std_logic;
--     MH1         : in     std_logic;
--     MH1_OUT     : out    std_logic;
--     MH2         : in     std_logic;
--     MH2_OUT     : out    std_logic;
--     ML1         : in     std_logic;
--     ML1_OUT     : out    std_logic;
--     ML2         : in     std_logic;
--     ML2_OUT     : out    std_logic;
--     SYSRST      : in     std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of BLOCK_THRESH_SWITCH is

begin

-- Als een slave zijn block_coinc naar een master door wil geven, dan doet hij dat door de threshold signalen
-- op een normaal niet bestaande / mogelijke waarde te zetten, namelijk: wel hoge threshold waarden, zonder lage waarden.

  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      ML1_OUT <= '0';
      ML2_OUT <= '0';
      MH1_OUT <= '0';
      MH2_OUT <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if MASTER = '0' and BLOCK_COINC = '1' then 
        ML1_OUT <= '0';
        ML2_OUT <= '0';
        MH1_OUT <= '1';
        MH2_OUT <= '1';
      else
        ML1_OUT <= ML1;
        ML2_OUT <= ML2;
        MH1_OUT <= MH1;
        MH2_OUT <= MH2;
      end if;
    end if;
  end process;  


end rtl ; -- of BLOCK_THRESH_SWITCH

