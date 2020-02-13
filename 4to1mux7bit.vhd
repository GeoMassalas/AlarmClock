library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_4_to_1_7 is
	port(   sel : in STD_LOGIC_VECTOR(1 downto 0); -- sel(0)-switch2 / sel(1)-switch3
			D1,D2,D3,D4 : in STD_LOGIC_VECTOR(6 downto 0);
			Y : out STD_LOGIC_VECTOR(6 downto 0));
end mux_4_to_1_7;

architecture Behavioral of mux_4_to_1_7 is
begin
	Y <=    D1 when sel = "00" else
			D2 when sel = "01" else
			D3 when sel = "10" else
			D4 when sel = "11" ;
end Behavioral;