-- PC Register
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;

entity sign_extend is
port(
	immediate_field : in std_logic_vector(15 downto 0);
	func : 			  in std_logic_vector(1 downto 0);
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
		if immediate_field(15) = '1' then
			output_address <= "1111111111111111" & immediate_field;
		elsif immediate_field(15) = '0' then
			output_address <= "0000000000000000" & immediate_field;
		end if;
    end if;
  end process;

end SImplementation;
