library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

-- entity
entity rndGaussGen_TB is
end rndGaussGen_TB;

architecture behav of rndGaussGen_TB is
	signal clk_i    : std_logic;
    signal rndNumb  : std_logic_vector(13 downto 0);
	signal Y        : std_logic_vector(1 downto 0);
begin
	
    UUT : entity work.rndGaussGen
 port map(clk_i => clk_i, rndNumb => rndNumb, Y => Y);
    
    CLOCK_GEN : process
    file test_vector      : text open write_mode is "test.txt";
	variable row          : line;
    begin
        clk_i <= '0';
        wait for 1 ns;
        --write(row,clk_i, right, 20);
        --write(row,rndNumb, right, 20);
		--write(row,Y, right, 20);
        --writeline(test_vector,row);
        clk_i <= '1';
        wait for 1 ns;
		if (Y = "01") then
        --write(row,clk_i, right, 20);
        write(row,rndNumb, right, 20);
		--write(row,Y, right, 20);
        writeline(test_vector,row);
        end if;

    end process;
    
end behav;
