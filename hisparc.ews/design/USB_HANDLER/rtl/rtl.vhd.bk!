-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'USB_HANDLER.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'USB_HANDLER' :
-- 
--   port(
--     CLKRD        : in     std_logic;
--     DATA_IN      : in     std_logic_vector(7 downto 0);
--     DATA_READY   : in     std_logic;
--     DIN_VALID    : in     std_logic;
--     RDEN         : out    std_logic;
--     READOUT_BUSY : out    std_logic;
--     SYSRST       : in     std_logic;
--     USB_DATA     : out    std_logic_vector(7 downto 0);
--     USB_TXE      : in     std_logic;
--     USB_WR       : out    std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture rtl of USB_HANDLER is

signal RDEN_TMP: std_logic ;
signal VALID_BUF1: std_logic ;
signal VALID_BUF1_DEL1: std_logic ;
signal VALID_BUF1_DEL2: std_logic ;
signal VALID_BUF2: std_logic ;
signal RST_VALID_BUF1: std_logic ;
signal RST_VALID_BUF2: std_logic ;
signal DATA_BUF1: std_logic_vector(7 downto 0) ;
signal DATA_BUF2: std_logic_vector(7 downto 0) ;
signal USB_DATA_TMP: std_logic_vector(7 downto 0) ;
signal WR_TMP: std_logic ;

begin
  
  USB_WR <= WR_TMP;
  RDEN <= RDEN_TMP;
  USB_DATA <= USB_DATA_TMP;
  READOUT_BUSY <= DATA_READY or VALID_BUF1;
  
  process(CLKRD,SYSRST)
  begin
  	if SYSRST = '1' then
  	  VALID_BUF1_DEL1 <= '0';
  	  VALID_BUF1_DEL2 <= '0';
    elsif (CLKRD'event and CLKRD = '0') then 
  	  if RST_VALID_BUF1 = '1' then
  	    VALID_BUF1_DEL1 <= '0';
  	    VALID_BUF1_DEL2 <= '0';
  	  else
        VALID_BUF1_DEL1 <= VALID_BUF1;
        VALID_BUF1_DEL2 <= VALID_BUF1_DEL1;
      end if;
    end if;
  end process;

  process(CLKRD,SYSRST)
  begin
  	if SYSRST = '1' then
  	  RDEN_TMP <= '0';
    elsif (CLKRD'event and CLKRD = '0') then -- RDEN changes on a negative clock edge
  	  if DATA_READY = '1' then
	    if VALID_BUF1 = '0' then
          RDEN_TMP <= not RDEN_TMP;
        else
          RDEN_TMP <= '0';
        end if;
      else
        RDEN_TMP <= '0';
      end if;
    end if;
  end process;

  process(CLKRD,SYSRST)
  begin
  	if SYSRST = '1' then
  	  WR_TMP <= '0';
    elsif (CLKRD'event and CLKRD = '1') then 
  	  if VALID_BUF1_DEL2 = '1' or VALID_BUF2 = '1' then
   	    if USB_TXE = '0' then
          WR_TMP <= not WR_TMP;
        else  
          WR_TMP <= '0';
		end if;
	  else 
        WR_TMP <= '0';
      end if;
    end if;
  end process;

  process(CLKRD,SYSRST)
  begin
  	if SYSRST = '1' then
  	  DATA_BUF1 <= "00000000";
  	  DATA_BUF2 <= "00000000";
  	  VALID_BUF1 <= '0';
  	  VALID_BUF2 <= '0';
    elsif (CLKRD'event and CLKRD = '0') then 
  	  if RST_VALID_BUF1 = '1' then
  	    VALID_BUF1 <= '0';
  	  elsif DIN_VALID = '1' then
  	    DATA_BUF1 <= DATA_IN;
  	    VALID_BUF1 <= DIN_VALID;
      end if;
  	  if RST_VALID_BUF2 = '1' then
  	    VALID_BUF2 <= '0';
      elsif DIN_VALID = '1' and VALID_BUF1 = '1' then
  	    VALID_BUF2 <= VALID_BUF1;
  	    DATA_BUF2 <= DATA_BUF1;
      end if;
    end if;
  end process;

  process(CLKRD,SYSRST)
  begin
  	if SYSRST = '1' then
  	  RST_VALID_BUF1 <= '0';
  	  RST_VALID_BUF2 <= '0';
    elsif (CLKRD'event and CLKRD = '0') then 
  	  if WR_TMP = '1' then 
        if VALID_BUF2  = '1' then
          RST_VALID_BUF2 <= '1';
        elsif VALID_BUF1_DEL2  = '1' then
          RST_VALID_BUF1 <= '1';
        end if;
      else
  	    RST_VALID_BUF1 <= '0';
  	    RST_VALID_BUF2 <= '0';
      end if;
    end if;
  end process;
          
  process(CLKRD,SYSRST)
  begin
  	if SYSRST = '1' then
  	  USB_DATA_TMP <= "00000000";
    elsif (CLKRD'event and CLKRD = '1') then 
      if VALID_BUF2 = '1' then
        USB_DATA_TMP <= DATA_BUF2;
      elsif VALID_BUF1 = '1' then
        USB_DATA_TMP <= DATA_BUF1;
      else
        USB_DATA_TMP <= USB_DATA_TMP;        
      end if;
    end if;
  end process;


end rtl ; -- of USB_HANDLER

