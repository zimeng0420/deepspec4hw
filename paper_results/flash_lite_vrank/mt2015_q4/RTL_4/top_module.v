module top_module(
	input x,
	input y,
	output z);

	wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;

	// Module A instantiation
	module_A a1 (
		.x(x),
		.y(y),
		.z(a1_out)
	);

	module_A a2 (
		.x(x),
		.y(y),
		.z(a2_out)
	);


	// Module B instantiation
	module_B b1 (
		.x(x),
		.y(y),
		.z(b1_out)
	);

	module_B b2 (
		.x(x),
		.y(y),
		.z(b2_out)
	);

	// OR gate
	assign or_out = a1_out | b1_out;

	// AND gate
	assign and_out = a2_out & b2_out;

	// XOR gate
	assign z = or_out ^ and_out;

endmodule

module module_A(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

module module_B(
    input x,
    input y,
    output z
);

    reg z_reg;
    always @(x or y) begin
        case({x,y})
            2'b00: z_reg = 1'b1;
            2'b10: z_reg = 1'b0;
            2'b01: z_reg = 1'b0;
            2'b11: z_reg = 1'b1;
            default: z_reg = 1'b0; // Handle any unforeseen states.  Although impossible in the problem definition
        endcase
    end

    assign z = z_reg;
endmodule