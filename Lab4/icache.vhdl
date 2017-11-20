-- Ibstruction cache
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity icache is
port(
  address : in std_logic_vector(4 downto 0);
  data : out std_logic_vector(31 downto 0));
end icache;

architecture ICImplementation of icache is
  type mem is array ( 0 to 31) of std_logic_vector(31 downto 0);
  constant my_rom : mem := (
    0  => "00100000000000010000000000000001", -- addi r1, r0, 1
    1  => "00100000000000100000000000000010", -- addi r2, r0, 2
    2  => "00000000010000010001000000100000", -- add r2, r2, r1
    3  => "00001000000000000000000000000010", -- jump 00010
    4  => "00001000000000000000000000000010", -- jump 00010
    5  => "00001000000000000000000000000010", -- jump 00010
    6  => "00001000000000000000000000000010", -- jump 00010
    7  => "00001000000000000000000000000010", -- jump 00010
    8  => "00001000000000000000000000000010", -- jump 00010
    9  => "00001000000000000000000000000010", -- jump 00010
    10 => "00001000000000000000000000000010", -- jump 00010
    11 => "00001000000000000000000000000010", -- jump 00010
    12 => "00001000000000000000000000000010", -- jump 00010
    13 => "00001000000000000000000000000010", -- jump 00010
    14 => "00001000000000000000000000000010", -- jump 00010
    15 => "00000000000000000000000000000000",
    16 => "00000000000000000000000000000000",
    17 => "00000000000000000000000000000000",
    18 => "00000000000000000000000000000000",
    19 => "00000000000000000000000000000000",
    20 => "00000000000000000000000000000000",
    21 => "00000000000000000000000000000000",
    22 => "00000000000000000000000000000000",
    23 => "00000000000000000000000000000000",
    24 => "00000000000000000000000000000000",
    25 => "00000000000000000000000000000000",
    26 => "00000000000000000000000000000000",
    27 => "00000000000000000000000000000000",
    28 => "00000000000000000000000000000000",
    29 => "00000000000000000000000000000000",
    30 => "00000000000000000000000000000000",
    31 => "00000000000000000000000000000000");
	
begin
   process (address)
   begin
     data <= my_rom(to_integer(unsigned(address)));
  end process;
end architecture ICImplementation;
