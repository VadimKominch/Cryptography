library ieee;
use ieee.std_logic_1164.all;

entity Salsa20encryption is
  port(
  );
end Salsa20encryption;

architecture beh of Salsa20encryption is

component expansion
    port(
    k:in std_logic_vector(255 downto 0);
    n:in std_logic_vector(127 downto 0);
    v:in std_logic;--0 for 32 byte, 1 for 16 byte
    clk:in std_logic;
    reset:in std_logic;
    output:out std_logic_vector(511 downto 0));
end component;

signal std_logic_vector(downto 0);
signal std_logic_vector(downto 0);

begin

end beh;
