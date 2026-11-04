module top_module(
    input x,
    input y,
    output z
);

    wire a1_out, a2_out, b1_out, b2_out;
    wire or_out, and_out;

    // Module A: z = (x^y) & x
    module A(input a, input b, output z);
        assign z = (a ^ b) & a;
    endmodule

    // Module B: Implemented using simulation waveform
    module B(input a, input b, output reg z);
        always @(*) begin
            if (a == 0 && b == 0)
                z = 1;
            else if (a == 1 && b == 1)
                z = 1;
            else
                z = 0;
        end
    endmodule

    // Instantiate modules A and B
    A instance_A1(.a(x), .b(y), .z(a1_out));
    A instance_A2(.a(x), .b(y), .z(a2_out));
    B instance_B1(.a(x), .b(y), .z(b1_out));
    B instance_B2(.a(x), .b(y), .z(b2_out));

    // OR and AND gates
    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;

    // XOR gate to produce output z
    assign z = or_out ^ and_out;

endmodule