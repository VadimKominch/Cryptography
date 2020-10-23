library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter is
  port(
  clk:in std_logic;
  start:in std_logic;
  reset:in std_logic;
  number:out std_logic_vector(31 downto 0);
  done:out std_logic);
end counter;

architecture beh of counter is
signal count:std_logic_vector(31 downto 0);

begin
  process(clk,reset)
  begin
    if(reset = '1') then
      count <=(others => '0');
      done<='0';
    elsif(clk'event and clk = '1') then
      if(start = '0') then
        if(count=x"0000002F") then
        count<=x"00000000";
        done<='1';
        else
        count<=count+1;
        done<='0'; 
        end if;
      end if;
    end if;
  end process;
  number<=count;
end beh;
