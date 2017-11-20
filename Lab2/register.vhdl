-- 32 x 32 register file
-- two read ports, one write port with write enable
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
entity regfile is
port( din : in std_logic_vector(31 downto 0);
 reset : in std_logic;
 clk : in std_logic;
 write : in std_logic;
 read_a : in std_logic_vector(4 downto 0);
 read_b : in std_logic_vector(4 downto 0);
 write_address : in std_logic_vector(4 downto 0);
 out_a : out std_logic_vector(31 downto 0);
 out_b : out std_logic_vector(31 downto 0));
end regfile ;

architecture RegisterImplementation of regfile is
  -- signals declaration
type registerFile is array(31 downto 0) of std_logic_vector(31 downto 0);
signal all_registers : registerFile := (others => (others => '0'));

  begin

    out_a <= all_registers(to_integer(unsigned(read_a)));
    out_b <= all_registers(to_integer(unsigned(read_b)));
    
    regFile : process(reset, clk, write)
    begin
      if reset = '1' then
        for i in 0 to 31 loop
          all_registers(i) <= (others => '0');
        end loop;
      elsif clk = '1'  and clk'event then
        if write = '1' then
          all_registers(to_integer(unsigned(write_address))) <= din;
        end if;
      end if;
    end process;
end architecture;
