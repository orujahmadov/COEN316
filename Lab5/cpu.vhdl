-- Next address calculator for
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity cpu is
  port(
    reset :           in std_logic;
    clk :             in std_logic;
    rs_out, rt_out :  out std_logic_vector(3 downto 0);
   -- output ports from register file
    pc_out :          out std_logic_vector(3 downto 0); -- pc reg
    overflow, zero :  out std_logic); -- will not be constrained
end cpu;

architecture implementation of cpu is

  -- Helper Signals ----------------------
  signal pc : std_logic_vector(31 downto 0);
  signal instruction : std_logic_vector(31 downto 0);

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
  signal pc_sel:        std_logic_vector(1 downto 0);

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
  component regfile
  port( din : in std_logic_vector(31 downto 0);
     reset : in std_logic;
     clk : in std_logic;
     reg_write : in std_logic;
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
     rt, rs : in std_logic_vector(4 downto 0);
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
	opcode:         in std_logic_vector(5 downto 0);
    func_code:      in std_logic_vector(5 downto 0);

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

  -- Instruction Cache
  IC: icache port map (address => pc(4 downto 0), data => instruction);

  -- Control Unit.
  CU: control_unit port map (opcode => instruction(31 downto 26), func_code => instruction(5 downto 0), reg_write => reg_write, reg_dst => reg_dst, reg_in_src => reg_in_src, alu_src => alu_src, add_sub => add_sub, data_write => data_write, logic_func => logic_func, func => func, branch_type => branch_type, pc_sel => pc_sel);

  -- NEXT Address
  NA: next_address port map (rs => instruction(25 downto 21), rt => instruction(20 downto 16), pc => pc, target_address => instruction(25 downto 0), branch_type => branch_type, pc_sel => pc_sel, next_pc => pc);

  -- First MUX use to choose reg destination address for write
  MUX1: mux2to1_5bit port map (X => instruction(20 downto 16), Y => instruction(15 downto 11), S => reg_dst, Z => write_reg_address);

  -- Register File
  RF: regfile port map (din => write_reg_data, reset => reset, clk => clk, reg_write => reg_write, read_a => instruction(25 downto 21), read_b => instruction(20 downto 16), write_address => write_reg_address, out_a => reg_out_a, out_b => reg_out_b);

  -- Sign Extend
  SE: sign_extend port map (immediate_field => instruction(15 downto 0), func => func, output_address => sign_extend_output);

  -- Second MUX use to choose rt for ALU
  MUX2: mux2to1_32bit port map (X => reg_out_b, Y => sign_extend_output, S => alu_src, Z => alu_y);

  -- ALU
  ALUCP: ALU port map (x => reg_out_a, y => alu_y, add_sub => add_sub, logic_func => logic_func, func => func, output => alu_output, overflow => overflow, zero => zero);

  -- Data Cache
  DC: dcache port map (address => alu_output(4 downto 0), din => reg_out_b, data_write => data_write, reset => reset, clk => clk, data_output => dcache_output);

  -- Third MUX use to choose Write back data
  MUX3: mux2to1_32bit port map (X => dcache_output, Y => alu_output, S => reg_in_src, Z => write_reg_data);
  
  rs_out <= reg_out_a(3 downto 0);
  rt_out <= reg_out_b(3 downto 0);
  pc_out <= pc(3 downto 0);
  
  
  pcRegister : process(reset, clk)
  begin
    if reset = '1' then
        pc <= (others => '0');
    elsif clk = '1'  and clk'event then
      pc <= pc;
    end if;
  end process;

end implementation;
