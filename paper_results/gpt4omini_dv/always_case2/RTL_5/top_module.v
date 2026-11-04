module top_module (
    input [3:0] in,
    output reg [1:0] pos
);

    always @* begin
        case (in)
            4'b0000: pos = 2'b00; // No inputs active
            4'b0001: pos = 2'b00; // in[0] active
            4'b0010: pos = 2'b01; // in[1] active
            4'b0100: pos = 2'b10; // in[2] active
            4'b1000: pos = 2'b11; // in[3] active
            4'b0011: pos = 2'b01; // in[1] or in[0] active
            4'b0110: pos = 2'b10; // in[2] or in[1] active
            4'b1100: pos = 2'b11; // in[3] or in[2] active
            4'b0111: pos = 2'b10; // in[2] active
            4'b1110: pos = 2'b11; // in[3] active
            4'b1111: pos = 2'b11; // in[3] active
            default: pos = 2'b00; // Default case
        endcase
    end

endmodule