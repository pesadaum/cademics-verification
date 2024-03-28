///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : control.sv
// Title       : Control Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Control module
// Notes       :
//
///////////////////////////////////////////////////////////////////////////

// import SystemVerilog package for opcode_t and state_t

import typedefs::*;

module control (
  output logic    load_ac,
  output logic    mem_rd ,
  output logic    mem_wr ,
  output logic    inc_pc ,
  output logic    load_pc,
  output logic    load_ir,
  output logic    halt   ,
  input  opcode_t opcode , // opcode type name must be opcode_t
  input           zero   ,
  input           clk    ,
  input           rst_
);
// SystemVerilog: time units and time precision specification
  timeunit 1ns;
  timeprecision 100ps;

  state_t state ;
  logic   alu_op;

  assign alu_op = (opcode inside {AND, ADD, XOR, LDA});

  always_ff @(posedge clk or negedge rst_)
    if (!rst_)
      state <= INST_ADDR;
    else
      state <= state.next();


  always_comb begin

    unique case(state)
      INST_ADDR : {mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr} = 0;

      INST_FETCH : begin
        mem_rd = 1;
        {load_ir, halt, inc_pc, load_ac, load_pc, mem_wr}  = 0;
      end

      INST_LOAD, IDLE : begin
        mem_rd  = 1;
        load_ir = 1;
        {halt, inc_pc, load_ac, load_pc, mem_wr}  = 0;
      end

      OP_ADDR : begin
        {mem_rd, load_ir, load_ac, load_pc, mem_wr}  = 0;
        halt   = opcode == HLT;
        inc_pc = 1;
      end

      OP_FETCH : begin
        mem_rd = alu_op;
        {load_ir, halt, inc_pc, load_ac, load_pc, mem_wr} = 0;
      end

      ALU_OP : begin
        mem_rd  = alu_op;
        {load_ir, halt, mem_wr} = 0;
        inc_pc  = (opcode == SKZ) && zero;
        load_ac = alu_op;
        load_pc = (opcode == JMP);
      end

      STORE : begin
        mem_rd  = alu_op;
        {load_ir, halt} = 0;
        inc_pc  = (opcode == JMP);
        load_ac = alu_op;
        load_pc = (opcode == JMP);
        mem_wr  = (opcode == STO);
      end

      default : {mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr} = 0;
    endcase
  end

endmodule
