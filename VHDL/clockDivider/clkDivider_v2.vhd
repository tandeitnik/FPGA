library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- entity
entity clkDivider is
	generic  (N      : integer := 5);
	port     (clk_i  : in  std_logic;
			  clk_o  : out std_logic );
end clkDivider;

architecture behav of clkDivider is
	
begin
	
	process(clk_i)
	variable counter : integer :=0;
	begin
		if (rising_edge(clk_i)) then
			if (counter = 0) then
				clk_o <= '1';
				counter := counter + 1;
			elsif (counter < (N-1)) then
				clk_o <= '0';
				counter := counter + 1;
			elsif (counter = (N-1)) then
				clk_o <= '0';
				counter := 0;
			else
				null;
			end if;
			
		else

			clk_o <= '0';
		
		end if;
		
		
	end process;
	
end behav;
