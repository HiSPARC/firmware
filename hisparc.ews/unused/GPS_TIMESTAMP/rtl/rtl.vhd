-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'GPS_TIMESTAMP.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'GPS_TIMESTAMP' :
-- 
--   port(
--     CLK10MHz           : in     std_logic;
--     CLK200MHz          : in     std_logic;
--     COINC              : in     std_logic;
--     GPS_TS_ONE_PPS_OUT : out    std_logic_vector(55 downto 0);
--     GPS_TS_OUT         : out    std_logic_vector(55 downto 0);
--     ONE_PPS            : in     std_logic;
--     RXD                : in     std_logic;
--     SYSRST             : in     std_logic;
--     TXD                : out    std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of GPS_TIMESTAMP is

signal COUNTER_153600 : std_logic_vector (6 downto 0); -- Counter at 153600Hz; Sample counter
signal CLK_153600 : std_logic;  
signal COUNTER_9600 : std_logic_vector (3 downto 0);
signal CLK_9600 : std_logic; -- Counter at 9600Hz; bautrate counter

signal GO : std_logic; -- This signal starts the initialisation data to the GPS reciever and becomes active 6.8 seconds after SYSRST
signal GO_DEL: std_logic;
signal GO_COUNT : std_logic_vector(15 downto 0); -- Counts 6.8 seconds
signal ENA_SER_DATA_COUNT: std_logic; -- This signal enables the data counter, which counts the number of bits send to the GPS reciever
signal SER_DATA_COUNT: integer range 81 downto 0;  
signal RST_CNT : std_logic; -- End of SER_DATA_COUNT
signal STARTBIT : std_logic;
signal SERWORD0 : std_logic_vector(7 downto 0);
signal SERWORD1 : std_logic_vector(7 downto 0);
signal SERWORD2 : std_logic_vector(7 downto 0);
signal SERWORD3 : std_logic_vector(7 downto 0);
signal SERWORD4 : std_logic_vector(7 downto 0);
signal SERWORD5 : std_logic_vector(7 downto 0);
signal SERWORD6 : std_logic_vector(7 downto 0);
signal SERWORD7 : std_logic_vector(7 downto 0);
signal STOPBIT : std_logic;

signal SAMPLE_COUNT : integer range 152 downto 0; -- Counter which samples the incomming serial data
signal TIME_OUT_COUNT : integer range 1600 downto 0; --10 bytes (16 times oversampling; 10 bits per word(8xdata + start and stop)) 
signal TIME_OUT : std_logic; -- Resets WORDCOUNT when there is 10 bytes long no data
signal WORD_COUNT : integer range 80 downto 0; -- Counts the number of words in the serial data stream
signal PAR_WORD : std_logic_vector (7 downto 0); -- This byte stores the serial bits
signal GPS_WORD4   : std_logic_vector ( 7 downto 0); -- Month (1 to 12)
signal GPS_WORD5   : std_logic_vector ( 7 downto 0); -- Day (1 to 31)
signal GPS_WORD6   : std_logic_vector ( 7 downto 0); -- Year (1998 to 2018) Higher byte
signal GPS_WORD7   : std_logic_vector ( 7 downto 0); -- Year (1998 to 2018) Lower byte
signal GPS_WORD8   : std_logic_vector ( 7 downto 0); -- Hours (0 to 23)
signal GPS_WORD9   : std_logic_vector ( 7 downto 0); -- Minutes (0 to 59)
signal GPS_WORD10  : std_logic_vector ( 7 downto 0); -- Seconds (0 to 60)
signal GPS_WORD15  : std_logic_vector ( 7 downto 0); -- Latitude (-324.000.000 to 324.000.000) (-90 degree to 90 degree) (324.000.000 = 1000 * 60 * 60 * 90)
signal GPS_WORD16  : std_logic_vector ( 7 downto 0); -- Latitude
signal GPS_WORD17  : std_logic_vector ( 7 downto 0); -- Latitude
signal GPS_WORD18  : std_logic_vector ( 7 downto 0); -- Latitude
signal GPS_WORD19  : std_logic_vector ( 7 downto 0); -- Longitude (-648.000.000 to 648.000.000) (-180 degree to 180 degree)
signal GPS_WORD20  : std_logic_vector ( 7 downto 0); -- Longitude
signal GPS_WORD21  : std_logic_vector ( 7 downto 0); -- Longitude
signal GPS_WORD22  : std_logic_vector ( 7 downto 0); -- Longitude

signal COINC_DEL: std_logic ;
signal GPS_TIME: std_logic_vector(55 downto 0);
signal ONE_PPS_DEL1: std_logic ; -- One delay needed to synchronize the asynchronious ONE_PPS with the 200MHz
signal ONE_PPS_DEL2: std_logic ;

begin

  GPS_TIME <= "01110111011001100101010101000100001100110010001000010001";

  SERWORD0 <= "01000000"; -- @
  SERWORD1 <= "01000000"; -- @
  SERWORD2 <= "01000101"; -- E
  SERWORD3 <= "01100001"; -- a
  SERWORD4 <= "00000001"; -- m
  SERWORD5 <= "00100101"; -- C
  SERWORD6 <= "00001101"; -- <CR>         
  SERWORD7 <= "00001010"; -- <LF>
  STARTBIT <= '0';
  STOPBIT <= '1';

-- 153600HZ counter/clock 
-- Used for sampling the serial RS232 data at 16 times the bautrate of 9600Hz
-- This is actual 153850Hz (10Mhz divide by 65); Mismatch is 0.16%                  
  process (CLK10MHz, SYSRST)
  begin
	if SYSRST = '1' then
	  COUNTER_153600 <= "0000000";                 
	elsif CLK10MHz'event and CLK10MHz = '1' then
	  if COUNTER_153600 >= "1000000" then -- 10Mhz divide by 65 (from 0 to 64)
		COUNTER_153600 <= "0000000";
		CLK_153600 <= '1';
	  else
		COUNTER_153600<= COUNTER_153600 + "0000001";
		CLK_153600 <= '0';
	  end if;
	end if;
  end process;


-- 9600 bautrateclock 
-- Divides the 153600Hz clock by 16                 
  process (CLK_153600, SYSRST)
  begin
	if SYSRST = '1' then
	  COUNTER_9600 <= "0000";                 
	elsif CLK_153600'event and CLK_153600 = '1' then
	  COUNTER_9600 <= COUNTER_9600 + "0001";
	end if;
  end process;

  CLK_9600 <= COUNTER_9600(3);

------------------ Start Initialisation GPS reciever -----------------------------------------

-- GO stuff
-- These signals intialisize the GPS reciever afteer 6.8 seconds	                        
  process (CLK_9600, SYSRST) 
  begin
	if  SYSRST = '1' then
	  GO_COUNT <= "0000000000000000";
	  GO_DEL <= '0'; 
	elsif CLK_9600'event and CLK_9600 = '1'then
	  GO_DEL <= GO;
      if GO_COUNT = "1111111111111111" then 
 	    GO_COUNT <= GO_COUNT; -- GO_COUNT locks itself after 6.8 seconds
      else
        GO_COUNT <= GO_COUNT + "0000000000000001";
      end if; 
    end if;
  end process;
-- The GO signals counts 65535 times a period of the 9600Hz, which is 6.8 seconds
  GO <=  '1' when GO_COUNT = "1111111111111111"  else '0' ;              

  -- ENA_SER_DATA_COUNT	starts at GO and stops at end of initialitiation of GPS reciever                        
  process (CLK_9600, SYSRST, RST_CNT) 
  begin
	if SYSRST = '1' or RST_CNT = '1' then
	  ENA_SER_DATA_COUNT <= '0';	
	elsif CLK_9600'event and CLK_9600 = '1' then
	  if GO = '1' and GO_DEL = '0' then     
		ENA_SER_DATA_COUNT <= '1';  
	  end if;
    end if;
  end process;   

-- SER_DATA_COUNT counts the number of bits send to the GPS reciever
  process (CLK_9600) 
  begin
	if CLK_9600'event and CLK_9600 = '1'then
	  if ENA_SER_DATA_COUNT = '1' then
    	SER_DATA_COUNT <= SER_DATA_COUNT + 1;
      else
    	SER_DATA_COUNT <= 0; 
      end if; 
    end if;
  end process;

-- Serializer                                    
  process (SER_DATA_COUNT, STARTBIT, STOPBIT, SERWORD0, SERWORD1, SERWORD2, SERWORD3, SERWORD4, SERWORD5, SERWORD6, SERWORD7)
  begin
   	case SER_DATA_COUNT is
   	  when 1 => TXD <= STARTBIT;    
      when 2 => TXD <= SERWORD0 (0);  
      when 3 => TXD <= SERWORD0 (1); 
      when 4 => TXD <= SERWORD0 (2);  
      when 5 => TXD <= SERWORD0 (3);  
      when 6 => TXD <= SERWORD0 (4);  
      when 7 => TXD <= SERWORD0 (5);  
      when 8 => TXD <= SERWORD0 (6);  
      when 9 => TXD <= SERWORD0 (7);
      when 10 => TXD <= STOPBIT;
      when 11 => TXD <= STARTBIT;   
      when 12 => TXD <= SERWORD1 (0);  
      when 13 => TXD <= SERWORD1 (1); 
      when 14 => TXD <= SERWORD1 (2);  
      when 15 => TXD <= SERWORD1 (3);  
      when 16 => TXD <= SERWORD1 (4);  
      when 17 => TXD <= SERWORD1 (5);  
      when 18 => TXD <= SERWORD1 (6);  
      when 19 => TXD <= SERWORD1 (7);
      when 20 => TXD <= STOPBIT;
      when 21 => TXD <= STARTBIT;   
      when 22 => TXD <= SERWORD2 (0);  
      when 23 => TXD <= SERWORD2 (1); 
      when 24 => TXD <= SERWORD2 (2);  
      when 25 => TXD <= SERWORD2 (3);  
      when 26 => TXD <= SERWORD2 (4);  
      when 27 => TXD <= SERWORD2 (5);  
      when 28 => TXD <= SERWORD2 (6);  
      when 29 => TXD <= SERWORD2 (7);
      when 30 => TXD <= STOPBIT;
      when 31 => TXD <= STARTBIT;    
      when 32 => TXD <= SERWORD3 (0);  
      when 33 => TXD <= SERWORD3 (1); 
      when 34 => TXD <= SERWORD3 (2);  
      when 35 => TXD <= SERWORD3 (3);  
      when 36 => TXD <= SERWORD3 (4);  
      when 37 => TXD <= SERWORD3 (5);  
      when 38 => TXD <= SERWORD3 (6);  
      when 39 => TXD <= SERWORD3 (7);
      when 40 => TXD <= STOPBIT;
      when 41 => TXD <= STARTBIT;    
      when 42 => TXD <= SERWORD4 (0); 
      when 43 => TXD <= SERWORD4 (1); 
      when 44 => TXD <= SERWORD4 (2);  
      when 45 => TXD <= SERWORD4 (3);  
      when 46 => TXD <= SERWORD4 (4);  
      when 47 => TXD <= SERWORD4 (5);  
      when 48 => TXD <= SERWORD4 (6);  
      when 49 => TXD <= SERWORD4 (7);
      when 50 => TXD <= STOPBIT;  
      when 51 => TXD <= STARTBIT; 
   	  when 52 => TXD <= SERWORD5 (0);    
      when 53 => TXD <= SERWORD5 (1); 
      when 54 => TXD <= SERWORD5 (2);  
      when 55 => TXD <= SERWORD5 (3);  
      when 56 => TXD <= SERWORD5 (4);  
      when 57 => TXD <= SERWORD5 (5);  
      when 58 => TXD <= SERWORD5 (6);  
      when 59 => TXD <= SERWORD5 (7);
      when 60 => TXD <= STOPBIT;  
      when 61 => TXD <= STARTBIT;  
      when 62 => TXD <= SERWORD6 (0); 
      when 63 => TXD <= SERWORD6 (1); 
      when 64 => TXD <= SERWORD6 (2);  
      when 65 => TXD <= SERWORD6 (3);  
      when 66 => TXD <= SERWORD6 (4);  
      when 67 => TXD <= SERWORD6 (5);  
      when 68 => TXD <= SERWORD6 (6);  
      when 69 => TXD <= SERWORD6 (7);
      when 70 => TXD <= STOPBIT;  
      when 71 => TXD <= STARTBIT;    
      when 72 => TXD <= SERWORD7 (0);    
      when 73 => TXD <= SERWORD7 (1); 
      when 74 => TXD <= SERWORD7 (2);  
      when 75 => TXD <= SERWORD7 (3);  
      when 76 => TXD <= SERWORD7 (4);  
      when 77 => TXD <= SERWORD7 (5);  
      when 78 => TXD <= SERWORD7 (6);  
      when 79 => TXD <= SERWORD7 (7);
      when 80 => TXD <= STOPBIT;  
      when others => TXD <=  '1';      
    end case;
   end process;
    
   RST_CNT <= '1' when DATA_COUNT = 81 else '0';

------------------ End Initialisation GPS reciever -----------------------------------------

------------------ Start Recieving GPS data -----------------------------------------

 -- Sample counter
  process(CLK_153600, SYSRST)                               
  begin
 	if SYSRST = '1' then
  	  SAMPLE_COUNT <= 0;
  	elsif CLK_153600'event and CLK_153600 = '1' then
  	  if SAMPLE_COUNT = 0 and RXD = '1' then
   		SAMPLE_COUNT <= 0 ; -- wait for start 
      elsif COUNT = 8 and RXD = '1' then
   		SAMPLE_COUNT <= 0 ; -- false start
   	  elsif COUNT = 152 then 
   		SAMPLE_COUNT <= 0; -- end
      else
   		SAMPLE_COUNT <= SAMPLE_COUNT + 1;
   	  end if;
 	end if; 
  end process;

 -- TIME_OUT counter
 -- This counter counts if there is no input data (RXD = '1') till 10 bytes (1600 counts)
 -- After this, the counter latches itself till a startbit  (RXD = '0')
  process(CLK_153600, SYSRST) 
  begin
 	if SYSRST = '1' then
  	  TIME_OUT_COUNT <= 0;
  	elsif CLK_153600'event and CLK_153600 = '1' then
  	  if RXD = '0' then
  		TIME_OUT_COUNT <= 0; 
  	  elsif TIME_OUT_COUNT = 1600 then
  		TIME_OUT_COUNT <= TIME_OUT_COUNT;
  	  else
   		TIME_OUT_COUNT <= TIME_OUT_COUNT + 1;
      end if;
 	end if; 
  end process; 

  TIME_OUT <= '1' when TIME_OUT_COUNT = 1600 else '0'; 

-- Word counter
-- This counter counts the number of words (bytes) in the serial data stream
  process(CLK_153600, SYSRST) 
  begin
	if SYSRST = '1'then
	  WORD_COUNT <= 0;
 	  elsif CLK_153600'event and CLK_153600 = '1' then
  	    if TIME_OUT = '1' then
  	  	  WORD_COUNT <= 0;
  		elsif COUNT = 9 then
   		  WORD_COUNT <= WORD_COUNT + 1;
   		else 
   		  WORD_COUNT <= WORD_COUNT;
      	end if;
 	  end if; 
  end process;

	-- Paralizer		
  PAR_WORD(0) <= RXD when SAMPLE_COUNT = 24  else PAR_WORD(0);
  PAR_WORD(1) <= RXD when SAMPLE_COUNT = 40  else PAR_WORD(1);
  PAR_WORD(2) <= RXD when SAMPLE_COUNT = 56  else PAR_WORD(2);
  PAR_WORD(3) <= RXD when SAMPLE_COUNT = 72  else PAR_WORD(3);
  PAR_WORD(4) <= RXD when SAMPLE_COUNT = 88  else PAR_WORD(4);
  PAR_WORD(5) <= RXD when SAMPLE_COUNT = 104 else PAR_WORD(5);
  PAR_WORD(6) <= RXD when SAMPLE_COUNT = 120 else PAR_WORD(6);
  PAR_WORD(7) <= RXD when SAMPLE_COUNT = 136 else PAR_WORD(7);

  GPS_WORD4 <= PAR_WORD when SAMPLE_COUNT = 144 and WORD_COUNT = 5 else GPS_WORD4;    
  GPS_WORD5 <= PAR_WORD when SAMPLE_COUNT = 144 and WORD_COUNT = 6 else GPS_WORD5;  
  GPS_WORD6 <= PAR_WORD when SAMPLE_COUNT = 144 and WORD_COUNT = 7 else GPS_WORD6;  
  GPS_WORD7 <= PAR_WORD when SAMPLE_COUNT = 144 and WORD_COUNT = 8 else GPS_WORD7; 
  GPS_WORD8 <= PAR_WORD when SAMPLE_COUNT = 144 and WORD_COUNT = 9 else GPS_WORD8;           
  GPS_WORD9 <= PAR_WORD when SAMPLE_COUNT = 144 and WORD_COUNT = 10 else GPS_WORD9; 
  GPS_WORD10<= PAR_WORD when SAMPLE_COUNT = 144 and WORD_COUNT = 11 else GPS_WORD10; 
  GPS_WORD15<= PAR_WORD when SAMPLE_COUNT = 144 and WORD_COUNT = 16 else GPS_WORD15; 
  GPS_WORD16<= PAR_WORD when SAMPLE_COUNT = 144 and WORD_COUNT = 17 else GPS_WORD16; 
  GPS_WORD17<= PAR_WORD when SAMPLE_COUNT = 144 and WORD_COUNT = 18 else GPS_WORD17; 
  GPS_WORD18<= PAR_WORD when SAMPLE_COUNT = 144 and WORD_COUNT = 19 else GPS_WORD18; 
  GPS_WORD19<= PAR_WORD when SAMPLE_COUNT = 144 and WORD_COUNT = 20 else GPS_WORD19; 
  GPS_WORD20<= PAR_WORD when SAMPLE_COUNT = 144 and WORD_COUNT = 21 else GPS_WORD20; 
  GPS_WORD21<= PAR_WORD when SAMPLE_COUNT = 144 and WORD_COUNT = 22 else GPS_WORD21; 
  GPS_WORD22<= PAR_WORD when SAMPLE_COUNT = 144 and WORD_COUNT = 23 else GPS_WORD22;

------------------ Start Recieving GPS data -----------------------------------------

  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      COINC_DEL <= '0';        
      ONE_PPS_DEL1 <= '0';        
      ONE_PPS_DEL2 <= '0';        
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      COINC_DEL <= COINC;        
      ONE_PPS_DEL1 <= ONE_PPS;        
      ONE_PPS_DEL2 <= ONE_PPS_DEL1;        
    end if;
  end process;  


  -- Latch GPS_TIME on positive edge of COINC
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      GPS_TS_OUT <= "00000000000000000000000000000000000000000000000000000000";
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if COINC = '1' and COINC_DEL = '0' then
        GPS_TS_OUT <= GPS_TIME;
	  end if;        
    end if;
  end process;  

  -- Latch GPS_TIME on positive edge of ONE_PPS
  process(CLK200MHz,SYSRST)
  begin
    if SYSRST = '1' then
      GPS_TS_ONE_PPS_OUT <= "00000000000000000000000000000000000000000000000000000000";
    elsif (CLK200MHz'event and CLK200MHz = '1') then
      if ONE_PPS_DEL1 = '1' and ONE_PPS_DEL2 = '0' then
        GPS_TS_ONE_PPS_OUT <= GPS_TIME;
      end if;
    end if;
  end process;  

end architecture rtl ; -- of GPS_TIMESTAMP
