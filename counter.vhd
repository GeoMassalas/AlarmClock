library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity counter is
    generic(n: natural := 2);
    port (clk: in STD_LOGIC;
            reset : in std_logic;
			output : out STD_LOGIC_VECTOR(n-1 downto 0));
end counter;

architecture Behavioral of counter is
	signal temp : STD_LOGIC_VECTOR(n-1 downto 0) := (others => '0');
begin
	counter_process : process(clk)
        begin
            if reset = '1' then
                temp <= (others => '0');
			elsif clk'event and clk='1' then
                temp <= temp + '1';
			end if;
		end process;
	output <= temp;
end Behavioral;