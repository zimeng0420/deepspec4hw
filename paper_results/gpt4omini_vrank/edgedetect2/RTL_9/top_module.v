module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] anyedge
);
	reg [7:0] in_d; // delay register to store previous value

	always @(posedge clk) begin
		anyedge <= 0; // reset anyedge on every clock
		in_d <= in;   // store the current input value
		anyedge <= (in & ~in_d); // detect 0 to 1 transitions
	end
endmodule