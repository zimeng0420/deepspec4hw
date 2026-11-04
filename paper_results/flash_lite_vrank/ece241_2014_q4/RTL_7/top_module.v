module top_module (
	input clk,
	input x,
	output z
);

	wire xor_out, and_out, or_out;
	wire q_xor, q_and, q_or;
	wire not_q_xor, not_q_and, not_q_or;

	// XOR gate
	assign xor_out = x ^ q_xor;

	// AND gate
	assign and_out = x & not_q_and;

	// OR gate
	assign or_out = x | not_q_or;

	// D flip-flops
	always @(posedge clk) begin
		q_xor <= xor_out;
	end

	always @(posedge clk) begin
		q_and <= and_out;
	end

	always @(posedge clk) begin
		q_or <= or_out;
	end

	// Inverters for flip-flop outputs
	assign not_q_xor = ~q_xor;
	assign not_q_and = ~q_and;
	assign not_q_or = ~q_or;
	
	// XNOR gate
	assign z = ~(q_xor ^ q_and ^ q_or);


endmodule