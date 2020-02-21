library IEEE;
use ieee.std_logic_1164.all;

package components is
    -- 2 bit counter Component
    component counter is
        generic(n: natural := 2);
        port (clk: in STD_LOGIC;
                reset : in std_logic;
                output : out STD_LOGIC_VECTOR(n-1 downto 0));
    end component;
    -- sec/min counter components
    component counter_time is
        generic(n: natural := 2);
        port (clk: in STD_LOGIC;
                reset : in std_logic;
                output : out STD_LOGIC_VECTOR(n-1 downto 0);
                output_flag : out STD_LOGIC);
    end component;
    -- hrs counter component
    component counter_time_hrs is
        generic(n: natural := 2);
        port (clk: in STD_LOGIC;
                reset : in std_logic;
                output : out STD_LOGIC_VECTOR(n-1 downto 0);
                output_flag : out STD_LOGIC);
    end component;
    -- 7bit multiplexer
    component mux_4_to_1_7 is
        port(   sel : in STD_LOGIC_VECTOR(1 downto 0); 
                D1,D2,D3,D4 : in STD_LOGIC_VECTOR(6 downto 0);
                Y : out STD_LOGIC_VECTOR(6 downto 0));
    end component;
    -- demultiplexer 4 to 1
    component demux_4_to_1 is
        port(  sel : in STD_LOGIC_VECTOR(1 downto 0); 
                Y  : out STD_LOGIC_VECTOR(3 downto 0));
    end component;
    -- bcd to 7seg decoder
    component bcddecoder is
        port(   input : in STD_LOGIC_VECTOR(3 downto 0);
                output : out STD_LOGIC_VECTOR(6 downto 0));
    end component;
    -- Frequency Divider
    component freq_div is
        generic (N:positive:=1);
        port(clk_board : in STD_LOGIC;
                clk_out : out STD_LOGIC);
    end component;
    -- mod10 component
    component mod10 is
        generic(divisor : integer := 10);
        port(divident : in STD_LOGIC_VECTOR(5 downto 0);
                quotient : out STD_LOGIC_VECTOR(3 downto 0);
                remainder : out STD_LOGIC_VECTOR(3 downto 0));
    end component;
    -- debounce component
    component debounce is
        generic(
            pulse: boolean := true;
            active_low: boolean := true;
            delay: integer := 100000);
        port (
            clk: in std_logic;
            reset: in std_logic; -- active low
            input: in std_logic;
            debounce: out std_logic);
    end component;

end package ;

----------------------------------------------------------------------
-- Component    : bcddecoder
-- Usage        : binary to 7seg decimal decoder 
----------------------------------------------------------------------
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

----------------------------------------------------------------------
-- Component    : mod10
-- Usage        : division by 10 in order to 
----------------------------------------------------------------------
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

----------------------------------------------------------------------
-- Component    : demux_4_to_1
-- Usage        : Simple demultiplexer to run the 7segment diplay
----------------------------------------------------------------------
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

----------------------------------------------------------------------
-- Component    : mux_4_to_1_7
-- Usage        : Simple multiplexer to run the 7segment diplay
----------------------------------------------------------------------
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

----------------------------------------------------------------------
-- Component    : counter_time_hrs
-- Usage        : counter for hrs
----------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity counter_time_hrs is
    generic(n: natural := 2);
    port (clk: in STD_LOGIC;
            reset : in std_logic;
			output : out STD_LOGIC_VECTOR(n-1 downto 0);
			output_flag : out STD_LOGIC);
end counter_time_hrs;

architecture Behavioral of counter_time_hrs is
    signal temp : STD_LOGIC_VECTOR(n-1 downto 0) := (others => '0');
    signal limit : STD_LOGIC_VECTOR(n-1 downto 0) := B"010111";
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

----------------------------------------------------------------------
-- Component    : counter_time
-- Usage        : counter for mins and seconds
----------------------------------------------------------------------
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

----------------------------------------------------------------------
-- Component    : counter
-- Usage        : general purpose countner
----------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity counter is
    generic(n: natural := 2);   -- bits of the counter
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

----------------------------------------------------------------------
-- Component    : debounce
-- Usage        : generic button debounce
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce is
    generic(
        pulse: boolean := true;         -- will the output be pulse or no
        active_low: boolean := true;    -- button active low or active high
        delay: integer := 100000);
    port (
        clk: in std_logic;
        reset: in std_logic; -- active high
        input: in std_logic;
        debounce: out std_logic);
end debounce ;

architecture arch of debounce is
    signal sample: std_logic_vector(9 downto 0) := "0001111000";
    signal sample_pulse: std_logic := '0';

begin

    process(clk) -- clock Divider
        variable count: integer := 0;
    begin  
        if clk'event and clk = '1' then
            if reset = '1' then
                count := 0;
                sample_pulse <= '0';
            else
                if count < delay then
                    count := count + 1;
                    sample_pulse <= '0';
                else
                    count := 0;
                    sample_pulse <= '1';
                end if;
            end if;
        end if;
    end process;

    process(clk) -- sampling process
    begin
        if clk'event and clk = '1' then
            if reset = '1' then
                sample <= (others => input);
            else
                if sample_pulse = '1' then
                    sample(9 downto 1) <= sample(8 downto 0);
                    sample(0) <= input;
                end if;
            end if;
        end if;
    end process;
    
    process(clk) -- button debouncing
        variable flag: std_logic := '0';
    begin
        if clk'event and clk = '1' then
            if reset = '1' then
                debounce <= '0';
            else
                if active_low then
                    if pulse then
                        if sample = "0000000000" then -- active low pulse out
                            if flag = '0' then
                                debounce <= '1';
                                flag := '1';
                            else
                                debounce <= '0';
                            end if;
                        else
                            debounce <= '0';
                            flag := '0';
                        end if;
                    else
                        if sample = "0000000000" then   -- active low constant out
                            debounce <= '1';
                        elsif sample = "1111111111" then
                            debounce <= '0';
                        end if;
                    end if;
                else
                    if pulse then
                        if sample = "1111111111" then -- active high pulse out
                            if flag = '0' then
                                debounce <= '1';
                                flag := '1';
                            else
                                debounce <= '0';
                            end if;
                        else
                            debounce <= '0';
                            flag := '0';
                        end if;
                    else
                        if sample = "1111111111" then   -- active high constant out
                            debounce <= '1';
                        elsif sample = "0000000000" then
                            debounce <= '0';
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
end architecture ;

----------------------------------------------------------------------
-- Component    : debounce
-- Usage        : on-board clock division
----------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity freq_div is
	generic (N:positive:=1);
	port(   clk_board : in STD_LOGIC;
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