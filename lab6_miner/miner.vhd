library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity miner is
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
end miner;

architecture beh of miner is

component core
  port(
  input:in std_logic_vector(511 downto 0);
  iv:in std_logic_vector(255 downto 0);
  reset:in std_logic;
  clk:in std_logic;
  ready:out std_logic;
  output:out std_logic_vector(255 downto 0));
end component;

component compare_block
  port(
  input:in std_logic_vector(255 downto 0);
  shift:in std_logic_vector(7 downto 0);
  output:out std_logic);
end component;

signal ready_first,ready_second,ready_third,ready_fourth: std_logic;
signal output_counter1,output_counter2,output_counter3,output_counter4:std_logic_vector(31 downto 0);
signal vect,vect2_1,vect3_1,vect2_2,vect3_2,vect2_3,vect3_3,vect2_4,vect3_4:std_logic_vector(511 downto 0);
signal ready1,ready2_1,ready2_2,ready2_3,ready2_4,ready3_1,ready3_2,ready3_3,ready3_4:std_logic;
signal iv,core1_output:std_logic_vector(255 downto 0);
signal hash_1,hash_2,hash_3,hash_4:std_logic_vector(255 downto 0);
signal core2_1_output,core3_1_output:std_logic_vector(255 downto 0);
signal core2_2_output,core3_2_output:std_logic_vector(255 downto 0);
signal core2_3_output,core3_3_output:std_logic_vector(255 downto 0);
signal core2_4_output,core3_4_output:std_logic_vector(255 downto 0);
signal padding_zeros:std_logic_vector(255 downto 0):=x"8000000000000000000000000000000000000000000000000000000000000000";
signal start_length:std_logic_vector(127 downto 0):=x"00000000000000000000000000000280";
signal cnt:std_logic_vector(1 downto 0):="00";
--@See core.vhd one SHA-256 block
--Design consists of four blocks of sha, which are common,but take different input nonces
--Four counters are in this design
--Comparing scheme addition with ones vector of 256-bit length. 257-bit shows if hash contains zeros in the start of the vector
begin
  process(ready1,clk)
    begin
      if(ready1='1' and ready1'event) then
        --output_counter1<=x"3a5de000";
        output_counter1<=x"00000000";
        output_counter2<=x"40000000";
        output_counter3<=x"80000000";
        --output_counter3<=x"3a5de07f";
        output_counter4<=x"C0000000";
      elsif(clk='1' and clk'event) then
        if(cnt="01") then
        output_counter1<=output_counter1+1;
        output_counter2<=output_counter2+1;
        output_counter3<=output_counter3+1;
        output_counter4<=output_counter4+1;
        cnt<="00";
      else
        cnt<=cnt+1;
      end if;
      end if;
      --End of counters
    end process;
    --Generating vectors for second sha-block
    iv<=x"6a09e667"&x"bb67ae85"&x"3c6ef372"&x"a54ff53a"&x"510e527f"&x"9b05688c"&x"1f83d9ab"&x"5be0cd19";
  vect<=version&hash_prev_block&hash_merkle_root(255 downto 32);
  core1:core port map(vect,iv,start,clk,ready1,core1_output);
  --PART I
  vect2_1<=hash_merkle_root(31 downto 0)&time_stamp&target&output_counter1&padding_zeros&start_length;
  core2_1:core port map(vect2_1,core1_output,ready1,clk,ready2_1,core2_1_output);
  vect3_1<=core2_1_output&x"8000000000000000000000000000000000000000000000000000000000000100";
  core3_1:core port map(vect3_1,iv,ready2_1,clk,ready3_1,core3_1_output);
  hash_1<=core3_1_output(7 downto 0)&core3_1_output(15 downto 8)&core3_1_output(23 downto 16)&core3_1_output(31 downto 24)&
        core3_1_output(39 downto 32)&core3_1_output(47 downto 40)&core3_1_output(55 downto 48)&core3_1_output(63 downto 56)&
        core3_1_output(71 downto 64)&core3_1_output(79 downto 72)&core3_1_output(87 downto 80)&core3_1_output(95 downto 88)&
        core3_1_output(103 downto 96)&core3_1_output(111 downto 104)&core3_1_output(119 downto 112)&core3_1_output(127 downto 120)&
        core3_1_output(135 downto 128)&core3_1_output(143 downto 136)&core3_1_output(151 downto 144)&core3_1_output(159 downto 152)&
        core3_1_output(167 downto 160)&core3_1_output(175 downto 168)&core3_1_output(183 downto 176)&core3_1_output(191 downto 184)&
        core3_1_output(199 downto 192)&core3_1_output(207 downto 200)&core3_1_output(215 downto 208)&core3_1_output(223 downto 216)&
        core3_1_output(231 downto 224)&core3_1_output(239 downto 232)&core3_1_output(247 downto 240)&core3_1_output(255 downto 248);
  cmp1:compare_block port map(hash_1,zeros,first);
  nonce_first<=output_counter1-x"40";
  --PART II
  vect2_2<=hash_merkle_root(31 downto 0)&time_stamp&target&output_counter2&padding_zeros&start_length;
  core2_2:core port map(vect2_2,core1_output,ready1,clk,ready2_2,core2_2_output);
  vect3_2<=core2_2_output&x"8000000000000000000000000000000000000000000000000000000000000100";
  core3_2:core port map(vect3_2,iv,ready2_2,clk,ready3_2,core3_2_output);
  hash_2<=core3_2_output(7 downto 0)&core3_2_output(15 downto 8)&core3_2_output(23 downto 16)&core3_2_output(31 downto 24)&
        core3_2_output(39 downto 32)&core3_2_output(47 downto 40)&core3_2_output(55 downto 48)&core3_2_output(63 downto 56)&
        core3_2_output(71 downto 64)&core3_2_output(79 downto 72)&core3_2_output(87 downto 80)&core3_2_output(95 downto 88)&
        core3_2_output(103 downto 96)&core3_2_output(111 downto 104)&core3_2_output(119 downto 112)&core3_2_output(127 downto 120)&
        core3_2_output(135 downto 128)&core3_2_output(143 downto 136)&core3_2_output(151 downto 144)&core3_2_output(159 downto 152)&
        core3_2_output(167 downto 160)&core3_2_output(175 downto 168)&core3_2_output(183 downto 176)&core3_2_output(191 downto 184)&
        core3_2_output(199 downto 192)&core3_2_output(207 downto 200)&core3_2_output(215 downto 208)&core3_2_output(223 downto 216)&
        core3_2_output(231 downto 224)&core3_2_output(239 downto 232)&core3_2_output(247 downto 240)&core3_2_output(255 downto 248);
  cmp2:compare_block port map(hash_2,zeros,second);
  nonce_second<=output_counter2-x"40";
--PART III
vect2_3<=hash_merkle_root(31 downto 0)&time_stamp&target&output_counter3&padding_zeros&start_length;
core2_3:core port map(vect2_3,core1_output,ready1,clk,ready2_3,core2_3_output);
  vect3_3<=core2_3_output&x"8000000000000000000000000000000000000000000000000000000000000100";
  core3_3:core port map(vect3_3,iv,ready2_3,clk,ready3_3,core3_3_output);
  hash_3<=core3_3_output(7 downto 0)&core3_3_output(15 downto 8)&core3_3_output(23 downto 16)&core3_3_output(31 downto 24)&
        core3_3_output(39 downto 32)&core3_3_output(47 downto 40)&core3_3_output(55 downto 48)&core3_3_output(63 downto 56)&
        core3_3_output(71 downto 64)&core3_3_output(79 downto 72)&core3_3_output(87 downto 80)&core3_3_output(95 downto 88)&
        core3_3_output(103 downto 96)&core3_3_output(111 downto 104)&core3_3_output(119 downto 112)&core3_3_output(127 downto 120)&
        core3_3_output(135 downto 128)&core3_3_output(143 downto 136)&core3_3_output(151 downto 144)&core3_3_output(159 downto 152)&
        core3_3_output(167 downto 160)&core3_3_output(175 downto 168)&core3_3_output(183 downto 176)&core3_3_output(191 downto 184)&
        core3_3_output(199 downto 192)&core3_3_output(207 downto 200)&core3_3_output(215 downto 208)&core3_3_output(223 downto 216)&
        core3_3_output(231 downto 224)&core3_3_output(239 downto 232)&core3_3_output(247 downto 240)&core3_3_output(255 downto 248);
  cmp3:compare_block port map(hash_3,zeros,third);
  hash<=hash_3;
  nonce_third<=output_counter3-x"40";
--PART IV
vect2_4<=hash_merkle_root(31 downto 0)&time_stamp&target&output_counter4&padding_zeros&start_length;
core2_4:core port map(vect2_4,core1_output,ready1,clk,ready2_4,core2_4_output);
  vect3_4<=core2_4_output&x"8000000000000000000000000000000000000000000000000000000000000100";
  core3_4:core port map(vect3_4,iv,ready2_4,clk,ready3_4,core3_4_output);
  hash_4<=core3_4_output(7 downto 0)&core3_4_output(15 downto 8)&core3_4_output(23 downto 16)&core3_4_output(31 downto 24)&
        core3_4_output(39 downto 32)&core3_4_output(47 downto 40)&core3_4_output(55 downto 48)&core3_4_output(63 downto 56)&
        core3_4_output(71 downto 64)&core3_4_output(79 downto 72)&core3_4_output(87 downto 80)&core3_4_output(95 downto 88)&
        core3_4_output(103 downto 96)&core3_4_output(111 downto 104)&core3_4_output(119 downto 112)&core3_4_output(127 downto 120)&
        core3_4_output(135 downto 128)&core3_4_output(143 downto 136)&core3_4_output(151 downto 144)&core3_4_output(159 downto 152)&
        core3_4_output(167 downto 160)&core3_4_output(175 downto 168)&core3_4_output(183 downto 176)&core3_4_output(191 downto 184)&
        core3_4_output(199 downto 192)&core3_4_output(207 downto 200)&core3_4_output(215 downto 208)&core3_4_output(223 downto 216)&
        core3_4_output(231 downto 224)&core3_4_output(239 downto 232)&core3_4_output(247 downto 240)&core3_4_output(255 downto 248);
  cmp4:compare_block port map(hash_4,zeros,fourth);
  nonce_fourth<=output_counter4-x"40";
end beh;