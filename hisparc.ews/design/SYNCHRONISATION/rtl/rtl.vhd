-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'SYNCHRONISATION.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'SYNCHRONISATION' :
-- 
--   port(
--     CLK200MHz    : in     std_logic;
--     DATA_NEG_ADC : in     std_logic_vector(11 downto 0);
--     DATA_POS_ADC : in     std_logic_vector(11 downto 0);
--     DCO_NEG_ADC  : in     std_logic;
--     DCO_POS_ADC  : in     std_logic;
--     DOUT_NEG     : out    std_logic_vector(11 downto 0);
--     DOUT_POS     : out    std_logic_vector(11 downto 0);
--     LOCKED       : in     std_logic;
--     SYSRST       : in     std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of SYNCHRONISATION is

signal RST: std_logic; 
signal DATA_POS_ADC_TMP1: std_logic_vector(11 downto 0);
signal DATA_POS_ADC_TMP2: std_logic_vector(11 downto 0);
signal DATA_NEG_ADC_TMP1: std_logic_vector(11 downto 0);
-- signal DATA_NEG_ADC_TMP2: std_logic_vector(11 downto 0);

begin
  
  RST <= SYSRST or not LOCKED;
  
  process(DCO_POS_ADC,RST)
  begin
    if RST = '1' then
      DATA_POS_ADC_TMP1 <= (others => '0');
    elsif (DCO_POS_ADC'event and DCO_POS_ADC = '1') then
      DATA_POS_ADC_TMP1 <= DATA_POS_ADC;
    end if;
  end process;  

  process(CLK200MHz,RST)
  begin
    if RST = '1' then
      DATA_POS_ADC_TMP2 <= (others => '0');
    elsif (CLK200MHz'event and CLK200MHz = '0') then -- negative edge
      DATA_POS_ADC_TMP2 <= DATA_POS_ADC_TMP1;
    end if;
  end process;  

  process(CLK200MHz,RST)
  begin
    if RST = '1' then
      Dout_POS <= (others => '0');
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      Dout_POS <= DATA_POS_ADC_TMP2;
    end if;
  end process;  

  process(DCO_NEG_ADC,RST)
  begin
    if RST = '1' then
      DATA_NEG_ADC_TMP1 <= (others => '0');
    elsif (DCO_NEG_ADC'event and DCO_NEG_ADC = '1') then
      DATA_NEG_ADC_TMP1 <= DATA_NEG_ADC;
    end if;
  end process;  

--  process(CLK200MHz,RST)
--  begin
--    if RST = '1' then
--      DATA_NEG_ADC_TMP2 <= (others => '0');
--    elsif (CLK200MHz'event and CLK200MHz = '0') then
--      DATA_NEG_ADC_TMP2 <= DATA_NEG_ADC_TMP1;
--    end if;
--  end process;  

  process(CLK200MHz,RST)
  begin
    if RST = '1' then
      Dout_NEG <= (others => '0');
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      Dout_NEG <= DATA_NEG_ADC_TMP1;
    end if;
  end process;  

end rtl ; -- of SYNCHRONISATION

