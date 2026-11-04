module top_module (
	input [2:0] a, 
	output reg [15:0] q
);

  always @(*) begin
    q = (a * a * 10000) + (a * 1000) + 4658;
  end

endmodule