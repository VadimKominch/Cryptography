library ieee;
use ieee.std_logic_1164.all;

entity doubleroundtest is
end doubleroundtest;

architecture beh of doubleroundtest is

component doubleround
  port(
  a:in std_logic_vector(511 downto 0);
  clk:in std_logic;
  reset:in std_logic;
  b:out std_logic_vector(511 downto 0));
end component;

signal a,b:std_logic_vector(511 downto 0);
signal clk:std_logic:='0';
signal reset:std_logic;

begin
  reset<='0';
  clk<=not clk after 25 ns;
  a<=x"00000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
     x"de5010666f9eb8f7e4fbbd9b454e3f57b75540d343e93a4c3a6f2aa0726d6b369243f4849145d1e84fa9d247dc8dee11054bf545254dd653d9421b6d67b276c1" after 400 ns;
d1:doubleround port map(a,clk,reset,b);
--assert () report "" severity note;
end beh;
