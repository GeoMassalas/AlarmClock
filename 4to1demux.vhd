-- Simple demultiplexer to run the 7segment diplay
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity demux_4_to_1 is
	port(sel : in STD_LOGIC_VECTOR(1 downto 0); 
			Y : out STD_LOGIC_VECTOR(3 downto 0));
end demux_4_to_1;

architecture Behavioral of demux_4_to_1 is
begin
    Y <=    B"1110" when sel = "00" else
            B"1101" when sel = "01" else
            B"0111" when sel = "11" else
            B"1011" when sel = "10" ;
end Behavioral;