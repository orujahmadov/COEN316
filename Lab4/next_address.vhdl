-- Next address calculator for
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;

entity next_address is
port(
  rt, rs : in std_logic_vector(31 downto 0);
 -- two register inputs
 pc : in std_logic_vector(31 downto 0);
 target_address : in std_logic_vector(25 downto 0);
 branch_type : in std_logic_vector(1 downto 0);
 pc_sel : in std_logic_vector(1 downto 0);
 next_pc : out std_logic_vector(31 downto 0));
end next_address;

architecture NAImplementation of next_address is

begin

	next_address_pr: process (rt, rs, pc, target_address, branch_type, pc_sel)
		variable offset_value: unsigned(31 downto 0);

	begin

		if (target_address(15) = '0') then
			offset_value := unsigned("0000000000000000" & target_address(15 downto 0));
		else
			offset_value := unsigned("1111111111111111" & target_address(15 downto 0));
		end if;

		case pc_sel is

      			-- no jump (PC +1)
			when "00" =>

				case branch_type is

					when "00" =>
						next_pc <= std_logic_vector(unsigned(pc) + 1); --no branching, pc += 1

          				-- BEQ
					when "01" =>
            				-- IF rs=rt, 1 + branch offset value sign extended to 32 bits
						if (rs = rt) then
							next_pc <= std_logic_vector(unsigned(pc) + 1 + offset_value);
						else
							next_pc <= std_logic_vector(unsigned(pc) + 1);
						end if;

          				--BNE
					when "10" =>
          				-- IF rs/=rt, 1 + branch offset value sign extended to 32 bits
						if (rs /= rt) then
							next_pc <= std_logic_vector(unsigned(pc) + 1 + offset_value);
						else
							next_pc <= std_logic_vector(unsigned(pc) + 1);
						end if;

          				-- BLTZ
					when "11" =>
          				-- IF rs<0, 1 + branch offset value sign extended to 32 bits
						if (signed(rs) < 0) then
							next_pc <= std_logic_vector(unsigned(pc) + 1 + offset_value);
						else
							next_pc <= std_logic_vector(unsigned(pc) + 1);
						end if;

					when others =>
						next_pc <= std_logic_vector(unsigned(pc) + 1);

				end case;

      			-- Jump
			when "01" =>
				next_pc <= "000000" & target_address; -- Padding target with zeros

      			-- Jump Register
			when "10" => -- jump register: PC = contents of register rs
				next_pc <= rs;

      			-- Not used
			when others => -- shouldn't happen, PC = PC + 1
				next_pc <= std_logic_vector(unsigned(pc) + 1);

		end case;

	end process;

end NAImplementation;
