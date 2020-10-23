library ieee;
use ieee.std_logic_1164.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity doubleroundsecondtest is
end doubleroundsecondtest;

architecture beh of doubleroundsecondtest is

component doubleround
  port(
  a:in std_logic_vector(511 downto 0);
  clk:in std_logic;
  reset:in std_logic;
  b:out std_logic_vector(511 downto 0));
end component;

signal a,b:std_logic_vector(511 downto 0);
signal clk:std_logic:='0';
signal reset:std_logic;

begin
  reset<='0';
  clk<=not clk after 25 ns;
  a<=x"7D1FCA609747013A58B04AFE06268882E36A3D21C8B07DFB47C7CCBC3CD24CF011C48A65427C3917DFA3651DA80B83BF5AB9A249AE8F64333AC65D5C0C7DB293";
d1:doubleround port map(a,clk,reset,b);
process(b)
  variable row:line;
  file input: text;
    begin
  file_open(input,"D:\PKdlyaSIB\lab2\input.txt",WRITE_MODE);
  hwrite(row,b);
  writeline(input,row);
  file_close(input);
    end process;

end beh;
