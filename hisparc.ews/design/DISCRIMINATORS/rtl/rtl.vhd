-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'DISCRIMINATORS.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'DISCRIMINATORS' :
-- 
--   port(
--     CLK200MHz     : in     std_logic;
--     COINC_TIME    : in     integer range 1000 downto 0;
--     COMPH1        : out    std_logic;
--     COMPH1_IN     : in     std_logic;
--     COMPH2        : out    std_logic;
--     COMPH2_IN     : in     std_logic;
--     COMPL1        : out    std_logic;
--     COMPL1_IN     : in     std_logic;
--     COMPL2        : out    std_logic;
--     COMPL2_IN     : in     std_logic;
--     DATA_ADC1_NEG : in     std_logic_vector(11 downto 0);
--     DATA_ADC1_POS : in     std_logic_vector(11 downto 0);
--     DATA_ADC2_NEG : in     std_logic_vector(11 downto 0);
--     DATA_ADC2_POS : in     std_logic_vector(11 downto 0);
--     EXT_TR_IN     : in     std_logic;
--     EXT_TR_OUT    : out    std_logic;
--     MASTER        : in     std_logic;
--     MH1_OUT       : out    std_logic;
--     MH2_OUT       : out    std_logic;
--     ML1_OUT       : out    std_logic;
--     ML2_OUT       : out    std_logic;
--     SYSRST        : in     std_logic;
--     THH1          : in     std_logic_vector(11 downto 0);
--     THH2          : in     std_logic_vector(11 downto 0);
--     THL1          : in     std_logic_vector(11 downto 0);
--     THL2          : in     std_logic_vector(11 downto 0));
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of DISCRIMINATORS is

signal ML1_PRE: std_logic ; -- Time Over Threshold channel1 low
signal ML2_PRE: std_logic ; -- Time Over Threshold channel2 low
signal MH1_PRE: std_logic ; -- Time Over Threshold channel1 high
signal MH2_PRE: std_logic ; -- Time Over Threshold channel2 high
signal ML1_PRE_DEL: std_logic ; -- Time Over Threshold channel1 low after one 200MHz period
signal ML2_PRE_DEL: std_logic ; -- Time Over Threshold channel2 low after one 200MHz period
signal MH1_PRE_DEL: std_logic ; -- Time Over Threshold channel1 high after one 200MHz period
signal MH2_PRE_DEL: std_logic ; -- Time Over Threshold channel2 high after one 200MHz period
signal ML1: std_logic ; -- Coincidence window ML1_PRE
signal ML1_CNT: integer range 1000 downto 0 ; -- Coincidence window counter ML1_PRE
signal ML2: std_logic ; -- Coincidence window ML2_PRE
signal ML2_CNT: integer range 1000 downto 0 ; -- Coincidence window counter ML2_PRE
signal MH1: std_logic ; -- Coincidence window MH1_PRE
signal MH1_CNT: integer range 1000 downto 0 ; -- Coincidence window counter MH1_PRE
signal MH2: std_logic ; -- Coincidence window MH2_PRE
signal MH2_CNT: integer range 1000 downto 0 ; -- Coincidence window counter MH2_PRE
signal EXT_TR_IN_DEL1: std_logic ; -- External trigger after one 200MHz period
signal EXT_TR_IN_DEL2: std_logic ; -- External trigger after two 200MHz periods; Two, because the external trigger is asynchronious
signal EXT_TR: std_logic ; -- Coincidence window EXT_TR
signal EXT_TR_CNT: integer range 1000 downto 0 ; -- Coincidence window counter EXT_TR
signal COMPL1_IN_DEL1: std_logic ; 
signal COMPL1_IN_DEL2: std_logic ; 
signal COMPL1_IN_WIN: std_logic ; 
signal COMPL1_IN_CNT: integer range 1000 downto 0 ; 
signal COMPH1_IN_DEL1: std_logic ; 
signal COMPH1_IN_DEL2: std_logic ; 
signal COMPH1_IN_WIN: std_logic ; 
signal COMPH1_IN_CNT: integer range 1000 downto 0 ; 
signal COMPL2_IN_DEL1: std_logic ; 
signal COMPL2_IN_DEL2: std_logic ; 
signal COMPL2_IN_WIN: std_logic ; 
signal COMPL2_IN_CNT: integer range 1000 downto 0 ; 
signal COMPH2_IN_DEL1: std_logic ; 
signal COMPH2_IN_DEL2: std_logic ; 
signal COMPH2_IN_WIN: std_logic ; 
signal COMPH2_IN_CNT: integer range 1000 downto 0 ; 
signal ML1_DEL1: std_logic ; -- Compensates the delay from slave to master
signal ML1_DEL2: std_logic ; 
signal ML1_DEL3: std_logic ; 
signal ML1_DEL4: std_logic ; 
signal MH1_DEL1: std_logic ; 
signal MH1_DEL2: std_logic ; 
signal MH1_DEL3: std_logic ; 
signal MH1_DEL4: std_logic ; 
signal ML2_DEL1: std_logic ; 
signal ML2_DEL2: std_logic ; 
signal ML2_DEL3: std_logic ; 
signal ML2_DEL4: std_logic ; 
signal MH2_DEL1: std_logic ; 
signal MH2_DEL2: std_logic ; 
signal MH2_DEL3: std_logic ; 
signal MH2_DEL4: std_logic ; 

