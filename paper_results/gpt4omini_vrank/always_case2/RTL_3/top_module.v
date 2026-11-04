module top_module (
    input [3:0] in,
    output reg [1:0] pos
);
    always @(*) begin
        case (in)
            4'b0000: pos = 2'b00;  // no input high
            4'b0001: pos = 2'b00;  // first bit high
            4'b0010: pos = 2'b01;  // second bit high
            4'b0011: pos = 2'b01;  // first or second bit high
            4'b0100: pos = 2'b10;  // third bit high
            4'b0101: pos = 2'b10;  // first or third bit high
            4'b0110: pos = 2'b10;  // second or third bit high
            4'b0111: pos = 2'b10;  // first, second or third bit high
            4'b1000: pos = 2'b11;  // fourth bit high
            4'b1001: pos = 2'b11;  // first or fourth bit high
            4'b1010: pos = 2'b11;  // second or fourth bit high
            4'b1011: pos = 2'b11;  // first, second or fourth bit high
            4'b1100: pos = 2'b11;  // third or fourth bit high
            4'b1101: pos = 2'b11;  // first, third or fourth bit high
            4'b1110: pos = 2'b11;  // second, third or fourth bit high
            4'b1111: pos = 2'b11;  // all bits high
            default: pos = 2'b00;   // should not happen
        endcase
    end
endmodule