library ieee;
use ieee.std_logic_1164.all;

entity ma is
port(
x:in std_logic_vector(31 downto 0);
y:in std_logic_vector(31 downto 0);
z:in std_logic_vector(31 downto 0);
b:out std_logic_vector(31 downto 0)
);
end ma;

architecture beh of ma is
begin
b<=(x and y) xor (x and z) xor (y and z);
end beh;
