library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity counter_time is
    generic(n: natural := 2);
    port (clk: in STD_LOGIC;
            reset : in std_logic;
			output : out STD_LOGIC_VECTOR(n-1 downto 0);
			output_flag : out STD_LOGIC);
end counter_time;

architecture Behavioral of counter_time is
    signal temp : STD_LOGIC_VECTOR(n-1 downto 0) := (others => '0');
    signal limit : STD_LOGIC_VECTOR(n-1 downto 0) := B"111011";
begin
	counter_process : process(clk)
        begin
            if reset = '1' then
                temp <= (others => '0');
			elsif clk'event and clk='1' then
			    output_flag <= '0';
                temp <= temp + '1';
                if temp = limit then
                    temp <= (others => '0');
                    output_flag <= '1';
                end if;
			end if;
		end process;
	output <= temp;
end Behavioral;