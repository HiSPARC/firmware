-- EASE/HDL begin --------------------------------------------------------------
-- Architecture 'rtl' of 'PLL.
--------------------------------------------------------------------------------
-- Copy of the interface declaration of Entity 'PLL' :
-- 
--   port(
--     CLK200MHz : out    std_logic;
--     inclk0    : in     std_logic;
--     locked    : out    std_logic);
-- 
-- EASE/HDL end ----------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

architecture rtl of PLL is

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (5 DOWNTO 0);
	SIGNAL sub_wire1	: STD_LOGIC ;
	SIGNAL sub_wire2	: STD_LOGIC ;
	SIGNAL sub_wire3	: STD_LOGIC ;
	SIGNAL sub_wire4	: STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL sub_wire5_bv	: BIT_VECTOR (0 DOWNTO 0);
	SIGNAL sub_wire5	: STD_LOGIC_VECTOR (0 DOWNTO 0);

	COMPONENT altpll
	GENERIC (
		clk0_duty_cycle		: NATURAL;
		lpm_type		: STRING;
		clk0_multiply_by		: NATURAL;
		invalid_lock_multiplier		: NATURAL;
		inclk0_input_frequency		: NATURAL;
		gate_lock_signal		: STRING;
		clk0_divide_by		: NATURAL;
		pll_type		: STRING;
		valid_lock_multiplier		: NATURAL;
		intended_device_family		: STRING;
		operation_mode		: STRING;
		compensate_clock		: STRING;
		clk0_phase_shift		: STRING
	);
	PORT (
			inclk	: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			locked	: OUT STD_LOGIC ;
			clk	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
	);
	END COMPONENT;

begin

	sub_wire5_bv(0 DOWNTO 0) <= "0";
	sub_wire5    <= To_stdlogicvector(sub_wire5_bv);
	sub_wire1    <= sub_wire0(0);
	CLK200MHz    <= sub_wire1;
	locked    <= sub_wire2;
	sub_wire3    <= inclk0;
	sub_wire4    <= sub_wire5(0 DOWNTO 0) & sub_wire3;

	altpll_component : altpll
	GENERIC MAP (
		clk0_duty_cycle => 50,
		lpm_type => "altpll",
		clk0_multiply_by => 1,
		invalid_lock_multiplier => 5,
		inclk0_input_frequency => 5000,
		gate_lock_signal => "NO",
		clk0_divide_by => 1,
		pll_type => "FAST",
		valid_lock_multiplier => 1,
		intended_device_family => "Cyclone II",
		operation_mode => "NORMAL",
		compensate_clock => "CLK0",
--		clk0_phase_shift => "2000"
		clk0_phase_shift => "0000"
	)
	PORT MAP (
		inclk => sub_wire4,
		clk => sub_wire0,
		locked => sub_wire2
	);
 
end rtl ; -- of PLL

