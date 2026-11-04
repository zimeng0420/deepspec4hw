module top_module(
    input x,
    input y,
    output z
);
    
    wire z_A1, z_A2, z_B1, z_B2;
    wire z_OR, z_AND;

    // Module A implementation
    module A(
        input x,
        input y,
        output z
    );
    assign z = (x ^ y) & x;
    endmodule

    // Module B implementation based on the provided waveform
    module B(
        input x,
        input y,
        output z
    );
    reg z;
    always @(x or y) begin
        case ({x, y})
            2'b00: z = 1;
            2'b01: z = 0;
            2'b10: z = 0;
            2'b11: z = 1;
            default: z = 0;
        endcase
    end
    endmodule

    // Instances of Module A and B
    A A1 (.x(x), .y(y), .z(z_A1));
    B B1 (.x(x), .y(y), .z(z_B1));
    
    A A2 (.x(x), .y(y), .z(z_A2));
    B B2 (.x(x), .y(y), .z(z_B2));

    // Output logic
    assign z_OR = z_A1 | z_B1;
    assign z_AND = z_A2 & z_B2;
    assign z = z_OR ^ z_AND;

endmodule