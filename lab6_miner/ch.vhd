library ieee;
use ieee.std_logic_1164.all;

entity ch is
  port(
  x:in std_logic_vector(31 downto 0);
  y:in std_logic_vector(31 downto 0);
  z:in std_logic_vector(31 downto 0);
  output:out std_logic_vector(31 downto 0)
  );
end ch;

architecture beh of ch is
begin
  --three stages of logic gates
  output<=(x and y) xor ( (not x) and z);
end beh;