begin

--ML1_PRE <= '1' when (DATA_ADC1_POS > THL1 or DATA_ADC1_NEG > THL1) else '0'; -- Discriminator for ML1
--ML2_PRE <= '1' when (DATA_ADC2_POS > THL2 or DATA_ADC2_NEG > THL2) else '0'; -- Discriminator for ML2
--MH1_PRE <= '1' when (DATA_ADC1_POS > THH1 or DATA_ADC1_NEG > THH1) else '0'; -- Discriminator for MH1
--MH2_PRE <= '1' when (DATA_ADC2_POS > THH2 or DATA_ADC2_NEG > THH2) else '0'; -- Discriminator for MH2

ML1_OUT <= ML1 when MASTER = '0' else ML1_DEL4;
MH1_OUT <= MH1 when MASTER = '0' else MH1_DEL4;
ML2_OUT <= ML2 when MASTER = '0' else ML2_DEL4;
MH2_OUT <= MH2 when MASTER = '0' else MH2_DEL4;
EXT_TR_OUT <= EXT_TR;
COMPL1 <= COMPL1_IN_WIN;
COMPL2 <= COMPL2_IN_WIN;
COMPH1 <= COMPH1_IN_WIN;
COMPH2 <= COMPH2_IN_WIN;

  process(CLK200MHz,SYSRST)
  begin
    if (CLK200MHz'event and CLK200MHz = '1') then
      if (DATA_ADC1_POS > THL1 or DATA_ADC1_NEG > THL1) then -- Discriminator for ML1
        ML1_PRE <= '1';
      else
        ML1_PRE <= '0';
      end if;
      if (DATA_ADC2_POS > THL2 or DATA_ADC2_NEG > THL2) then -- Discriminator for ML2
        ML2_PRE <= '1';
      else
        ML2_PRE <= '0';
      end if;
      if (DATA_ADC1_POS > THH1 or DATA_ADC1_NEG > THH1) then -- Discriminator for MH1
        MH1_PRE <= '1';
      else
        MH1_PRE <= '0';
      end if;
      if (DATA_ADC2_POS > THH2 or DATA_ADC2_NEG > THH2) then -- Discriminator for MH2
        MH2_PRE <= '1';
      else
        MH2_PRE <= '0';
      end if;
    end if;
  end process;  


  -- Delays
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      ML1_PRE_DEL <= '0';
      ML2_PRE_DEL <= '0';
      MH1_PRE_DEL <= '0';
      MH2_PRE_DEL <= '0';
      EXT_TR_IN_DEL1 <= '0';
      EXT_TR_IN_DEL2 <= '0';
      COMPL1_IN_DEL1 <= '0';
      COMPL1_IN_DEL2 <= '0';
      COMPH1_IN_DEL1 <= '0';
      COMPH1_IN_DEL2 <= '0';
      COMPL2_IN_DEL1 <= '0';
      COMPL2_IN_DEL2 <= '0';
      COMPH2_IN_DEL1 <= '0';
      COMPH2_IN_DEL2 <= '0';
      ML1_DEL1 <= '0';
      ML1_DEL2 <= '0';
      ML1_DEL3 <= '0';
      ML1_DEL4 <= '0';
      MH1_DEL1 <= '0';
      MH1_DEL2 <= '0';
      MH1_DEL3 <= '0';
      MH1_DEL4 <= '0';
      ML2_DEL1 <= '0';
      ML2_DEL2 <= '0';
      ML2_DEL3 <= '0';
      ML2_DEL4 <= '0';
      MH2_DEL1 <= '0';
      MH2_DEL2 <= '0';
      MH2_DEL3 <= '0';
      MH2_DEL4 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      ML1_PRE_DEL <= ML1_PRE; 
      ML2_PRE_DEL <= ML2_PRE; 
      MH1_PRE_DEL <= MH1_PRE; 
      MH2_PRE_DEL <= MH2_PRE; 
      EXT_TR_IN_DEL1 <= EXT_TR_IN; 
      EXT_TR_IN_DEL2 <= EXT_TR_IN_DEL1; 
      COMPL1_IN_DEL1 <= COMPL1_IN; 
      COMPL1_IN_DEL2 <= COMPL1_IN_DEL1; 
      COMPH1_IN_DEL1 <= COMPH1_IN; 
      COMPH1_IN_DEL2 <= COMPH1_IN_DEL1; 
      COMPL2_IN_DEL1 <= COMPL2_IN; 
      COMPL2_IN_DEL2 <= COMPL2_IN_DEL1; 
      COMPH2_IN_DEL1 <= COMPH2_IN; 
      COMPH2_IN_DEL2 <= COMPH2_IN_DEL1; 
      ML1_DEL1 <= ML1; 
      ML1_DEL2 <= ML1_DEL1; 
      ML1_DEL3 <= ML1_DEL2; 
      ML1_DEL4 <= ML1_DEL3; 
      MH1_DEL1 <= MH1; 
      MH1_DEL2 <= MH1_DEL1; 
      MH1_DEL3 <= MH1_DEL2; 
      MH1_DEL4 <= MH1_DEL3; 
      ML2_DEL1 <= ML2; 
      ML2_DEL2 <= ML2_DEL1; 
      ML2_DEL3 <= ML2_DEL2; 
      ML2_DEL4 <= ML2_DEL3; 
      MH2_DEL1 <= MH2; 
      MH2_DEL2 <= MH2_DEL1; 
      MH2_DEL3 <= MH2_DEL2; 
      MH2_DEL4 <= MH2_DEL3; 
    end if;
  end process;  
      
  -- Coincidence window for ML1
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      ML1 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if ML1_PRE = '1' and ML1_PRE_DEL = '0' then  -- On an upgoing egde of ML1_PRE
        ML1 <= '1'; 
      elsif ML1_CNT = COINC_TIME - 1 then
        ML1 <= '0';
      end if;
    end if;
  end process;  

  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      ML1_CNT <= 0;
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if ML1 = '0' then -- ML1 = '0' makes end of coinc window
        ML1_CNT <= 0;
      else
        ML1_CNT <= ML1_CNT + 1;
      end if;
    end if;
  end process;  

  -- Coincidence window for ML2
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      ML2 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if ML2_PRE = '1' and ML2_PRE_DEL = '0' then -- On an upgoing egde of ML2_PRE
        ML2 <= '1'; 
      elsif ML2_CNT = COINC_TIME - 1 then
        ML2 <= '0';
      end if;
    end if;
  end process;  
      
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      ML2_CNT <= 0;
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if ML2 = '0' then -- ML2 = '0' makes end of coinc window
        ML2_CNT <= 0;
      else
        ML2_CNT <= ML2_CNT + 1;
      end if;
    end if;
  end process;  

  -- Coincidence window for MH1
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      MH1 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if MH1_PRE = '1' and MH1_PRE_DEL = '0' then  -- On an upgoing egde of MH1_PRE
        MH1 <= '1'; 
      elsif MH1_CNT = COINC_TIME - 1 then
        MH1 <= '0';
      end if;
    end if;
  end process;  
      
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      MH1_CNT <= 0;
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if MH1 = '0' then -- MH1 = '0' makes end of coinc window
        MH1_CNT <= 0;
      else
        MH1_CNT <= MH1_CNT + 1;
      end if;
    end if;
  end process;  

  -- Coincidence window for MH2
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      MH2 <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if MH2_PRE = '1' and MH2_PRE_DEL = '0' then -- On an upgoing egde of MH2_PRE
        MH2 <= '1'; 
      elsif MH2_CNT = COINC_TIME - 1 then
        MH2 <= '0';
      end if;
    end if;
  end process;  
      
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      MH2_CNT <= 0;
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if MH2 = '0' then -- MH2 = '0' makes end of coinc window
        MH2_CNT <= 0;
      else
        MH2_CNT <= MH2_CNT + 1;
      end if;
    end if;
  end process;  

  -- Coincidence window for EXT_TR
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      EXT_TR <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if EXT_TR_IN_DEL1 = '1' and EXT_TR_IN_DEL2 = '0' then -- On an upgoing egde of EXT_TR_IN
        EXT_TR <= '1'; 
      elsif EXT_TR_CNT = COINC_TIME - 1 then
        EXT_TR <= '0';
      end if;
    end if;
  end process;  
      
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      EXT_TR_CNT <= 0;
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if EXT_TR = '0' then -- EXT_TR = '0' makes end of coinc window
        EXT_TR_CNT <= 0;
      else
        EXT_TR_CNT <= EXT_TR_CNT + 1;
      end if;
    end if;
  end process;  

  -- Coincidence window for COMPL1
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COMPL1_IN_WIN <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COMPL1_IN_DEL1 = '1' and COMPL1_IN_DEL2 = '0' then 
        COMPL1_IN_WIN <= '1'; 
      elsif COMPL1_IN_CNT = COINC_TIME - 1 then
        COMPL1_IN_WIN <= '0';
      end if;
    end if;
  end process;  
      
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COMPL1_IN_CNT <= 0;
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COMPL1_IN_WIN = '0' then 
        COMPL1_IN_CNT <= 0;
      else
        COMPL1_IN_CNT <= COMPL1_IN_CNT + 1;
      end if;
    end if;
  end process;  

  -- Coincidence window for COMPH1
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COMPH1_IN_WIN <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COMPH1_IN_DEL1 = '1' and COMPH1_IN_DEL2 = '0' then 
        COMPH1_IN_WIN <= '1'; 
      elsif COMPH1_IN_CNT = COINC_TIME - 1 then
        COMPH1_IN_WIN <= '0';
      end if;
    end if;
  end process;  
      
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COMPH1_IN_CNT <= 0;
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COMPH1_IN_WIN = '0' then 
        COMPH1_IN_CNT <= 0;
      else
        COMPH1_IN_CNT <= COMPH1_IN_CNT + 1;
      end if;
    end if;
  end process;  

  -- Coincidence window for COMPL2
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COMPL2_IN_WIN <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COMPL2_IN_DEL1 = '1' and COMPL2_IN_DEL2 = '0' then 
        COMPL2_IN_WIN <= '1'; 
      elsif COMPL2_IN_CNT = COINC_TIME - 1 then
        COMPL2_IN_WIN <= '0';
      end if;
    end if;
  end process;  
      
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COMPL2_IN_CNT <= 0;
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COMPL2_IN_WIN = '0' then 
        COMPL2_IN_CNT <= 0;
      else
        COMPL2_IN_CNT <= COMPL2_IN_CNT + 1;
      end if;
    end if;
  end process;  

  -- Coincidence window for COMPH2
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COMPH2_IN_WIN <= '0';
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COMPH2_IN_DEL1 = '1' and COMPH2_IN_DEL2 = '0' then 
        COMPH2_IN_WIN <= '1'; 
      elsif COMPH2_IN_CNT = COINC_TIME - 1 then
        COMPH2_IN_WIN <= '0';
      end if;
    end if;
  end process;  
      
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COMPH2_IN_CNT <= 0;
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COMPH2_IN_WIN = '0' then 
        COMPH2_IN_CNT <= 0;
      else
        COMPH2_IN_CNT <= COMPH2_IN_CNT + 1;
      end if;
    end if;
  end process;  

end rtl ; -- of DISCRIMINATORS

