library ieee;
use ieee.std_logic_1164.all;

entity rowroundtest is
end rowroundtest;

architecture beh of rowroundtest is
component rowround
  port(
    y:in std_logic_vector(511 downto 0);
    clk:in std_logic;
    reset:in std_logic;
    z:out std_logic_vector(511 downto 0));
end component;

signal a,b:std_logic_vector(511 downto 0);
signal clk:std_logic:='0';
signal reset:std_logic;

begin
  reset<='0';
  clk<=not clk after 25 ns;
  a<=x"00000001000000000000000000000000000000010000000000000000000000000000000100000000000000000000000000000001000000000000000000000000",
     x"08521bd61fe88837bb2aa5763aa26365c54c6a5b2fc74c2f6dd39cc3da0a64f690a2f23d067f95a606b35f6141e4732ee859c100ea4d84b70f619bffbc6e965a" after 200 ns;
  r1:rowround port map(a,clk,reset,b);
end beh;
