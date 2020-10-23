library ieee;
use ieee.std_logic_1164.all;

entity mux is
  generic(
  Size:integer
  );
  port(
  a:in std_logic_vector(Size-1 downto 0);
  b:in std_logic_vector(Size-1 downto 0);
  control:in std_logic;
  c:out std_logic_vector(Size-1 downto 0));
end mux;

architecture beh of mux is
begin
c<= a when (control='0') else b;
  end beh;
