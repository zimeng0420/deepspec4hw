module top_module(
	input a, 
	input b,
	output out_assign,
	output reg out_alwaysblock
);

  // Continuous Assignment using 'assign'
  assign out_assign = a & b;

  // Combinational Always Block
  always @(*) begin
    out_alwaysblock = a & b;
  end

endmodule