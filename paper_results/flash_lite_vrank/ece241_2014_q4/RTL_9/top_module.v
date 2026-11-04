module top_module (
	input clk,
	input x,
	output z
);

	wire xor_in, and_in, or_in;
	wire xor_out, and_out, or_out;
	wire q_xor, q_and, q_or;
	wire q_and_n, q_or_n;

	// XOR gate and D flip-flop
	xor #(1) xor_gate (
		.in1(x),
		.in2(q_xor),
		.out(xor_out)
	);

	dff dff_xor (
		.clk(clk),
		.d(xor_out),
		.q(q_xor)
	);


	// AND gate and D flip-flop
	not #(1) not_and (
		.in(q_and),
		.out(q_and_n)
	);

	and #(1) and_gate (
		.in1(x),
		.in2(q_and_n),
		.out(and_out)
	);

	dff dff_and (
		.clk(clk),
		.d(and_out),
		.q(q_and)
	);


	// OR gate and D flip-flop
	not #(1) not_or (
		.in(q_or),
		.out(q_or_n)
	);

	or #(1) or_gate (
		.in1(x),
		.in2(q_or_n),
		.out(or_out)
	);

	dff dff_or (
		.clk(clk),
		.d(or_out),
		.q(q_or)
	);


	// XNOR gate
	xnor3 #(1) xnor_gate (
		.in1(q_xor),
		.in2(q_and),
		.in3(q_or),
		.out(z)
	);



endmodule


// XOR gate
module xor (
  parameter WIDTH = 1,
  input  [WIDTH-1:0] in1,
  input  [WIDTH-1:0] in2,
  output [WIDTH-1:0] out
);
  assign out = in1 ^ in2;
endmodule

// AND gate
module and (
  parameter WIDTH = 1,
  input  [WIDTH-1:0] in1,
  input  [WIDTH-1:0] in2,
  output [WIDTH-1:0] out
);
  assign out = in1 & in2;
endmodule

// OR gate
module or (
  parameter WIDTH = 1,
  input  [WIDTH-1:0] in1,
  input  [WIDTH-1:0] in2,
  output [WIDTH-1:0] out
);
  assign out = in1 | in2;
endmodule

// D Flip-Flop
module dff (
	input clk,
	input d,
	output reg q
);

	always @(posedge clk) begin
		q <= d;
	end

endmodule

// Not Gate
module not (
  parameter WIDTH = 1,
  input  [WIDTH-1:0] in,
  output [WIDTH-1:0] out
);
  assign out = ~in;
endmodule


// Three-input XNOR
module xnor3 (
	parameter WIDTH = 1,
	input [WIDTH-1:0] in1,
	input [WIDTH-1:0] in2,
	input [WIDTH-1:0] in3,
	output [WIDTH-1:0] out
);
	assign out = ~( (in1 ^ in2) ^ in3 );
endmodule