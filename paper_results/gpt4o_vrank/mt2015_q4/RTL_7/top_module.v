module top_module(
    input x,
    input y,
    output z
);

    wire A1_out, B1_out, A2_out, B2_out;
    wire OR_out, AND_out;

    // Module A implementation
    module A(
        input x,
        input y,
        output z
    );
        assign z = (x ^ y) & x;
    endmodule

    // Module B implementation
    module B(
        input x,
        input y,
        output reg z
    );
        always @(*) begin
            case ({x, y})
                2'b00: z = 1;
                2'b01: z = 0;
                2'b10: z = 0;
                2'b11: z = 1;
            endcase
        end
    endmodule

    // Instantiate A and B submodules
    A A1(.x(x), .y(y), .z(A1_out));
    B B1(.x(x), .y(y), .z(B1_out));

    A A2(.x(x), .y(y), .z(A2_out));
    B B2(.x(x), .y(y), .z(B2_out));

    // OR and AND gates
    assign OR_out = A1_out | B1_out;
    assign AND_out = A2_out & B2_out;

    // XOR gate for final output
    assign z = OR_out ^ AND_out;

endmodule