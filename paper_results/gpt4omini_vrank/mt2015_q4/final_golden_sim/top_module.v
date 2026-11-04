module top_module(
    input x,
    input y,
    output z
);

    // Module A: z = (x^y) & x
    wire a1_out, a2_out;
    wire b1_out, b2_out;

    assign a1_out = (x ^ y) & x;
    assign a2_out = (x ^ y) & x;  // Module A instance 2

    // Module B waveform behavior implementation
    reg b1_out_reg, b2_out_reg;

    always @(*) begin
        case ({x, y})
            2'b00: b1_out_reg = 1; // t = [0ns, 20ns]
            2'b01: b1_out_reg = 0; // t = [60ns, 65ns]
            2'b10: b1_out_reg = 0; // t = [25ns, 30ns]
            2'b11: b1_out_reg = 1; // t = [45ns, 50ns], [70ns, 70ns]
            default: b1_out_reg = 1; // Default case for undefined states, remains 1 from 0ns - 20ns
        endcase
    end

    always @(*) begin
        case ({x, y})
            2'b00: b2_out_reg = 1; // t = [0ns, 20ns]
            2'b01: b2_out_reg = 0; // t = [60ns, 65ns]
            2'b10: b2_out_reg = 0; // t = [25ns, 30ns]
            2'b11: b2_out_reg = 1; // t = [45ns, 50ns], [70ns, 70ns]
            default: b2_out_reg = 1; // Default case for undefined states, remains 1 from 0ns - 20ns
        endcase
    end

    assign b1_out = b1_out_reg;
    assign b2_out = b2_out_reg;

    // OR and AND operations
    wire or_out, and_out;

    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;

    // Final output
    assign z = or_out ^ and_out;

endmodule