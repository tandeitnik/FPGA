library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

-- entity
entity clkDivider_TB is
end clkDivider_TB;

architecture behav of clkDivider_TB is
	signal clk_i    : std_logic;
    signal clk_o    : std_logic;
    signal N        : integer := 5;
begin
	
    UUT : entity work.clkDivider
    generic map(N => N) port map(clk_i => clk_i, clk_o => clk_o) ;
    
    CLOCK_GEN : process
    file test_vector      : text open write_mode is "test.txt";
	variable row          : line;
    begin
        clk_i <= '0';
        wait for 1 ns;
        write(row,clk_i, right, 15);
        write(row,clk_o, right, 15);
        writeline(test_vector,row);
        clk_i <= '1';
        wait for 1 ns;

        write(row,clk_i, right, 15);
        write(row,clk_o, right, 15);
        writeline(test_vector,row);

    end process;
    
end behav;
