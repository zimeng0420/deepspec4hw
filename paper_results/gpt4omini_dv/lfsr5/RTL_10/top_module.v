module top_module(
	input clk,
	input reset,
	output reg [4:0] q);

	always @(posedge clk or posedge reset) begin
		if (reset) 
			q <= 5'b00001; 
		else 
			q <= {q[3] ^ q[4], q[4], q[2], q[1], q[0]}; 
	end

endmodule