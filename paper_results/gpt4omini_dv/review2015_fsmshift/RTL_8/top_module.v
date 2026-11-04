module top_module(
	input clk,
	input reset,
	output reg shift_ena);

	reg [3:0] counter;

	always @(posedge clk) begin
		if (reset) begin
			counter <= 4'b1111; // Set counter to 4
			shift_ena <= 1'b1;  // Enable shift register
		end else if (counter > 0) begin
			counter <= counter - 1; // Decrement counter
		end else begin
			shift_ena <= 1'b0; // Deassert shift_ena
		end
	end
endmodule