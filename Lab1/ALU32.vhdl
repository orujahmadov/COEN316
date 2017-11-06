-- ALU
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- ALU ENTITY DECLARATION
entity alu is
port(x, y : in std_logic_vector(31 downto 0);
   -- two input operands
   add_sub : in std_logic ; -- 0 = add , 1 = sub
   logic_func : in std_logic_vector(1 downto 0 ) ;
   -- 00 = AND, 01 = OR , 10 = XOR , 11 = NOR
   func : in std_logic_vector(1 downto 0 ) ;
   -- 00 = lui, 01 = setless , 10 = arith , 11 = logic
   output : out std_logic_vector(31 downto 0) ;
   overflow : out std_logic ;
   zero : out std_logic);
end alu ;

-- ARCHITECTURE DECLARATION
architecture ALUImplementation of alu is

-- Signals Declaration
signal add_subtract : std_logic_vector(31 downto 0);
signal subtract : std_logic_vector(31 downto 0);

begin

  P_ALU: process (add_sub, func)

  begin
    -- Calculate result of adder subtracter
    if add_sub = '0' then
      add_subtract <= (x+y);
    elsif add_sub = '1' then
      add_subtract <= (x-y);
    end if;


  -- Multiplexer selection
    if func = "00" then
    -- Output is simply y
      output <= y;

    elsif func = "01" then
    -- Output is SLB
      subtract <= (x-y);
      output <= "0000000000000000000000000000000" & subtract(11);

    elsif func = "10" then
      output <= add_subtract;

    elsif func = "11" then
      if logic_func = "00" then
        output <= (x and y);
      elsif logic_func = "01" then
        output <= (x or y);
      elsif logic_func = "10" then
        output <= (x xor y);
      elsif logic_func = "11" then
        output <= (x nor y);
      end if;

    end if;

  -- Set Zero Flag result
    if add_subtract = "00000000000000000000000000000000" then
      zero <= '1';
    else
      zero <= '0';
    end if;

  --Overflow detection. The equation was calculated using truth table with K maping.
    overflow <= ((not x(31)) and (not y(31)) and add_subtract(31)) or (x(31) and y(31) and (not add_subtract(31)) );

  end process P_ALU;

end architecture ;
