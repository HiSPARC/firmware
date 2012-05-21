-- EASE/HDL begin --------------------------------------------------------------
-- 
-- Architecture 'rtl' of entity 'SER_LED_DATA'.
-- 
--------------------------------------------------------------------------------
-- 
-- Copy of the interface declaration:
-- 
--   port(
--     CLK10MHz       : in     std_logic;
--     HIT_PATTERN    : in     std_logic_vector(7 downto 0);
--     LED_DATA_OUT   : out    std_logic;
--     MASTER_PATTERN : out    std_logic_vector(3 downto 0);
--     STROBE         : in     std_logic;
--     SYSRST         : in     std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of SER_LED_DATA is

signal DATA_COUNT: integer range 24 downto 0;
signal STROBE_DEL: std_logic ;
signal SEND_CLK: std_logic ;
signal SEND_CLK_DEL: std_logic ;
signal SEND_CLK_CNT: std_logic_vector(3 downto 0);

begin

  SEND_CLK <= SEND_CLK_CNT(3);

  process(CLK10MHz,SYSRST)
  begin
  	if SYSRST = '1' then
  	  SEND_CLK_CNT <= "0000";
    elsif (CLK10MHz'event and CLK10MHz = '1') then 
  	  SEND_CLK_CNT <= SEND_CLK_CNT + "0001";
    end if;
  end process;

  process(CLK10MHz,SYSRST)
  begin
  	if SYSRST = '1' then
  	  SEND_CLK_DEL <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then 
  	  SEND_CLK_DEL <= SEND_CLK;
    end if;
  end process;

  process(CLK10MHz,SYSRST)
  begin
  	if SYSRST = '1' then
  	  STROBE_DEL <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then 
      if SEND_CLK = '1' and SEND_CLK_DEL = '0' then  -- upgoing edge of SEND_CLK
  	    STROBE_DEL <= STROBE;
      end if;
    end if;
  end process;

  process(CLK10MHz,SYSRST)
  begin
  	if SYSRST = '1' then
  	  DATA_COUNT <= 24;
    elsif (CLK10MHz'event and CLK10MHz = '1') then 
      if (SEND_CLK = '1' and SEND_CLK_DEL = '0') then 
        if (STROBE = '1' and STROBE_DEL = '0') then  -- upgoing edge of STROBE
  	      DATA_COUNT <= 0;
        elsif DATA_COUNT < 24 then  
          DATA_COUNT <= DATA_COUNT + 1;
        else  
          DATA_COUNT <= DATA_COUNT;
        end if;
      end if;
    end if;
  end process;


  process(DATA_COUNT,HIT_PATTERN)
  begin
    case (DATA_COUNT) is
      when 0 => LED_DATA_OUT <= '1'; -- 99h
      when 1 => LED_DATA_OUT <= '0'; -- 99h
      when 2 => LED_DATA_OUT <= '0'; -- 99h
      when 3 => LED_DATA_OUT <= '1'; -- 99h
      when 4 => LED_DATA_OUT <= '1'; -- 99h
      when 5 => LED_DATA_OUT <= '0'; -- 99h
      when 6 => LED_DATA_OUT <= '0'; -- 99h
      when 7 => LED_DATA_OUT <= '1'; -- 99h
      when 8 => LED_DATA_OUT <= HIT_PATTERN(7); 
      when 9 => LED_DATA_OUT <= HIT_PATTERN(6); 
      when 10 => LED_DATA_OUT <= HIT_PATTERN(5); 
      when 11 => LED_DATA_OUT <= HIT_PATTERN(4); 
      when 12 => LED_DATA_OUT <= HIT_PATTERN(3); 
      when 13 => LED_DATA_OUT <= HIT_PATTERN(2); 
      when 14 => LED_DATA_OUT <= HIT_PATTERN(1); 
      when 15 => LED_DATA_OUT <= HIT_PATTERN(0); 
      when 16 => LED_DATA_OUT <= '0'; -- 66h
      when 17 => LED_DATA_OUT <= '1'; -- 66h
      when 18 => LED_DATA_OUT <= '1'; -- 66h
      when 19 => LED_DATA_OUT <= '0'; -- 66h
      when 20 => LED_DATA_OUT <= '0'; -- 66h
      when 21 => LED_DATA_OUT <= '1'; -- 66h
      when 22 => LED_DATA_OUT <= '1'; -- 66h
      when 23 => LED_DATA_OUT <= '0'; -- 66h
      when others => LED_DATA_OUT <= '0';
    end case;
  end process;

  process(CLK10MHz,SYSRST)
  begin
  	if SYSRST = '1' then
  	  MASTER_PATTERN <= "0000";
    elsif (CLK10MHz'event and CLK10MHz = '1') then 
      if STROBE = '1' and STROBE_DEL = '0' then  -- upgoing edge of STROBE
  	    MASTER_PATTERN(3) <= HIT_PATTERN(7); -- 3 Hit Master Ch 1
  	    MASTER_PATTERN(2) <= HIT_PATTERN(6); -- 3 Hit Master Ch 2
  	    MASTER_PATTERN(1) <= HIT_PATTERN(3); -- 2 Hit Master Ch 1
  	    MASTER_PATTERN(0) <= HIT_PATTERN(2); -- 2 Hit Master Ch 2
      else  
  	    MASTER_PATTERN <= "0000";
      end if;
    end if;
  end process;

end rtl ; -- of SER_LED_DATA

