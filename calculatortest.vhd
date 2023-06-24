-- Hannah Soria
-- CS232 fall 22
-- project06
-- calculatortest
-- test program for the calculator circuit
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculatortest is
end entity;

architecture test of calculatortest is
  constant num_cycles : integer := 80;

  -- this circuit needs a clock and a reset
  signal clk : std_logic := '1';
  signal reset : std_logic;

  -- calculator component
  component calculator
    port(		
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
		
  end component;
  
  	--hexdisplay
	component hexdisplay
	port(
	A: in UNSIGNED(3 downto 0);
	result: out UNSIGNED(6 downto 0)
   );
   end component;
	
	signal op: std_logic_vector(1 downto 0);
	signal digit0: std_logic_vector(6 downto 0);
	signal digit1: std_logic_vector(6 downto 0);

  -- output signals
  signal stackview: std_logic_vector(3 downto 0);
  

  -- buttons
  signal b2, b3, b4 : std_logic;
  signal data: std_logic_vector(7 downto 0);

begin

  -- start off with a short reset
  reset <= '0', '1' after 5 ns;

  -- create a clock
  process
  begin
    for i in 1 to num_cycles loop
      clk <= not clk;
      wait for 5 ns;
      clk <= not clk;
      wait for 5 ns;
    end loop;
    wait;
  end process;

  -- clock is in 5ns increments, rising edges on 5, 15, 25, 35, 45..., let 5 cycles
  -- go by before doing anything

  -- values 4, 3, 2, 6, and 1
  data <= "00000100", "00000010" after 65 ns, "00000110" after 130 ns, "00000011" after 220 ns, "00000001" after 300 ns;
  
  -- values 4, 3, 2, 6, and 1 are added into the mbr
  b2 <= '1', '0' after 10 ns, '1' after 20 ns, '0' after 80 ns, '1' after 90 ns, '0' after 150 ns, '1' after 160 ns, '0' after 230 ns, '1' after 240 ns, '0' after 310 ns, '1' after 320 ns;
  
  -- values 4, 3, 2, 6 are added to the stack
  b3 <= '1', '0' after 50 ns, '1' after 60 ns, '0' after 110 ns, '1' after 120 ns, '0' after 190 ns, '1' after 200 ns, '0' after 270 ns, '1' after 280 ns;
  
  -- vales are popped off the stack
  b4 <= '1', '0' after 370 ns, '1' after 380 ns, '0' after 430 ns, '1' after 440 ns, '0' after 490 ns, '1' after 500 ns, '0' after 550 ns, '1' after 560 ns;
  
  -- addition, then substraction, then multiplication, then division
  op <= "00", "01" after 410 ns, "10" after 480 ns, "11" after 530 ns;
  

  -- port map the circuit
  L0: calculator port map( clk, reset, b2, b3, b4, op, data, digit0, digit1, stackview);

end test;
