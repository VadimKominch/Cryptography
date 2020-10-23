library ieee;
use ieee.std_logic_1164.all;

entity reg_with_init is
  generic(
  init_vector:std_logic_vector(31 downto 0)
  );
  port(
  a:in std_logic_vector(31 downto 0);
  clk:in std_logic;
  reset:in std_logic;
  b:out std_logic_vector(31 downto 0));
end reg_with_init;

architecture beh of reg_with_init is
begin
   process(clk,reset)
 begin
   if(reset = '1') then
     b<= init_vector;
  elsif(clk'event and clk='1') then
    b<=a;
  end if;
 end process;
end beh;
