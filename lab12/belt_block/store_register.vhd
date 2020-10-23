library ieee;
use ieee.std_logic_1164.all;

entity store_register is
  port(
  input:in std_logic_vector(31 downto 0);
  clk:in std_logic;
  reset:in std_logic;
  output:out std_logic_vector(31 downto 0));
end store_register;

architecture beh of store_register is
begin
 process(clk,reset)
 begin
   if(reset = '1') then
     output<= (others =>'0');
  elsif(clk'event and clk='1') then
    output<=input;
  end if;
 end process; 
end beh;

