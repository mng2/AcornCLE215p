
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
    
    process(clk200)
    begin
        if rising_edge(clk200) then
            if count = 100000000 then
                count       <= 0;
                slowflag    <= '1';
            else
                count       <= count + 1;
                slowflag    <= '0';
            end if;
            if slowflag = '1' then
                countslow  <= countslow + 1;
            end if;
            LEDs_N <= not std_logic_vector(countslow);
        end if;
    end process;

end Behavioral;
