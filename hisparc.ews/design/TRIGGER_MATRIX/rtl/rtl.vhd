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
--     POST_TIME         : in     integer range 1600 downto 0;
--     SH1_IN            : in     std_logic;
--     SH2_IN            : in     std_logic;
--     SL1_IN            : in     std_logic;
--     SL2_IN            : in     std_logic;
--     SLAVE_PRESENT     : in     std_logic;
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
signal SCINT_PATTERN: std_logic_vector(5 downto 0); -- The 6 LSB bits of TR_CONDITION selects a SCINT_PATTERN; TR_CONDITION(6) selects the ext. trigger
signal CAL_EXTTRIG_PATTERN: std_logic_vector(1 downto 0); -- TR_CONDITION(7) selects a calibration; TR_CONDITION(6) selects the ext. trigger
signal SCINT_COINC: std_logic ; -- Selected scintillator trigger
signal COINC_TMP: std_logic ;
signal COINC_DEL: std_logic ;
signal COINC_TO_END_TIME_TMP: std_logic ; -- Time from negative edge of COINC to end of POST_TIME  
signal COINC_TO_END_TIME_CNT: integer range 1600 downto 0 ; -- Counter from COINC to end of POST_TIME
signal BLOCK_COINC_SYNCHR: std_logic ;
signal CAL_COUNT: std_logic_vector(22 downto 0); -- Calibration counter Full scale is about 2^23 times 100ns is 0.84 seconds


begin

  SCINT_PATTERN <= TR_CONDITION(5 downto 0);
  CAL_EXTTRIG_PATTERN <= TR_CONDITION(7 downto 6);
  
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      SL1 <= '0';
      SL2 <= '0';
      SH1 <= '0';
      SH2 <= '0';  
      COINC_DEL <= '0';        
      BLOCK_COINC_SYNCHR <= '0';        
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      COINC_DEL <= COINC_TMP;        
      BLOCK_COINC_SYNCHR <= BLOCK_COINC;        
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
      
-- TR_CONDITION1
-- 0H, 1L, at least one low signal
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION1 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION1 <= (ML1 or ML2 or SL1 or SL2);
    end if;
  end process;  

-- TR_CONDITION2
-- 0H, 2L, at least two low signals
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
-- 0H, 3L, at least three low signals
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
-- 0H, 4L, all four low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION4 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION4 <= (ML1 and ML2 and SL1 and SL2);
    end if;
  end process;  

-- TR_CONDITION5
-- 1H, 0L,  at least one high signal
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION5 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION5 <= (MH1 or MH2 or SH1 or SH2);
    end if;
  end process;  

-- TR_CONDITION6
-- 1H, 1L,  at least one high signal and at least one other low signal
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
-- 1H, 2L,  at least one high signal and at least two other low signals
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
-- 1H, 3L,  at least one high signal and at least three other low signals
-- Assuming that when the high signal is present, the low signal of that channel is also present.
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION8 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION8 <= TR_CONDITION5 and TR_CONDITION4;
    end if;
  end process;  

-- TR_CONDITION9
-- 2H, 0L, at least two high signals. 
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

-- TR_CONDITION10
-- 2H, 1L,  at least two high signals and at least one other low signal
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
-- 2H, 2L,  at least two high signals and at least two other low signals
-- Assuming that when the high signal is present, the low signal of that channel is also present.
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION11 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION11 <= TR_CONDITION9 and TR_CONDITION4;
    end if;
  end process;  

-- TR_CONDITION12
-- 3H, 0L,  at least two high signals and at least three other low signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION12 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION12 <= (MH1 and MH2 and SH1) or (MH1 and MH2 and SH2) or (MH1 and SH1 and SH2) or 
                        (MH2 and SH1 and SH2);
    end if;
  end process;  

-- TR_CONDITION13
-- 3H, 1L,  at least three high signals and at least one other low signal
-- Assuming that when the high signal is present, the low signal of that channel is also present.
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION13 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION13 <= TR_CONDITION12 and TR_CONDITION4;
    end if;
  end process;  

