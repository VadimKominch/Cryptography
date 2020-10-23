library ieee;
use ieee.std_logic_1164.all;

entity doubleround is
  port(
  a:in std_logic_vector(511 downto 0);
  clk:in std_logic;
  reset:in std_logic;
  b:out std_logic_vector(511 downto 0));
end doubleround;

architecture beh of doubleround is

component columnround
  port(
    y:in std_logic_vector(511 downto 0);
    clk:in std_logic;
    reset:in std_logic;
    z:out std_logic_vector(511 downto 0));
end component;

component rowround
  port(
    y:in std_logic_vector(511 downto 0);
    clk:in std_logic;
    reset:in std_logic;
    z:out std_logic_vector(511 downto 0));
end component;

signal cls:std_logic_vector(511 downto 0);

begin
c1:columnround port map(a,clk,reset,cls);
r1:rowround port map(cls,clk,reset,b);  
end beh;
