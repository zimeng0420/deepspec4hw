module top_module (
    input [3:0] in,
    output reg [1:0] pos
);
    always @* begin
        case (in)
            4'b0000: pos = 2'b00; // All inputs low
            4'b0001: pos = 2'b00; // in[0] is high
            4'b0010: pos = 2'b01; // in[1] is high
            4'b0011: pos = 2'b01; // in[1] is high (priority over in[0])
            4'b0100: pos = 2'b10; // in[2] is high
            4'b0101: pos = 2'b10; // in[2] is high (priority over in[0])
            4'b0110: pos = 2'b10; // in[2] is high (priority over in[1])
            4'b0111: pos = 2'b10; // in[2] is high (priority over in[1] and in[0])
            4'b1000: pos = 2'b11; // in[3] is high
            4'b1001: pos = 2'b11; // in[3] is high (priority over in[0])
            4'b1010: pos = 2'b11; // in[3] is high (priority over in[1])
            4'b1011: pos = 2'b11; // in[3] is high (priority over in[1] and in[0])
            4'b1100: pos = 2'b11; // in[3] is high (priority over in[2])
            4'b1101: pos = 2'b11; // in[3] is high (priority over in[2] and in[0])
            4'b1110: pos = 2'b11; // in[3] is high (priority over in[2] and in[1])
            4'b1111: pos = 2'b11; // in[3] is high (priority over in[2], in[1], and in[0])
            default: pos = 2'b00; // Default case (just in case)
        endcase
    end
endmodule