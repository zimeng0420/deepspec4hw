module top_module (
    input [3:0] in,
    output reg [1:0] pos
);
    always @(*) begin
        case (in)
            4'b0001: pos = 2'd0; // bit 0
            4'b0010: pos = 2'd1; // bit 1
            4'b0100: pos = 2'd2; // bit 2
            4'b1000: pos = 2'd3; // bit 3
            4'b0011: pos = 2'd1; // bit 1
            4'b0110: pos = 2'd2; // bit 2
            4'b1100: pos = 2'd3; // bit 3
            4'b0000: pos = 2'd0; // none high, output is zero
            default: pos = 2'd0; // default case, should not occur
        endcase
    end
endmodule