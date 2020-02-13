library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mod10 is
	generic(divisor : integer := 10);
	port(divident : in STD_LOGIC_VECTOR(5 downto 0);
			quotient : out STD_LOGIC_VECTOR(3 downto 0);
			remainder : out STD_LOGIC_VECTOR(3 downto 0));
end mod10;

architecture Behavioral of mod10 is
signal q : STD_LOGIC_VECTOR(3 downto 0);
signal r : STD_LOGIC_VECTOR(5 downto 0);
begin
	div_process : process(divident)
		variable n : UNSIGNED(5 downto 0);
		variable t : STD_LOGIC_VECTOR(3 downto 0);
		variable z : UNSIGNED(5 downto 0);
	begin
		z := to_unsigned(divisor, z'length);
		t := "0000";
		n := unsigned(divident);
		for i in 0 to 5 loop
			if n >= z then
				n := n - z;
				t := t + '1';
			end if;
		end loop;
		q <= t;
		r <= std_logic_vector(n);
	end process;
	quotient <= q;
	remainder <= r(3 downto 0);
end Behavioral;