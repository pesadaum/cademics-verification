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
  input  logic       clk     ,
  output logic       read    ,
  output logic       write   ,
  output logic [4:0] addr    ,
  output logic [7:0] data_in , // data TO memory
  input  wire  [7:0] data_out  // data FROM memory
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
        write_mem (i, 0, debug);
      for (int i = 0; i<32; i++)
        begin
          read_mem (i, rdata, debug);
          // check each memory location for data = 'h00
          error_status = check (i, rdata, 8'h00);
        end
// SYSTEMVERILOG: void function
      printstatus(error_status);

      $display("Data = Address Test");
// SYSTEMVERILOG: enhanced for loop
      for (int i = 0; i< 32; i++)
        write_mem (i, i, debug);
      for (int i = 0; i<32; i++)
        begin
          read_mem (i, rdata, debug);
          // check each memory location for data = address
          error_status = check (i, rdata, i);
        end
// SYSTEMVERILOG: void function
      printstatus(error_status);

      $finish;
    end

  // add read_mem and write_mem tasks

  task write_mem(input [4:0] wr_addr, input [7:0] wr_data, input debug = 0);
    @ (negedge clk) begin
      write <= 1;
      read <= 0;
      addr <= wr_addr;
      data_in <= wr_data;
    end
    @ (negedge clk) begin
      write <= 0;
      if (debug) $display("Write addr: %4h; write data: %4h", wr_data, wr_addr);
    end
  endtask

  task read_mem(input [4:0] rd_addr, output [7:0] rd_data,  input debug = 0);
    @ (negedge clk) begin
      write <= 0;
      read <= 1;
      addr <= rd_addr;
    end
    @ (negedge clk) begin
      // mixing blocking and nonblocking (?)
      read <= 0;
      rd_data = data_out;
      if(debug) if (debug) $display("read addr: %4h; read data: %4h", rd_data, rd_addr);
    end

  endtask

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
