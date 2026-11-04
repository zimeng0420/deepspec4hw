module top_module(
    input x,
    input y,
    output z
);

    wire z_A1, z_A2, z_B1, z_B2;
    wire z_OR, z_AND;

    // Module A
    module A(
        input x,
        input y,
        output z
    );
        assign z = (x ^ y) & x;
    endmodule

    // Module B
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

    // Instantiate Module A 
    A a1 (.x(x), .y(y), .z(z_A1));
    A a2 (.x(x), .y(y), .z(z_A2));

    // Instantiate Module B 
    B b1 (.x(x), .y(y), .z(z_B1));
    B b2 (.x(x), .y(y), .z(z_B2));

    // OR gate for the first pair
    assign z_OR = z_A1 | z_B1;

    // AND gate for the second pair
    assign z_AND = z_A2 & z_B2;

    // Final output
    assign z = z_OR ^ z_AND;

endmodule