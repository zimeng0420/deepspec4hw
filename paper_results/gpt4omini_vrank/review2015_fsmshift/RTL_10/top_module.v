module top_module(
	input clk,
	input reset,
	output reg shift_ena
);
	reg [1:0] count; // 2-bit counter to count 4 cycles

	always @(posedge clk) begin
		if (reset) begin
			shift_ena <= 1'b1; // Enable shift register on reset
			count <= 2'b00; // Reset count to 0
		end else if (count < 2'b11) begin
			count <= count + 1; // Increment count
			shift_ena <= 1'b1; // Keep shift_ena asserted
		end else begin
			shift_ena <= 1'b0; // Deassert shift_ena after 4 cycles
		end
	end
endmodule