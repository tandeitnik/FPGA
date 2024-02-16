	library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

	-- entity
	entity rndGaussGen is
		port     (clk_i  : in  std_logic;
				  output : out std_logic_vector(13 downto 0) );
	end rndGaussGen;

	architecture behav of rndGaussGen is
		
		type memory is array (0 to (2**14-2)) of unsigned(17 downto 0); --memory has to have 4 extra bits to accomodate the sum of 16 numbers without overflowing
		type state_type is (ST0,ST1);
		signal PS, NS : state_type;
		signal uniformNumbers : memory; --matrix to store uniform distributed numbers

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
		
		main: process(PS,clk_i)
		variable count_1 : integer := 0;
		variable count_2 : integer := 0;
		variable sum     : unsigned(17 downto 0);
		begin
			case PS is
				when ST0 => --build uniformNumbers matrix
					if (count_1 = 0) then --place seed at fist row
						uniformNumbers(count_1) <= (others => '0'); 
						uniformNumbers(count_1)(0) <= '1';
						count_1 := count_1 + 1;
						NS <= ST0; --continue in this state
					elsif (count_1 < (2**14-1)) then -- evaluate next rows
						uniformNumbers(count_1) <= (others => '0');
						uniformNumbers(count_1)(13 downto 0) <= (uniformNumbers(count_1 - 1)(13 downto 0) srl 1) OR ((uniformNumbers(count_1 - 1)(13 downto 0) XOR (uniformNumbers(count_1 - 1)(13 downto 0) srl 1) XOR (uniformNumbers(count_1 - 1)(13 downto 0) srl 2) XOR (uniformNumbers(count_1 - 1)(13 downto 0) srl 12) ) sll 13) ;
						count_1 := count_1 + 1;
						NS <= ST0; --continue in this state
					elsif (count_1 = (2**14-1)) then -- matrix is done, advance to next state
						NS <= ST1;--go to the next state
					end if;
					
					output <= (others => '0'); --output zeros when building matrix
					
				when ST1 => 
				
					if (rising_edge(clk_i)) then
						sum := (   uniformNumbers((0 + count_2) mod (2**14-1))
								 + uniformNumbers((1 + count_2) mod (2**14-1))
								 + uniformNumbers((2 + count_2) mod (2**14-1))
								 + uniformNumbers((3 + count_2) mod (2**14-1))
								 + uniformNumbers((4 + count_2) mod (2**14-1))
								 + uniformNumbers((5 + count_2) mod (2**14-1))
								 + uniformNumbers((6 + count_2) mod (2**14-1))
								 + uniformNumbers((7 + count_2) mod (2**14-1))
								 + uniformNumbers((8 + count_2) mod (2**14-1))
								 + uniformNumbers((9 + count_2) mod (2**14-1))
								 + uniformNumbers((10 + count_2) mod (2**14-1))
								 + uniformNumbers((11 + count_2) mod (2**14-1))
								 + uniformNumbers((12 + count_2) mod (2**14-1))
								 + uniformNumbers((13 + count_2) mod (2**14-1))
								 + uniformNumbers((14 + count_2) mod (2**14-1))
								 + uniformNumbers((15 + count_2) mod (2**14-1)) ) srl 4; --sum 16 entries and divide by 16 (which is equivalent to srl 4)
						output <= std_logic_vector(sum(13 downto 0)); --output the normalized sum, which should give a normal distributed signal
						count_2 := (count_2 + 1) mod (2**14-1);
					end if;
				when others =>
				
					NS <= ST0;
					
			end case;
			
		end process main;
		
		
	end behav;
