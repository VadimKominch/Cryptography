library ieee;
use ieee.std_logic_1164.all;

entity writesignalreg is
  generic(
  Size:integer
  );
  port(
  a:in std_logic_vector(Size-1 downto 0);
  write:in std_logic;
  clk:in std_logic;
  reset:in std_logic;
  b:out std_logic_vector(Size-1 downto 0));
end writesignalreg;

architecture beh of writesignalreg is
begin
   process(clk,reset)
 begin
   if(reset = '1') then
     b<= (others =>'0');
  elsif(clk'event and clk='1') then
    if(write='1') then
    b<=a;
  end if;
  end if;
 end process;
end;
