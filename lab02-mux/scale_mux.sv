module scale_mux #(parameter WIDTH = 1) (
  input  logic [WIDTH-1:0] in_a, in_b,
  output logic [WIDTH-1:0] out,
  input                    sel_a
);

  // just using the same timescale of tb module
  timeunit        1ns ;
  timeprecision 100ps ;

  always_comb begin : main
    unique case (sel_a)
      '1      : out = in_a;
      '0      : out = in_b ;
      default : out = 'X;
    endcase
  end

endmodule