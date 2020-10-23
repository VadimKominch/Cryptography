library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity xor32 is
port(
a:in std_logic_vector(31 downto 0);
b:in std_logic_vector(31 downto 0);
c:out std_logic_vector(31 downto 0));
end xor32;

architecture beh of xor32 is
begin
  c<= a xor b;
end beh;