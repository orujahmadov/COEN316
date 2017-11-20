-- PC Register
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;

entity icache is
port(
  address : in std_logic_vector(4 downto 0);
  data : out std_logic_vector(31 downto 0));
end icache;

architecture ICImplementation of icache is
  type mem is array ( 0 to 31) of std_logic_vector(31 downto 0);
  constant my_Rom : mem := (
    0  => "00100000000000010000000000000001", -- addi r1, r0, 1
    1  => "00100000000000100000000000000010", -- addi r2, r0, 2
    2  => "00000000010000010001000000100000", -- add r2, r2, r1
    3  => "00001000000000000000000000000010", -- jump 00010
    4  => "00000100",
    5  => "11110000",
    6  => "11110000",
    7  => "11110000",
    8  => "11110000",
    9  => "11110000",
    10 => "11110000",
    11 => "11110000",
    12 => "11110000",
    13 => "11110000",
    14 => "11110000",
    15 => "00000000000000000000000000000000");
begin
   process (address)
   begin
     data <= my_rom(to_integer(unsigned(address)));
  end process;
end architecture ICImplementation;
