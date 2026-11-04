module top_module (
	input clk,
	input x,
	output z
);

	// Internal signals
	wire xor_out, and_out, or_out;
	wire q_xor, q_and, q_or;
	wire not_and, not_or;

	// XOR gate and D flip-flop
	xor u1_xor (
		.in1(x),
		.in2(q_xor),
		.out(xor_out)
	);

	dff u2_dff_xor (
		.clk(clk),
		.d(xor_out),
		.q(q_xor)
	);

	// AND gate and D flip-flop
	not u3_not_and (
		.in(q_and),
		.out(not_and)
	);

	and u4_and (
		.in1(x),
		.in2(not_and),
		.out(and_out)
	);

	dff u5_dff_and (
		.clk(clk),
		.d(and_out),
		.q(q_and)
	);

	// OR gate and D flip-flop
	not u6_not_or (
		.in(q_or),
		.out(not_or)
	);

	or u7_or (
		.in1(x),
		.in2(not_or),
		.out(or_out)
	);

	dff u8_dff_or (
		.clk(clk),
		.d(or_out),
		.q(q_or)
	);

	// XNOR gate
	xnor u9_xnor (
		.in1(q_xor),
		.in2(q_and),
		.in3(q_or),
		.out(z)
	);


endmodule

// XOR gate module
module xor (
	input in1,
	input in2,
	output out
);
	assign out = in1 ^ in2;
endmodule

// AND gate module
module and (
	input in1,
	input in2,
	output out
);
	assign out = in1 & in2;
endmodule

// OR gate module
module or (
	input in1,
	input in2,
	output out
);
	assign out = in1 | in2;
endmodule

// NOT gate module
module not (
	input in,
	output out
);
	assign out = ~in;
endmodule

// D flip-flop module
module dff (
	input clk,
	input d,
	output reg q
);

	always @(posedge clk) begin
		q <= d;
	end

endmodule

// XNOR gate module
module xnor (
	input in1,
	input in2,
	input in3,
	output out
);
	assign out = ~( (in1 ^ in2) ^ in3 );
endmodule