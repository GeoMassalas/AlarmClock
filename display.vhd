library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display is
    port(   clk  : in STD_LOGIC;
            reset : in STD_LOGIC;
            set_min,set_hrs : in STD_LOGIC;
            disp_out : out STD_LOGIC_VECTOR(6 downto 0);
            disp_enable : out STD_LOGIC_VECTOR(3 downto 0);
            seconds : out STD_LOGIC_VECTOR(5 downto 0));
end display;

architecture Behavioral of display is
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

-- Signals
signal temp1,temp2,temp3,temp4 : STD_LOGIC_VECTOR(6 downto 0);
signal sel : STD_LOGIC_VECTOR(1 downto 0);
signal min_clk1,temp_clk,sec_clk,min_clk,hrs_clk,sec_reset,min_reset,hrs_reset,hrs_clk1,hrs_clk2 : STD_LOGIC;
signal minutes,hours : std_logic_vector(5 downto 0);
signal disp1,disp2,disp3,disp4  : STD_LOGIC_VECTOR(3 downto 0);
signal db_min,db_hrs : std_logic;

begin
    DBM: debounce
        generic map (pulse => true, active_low => false, delay => 100000)
        port map (clk => clk, reset => reset, input => set_min, debounce => db_min);
    DBH: debounce
        generic map (pulse => true, active_low => false, delay => 100000)
        port map (clk => clk, reset => reset, input => set_hrs, debounce => db_hrs);
    FD: freq_div
        generic map(N=>210000)
        port map(clk_board => clk,clk_out => temp_clk);
    SEC: freq_div
        generic map(N=>50000000)
        port map(clk_board => clk,clk_out => sec_clk);
    D1:	bcddecoder 
        port map(input => disp1,output => temp1);
    D2:	bcddecoder 
        port map(input => disp2,output => temp2);
    D3:	bcddecoder 
        port map(input => disp3,output => temp3);
    D4:	bcddecoder 
        port map(input => disp4,output => temp4);
    COUNTER2: counter
        generic map(n=>2)
        port map(clk => temp_clk, reset => '0', output => sel);
    COUNTER_SEC: counter_time
        generic map(n=>6)
        port map(clk => sec_clk, reset => reset, output => seconds, output_flag => min_clk);
    MIN_MOD: mod10
        generic map(divisor=>10)
        port map(divident => minutes, quotient => disp2 , remainder => disp1);
    COUNTER_MIN: counter_time
        generic map(n=>6)
        port map(clk => min_clk1, reset => reset, output => minutes, output_flag => hrs_clk1);
    min_clk1 <= min_clk XOR db_min;
    HRS_MOD: mod10
        generic map(divisor=>10)
        port map(divident => hours, quotient => disp4 , remainder => disp3);
    COUNTER_HRS: counter_time_hrs
        generic map(n=>6)
        port map(clk => hrs_clk, reset => reset, output => hours, output_flag => hrs_clk2);
    hrs_clk <=  hrs_clk1 XOR db_hrs;
    MUX7: mux_4_to_1_7
        port map(sel => sel,D1 => temp1, D2 => temp2, D3 => temp3, D4 => temp4, Y => disp_out);
    DEMUX: demux_4_to_1
        port map(sel => sel, Y => disp_enable);
end Behavioral;