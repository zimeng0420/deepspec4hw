module top_module(
    input x,
    input y,
    output z
);
    // Module A implementing the boolean function z_A = (x^y) & x
    wire z_A1, z_A2;
    module A (
        input x,
        input y,
        output z
    );
        assign z = (x ^ y) & x;
    endmodule

    // Module B defined by behavioral output based on the specified waveform
    reg z_B1, z_B2;
    module B (
        input x,
        input y,
        output z
    );
        always @(*) begin
            case({x, y})
                2'b00: z = 1;  // z = 1 when x = 0 and y = 0
                2'b01: z = 0;  // z = 0 when x = 0 and y = 1
                2'b10: z = 0;  // z = 0 when x = 1 and y = 0
                2'b11: z = 1;  // z = 1 when x = 1 and y = 1
                default: z = 0; // default case
            endcase
        end
    endmodule

    // Instantiate first A and B modules
    A A1 (.x(x), .y(y), .z(z_A1));
    B B1 (.x(x), .y(y), .z(z_B1));

    // Instantiate second A and B modules
    A A2 (.x(x), .y(y), .z(z_A2));
    B B2 (.x(x), .y(y), .z(z_B2));

    // OR gate for outputs of A1 and B1
    wire z_OR;
    assign z_OR = z_A1 | z_B1;

    // AND gate for outputs of A2 and B2
    wire z_AND;
    assign z_AND = z_A2 & z_B2;

    // Final output z from XOR of z_OR and z_AND
    assign z = z_OR ^ z_AND;

endmodule