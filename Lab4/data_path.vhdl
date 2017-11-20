-- Next address calculator for
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;

entity data_path is
port(
  reg_dst:      in std_logic;
  alu_src:      in std_logic;
  reg_in_src:   in std_logic;
  reset :       in std_logic;
  clk :         in std_logic;
  next_pc :     out std_logic_vector(31 downto 0));
end data_path;

architecture DPImplementation of data_path is

  -- Signals
  signal pc : std_logic_vector(31 downto 0);
  signal instruction : std_logic_vector(31 downto 0);
  signal rs : std_logic_vector(4 downto 0);
  signal rt : std_logic_vector(4 downto 0);
  signal rd : std_logic_vector(4 downto 0);
  signal immediate : std_logic_vector(15 downto 0);
  signal target_address : std_logic_vector(25 downto 0);

  -- Data Cache Component
  component dcache
  port(
    address : in std_logic_vector(4 downto 0);
    din : in std_logic_vector(31 downto 0);
    data_write : in std_logic;
    reset : in std_logic;
    clk : in std_logic;
    data_output : out std_logic_vector(31 downto 0));
  end component;

  -- Instruction Cache Component
  component icache
  port(
    address : in std_logic_vector(4 downto 0);
    data : out std_logic_vector(31 downto 0));
  end component;

  -- PC Register Cache Component
  component pc_register
  port(
   pc : in std_logic_vector(31 downto 0);
   reset : in std_logic;
   clk : in std_logic;
   next_pc : out std_logic_vector(31 downto 0));
  end component;

  -- Sign Extension Component
  component sign_extend
  port(
    immediate_field : in std_logic_vector(15 downto 0);
    func : in std_logic_vector(1 downto 0);
    output_address : out std_logic_vector(31 downto 0));
  end component;

  -- ALU Component
  component ALU
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
  end component;

  -- Register Component
  component register_file
  port( din : in std_logic_vector(31 downto 0);
     reset : in std_logic;
     clk : in std_logic;
     write : in std_logic;
     read_a : in std_logic_vector(4 downto 0);
     read_b : in std_logic_vector(4 downto 0);
     write_address : in std_logic_vector(4 downto 0);
     out_a : out std_logic_vector(31 downto 0);
     out_b : out std_logic_vector(31 downto 0));
  end component;

  -- Next Address component
  component next_address
  port(
   rt, rs : in std_logic_vector(31 downto 0);
   -- two register inputs
   pc : in std_logic_vector(31 downto 0);
   target_address : in std_logic_vector(25 downto 0);
   branch_type : in std_logic_vector(1 downto 0);
   pc_sel : in std_logic_vector(1 downto 0);
   next_pc : out std_logic_vector(31 downto 0));
  end component;

begin


  -- PC Register
  PC_R: pc_register port map (pc => pc, reset => reset, clk => clk, pc => next_pc);

  -- NEXT Address
  NA: next_address port map ( ?? => rt, ?? => rs, pc => pc, ??=> target_address, => branch_type, ??=>pc_sel, pc => next_pc);

  -- Instruction Cache
  IC: icache port map (pc(4 downto 0) => address, instruction => data);

  -- Register File
  RF: register_file port map ( => din, reset => reset, clk => clk, => write, =>read_a, =>read_b, => write_address, => out_a, => out_b);

  -- ALU
  ALU: ALU port map (=> x, => y, add_sub => , => logic_func, => func, => output, => overflow, =>zero);

  -- Data Cache
  DC: dcache port map (=> address, => din, => data_write, => reset => reset, clk => clk, => data_output);

  -- Sign Extend
  SE: sign_extend port map ( => immediate_field, => func, => output_address);




end DPImplementation;
