module top_module (
	input clk,
	input x,
	output z
);

	wire xor_in, and_in, or_in;
	wire q_xor, q_and, q_or;
	wire q_and_n, q_or_n;

	// XOR gate and D flip-flop
	xor #( .WIDTH(1) ) xor_gate (
		.in1(x),
		.in2(q_xor),
		.out(xor_in)
	);

	dff #( .WIDTH(1) ) dff_xor (
		.clk(clk),
		.rst(0),  // Assuming no explicit reset signal is provided.  Using implicit reset
		.d(xor_in),
		.q(q_xor)
	);

	// AND gate and D flip-flop
	and #( .WIDTH(1) ) and_gate (
		.in1(x),
		.in2(~q_and),
		.out(and_in)
	);

	dff #( .WIDTH(1) ) dff_and (
		.clk(clk),
		.rst(0),  // Assuming no explicit reset signal is provided.  Using implicit reset
		.d(and_in),
		.q(q_and)
	);


	// OR gate and D flip-flop
	or #( .WIDTH(1) ) or_gate (
		.in1(x),
		.in2(~q_or),
		.out(or_in)
	);

	dff #( .WIDTH(1) ) dff_or (
		.clk(clk),
		.rst(0),  // Assuming no explicit reset signal is provided.  Using implicit reset
		.d(or_in),
		.q(q_or)
	);
	
	// XNOR gate
	xnor3 #( .WIDTH(1) ) xnor_gate (
		.in1(q_xor),
		.in2(q_and),
		.in3(q_or),
		.out(z)
	);

endmodule


module dff (
  input clk,
  input rst,
  input d,
  output reg q
);
  always @(posedge clk) begin
    if (rst)
      q <= 1'b0;  // Synchronous reset.  If not specified, uses implicit reset.
    else
      q <= d;
  end
endmodule


module xor (
    input [WIDTH-1:0] in1,
    input [WIDTH-1:0] in2,
    output [WIDTH-1:0] out
    );
    parameter WIDTH = 1;
    assign out = in1 ^ in2;
endmodule

module and (
    input [WIDTH-1:0] in1,
    input [WIDTH-1:0] in2,
    output [WIDTH-1:0] out
    );
    parameter WIDTH = 1;
    assign out = in1 & in2;
endmodule


module or (
    input [WIDTH-1:0] in1,
    input [WIDTH-1:0] in2,
    output [WIDTH-1:0] out
    );
    parameter WIDTH = 1;
    assign out = in1 | in2;
endmodule


module xnor3 (
    input [WIDTH-1:0] in1,
    input [WIDTH-1:0] in2,
    input [WIDTH-1:0] in3,
    output [WIDTH-1:0] out
    );
    parameter WIDTH = 1;
    assign out = ~(in1 ^ in2 ^ in3);
endmodule