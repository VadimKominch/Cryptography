library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity expander is
  port(
  word:in std_logic_vector(511 downto 0);
  clk:in std_logic;
  output:out std_logic_vector(511 downto 0);
  output_word:out std_logic_vector(31 downto 0));
end expander;


architecture beh of expander is

component s0
port(
  a:in std_logic_vector(31 downto 0);
  b:out std_logic_vector(31 downto 0));
end component;

component s1
port(
  a:in std_logic_vector(31 downto 0);
  b:out std_logic_vector(31 downto 0));
end component;

component reg
generic(
  Size:integer
  );
port(
  a:in std_logic_vector(Size-1 downto 0);
  clk:in std_logic;
  reset:in std_logic;
  b:out std_logic_vector(Size-1 downto 0));
end component;

signal temp:std_logic_vector(511 downto 0);
signal temp_sum1,temp_sum2,temp_sum3,out_s1,out_s0:std_logic_vector(31 downto 0);


begin
regX:reg generic map(512) port map(word,clk,'0',temp);
s_1:s1 port map(temp(63 downto 32),out_s1);
s_0:s0 port map(temp(479 downto 448),out_s0);
temp_sum1<=temp(511 downto 480)+out_s1;
temp_sum2<=temp_sum1+out_s0;
temp_sum3<=temp(223 downto 192)+temp_sum2;--t-7
output<=temp(479 downto 0)&temp_sum3;
output_word<=temp(511 downto 480);

  
end beh;