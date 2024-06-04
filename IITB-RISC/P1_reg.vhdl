library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all; 
-- Libraries

entity p1_reg is 
	port(
		 clock,P1_DB,p1_w,reset: in std_logic;
		 P1_PC,P1_IR : in std_logic_vector(15 downto 0);
		 P1_out: out std_logic_vector(32 downto 0));
end entity p1_reg;

architecture bhv of p1_reg is
signal temp: std_logic_vector(32 downto 0):= (others=>'0');
begin
    writing: process(clock,p1_w,reset)
    begin
        if (reset = '1') then
            temp <= (others=>'0');
        else
            if(rising_edge(clock) and p1_w='1') then 
                temp<=P1_PC&P1_IR&P1_DB;
            end if;
        end if;  
    end process;    
    P1_out<=temp;
    end bhv;

    
