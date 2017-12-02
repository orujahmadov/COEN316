-- Next address calculator for
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;

entity control_unit is
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

end control_unit;

architecture implementation of control_unit is
  -- Signals

begin
  process (opcode)
  begin
    case opcode is

    -- R-type instruction
      when "000000" =>
       -- Common outputs. These are same for all R-type instructions

       -- Single bit outputs
         reg_write    <= "1";
         reg_dst      <= "1";
         reg_in_src   <= "1";
         alu_src      <= "0";
         data_write   <= "0";

       -- Two bit outputs
         branch_type <= "00";
         pc_sel      <= "00";

         case func_code is
           -- Add
            when "100000" =>
              add_sub     <= "0";
              logic_func  <= "00";
              func        <= "10";
          -- Subtract
            when "100010" =>
              add_sub     <= "1";
              logic_func  <= "00";
              func        <= "10";
            -- SLT
            when "101010" =>
             add_sub     <= "1";
             logic_func  <= "00";
             func        <= "01";
          -- AND
            when "100100" =>
             add_sub     <= "1";
             logic_func  <= "00";
             func        <= "11";
          -- OR
            when "100000" =>
              add_sub     <= "1";
              logic_func  <= "01";
              func        <= "11";
          -- XOR
            when "100010" =>
              add_sub     <= "1";
              logic_func  <= "10";
              func        <= "11";
          -- NOR
            when "100010" =>
              add_sub     <= "1";
              logic_func  <= "11";
              func        <= "11";
          -- Should not happen
            when others =>
              null;
        end case;

    -- Immediate instructions

      -- LUI
      when "001111" =>
      -- Single bit outputs
        reg_write    <= "1";
        reg_dst      <= "1";
        reg_in_src   <= "1";
        alu_src      <= "0";
        add_sub      <= "1";
        data_write   <= "0";

      -- Two bit outputs
        logic_func  <= "00";
        func        <= "10";
        branch_type <= "00";
        pc_sel      <= "00";

      -- SLTI
      when "001010" =>
      -- Single bit outputs
        reg_write    <= "1";
        reg_dst      <= "0";
        reg_in_src   <= "1";
        alu_src      <= "1";
        add_sub      <= "1";
        data_write   <= "0";

      -- Two bit outputs
        logic_func  <= "00";
        func        <= "01";
        branch_type <= "00";
        pc_sel      <= "00";

      -- ADDI
      when "001000" =>
      -- Single bit outputs
        reg_write    <= "1";
        reg_dst      <= "0";
        reg_in_src   <= "1";
        alu_src      <= "1";
        add_sub      <= "0";
        data_write   <= "0";

      -- Two bit outputs
        logic_func  <= "00";
        func        <= "10";
        branch_type <= "00";
        pc_sel      <= "00";

     --  ANDI
     when "001100" =>
     -- Single bit outputs
       reg_write    <= "1";
       reg_dst      <= "0";
       reg_in_src   <= "1";
       alu_src      <= "1";
       add_sub      <= "0";
       data_write   <= "0";

     -- Two bit outputs
       logic_func  <= "01";
       func        <= "11";
       branch_type <= "00";
       pc_sel      <= "00";

    -- ORI
    when "001101" =>
    -- Single bit outputs
      reg_write    <= "1";
      reg_dst      <= "0";
      reg_in_src   <= "1";
      alu_src      <= "1";
      add_sub      <= "0";
      data_write   <= "0";

    -- Two bit outputs
      logic_func  <= "10";
      func        <= "11";
      branch_type <= "00";
      pc_sel      <= "00";

    -- XORI
    when "001110" =>
    -- Single bit outputs
      reg_write    <= "1";
      reg_dst      <= "0";
      reg_in_src   <= "1";
      alu_src      <= "1";
      add_sub      <= "0";
      data_write   <= "0";

    -- Two bit outputs
      logic_func  <= "11";
      func        <= "11";
      branch_type <= "00";
      pc_sel      <= "00";

    -- LW
    when "100011" =>
    -- Single bit outputs
      reg_write    <= "1";
      reg_dst      <= "0";
      reg_in_src   <= "0";
      alu_src      <= "1";
      add_sub      <= "0";
      data_write   <= "0";

    -- Two bit outputs
      logic_func  <= "10";
      func        <= "10";
      branch_type <= "00";
      pc_sel      <= "00";

    -- SW
    when "101011" =>
    -- Single bit outputs
      reg_write    <= "0";
      reg_dst      <= "0";
      reg_in_src   <= "0";
      alu_src      <= "1";
      add_sub      <= "0";
      data_write   <= "1";

    -- Two bit outputs
      logic_func  <= "10";
      func        <= "10";
      branch_type <= "00";
      pc_sel      <= "00";

    -- BLTZ
    when "000001" =>
    -- Single bit outputs
      reg_write    <= "0";
      reg_dst      <= "0";
      reg_in_src   <= "0";
      alu_src      <= "0";
      add_sub      <= "0";
      data_write   <= "0";

    -- Two bit outputs
      logic_func  <= "00";
      func        <= "00";
      branch_type <= "11";
      pc_sel      <= "00";

    -- BEQ
    when "000100" =>
    -- Single bit outputs
      reg_write    <= "0";
      reg_dst      <= "0";
      reg_in_src   <= "0";
      alu_src      <= "0";
      add_sub      <= "0";
      data_write   <= "0";

    -- Two bit outputs
      logic_func  <= "00";
      func        <= "00";
      branch_type <= "01";
      pc_sel      <= "00";

    -- BNE
    when "000101" =>
    -- Single bit outputs
      reg_write    <= "0";
      reg_dst      <= "0";
      reg_in_src   <= "0";
      alu_src      <= "0";
      add_sub      <= "0";
      data_write   <= "0";

    -- Two bit outputs
      logic_func  <= "00";
      func        <= "00";
      branch_type <= "10";
      pc_sel      <= "00";

    -- JUMP
    when "000101" =>
    -- Single bit outputs
      reg_write    <= "0";
      reg_dst      <= "0";
      reg_in_src   <= "0";
      alu_src      <= "0";
      add_sub      <= "0";
      data_write   <= "0";

    -- Two bit outputs
      logic_func  <= "00";
      func        <= "00";
      branch_type <= "00";
      pc_sel      <= "01";

    -- JUMP RS
    when "000101" =>
    -- Single bit outputs
      reg_write    <= "0";
      reg_dst      <= "0";
      reg_in_src   <= "0";
      alu_src      <= "0";
      add_sub      <= "0";
      data_write   <= "0";

    -- Two bit outputs
      logic_func  <= "00";
      func        <= "00";
      branch_type <= "00";
      pc_sel      <= "10";

    when others =>
      null;

      end case;
  end process;

end implementation;
