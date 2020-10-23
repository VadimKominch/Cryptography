library ieee;
use ieee.std_logic_1164.all;

entity one_iteration is
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
end one_iteration;

architecture beh of one_iteration is

component block_G
  port(
    a:in std_logic_vector(31 downto 0);
    key:in std_logic_vector(31 downto 0);
    shift:in std_logic_vector(4 downto 0); 
    clk:in std_logic;
    b:out std_logic_vector(31 downto 0));
end component;

component xor32
  port(
    a:in std_logic_vector(31 downto 0);
    b:in std_logic_vector(31 downto 0);
    c:out std_logic_vector(31 downto 0));
end component;

component sum32
  port(
    a:in std_logic_vector(31 downto 0);
    b:in std_logic_vector(31 downto 0);
    c:out std_logic_vector(31 downto 0));
end component;

component sub32
  port(
    a:in std_logic_vector(31 downto 0);
    b:in std_logic_vector(31 downto 0);
    c:out std_logic_vector(31 downto 0));
end component;

component store_register
  port(
  input:in std_logic_vector(31 downto 0);
  clk:in std_logic;
  reset:in std_logic;
  output:out std_logic_vector(31 downto 0));
end component;

signal temp_from_block_1,temp_from_xor1,temp_from_block_2,temp_from_xor2:std_logic_vector(31 downto 0);
signal temp_from_block_3,temp_from_sub1,temp_from_block_4,temp_from_xor3:std_logic_vector(31 downto 0);
signal temp_from_reg1,temp_from_sum1:std_logic_vector(31 downto 0);
signal temp_from_sum2,temp_from_sub2:std_logic_vector(31 downto 0);
signal temp_from_reg2,temp_from_reg3:std_logic_vector(31 downto 0);
signal temp_from_block_5,temp_from_sum3:std_logic_vector(31 downto 0);
signal temp_from_reg23,temp_from_reg34,temp_from_reg45:std_logic_vector(31 downto 0);
signal temp_from_regd,temp_from_reg56:std_logic_vector(31 downto 0);
signal temp_from_block_6,temp_from_xor4,temp_from_block_7,temp_from_xor5:std_logic_vector(31 downto 0);

begin
  
  --first pipeline stage
  block1:block_G port map(a,key1,"00101",clk,temp_from_block_1);
  xor1:xor32 port map(temp_from_block_1,b,temp_from_xor1); -- counting b
  block2:block_G port map(d,key2,"10101",clk,temp_from_block_2);
  xor2:xor32 port map(temp_from_block_2,c,temp_from_xor2); -- counting c
  
  --second pipeline stage
  block3:block_G port map(temp_from_xor1,key3,"01101",clk,temp_from_block_3);
  sub1:sub32 port map(a,temp_from_block_3,temp_from_sub1); --counting a
  reg1: store_register port map(temp_from_xor2,clk,reset,temp_from_reg1);
  sum1: sum32 port map(temp_from_reg1,key4,temp_from_sum1); -- counting b+c
  
  --third pipeline stage
  block4:block_G port map(temp_from_sum1,temp_from_xor1,"10101",clk,temp_from_block_4);
  xor3:xor32 port map(temp_from_block_4,iteration,temp_from_xor3);   -- counting e
  
  --fourth pipeline stage
  reg2: store_register port map(temp_from_xor3,clk,reset,temp_from_reg2);
  sum2: sum32 port map(temp_from_reg2,temp_from_xor1,temp_from_sum2); -- counting b
  sub2: sub32 port map(temp_from_xor2,temp_from_reg2,temp_from_sub2); -- counting c
  
  --fifth pipeline stage
  reg3: store_register port map(temp_from_sum2,clk,reset,temp_from_reg3);
  block5:block_G port map(temp_from_sub2,key5,"01101",clk,temp_from_block_5);
  sum3:sum32 port map(temp_from_block_5,d,temp_from_sum3); ---counting d
  
  --sixth pipeline stage(block of 4 registers used for signal a to wait its time to count)
  reg23: store_register port map(temp_from_sub1,clk,reset,temp_from_reg23);
  reg34: store_register port map(temp_from_reg23,clk,reset,temp_from_reg34);
  reg45: store_register port map(temp_from_reg34,clk,reset,temp_from_reg45); 
  reg56: store_register port map(temp_from_reg45,clk,reset,temp_from_reg56); -- final a
  regd: store_register port map(temp_from_sum3,clk,reset,temp_from_regd); --final d
  block6:block_G port map(temp_from_sum3,key7,"00101",clk,temp_from_block_6);
  xor4:xor32 port map(temp_from_block_6,temp_from_sub2,temp_from_xor4); -- counting c final
  block7:block_G port map(temp_from_reg45,key6,"10101",clk,temp_from_block_7);
  xor5:xor32 port map(temp_from_reg3,temp_from_block_7,temp_from_xor5); --counting b final
  output_a<=temp_from_xor5;
  output_b<=temp_from_regd;
  output_c<=temp_from_reg56;
  output_d<=temp_from_xor4;
end beh;

