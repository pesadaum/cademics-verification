import typedefs::*;

module alu (
  input  logic [7:0] accum ,
  input  logic [7:0] data  ,
  input  opcode_t    opcode,
  input  logic       clk   ,
  output logic [7:0] out   ,
  output logic       zero
);

  timeunit 1ns;
  timeprecision 100ps;

  always @(negedge clk)
    unique case ( opcode )
      ADD     : out <= accum + data;
      AND     : out <= accum & data;
      XOR     : out <= accum ^ data;
      LDA     : out <=         data;
      HLT,
      SKZ,
      JMP,
      STO     : out <= accum;
      default : out <= 'x;
    endcase


    always_comb begin
      zero = (accum == 0) ? 1 : 0;
    end

endmodule