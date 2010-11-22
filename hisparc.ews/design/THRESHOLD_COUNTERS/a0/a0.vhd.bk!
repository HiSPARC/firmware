-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'a0' of 'THRESHOLD_COUNTERS.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'THRESHOLD_COUNTERS' :
-- 
--   port(
--     CLK200MHz       : in     std_logic;
--     MH1             : in     std_logic;
--     MH2             : in     std_logic;
--     ML1             : in     std_logic;
--     ML2             : in     std_logic;
--     ONE_PPS         : in     std_logic;
--     SYSRST          : in     std_logic;
--     TH_COUNTERS_OUT : out    std_logic_vector(63 downto 0));
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture a0 of THRESHOLD_COUNTERS is

signal ML1_DEL: std_logic ;
signal MH1_DEL: std_logic ;
signal ML2_DEL: std_logic ;
signal MH2_DEL: std_logic ;
signal ONE_PPS_DEL1: std_logic ; -- One delay needed to synchronize the asynchronious ONE_PPS with the 200MHz
signal ONE_PPS_DEL2: std_logic ;
signal ONE_PPS_DEL3: std_logic ;
signal ML1_COUNTER: std_logic_vector(15 downto 0) ;
signal MH1_COUNTER: std_logic_vector(15 downto 0) ;
signal ML2_COUNTER: std_logic_vector(15 downto 0) ;
signal MH2_COUNTER: std_logic_vector(15 downto 0) ;

begin

  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      ML1_DEL <= '0';
      MH1_DEL <= '0';
      ML2_DEL <= '0';
      MH2_DEL <= '0';
      ONE_PPS_DEL1 <= '0';
      ONE_PPS_DEL2 <= '0';
      ONE_PPS_DEL3 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      ML1_DEL <= ML1;
      MH1_DEL <= MH1;
      ML2_DEL <= ML2;
      MH2_DEL <= MH2;
      ONE_PPS_DEL1 <= ONE_PPS;
      ONE_PPS_DEL2 <= ONE_PPS_DEL1;
      ONE_PPS_DEL3 <= ONE_PPS_DEL2;
    end if;
  end process;

  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      ML1_COUNTER <= "0000000000000000";
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if ONE_PPS_DEL2 = '1' and ONE_PPS_DEL3 = '0' then
        ML1_COUNTER <= "0000000000000000";
      elsif ML1 = '1' and ML1_DEL = '0' then
        ML1_COUNTER <= ML1_COUNTER + "0000000000000001";
      end if;
    end if;
  end process;

  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      MH1_COUNTER <= "0000000000000000";
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if ONE_PPS_DEL2 = '1' and ONE_PPS_DEL3 = '0' then
        MH1_COUNTER <= "0000000000000000";
      elsif MH1 = '1' and MH1_DEL = '0' then
        MH1_COUNTER <= MH1_COUNTER + "0000000000000001";
      end if;
    end if;
  end process;

  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      ML2_COUNTER <= "0000000000000000";
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if ONE_PPS_DEL2 = '1' and ONE_PPS_DEL3 = '0' then
        ML2_COUNTER <= "0000000000000000";
      elsif ML2 = '1' and ML2_DEL = '0' then
        ML2_COUNTER <= ML2_COUNTER + "0000000000000001";
      end if;
    end if;
  end process;

  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      MH2_COUNTER <= "0000000000000000";
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if ONE_PPS_DEL2 = '1' and ONE_PPS_DEL3 = '0' then
        MH2_COUNTER <= "0000000000000000";
      elsif MH2 = '1' and MH2_DEL = '0' then
        MH2_COUNTER <= MH2_COUNTER + "0000000000000001";
      end if;
    end if;
  end process;

  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TH_COUNTERS_OUT <= (others => '0');
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if ONE_PPS_DEL1 = '1' and ONE_PPS_DEL2 = '0' then
        TH_COUNTERS_OUT(15 downto 0) <= ML1_COUNTER;
        TH_COUNTERS_OUT(31 downto 16) <= MH1_COUNTER;
        TH_COUNTERS_OUT(47 downto 32) <= ML2_COUNTER;
        TH_COUNTERS_OUT(63 downto 48) <= MH2_COUNTER;
      end if;
    end if;
  end process;

end architecture a0 ; -- of THRESHOLD_COUNTERS

