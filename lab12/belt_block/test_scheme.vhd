library ieee;
use ieee.std_logic_1164.all;

entity test_scheme is
end test_scheme;

architecture beh of test_scheme is
component scheme
port(
  input_message:in std_logic_vector(127 downto 0);
  key:in std_logic_vector(255 downto 0);
  clk:in std_logic;
  start:in std_logic;
  reset:in std_logic;
  done:out std_logic;
  output_message:out std_logic_vector(127 downto 0));
end component;

signal input,output:std_logic_vector(127 downto 0);
signal key:std_logic_vector(255 downto 0);
signal clk:std_logic:='0';
signal start,done,reset:std_logic;

begin
  process(clk)
  begin
    clk<=not clk after 25 ns;
  end process;
  start<='0',
        '1' after 50 ns,
        '0' after 70 ns;
  reset<='0',
  '1' after 25 ns,
  '0' after 40 ns;
  input<=x"B194BAC80A08F53B366D008E584A5DE4";
  key<=x"E9DEE72C8F0C0FA62DDB49F46F73964706075316ED247A3739CBA38303A98BF6";
  p1:scheme port map(input,key,clk,start,reset,done,output);
end beh;
