library ieee;
use ieee.std_logic_1164.all;


entity display_tb is
end display_tb;

architecture tb of display_tb is
    component display
    port(
        disp1,disp2,disp3,disp4  : in STD_LOGIC_VECTOR(3 downto 0);
        clk  : in STD_LOGIC;
        disp_out : out STD_LOGIC_VECTOR(6 downto 0);
        disp_enable : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    -- Inputs
    signal disp1 : std_logic_vector(3 downto 0) := B"0000";
    signal disp2 : std_logic_vector(3 downto 0) := B"0001";
    signal disp3 : std_logic_vector(3 downto 0) := B"0011";
    signal disp4 : std_logic_vector(3 downto 0) := B"0100";
    signal clk   : std_logic := '0';
    -- Outputs
    signal disp_out : std_logic_vector(6 downto 0);
    signal disp_enable : std_logic_vector(3 downto 0);
begin

    uut: display port map (
        disp1 => disp1,
        disp2 => disp2,
        disp3 => disp3,
        disp4 => disp4,
        clk => clk,
        disp_out => disp_out,
        disp_enable => disp_enable
      );
    
    clkk : process
    constant clk_period: time := 8 ms;
    begin
        clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
    end process;

end tb;