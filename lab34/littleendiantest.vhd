library ieee;
use ieee.std_logic_1164.all;

entity littleendiantest is
end littleendiantest;

architecture beh of littleendiantest is

component littleendian
  port(
  a:in std_logic_vector(31 downto 0);
  b:out std_logic_vector(31 downto 0));
end component;

signal a,b:std_logic_vector(31 downto 0);

begin
a<=x"AABBCCDD";
l1:littleendian port map(a,b);  
end beh;