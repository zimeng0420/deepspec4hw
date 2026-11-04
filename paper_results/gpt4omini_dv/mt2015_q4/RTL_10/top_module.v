module top_module(
    input x,
    input y,
    output z
);
    wire z_A1, z_A2, z_B1, z_B2;
    wire z_OR, z_AND;

    // Module A implementation
    assign z_A1 = (x ^ y) & x;
    assign z_A2 = (x ^ y) & x;

    // Module B implementation based on simulation waveform
    // A behavioral model to represent Module B
    reg [3:0] state;
    always @(*) begin
        case(state)
            0, 1, 2, 3, 4: z_B1 = 1; // When x=0, y=0
            5, 6: z_B1 = 0;          // When x=1, y=0
            7, 8: z_B1 = 0;          // When x=0, y=1
            9, 10: z_B1 = 1;         // When x=1, y=1
            11, 12: z_B1 = 1;        // When x=0, y=0
            13, 14: z_B1 = 0;        // When x=0, y=1
            15: z_B1 = 1;            // When x=1, y=1
            default: z_B1 = 0;
        endcase
    end

    always @(*) begin
        case(state)
            0, 1, 2, 3, 4: z_B2 = 1; // When x=0, y=0
            5, 6: z_B2 = 0;          // When x=1, y=0
            7, 8: z_B2 = 0;          // When x=0, y=1
            9, 10: z_B2 = 1;         // When x=1, y=1
            11, 12: z_B2 = 1;        // When x=0, y=0
            13, 14: z_B2 = 0;        // When x=0, y=1
            15: z_B2 = 1;            // When x=1, y=1
            default: z_B2 = 0;
        endcase
    end

    // OR and AND gates
    assign z_OR = z_A1 | z_B1;
    assign z_AND = z_A2 & z_B2;

    // Final output
    assign z = z_OR ^ z_AND;
endmodule