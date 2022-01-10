
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity top is
    Port ( CLK200_P : in STD_LOGIC;
           CLK200_N : in STD_LOGIC;
           LEDs_N   : out STD_LOGIC_VECTOR (4 downto 1));
end top;

architecture Behavioral of top is

    signal clk200   : std_logic;
    signal count    : integer := 0;
    signal countslow: unsigned(4 downto 1) := X"0";
    signal slowflag : std_logic;
    signal clk100   : std_logic;
    signal clkfb    : std_logic;
    signal mmcm_lock: std_logic;
    signal uc_gpio  : std_ulogic_vector(7 downto 0);
    
    component neorv32_test_setup_approm
    port (
    -- Global control --
    clk_i       : in  std_ulogic; -- global clock, rising edge
    rstn_i      : in  std_ulogic; -- global reset, low-active, async
    -- GPIO --
    gpio_o      : out std_ulogic_vector(7 downto 0) -- parallel output
    );
    end component;
  
begin

    IBUFDS_clk200 : IBUFDS
    generic map (
        DIFF_TERM => FALSE, -- already has external termination? 
        IBUF_LOW_PWR => FALSE,
        IOSTANDARD => "DEFAULT" )
    port map (
        I     => CLK200_P,
        IB    => CLK200_N,
        O     => clk200 
    );
    
    -- instantiate MMCM to halve frequency for NEORV32
    MMCME2_BASE_inst : MMCME2_BASE
    generic map (
    BANDWIDTH => "OPTIMIZED",  -- Jitter programming (OPTIMIZED, HIGH, LOW)
    CLKFBOUT_MULT_F => 5.0,    -- Multiply value for all CLKOUT (2.000-64.000).
    CLKFBOUT_PHASE => 0.0,     -- Phase offset in degrees of CLKFB (-360.000-360.000).
    CLKIN1_PERIOD => 5.0,      -- Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
    -- CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
    CLKOUT1_DIVIDE => 10,
    CLKOUT2_DIVIDE => 1,
    CLKOUT3_DIVIDE => 1,
    CLKOUT4_DIVIDE => 1,
    CLKOUT5_DIVIDE => 1,
    CLKOUT6_DIVIDE => 1,
    CLKOUT0_DIVIDE_F => 1.0,   -- Divide amount for CLKOUT0 (1.000-128.000).
    -- CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
    CLKOUT0_DUTY_CYCLE => 0.5,
    CLKOUT1_DUTY_CYCLE => 0.5,
    CLKOUT2_DUTY_CYCLE => 0.5,
    CLKOUT3_DUTY_CYCLE => 0.5,
    CLKOUT4_DUTY_CYCLE => 0.5,
    CLKOUT5_DUTY_CYCLE => 0.5,
    CLKOUT6_DUTY_CYCLE => 0.5,
    -- CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
    CLKOUT0_PHASE => 0.0,
    CLKOUT1_PHASE => 0.0,
    CLKOUT2_PHASE => 0.0,
    CLKOUT3_PHASE => 0.0,
    CLKOUT4_PHASE => 0.0,
    CLKOUT5_PHASE => 0.0,
    CLKOUT6_PHASE => 0.0,
    CLKOUT4_CASCADE => FALSE,  -- Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
    DIVCLK_DIVIDE => 1,        -- Master division value (1-106)
    REF_JITTER1 => 0.0,        -- Reference input jitter in UI (0.000-0.999).
    STARTUP_WAIT => TRUE      -- Delays DONE until MMCM is locked (FALSE, TRUE)
    )
    port map (
    -- Clock Outputs: 1-bit (each) output: User configurable clock outputs
    CLKOUT0 => open,     -- 1-bit output: CLKOUT0
    CLKOUT0B => open,   -- 1-bit output: Inverted CLKOUT0
    CLKOUT1 => clk100,     -- 1-bit output: CLKOUT1
    CLKOUT1B => open,   -- 1-bit output: Inverted CLKOUT1
    CLKOUT2 => open,     -- 1-bit output: CLKOUT2
    CLKOUT2B => open,   -- 1-bit output: Inverted CLKOUT2
    CLKOUT3 => open,     -- 1-bit output: CLKOUT3
    CLKOUT3B => open,   -- 1-bit output: Inverted CLKOUT3
    CLKOUT4 => open,     -- 1-bit output: CLKOUT4
    CLKOUT5 => open,     -- 1-bit output: CLKOUT5
    CLKOUT6 => open,     -- 1-bit output: CLKOUT6
    -- Feedback Clocks: 1-bit (each) output: Clock feedback ports
    CLKFBOUT => clkfb,   -- 1-bit output: Feedback clock
    CLKFBOUTB => open, -- 1-bit output: Inverted CLKFBOUT
    -- Status Ports: 1-bit (each) output: MMCM status ports
    LOCKED => mmcm_lock,       -- 1-bit output: LOCK
    -- Clock Inputs: 1-bit (each) input: Clock input
    CLKIN1 => clk200,       -- 1-bit input: Clock
    -- Control Ports: 1-bit (each) input: MMCM control ports
    PWRDWN => '0',       -- 1-bit input: Power-down
    RST => '0',             -- 1-bit input: Reset
    -- Feedback Clocks: 1-bit (each) input: Clock feedback ports
    CLKFBIN => clkfb      -- 1-bit input: Feedback clock
    );
    
    my_neo: neorv32_test_setup_approm
    port map(
        clk_i   => clk100,
        rstn_i  => mmcm_lock,
        gpio_o  => uc_gpio
    );
    
    LEDs_N <= not std_logic_vector(uc_gpio(3 downto 0));

end Behavioral;
