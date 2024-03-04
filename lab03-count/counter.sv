module counter (
  input  logic [4:0] data ,
  output logic [4:0] count,
  input  logic       load, enable, clk, rst_
);


  timeunit 1ns;
  timeprecision 100ps;

  always_ff @( posedge clk, negedge rst_ ) begin : main
    if (!rst_) count <= 0;
    else if (load) count <= data;
    else if (enable) count++;
  end




endmodule
