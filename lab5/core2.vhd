library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity core is
  port(
  input:in std_logic_vector(511 downto 0);
  reset:in std_logic;
  clk:in std_logic;
  ready:out std_logic;
  output:out std_logic_vector(511 downto 0));
end core;

architecture beh of core is
--pipeline architecture
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
  --addr:in std_logic_vector(6 downto 0);
  addr:in integer;
  output:out std_logic_vector(31 downto 0));
end component;

component expander
  port(
  word:in std_logic_vector(511 downto 0);
  clk:in std_logic;
  output:out std_logic_vector(511 downto 0);
  output_word:out std_logic_vector(31 downto 0));
end component;

type words_arr is array (0 to 65) of std_logic_vector(511 downto 0);
type iter_arr is array (0 to 65) of std_logic_vector(31 downto 0);

signal output_1_from_iter,output_2_from_iter,output_3_from_iter,output_4_from_iter,output_5_from_iter,output_6_from_iter,output_7_from_iter,output_8_from_iter:iter_arr;
signal output_from_reg1,output_from_reg2,output_from_reg3,output_from_reg4,output_from_reg5,output_from_reg6,output_from_reg7,output_from_reg8:iter_arr;
signal current_d,output_ch:iter_arr;
signal output_from_sum0,output_from_sum1,output_from_ma,output_from_ch:iter_arr;
signal w,k:iter_arr;
signal temp_sum,temp_sum2,temp_sum3,temp_sum4,temp_sum5,temp_sum6,temp_sum7:iter_arr;
signal addr:std_logic_vector(6 downto 0);
signal output_from_s0,output_from_s1:iter_arr;
signal words:words_arr;
signal end_a,end_b,end_c,end_d,end_e,end_f,end_g,end_h:iter_arr;

begin
  words(0)<=input;
  output_1_from_iter(0)<=x"6a09e667";
  output_2_from_iter(0)<=x"bb67ae85";
  output_3_from_iter(0)<=x"3c6ef372";
  output_4_from_iter(0)<=x"a54ff53a";
  output_5_from_iter(0)<=x"510e527f";
  output_6_from_iter(0)<=x"9b05688c";
  output_7_from_iter(0)<=x"1f83d9ab";
  output_8_from_iter(0)<=x"5be0cd19";
  -----EXPANDER------------------
  --generate word w for next computing unit
  g1:for i in 0 to 63 generate
exp1:expander port map(words(i),clk,words(i+1),w(i));

--H(0)0 = 6a09e667
--H(0)1 = bb67ae85
--H(0)2 = 3c6ef372
--H(0)3 = a54ff53a
--H(0)4 = 510e527f
--H(0)5 = 9b05688c
--H(0)6 = 1f83d9ab
--H(0)7 = 5be0cd19
  --where should i generate adress for ROM to get actual value
  --COMPRESSOR-----------------
  r1:ROM port map(i,k(i));
  --replace addr with another 
  A:reg generic map(32) port map(output_1_from_iter(i),clk,reset,output_from_reg1(i));
  B:reg generic map(32) port map(output_2_from_iter(i),clk,reset,output_from_reg2(i));
  C:reg generic map(32) port map(output_3_from_iter(i),clk,reset,output_from_reg3(i));
  D:reg generic map(32) port map(output_4_from_iter(i),clk,reset,output_from_reg4(i));
  E:reg generic map(32) port map(output_5_from_iter(i),clk,reset,output_from_reg5(i));
  F:reg generic map(32) port map(output_6_from_iter(i),clk,reset,output_from_reg6(i));
  G:reg generic map(32) port map(output_7_from_iter(i),clk,reset,output_from_reg7(i));
  H:reg generic map(32) port map(output_8_from_iter(i),clk,reset,output_from_reg8(i));
  --w comes from expander scheme
  --k comes from ROM table
  temp_sum(i)<=w(i)+k(i);
  temp_sum2(i)<=temp_sum(i)+output_ch(i);
  temp_sum3(i)<=temp_sum2(i)+output_from_reg8(i);
  temp_sum4(i)<=temp_sum3(i)+output_from_sum1(i);--T1
  temp_sum5(i)<=temp_sum4(i)+output_from_ma(i);
  temp_sum6(i)<=temp_sum5(i)+output_from_sum0(i);--T1+T2
  
  ch1:ch port map(output_from_reg5(i),output_from_reg6(i),output_from_reg7(i),output_ch(i));
  ma1:ma port map(output_from_reg1(i),output_from_reg2(i),output_from_reg3(i),output_from_ma(i));
  sum0_0:sum0 port map(output_from_reg1(i),output_from_sum0(i));
  sum1_0:sum1 port map(output_from_reg5(i),output_from_sum1(i));
  
  temp_sum7(i)<=temp_sum4(i)+output_from_reg4(i);
  output_1_from_iter(i+1)<=temp_sum6(i);
  output_2_from_iter(i+1)<=output_from_reg1(i);
  output_3_from_iter(i+1)<=output_from_reg2(i);
  output_4_from_iter(i+1)<=output_from_reg3(i);
  output_5_from_iter(i+1)<=temp_sum7(i);
  output_6_from_iter(i+1)<=output_from_reg5(i);
  output_7_from_iter(i+1)<=output_from_reg6(i);
  output_8_from_iter(i+1)<=output_from_reg7(i);
  end generate g1;
  --end_a<=x"6a09e667"+output_1_from_iter(64);
  --end_b<=x"bb67ae85"+output_2_from_iter(64);
  --end_c<=x"3c6ef372"+output_3_from_iter(64);
  --end_d<=x"a54ff53a"+output_4_from_iter(64);
  --end_e<=x"510e527f"+output_5_from_iter(64);
  --end_f<=x"9b05688c"+output_6_from_iter(64);
  --end_g<=x"1f83d9ab"+output_7_from_iter(64);
  --end_h<=x"5be0cd19"+output_8_from_iter(64);
end beh;

