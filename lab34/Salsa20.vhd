library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Salsa20 is
  port(
  a:in std_logic_vector(511 downto 0);
  clk:in std_logic;
  reset:in std_logic;
  ready:out std_logic;
  b:out std_logic_vector(511 downto 0));
end Salsa20;

architecture beh of Salsa20 is

component littleendian
  port(
  a:in std_logic_vector(31 downto 0);
  b:out std_logic_vector(31 downto 0));
end component;

component doubleround
  port(
  a:in std_logic_vector(511 downto 0);
  clk:in std_logic;
  reset:in std_logic;
  b:out std_logic_vector(511 downto 0));
end component;

component writesignalreg
  generic(
  Size:integer
  );
  port(
  a:in std_logic_vector(Size-1 downto 0);
  write:in std_logic;
  clk:in std_logic;
  reset:in std_logic;
  b:out std_logic_vector(Size-1 downto 0));
end component;

signal converted:std_logic_vector(511 downto 0);
signal output1,output2,output3,output4,output5,output6,output7,output8,output9,output10:std_logic_vector(511 downto 0);
signal xor1,xor2,xor3,xor4,xor5,xor6,xor7,xor8,xor9,xor10:std_logic_vector(511 downto 0);
signal le1,le2,le3,le4,le5,le6,le7,le8,le9,le10,le11,le12,le13,le14,le15,le16:std_logic_vector(31 downto 0);
signal le1_1,le2_1,le3_1,le4_1,le5_1,le6_1,le7_1,le8_1,le9_1,le10_1,le11_1,le12_1,le13_1,le14_1,le15_1,le16_1:std_logic_vector(31 downto 0);
signal sum1,sum2,sum3,sum4,sum5,sum6,sum7,sum8,sum9,sum10,sum11,sum12,sum13,sum14,sum15,sum16:std_logic_vector(31 downto 0);
signal r1_out,r2_out,r3_out,r4_out,r5_out,r6_out,r7_out,r8_out,r9_out,r10_out:std_logic_vector(511 downto 0);
signal counter:std_logic_vector(6 downto 0);
signal enable:std_logic;

begin
  we_counter:process(clk,reset)
    begin
      if(reset='1') then
        counter<="0000000";
        ready<='0';
      elsif(clk='1' and clk'event) then
        counter<= counter+1;
      end if;
      if(counter="1010000") then
        ready<='1';
        counter<="0000000";
        else
          ready<='0';
      end if;
    end process;
  --to little endian conversion
  l1:littleendian port map(a(511 downto 480),le1);
  l2:littleendian port map(a(479 downto 448),le2);
  l3:littleendian port map(a(447 downto 416),le3);
  l4:littleendian port map(a(415 downto 384),le4);
  l5:littleendian port map(a(383 downto 352),le5);
  l6:littleendian port map(a(351 downto 320),le6);
  l7:littleendian port map(a(319 downto 288),le7);
  l8:littleendian port map(a(287 downto 256),le8);
  l9:littleendian port map(a(255 downto 224),le9);
  l10:littleendian port map(a(223 downto 192),le10);
  l11:littleendian port map(a(191 downto 160),le11);
  l12:littleendian port map(a(159 downto 128),le12);
  l13:littleendian port map(a(127 downto 96),le13);
  l14:littleendian port map(a(95 downto 64),le14);
  l15:littleendian port map(a(63 downto 32),le15);
  l16:littleendian port map(a(31 downto 0),le16);
  converted<=le1&le2&le3&le4&le5&le6&le7&le8&le9&le10&le11&le12&le13&le14&le15&le16;
  --10 times double round function
  d1:doubleround port map(converted,clk,reset,output1);-- delay from registers with we signal is not correct for this type of pypeline
  d2:doubleround port map(output1,clk,reset,output2);
  d3:doubleround port map(output2,clk,reset,output3);
  d4:doubleround port map(output3,clk,reset,output4);
  d5:doubleround port map(output4,clk,reset,output5);
  d6:doubleround port map(output5,clk,reset,output6);
  d7:doubleround port map(output6,clk,reset,output7);
  d8:doubleround port map(output7,clk,reset,output8);
  d9:doubleround port map(output8,clk,reset,output9);
  d10:doubleround port map(output9,clk,reset,output10);
  --sum chain
  sum1<=le1+output10(511 downto 480);
  sum2<=le2+output10(479 downto 448);
  sum3<=le3+output10(447 downto 416);
  sum4<=le4+output10(415 downto 384);
  sum5<=le5+output10(383 downto 352);
  sum6<=le6+output10(351 downto 320);
  sum7<=le7+output10(319 downto 288);
  sum8<=le8+output10(287 downto 256);
  sum9<=le9+output10(255 downto 224);
  sum10<=le10+output10(223 downto 192);
  sum11<=le11+output10(191 downto 160);
  sum12<=le12+output10(159 downto 128);
  sum13<=le13+output10(127 downto 96);
  sum14<=le14+output10(95 downto 64);
  sum15<=le15+output10(63 downto 32);
  sum16<=le16+output10(31 downto 0);
  --little endian conversion
  l1_1:littleendian port map(sum1,le1_1);
  l2_1:littleendian port map(sum2,le2_1);
  l3_1:littleendian port map(sum3,le3_1);
  l4_1:littleendian port map(sum4,le4_1);
  l5_1:littleendian port map(sum5,le5_1);
  l6_1:littleendian port map(sum6,le6_1);
  l7_1:littleendian port map(sum7,le7_1);
  l8_1:littleendian port map(sum8,le8_1);
  l9_1:littleendian port map(sum9,le9_1);
  l10_1:littleendian port map(sum10,le10_1);
  l11_1:littleendian port map(sum11,le11_1);
  l12_1:littleendian port map(sum12,le12_1);
  l13_1:littleendian port map(sum13,le13_1);
  l14_1:littleendian port map(sum14,le14_1);
  l15_1:littleendian port map(sum15,le15_1);
  l16_1:littleendian port map(sum16,le16_1);
  b<=le1_1&le2_1&le3_1&le4_1&le5_1&le6_1&le7_1&le8_1&le9_1&le10_1&le11_1&le12_1&le13_1&le14_1&le15_1&le16_1;
end beh;
