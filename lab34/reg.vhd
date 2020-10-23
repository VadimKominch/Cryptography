library ieee;
use ieee.std_logic_1164.all;

entity reg is
  generic(
  Size:integer
  );
  port(
  a:in std_logic_vector(Size-1 downto 0);
  clk:in std_logic;
  reset:in std_logic;
  b:out std_logic_vector(Size-1 downto 0));
end reg;

architecture beh of reg is
begin
   process(clk,reset)
 begin
   if(reset = '1') then
     b<= (others =>'0');
  elsif(clk'event and clk='1') then
    b<=a;
  end if;
 end process;
end beh;