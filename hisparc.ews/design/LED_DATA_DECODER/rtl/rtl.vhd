-- EASE/HDL begin --------------------------------------------------------------
-- 
-- Architecture 'rtl' of entity 'LED_DATA_DECODER'.
-- 
--------------------------------------------------------------------------------
-- 
-- Copy of the interface declaration:
-- 
--   port(
--     CLK10MHz      : in     std_logic;
--     LED_DATA_IN   : in     std_logic;
--     SLAVE_PATTERN : out    std_logic_vector(3 downto 0);
--     SYSRST        : in     std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of LED_DATA_DECODER is

signal SAMPLE_COUNT : integer range 385 downto 0; -- Counter which samples the incomming serial data
signal GET_START_BYTE : std_logic_vector (7 downto 0); 
signal GET_PATTERN_BYTE : std_logic_vector (7 downto 0); 
signal GET_STOP_BYTE : std_logic_vector (7 downto 0); 


begin

 -- Sample counter
  process(CLK10MHz, SYSRST)                               
  begin
 	if SYSRST = '1' then
  	SAMPLE_COUNT <= 0;
  elsif CLK10MHz'event and CLK10MHz = '1' then
  	if SAMPLE_COUNT = 0 and LED_DATA_IN = '0' then
   		SAMPLE_COUNT <= 0 ; -- wait for start 
    elsif SAMPLE_COUNT = 8 and LED_DATA_IN = '0' then
   		SAMPLE_COUNT <= 0 ; -- false start
   	elsif SAMPLE_COUNT = 385 then 
   		SAMPLE_COUNT <= 0; -- end
    else
   		SAMPLE_COUNT <= SAMPLE_COUNT + 1;
   	end if;
 	end if; 
  end process;

  process(CLK10MHz,SYSRST,SAMPLE_COUNT,LED_DATA_IN)
  begin
 	if SYSRST = '1' then
  	GET_START_BYTE <= "00000000";
  	GET_PATTERN_BYTE <= "00000000";
  	GET_STOP_BYTE <= "00000000";
  elsif CLK10MHz'event and CLK10MHz = '1' then
    case (SAMPLE_COUNT) is
      when 8 => GET_START_BYTE(7) <= LED_DATA_IN;
      when 24 => GET_START_BYTE(6) <= LED_DATA_IN;
      when 40 => GET_START_BYTE(5) <= LED_DATA_IN;
      when 56 => GET_START_BYTE(4) <= LED_DATA_IN;
      when 72 => GET_START_BYTE(3) <= LED_DATA_IN;
      when 88 => GET_START_BYTE(2) <= LED_DATA_IN;
      when 104 => GET_START_BYTE(1) <= LED_DATA_IN;
      when 120 => GET_START_BYTE(0) <= LED_DATA_IN;
      when 136 => GET_PATTERN_BYTE(7) <= LED_DATA_IN;
      when 152 => GET_PATTERN_BYTE(6) <= LED_DATA_IN;
      when 168 => GET_PATTERN_BYTE(5) <= LED_DATA_IN;
      when 184 => GET_PATTERN_BYTE(4) <= LED_DATA_IN;
      when 200 => GET_PATTERN_BYTE(3) <= LED_DATA_IN;
      when 216 => GET_PATTERN_BYTE(2) <= LED_DATA_IN;
      when 232 => GET_PATTERN_BYTE(1) <= LED_DATA_IN;
      when 248 => GET_PATTERN_BYTE(0) <= LED_DATA_IN;
      when 264 => GET_STOP_BYTE(7) <= LED_DATA_IN;
      when 280 => GET_STOP_BYTE(6) <= LED_DATA_IN;
      when 296 => GET_STOP_BYTE(5) <= LED_DATA_IN;
      when 312 => GET_STOP_BYTE(4) <= LED_DATA_IN;
      when 328 => GET_STOP_BYTE(3) <= LED_DATA_IN;
      when 344 => GET_STOP_BYTE(2) <= LED_DATA_IN;
      when 360 => GET_STOP_BYTE(1) <= LED_DATA_IN;
      when 376 => GET_STOP_BYTE(0) <= LED_DATA_IN;
      when others => 
    end case;
 	end if; 
  end process;

  process(CLK10MHz, SYSRST)                               
  begin
 	if SYSRST = '1' then
  	SLAVE_PATTERN <= "0000";
  elsif CLK10MHz'event and CLK10MHz = '1' then
  	if SAMPLE_COUNT = 384 and GET_START_BYTE = "10011001" and GET_STOP_BYTE = "01100110" then
	    SLAVE_PATTERN(3) <= GET_PATTERN_BYTE(5); -- 3 Hit Slave Ch 1
 	    SLAVE_PATTERN(2) <= GET_PATTERN_BYTE(4); -- 3 Hit Slave Ch 2
 	    SLAVE_PATTERN(1) <= GET_PATTERN_BYTE(1); -- 2 Hit Slave Ch 1
 	    SLAVE_PATTERN(0) <= GET_PATTERN_BYTE(0); -- 2 Hit Slave Ch 2
    else
  	  SLAVE_PATTERN <= "0000";
   	end if;
 	end if; 
  end process;


end rtl ; -- of LED_DATA_DECODER

