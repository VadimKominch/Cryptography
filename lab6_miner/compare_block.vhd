library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity compare_block is
  port(
  input:in std_logic_vector(255 downto 0);
  shift:in std_logic_vector(7 downto 0);
  output:out std_logic);
end compare_block;

architecture beh of compare_block is

signal ones:std_logic_vector(255 downto 0):=x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
signal shifted:std_logic_vector(255 downto 0);
signal temp_sum:std_logic_vector(256 downto 0);

begin  
shifted<=shl(ones,256-shift);
temp_sum<='0'&shifted+input;
output<=not temp_sum(256);
end beh;