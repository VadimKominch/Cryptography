library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ROM is
  port(
  addr:in std_logic_vector(5 downto 0);
  --addr:in integer;
  output:out std_logic_vector(31 downto 0));
end ROM;

architecture beh of ROM is
type memory is array ( 0 to 63 ) of std_logic_vector( 31 downto 0 ) ;
constant ROM_Table :memory := (
0 => x"428A2F98",
1 => x"71374491",
2 => x"B5C0FBCF",
3 => x"E9B5DBA5",
4 => x"3956C25B",
5 => x"59F111F1",
6 => x"923F82A4",
7 => x"AB1C5ED5",
8 => x"D807AA98",
9 => x"12835B01",
10 => x"243185BE",
11 => x"550C7DC3",
12 => x"72BE5D74",
13 => x"80DEB1FE",
14 => x"9BDC06A7",
15 => x"C19BF174",
16 => x"E49B69C1",
17 => x"EFBE4786",
18 => x"0FC19DC6",
19 => x"240CA1CC",
20 => x"2DE92C6F",
21 => x"4A7484AA",
22 => x"5CB0A9DC",
23 => x"76F988DA",
24 => x"983E5152",
25 => x"A831C66D", 
26 => x"B00327C8",
27 => x"BF597FC7",
28 => x"C6E00BF3", 
29 => x"D5A79147", 
30 => x"06CA6351", 
31 => x"14292967",
32 => x"27B70A85", 
33 => x"2E1B2138", 
34 => x"4D2C6DFC", 
35 => x"53380D13", 
36 => x"650A7354", 
37 => x"766A0ABB", 
38 => x"81C2C92E", 
39 => x"92722C85",
40 => x"A2BFE8A1", 
41 => x"A81A664B", 
42 => x"C24B8B70", 
43 => x"C76C51A3", 
44 => x"D192E819", 
45 => x"D6990624", 
46 => x"F40E3585", 
47 => x"106AA070",
48 => x"19A4C116", 
49 => x"1E376C08", 
50 => x"2748774C", 
51 => x"34B0BCB5", 
52 => x"391C0CB3", 
53 => x"4ED8AA4A", 
54 => x"5B9CCA4F", 
55 => x"682E6FF3",
56 => x"748F82EE", 
57 => x"78A5636F", 
58 => x"84C87814", 
59 => x"8CC70208", 
60 => x"90BEFFFA", 
61 => x"A4506CEB", 
62 => x"BEF9A3F7", 
63 => x"C67178F2");

begin
             output <= ROM_Table(conv_integer(addr(5 downto 0)));
             --output <= ROM_Table(addr);
end beh;
