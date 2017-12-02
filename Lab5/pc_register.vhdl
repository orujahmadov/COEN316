-- PC Register
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;

entity pc_register is
port(
  pc : in std_logic_vector(31 downto 0);
 reset : in std_logic;
 clk : in std_logic;
 next_pc : out std_logic_vector(31 downto 0));
end pc_register;

architecture PCRImplementation of pc_register is

begin

  pcRegister : process(reset, clk, pc)
  begin
    if reset = '1' then
        next_pc <= (others => '0');
    elsif clk = '1'  and clk'event then
      next_pc <= pc;
    end if;
  end process;

end PCRImplementation;
