	library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

	-- entity
	entity rndGaussGen is
		port     (clk_i  : in  std_logic;
				  rndNumb : out std_logic_vector(13 downto 0) );
	end rndGaussGen;

	architecture behav of rndGaussGen is
		
		type memory is array (0 to 15) of signed(17 downto 0); --memory has to have 4 extra bits to accomodate the sum of 16 numbers without overflowing
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
		variable sum     : signed(17 downto 0);
		begin
			case PS is
				when ST0 => --build uniformNumbers matrix
					if (count_1 = 0) then --place seed at fist row
						uniformNumbers(count_1) <= (0 => '1', others => '0'); 
						--uniformNumbers(count_1)(0) <= '1';
						count_1 := count_1 + 1;
						NS <= ST0; --continue in this state
					elsif (count_1 < 16) then -- evaluate next rows
						uniformNumbers(count_1) <= (others => '0');
						uniformNumbers(count_1)(13 downto 0) <= (uniformNumbers(count_1 - 1)(13 downto 0) srl 1) OR ((uniformNumbers(count_1 - 1)(13 downto 0) XOR (uniformNumbers(count_1 - 1)(13 downto 0) srl 1) XOR (uniformNumbers(count_1 - 1)(13 downto 0) srl 2) XOR (uniformNumbers(count_1 - 1)(13 downto 0) srl 12) ) sll 13) ;
						count_1 := count_1 + 1;
						NS <= ST0; --continue in this state
					elsif (count_1 = 16) then -- matrix is done, advance to next state
						NS <= ST1;--go to the next state
					end if;
					
					rndNumb <= (others => '0'); --rndNumb zeros when building matrix
					
				when ST1 =>
				
					if (rising_edge(clk_i)) then
						sum := shift_right(  ( uniformNumbers(0)
								 + uniformNumbers(1)
								 + uniformNumbers(2)
								 + uniformNumbers(3)
								 + uniformNumbers(4)
								 + uniformNumbers(5)
								 + uniformNumbers(6)
								 + uniformNumbers(7)
								 + uniformNumbers(8)
								 + uniformNumbers(9)
								 + uniformNumbers(10)
								 + uniformNumbers(11)
								 + uniformNumbers(12)
								 + uniformNumbers(13)
								 + uniformNumbers(14)
								 + uniformNumbers(15 )) , 4); --sum 16 entries and divide by 16 (which is equivalent to srl 4)
						
						for i in 0 to 14 loop -- shift the registers up
							uniformNumbers(i) <= uniformNumbers(i+1);
						end loop;
						
						uniformNumbers(15) <= (others => '0'); -- evaluate the last register
						uniformNumbers(15)(13 downto 0) <= (uniformNumbers(15)(13 downto 0) srl 1) OR ((uniformNumbers(15)(13 downto 0) XOR (uniformNumbers(15)(13 downto 0) srl 1) XOR (uniformNumbers(15)(13 downto 0) srl 2) XOR (uniformNumbers(15)(13 downto 0) srl 12) ) sll 13) ;
						
						rndNumb <= std_logic_vector(resize(sum,14)); --output the normalized sum, which should give a normal distributed signal
						
					end if;
				when others =>
				
					NS <= ST0;
					
			end case;
			
		end process main;
	
	end behav;
