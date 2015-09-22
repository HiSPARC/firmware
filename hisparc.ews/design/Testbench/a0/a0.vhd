-- EASE/HDL begin --------------------------------------------------------------
-- 
-- Architecture 'a0' of entity 'Testbench'.
-- 
--------------------------------------------------------------------------------
-- 
-- Copy of the interface declaration:
-- 
--   port(
--     ADC_A0           : in     std_logic;
--     ADC_DATA         : out    std_logic_vector(7 downto 0);
--     CLK200MHz        : out    std_logic;
--     CLK40MHz         : out    std_logic;
--     COMPH1           : out    std_logic;
--     COMPH2           : out    std_logic;
--     COMPL1           : out    std_logic;
--     COMPL2           : out    std_logic;
--     DATA_NEG_ADC_CH1 : out    std_logic_vector(11 downto 0);
--     DATA_NEG_ADC_CH2 : out    std_logic_vector(11 downto 0);
--     DATA_POS_ADC_CH1 : out    std_logic_vector(11 downto 0);
--     DATA_POS_ADC_CH2 : out    std_logic_vector(11 downto 0);
--     DCO_NEG_ADC_CH1  : out    std_logic;
--     DCO_NEG_ADC_CH2  : out    std_logic;
--     DCO_POS_ADC_CH1  : out    std_logic;
--     DCO_POS_ADC_CH2  : out    std_logic;
--     EXT_TR_IN_n      : out    std_logic;
--     GPS_SDI          : in     std_logic;
--     GPS_SDO          : out    std_logic;
--     INTF1_IO         : out    std_logic_vector(2 downto 0);
--     INTF2_IO         : out    std_logic_vector(7 downto 0);
--     ONE_PPS          : out    std_logic;
--     SERIAL_NUMBER    : out    std_logic_vector(9 downto 0);
--     SH1              : out    std_logic;
--     SH2              : out    std_logic;
--     SL1              : out    std_logic;
--     SL2              : out    std_logic;
--     SPY_CON          : out    std_logic;
--     SPY_SDI          : in     std_logic;
--     SPY_SDO          : out    std_logic;
--     USB_DATA_IN      : inout  std_logic_vector(7 downto 0);
--     USB_DATA_OUT     : out    std_logic_vector(7 downto 0);
--     USB_RD           : in     std_logic;
--     USB_RXF          : out    std_logic;
--     USB_TXE          : out    std_logic;
--     USB_WR           : in     std_logic;
--     nSYSRST          : out    std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

architecture a0 of Testbench is

signal CLK200MHz_TMP: std_logic ;
signal CLK40MHz_TMP: std_logic ;
signal CLK10MHz_TMP: std_logic ;
signal SYSRST_TMP: std_logic ;
signal DCO_POS_ADC: std_logic ;
signal DCO_NEG_ADC: std_logic ;
signal DATA_POS_ADC_TMP: std_logic_vector(11 downto 0);
signal DATA_NEG_ADC_TMP: std_logic_vector(11 downto 0);
signal TXE_CNT: std_logic_vector(4 downto 0);
signal TXE_TMP: std_logic ;
signal RXF_TMP: std_logic ;
signal USB_MEMORY_CNT: integer range 100000 downto 0 ; -- USB Memory Counter
signal USB_READ_CNT: integer range 40 downto 0 ;
signal WRITE_PARAMETER_LIST_HOLD: std_logic ;
signal USB_READ_DAC_CNT: integer range 20 downto 0 ;
signal WRITE_VIA_USB_DAC: std_logic ;
signal WRITE_CLOCK_ADJ: std_logic ;
signal USB_WRITE_CLOCK_ADJ_CNT: integer range 5 downto 0 ;
signal RS232_CLOCK: std_logic ;
signal RS232_CNT: integer range 275 downto 0 ;
signal STARTBIT: std_logic ;
signal STOPBIT: std_logic ;
signal FIRSTBYTE: std_logic_vector(7 downto 0);
signal SECONDBYTE: std_logic_vector(7 downto 0);
signal THIRDBYTE: std_logic_vector(7 downto 0);
signal FOURTHBYTE: std_logic_vector(7 downto 0);

begin

  nSYSRST <= not SYSRST_TMP;
  CLK200MHz <= CLK200MHz_TMP;
  CLK40MHz <= CLK40MHz_TMP;
  DATA_POS_ADC_CH1 <= DATA_POS_ADC_TMP after 1.7 ns;
  DATA_NEG_ADC_CH1 <= DATA_NEG_ADC_TMP after 1.7 ns;
  DATA_POS_ADC_CH2 <= (DATA_POS_ADC_TMP + "000001000000") after 1.7 ns;
  DATA_NEG_ADC_CH2 <= (DATA_NEG_ADC_TMP + "000001000000") after 1.7 ns;
  DCO_POS_ADC <= not CLK200MHz_TMP after 1.2 ns;
  DCO_NEG_ADC <= CLK200MHz_TMP after 1.2 ns;
  DCO_POS_ADC_CH1 <= DCO_POS_ADC;
  DCO_POS_ADC_CH2 <= DCO_POS_ADC;
  DCO_NEG_ADC_CH1 <= DCO_NEG_ADC;
  DCO_NEG_ADC_CH2 <= DCO_NEG_ADC;
  COMPL1 <= '1';
  COMPH1 <= '0';
  COMPL2 <= '1';
  COMPH2 <= '0';

  ADC_DATA <= "01011001" when ADC_A0 = '0' else "10101001"; -- 59h else A8h <== binair staat er A9(hex), niet A8(hex)
  SERIAL_NUMBER <= "0000000011";

  USB_TXE <= TXE_TMP;
  USB_RXF <= RXF_TMP;

  SYSRST_TMP <= '1', '0' after 16 ns;

  ONE_PPS <= '0', '1' after 300 us, '0' after 500 us, '1' after 30 ms;

  SL1 <= '1';
  SL2 <= '1';
  SH1 <= '1';
  SH2 <= '1';
  EXT_TR_IN_n <= '1', '0' after 200 us, '1' after 201 us;

  SPY_CON <= '0';
  SPY_SDO <= '0';

  WRITE_PARAMETER_LIST_HOLD <= '1','0' after 800 us;
  WRITE_VIA_USB_DAC <= '1','0' after 1500 us;
  WRITE_CLOCK_ADJ <= '1','0' after 15 ms;

--  READ_ERROR <= '0','1' after 1200 us;

  process
  begin
    CLK10MHz_TMP <= '0','1' after 50 ns;
    wait for 100 ns;
  end process;

  process
  begin
    CLK40MHz_TMP <= '0','1' after 12.5 ns;
    wait for 25 ns;
  end process;

  process
  begin
    CLK200MHz_TMP <= '0','1' after 2.5 ns;
    wait for 5 ns;
  end process;

  process(CLK200MHz_TMP,SYSRST_TMP)
  begin
    if SYSRST_TMP = '1' then
      DATA_POS_ADC_TMP <= "000000000000";
    elsif (CLK200MHz_TMP'event and CLK200MHz_TMP = '1') then
      DATA_POS_ADC_TMP <= DATA_POS_ADC_TMP + "000000000010";
    end if;
  end process;

  process(CLK200MHz_TMP,SYSRST_TMP)
  begin
    if SYSRST_TMP = '1' then
      DATA_NEG_ADC_TMP <= "000000000001";
    elsif (CLK200MHz_TMP'event and CLK200MHz_TMP = '0') then
      DATA_NEG_ADC_TMP <= DATA_NEG_ADC_TMP + "000000000010";
    end if;
  end process;

  process(USB_WR,SYSRST_TMP)
  begin
    if SYSRST_TMP = '1' then
      TXE_TMP <= '0';
      TXE_CNT <= "00000";
    elsif (USB_WR'event and USB_WR = '0') then -- let op: USB_WR gaat op een negatieve flank
      if TXE_TMP = '0' then
        USB_DATA_OUT <= USB_DATA_IN;
      end if;
      if TXE_CNT /= "11110" then
        TXE_TMP <= '0','1' after 25 ns,'0' after 105 ns;
      else
        TXE_TMP <= '0','1' after 25 ns,'0' after 3025 ns;
      end if;
      TXE_CNT <= TXE_CNT + "00001";
    end if;
  end process;

  process(USB_READ_CNT,WRITE_PARAMETER_LIST_HOLD,USB_READ_DAC_CNT,WRITE_VIA_USB_DAC,WRITE_CLOCK_ADJ,USB_WRITE_CLOCK_ADJ_CNT)
  begin
    if (WRITE_PARAMETER_LIST_HOLD = '0' and USB_READ_CNT < 3) or (WRITE_VIA_USB_DAC = '0' and USB_READ_DAC_CNT < 4) or (WRITE_CLOCK_ADJ = '0' and USB_WRITE_CLOCK_ADJ_CNT < 5)then
      RXF_TMP <= '0';
    else
      RXF_TMP <= '1';
    end if;
  end process;

  process(USB_RD,SYSRST_TMP,WRITE_PARAMETER_LIST_HOLD)
  begin
    if SYSRST_TMP = '1' then
      USB_READ_CNT <= 0;
    elsif (USB_RD'event and USB_RD = '1') and WRITE_PARAMETER_LIST_HOLD = '0' then
      USB_READ_CNT <= USB_READ_CNT + 1;
    end if;
  end process;

  process(USB_READ_CNT,USB_RD)
  begin
    if USB_RD = '1' then
      USB_DATA_IN <= "ZZZZZZZZ";
    elsif WRITE_PARAMETER_LIST_HOLD = '0' then
      case (USB_READ_CNT) is
      when 0 => USB_DATA_IN <= "10011001";
      when 1 => USB_DATA_IN <= "01010101";
      when 2 => USB_DATA_IN <= "01100110";
      when others => USB_DATA_IN <= "ZZZZZZZZ";
      end case;
    end if;
  end process;

  process(USB_RD,SYSRST_TMP,WRITE_VIA_USB_DAC)
  begin
    if SYSRST_TMP = '1' then
      USB_READ_DAC_CNT <= 0;
    elsif (USB_RD'event and USB_RD = '1') and WRITE_VIA_USB_DAC = '0' then
      USB_READ_DAC_CNT <= USB_READ_DAC_CNT + 1;
    end if;
  end process;

  process(USB_READ_DAC_CNT,USB_RD)
  begin
    if USB_RD = '1' then
      USB_DATA_IN <= "ZZZZZZZZ";
    elsif WRITE_VIA_USB_DAC = '0' then
      case (USB_READ_DAC_CNT) is
      when 0 => USB_DATA_IN <= "10011001";
      when 1 => USB_DATA_IN <= "00010000";
      when 2 => USB_DATA_IN <= "10010101";
      when 3 => USB_DATA_IN <= "01100110";
      when others => USB_DATA_IN <= "ZZZZZZZZ";
      end case;
    end if;
  end process;

  process(USB_RD,SYSRST_TMP,WRITE_CLOCK_ADJ)
  begin
    if SYSRST_TMP = '1' then
      USB_WRITE_CLOCK_ADJ_CNT <= 0;
    elsif (USB_RD'event and USB_RD = '1') and WRITE_CLOCK_ADJ = '0' then
      USB_WRITE_CLOCK_ADJ_CNT <= USB_WRITE_CLOCK_ADJ_CNT + 1;
    end if;
  end process;

  process(USB_WRITE_CLOCK_ADJ_CNT,USB_RD)
  begin
    if USB_RD = '1' then
      USB_DATA_IN <= "ZZZZZZZZ";
    elsif WRITE_CLOCK_ADJ = '0' then
      case (USB_WRITE_CLOCK_ADJ_CNT) is
      when 0 => USB_DATA_IN <= "10011001";
      when 1 => USB_DATA_IN <= "00110101";
      when 2 => USB_DATA_IN <= "00000000";
      when 3 => USB_DATA_IN <= "11001001";
      when 4 => USB_DATA_IN <= "01100110";
      when others => USB_DATA_IN <= "ZZZZZZZZ";
      end case;
    end if;
  end process;


  process(USB_WR,SYSRST_TMP)
  begin
    if SYSRST_TMP = '1' then
      USB_MEMORY_CNT <= 0;
    elsif (USB_WR'event and USB_WR = '1') then
      USB_MEMORY_CNT <= USB_MEMORY_CNT + 1;
    end if;
  end process;

  process
  begin
    RS232_CLOCK <= '0','1' after 52083 ns;
    wait for 104170 ns;
  end process;

  process(RS232_CLOCK,SYSRST_TMP)
  begin
    if SYSRST_TMP = '1' then
      RS232_CNT <= 0;
    elsif (RS232_CLOCK'event and RS232_CLOCK = '1') then
      if RS232_CNT = 275 then
        RS232_CNT <= RS232_CNT;
      else
        RS232_CNT <= RS232_CNT + 1;
      end if;
    end if;
  end process;

  STARTBIT <= '0';
  STOPBIT <= '1';
  FIRSTBYTE <= "00010010"; -- Data = 12h
  SECONDBYTE <= "00110100"; -- Data = 34h
  THIRDBYTE <= "01010110"; -- Data = 56h
  FOURTHBYTE <= "01111000"; -- Data = 78h

  process(RS232_CNT,STARTBIT,STOPBIT,FIRSTBYTE,SECONDBYTE,THIRDBYTE,FOURTHBYTE)
  begin
    case (RS232_CNT) is
      when 0 => GPS_SDO <= '1';
      when 1 => GPS_SDO <= '1';
      when 2 => GPS_SDO <= '1';
      when 3 => GPS_SDO <= '1';
      when 4 => GPS_SDO <= '1';
      when 5 => GPS_SDO <= '1';
      when 6 => GPS_SDO <= STARTBIT; -- Byte 1 (Header)
      when 7 => GPS_SDO <= FIRSTBYTE(0);
      when 8 => GPS_SDO <= FIRSTBYTE(1);
      when 9 => GPS_SDO <= FIRSTBYTE(2);
      when 10 => GPS_SDO <= FIRSTBYTE(3);
      when 11 => GPS_SDO <= FIRSTBYTE(4);
      when 12 => GPS_SDO <= FIRSTBYTE(5);
      when 13 => GPS_SDO <= FIRSTBYTE(6);
      when 14 => GPS_SDO <= FIRSTBYTE(7);
      when 15 => GPS_SDO <= STOPBIT;
      when 16 => GPS_SDO <= STARTBIT; -- Byte 2 (Header)
      when 17 => GPS_SDO <= SECONDBYTE(0);
      when 18 => GPS_SDO <= SECONDBYTE(1);
      when 19 => GPS_SDO <= SECONDBYTE(2);
      when 20 => GPS_SDO <= SECONDBYTE(3);
      when 21 => GPS_SDO <= SECONDBYTE(4);
      when 22 => GPS_SDO <= SECONDBYTE(5);
      when 23 => GPS_SDO <= SECONDBYTE(6);
      when 24 => GPS_SDO <= SECONDBYTE(7);
      when 25 => GPS_SDO <= STOPBIT;
      when 26 => GPS_SDO <= STARTBIT; -- Byte 3 (Header)
      when 27 => GPS_SDO <= THIRDBYTE(0);
      when 28 => GPS_SDO <= THIRDBYTE(1);
      when 29 => GPS_SDO <= THIRDBYTE(2);
      when 30 => GPS_SDO <= THIRDBYTE(3);
      when 31 => GPS_SDO <= THIRDBYTE(4);
      when 32 => GPS_SDO <= THIRDBYTE(5);
      when 33 => GPS_SDO <= THIRDBYTE(6);
      when 34 => GPS_SDO <= THIRDBYTE(7);
      when 35 => GPS_SDO <= STOPBIT;
      when 36 => GPS_SDO <= STARTBIT; -- Byte 4 (Header)
      when 37 => GPS_SDO <= FOURTHBYTE(0);
      when 38 => GPS_SDO <= FOURTHBYTE(1);
      when 39 => GPS_SDO <= FOURTHBYTE(2);
      when 40 => GPS_SDO <= FOURTHBYTE(3);
      when 41 => GPS_SDO <= FOURTHBYTE(4);
      when 42 => GPS_SDO <= FOURTHBYTE(5);
      when 43 => GPS_SDO <= FOURTHBYTE(6);
      when 44 => GPS_SDO <= FOURTHBYTE(7);
      when 45 => GPS_SDO <= STOPBIT;
      when 46 => GPS_SDO <= STARTBIT; -- Byte 5 (Month)
      when 47 => GPS_SDO <= FIRSTBYTE(0);
      when 48 => GPS_SDO <= FIRSTBYTE(1);
      when 49 => GPS_SDO <= FIRSTBYTE(2);
      when 50 => GPS_SDO <= FIRSTBYTE(3);
      when 51 => GPS_SDO <= FIRSTBYTE(4);
      when 52 => GPS_SDO <= FIRSTBYTE(5);
      when 53 => GPS_SDO <= FIRSTBYTE(6);
      when 54 => GPS_SDO <= FIRSTBYTE(7);
      when 55 => GPS_SDO <= STOPBIT;
      when 56 => GPS_SDO <= STARTBIT; -- Byte 6 (Day)
      when 57 => GPS_SDO <= SECONDBYTE(0);
      when 58 => GPS_SDO <= SECONDBYTE(1);
      when 59 => GPS_SDO <= SECONDBYTE(2);
      when 60 => GPS_SDO <= SECONDBYTE(3);
      when 61 => GPS_SDO <= SECONDBYTE(4);
      when 62 => GPS_SDO <= SECONDBYTE(5);
      when 63 => GPS_SDO <= SECONDBYTE(6);
      when 64 => GPS_SDO <= SECONDBYTE(7);
      when 65 => GPS_SDO <= STOPBIT;
      when 66 => GPS_SDO <= STARTBIT; -- Byte 7 (Year)
      when 67 => GPS_SDO <= THIRDBYTE(0);
      when 68 => GPS_SDO <= THIRDBYTE(1);
      when 69 => GPS_SDO <= THIRDBYTE(2);
      when 70 => GPS_SDO <= THIRDBYTE(3);
      when 71 => GPS_SDO <= THIRDBYTE(4);
      when 72 => GPS_SDO <= THIRDBYTE(5);
      when 73 => GPS_SDO <= THIRDBYTE(6);
      when 74 => GPS_SDO <= THIRDBYTE(7);
      when 75 => GPS_SDO <= STOPBIT;
      when 76 => GPS_SDO <= STARTBIT; -- Byte 8 (Year)
      when 77 => GPS_SDO <= FOURTHBYTE(0);
      when 78 => GPS_SDO <= FOURTHBYTE(1);
      when 79 => GPS_SDO <= FOURTHBYTE(2);
      when 80 => GPS_SDO <= FOURTHBYTE(3);
      when 81 => GPS_SDO <= FOURTHBYTE(4);
      when 82 => GPS_SDO <= FOURTHBYTE(5);
      when 83 => GPS_SDO <= FOURTHBYTE(6);
      when 84 => GPS_SDO <= FOURTHBYTE(7);
      when 85 => GPS_SDO <= STOPBIT;
      when 86 => GPS_SDO <= STARTBIT; -- Byte 9 (Hours)
      when 87 => GPS_SDO <= FIRSTBYTE(0);
      when 88 => GPS_SDO <= FIRSTBYTE(1);
      when 89 => GPS_SDO <= FIRSTBYTE(2);
      when 90 => GPS_SDO <= FIRSTBYTE(3);
      when 91 => GPS_SDO <= FIRSTBYTE(4);
      when 92 => GPS_SDO <= FIRSTBYTE(5);
      when 93 => GPS_SDO <= FIRSTBYTE(6);
      when 94 => GPS_SDO <= FIRSTBYTE(7);
      when 95 => GPS_SDO <= STOPBIT;
      when 96 => GPS_SDO <= STARTBIT; -- Byte 10 (Minutes)
      when 97 => GPS_SDO <= SECONDBYTE(0);
      when 98 => GPS_SDO <= SECONDBYTE(1);
      when 99 => GPS_SDO <= SECONDBYTE(2);
      when 100 => GPS_SDO <= SECONDBYTE(3);
      when 101 => GPS_SDO <= SECONDBYTE(4);
      when 102 => GPS_SDO <= SECONDBYTE(5);
      when 103 => GPS_SDO <= SECONDBYTE(6);
      when 104 => GPS_SDO <= SECONDBYTE(7);
      when 105 => GPS_SDO <= STOPBIT;
      when 106 => GPS_SDO <= STARTBIT; -- Byte 11 (Seconds)
      when 107 => GPS_SDO <= THIRDBYTE(0);
      when 108 => GPS_SDO <= THIRDBYTE(1);
      when 109 => GPS_SDO <= THIRDBYTE(2);
      when 110 => GPS_SDO <= THIRDBYTE(3);
      when 111 => GPS_SDO <= THIRDBYTE(4);
      when 112 => GPS_SDO <= THIRDBYTE(5);
      when 113 => GPS_SDO <= THIRDBYTE(6);
      when 114 => GPS_SDO <= THIRDBYTE(7);
      when 115 => GPS_SDO <= STOPBIT;
      when 116 => GPS_SDO <= STARTBIT; -- Byte 12 (Fractional second)
      when 117 => GPS_SDO <= FIRSTBYTE(0);
      when 118 => GPS_SDO <= FIRSTBYTE(1);
      when 119 => GPS_SDO <= FIRSTBYTE(2);
      when 120 => GPS_SDO <= FIRSTBYTE(3);
      when 121 => GPS_SDO <= FIRSTBYTE(4);
      when 122 => GPS_SDO <= FIRSTBYTE(5);
      when 123 => GPS_SDO <= FIRSTBYTE(6);
      when 124 => GPS_SDO <= FIRSTBYTE(7);
      when 125 => GPS_SDO <= STOPBIT;
      when 126 => GPS_SDO <= STARTBIT; -- Byte 13 (Fractional second)
      when 127 => GPS_SDO <= SECONDBYTE(0);
      when 128 => GPS_SDO <= SECONDBYTE(1);
      when 129 => GPS_SDO <= SECONDBYTE(2);
      when 130 => GPS_SDO <= SECONDBYTE(3);
      when 131 => GPS_SDO <= SECONDBYTE(4);
      when 132 => GPS_SDO <= SECONDBYTE(5);
      when 133 => GPS_SDO <= SECONDBYTE(6);
      when 134 => GPS_SDO <= SECONDBYTE(7);
      when 135 => GPS_SDO <= STOPBIT;
      when 136 => GPS_SDO <= STARTBIT; -- Byte 14 (Fractional second)
      when 137 => GPS_SDO <= THIRDBYTE(0);
      when 138 => GPS_SDO <= THIRDBYTE(1);
      when 139 => GPS_SDO <= THIRDBYTE(2);
      when 140 => GPS_SDO <= THIRDBYTE(3);
      when 141 => GPS_SDO <= THIRDBYTE(4);
      when 142 => GPS_SDO <= THIRDBYTE(5);
      when 143 => GPS_SDO <= THIRDBYTE(6);
      when 144 => GPS_SDO <= THIRDBYTE(7);
      when 145 => GPS_SDO <= STOPBIT;
      when 146 => GPS_SDO <= STARTBIT; -- Byte 15 (Fractional second)
      when 147 => GPS_SDO <= FOURTHBYTE(0);
      when 148 => GPS_SDO <= FOURTHBYTE(1);
      when 149 => GPS_SDO <= FOURTHBYTE(2);
      when 150 => GPS_SDO <= FOURTHBYTE(3);
      when 151 => GPS_SDO <= FOURTHBYTE(4);
      when 152 => GPS_SDO <= FOURTHBYTE(5);
      when 153 => GPS_SDO <= FOURTHBYTE(6);
      when 154 => GPS_SDO <= FOURTHBYTE(7);
      when 155 => GPS_SDO <= STOPBIT;
      when 156 => GPS_SDO <= STARTBIT; -- Byte 16 (Latitude)
      when 157 => GPS_SDO <= FIRSTBYTE(0);
      when 158 => GPS_SDO <= FIRSTBYTE(1);
      when 159 => GPS_SDO <= FIRSTBYTE(2);
      when 160 => GPS_SDO <= FIRSTBYTE(3);
      when 161 => GPS_SDO <= FIRSTBYTE(4);
      when 162 => GPS_SDO <= FIRSTBYTE(5);
      when 163 => GPS_SDO <= FIRSTBYTE(6);
      when 164 => GPS_SDO <= FIRSTBYTE(7);
      when 165 => GPS_SDO <= STOPBIT;
      when 166 => GPS_SDO <= STARTBIT; -- Byte 17 (Latitude)
      when 167 => GPS_SDO <= SECONDBYTE(0);
      when 168 => GPS_SDO <= SECONDBYTE(1);
      when 169 => GPS_SDO <= SECONDBYTE(2);
      when 170 => GPS_SDO <= SECONDBYTE(3);
      when 171 => GPS_SDO <= SECONDBYTE(4);
      when 172 => GPS_SDO <= SECONDBYTE(5);
      when 173 => GPS_SDO <= SECONDBYTE(6);
      when 174 => GPS_SDO <= SECONDBYTE(7);
      when 175 => GPS_SDO <= STOPBIT;
      when 176 => GPS_SDO <= STARTBIT; -- Byte 18 (Latitude)
      when 177 => GPS_SDO <= THIRDBYTE(0);
      when 178 => GPS_SDO <= THIRDBYTE(1);
      when 179 => GPS_SDO <= THIRDBYTE(2);
      when 180 => GPS_SDO <= THIRDBYTE(3);
      when 181 => GPS_SDO <= THIRDBYTE(4);
      when 182 => GPS_SDO <= THIRDBYTE(5);
      when 183 => GPS_SDO <= THIRDBYTE(6);
      when 184 => GPS_SDO <= THIRDBYTE(7);
      when 185 => GPS_SDO <= STOPBIT;
      when 186 => GPS_SDO <= STARTBIT; -- Byte 19 (Latitude)
      when 187 => GPS_SDO <= FOURTHBYTE(0);
      when 188 => GPS_SDO <= FOURTHBYTE(1);
      when 189 => GPS_SDO <= FOURTHBYTE(2);
      when 190 => GPS_SDO <= FOURTHBYTE(3);
      when 191 => GPS_SDO <= FOURTHBYTE(4);
      when 192 => GPS_SDO <= FOURTHBYTE(5);
      when 193 => GPS_SDO <= FOURTHBYTE(6);
      when 194 => GPS_SDO <= FOURTHBYTE(7);
      when 195 => GPS_SDO <= STOPBIT;
      when 196 => GPS_SDO <= STARTBIT; -- Byte 20 (Longitude)
      when 197 => GPS_SDO <= FIRSTBYTE(0);
      when 198 => GPS_SDO <= FIRSTBYTE(1);
      when 199 => GPS_SDO <= FIRSTBYTE(2);
      when 200 => GPS_SDO <= FIRSTBYTE(3);
      when 201 => GPS_SDO <= FIRSTBYTE(4);
      when 202 => GPS_SDO <= FIRSTBYTE(5);
      when 203 => GPS_SDO <= FIRSTBYTE(6);
      when 204 => GPS_SDO <= FIRSTBYTE(7);
      when 205 => GPS_SDO <= STOPBIT;
      when 206 => GPS_SDO <= STARTBIT; -- Byte 21 (Longitude)
      when 207 => GPS_SDO <= SECONDBYTE(0);
      when 208 => GPS_SDO <= SECONDBYTE(1);
      when 209 => GPS_SDO <= SECONDBYTE(2);
      when 210 => GPS_SDO <= SECONDBYTE(3);
      when 211 => GPS_SDO <= SECONDBYTE(4);
      when 212 => GPS_SDO <= SECONDBYTE(5);
      when 213 => GPS_SDO <= SECONDBYTE(6);
      when 214 => GPS_SDO <= SECONDBYTE(7);
      when 215 => GPS_SDO <= STOPBIT;
      when 216 => GPS_SDO <= STARTBIT; -- Byte 22 (Longitude)
      when 217 => GPS_SDO <= THIRDBYTE(0);
      when 218 => GPS_SDO <= THIRDBYTE(1);
      when 219 => GPS_SDO <= THIRDBYTE(2);
      when 220 => GPS_SDO <= THIRDBYTE(3);
      when 221 => GPS_SDO <= THIRDBYTE(4);
      when 222 => GPS_SDO <= THIRDBYTE(5);
      when 223 => GPS_SDO <= THIRDBYTE(6);
      when 224 => GPS_SDO <= THIRDBYTE(7);
      when 225 => GPS_SDO <= STOPBIT;
      when 226 => GPS_SDO <= STARTBIT; -- Byte 23 (Longitude)
      when 227 => GPS_SDO <= FOURTHBYTE(0);
      when 228 => GPS_SDO <= FOURTHBYTE(1);
      when 229 => GPS_SDO <= FOURTHBYTE(2);
      when 230 => GPS_SDO <= FOURTHBYTE(3);
      when 231 => GPS_SDO <= FOURTHBYTE(4);
      when 232 => GPS_SDO <= FOURTHBYTE(5);
      when 233 => GPS_SDO <= FOURTHBYTE(6);
      when 234 => GPS_SDO <= FOURTHBYTE(7);
      when 235 => GPS_SDO <= STOPBIT;
      when 236 => GPS_SDO <= STARTBIT; -- Byte 24 (Height)
      when 237 => GPS_SDO <= FIRSTBYTE(0);
      when 238 => GPS_SDO <= FIRSTBYTE(1);
      when 239 => GPS_SDO <= FIRSTBYTE(2);
      when 240 => GPS_SDO <= FIRSTBYTE(3);
      when 241 => GPS_SDO <= FIRSTBYTE(4);
      when 242 => GPS_SDO <= FIRSTBYTE(5);
      when 243 => GPS_SDO <= FIRSTBYTE(6);
      when 244 => GPS_SDO <= FIRSTBYTE(7);
      when 245 => GPS_SDO <= STOPBIT;
      when 246 => GPS_SDO <= STARTBIT; -- Byte 25 (Height)
      when 247 => GPS_SDO <= SECONDBYTE(0);
      when 248 => GPS_SDO <= SECONDBYTE(1);
      when 249 => GPS_SDO <= SECONDBYTE(2);
      when 250 => GPS_SDO <= SECONDBYTE(3);
      when 251 => GPS_SDO <= SECONDBYTE(4);
      when 252 => GPS_SDO <= SECONDBYTE(5);
      when 253 => GPS_SDO <= SECONDBYTE(6);
      when 254 => GPS_SDO <= SECONDBYTE(7);
      when 255 => GPS_SDO <= STOPBIT;
      when 256 => GPS_SDO <= STARTBIT; -- Byte 26 (Height)
      when 257 => GPS_SDO <= THIRDBYTE(0);
      when 258 => GPS_SDO <= THIRDBYTE(1);
      when 259 => GPS_SDO <= THIRDBYTE(2);
      when 260 => GPS_SDO <= THIRDBYTE(3);
      when 261 => GPS_SDO <= THIRDBYTE(4);
      when 262 => GPS_SDO <= THIRDBYTE(5);
      when 263 => GPS_SDO <= THIRDBYTE(6);
      when 264 => GPS_SDO <= THIRDBYTE(7);
      when 265 => GPS_SDO <= STOPBIT;
      when 266 => GPS_SDO <= STARTBIT; -- Byte 27 (Height)
      when 267 => GPS_SDO <= FOURTHBYTE(0);
      when 268 => GPS_SDO <= FOURTHBYTE(1);
      when 269 => GPS_SDO <= FOURTHBYTE(2);
      when 270 => GPS_SDO <= FOURTHBYTE(3);
      when 271 => GPS_SDO <= FOURTHBYTE(4);
      when 272 => GPS_SDO <= FOURTHBYTE(5);
      when 273 => GPS_SDO <= FOURTHBYTE(6);
      when 274 => GPS_SDO <= FOURTHBYTE(7);
      when 275 => GPS_SDO <= STOPBIT;
      when others => GPS_SDO <= '1';
    end case;
  end process;

end architecture a0 ; -- of Testbench

