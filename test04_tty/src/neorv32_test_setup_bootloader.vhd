-- #################################################################################################
-- # << NEORV32 - Test Setup using the UART-Bootloader to upload and run executables >>            #
-- # ********************************************************************************************* #
-- # BSD 3-Clause License                                                                          #
-- #                                                                                               #
-- # Copyright (c) 2021, Stephan Nolting. All rights reserved.                                     #
-- #                                                                                               #
-- # Redistribution and use in source and binary forms, with or without modification, are          #
-- # permitted provided that the following conditions are met:                                     #
-- #                                                                                               #
-- # 1. Redistributions of source code must retain the above copyright notice, this list of        #
-- #    conditions and the following disclaimer.                                                   #
-- #                                                                                               #
-- # 2. Redistributions in binary form must reproduce the above copyright notice, this list of     #
-- #    conditions and the following disclaimer in the documentation and/or other materials        #
-- #    provided with the distribution.                                                            #
-- #                                                                                               #
-- # 3. Neither the name of the copyright holder nor the names of its contributors may be used to  #
-- #    endorse or promote products derived from this software without specific prior written      #
-- #    permission.                                                                                #
-- #                                                                                               #
-- # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS   #
-- # OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF               #
-- # MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE    #
-- # COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,     #
-- # EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE #
-- # GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED    #
-- # AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING     #
-- # NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED  #
-- # OF THE POSSIBILITY OF SUCH DAMAGE.                                                            #
-- # ********************************************************************************************* #
-- # The NEORV32 RISC-V Processor - https://github.com/stnolting/neorv32                           #
-- #################################################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.VComponents.all;

library neorv32;
use neorv32.neorv32_package.all;

entity neorv32_bootloader_200 is
  generic (
    -- adapt these for your setup --
    CLOCK_FREQUENCY   : natural := 100000000; -- clock frequency of clk_i in Hz
    MEM_INT_IMEM_SIZE : natural := 16*1024;   -- size of processor-internal instruction memory in bytes
    MEM_INT_DMEM_SIZE : natural := 8*1024     -- size of processor-internal data memory in bytes
  );
  port (
    -- Global control --
    CLK200_P    : in  std_ulogic; -- global clock, rising edge
    CLK200_N    : in  std_ulogic;
    rstn_i      : in  std_ulogic; -- global reset, low-active, async
    clk100      : out std_ulogic;
    -- GPIO --
    gpio_o      : out std_ulogic_vector(7 downto 0); -- parallel output
    -- UART0 --
    brt0_txd_o  : out std_ulogic_vector(7 downto 0); -- UART0 send data
    brt0_rxd_i  : in  std_ulogic_vector(7 downto 0); -- UART0 receive data
    brt0_txd_valid  : out std_ulogic;
    brt0_rxd_valid  : in  std_ulogic
  );
end entity;

architecture neorv32_test_setup_bootloader_rtl of neorv32_bootloader_200 is

    signal clk200       : std_ulogic;
    signal clk100int    : std_ulogic;
    signal clkfb        : std_ulogic;
    signal mmcm_lock    : std_ulogic;  
    signal con_gpio_o   : std_ulogic_vector(63 downto 0);

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
    CLKOUT1 => clk100int,     -- 1-bit output: CLKOUT1
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
    
  -- The Core Of The Problem ----------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  neorv32_top_inst: entity neorv32.neorv32_top
  generic map (
    -- General --
    CLOCK_FREQUENCY              => CLOCK_FREQUENCY,   -- clock frequency of clk_i in Hz
    INT_BOOTLOADER_EN            => true,              -- boot configuration: true = boot explicit bootloader; false = boot from int/ext (I)MEM
    -- RISC-V CPU Extensions --
    CPU_EXTENSION_RISCV_C        => true,              -- implement compressed extension?
    CPU_EXTENSION_RISCV_M        => true,              -- implement mul/div extension?
    CPU_EXTENSION_RISCV_Zicsr    => true,              -- implement CSR system?
    CPU_EXTENSION_RISCV_Zicntr   => true,              -- implement base counters?
    -- Internal Instruction memory --
    MEM_INT_IMEM_EN              => true,              -- implement processor-internal instruction memory
    MEM_INT_IMEM_SIZE            => MEM_INT_IMEM_SIZE, -- size of processor-internal instruction memory in bytes
    -- Internal Data memory --
    MEM_INT_DMEM_EN              => true,              -- implement processor-internal data memory
    MEM_INT_DMEM_SIZE            => MEM_INT_DMEM_SIZE, -- size of processor-internal data memory in bytes
    -- Processor peripherals --
    IO_GPIO_EN                   => true,              -- implement general purpose input/output port unit (GPIO)?
    IO_MTIME_EN                  => true,              -- implement machine system timer (MTIME)?
    IO_BRT0_EN                   => true               -- implement primary byte receiver/transmitter (as UART0)?
  )
  port map (
    -- Global control --
    clk_i       => clk100int,       -- global clock, rising edge
    rstn_i      => (rstn_i and mmcm_lock),  -- global reset, low-active, async
    -- GPIO (available if IO_GPIO_EN = true) --
    gpio_o      => con_gpio_o,  -- parallel output
    -- primary BRT0 (available if IO_BRT0_EN = true) --
    brt0_txd_o => brt0_txd_o, -- UART0 send data
    brt0_rxd_i => brt0_rxd_i, -- UART0 receive data
    brt0_txd_valid => brt0_txd_valid,
    brt0_rxd_valid => brt0_rxd_valid
  );

  -- GPIO output --
  gpio_o <= con_gpio_o(7 downto 0);

  clk100 <= clk100int;

end architecture;
