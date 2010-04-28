-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'a0' of 'LVDS_MUX.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'LVDS_MUX' :
-- 
--   port(
--     CLK10MHz        : in     std_logic;
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
--     SL2             : out    std_logic;
--     SYSRST          : in     std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture a0 of LVDS_MUX is

signal ONE_PPS_TMP: std_logic ;
signal ONE_PPS_DEL1: std_logic ;
signal ONE_PPS_DEL2: std_logic ;
signal STARTUP_COUNT: std_logic_vector(3 downto 0);
signal STARTUP_BLOCK: std_logic ;

begin

  SL1 <= LVDS_IN1 when MASTER = '1' else '1';
  SH1 <= LVDS_IN2 when MASTER = '1' else '1';
  SL2 <= LVDS_IN3 when MASTER = '1' else '1';
  SH2 <= LVDS_IN4 when MASTER = '1' else '1';

  GPS_DATA_OUT <= GPS_DATA_MASTER when MASTER = '1' else LVDS_IN1;
  ONE_PPS_TMP <= ONE_PPS_MASTER when MASTER = '1' else LVDS_IN2;
  ONE_PPS_OUT <= ONE_PPS_TMP;

  process(CLK200MHz, STARTUP_BLOCK)
  begin
    if (STARTUP_BLOCK = '1') then
      COINC <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
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

  process(CLK10MHz,SYSRST)
  begin
    if SYSRST = '1' then
      ONE_PPS_DEL1 <= '0';
      ONE_PPS_DEL2 <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      ONE_PPS_DEL1 <= ONE_PPS_TMP;
      ONE_PPS_DEL2 <= ONE_PPS_DEL1;
    end if;
  end process;

  process(CLK10MHz,SYSRST)
  begin
    if SYSRST = '1' then
      STARTUP_COUNT <= "0000";
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if STARTUP_COUNT = "1000" then -- after 8 seconds
        STARTUP_COUNT <= STARTUP_COUNT; -- latch countvalue 8
      elsif ONE_PPS_DEL1 = '1' and ONE_PPS_DEL2 = '0' then -- at rising edge of PPS
        STARTUP_COUNT <= STARTUP_COUNT + "0001"; -- increase counter
      end if;
    end if;
  end process;

  STARTUP_BLOCK <= not STARTUP_COUNT(3);

end architecture a0 ; -- of LVDS_MUX

