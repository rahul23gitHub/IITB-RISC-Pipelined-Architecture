library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Libraries

entity HazardDetector is
	port (
    Address_Stg3_A:in std_logic_vector(2 downto 0);
    Address_Stg3_B:in std_logic_vector(2 downto 0);
    Address_Stg: in std_logic_vector(2 downto 0);
    hazardbit:in std_logic;
    sel_A:out std_logic;
    sel_B:out std_logic
    );
end HazardDetector;

architecture behav of HazardDetector is
begin
selecting:process(Address_Stg3_A,Address_Stg3_B,Address_Stg,hazardbit)
begin
    if(hazardbit='0') then 
    sel_A<='0';
    sel_B<='0';
    -- if the data which it has is of no use then  hazardbit is zero
    else
      if(Address_Stg3_A = Address_Stg) then 
      sel_A<='1';
		-- if its output address is matching with any of the input addresses 
      end if;
      if(Address_Stg3_B = Address_Stg) then 
      sel_B<='1';
      end if;
    end if;
end process;
end behav;



