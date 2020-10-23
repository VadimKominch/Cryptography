library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity testSalsa20 is
end testSalsa20;

architecture beh of testSalsa20 is

component Salsa20
  port(
  a:in std_logic_vector(511 downto 0);
  clk:in std_logic;
  reset:in std_logic;
  ready:out std_logic;
  b:out std_logic_vector(511 downto 0));
end component;

signal a,b:std_logic_vector(511 downto 0);
signal clk:std_logic:='0';
signal reset,ready:std_logic;

begin
  reset<='0',
  '1' after 10 ns,
  '0' after 20 ns;
  clk<=not clk after 25 ns;
  a<=x"D39F0D734C3752B70375DE25BFBBEA8831EDB330016AB2DBAFC7A6305610B3CF1FF0203F0F535DA174933071EE37CC244FC9EB4F03519C2FCB1AF4F358766836";
  Salsa1:Salsa20 port map(a,clk,reset,ready,b);
  process(ready)
  variable row:line;
  file input: text;
    begin
  file_open(input,"D:\PKdlyaSIB\lab2\input.txt",WRITE_MODE);
  if(ready='1' and ready'event) then
  hwrite(row,b);
  writeline(input,row);
  file_close(input);
  end if;
    end process;
end beh;