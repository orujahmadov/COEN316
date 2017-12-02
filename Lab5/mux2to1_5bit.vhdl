library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2to1_5bit is
port(
  X,Y : in std_logic_vector(4 downto 0);
    S : in std_logic;
    Z : out std_logic_vector(4 downto 0));
end mux2to1_5bit;

architecture Behavioral of mux2to1_5bit is

begin

process (X, Y, S) is
  begin
    if (S ='0') then
      Z <= X;
    else
      Z <= Y;
  end if;
end process;

end Behavioral;
