library ieee;
use ieee.std_logic_1164.all;

entity sum0 is
port(
a:in std_logic_vector(31 downto 0);
b:out std_logic_vector(31 downto 0)
);
end sum0;

architecture beh of sum0 is
begin
  --BSIG0(x) = ROTR^2(x) XOR ROTR^13(x) XOR ROTR^22(x)
b<=(a(1 downto 0)&a(31 downto 2)) xor (a(12 downto 0)&a(31 downto 13)) xor (a(21 downto 0)&a(31 downto 22));
end beh;
