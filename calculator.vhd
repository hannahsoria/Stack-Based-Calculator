-- Hannah Soria
-- CS232 fall 22
-- project06
-- calculator

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator is

  port
  ( 
		clock: in std_logic;
      reset: in std_logic; -- button 1
      b2:    in std_logic; -- capture input: switch values to mbr
      b3:    in std_logic; -- enter: push mbr -> stack
      b4:    in std_logic; -- action: pop stack -> mbr
		op:	in std_logic_vector(1 downto 0); -- 2 action switches
		data:  in std_logic_vector(7 downto 0); -- 8 input data switches
      digit0:	out std_logic_vector(6 downto 0); --output for 7 segment display
		digit1:	out std_logic_vector(6 downto 0); --output for 7 segment display
      stackview: out std_logic_vector(3 downto 0) -- stack debugging
	);
	

end entity;

architecture rtl of calculator is 

	component memram
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
	
	end component;
	
	component hexdisplay
	port(
	A: in UNSIGNED(3 downto 0);
	result: out UNSIGNED(6 downto 0)
   );
   end component;
	
	signal RAM_input:	std_LOGIC_VECTOR(7 downto 0);
	signal RAM_output:	std_LOGIC_VECTOR(7 downto 0);
	--ram write enable 
	signal RAM_we:	std_LOGIC;
	signal stack_ptr:	unsigned(3 downto 0);
	--register
	signal mbr:	std_LOGIC_VECTOR(7 downto 0);
	signal state:	std_LOGIC_VECTOR(2 downto 0);
	signal full_product: unsigned(15 downto 0);
	signal temp: std_LOGIC_VECTOR(2 downto 0);
	
	begin

	memram1: memram
	port map (address => std_LOGIC_VECTOR(stack_ptr), clock => clock, data => RAM_input, wren => RAM_we, q => RAM_output);
	
	hexdisplay1: hexdisplay
	port map (A => unsigned(mbr(3 downto 0)), std_LOGIC_VECTOR(result) => digit0);
	
	hexdisplay2: hexdisplay
	port map (A => unsigned(mbr(7 downto 4)), std_LOGIC_VECTOR(result) => digit1);

	stackview <= std_LOGIC_VECTOR(stack_ptr);
	
	process (clock, reset)
	begin
		if reset = '0' then
			stack_ptr <= "0000";
			mbr <= "00000000";
			RAM_input <= "00000000";
			RAM_we <= '0';
			state <= "000";
		elsif (rising_edge(clock)) then
			case state is
				--waiting for a button press
				when "000" =>
					temp <= "101";
				if b2 = '0' then
					mbr <= data; -- move current val of switches to mbr
					state <= "111";
				elsif b3 = '0' then
					RAM_input <= mbr; -- push mbr onto the stack
					RAM_we <= '1'; -- write 
					state <= "001";
				elsif  b4 = '0' then 
					if stack_ptr /= 0 then -- if stack is not enmpty
						stack_ptr <= stack_ptr - 1;
						state <= "100";
					end if;
				end if;
				
				-- next step in process of writing to memory
				when "001" =>
				RAM_we <= '0';
				stack_ptr <= stack_ptr + 1;
				state <= "111";
				
				-- next step for read process
				-- wait for 2 clock cycles for the new add to be accepted
				when "100" =>
				state <= "101";
				
				-- still waiting
				when "101" =>
				state <= "110";
				
				-- output is now avaliable
				when "110" =>
				if op = "00" then -- addition 
						mbr <= std_LOGIC_VECTOR(unsigned(mbr) + unsigned(RAM_output));
					
					elsif op = "01" then -- subtraction
						mbr <= std_LOGIC_VECTOR(unsigned(RAM_output) - unsigned(mbr));
						
					elsif op = "10" then -- multiplication
						mbr <= std_LOGIC_VECTOR(unsigned(RAM_output(3 downto 0)) * unsigned(mbr(3 downto 0)));
						
					elsif op = "11" then -- division
						mbr <= std_LOGIC_VECTOR(unsigned(RAM_output)/unsigned(mbr));
					
					end if;
				state <= "111";
				
				-- waits for all the buttons to be released
				when "111" =>
				if b2 = '1'then
					if b3 = '1' then
						if b4 = '1' then
							state <= "000";
						end if;
					end if;
				end if;
				
				when others =>
				state <= "000";
				
			end case;
		end if;
	end process;

	
	end rtl;
	