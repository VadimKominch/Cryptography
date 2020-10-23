library ieee;
use ieee.std_logic_1164.all;

entity s1 is
  port(
  a:in std_logic_vector(31 downto 0);
  b:out std_logic_vector(31 downto 0));
end s1;

architecture beh of s1 is
begin
  b<=(a(16 downto 0)&a(31 downto 17)) xor (a(18 downto 0)&a(31 downto 19)) xor ("0000000000"&a(31 downto 10));
end beh;