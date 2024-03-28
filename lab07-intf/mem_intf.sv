interface mem_intf (input clk);


// SYSTEMVERILOG: timeunit and timeprecision specification
  timeunit 1ns;
  timeprecision 1ns;

  logic       read, write;
  logic [4:0] addr   ;
  logic [7:0] data_in, data_out;

  modport mem (
    input clk, read, write, addr, data_in,
    output data_out
  );

  modport tb (
    input clk, data_out,
    output read, write, addr, data_in,
    import write_mem, read_mem
  );

  task write_mem(input [4:0] wr_addr, input [7:0] wr_data, input debug = 0);
    @ (negedge bus.clk) begin
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
    @ (negedge bus.clk) begin
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

endinterface //mem_intf