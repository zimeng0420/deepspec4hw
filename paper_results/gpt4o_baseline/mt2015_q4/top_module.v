module top_module(
    input x,
    input y,
    output z
);

    wire a1_out, a2_out; // Outputs of Module A instances
    wire b1_out, b2_out; // Outputs of Module B instances
    wire or_out, and_out; // Outputs of OR and AND gates

    // Module A instantiations
    module_A u_a1 (
        .x(x),
        .y(y),
        .z(a1_out)
    );

    module_A u_a2 (
        .x(x),
        .y(y),
        .z(a2_out)
    );

    // Module B instantiations
    module_B u_b1 (
        .x(x),
        .y(y),
        .z(b1_out)
    );

    module_B u_b2 (
        .x(x),
        .y(y),
        .z(b2_out)
    );

    // OR gate
    assign or_out = a1_out | b1_out;

    // AND gate
    assign and_out = a2_out & b2_out;

    // Final XOR gate
    assign z = or_out ^ and_out;

endmodule

// Module A: z = (x ^ y) & x
module module_A(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: Implements the simulation waveform
module module_B(
    input x,
    input y,
    output reg z
);
    always @(*) begin
        // Simulate the behavior of Module B based on the given waveform
        case ({x, y})
            2'b00: z = 1;
            2'b01: z = 0;
            2'b10: z = 0;
            2'b11: z = 1;
        endcase
    end
endmodule