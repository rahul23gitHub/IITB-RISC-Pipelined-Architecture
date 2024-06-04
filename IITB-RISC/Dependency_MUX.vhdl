library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Libraries

entity Dependency_MUX is
	port (
	RF_out: in std_logic_vector(15 downto 0);
    D_val4: in std_logic_vector(15 downto 0);
    D_val5: in std_logic_vector(15 downto 0);
    D_val6: in std_logic_vector(15 downto 0);
-- Control pins from BrPred,RF_read,Execute_Stage

    DStg_4: in std_logic;
    DStg_5: in std_logic;
    DStg_6: in std_logic;
-- Final Output to be given to PC_new of Next stage to be written to R0 of RF;

	Dependency_MUX_out: out std_logic_vector(15 downto 0)
    
    );
end Dependency_MUX;

architecture bhv of Dependency_MUX is
begin
selecting: process(DStg_4,DStg_5,DStg_6,RF_out,D_val5,D_val4,D_val6)
begin 

    if (DStg_4='1') then 
    Dependency_MUX_out<=D_val4;
	 -- highest priority to the latest value

    else if (DStg_5='1') then 
    Dependency_MUX_out<=D_val5;

    else if (DStg_6='1') then 
    Dependency_MUX_out<=D_val6;

    else 
    Dependency_MUX_out<=RF_out; -- By default 
    end if;
	 end if;
	 end if;
end process;
end bhv;




