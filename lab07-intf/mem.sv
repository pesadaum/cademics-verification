///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mem.sv
// Title       : Memory Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the memory module
// Notes       :
// Synchronous 8x32 Memory Design
// Specification:
//  Memory is 8-bits wide and address range is 0 to 31.
//  Memory access is synchronous.
//  Write data into the memory on posedge of bus.clk when write=1
//  Place memory[addr] onto data bus on posedge of bus.clk when read=1
//  The read and write signals should not be simultaneously high.
//
///////////////////////////////////////////////////////////////////////////

module mem (
  mem_intf.mem    bus
);
// SYSTEMVERILOG: timeunit and timeprecision specification
  timeunit 1ns;
  timeprecision 1ns;

// SYSTEMVERILOG: logic data type
  logic [7:0] memory[0:31];

  always @(posedge bus.clk)
    if (bus.write && !bus.read)
// SYSTEMVERILOG: time literals
      #1 memory[bus.addr] <= bus.data_in;

// SYSTEMVERILOG: always_ff and iff event control
  always_ff @(posedge bus.clk iff ((bus.read == '1)&&(bus.write == '0)) )
    bus.data_out <= memory[bus.addr];

endmodule
