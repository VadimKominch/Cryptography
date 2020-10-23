library ieee;
use ieee.std_logic_1164.all;

entity expansion is
  port(
    k:in std_logic_vector(255 downto 0);
    n:in std_logic_vector(127 downto 0);
    v:in std_logic;
    clk:in std_logic;
    reset:in std_logic;
    ready:out std_logic;
    output:out std_logic_vector(511 downto 0));
end expansion;
--signal v choose between 16-byte k and 32-byte k
--0 for 32-byte k
--1 for 16-byte k
--add ready signal
architecture beh of expansion is
component Salsa20
port(
  a:in std_logic_vector(511 downto 0);
  clk:in std_logic;
  reset:in std_logic;
  ready:out std_logic;
  b:out std_logic_vector(511 downto 0));
end component;

component mux
  generic(
  Size:integer
  );
  port(
  a:in std_logic_vector(Size-1 downto 0);
  b:in std_logic_vector(Size-1 downto 0);
  control:in std_logic;
  c:out std_logic_vector(Size-1 downto 0));
end component;

signal output_mux:std_logic_vector(511 downto 0);
signal input_mux_1,input_mux_2:std_logic_vector(511 downto 0);
constant zero:std_logic_vector(31 downto 0):=x"65787061";
constant one_theta:std_logic_vector(31 downto 0):=x"6E642031";
constant one_sigma:std_logic_vector(31 downto 0):=x"6E642033";
constant two_theta:std_logic_vector(31 downto 0):=x"362D6279";
constant two_sigma:std_logic_vector(31 downto 0):=x"322D6279";
constant three:std_logic_vector(31 downto 0):=x"7465206B";
signal readySalsa:std_logic;

begin
      ready<=readySalsa;
  --insert registers with constants or save constant declaration
  input_mux_1<=zero&k(255 downto 128)&one_sigma&n&two_sigma&k(127 downto 0)&three;
  input_mux_2<=zero&k(127 downto 0)&one_theta&n&two_theta&k(127 downto 0)&three;
  mux1:mux generic map(512) port map(input_mux_1,input_mux_2,v,output_mux);
s1:Salsa20 port map(output_mux,clk,reset,readySalsa,output);  
end beh;