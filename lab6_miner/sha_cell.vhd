library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sha_cell is
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
end sha_cell;

architecture beh of sha_cell is

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

component reg_with_init
generic(
  init_vector:std_logic_vector(31 downto 0)
  );
port(
  a:in std_logic_vector(31 downto 0);
  clk:in std_logic;
  reset:in std_logic;
  b:out std_logic_vector(31 downto 0));
end component;

component ma
port(
x:in std_logic_vector(31 downto 0);
y:in std_logic_vector(31 downto 0);
z:in std_logic_vector(31 downto 0);
b:out std_logic_vector(31 downto 0)
);
end component;

component ch
port(
  x:in std_logic_vector(31 downto 0);
  y:in std_logic_vector(31 downto 0);
  z:in std_logic_vector(31 downto 0);
  output:out std_logic_vector(31 downto 0)
  );
end component;

component sum0
port(
a:in std_logic_vector(31 downto 0);
b:out std_logic_vector(31 downto 0)
);
end component;

component sum1
port(
  a:in std_logic_vector(31 downto 0);
  b:out std_logic_vector(31 downto 0)
);
end component;

component s1
port(
  a:in std_logic_vector(31 downto 0);
  b:out std_logic_vector(31 downto 0)
);
end component;

component s0
port(
  a:in std_logic_vector(31 downto 0);
  b:out std_logic_vector(31 downto 0)
);
end component;

component ROM
port(
  addr:in std_logic_vector(5 downto 0);
  --addr:in integer;
  output:out std_logic_vector(31 downto 0));
end component;

component expander
  port(
  word:in std_logic_vector(511 downto 0);
  clk:in std_logic;
  output:out std_logic_vector(511 downto 0);
  output_word:out std_logic_vector(31 downto 0));
end component;

--signal output_1_from_iter,output_2_from_iter,output_3_from_iter,output_4_from_iter,output_5_from_iter,output_6_from_iter,output_7_from_iter,output_8_from_iter:std_logic_vector(31 downto 0);
signal output_from_reg1,output_from_reg2,output_from_reg3,output_from_reg4,output_from_reg5,output_from_reg6,output_from_reg7,output_from_reg8:std_logic_vector(31 downto 0);
signal a_old,b_old,c_old,e_old,f_old,g_old:std_logic_vector(31 downto 0);
signal output_from_sum0,output_from_sum1,output_from_ma,output_from_ch:std_logic_vector(31 downto 0);
signal w,k,output_from_temp_reg:std_logic_vector(31 downto 0);
signal temp_sum,temp_sum2,temp_sum3,temp_sum4,temp_sum5,temp_sum6,temp_sum7:std_logic_vector(31 downto 0);
signal count:std_logic_vector(6 downto 0);
signal temp:std_logic_vector(511 downto 0);

begin
 --EXPANDER
  exp1:expander port map(words,clk,words_out,w);

  --COMPRESSOR-----------------
  r1:ROM port map(addr,k);
  A:reg generic map(32) port map(input_1_for_iter,clk,'0',output_from_reg1);
  B:reg generic map(32) port map(input_2_for_iter,clk,'0',output_from_reg2);
  C:reg generic map(32) port map(input_3_for_iter,clk,'0',output_from_reg3);
  D:reg generic map(32) port map(input_4_for_iter,clk,'0',output_from_reg4);
  E:reg generic map(32) port map(input_5_for_iter,clk,'0',output_from_reg5);
  F:reg generic map(32) port map(input_6_for_iter,clk,'0',output_from_reg6);
  G:reg generic map(32) port map(input_7_for_iter,clk,'0',output_from_reg7);
  H:reg generic map(32) port map(input_8_for_iter,clk,'0',output_from_reg8);
  --w comes from expander scheme
  --k comes from ROM table
temp_sum<=w+k;
  temp_sum2<=temp_sum+output_from_ch;
  temp_sum3<=temp_sum2+output_from_reg8;
  temp_sum4<=temp_sum3+output_from_sum1;--T1
  temp_sum5<=temp_sum4+output_from_ma;
  temp_sum6<=temp_sum5+output_from_sum0;--T1+T2
  
  ch1:ch port map(output_from_reg5,output_from_reg6,output_from_reg7,output_from_ch);
  ma1:ma port map(output_from_reg1,output_from_reg2,output_from_reg3,output_from_ma);
  sum0_0:sum0 port map(output_from_reg1,output_from_sum0);
  sum1_0:sum1 port map(output_from_reg5,output_from_sum1);
  
  --A1:reg generic map(32) port map(output_from_reg1,clk,'0',a_old);
--  B1:reg generic map(32) port map(output_from_reg2,clk,'0',b_old);
--  C1:reg generic map(32) port map(output_from_reg3,clk,'0',c_old);
--  ma1:reg generic map(32) port map(output_from_reg3,clk,'0',c_old);
--  E1:reg generic map(32) port map(output_from_reg5,clk,'0',e_old);
--  F1:reg generic map(32) port map(output_from_reg6,clk,'0',f_old);
--  G1:reg generic map(32) port map(output_from_reg7,clk,'0',g_old);
  
  temp_sum7<=output_from_reg4+temp_sum4;
  output_1_from_iter<=temp_sum6;
  output_2_from_iter<=output_from_reg1;
  output_3_from_iter<=output_from_reg2;
  output_4_from_iter<=output_from_reg3;
  output_5_from_iter<=temp_sum7;
  output_6_from_iter<=output_from_reg5;
  output_7_from_iter<=output_from_reg6;
  output_8_from_iter<=output_from_reg7;
  
end beh;
