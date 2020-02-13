-- 
-- Component made in order to 
-- divide the on-board clock
-- to smaller frequency clocks where 
-- N is the number of repetitions
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity freq_div is
	generic (N:positive:=1);
	port(clk_board : in STD_LOGIC;
			clk_out : out STD_LOGIC);
end freq_div;

architecture Behavioral of freq_div is
-- Signals
signal temp : STD_LOGIC := '0';
signal i : integer := 0;

begin
	freqdiv : process(clk_board) is
	begin
		if clk_board'event and clk_board='1' then
			i <= i+1;
			if (i = N) then  
				temp <= not temp;
				i <= 0;
			end if;
		end if;
	end process;
	clk_out <= temp;
end Behavioral;