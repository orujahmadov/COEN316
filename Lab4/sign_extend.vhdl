-- PC Register
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_extend is
port(
  immediate_field : in std_logic_vector(15 downto 0);
 func : in std_logic_vector(1 downto 0);
 output_address : out std_logic_vector(31 downto 0));
end sign_extend;

architecture SImplementation of sign_extend is

begin

  pcRegister : process(immediate_field, func)
  begin
    if func = "00" then
      output_address <= immediate_field & "0000000000000000";
    elsif func = "11" then
      output_address <= "0000000000000000" & immediate_field;
	else
		output_address <= std_logic_vector(resize(signed(immediate_field), 32));
    end if;

  end process;

end SImplementation;
