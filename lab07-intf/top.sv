///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : top.sv
// Title       : top module for Memory labs
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the top module for memory labs
// Notes       :
// Memory Lab - top-level
// A top-level module which instantiates the memory and mem_test modules
//
///////////////////////////////////////////////////////////////////////////

module top ();
// SYSTEMVERILOG: timeunit and timeprecision specification
  timeunit 1ns;
  timeprecision 1ns;

  bit clk;

  mem_intf bus (.clk);

  mem_test test (.bus);
  mem memory (.bus);

  always #5 clk = ~clk;
endmodule
