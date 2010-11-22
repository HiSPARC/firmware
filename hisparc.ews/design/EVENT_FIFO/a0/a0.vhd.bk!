-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'a0' of 'EVENT_FIFO.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'EVENT_FIFO' :
-- 
--   port(
--     DATA_IN    : in     std_logic_vector(7 downto 0);
--     DATA_OUT   : out    std_logic_vector(7 downto 0);
--     RDCLOCK    : in     std_logic;
--     RD_ADDRESS : in     integer range 12020 downto 0;
--     WE         : in     std_logic;
--     WRCLOCK    : in     std_logic;
--     WR_ADDRESS : in     integer range 12020 downto 0);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture a0 of EVENT_FIFO is

  type MEM is array(0 to 12020) of std_logic_vector(7 downto 0);
  signal RAM_BLOCK : MEM;
  signal RD_ADDRESS_REG : integer range 0 to 12020;

begin

  process (WRCLOCK)
  begin
    if (WRCLOCK'event and WRCLOCK = '1') then
      if (WE = '1') then
        RAM_BLOCK(WR_ADDRESS) <= DATA_IN;
      end if;
    end if;
  end process;

  process (RDCLOCK)
  BEGIN
    if (RDCLOCK'event and RDCLOCK = '1') then
      DATA_OUT <= RAM_BLOCK(RD_ADDRESS_REG);
      RD_ADDRESS_REG <= RD_ADDRESS;
    end if;
  end process;

end architecture a0 ; -- of EVENT_FIFO

