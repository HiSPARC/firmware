-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'READOUT_TIMED_OUT.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'READOUT_TIMED_OUT' :
-- 
--   port(
--     CLK10MHz          : in     std_logic;
--     ONE_PPS           : in     std_logic;
--     TIME_OUT_RESET    : out    std_logic;
--     USB_TXE           : in     std_logic;
--     USB_WRITE_REQUEST : in     std_logic;
--     nSYSRST           : in     std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of READOUT_TIMED_OUT is

signal TIME_OUT_COUNT: std_logic_vector(3 downto 0); 
signal USB_TXE_DEL1: std_logic ; 
signal USB_TXE_DEL2: std_logic ; 
signal ONE_PPS_DEL1: std_logic ; 
signal ONE_PPS_DEL2: std_logic ; 


begin

  TIME_OUT_RESET <= TIME_OUT_COUNT(3);

  process(CLK10MHz,nSYSRST)
  begin
  	if nSYSRST = '0' then
  	  USB_TXE_DEL1 <= '0';
  	  USB_TXE_DEL2 <= '0';
  	  ONE_PPS_DEL1 <= '0';
  	  ONE_PPS_DEL2 <= '0';
    elsif (CLK10MHz'event and CLK10MHz = '1') then 
  	  USB_TXE_DEL1 <= USB_TXE;
  	  USB_TXE_DEL2 <= USB_TXE_DEL1;
  	  ONE_PPS_DEL1 <= ONE_PPS;
  	  ONE_PPS_DEL2 <= ONE_PPS_DEL1;
    end if;
  end process;

  process(CLK10MHz,nSYSRST)
  begin
  	if nSYSRST = '0' then
  	  TIME_OUT_COUNT <= "0000";
    elsif (CLK10MHz'event and CLK10MHz = '1') then 
      if USB_TXE_DEL1 = '0' and USB_TXE_DEL2 = '1' then -- at falling edge of TXE
  	    TIME_OUT_COUNT <= "0000"; -- reset counter
      elsif TIME_OUT_COUNT = "1000" then -- after 8 seconds no TXE
  	    TIME_OUT_COUNT <= TIME_OUT_COUNT; -- latch countvalue 8  
  	  elsif USB_WRITE_REQUEST = '1' then 
        if ONE_PPS_DEL1 = '1' and ONE_PPS_DEL2 = '0' then -- at rising edge of PPS
  	      TIME_OUT_COUNT <= TIME_OUT_COUNT + "0001"; -- increase counter    	   
        end if;
      end if;
    end if;
  end process;

end rtl ; -- of READOUT_TIMED_OUT

