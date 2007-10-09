-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'LVDS_MUX.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'LVDS_MUX' :
-- 
--   port(
--     CLK200MHz       : in     std_logic;
--     COINC           : out    std_logic;
--     COINC_MASTER    : in     std_logic;
--     GPS_DATA_MASTER : in     std_logic;
--     GPS_DATA_OUT    : out    std_logic;
--     LVDS_IN1        : in     std_logic;
--     LVDS_IN2        : in     std_logic;
--     LVDS_IN3        : in     std_logic;
--     LVDS_IN4        : in     std_logic;
--     LVDS_OUT1       : out    std_logic;
--     LVDS_OUT2       : out    std_logic;
--     LVDS_OUT3       : out    std_logic;
--     LVDS_OUT4       : out    std_logic;
--     MASTER          : in     std_logic;
--     MH1             : in     std_logic;
--     MH2             : in     std_logic;
--     ML1             : in     std_logic;
--     ML2             : in     std_logic;
--     ONE_PPS_MASTER  : in     std_logic;
--     ONE_PPS_OUT     : out    std_logic;
--     SH1             : out    std_logic;
--     SH2             : out    std_logic;
--     SL1             : out    std_logic;
--     SL2             : out    std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of LVDS_MUX is

begin

  SL1 <= LVDS_IN1 when MASTER = '1' else '1';
  SH1 <= LVDS_IN2 when MASTER = '1' else '1';
  SL2 <= LVDS_IN3 when MASTER = '1' else '1';
  SH2 <= LVDS_IN4 when MASTER = '1' else '1';

  GPS_DATA_OUT <= GPS_DATA_MASTER when MASTER = '1' else LVDS_IN1;
  ONE_PPS_OUT <= ONE_PPS_MASTER when MASTER = '1' else LVDS_IN2;
--  COINC <= COINC_MASTER when MASTER = '1' else LVDS_IN3;

  process(CLK200MHz)
  begin
    if (CLK200MHz'event and CLK200MHz = '1') then
      if MASTER = '1' then
        COINC <= COINC_MASTER;
      else
        COINC <= LVDS_IN3;
      end if;
    end if;
  end process;  
  
  LVDS_OUT1 <= GPS_DATA_MASTER when MASTER = '1' else ML1;
  LVDS_OUT2 <= ONE_PPS_MASTER when MASTER = '1' else MH1;
  LVDS_OUT3 <= COINC_MASTER when MASTER = '1' else ML2;
  LVDS_OUT4 <= '0' when MASTER = '1' else MH2;

end rtl ; -- of LVDS_MUX

