-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'a0' of 'DUAL_PORT_RAM.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'DUAL_PORT_RAM' :
-- 
--   port(
--     DATA_IN    : in     std_logic_vector(11 downto 0);
--     DATA_OUT   : out    std_logic_vector(11 downto 0);
--     RDCLOCK    : in     std_logic;
--     RD_ADDRESS : in     integer range 2020 downto 0;
--     WE         : in     std_logic;
--     WRCLOCK    : in     std_logic;
--     WR_ADDRESS : in     integer range 2020 downto 0);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture a0 of DUAL_PORT_RAM is

	type MEM is array(0 to 2020) of std_logic_vector(11 downto 0);
	signal RAM_BLOCK : MEM;
	signal RD_ADDRESS_REG : integer range 0 to 2020;

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

end a0 ; -- of DUAL_PORT_RAM

