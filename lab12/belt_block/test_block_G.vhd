library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test_block_G is
end test_block_G;

architecture beh of test_block_G is
component block_G
  port(
    a:in std_logic_vector(31 downto 0);
    key:in std_logic_vector(31 downto 0);
    shift:in std_logic_vector(4 downto 0); 
    clk:in std_logic;
    b:out std_logic_vector(31 downto 0));
end component;
signal a,b,b1,temp,key,temp2:std_logic_vector(31 downto 0);
signal shift:std_logic_vector(4 downto 0);
signal clk:std_logic:='1';

begin
  a<=x"C8BA94B1";
  b1<=x"3BF5080A";
  key<=x"2CE7DEE9";
  shift<="00101";
  process(clk)
    begin
      clk<= not clk after 50 ns;
    end process;
  block1:block_G port map(a,key,shift,clk,b);
  temp<=b1 xor b;
end beh;
