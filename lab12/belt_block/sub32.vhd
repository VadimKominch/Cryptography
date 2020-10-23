library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sub32 is
port(
a:in std_logic_vector(31 downto 0);
b:in std_logic_vector(31 downto 0);
c:out std_logic_vector(31 downto 0));
end sub32;

architecture beh of sub32 is
begin
  c<= a - b;
end beh;
