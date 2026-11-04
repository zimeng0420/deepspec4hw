module top_module(
	input clk, 
	input load, 
	input [9:0] data, 
	output reg tc
);

reg [9:0] counter;

always @(posedge clk) begin
	if (load) begin
		counter <= data; // Load new value
		tc <= 0; // Reset terminal count
	end else begin
		if (counter > 0) begin
			counter <= counter - 1; // Decrement
		end
		tc <= (counter == 1); // Terminal count signal
	end
end

endmodule