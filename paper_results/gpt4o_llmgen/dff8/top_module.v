module top_module(
	input clk,
	input [7:0] d,
	output reg [7:0] q
);

    // On the positive edge of the clock
    always @(posedge clk) begin
        q <= d; // Latch input data to output on the rising edge
    end

endmodule