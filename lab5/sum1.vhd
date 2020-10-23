library ieee;
use ieee.std_logic_1164.all;

entity sum1 is
  port(
  a:in std_logic_vector(31 downto 0);
  b:out std_logic_vector(31 downto 0)
  );
end sum1;

architecture beh of sum1 is
begin
 --BSIG1(x) = ROTR^6(x) XOR ROTR^11(x) XOR ROTR^25(x)
 b<=(a(5 downto 0)&a(31 downto 6)) xor (a(10 downto 0)&a(31 downto 11)) xor (a(24 downto 0)&a(31 downto 25));
end beh;