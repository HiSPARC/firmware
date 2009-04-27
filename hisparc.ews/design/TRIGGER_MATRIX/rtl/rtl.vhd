-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'TRIGGER_MATRIX.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'TRIGGER_MATRIX' :
-- 
--   port(
--     BLOCK_COINC       : in     std_logic;
--     CLK10MHz          : in     std_logic;
--     CLK200MHz         : in     std_logic;
--     COINC_TO_END_TIME : out    std_logic;
--     COMPH1            : in     std_logic;
--     COMPH2            : in     std_logic;
--     COMPL1            : in     std_logic;
--     COMPL2            : in     std_logic;
--     EXT_TR            : in     std_logic;
--     MASTER            : in     std_logic;
--     MH1               : in     std_logic;
--     MH2               : in     std_logic;
--     ML1               : in     std_logic;
--     ML2               : in     std_logic;
--     ONE_PPS           : in     std_logic;
--     POST_TIME         : in     integer range 1600 downto 0;
--     SH1_IN            : in     std_logic;
--     SH2_IN            : in     std_logic;
--     SL1_IN            : in     std_logic;
--     SL2_IN            : in     std_logic;
--     SLAVE_PRESENT     : in     std_logic;
--     STARTUP_BLOCK_OUT : out    std_logic;
--     SYSRST            : in     std_logic;
--     TRIGGER_PATTERN   : out    std_logic_vector(15 downto 0);
--     TR_CONDITION      : in     std_logic_vector(7 downto 0));
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of TRIGGER_MATRIX is

signal SL1: std_logic ;
signal SL2: std_logic ;
signal SH1: std_logic ;
signal SH2: std_logic ;
signal ML1_DEL1: std_logic ;
signal ML2_DEL1: std_logic ;
signal MH1_DEL1: std_logic ;
signal MH2_DEL1: std_logic ;
signal ML1_DEL2: std_logic ;
signal ML2_DEL2: std_logic ;
signal MH1_DEL2: std_logic ;
signal MH2_DEL2: std_logic ;
signal ML1_DEL3: std_logic ;
signal ML2_DEL3: std_logic ;
signal MH1_DEL3: std_logic ;
signal MH2_DEL3: std_logic ;
signal ML1_DEL4: std_logic ;
signal ML2_DEL4: std_logic ;
signal MH1_DEL4: std_logic ;
signal MH2_DEL4: std_logic ;
signal SL1_DEL1: std_logic ;
signal SL2_DEL1: std_logic ;
signal SH1_DEL1: std_logic ;
signal SH2_DEL1: std_logic ;
signal SL1_DEL2: std_logic ;
signal SL2_DEL2: std_logic ;
signal SH1_DEL2: std_logic ;
signal SH2_DEL2: std_logic ;
signal SL1_DEL3: std_logic ;
signal SL2_DEL3: std_logic ;
signal SH1_DEL3: std_logic ;
signal SH2_DEL3: std_logic ;
signal SL1_DEL4: std_logic ;
signal SL2_DEL4: std_logic ;
signal SH1_DEL4: std_logic ;
signal SH2_DEL4: std_logic ;
signal ML1_LATCHED: std_logic ;
signal ML2_LATCHED: std_logic ;
signal MH1_LATCHED: std_logic ;
signal MH2_LATCHED: std_logic ;
signal SL1_LATCHED: std_logic ;
signal SL2_LATCHED: std_logic ;
signal SH1_LATCHED: std_logic ;
signal SH2_LATCHED: std_logic ;
signal ML1_NEW: std_logic ;
signal ML2_NEW: std_logic ;
signal MH1_NEW: std_logic ;
signal MH2_NEW: std_logic ;
signal SL1_NEW: std_logic ;
signal SL2_NEW: std_logic ;
signal SH1_NEW: std_logic ;
signal SH2_NEW: std_logic ;
signal TR_CONDITION1: std_logic ;
signal TR_CONDITION2: std_logic ;
signal TR_CONDITION3: std_logic ;
signal TR_CONDITION4: std_logic ;
signal TR_CONDITION5: std_logic ;
signal TR_CONDITION6: std_logic ;
signal TR_CONDITION7: std_logic ;
signal TR_CONDITION8: std_logic ;
signal TR_CONDITION9: std_logic ;
signal TR_CONDITION10: std_logic ;
signal TR_CONDITION11: std_logic ;
signal TR_CONDITION12: std_logic ;
signal TR_CONDITION13: std_logic ;
signal TR_CONDITION14: std_logic ;
signal TR_CONDITION15: std_logic ;
signal TR_CONDITION16: std_logic ;
signal TR_CONDITION17: std_logic ;
signal TR_CONDITION18: std_logic ;
signal TR_CONDITION19: std_logic ;
signal TR_CONDITION20: std_logic ;
signal TR_CONDITION21: std_logic ;
signal TR_CONDITION22: std_logic ;
signal TR_CONDITION23: std_logic ;
signal TR_CONDITION24: std_logic ;
signal TR_CONDITION25: std_logic ;
signal TR_CONDITION26: std_logic ;
signal TR_CONDITION27: std_logic ;
signal TR_CONDITION28: std_logic ;
signal TR_CONDITION29: std_logic ;
signal TR_CONDITION30: std_logic ;
signal TR_CONDITION1_NEW: std_logic ;
signal TR_CONDITION2_NEW: std_logic ;
signal TR_CONDITION3_NEW: std_logic ;
signal TR_CONDITION4_NEW: std_logic ;
signal TR_CONDITION5_NEW: std_logic ;
signal TR_CONDITION6_NEW: std_logic ;
signal TR_CONDITION7_NEW: std_logic ;
signal TR_CONDITION8_NEW: std_logic ;
signal TR_CONDITION9_NEW: std_logic ;
signal TR_CONDITION10_NEW: std_logic ;
signal TR_CONDITION11_NEW: std_logic ;
signal TR_CONDITION12_NEW: std_logic ;
signal TR_CONDITION13_NEW: std_logic ;
signal TR_CONDITION14_NEW: std_logic ;
signal TR_CONDITION15_NEW: std_logic ;
signal TR_CONDITION16_NEW: std_logic ;
signal TR_CONDITION17_NEW: std_logic ;
signal TR_CONDITION18_NEW: std_logic ;
signal TR_CONDITION19_NEW: std_logic ;
signal TR_CONDITION20_NEW: std_logic ;
signal TR_CONDITION21_NEW: std_logic ;
signal TR_CONDITION22_NEW: std_logic ;
signal TR_CONDITION23_NEW: std_logic ;
signal TR_CONDITION24_NEW: std_logic ;
signal TR_CONDITION25_NEW: std_logic ;
signal TR_CONDITION26_NEW: std_logic ;
signal TR_CONDITION27_NEW: std_logic ;
signal TR_CONDITION28_NEW: std_logic ;
signal TR_CONDITION29_NEW: std_logic ;
signal TR_CONDITION30_NEW: std_logic ;
signal TR_CONDITION1_DEL: std_logic ;
signal TR_CONDITION2_DEL: std_logic ;
signal TR_CONDITION3_DEL: std_logic ;
signal TR_CONDITION4_DEL: std_logic ;
signal TR_CONDITION5_DEL: std_logic ;
signal TR_CONDITION9_DEL: std_logic ;
signal TR_CONDITION12_DEL: std_logic ;
signal TR_CONDITION14_DEL: std_logic ;
signal TR_CONDITION1_NEW_DEL: std_logic ;
signal TR_CONDITION2_NEW_DEL: std_logic ;
signal TR_CONDITION3_NEW_DEL: std_logic ;
signal TR_CONDITION4_NEW_DEL: std_logic ;
signal TR_CONDITION5_NEW_DEL: std_logic ;
signal TR_CONDITION9_NEW_DEL: std_logic ;
signal TR_CONDITION12_NEW_DEL: std_logic ;
signal TR_CONDITION14_NEW_DEL: std_logic ;
signal SCINT_LATCH: std_logic ; -- Latched de triggervoorwaarden zoals MH1, SH1 enz, Aktief als aan de triggervoorwaarden voldaan is.
signal SCINT_LATCH_DEL: std_logic ; -- Nodig voor opgaande flank detectie
signal SCINT_PATTERN: std_logic_vector(5 downto 0); -- The 6 LSB bits of TR_CONDITION selects a SCINT_PATTERN; TR_CONDITION(6) selects the ext. trigger
signal TRIGGER_PATTERN_TMP: std_logic_vector(15 downto 0); -- Tijdelijke latching van het triggerpatroon voor de master en slave signalen. De comparatorsignalen worden later ingeklokt.
-- signal CAL_EXTTRIG_PATTERN: std_logic_vector(1 downto 0); -- TR_CONDITION(7) selects a calibration; TR_CONDITION(6) selects the ext. trigger
signal SCINT_COINC: std_logic ; -- Selected scintillator trigger
signal SCINT_COINC_DEL: std_logic ; 
signal COINC_TMP: std_logic ;
signal COINC_DEL: std_logic ;
signal COINC_TO_END_TIME_TMP: std_logic ; -- Time from negative edge of COINC to end of POST_TIME  
signal COINC_TO_END_TIME_DEL_TMP: std_logic ;   
signal BEGIN_COINC_TO_END_TIME_TMP: std_logic ; -- Time from positive edge of COINC to end of POST_TIME  
signal COINC_TO_END_TIME_CNT: integer range 1600 downto 0 ; -- Counter from end COINC to end of POST_TIME
-- There must be a gap between the end of a posttime and the beginning of a new coinctime.
-- This is related to the readoutclock RDCLK. It will cost the COINC_TO_END_TIME switch in instance FIFO_SELECT two clockperiods
-- to react. Periodtime is 200ns, thus the gap must be 400ns. That are 80 steps of 5ns. This will increase the deadtime.
signal POST_PLUS_GAP_TIME_CNT: integer range 1680 downto 0 ; -- Counter from end COINC to end of POST_TIME plus gap
signal GAP_TIME: integer range 1700 downto 0 ; -- POST_TIME plus gap
signal COINC_TO_GAP_TIME: std_logic ; -- Time from negative edge of COINC to end of GAP_TIME  
signal BLOCK_START_OF_COINC: std_logic ; -- This signal is the OR of all signals which prevent starting COINC.
signal BLOCK_COINC_SYNCHR: std_logic ;
signal EXT_TR_DEL: std_logic ;
signal CAL_COUNT: std_logic_vector(22 downto 0); -- Calibration counter Full scale is about 2^23 times 100ns is 0.84 seconds
signal CAL_TR: std_logic ;
signal CAL_TR_DEL1: std_logic ;
signal CAL_TR_DEL2: std_logic ;

