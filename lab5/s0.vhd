library ieee;
use ieee.std_logic_1164.all;

entity s0 is
  port(
  a:in std_logic_vector(31 downto 0);
  b:out std_logic_vector(31 downto 0));
end s0;

architecture beh of s0 is
begin
  b<=(a(6 downto 0)&a(31 downto 7)) xor (a(17 downto 0)&a(31 downto 18)) xor ("000"&a(31 downto 3));
end beh;