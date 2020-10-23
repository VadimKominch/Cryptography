library ieee;
use ieee.std_logic_1164.all;

entity littleendian is
  port(
  a:in std_logic_vector(31 downto 0);
  b:out std_logic_vector(31 downto 0));
end littleendian;

architecture beh of littleendian is
begin
 b<=a(7 downto 0)&a(15 downto 8)&a(23 downto 16)&a(31 downto 24); 
end beh;