-- Next signals are necessary to disable coint at startup, otherwise there will be a false hit
signal ONE_PPS_DEL1: std_logic ;
signal ONE_PPS_DEL2: std_logic ;
signal ONE_PPS_DEL3: std_logic ;
signal STARTUP_COUNT: std_logic_vector(3 downto 0); -- Counts 8 seconds from startup to disable coinc
signal STARTUP_BLOCK: std_logic ;


begin

  SCINT_PATTERN <= TR_CONDITION(5 downto 0);
--  CAL_EXTTRIG_PATTERN <= TR_CONDITION(7 downto 6);
  COINC_TO_END_TIME <= BEGIN_COINC_TO_END_TIME_TMP;
  STARTUP_BLOCK_OUT <= STARTUP_BLOCK;
  GAP_TIME <= POST_TIME + 100; -- 0.5 us gap
  
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      SL1 <= '0';
      SL2 <= '0';
      SH1 <= '0';
      SH2 <= '0';  
      SCINT_LATCH_DEL <= '0';  
      EXT_TR_DEL <= '0';  
      SCINT_COINC_DEL <= '0';        
      COINC_DEL <= '0';        
      COINC_TO_END_TIME_DEL_TMP <= '0';        
      BLOCK_COINC_SYNCHR <= '0';        
      CAL_TR <= '0';  
      CAL_TR_DEL1 <= '0';  
      CAL_TR_DEL2 <= '0';  
      TR_CONDITION1_DEL <= '0';        
      TR_CONDITION2_DEL <= '0';        
      TR_CONDITION3_DEL <= '0';        
      TR_CONDITION4_DEL <= '0';        
      TR_CONDITION5_DEL <= '0';        
      TR_CONDITION9_DEL <= '0';        
      TR_CONDITION12_DEL <= '0';        
      TR_CONDITION14_DEL <= '0';        
      TR_CONDITION1_NEW_DEL <= '0';        
      TR_CONDITION2_NEW_DEL <= '0';        
      TR_CONDITION3_NEW_DEL <= '0';        
      TR_CONDITION4_NEW_DEL <= '0';        
      TR_CONDITION5_NEW_DEL <= '0';        
      TR_CONDITION9_NEW_DEL <= '0';        
      TR_CONDITION12_NEW_DEL <= '0';        
      TR_CONDITION14_NEW_DEL <= '0';        
      ML1_DEL1 <= '0';        
      ML2_DEL1 <= '0';        
      MH1_DEL1 <= '0';        
      MH2_DEL1 <= '0';        
      ML1_DEL2 <= '0';        
      ML2_DEL2 <= '0';        
      MH1_DEL2 <= '0';        
      MH2_DEL2 <= '0';        
      ML1_DEL3 <= '0';        
      ML2_DEL3 <= '0';        
      MH1_DEL3 <= '0';        
      MH2_DEL3 <= '0';        
      ML1_DEL4 <= '0';        
      ML2_DEL4 <= '0';        
      MH1_DEL4 <= '0';        
      MH2_DEL4 <= '0';        
      SL1_DEL1 <= '0';        
      SL2_DEL1 <= '0';        
      SH1_DEL1 <= '0';        
      SH2_DEL1 <= '0';        
      SL1_DEL2 <= '0';        
      SL2_DEL2 <= '0';        
      SH1_DEL2 <= '0';        
      SH2_DEL2 <= '0';        
      SL1_DEL3 <= '0';        
      SL2_DEL3 <= '0';        
      SH1_DEL3 <= '0';        
      SH2_DEL3 <= '0';        
      SL1_DEL4 <= '0';        
      SL2_DEL4 <= '0';        
      SH1_DEL4 <= '0';        
      SH2_DEL4 <= '0';        
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      SCINT_LATCH_DEL <= SCINT_LATCH;        
      COINC_TO_END_TIME_DEL_TMP <= COINC_TO_END_TIME_TMP;        
      SCINT_COINC_DEL <= SCINT_COINC;        
      COINC_DEL <= COINC_TMP;        
      BLOCK_COINC_SYNCHR <= BLOCK_COINC;        
      EXT_TR_DEL <= EXT_TR;        
      CAL_TR <= CAL_COUNT(22);        
      CAL_TR_DEL1 <= CAL_TR;        
      CAL_TR_DEL2 <= CAL_TR_DEL1;        
      TR_CONDITION1_DEL <= TR_CONDITION1;        
      TR_CONDITION2_DEL <= TR_CONDITION2;        
      TR_CONDITION3_DEL <= TR_CONDITION3;        
      TR_CONDITION4_DEL <= TR_CONDITION4;        
      TR_CONDITION5_DEL <= TR_CONDITION5;        
      TR_CONDITION9_DEL <= TR_CONDITION9;        
      TR_CONDITION12_DEL <= TR_CONDITION12;        
      TR_CONDITION14_DEL <= TR_CONDITION14;        
      TR_CONDITION1_NEW_DEL <= TR_CONDITION1_NEW;        
      TR_CONDITION2_NEW_DEL <= TR_CONDITION2_NEW;        
      TR_CONDITION3_NEW_DEL <= TR_CONDITION3_NEW;        
      TR_CONDITION4_NEW_DEL <= TR_CONDITION4_NEW;        
      TR_CONDITION5_NEW_DEL <= TR_CONDITION5_NEW;        
      TR_CONDITION9_NEW_DEL <= TR_CONDITION9_NEW;        
      TR_CONDITION12_NEW_DEL <= TR_CONDITION12_NEW;        
      TR_CONDITION14_NEW_DEL <= TR_CONDITION14_NEW;        
      ML1_DEL1 <= ML1;        
      ML1_DEL2 <= ML1_DEL1;        
      ML1_DEL3 <= ML1_DEL2;        
      ML1_DEL4 <= ML1_DEL3;        
      ML2_DEL1 <= ML2;        
      ML2_DEL2 <= ML2_DEL1;        
      ML2_DEL3 <= ML2_DEL2;        
      ML2_DEL4 <= ML2_DEL3;        
      MH1_DEL1 <= MH1;        
      MH1_DEL2 <= MH1_DEL1;        
      MH1_DEL3 <= MH1_DEL2;        
      MH1_DEL4 <= MH1_DEL3;        
      MH2_DEL1 <= MH2;        
      MH2_DEL2 <= MH2_DEL1;        
      MH2_DEL3 <= MH2_DEL2;        
      MH2_DEL4 <= MH2_DEL3;        

      SL1_DEL1 <= SL1;        
      SL1_DEL2 <= SL1_DEL1;        
      SL1_DEL3 <= SL1_DEL2;        
      SL1_DEL4 <= SL1_DEL3;        
      SL2_DEL1 <= SL2;        
      SL2_DEL2 <= SL2_DEL1;        
      SL2_DEL3 <= SL2_DEL2;        
      SL2_DEL4 <= SL2_DEL3;        
      SH1_DEL1 <= SH1;        
      SH1_DEL2 <= SH1_DEL1;        
      SH1_DEL3 <= SH1_DEL2;        
      SH1_DEL4 <= SH1_DEL3;        
      SH2_DEL1 <= SH2;        
      SH2_DEL2 <= SH2_DEL1;        
      SH2_DEL3 <= SH2_DEL2;        
      SH2_DEL4 <= SH2_DEL3;        
      if SLAVE_PRESENT = '1' then
        SL1 <= SL1_IN; 
        SL2 <= SL2_IN; 
        SH1 <= SH1_IN; 
        SH2 <= SH2_IN; 
      else
        SL1 <= '0';
        SL2 <= '0';
        SH1 <= '0';
        SH2 <= '0';
      end if;
    end if;
  end process;  

  process(CLK10MHz,SYSRST)
  begin
    if SYSRST = '1' then
      CAL_COUNT <= "00000000000000000000000";
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      CAL_COUNT <= CAL_COUNT + "00000000000000000000001";
    end if;
  end process;  

  process(CLK10MHz,SYSRST)
  begin
    if SYSRST = '1' then
      ONE_PPS_DEL1 <= '0';        
      ONE_PPS_DEL2 <= '0';        
      ONE_PPS_DEL3 <= '0';        
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      ONE_PPS_DEL1 <= ONE_PPS;        
      ONE_PPS_DEL2 <= ONE_PPS_DEL1;        
      ONE_PPS_DEL3 <= ONE_PPS_DEL2;        
    end if;
  end process;  

  process(CLK10MHz,SYSRST)
  begin
    if SYSRST = '1' then
      STARTUP_COUNT <= "0000";
    elsif (CLK10MHz'event and CLK10MHz = '1') then
      if STARTUP_COUNT = "1000" then -- Als er 8 sekonden geteld zijn.
        STARTUP_COUNT <= STARTUP_COUNT; -- Tellerwaarde blijft hangen.
      elsif ONE_PPS_DEL2 = '1' and ONE_PPS_DEL3 = '0' then -- Op de voorflank van het PPS signaal
        STARTUP_COUNT <= STARTUP_COUNT + "0001"; -- Verhoog de teller
      end if;
    end if;
  end process;  

  STARTUP_BLOCK <= not STARTUP_COUNT(3);

-- Trigger condities die na 1 periode bepaald zijn
      
-- TR_CONDITION1
-- 0H and 1L, at least one low signal
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION1 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION1 <= (ML1 or ML2 or SL1 or SL2);
    end if;
  end process;  

-- TR_CONDITION2
-- 0H and 2L, at least two low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION2 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION2 <= (ML1 and ML2) or (ML1 and SL1) or (ML1 and SL2) or 
                       (ML2 and SL1) or (ML2 and SL2) or 
                       (SL1 and SL2);
    end if;
  end process;  

-- TR_CONDITION3
-- 0H and 3L, at least three low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION3 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION3 <= (ML1 and ML2 and SL1) or (ML1 and ML2 and SL2) or (ML1 and SL1 and SL2) or 
                       (ML2 and SL1 and SL2);
    end if;
  end process;  

-- TR_CONDITION4
-- 0H and 4L, all four low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION4 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION4 <= (ML1 and ML2 and SL1 and SL2);
    end if;
  end process;  

-- TR_CONDITION5
-- 1H and 0L,  at least one high signal
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION5 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION5 <= (MH1 or MH2 or SH1 or SH2);
    end if;
  end process;  

-- TR_CONDITION9
-- 2H and 0L, at least two high signals. 
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION9 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION9 <= (MH1 and MH2) or (MH1 and SH1) or (MH1 and SH2) or 
                 (MH2 and SH1) or (MH2 and SH2) or  
                 (SH1 and SH2); 
    end if;
  end process;  

-- TR_CONDITION12
-- 3H and 0L,  at least three high signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION12 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION12 <= (MH1 and MH2 and SH1) or (MH1 and MH2 and SH2) or (MH1 and SH1 and SH2) or 
                        (MH2 and SH1 and SH2);
    end if;
  end process;  

-- TR_CONDITION14
-- 4H and 0L, all four high signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION14 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION14 <= (MH1 and MH2 and SH1 and SH2);
    end if;
  end process;  

-- Trigger condities die na 2 periodes bepaald zijn

-- TR_CONDITION6
-- 1H and 1L,  at least one high signal and at least one other low signal
-- Assuming that when the high signal is present, the low signal of that channel is also present.
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION6 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION6 <= TR_CONDITION5 and TR_CONDITION2;
    end if;
  end process;  

-- TR_CONDITION7
-- 1H and 2L,  at least one high signal and at least two other low signals
-- Assuming that when the high signal is present, the low signal of that channel is also present.
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION7 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION7 <= TR_CONDITION5 and TR_CONDITION3;
    end if;
  end process;  

-- TR_CONDITION8
-- 1H and 3L,  at least one high signal and at least three other low signals
-- Assuming that when the high signal is present, the low signal of that channel is also present.
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION8 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION8 <= TR_CONDITION5 and TR_CONDITION4;
    end if;
  end process;  

-- TR_CONDITION10
-- 2H and 1L,  at least two high signals and at least one other low signal
-- Assuming that when the high signal is present, the low signal of that channel is also present.
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION10 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION10 <= TR_CONDITION9 and TR_CONDITION3;
    end if;
  end process;  

-- TR_CONDITION11
-- 2H and 2L,  at least two high signals and at least two other low signals
-- Assuming that when the high signal is present, the low signal of that channel is also present.
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION11 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION11 <= TR_CONDITION9 and TR_CONDITION4;
    end if;
  end process;  

-- TR_CONDITION13
-- 3H and 1L,  at least three high signals and at least one other low signal
-- Assuming that when the high signal is present, the low signal of that channel is also present.
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION13 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION13 <= TR_CONDITION12 and TR_CONDITION4;
    end if;
  end process;  

-- TR_CONDITION15
-- 1H or 1L,  at least one high signal or at least one low signal
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION15 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION15 <= TR_CONDITION5 or TR_CONDITION1;
    end if;
  end process;  

-- TR_CONDITION16
-- 1H or 2L,  at least one high signal or at least two low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION16 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION16 <= TR_CONDITION5 or TR_CONDITION2;
    end if;
  end process;  

-- TR_CONDITION17
-- 1H or 3L,  at least one high signal or at least three low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION17 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION17 <= TR_CONDITION5 or TR_CONDITION3;
    end if;
  end process;  

-- TR_CONDITION18
-- 1H or 4L,  at least one high signal or all four signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION18 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION18 <= TR_CONDITION5 or TR_CONDITION4;
    end if;
  end process;  

-- TR_CONDITION19
-- 2H or 1L,  at least two high signals or at least one low signal
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION19 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION19 <= TR_CONDITION9 or TR_CONDITION1;
    end if;
  end process;  

-- TR_CONDITION20
-- 2H or 2L,  at least two high signals or at least two low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION20 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION20 <= TR_CONDITION9 or TR_CONDITION2;
    end if;
  end process;  

-- TR_CONDITION21
-- 2H or 3L,  at least two high signals or at least three low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION21 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION21 <= TR_CONDITION9 or TR_CONDITION3;
    end if;
  end process;  

-- TR_CONDITION22
-- 2H or 4L,  at least two high signals or all four signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION22 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION22 <= TR_CONDITION9 or TR_CONDITION4;
    end if;
  end process;  

-- TR_CONDITION23
-- 3H or 1L,  at least three high signals or at least one low signal
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION23 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION23 <= TR_CONDITION12 or TR_CONDITION1;
    end if;
  end process;  

-- TR_CONDITION24
-- 3H or 2L,  at least three high signals or at least two low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION24 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION24 <= TR_CONDITION12 or TR_CONDITION2;
    end if;
  end process;  

-- TR_CONDITION25
-- 3H or 3L,  at least three high signals or at least three low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION25 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION25 <= TR_CONDITION12 or TR_CONDITION3;
    end if;
  end process;  

-- TR_CONDITION26
-- 3H or 4L,  at least three high signals or all four signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION26 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION26 <= TR_CONDITION12 or TR_CONDITION4;
    end if;
  end process;  

-- TR_CONDITION27
-- 4H or 1L,  all four high signals or at least one low signal
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION27 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION27 <= TR_CONDITION14 or TR_CONDITION1;
    end if;
  end process;  

-- TR_CONDITION28
-- 4H or 2L,  all four high signals or at least two low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION28 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION28 <= TR_CONDITION14 or TR_CONDITION2;
    end if;
  end process;  

-- TR_CONDITION29
-- 4H or 3L,  all four high signals or at least three low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION29 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION29 <= TR_CONDITION14 or TR_CONDITION3;
    end if;
  end process;  

-- TR_CONDITION30
-- 4H or 4L,  all four high signals or all four low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION30 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION30 <= TR_CONDITION14 or TR_CONDITION4;
    end if;
  end process;  

-- Als aan het triggerpatroon voldaan wordt, moeten de signalen uit de scintillator gelatched worden

  process (CLK200MHz,SYSRST,SCINT_PATTERN)
  begin
    if SYSRST = '1' then
      SCINT_LATCH <= '0';
    elsif (CLK200MHz'event and CLK200MHz='1') then
      case SCINT_PATTERN is
        when "000001" => SCINT_LATCH <= TR_CONDITION1_DEL;
        when "000010" => SCINT_LATCH <= TR_CONDITION2_DEL;
        when "000011" => SCINT_LATCH <= TR_CONDITION3_DEL;
        when "000100" => SCINT_LATCH <= TR_CONDITION4_DEL;
        when "001000" => SCINT_LATCH <= TR_CONDITION5_DEL;
        when "001001" => SCINT_LATCH <= TR_CONDITION6;
        when "001010" => SCINT_LATCH <= TR_CONDITION7;
        when "001011" => SCINT_LATCH <= TR_CONDITION8;
        when "010000" => SCINT_LATCH <= TR_CONDITION9_DEL;
        when "010001" => SCINT_LATCH <= TR_CONDITION10;
        when "010010" => SCINT_LATCH <= TR_CONDITION11;
        when "011000" => SCINT_LATCH <= TR_CONDITION12_DEL;
        when "011001" => SCINT_LATCH <= TR_CONDITION13;
        when "100000" => SCINT_LATCH <= TR_CONDITION14_DEL;
        when "001100" => SCINT_LATCH <= TR_CONDITION15;
        when "001101" => SCINT_LATCH <= TR_CONDITION16;
        when "001110" => SCINT_LATCH <= TR_CONDITION17;
        when "001111" => SCINT_LATCH <= TR_CONDITION18;
        when "010100" => SCINT_LATCH <= TR_CONDITION19;
        when "010101" => SCINT_LATCH <= TR_CONDITION20;
        when "010110" => SCINT_LATCH <= TR_CONDITION21;
        when "010111" => SCINT_LATCH <= TR_CONDITION22;
        when "011100" => SCINT_LATCH <= TR_CONDITION23;
        when "011101" => SCINT_LATCH <= TR_CONDITION24;
        when "011110" => SCINT_LATCH <= TR_CONDITION25;
        when "011111" => SCINT_LATCH <= TR_CONDITION26;
        when "100100" => SCINT_LATCH <= TR_CONDITION27;
        when "100101" => SCINT_LATCH <= TR_CONDITION28;
        when "100110" => SCINT_LATCH <= TR_CONDITION29;
        when "100111" => SCINT_LATCH <= TR_CONDITION30;
        when others => SCINT_LATCH <= '0';
      end case;  
    end if;
  end process;


-- Het vasthouden of blokkeren van de ingangssignalen wordt aangezet door de opgaande flank van SCINT_LATCH
-- en wordt geblockt door BLOCK_START_OF_COINC
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      ML1_LATCHED <= '0';
      ML2_LATCHED <= '0';
      MH1_LATCHED <= '0';
      MH2_LATCHED <= '0';
      SL1_LATCHED <= '0';
      SL2_LATCHED <= '0';
      SH1_LATCHED <= '0';
      SH2_LATCHED <= '0';
      TRIGGER_PATTERN_TMP <= "0000000000000000";
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if BLOCK_START_OF_COINC = '0' and SCINT_LATCH = '1' and SCINT_LATCH_DEL = '0' then
        ML1_LATCHED <= ML1_DEL3;
        ML2_LATCHED <= ML2_DEL3;
        MH1_LATCHED <= MH1_DEL3;
        MH2_LATCHED <= MH2_DEL3;
        SL1_LATCHED <= SL1_DEL3;
        SL2_LATCHED <= SL2_DEL3;
        SH1_LATCHED <= SH1_DEL3;
        SH2_LATCHED <= SH2_DEL3;
        TRIGGER_PATTERN_TMP(0) <= ML1_DEL3;
        TRIGGER_PATTERN_TMP(1) <= MH1_DEL3;
        TRIGGER_PATTERN_TMP(2) <= ML2_DEL3;
        TRIGGER_PATTERN_TMP(3) <= MH2_DEL3;
        TRIGGER_PATTERN_TMP(4) <= SL1_DEL3;
        TRIGGER_PATTERN_TMP(5) <= SH1_DEL3;
        TRIGGER_PATTERN_TMP(6) <= SL2_DEL3;
        TRIGGER_PATTERN_TMP(7) <= SH2_DEL3;
        TRIGGER_PATTERN_TMP(8) <= EXT_TR;
        TRIGGER_PATTERN_TMP(9) <= MASTER;
        TRIGGER_PATTERN_TMP(10) <= SLAVE_PRESENT;
        TRIGGER_PATTERN_TMP(15) <= '0';
      end if;
    end if;
  end process;  

-- Hier worden de nieuwe ingangssignalen gemaakt. Degene die de coincidentie starten.
-- Mocht later de triggervoorwaarde verlengt worden door nog een geldige combinatie
-- dan wordt dit tegengehouden.
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      ML1_NEW <= '0';
      ML2_NEW <= '0';
      MH1_NEW <= '0';
      MH2_NEW <= '0';
      SL1_NEW <= '0';
      SL2_NEW <= '0';
      SH1_NEW <= '0';
      SH2_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      ML1_NEW <= ML1_LATCHED and ML1_DEL4;
      ML2_NEW <= ML2_LATCHED and ML2_DEL4;
      MH1_NEW <= MH1_LATCHED and MH1_DEL4;
      MH2_NEW <= MH2_LATCHED and MH2_DEL4;
      SL1_NEW <= SL1_LATCHED and SL1_DEL4;
      SL2_NEW <= SL2_LATCHED and SL2_DEL4;
      SH1_NEW <= SH1_LATCHED and SH1_DEL4;
      SH2_NEW <= SH2_LATCHED and SH2_DEL4;
    end if;
  end process;  

-- Van de nieuwe signalen moet weer opnieuw de triggerconditie bepaald worden.
-- Deze signalen kunnen alleen in het begin van een triggervoorwaarde opkomen en worden dus niet verlengd
-- door een andere geldige combinatie

-- Trigger condities die na 1 periode bepaald zijn
      
-- TR_CONDITION1_NEW
-- 0H and 1L, at least one low signal
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION1_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION1_NEW <= (ML1_NEW or ML2_NEW or SL1_NEW or SL2_NEW);
    end if;
  end process;  

-- TR_CONDITION2_NEW
-- 0H and 2L, at least two low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION2_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION2_NEW <= (ML1_NEW and ML2_NEW) or (ML1_NEW and SL1_NEW) or (ML1_NEW and SL2_NEW) or 
                       (ML2_NEW and SL1_NEW) or (ML2_NEW and SL2_NEW) or 
                       (SL1_NEW and SL2_NEW);
    end if;
  end process;  

-- TR_CONDITION3_NEW
-- 0H and 3L, at least three low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION3_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION3_NEW <= (ML1_NEW and ML2_NEW and SL1_NEW) or (ML1_NEW and ML2_NEW and SL2_NEW) or (ML1_NEW and SL1_NEW and SL2_NEW) or 
                       (ML2_NEW and SL1_NEW and SL2_NEW);
    end if;
  end process;  

-- TR_CONDITION4_NEW
-- 0H and 4L, all four low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION4_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION4_NEW <= (ML1_NEW and ML2_NEW and SL1_NEW and SL2_NEW);
    end if;
  end process;  

-- TR_CONDITION5_NEW
-- 1H and 0L,  at least one high signal
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION5_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION5_NEW <= (MH1_NEW or MH2_NEW or SH1_NEW or SH2_NEW);
    end if;
  end process;  

-- TR_CONDITION9_NEW
-- 2H and 0L, at least two high signals. 
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION9_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION9_NEW <= (MH1_NEW and MH2_NEW) or (MH1_NEW and SH1_NEW) or (MH1_NEW and SH2_NEW) or 
                 (MH2_NEW and SH1_NEW) or (MH2_NEW and SH2_NEW) or  
                 (SH1_NEW and SH2_NEW); 
    end if;
  end process;  

-- TR_CONDITION12_NEW
-- 3H and 0L,  at least three high signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION12_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION12_NEW <= (MH1_NEW and MH2_NEW and SH1_NEW) or (MH1_NEW and MH2_NEW and SH2_NEW) or (MH1_NEW and SH1_NEW and SH2_NEW) or 
                        (MH2_NEW and SH1_NEW and SH2_NEW);
    end if;
  end process;  

-- TR_CONDITION14_NEW
-- 4H and 0L, all four high signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION14_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION14_NEW <= (MH1_NEW and MH2_NEW and SH1_NEW and SH2_NEW);
    end if;
  end process;  

-- Trigger condities die na 2 periodes bepaald zijn

-- TR_CONDITION6_NEW
-- 1H and 1L,  at least one high signal and at least one other low signal
-- Assuming that when the high signal is present, the low signal of that channel is also present.
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION6_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION6_NEW <= TR_CONDITION5_NEW and TR_CONDITION2_NEW;
    end if;
  end process;  

-- TR_CONDITION7_NEW
-- 1H and 2L,  at least one high signal and at least two other low signals
-- Assuming that when the high signal is present, the low signal of that channel is also present.
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION7_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION7_NEW <= TR_CONDITION5_NEW and TR_CONDITION3_NEW;
    end if;
  end process;  

-- TR_CONDITION8_NEW
-- 1H and 3L,  at least one high signal and at least three other low signals
-- Assuming that when the high signal is present, the low signal of that channel is also present.
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION8_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION8_NEW <= TR_CONDITION5_NEW and TR_CONDITION4_NEW;
    end if;
  end process;  

-- TR_CONDITION10_NEW
-- 2H and 1L,  at least two high signals and at least one other low signal
-- Assuming that when the high signal is present, the low signal of that channel is also present.
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION10_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION10_NEW <= TR_CONDITION9_NEW and TR_CONDITION3_NEW;
    end if;
  end process;  

-- TR_CONDITION11_NEW
-- 2H and 2L,  at least two high signals and at least two other low signals
-- Assuming that when the high signal is present, the low signal of that channel is also present.
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION11_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION11_NEW <= TR_CONDITION9_NEW and TR_CONDITION4_NEW;
    end if;
  end process;  

-- TR_CONDITION13_NEW
-- 3H and 1L,  at least three high signals and at least one other low signal
-- Assuming that when the high signal is present, the low signal of that channel is also present.
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION13_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION13_NEW <= TR_CONDITION12_NEW and TR_CONDITION4_NEW;
    end if;
  end process;  

-- TR_CONDITION15_NEW
-- 1H or 1L,  at least one high signal or at least one low signal
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION15_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION15_NEW <= TR_CONDITION5_NEW or TR_CONDITION1_NEW;
    end if;
  end process;  

-- TR_CONDITION16_NEW
-- 1H or 2L,  at least one high signal or at least two low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION16_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION16_NEW <= TR_CONDITION5_NEW or TR_CONDITION2_NEW;
    end if;
  end process;  

-- TR_CONDITION17_NEW
-- 1H or 3L,  at least one high signal or at least three low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION17_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION17_NEW <= TR_CONDITION5_NEW or TR_CONDITION3_NEW;
    end if;
  end process;  

-- TR_CONDITION18_NEW
-- 1H or 4L,  at least one high signal or all four signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION18_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION18_NEW <= TR_CONDITION5_NEW or TR_CONDITION4_NEW;
    end if;
  end process;  

-- TR_CONDITION19_NEW
-- 2H or 1L,  at least two high signals or at least one low signal
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION19_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION19_NEW <= TR_CONDITION9_NEW or TR_CONDITION1_NEW;
    end if;
  end process;  

-- TR_CONDITION20_NEW
-- 2H or 2L,  at least two high signals or at least two low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION20_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION20_NEW <= TR_CONDITION9_NEW or TR_CONDITION2_NEW;
    end if;
  end process;  

-- TR_CONDITION21_NEW
-- 2H or 3L,  at least two high signals or at least three low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION21_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION21_NEW <= TR_CONDITION9_NEW or TR_CONDITION3_NEW;
    end if;
  end process;  

-- TR_CONDITION22_NEW
-- 2H or 4L,  at least two high signals or all four signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION22_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION22_NEW <= TR_CONDITION9_NEW or TR_CONDITION4_NEW;
    end if;
  end process;  

-- TR_CONDITION23_NEW
-- 3H or 1L,  at least three high signals or at least one low signal
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION23_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION23_NEW <= TR_CONDITION12_NEW or TR_CONDITION1_NEW;
    end if;
  end process;  

-- TR_CONDITION24_NEW
-- 3H or 2L,  at least three high signals or at least two low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION24_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION24_NEW <= TR_CONDITION12_NEW or TR_CONDITION2_NEW;
    end if;
  end process;  

-- TR_CONDITION25_NEW
-- 3H or 3L,  at least three high signals or at least three low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION25_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION25_NEW <= TR_CONDITION12_NEW or TR_CONDITION3_NEW;
    end if;
  end process;  

-- TR_CONDITION26_NEW
-- 3H or 4L,  at least three high signals or all four signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION26_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION26_NEW <= TR_CONDITION12_NEW or TR_CONDITION4_NEW;
    end if;
  end process;  

-- TR_CONDITION27_NEW
-- 4H or 1L,  all four high signals or at least one low signal
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION27_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION27_NEW <= TR_CONDITION14_NEW or TR_CONDITION1_NEW;
    end if;
  end process;  

-- TR_CONDITION28_NEW
-- 4H or 2L,  all four high signals or at least two low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION28_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION28_NEW <= TR_CONDITION14_NEW or TR_CONDITION2_NEW;
    end if;
  end process;  

-- TR_CONDITION29_NEW
-- 4H or 3L,  all four high signals or at least three low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION29_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION29_NEW <= TR_CONDITION14_NEW or TR_CONDITION3_NEW;
    end if;
  end process;  

-- TR_CONDITION30_NEW
-- 4H or 4L,  all four high signals or all four low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION30_NEW <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION30_NEW <= TR_CONDITION14_NEW or TR_CONDITION4_NEW;
    end if;
  end process;  

-- Van de NEW gemaakte signalen moet weer bekeken worden of ze een coincidentie maken, indien ze geselecteerd zijn.
  process (CLK200MHz,SYSRST,SCINT_PATTERN)
  begin
    if SYSRST = '1' then
      SCINT_COINC <= '0';
    elsif (CLK200MHz'event and CLK200MHz='1') then
      case SCINT_PATTERN is
        when "000001" => SCINT_COINC <= TR_CONDITION1_NEW_DEL;
        when "000010" => SCINT_COINC <= TR_CONDITION2_NEW_DEL;
        when "000011" => SCINT_COINC <= TR_CONDITION3_NEW_DEL;
        when "000100" => SCINT_COINC <= TR_CONDITION4_NEW_DEL;
        when "001000" => SCINT_COINC <= TR_CONDITION5_NEW_DEL;
        when "001001" => SCINT_COINC <= TR_CONDITION6_NEW;
        when "001010" => SCINT_COINC <= TR_CONDITION7_NEW;
        when "001011" => SCINT_COINC <= TR_CONDITION8_NEW;
        when "010000" => SCINT_COINC <= TR_CONDITION9_NEW_DEL;
        when "010001" => SCINT_COINC <= TR_CONDITION10_NEW;
        when "010010" => SCINT_COINC <= TR_CONDITION11_NEW;
        when "011000" => SCINT_COINC <= TR_CONDITION12_NEW_DEL;
        when "011001" => SCINT_COINC <= TR_CONDITION13_NEW;
        when "100000" => SCINT_COINC <= TR_CONDITION14_NEW_DEL;
        when "001100" => SCINT_COINC <= TR_CONDITION15_NEW;
        when "001101" => SCINT_COINC <= TR_CONDITION16_NEW;
        when "001110" => SCINT_COINC <= TR_CONDITION17_NEW;
        when "001111" => SCINT_COINC <= TR_CONDITION18_NEW;
        when "010100" => SCINT_COINC <= TR_CONDITION19_NEW;
        when "010101" => SCINT_COINC <= TR_CONDITION20_NEW;
        when "010110" => SCINT_COINC <= TR_CONDITION21_NEW;
        when "010111" => SCINT_COINC <= TR_CONDITION22_NEW;
        when "011100" => SCINT_COINC <= TR_CONDITION23_NEW;
        when "011101" => SCINT_COINC <= TR_CONDITION24_NEW;
        when "011110" => SCINT_COINC <= TR_CONDITION25_NEW;
        when "011111" => SCINT_COINC <= TR_CONDITION26_NEW;
        when "100100" => SCINT_COINC <= TR_CONDITION27_NEW;
        when "100101" => SCINT_COINC <= TR_CONDITION28_NEW;
        when "100110" => SCINT_COINC <= TR_CONDITION29_NEW;
        when "100111" => SCINT_COINC <= TR_CONDITION30_NEW;
        when others => SCINT_COINC <= '0';
      end case;  
    end if;
  end process;

  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COINC_TMP <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if TR_CONDITION(7) = '1' then -- Calibration selected
        if CAL_TR_DEL1 = '0' and CAL_TR_DEL2 = '1' then  -- negative edge of calibration trigger
          COINC_TMP <= '0'; -- reset COINC_TMP
        elsif BLOCK_START_OF_COINC = '0' -- No running coinc and no block
          and CAL_TR_DEL1 = '1' and CAL_TR_DEL2 = '0' then  -- and positive edge of calibration trigger
          COINC_TMP <= '1';
        end if;
      elsif TR_CONDITION(6) = '1' then -- External trigger and triggers from scintillators selected; TR_CONDITION15 if SCINT_COINC = '0'; TR_CONDITION16  if SCINT_COINC = TR_CONDITION1 to 14
        if (EXT_TR = '0' and EXT_TR_DEL = '1') or (SCINT_COINC = '0' and SCINT_COINC_DEL = '1') then  -- negative edge of external trigger or negative edge of scintillator trigger
          COINC_TMP <= '0';
        elsif BLOCK_START_OF_COINC = '0' -- No running coinc and no block
          and ((EXT_TR = '1' and EXT_TR_DEL = '0') or (SCINT_COINC = '1' and SCINT_COINC_DEL = '0')) then  -- positive edge of external trigger or positive edge of scintillator trigger
          COINC_TMP <= '1';
        end if;
      elsif SCINT_COINC = '0' and SCINT_COINC_DEL = '1' then  -- negative edge of scintillator trigger
        COINC_TMP <= '0';
      elsif BLOCK_START_OF_COINC = '0' -- No running coinc and no block
        and SCINT_COINC = '1' and SCINT_COINC_DEL = '0' then  -- positive edge of scintillator trigger
        COINC_TMP <= '1';
      end if;
    end if;
  end process;





  -- Latch TRIGGER_PATTERN op de achterkant van posttime
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TRIGGER_PATTERN <= "0000000000000000";
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COINC_TO_END_TIME_TMP = '0' and COINC_TO_END_TIME_DEL_TMP = '1' then
        TRIGGER_PATTERN(0) <= TRIGGER_PATTERN_TMP(0);
        TRIGGER_PATTERN(1) <= TRIGGER_PATTERN_TMP(1);
        TRIGGER_PATTERN(2) <= TRIGGER_PATTERN_TMP(2);
        TRIGGER_PATTERN(3) <= TRIGGER_PATTERN_TMP(3);
        TRIGGER_PATTERN(4) <= TRIGGER_PATTERN_TMP(4);
        TRIGGER_PATTERN(5) <= TRIGGER_PATTERN_TMP(5);
        TRIGGER_PATTERN(6) <= TRIGGER_PATTERN_TMP(6);
        TRIGGER_PATTERN(7) <= TRIGGER_PATTERN_TMP(7);
        TRIGGER_PATTERN(8) <= TRIGGER_PATTERN_TMP(8);
        TRIGGER_PATTERN(9) <= TRIGGER_PATTERN_TMP(9);
        TRIGGER_PATTERN(10) <= TRIGGER_PATTERN_TMP(10);
        TRIGGER_PATTERN(11) <= COMPL1;
        TRIGGER_PATTERN(12) <= COMPH1;
        TRIGGER_PATTERN(13) <= COMPL2;
        TRIGGER_PATTERN(14) <= COMPH2;
        TRIGGER_PATTERN(15) <= TRIGGER_PATTERN_TMP(15);
	    end if;        
    end if;
  end process;  
  
  -- COINC_TO_END_TIME_TMP starts at a negative edge of COINC and stops when COINC_TO_END_TIME_CNT reaches POST_TIME
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COINC_TO_END_TIME_TMP <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COINC_TMP = '0' and COINC_DEL = '1' then -- on a negative edge of COINC
        COINC_TO_END_TIME_TMP <= '1'; 
      elsif COINC_TO_END_TIME_CNT > POST_TIME then
        COINC_TO_END_TIME_TMP <= '0';
      end if;
    end if;
  end process;  

  -- COINC_TO_END_TIME_CNT starts when COINC_TO_END_TIME_TMP = '1'
  -- and counts as long COINC_TO_END_TIME_TMP is valid 
  -- and resets when COINC_TO_END_TIME_TMP = '0'
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COINC_TO_END_TIME_CNT <= 0;
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COINC_TO_END_TIME_TMP = '1' then 
        COINC_TO_END_TIME_CNT <= COINC_TO_END_TIME_CNT + 1;
      else
        COINC_TO_END_TIME_CNT <= 0;
      end if;
    end if;
  end process;  

  -- BEGIN_COINC_TO_END_TIME_TMP goes from begin of coinc till end of posttime
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      BEGIN_COINC_TO_END_TIME_TMP <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      BEGIN_COINC_TO_END_TIME_TMP <= COINC_TMP or COINC_DEL or COINC_TO_END_TIME_TMP;
    end if;
  end process;  

  -- COINC_TO_GAP_TIME starts at a negative edge of COINC and stops when POST_PLUS_GAP_TIME_CNT reaches GAP_TIME
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COINC_TO_GAP_TIME <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COINC_TMP = '0' and COINC_DEL = '1' then -- on a negative edge of COINC
        COINC_TO_GAP_TIME <= '1'; 
      elsif POST_PLUS_GAP_TIME_CNT > GAP_TIME then
        COINC_TO_GAP_TIME <= '0';
      end if;
    end if;
  end process;  

  -- POST_PLUS_GAP_TIME_CNT starts when COINC_TO_GAP_TIME = '1'
  -- and counts as long COINC_TO_GAP_TIME is valid 
  -- and resets when COINC_TO_GAP_TIME = '0'
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      POST_PLUS_GAP_TIME_CNT <= 0;
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COINC_TO_GAP_TIME = '1' then 
        POST_PLUS_GAP_TIME_CNT <= POST_PLUS_GAP_TIME_CNT + 1;
      else
        POST_PLUS_GAP_TIME_CNT <= 0;
      end if;
    end if;
  end process;  

  -- BLOCK_START_OF_COINC goes from begin of coinc till end of gaptime
  process(CLK200MHz,SYSRST)
  begin
    if (CLK200MHz'event and CLK200MHz = '1') then
      BLOCK_START_OF_COINC <= BLOCK_COINC_SYNCHR or COINC_TMP or COINC_DEL or COINC_TO_GAP_TIME or STARTUP_BLOCK;
    end if;
  end process;  

end rtl ; -- of TRIGGER_MATRIX

