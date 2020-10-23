library ieee;
use ieee.std_logic_1164.all;

entity test_core is
end test_core;

architecture beh of test_core is

component core
  port(
  input:in std_logic_vector(511 downto 0);
  reset:in std_logic;
  clk:in std_logic;
  ready:out std_logic;
  output:out std_logic_vector(255 downto 0));
end component;

signal output:std_logic_vector(255 downto 0);
signal input:std_logic_vector(511 downto 0);
signal clk:std_logic:='0';
signal reset,ready:std_logic;

begin
  input<=x"61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018";
  clk<= not clk after 25 ns;
  reset<='0',
  '1' after 30 ns,
  '0' after 50 ns;
c1:core port map(input,reset,clk,ready,output);
end beh;