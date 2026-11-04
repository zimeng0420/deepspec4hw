module top_module (
	input a, 
	input b,
	input c,
	input d,
	output reg out
);

  always @(*) begin
    // Simplified Boolean expression derived from the Karnaugh map:
    // out = (a & c) | (a & d) | (b & c) | (b & d)
    out = (a & c) | (a & d) | (b & c) | (b & d);
  end

endmodule