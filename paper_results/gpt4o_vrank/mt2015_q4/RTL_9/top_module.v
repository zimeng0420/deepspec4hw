module top_module(
    input x,
    input y,
    output z
);

    wire z1_A, z1_B, z2_A, z2_B;
    wire or_out, and_out;

    // Module A: Implements z = (x ^ y) & x
    module A(
        input x,
        input y,
        output z
    );
        assign z = (x ^ y) & x;
    endmodule

    // Module B: Defined by simulation waveform
    module B(
        input x,
        input y,
        output reg z
    );
        always @(*) begin
            case({x, y})
                2'b00: z = 1;
                2'b01: z = 0;
                2'b10: z = 0;
                2'b11: z = 1;
                default: z = 0;
            endcase
        end
    endmodule

    // Instantiate the modules
    A A1 (.x(x), .y(y), .z(z1_A));
    B B1 (.x(x), .y(y), .z(z1_B));

    A A2 (.x(x), .y(y), .z(z2_A));
    B B2 (.x(x), .y(y), .z(z2_B));

    // Combine outputs
    assign or_out = z1_A | z1_B;
    assign and_out = z2_A & z2_B;
    assign z = or_out ^ and_out;

endmodule