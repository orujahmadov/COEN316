-- Next address calculator for
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;

entity data_path is
port(
  reset :       in std_logic;
  clk :         in std_logic;
  next_pc :     out std_logic_vector(31 downto 0));
end data_path;

architecture implementation of data_path is

  -- Helper Signals ----------------------
  signal pc : std_logic_vector(31 downto 0);
  signal instruction : std_logic_vector(31 downto 0);
  signal rs : std_logic_vector(4 downto 0);
  signal rt : std_logic_vector(4 downto 0);
  signal rd : std_logic_vector(4 downto 0);
  signal immediate : std_logic_vector(15 downto 0);
  signal overflow: std_logic;
  signal zero: std_logic;

  signal sign_extend_output:    std_logic_vector(31 downto 0);
  signal alu_y:                 std_logic_vector(31 downto 0);
  signal alu_output:            std_logic_vector(31 downto 0);
  signal dcache_output:         std_logic_vector(31 downto 0);
  signal write_reg_data   :     std_logic_vector(31 downto 0);
  signal write_reg_address:     std_logic_vector(4 downto 0);
  signal reg_out_a:             std_logic_vector(31 downto 0);
  signal reg_out_b:             std_logic_vector(31 downto 0);

  ----------------------------------------

  -- Control Signals -------------

  -- Single bit outputs
  signal reg_write:     std_logic;
  signal reg_dst:       std_logic;
  signal reg_in_src:    std_logic;
  signal alu_src:       std_logic;
  signal add_sub:       std_logic;
  signal data_write:    std_logic;

  -- Two bit outputs
  signal logic_func:    std_logic_vector(1 downto 0);
  signal func:          std_logic_vector(1 downto 0);
  signal branch_type:   std_logic_vector(1 downto 0);
  signal pc_sel:        std_logic_vector(1 downto 0));

  ------------------------------

-- C O M P O N E N T S

  component mux2to1_5bit
  port(
    X,Y : in std_logic_vector(4 downto 0);
      S : in std_logic;
      Z : out std_logic_vector(4 downto 0));
  end component;

  component mux2to1_32bit
  port(
    X,Y : in std_logic_vector(31 downto 0);
      S : in std_logic;
      Z : out std_logic_vector(31 downto 0));
  end component;

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
       -- two register inputs
     rt, rs : in std_logic_vector(31 downto 0);
     pc : in std_logic_vector(31 downto 0);
     target_address : in std_logic_vector(25 downto 0);
     branch_type : in std_logic_vector(1 downto 0);
     pc_sel : in std_logic_vector(1 downto 0);
     next_pc : out std_logic_vector(31 downto 0));
  end component;

  -- Control Unit component
  component control_unit
  port(
    -- INPUTS
    func_code:      in std_logic_vector(5 downto 0);
    opcode:         in std_logic_vector(5 downto 0);

    -- Single bit outputs
    reg_write:     out std_logic;
    reg_dst:       out std_logic;
    reg_in_src:    out std_logic;
    alu_src:       out std_logic;
    add_sub:       out std_logic;
    data_write:    out std_logic;

    -- Two bit outputs
    logic_func:    out std_logic_vector(1 downto 0);
    func:          out std_logic_vector(1 downto 0);
    branch_type:   out std_logic_vector(1 downto 0);
    pc_sel:        out std_logic_vector(1 downto 0));
  end component;

begin

  -- PC Register
  PC_R: pc_register port map (pc, reset, clk, pc);

  -- Instruction Cache
  IC: icache port map (pc(4 downto 0), instruction);

  -- Control Unit
  CU: control_unit port map (instruction(31 downto 26), instruction(31 downto 26), reg_write, reg_dst, reg_in_src, alu_src, add_sub, data_write, logic_func, func, branch_type, pc_sel);

  -- NEXT Address
  NA: next_address port map (instruction(20 downto 16), instruction(25 downto 21), pc, instruction(25 downto 0), branch_type, pc_sel, pc);

  -- First MUX use to choose reg destination address for write
  MUX1: mux2to1_5bit port map (instruction(20 downto 16), instruction(16 downto 11), reg_dst, write_reg_address);

  -- Register File
  RF: register_file port map (write_reg_data, reset, clk, reg_write, instruction(25 downto 21), instruction(20 downto 16), write_reg_address, reg_out_a, reg_out_b);

  -- Sign Extend
  SE: sign_extend port map (instruction(15 downto 0), func, sign_extend_output);

  -- Second MUX use to choose rt for ALU
  MUX2: mux2to1_32bit port map (reg_out_b, sign_extend_output, alu_src, alu_y);

  -- ALU
  ALU: ALU port map (reg_out_a, alu_y, add_sub, logic_func, func, alu_output, overflow, zero);

  -- Data Cache
  DC: dcache port map (alu_output(4 downto 0), reg_out_b, data_write, reset, clk => clk, dcache_output);

  -- Third MUX use to choose Write back data
  MUX3: mux2to1_32bit port map (dcache_output, alu_output, reg_in_src, write_reg_data);

end implementation;
