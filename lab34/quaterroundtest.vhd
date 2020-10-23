library ieee;
use ieee.std_logic_1164.all;

entity quaterroundtest is
end quaterroundtest;

architecture uut of quaterroundtest is
component quaterround
    port(
    y:in std_logic_vector(127 downto 0);
    clk:in std_logic;
    reset:in std_logic;
    z:out std_logic_vector(127 downto 0));
end component;

signal a,b:std_logic_vector(127 downto 0);
signal clk:std_logic:='0';
signal reset:std_logic;

begin
  reset<='0';
  clk<=not clk after 25 ns;
  a<=x"00000001000000000000000000000000" after 200 ns,
     x"e7e8c006c4f9417d6479b4b268c67137" after 400 ns,
     x"d3917c5b55f1c40752a58a7a8f887a3b" after 600 ns;
  q1:quaterround port map(a,clk,reset,b);
end uut;
