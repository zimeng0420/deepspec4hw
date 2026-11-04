module top_module(
    input x,
    input y,
    output z
);

    // Module A
    wire z_A1, z_A2;
    wire z_B1, z_B2;
    
    assign z_A1 = (x ^ y) & x; // Output of A1
    assign z_A2 = (x ^ y) & x; // Output of A2 (same logic, duplicate as A1)

    // Module B behavior based on simulation waveform
    reg z_B1_reg, z_B2_reg;

    always @(x or y) begin
        case ({x, y})
            2'b00: z_B1_reg = 1;
            2'b01: z_B1_reg = 0;
            2'b10: z_B1_reg = 0;
            2'b11: z_B1_reg = 1;
            default: z_B1_reg = 1; // Default for simulation conditions
        endcase
    end

    always @(x or y) begin
        case ({x, y})
            2'b00: z_B2_reg = 1;
            2'b01: z_B2_reg = 0;
            2'b10: z_B2_reg = 1;
            2'b11: z_B2_reg = 1;
            default: z_B2_reg = 0; // Default for simulation conditions
        endcase
    end
    
    assign z_B1 = z_B1_reg;
    assign z_B2 = z_B2_reg;

    // Combine A and B outputs
    wire z_OR, z_AND;
    assign z_OR = z_A1 | z_B1;
    assign z_AND = z_A2 & z_B2;

    // Final output
    assign z = z_OR ^ z_AND;

endmodule