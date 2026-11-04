module top_module (
    input [3:0] in,
    output reg [1:0] pos
);

    always @(*) begin
        case (in)
            4'b0000: pos = 2'b00;  // No inputs high
            4'b0001: pos = 2'b00;  // in[0] high
            4'b0010: pos = 2'b01;  // in[1] high
            4'b0100: pos = 2'b10;  // in[2] high
            4'b1000: pos = 2'b11;  // in[3] high
            4'b0011: pos = 2'b01;  // in[1] or in[0] high, first 1 is at in[1]
            4'b0110: pos = 2'b10;  // in[2] or in[1] high, first 1 is at in[2]
            4'b1100: pos = 2'b11;  // in[3] or in[2] high, first 1 is at in[3]
            4'b0111: pos = 2'b10;  // in[2], in[1], or in[0] high, first 1 is at in[2]
            4'b1110: pos = 2'b11;  // in[3] or (in[2], in[1], in[0]) high, first 1 is at in[3]
            4'b1111: pos = 2'b11;  // all high, first 1 is at in[3]
            default: pos = 2'b00;  // default case
        endcase
    end

endmodule