-- TR_CONDITION14
-- 4H, 0L, all four high signals
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TR_CONDITION14 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      TR_CONDITION14 <= (MH1 and MH2 and SH1 and SH2);
    end if;
  end process;  

  process (CLK200MHz,SCINT_PATTERN,TR_CONDITION1,TR_CONDITION2,TR_CONDITION3,TR_CONDITION4,TR_CONDITION5,TR_CONDITION6,TR_CONDITION7,TR_CONDITION8,TR_CONDITION9,TR_CONDITION10,TR_CONDITION11,TR_CONDITION12,TR_CONDITION13,TR_CONDITION14)
  begin
    if (CLK200MHz'event and CLK200MHz='1') then
      case SCINT_PATTERN is
        when "000001" => SCINT_COINC <= TR_CONDITION1;
        when "000010" => SCINT_COINC <= TR_CONDITION2;
        when "000011" => SCINT_COINC <= TR_CONDITION3;
        when "000100" => SCINT_COINC <= TR_CONDITION4;
        when "001000" => SCINT_COINC <= TR_CONDITION5;
        when "001001" => SCINT_COINC <= TR_CONDITION6;
        when "001010" => SCINT_COINC <= TR_CONDITION7;
        when "001011" => SCINT_COINC <= TR_CONDITION8;
        when "010000" => SCINT_COINC <= TR_CONDITION9;
        when "010001" => SCINT_COINC <= TR_CONDITION10;
        when "010010" => SCINT_COINC <= TR_CONDITION11;
        when "011000" => SCINT_COINC <= TR_CONDITION12;
        when "011001" => SCINT_COINC <= TR_CONDITION13;
        when "100000" => SCINT_COINC <= TR_CONDITION14;
        when others => SCINT_COINC <= '0';
      end case;  
    end if;
  end process;

  process(CLK200MHz,SCINT_COINC)
  begin
    if (CLK200MHz'event and CLK200MHz='1') then
      if COINC_TO_END_TIME_TMP = '0' and BLOCK_COINC_SYNCHR = '0' then -- No running coinc and no block
        case CAL_EXTTRIG_PATTERN is
          when "00" => COINC_TMP <= SCINT_COINC; -- No External trigger, only triggers from scintillators
          when "01" => COINC_TMP <= SCINT_COINC or EXT_TR; -- External trigger and triggers from scintillators selected; TR_CONDITION15 if SCINT_COINC = '0'; TR_CONDITION16  if SCINT_COINC = TR_CONDITION1 to 14
          when "10" => COINC_TMP <= CAL_COUNT(22); -- Calibration selected
          when "11" => COINC_TMP <= CAL_COUNT(22); -- Calibration selected
          when others => COINC_TMP <= '0';
        end case;  
      end if;
    end if;
  end process;

  -- Latch TRIGGER_PATTERN on positive edge of COINC
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      TRIGGER_PATTERN <= "0000000000000000";
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COINC_TMP = '1' and COINC_DEL = '0' then
        TRIGGER_PATTERN(0) <= ML1;
        TRIGGER_PATTERN(1) <= MH1;
        TRIGGER_PATTERN(2) <= ML2;
        TRIGGER_PATTERN(3) <= MH2;
        TRIGGER_PATTERN(4) <= SL1;
        TRIGGER_PATTERN(5) <= SH1;
        TRIGGER_PATTERN(6) <= SL2;
        TRIGGER_PATTERN(7) <= SH2;
        TRIGGER_PATTERN(8) <= EXT_TR;
        TRIGGER_PATTERN(9) <= MASTER;
        TRIGGER_PATTERN(10) <= SLAVE_PRESENT;
        TRIGGER_PATTERN(11) <= COMPL1;
        TRIGGER_PATTERN(12) <= COMPH1;
        TRIGGER_PATTERN(13) <= COMPL2;
        TRIGGER_PATTERN(14) <= COMPH2;
        TRIGGER_PATTERN(15) <= '0';
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

  -- COINC_TO_END_TIME goes from begin of coinc till end of posttime
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COINC_TO_END_TIME <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      COINC_TO_END_TIME <= COINC_TMP or COINC_DEL or COINC_TO_END_TIME_TMP;
    end if;
  end process;  

end rtl ; -- of TRIGGER_MATRIX

