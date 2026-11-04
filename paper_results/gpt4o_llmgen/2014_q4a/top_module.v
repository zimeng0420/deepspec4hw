module top_module (
	input clk,
	input w,
	input R,
	input E,
	input L,
	output reg Q
);

always @(posedge clk) begin
    if (L) begin
        // Load operation
        Q <= R;
    end else if (E) begin
        // Shift operation
        Q <= w;
    end
    // If neither load nor shift is enabled, hold the current value
end

endmodule