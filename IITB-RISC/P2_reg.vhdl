library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all; 
-- Libraries

entity p2_reg is 
	port(
	     p2_w,clock,reset : in std_logic;
		 Op_code_stg2: in std_logic_vector(3 downto 0); --(41 downto 38)
		 Ra,Rb,Rc,last_3: in std_logic_vector(2 downto 0);  --(37 downto 35), (34 downto 32), (31 downto 29), (19 downto 17)
		 Immi: in std_logic_vector(8 downto 0);  --(28 downto 20)
		 PC_in_stg2: in std_logic_vector(15 downto 0); --(15 downto 0)
		 data_bit: in std_logic; --(16)
		 p2_out: out std_logic_vector(41 downto 0));
end entity p2_reg;

architecture behav of p2_reg is
signal temp: std_logic_vector(41 downto 0):= (others => '0');
begin 

temp_writing : process(clock,reset)
begin

	if (reset = '1') then
		temp <= (others=>'0');
	else
		if (rising_edge(clock) and (p2_w = '1')) then
			temp <= Op_code_stg2 & Ra & Rb & Rc & Immi & last_3 & data_bit & PC_in_stg2;
	    else
			null;
	    end if;
	end if; 
	
end process;

p2_out<= temp;
end architecture behav;