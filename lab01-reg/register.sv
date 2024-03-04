module register #(localparam WIDTH = 8) (
  output logic [WIDTH-1:0] out ,
  input  logic [WIDTH-1:0] data,
  input  logic             clk, rst_, enable
);

  // just using the same timescale of tb module
  timeunit 1ns; 
  timeprecision 100ps;

  always_ff @(posedge clk, negedge rst_) begin : main
    if (!rst_) begin
      out <= 0;
    end
    else if(enable) begin
      out <= data;
    end
  end

endmodule