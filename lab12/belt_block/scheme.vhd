library ieee;
use ieee.std_logic_1164.all;

entity scheme is
  port(
  input_message:in std_logic_vector(127 downto 0);
  key:in std_logic_vector(255 downto 0);
  clk:in std_logic;
  start:in std_logic;
  reset:in std_logic;
  done:out std_logic;
  output_message:out std_logic_vector(127 downto 0));
end scheme;

architecture beh of scheme is
component counter
port(
  clk:in std_logic;
  start:in std_logic;
  reset:in std_logic;
  number:out std_logic_vector(31 downto 0);
  done:out std_logic);
end component;


component one_iteration
  port(
  a:in std_logic_vector(31 downto 0);
  b:in std_logic_vector(31 downto 0);
  c:in std_logic_vector(31 downto 0);
  d:in std_logic_vector(31 downto 0);
  key1:in std_logic_vector(31 downto 0);
  key2:in std_logic_vector(31 downto 0);
  key3:in std_logic_vector(31 downto 0);
  key4:in std_logic_vector(31 downto 0);
  key5:in std_logic_vector(31 downto 0);
  key6:in std_logic_vector(31 downto 0);
  key7:in std_logic_vector(31 downto 0);
  iteration:in std_logic_vector(31 downto 0);
  clk:in std_logic;
  start:in std_logic;
  reset:in std_logic;
  output_a:out std_logic_vector(31 downto 0);
  output_b:out std_logic_vector(31 downto 0);
  output_c:out std_logic_vector(31 downto 0);
  output_d:out std_logic_vector(31 downto 0));
end component;

signal key1,key2,key3,key4,key5,key6,key7,key8:std_logic_vector(31 downto 0);
signal input:std_logic_vector(127 downto 0);
signal a,b,c,d:std_logic_vector(31 downto 0);
signal output1_a,output1_b,output1_c,output1_d:std_logic_vector(31 downto 0);
signal output2_a,output2_b,output2_c,output2_d:std_logic_vector(31 downto 0);
signal output3_a,output3_b,output3_c,output3_d:std_logic_vector(31 downto 0);
signal output4_a,output4_b,output4_c,output4_d:std_logic_vector(31 downto 0);
signal output5_a,output5_b,output5_c,output5_d:std_logic_vector(31 downto 0);
signal output6_a,output6_b,output6_c,output6_d:std_logic_vector(31 downto 0);
signal output7_a,output7_b,output7_c,output7_d:std_logic_vector(31 downto 0);
signal output8_a,output8_b,output8_c,output8_d:std_logic_vector(31 downto 0);
signal number:std_logic_vector(31 downto 0);

begin
  -- input message big to little endian conversion
  a<=input_message(103 downto 96)&input_message(111 downto 104)&input_message(119 downto 112)&input_message(127 downto 120);
  b<=input_message(71 downto 64)&input_message(79 downto 72)&input_message(87 downto 80)&input_message(95 downto 88);
  c<=input_message(39 downto 32)&input_message(47 downto 40)&input_message(55 downto 48)&input_message(63 downto 56);
  d<=input_message(7 downto 0)&input_message(15 downto 8)&input_message(23 downto 16)&input_message(31 downto 24);

   --key big to little endian conversion
  key1<=key(231 downto 224)&key(239 downto 232)&key(247 downto 240)&key(255 downto 248);
  key2<=key(199 downto 192)&key(207 downto 200)&key(215 downto 208)&key(223 downto 216);
  key3<=key(167 downto 160)&key(175 downto 168)&key(183 downto 176)&key(191 downto 184);
  key4<=key(135 downto 128)&key(143 downto 136)&key(151 downto 144)&key(159 downto 152);
  key5<=key(103 downto 96)&key(111 downto 104)&key(119 downto 112)&key(127 downto 120);
  key6<=key(71 downto 64)&key(79 downto 72)&key(87 downto 80)&key(95 downto 88);
  key7<=key(39 downto 32)&key(47 downto 40)&key(55 downto 48)&key(63 downto 56);
  key8<=key(7 downto 0)&key(15 downto 8)&key(23 downto 16)&key(31 downto 24);
counter1:counter port map(clk,start,reset,number,done);
one:one_iteration port map(a,b,c,d,key1,key2,key3,key4,key5,key6,key7,x"00000001",clk,start,reset,output1_a,output1_b,output1_c,output1_d);
two:one_iteration port map(output1_a,output1_b,output1_c,output1_d,key8,key1,key2,key3,key4,key5,key6,x"00000002",clk,start,reset,output2_a,output2_b,output2_c,output2_d);
three:one_iteration port map(output2_a,output2_b,output2_c,output2_d,key7,key8,key1,key2,key3,key4,key5,x"00000003",clk,start,reset,output3_a,output3_b,output3_c,output3_d);
four:one_iteration port map(output3_a,output3_b,output3_c,output3_d,key6,key7,key8,key1,key2,key3,key4,x"00000004",clk,start,reset,output4_a,output4_b,output4_c,output4_d);
five:one_iteration port map(output4_a,output4_b,output4_c,output4_d,key5,key6,key7,key8,key1,key2,key3,x"00000005",clk,start,reset,output5_a,output5_b,output5_c,output5_d);
six:one_iteration port map(output5_a,output5_b,output5_c,output5_d,key4,key5,key6,key7,key8,key1,key2,x"00000006",clk,start,reset,output6_a,output6_b,output6_c,output6_d);
seven:one_iteration port map(output6_a,output6_b,output6_c,output6_d,key3,key4,key5,key6,key7,key8,key1,x"00000007",clk,start,reset,output7_a,output7_b,output7_c,output7_d);
eight:one_iteration port map(output7_a,output7_b,output7_c,output7_d,key2,key3,key4,key5,key6,key7,key8,x"00000008",clk,start,reset,output8_a,output8_b,output8_c,output8_d);

output_message<=output8_b(7 downto 0)&output8_b(15 downto 8)&output8_b(23 downto 16)&output8_b(31 downto 24)&output8_d(7 downto 0)&output8_d(15 downto 8)&output8_d(23 downto 16)&output8_d(31 downto 24)&output8_a(7 downto 0)&output8_a(15 downto 8)&output8_a(23 downto 16)&output8_a(31 downto 24)&output8_c(7 downto 0)&output8_c(15 downto 8)&output8_c(23 downto 16)&output8_c(31 downto 24);

end beh;

