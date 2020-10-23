library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity quaterround is
  port(
    y:in std_logic_vector(127 downto 0);
    clk:in std_logic;
    reset:in std_logic;
    z:out std_logic_vector(127 downto 0));
end quaterround;

architecture beh of quaterround is

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

----------------
--z1 = y1 xor ((y0+y3)<<<7)
--z2 = y2 xor ((z1+y0)<<<9)
--z3 = y3 xor ((z2+z1)<<<13)
--z0 = y0 xor ((z3+z2)<<<18)

signal z1,z2,z3,z0:std_logic_vector(31 downto 0);
signal temp1,temp2:std_logic_vector(31 downto 0);
signal temp4,temp5:std_logic_vector(31 downto 0);
signal temp7,temp8:std_logic_vector(31 downto 0);
signal temp10,temp11:std_logic_vector(31 downto 0);
signal result:std_logic_vector(127 downto 0);
signal stage1_reg1_output,stage1_reg2_output,stage1_reg3_output,stage1_reg4_output:std_logic_vector(31 downto 0);
signal stage2_reg1_output,stage2_reg2_output,stage2_reg3_output,stage2_reg4_output:std_logic_vector(31 downto 0);
signal stage3_reg1_output,stage3_reg2_output,stage3_reg3_output,stage3_reg4_output:std_logic_vector(31 downto 0);
signal stage4_reg1_output,stage4_reg2_output,stage4_reg3_output,stage4_reg4_output:std_logic_vector(31 downto 0);

begin
  temp1<=y(127 downto 96) + y(31 downto 0);
  temp2<=temp1(24 downto 0)&temp1(31 downto 25);
  z1<=y(95 downto 64) xor temp2;
  reg1_1:reg generic map(32) port map(y(127 downto 96),clk,reset,stage1_reg1_output);--y0
  reg1_2:reg generic map(32) port map(y(63 downto 32),clk,reset,stage1_reg2_output);--y2
  reg1_3:reg generic map(32) port map(y(31 downto 0),clk,reset,stage1_reg3_output);--y3
  reg1_4:reg generic map(32) port map(z1,clk,reset,stage1_reg4_output);--z1
  ----end of stage one-----------
  temp4<=stage1_reg1_output + stage1_reg4_output;
  temp5<=temp4(22 downto 0)&temp4(31 downto 23);
  z2<=stage1_reg2_output xor temp5;
  reg2_1:reg generic map(32) port map(stage1_reg4_output,clk,reset,stage2_reg1_output);--z1
  reg2_2:reg generic map(32) port map(stage1_reg1_output,clk,reset,stage2_reg2_output);--y0
  reg2_3:reg generic map(32) port map(z2,clk,reset,stage2_reg3_output);--z2
  reg2_4:reg generic map(32) port map(stage1_reg3_output,clk,reset,stage2_reg4_output);--y3
  ----end of stage two-----------
  temp7<=stage2_reg1_output + stage2_reg3_output;
  temp8<=temp7(18 downto 0)&temp7(31 downto 19);
  z3<=stage2_reg4_output xor temp8;
  reg3_1:reg generic map(32) port map(stage2_reg2_output,clk,reset,stage3_reg1_output);--y0
  reg3_2:reg generic map(32) port map(stage2_reg3_output,clk,reset,stage3_reg2_output);--z2
  reg3_3:reg generic map(32) port map(z3,clk,reset,stage3_reg3_output);--z3
  reg3_4:reg generic map(32) port map(stage2_reg1_output,clk,reset,stage3_reg4_output);--z1
  ----end of stage three-----------
  temp10<=stage3_reg3_output + stage3_reg2_output;
  temp11<=temp10(13 downto 0)&temp10(31 downto 14);
  z0<=stage3_reg1_output xor temp11;
  reg4_1:reg generic map(32) port map(stage3_reg3_output,clk,reset,stage4_reg1_output);--z3
  reg4_2:reg generic map(32) port map(stage3_reg2_output,clk,reset,stage4_reg2_output);--z2
  reg4_3:reg generic map(32) port map(stage3_reg4_output,clk,reset,stage4_reg3_output);--z1
  reg4_4:reg generic map(32) port map(z0,clk,reset,stage4_reg4_output);--z0
    ----end of stage four-----------
  z<=stage4_reg4_output&stage4_reg3_output&stage4_reg2_output&stage4_reg1_output;
  
end beh;
