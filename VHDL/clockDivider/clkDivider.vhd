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
	type state_type is (ST0,ST1);
	signal PS, NS : state_type;
begin
	
	sync_proc: process(clk_i,NS)
		variable CLR : integer := 1;
		begin
			if (CLR = 1) then
				PS <= ST0;
				CLR := 0;
			elsif (rising_edge(clk_i)) then
				PS <= NS;
			end if;
		end process sync_proc;
	
	process(clk_i,PS)
	variable count : integer := 0;
	begin
		case PS is
			when ST0 =>
				if (rising_edge(clk_i)) then
					clk_o <= '1';
					count := count + 1;
					NS <= ST1;
				end if;
			when ST1 =>
				if (rising_edge(clk_i)) then
					if (count = (N-1)) then
						clk_o <= '0';
						count := 0;
						NS <= ST0;
					else
                    	clk_o <= '0';
						NS <= ST1;
						count := count + 1;
					end if;
				end if;
			when others =>
				clk_o <= '0';
				count := 0;
				NS <= ST0;
		end case;
	end process;

end behav;
