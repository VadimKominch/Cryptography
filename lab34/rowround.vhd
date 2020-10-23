library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity rowround is
  port(
    y:in std_logic_vector(511 downto 0);
    clk:in std_logic;
    reset:in std_logic;
    z:out std_logic_vector(511 downto 0));
end rowround;

architecture beh of rowround is
component quaterround
    port(
    y:in std_logic_vector(127 downto 0);
    clk:in std_logic;
    reset:in std_logic;
    z:out std_logic_vector(127 downto 0));
end component;

--(z0; z1; z2; z3) = quarterround(y0; y1; y2; y3);
--(z5; z6; z7; z4) = quarterround(y5; y6; y7; y4);
--(z10; z11; z8; z9) = quarterround(y10; y11; y8; y9);
--(z15; z12; z13; z14) = quarterround(y15; y12; y13; y14):

signal output1,output2,output3,output4:std_logic_vector(127 downto 0);
signal input1,input2,input3,input4:std_logic_vector(127 downto 0);

begin
  input1<=y(511 downto 480)&y(479 downto 448)&y(447 downto 416)&y(415 downto 384);
  input2<=y(351 downto 320)&y(319 downto 288)&y(287 downto 256)&y(383 downto 352);
  input3<=y(191 downto 160)&y(159 downto 128)&y(255 downto 224)&y(223 downto 192);
  input4<=y(31 downto 0)&y(127 downto 96)&y(95 downto 64)&y(63 downto 32);
  
  q1:quaterround port map(input1,clk,reset,output1);
  q2:quaterround port map(input2,clk,reset,output2);
  q3:quaterround port map(input3,clk,reset,output3);
  q4:quaterround port map(input4,clk,reset,output4);
  z<=output1&output2(31 downto 0)&output2(127 downto 32)&output3(63 downto 0)&output3(127 downto 64)&output4(95 downto 0)&output4(127 downto 96);
  
end beh;
