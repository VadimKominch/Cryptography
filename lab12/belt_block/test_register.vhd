library ieee;
use ieee.std_logic_1164.all;

entity test_register is
end test_register;

architecture beh of test_register is

component store_register 
  port(
  input:in std_logic_vector(31 downto 0);
  clk:in std_logic;
  reset:in std_logic;
  output:out std_logic_vector(31 downto 0));
end component;

signal input,output:std_logic_vector(31 downto 0);
signal reset:std_logic;
signal clk:std_logic:='0';
begin
  process(clk)
    begin
      clk<= not clk after 25 ns;
    end process;
input<=x"AAAAAAAA",
       x"BBBBBBBB" after 25 ns; 
    reset<='0',
    '1' after 10 ns,
    '0' after 15 ns;
    reg1:store_register port map(input,clk,reset,output); 
end beh;