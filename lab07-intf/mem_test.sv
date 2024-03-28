///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mem_test.sv
// Title       : Memory Testbench Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Memory testbench module
// Notes       :
//
///////////////////////////////////////////////////////////////////////////

module mem_test (
  mem_intf.tb    bus
);
// SYSTEMVERILOG: timeunit and timeprecision specification
  timeunit 1ns;
  timeprecision 1ns;

// SYSTEMVERILOG: new data types - bit ,logic
  bit         debug = 1;
  logic [7:0] rdata    ; // stores data read from memory for checking

// Monitor Results
  initial begin
    $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
    #40000ns $display ( "MEMORY TEST TIMEOUT" );
    $finish;
  end

  initial
    begin: memtest
      int error_status;

      $display("Clear Memory Test");
// SYSTEMVERILOG: enhanced for loop
      for (int i = 0; i< 32; i++)
        bus.write_mem (i, 0, debug);
      for (int i = 0; i<32; i++)
        begin
          bus.read_mem (i, rdata, debug);
          // check each memory location for data = 'h00
          error_status = check (i, rdata, 8'h00);
        end
// SYSTEMVERILOG: void function
      printstatus(error_status);

      $display("Data = Address Test");
// SYSTEMVERILOG: enhanced for loop
      for (int i = 0; i< 32; i++)
        bus.write_mem (i, i, debug);
      for (int i = 0; i<32; i++)
        begin
          bus.read_mem (i, rdata, debug);
          // check each memory location for data = address
          error_status = check (i, rdata, i);
        end
// SYSTEMVERILOG: void function
      printstatus(error_status);

      $finish;
    end

  // add read_mem and bus.write_mem tasks

  

// add result print function
  function void printstatus (input int status);
    if(status == 0) $display("TEST PASSED");
    else $display("TEST FAILED");
  endfunction


  function int check(input [7:0] address, input [4:0] expected, input [4:0] obtained);
    static int err_count = 0;

    if (obtained != expected) begin
      $display ("Error: obtained=%4h | expected=%4h | address=%7h", obtained, expected, address);
      err_count++;
    end

    return err_count;
  endfunction //



endmodule
