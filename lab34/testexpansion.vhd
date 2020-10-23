library ieee;
use ieee.std_logic_1164.all;

entity testexpansion is
end testexpansion;

architecture beh of testexpansion is

component expansion
  port(
    k:in std_logic_vector(255 downto 0);
    n:in std_logic_vector(127 downto 0);
    v:in std_logic;--choice between 16-byte k ad 32-byte k
    clk:in std_logic;
    reset:in std_logic;
    ready:out std_logic;
    output:out std_logic_vector(511 downto 0));
end component;

signal k:std_logic_vector(255 downto 0);
signal n:std_logic_vector(127 downto 0);
signal v,reset,ready:std_logic;
signal clk:std_logic:='0';
signal output:std_logic_vector(511 downto 0);

begin
  reset<='0',
  '1' after 10 ns,
  '0' after 20 ns;
  clk<=not clk after 25 ns;
  k<=x"0102030405060708090A0B0C0D0E0F100102030405060708090A0B0C0D0E0F10";
  n<=x"65666768696A6B6C6D6E6F7071727374";
  v<='1';
  exp1:expansion port map(k,n,v,clk,reset,ready,output);
end beh;
