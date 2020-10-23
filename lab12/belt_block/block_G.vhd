library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity block_G is
  port(
    a:in std_logic_vector(31 downto 0);
    key:in std_logic_vector(31 downto 0);
    shift:in std_logic_vector(4 downto 0); 
    clk:in std_logic;
    b:out std_logic_vector(31 downto 0));
end block_G;

architecture beh of block_G is
component ROM
port(
    addr:in std_logic_vector(7 downto 0);
    clk:in std_logic;
    output:out std_logic_vector(7 downto 0));
end component;
signal temp:std_logic_vector(31 downto 0);
signal addr:std_logic_vector(31 downto 0);
begin
  addr <= a + key;
  ROM1:ROM port map(addr(31 downto 24),clk,temp(31 downto 24));
  ROM2:ROM port map(addr(23 downto 16),clk,temp(23 downto 16));
  ROM3:ROM port map(addr(15 downto 8),clk,temp(15 downto 8));
  ROM4:ROM port map(addr(7 downto 0),clk,temp(7 downto 0));
  b<=temp(31-to_integer(unsigned(shift)) downto 0) & temp(31 downto 32-to_integer(unsigned(shift)));
end beh;