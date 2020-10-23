library ieee;
use ieee.std_logic_1164.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity test_miner is
end test_miner;

architecture beh of test_miner is
component miner
  port(
  version:in std_logic_vector(31 downto 0);
  hash_prev_block:in std_logic_vector(255 downto 0);
  hash_merkle_root:in std_logic_vector(255 downto 0);
  time_stamp:in std_logic_vector(31 downto 0);
  target:in std_logic_vector(31 downto 0);
  zeros:in std_logic_vector(7 downto 0);
  first:out std_logic;
  nonce_first:out std_logic_vector(31 downto 0);
  second:out std_logic;
  nonce_second:out std_logic_vector(31 downto 0);
  third:out std_logic;
  nonce_third:out std_logic_vector(31 downto 0);
  fourth:out std_logic;
  nonce_fourth:out std_logic_vector(31 downto 0);
  clk:in std_logic;
  start:in std_logic;
  hash:out std_logic_vector(255 downto 0));
end component;

signal version,time_stamp,target,nonce1,nonce2,nonce3,nonce4:std_logic_vector(31 downto 0);
signal hash_prev_block,hash_merkle_root,hash:std_logic_vector(255 downto 0);
signal zeros:std_logic_vector(7 downto 0);
signal start,ready1,ready2,ready3,ready4:std_logic;
signal clk:std_logic:='0';

begin
  clk<= not clk after 5 ns;
  start<='0',
  '1' after 5 ns,
  '0' after 10 ns;
  version<=x"01000000";
  time_stamp<=x"b575d949";
  target<=x"ffff001d";
  zeros<="00100000";
  hash_prev_block<=x"a7c3299ed2475e1d6ea5ed18d5bfe243224add249cce99c5c67cc9fb00000000";
  hash_merkle_root<=x"601c73862a0a7238e376f497783c8ecca2cf61a4f002ec8898024230787f399c";
m1:miner port map(version,hash_prev_block,hash_merkle_root,time_stamp,target,zeros,ready1,nonce1,ready2,nonce2,ready3,nonce3,ready4,nonce4,clk,start,hash);

--process(ready)
--  variable row:line;
--  file input: text;
--    begin
--  file_open(input,"D:\PKdlyaSIB\lab4\input.txt",WRITE_MODE);
--  if(ready='1' and ready'event) then
--  hwrite(row,hash);
--  writeline(input,row);
--  file_close(input);
--  end if;
--    end process;
end beh;
