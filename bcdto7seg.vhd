library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity bcddecoder is
	port(   input : in STD_LOGIC_VECTOR(3 downto 0);
			output : out STD_LOGIC_VECTOR(6 downto 0));
end bcddecoder;

architecture Behavioral of bcddecoder is

begin
    process(input)
    begin
        case input is
		  when "0000" => output <= B"0000001"; 	-- 0
		  when "0001" => output <= B"1001111";  -- 1
		  when "0010" => output <= B"0010010"; -- 2
		  when "0011" => output <= B"0000110";  -- 3
		  when "0100" => output <= B"1001100"; -- 4
	      when "0101" => output <= B"0100100"; -- 5
		  when "0110" => output <= B"0100000"; -- 6
		  when "0111" => output <= B"0001111"; -- 7
		  when "1000" => output <= B"0000000"; -- 8
		  when "1001" => output <= B"0000100"; -- 9
		  when others => output <= B"1111111";
		 end case;
    end process;
end Behavioral;
