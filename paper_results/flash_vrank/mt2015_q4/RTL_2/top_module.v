module top_module(
    input x,
    input y,
    output z
);

    wire a_out1, a_out2, b_out1, b_out2, or_out, and_out;

    // Module A: z = (x^y) & x
    module a_module (input x, input y, output z);
        assign z = (x ^ y) & x;
    endmodule

    // Module B: Waveform-defined behavior
    module b_module (input x, input y, output z);
        reg z_reg;
        
        always @(x or y) begin
            case ({x, y})
                2'b00: z_reg = 1;
                2'b01: z_reg = 0;
                2'b10: z_reg = 0;
                2'b11: z_reg = 1;
                default: z_reg = 0; //default case
            endcase
        end
        
        assign z = z_reg;
    endmodule

    // Instantiate modules
    a_module a1 (x, y, a_out1);
    a_module a2 (x, y, a_out2);
    b_module b1 (x, y, b_out1);
    b_module b2 (x, y, b_out2);

    // OR and AND gates
    assign or_out = a_out1 | b_out1;
    assign and_out = a_out2 & b_out2;

    // XOR gate
    assign z = or_out ^ and_out;

endmodule