library ieee;
use ieee.std_logic_1164.all;

entity test_counter is
end test_counter;

architecture beh of test_counter is
component counter
    port(
  clk:in std_logic;
  start:in std_logic;
  reset:in std_logic;
  number:out std_logic_vector(31 downto 0);
  done:out std_logic);
  end component;
  
  signal start,reset,done:std_logic;
  signal clk:std_logic:='0';
  signal number:std_logic_vector(31 downto 0);
begin
  process(clk)
    begin
      clk<=not clk after 25 ns;
      end process;
      
  reset<='0',
  '1' after 10 ns,
  '0' after 20 ns;
  start<='0',
    '1' after 70 ns,
    '0' after 80 ns,
    '1' after 125 ns,
    '0' after 150 ns;
  count1:counter port map(clk,start,reset,number,done);
end beh;
