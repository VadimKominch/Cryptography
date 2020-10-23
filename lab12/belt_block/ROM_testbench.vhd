library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ROM_testbench is
end ROM_testbench;


architecture beh of ROM_testbench is 

component ROM
port(
    addr:in std_logic_vector(7 downto 0);
    clk:in std_logic;
    output:out std_logic_vector(7 downto 0));
end component;

signal clk:std_logic:='0';
signal addr,output:std_logic_vector(7 downto 0);

begin
process(clk)
  begin
    clk<=not clk after 25 ns;
  end process;
  addr<=x"00",
        x"01" after 50 ns,
        x"02" after 100 ns,
        x"03" after 150 ns,
        x"04" after 200 ns,
        x"05" after 250 ns,
        x"06" after 300 ns,
        x"07" after 350 ns,
        x"08" after 400 ns,
        x"09" after 450 ns,
        x"0A" after 500 ns,
        x"0B" after 550 ns,
        x"0C" after 600 ns,
        x"0D" after 650 ns,
        x"0E" after 700 ns,
        x"0F" after 750 ns,
        x"10" after 800 ns,
        x"11" after 850 ns;
  rom_1:ROM port map(addr,clk,output);
end beh;