library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity core is
  port(
  input:in std_logic_vector(511 downto 0);
  iv:in std_logic_vector(255 downto 0);
  reset:in std_logic;
  clk:in std_logic;
  ready:out std_logic;
  output:out std_logic_vector(255 downto 0));
end core;

architecture beh of core is
--pipeline architecture

component sha_cell
  port(
  input_1_for_iter:in std_logic_vector(31 downto 0);
  input_2_for_iter:in std_logic_vector(31 downto 0);
  input_3_for_iter:in std_logic_vector(31 downto 0);
  input_4_for_iter:in std_logic_vector(31 downto 0);
  input_5_for_iter:in std_logic_vector(31 downto 0);
  input_6_for_iter:in std_logic_vector(31 downto 0);
  input_7_for_iter:in std_logic_vector(31 downto 0);
  input_8_for_iter:in std_logic_vector(31 downto 0);
  words:in std_logic_vector(511 downto 0);
  addr:in std_logic_vector(5 downto 0);
  clk:in std_logic;
  output_1_from_iter:out std_logic_vector(31 downto 0);
  output_2_from_iter:out std_logic_vector(31 downto 0);
  output_3_from_iter:out std_logic_vector(31 downto 0);
  output_4_from_iter:out std_logic_vector(31 downto 0);
  output_5_from_iter:out std_logic_vector(31 downto 0);
  output_6_from_iter:out std_logic_vector(31 downto 0);
  output_7_from_iter:out std_logic_vector(31 downto 0);
  output_8_from_iter:out std_logic_vector(31 downto 0);
  words_out:out std_logic_vector(511 downto 0));
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

type words_arr is array (0 to 64) of std_logic_vector(511 downto 0);
type iter_arr is array (0 to 64) of std_logic_vector(31 downto 0);
type memory is array ( 0 to 63 ) of std_logic_vector(5 downto 0 ) ;

signal words:words_arr;

constant num :memory := (
0 => "000000",
1 => "000001",
2 => "000010",
3 => "000011",
4 => "000100",
5 => "000101",
6 => "000110",
7 => "000111",
8 => "001000",
9 => "001001",
10 =>"001010",
11 => "001011",
12 => "001100",
13 => "001101",
14 => "001110",
15 => "001111",
16 => "010000",
17 => "010001",
18 => "010010",
19 => "010011",
20 => "010100",
21 => "010101",
22 => "010110",
23 => "010111",
24 => "011000",
25 => "011001", 
26 => "011010",
27 => "011011",
28 => "011100", 
29 => "011101", 
30 => "011110", 
31 => "011111",
32 => "100000", 
33 => "100001", 
34 => "100010", 
35 => "100011", 
36 => "100100", 
37 => "100101", 
38 => "100110", 
39 => "100111",
40 => "101000", 
41 => "101001", 
42 => "101010", 
43 => "101011", 
44 => "101100", 
45 => "101101", 
46 => "101110", 
47 => "101111",
48 => "110000", 
49 => "110001", 
50 => "110010", 
51 => "110011", 
52 => "110100", 
53 => "110101", 
54 => "110110", 
55 => "110111",
56 => "111000", 
57 => "111001", 
58 => "111010", 
59 => "111011", 
60 => "111100", 
61 => "111101", 
62 => "111110", 
63 => "111111");

signal input1,input2,input3,input4,input5,input6,input7,input8:iter_arr;
signal output1,output2,output3,output4,output5,output6,output7,output8:std_logic_vector(31 downto 0);
signal a,b,c,d,e,f,g,h:std_logic_vector(31 downto 0);
signal count:std_logic_vector(6 downto 0);
begin
   counter:process(reset,clk)
  begin
    if(reset='1' and reset'event) then
      count<="0000000";
    elsif(clk='1' and clk'event) then
    if(count="1000000") then
      ready<='1';
    else
      count<=count+1;
      ready<='0';
    end if;
    end if;
  end process;
  input1(0)<=iv(255 downto 224);
  input2(0)<=iv(223 downto 192);
  input3(0)<=iv(191 downto 160);
  input4(0)<=iv(159 downto 128);
  input5(0)<=iv(127 downto 96);
  input6(0)<=iv(95 downto 64);
  input7(0)<=iv(63 downto 32);
  input8(0)<=iv(31 downto 0);
  words(0)<=input;  
  cell:for i in 0 to 63 generate 
  sha_cell1:sha_cell port map(input1(i),input2(i),input3(i),input4(i),input5(i),input6(i),input7(i),input8(i),words(i),num(i),clk,input1(i+1),input2(i+1),input3(i+1),input4(i+1),input5(i+1),input6(i+1),input7(i+1),input8(i+1),words(i+1));
end generate cell;

--regA:reg generic map(32) port map(input1(64),clk,'0',a);
--regB:reg generic map(32) port map(input2(64),clk,'0',b);
--regC:reg generic map(32) port map(input3(64),clk,'0',c);
--regD:reg generic map(32) port map(input4(64),clk,'0',d);
--regE:reg generic map(32) port map(input5(64),clk,'0',e);
--regF:reg generic map(32) port map(input6(64),clk,'0',f);
--regG:reg generic map(32) port map(input7(64),clk,'0',g);
--regH:reg generic map(32) port map(input8(64),clk,'0',h);

output1<=input1(64)+iv(255 downto 224);
output2<=input2(64)+iv(223 downto 192);
output3<=input3(64)+iv(191 downto 160);
output4<=input4(64)+iv(159 downto 128);
output5<=input5(64)+iv(127 downto 96);
output6<=input6(64)+iv(95 downto 64);
output7<=input7(64)+iv(63 downto 32);
output8<=input8(64)+iv(31 downto 0);
--output1<=a+iv(255 downto 224);
--output2<=b+iv(223 downto 192);
--output3<=c+iv(191 downto 160);
--output4<=d+iv(159 downto 128);
--output5<=e+iv(127 downto 96);
--output6<=f+iv(95 downto 64);
--output7<=g+iv(63 downto 32);
--output8<=h+iv(31 downto 0);
output<=output1&output2&output3&output4&output5&output6&output7&output8;
end beh;
