library ieee;
use ieee.std_logic_1164.all;

entity columnround is
  port(
    y:in std_logic_vector(511 downto 0);
    clk:in std_logic;
    reset:in std_logic;
    z:out std_logic_vector(511 downto 0));
end columnround;

architecture beh of columnround is

component quaterround
    port(
    y:in std_logic_vector(127 downto 0);
    clk:in std_logic;
    reset:in std_logic;
    z:out std_logic_vector(127 downto 0));
end component;

signal input1,input2,input3,input4:std_logic_vector(127 downto 0);
signal output1,output2,output3,output4:std_logic_vector(127 downto 0);

--(y0; y4; y8; y12) = quarterround(x0; x4; x8; x12);
--(y5; y9; y13; y1) = quarterround(x5; x9; x13; x1);
--(y10; y14; y2; y6) = quarterround(x10; x14; x2; x6);
--(y15; y3; y7; y11) = quarterround(x15; x3; x7; x11):
begin
  input1<=y(511 downto 480)&y(383 downto 352)&y(255 downto 224)&y(127 downto 96);
  input2<=y(351 downto 320)&y(223 downto 192)&y(95 downto 64)&y(479 downto 448);
  input3<=y(191 downto 160)&y(63 downto 32)&y(447 downto 416)&y(319 downto 288);
  input4<=y(31 downto 0)&y(415 downto 384)&y(287 downto 256)&y(159 downto 128);
  q1:quaterround port map(input1,clk,reset,output1);
  q2:quaterround port map(input2,clk,reset,output2);
  q3:quaterround port map(input3,clk,reset,output3);
  q4:quaterround port map(input4,clk,reset,output4);
  z<=output1(127 downto 96)&
  output2(31 downto 0)&
  output3(63 downto 32)&
  output4(95 downto 64)&
  output1(95 downto 64)&
  output2(127 downto 96)&
  output3(31 downto 0)&
  output4(63 downto 32)&
  output1(63 downto 32)&
  output2(95 downto 64)&
  output3(127 downto 96)&
  output4(31 downto 0)&
  output1(31 downto 0)&
  output2(63 downto 32)&
  output3(95 downto 64)&
  output4(127 downto 96);
end beh;