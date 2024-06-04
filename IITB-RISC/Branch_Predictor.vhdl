library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Libraries

entity BrPred is
    port (
        clock, reset     : in std_logic; -- Clock and reset inputs
        PC_in_Stg_1      : in std_logic_vector(15 downto 0); -- PC input in stage 1
        Op_codebpred     : in std_logic_vector(3 downto 0); -- Operation code for branch predictor
        CStg_1, Databit  : out std_logic; -- Outputs for condition stage 1 and data bit
        PC_in_Stg_4      : in std_logic_vector(15 downto 0); -- PC input in stage 3
        WriteBit         : in std_logic; -- Signal to write
        Condition        : in std_logic; -- Condition signal
        Branch_to        : in std_logic_vector(15 downto 0); -- Branch target
        Update           : in std_logic; -- Update signal
        Stop_signal      : out std_logic; -- Stop signal
        PC_out           : out std_logic_vector(15 downto 0)  -- PC output
    );
end entity BrPred;

-- Architecture definition
architecture behav of BrPred is
    -- Register array declaration
	 signal found:std_logic:='0';
    type reg_array_type is array (15 downto 0) of std_logic_vector(32 downto 0); 
    signal registers: reg_array_type := (others => (others => '0')); -- Initialize all registers to zero
    
    -- Helper function to extract components from the register
    function get_pc(in_reg: std_logic_vector(32 downto 0)) return std_logic_vector is
        variable pc: std_logic_vector(15 downto 0);
    begin
        pc := in_reg(32 downto 17);
        return pc;
    end function;
    
    function get_branch_target(in_reg: std_logic_vector(32 downto 0)) return std_logic_vector is
        variable branch_target: std_logic_vector(15 downto 0);
    begin
        branch_target := in_reg(16 downto 1);
        return branch_target;
    end function;

    -- Process to find PC at stage 1
	 begin
    Stg1_FindPC: process(clock, reset)
    begin
        if reset = '1' then
            CStg_1 <= '0';
            Databit <= '0';
        elsif rising_edge(clock) then
            CStg_1 <= '0';
            Databit <= '0';
            
            -- Find PC and determine action based on history bit
            for i in registers'range loop
                if get_pc(registers(i)) = PC_in_Stg_1 then
                    if registers(i)(0) = '1' then
                        PC_out <= get_branch_target(registers(i)); -- Output PC
                        CStg_1 <= '1';
							   Databit<='1';	-- Signal branch taken
                    end if;
                    exit;
                end if;
            end loop;
        end if;
    end process;

    -- Process to write/update PC at stage 3
    Stg_WritePC: process(clock, reset)
    begin
        if reset = '1' then
            for i in registers'range loop
                registers(i) <= (others => '0'); -- Reset all registers
            end loop;
        elsif rising_edge(clock) then
            -- Update existing or add new entry if WriteBit is set
				found<='0';
				  if Update = '1' then
            if WriteBit = '0' then
                for i in registers'range loop
                    if get_pc(registers(i)) = PC_in_Stg_4 then
                        registers(i) <= PC_in_Stg_4 & Branch_to & Condition; -- Update existing
								found<='1';
                        exit;
                    end if;
                end loop;
                -- Find a free slot to insert a new entry if needed
					 if(found='0') then 
                for i in registers'range loop
                    if registers(i)(32 downto 0) = "000000000000000000000000000000000" then
                        registers(i) <= PC_in_Stg_4 & Branch_to & Condition; -- Add new entry
                        exit;
                    end if;
                end loop;
					 end if;
            end if;
				end if;
        end if;
    end process;

    -- Process to update Stop_signal based on opcode and branch
    Branching_Update: process(clock, reset)
    begin
            Stop_signal <= '0'; -- Default to no stop
            if Update = '1' then
                for i in registers'range loop
                    if get_pc(registers(i)) = PC_in_Stg_4 then
                        if Op_codebpred = "1101" or Op_codebpred = "1111" then
                            if get_branch_target(registers(i)) = Branch_to then
                                Stop_signal <= '0'; -- No stop
                            else
                                Stop_signal <= '1'; -- Stop signal
                            end if;
                        end if;
							if Op_codebpred = "1001" or Op_codebpred = "1010"  or Op_codebpred = "1000" then
                            if registers(i)(0)='1' then
                                Stop_signal <= '0'; -- No stop
                            else
                                Stop_signal <= '1'; -- Stop signal
                            end if;
                     end if;
								
                    end if;
                end loop;
            end if;
    end process;

end architecture behav;
