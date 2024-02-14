library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

-- entity
entity rndGaussGen_TB is
end rndGaussGen_TB;

architecture behav of rndGaussGen_TB is
	signal CLK    : std_logic;
    signal OUTPUT : std_logic_vector(13 downto 0);
begin
	
    UUT : entity work.rndGaussGen
 port map(clk_i => CLK, output => OUTPUT);
    
    CLOCK_GEN : process
    file test_vector      : text open write_mode is "test.txt";
	variable row          : line;
    begin
        CLK <= '0';
        wait for 1 ns;
        --write(row,CLK, right, 15);
        --write(row,output, right, 15);
        --writeline(test_vector,row);
        CLK <= '1';
        wait for 1 ns;

          write(row,CLK, right, 15);
          write(row,output, right, 15);
          writeline(test_vector,row);

    end process;
    
end behav;
