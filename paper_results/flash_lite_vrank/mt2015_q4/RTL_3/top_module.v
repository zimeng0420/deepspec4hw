module top_module(
	input x,
	input y,
	output z);

	wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;

	// Module A instantiation
	module_a a1 (
		.x(x),
		.y(y),
		.z(a1_out)
	);

	module_a a2 (
		.x(x),
		.y(y),
		.z(a2_out)
	);


	// Module B instantiation
	module_b b1 (
		.x(x),
		.y(y),
		.z(b1_out)
	);

	module_b b2 (
		.x(x),
		.y(y),
		.z(b2_out)
	);

	// OR gate
	or_gate or_inst (
		.in1(a1_out),
		.in2(b1_out),
		.out(or_out)
	);

	// AND gate
	and_gate and_inst (
		.in1(a2_out),
		.in2(b2_out),
		.out(and_out)
	);

	// XOR gate
	xor_gate xor_inst (
		.in1(or_out),
		.in2(and_out),
		.out(z)
	);

endmodule

// Module A implementation
module module_a(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

// Module B implementation
module module_b(
    input x,
    input y,
    output z
);
    reg z_reg;

    always @(x or y) begin
        case({x, y})
            2'b00: z_reg = 1'b1;
            2'b10: z_reg = 1'b0;
            2'b01: z_reg = 1'b0;
            2'b11: z_reg = 1'b1;
            default: z_reg = 1'b0;
        endcase
    end
	
    assign z = z_reg;
endmodule

// OR gate implementation
module or_gate(
    input in1,
    input in2,
    output out
);
    assign out = in1 | in2;
endmodule

// AND gate implementation
module and_gate(
    input in1,
    input in2,
    output out
);
    assign out = in1 & in2;
endmodule

// XOR gate implementation
module xor_gate(
    input in1,
    input in2,
    output out
);
    assign out = in1 ^ in2;
endmodule