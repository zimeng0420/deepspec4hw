module top_module (
    input [3:0] in,
    output reg [1:0] pos
);

    always @(*) begin
        case (1'b1)  // Check for the first '1' from the most significant bit
            in[3]: pos = 2'b11; // if in[3] is high
            in[2]: pos = 2'b10; // if in[2] is high
            in[1]: pos = 2'b01; // if in[1] is high
            in[0]: pos = 2'b00; // if in[0] is high
            default: pos = 2'b00; // if none are high, output 0
        endcase
    end

endmodule