-- PC Register
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity dcache is
port(
  address : in std_logic_vector(4 downto 0);
  din : in std_logic_vector(31 downto 0);
  write : in std_logic;
  reset : in std_logic;
  clk : in std_logic;
  data_output : out std_logic_vector(31 downto 0));
end dcache;

architecture DCImplementation of dcache is
  -- signals declaration
type cache is array(31 downto 0) of std_logic_vector(31 downto 0);
signal data_cache : cache := (others => (others => '0'));

	begin
	
	dataCache : process(reset, clk, write, address)
	begin
		if reset = '1' then
		  for i in 0 to 31 loop
			data_cache(i) <= (others => '0');
		  end loop;
		elsif clk'event and clk= '1' then
		  if write = '1' then
			data_cache(to_integer(unsigned(address))) <= din;
		  end if;
		end if;
		data_output <= data_cache(to_integer(unsigned(address)));
	end process;

end DCImplementation;
