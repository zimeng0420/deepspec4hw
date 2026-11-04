module top_module(
    input x,
    input y,
    output z
);

    // Module A: Implements z = (x ^ y) & x
    wire a_out1, a_out2;
    wire b_out1, b_out2;

    // Module A definition
    module A(
        input x,
        input y,
        output z
    );
        assign z = (x ^ y) & x;
    endmodule

    // Module B: output z based on the provided waveform
    module B(
        input x,
        input y,
        output z
    );
        reg z;
        always @(*) begin
            case ({x, y})
                2'b00: z = 1;
                2'b01: z = 0;
                2'b10: z = 0;
                2'b11: z = 1;
                default: z = 0;
            endcase
        end
    endmodule

    // Instantiate A and B modules
    A a1 (.x(x), .y(y), .z(a_out1));
    B b1 (.x(x), .y(y), .z(b_out1));
    
    A a2 (.x(x), .y(y), .z(a_out2));
    B b2 (.x(x), .y(y), .z(b_out2));

    // Connections
    wire or_out, and_out;
    assign or_out = a_out1 | b_out1;
    assign and_out = a_out2 & b_out2;

    // Final output z
    assign z = or_out ^ and_out;

endmodule