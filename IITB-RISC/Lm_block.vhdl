library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Libraries

entity lmsm_controller is
    port(
        Imm              : in std_logic_vector(7 downto 0);
        Ra               : in std_logic_vector(15 downto 0);
        ctrl_s4          : in std_logic;
        clock            : in std_logic;
        Dptr             : out std_logic_vector(15 downto 0);
        Rx_to_load_store : out std_logic_vector(2 downto 0);
        count            : out std_logic_vector(2 downto 0)
    );
end entity lmsm_controller;

architecture behav of lmsm_controller is
    type ArrayType is array (0 to 7) of std_logic_vector(2 downto 0);
    signal tempArray  : ArrayType := (others => "000"); -- Initialize all to 0
    signal temp_count : unsigned(2 downto 0) := (others => '0');
    signal i          : unsigned(2 downto 0) := (others => '0');
begin

    -- Process for counting and setting tempArray with addresses of registers to be loaded
    process (Imm)
    begin
        if rising_edge(clock) then
            temp_count <= (others => '0'); -- Reset count
            for j in Imm'range loop
                if Imm(j) = '1' then
                    temp_count <= temp_count + 1;
                    tempArray(j) <= std_logic_vector(to_unsigned(7-j, 3));
                end if;
            end loop;
        end if;
    end process;

    count <= std_logic_vector(temp_count-i); -- Output the count
    -- Final output process for load as well as store multiple
	 
    load: process(clock)
    begin
        if rising_edge(clock) then
            if ctrl_s4 = '1' then
                if to_integer(i) < to_integer(temp_count) then
                    -- Compute new Dptr based on `i`
                    Dptr <= std_logic_vector(signed(Ra) + to_signed(2 * to_integer(i), Dptr'length));
                    Rx_to_load_store <= tempArray(to_integer(i)); -- Use tempArray to store/load
                    i <= i + 1; -- Increment i`
                else                                          -- Reset `i` to avoid exceeding bounds
                    i <= (others => '0'); 
                end if;
            end if;
        end if;
    end process;

end architecture behav;
