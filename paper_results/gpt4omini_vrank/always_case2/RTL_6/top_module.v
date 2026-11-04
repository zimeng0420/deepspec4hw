module top_module (
    input [3:0] in,
    output reg [1:0] pos
);
    always @* begin
        case (in)
            4'b0001: pos = 2'd0;
            4'b0010: pos = 2'd1;
            4'b0011: pos = 2'd1; // if both 0 and 1 are high, return 1
            4'b0100: pos = 2'd2;
            4'b0101: pos = 2'd2; // if both 0 and 2 are high, return 2
            4'b0110: pos = 2'd2; // if both 1 and 2 are high, return 2
            4'b0111: pos = 2'd2; // if 0, 1, and 2 are high, return 2
            4'b1000: pos = 2'd3;
            4'b1001: pos = 2'd3; // if both 0 and 3 are high, return 3
            4'b1010: pos = 2'd3; // if both 1 and 3 are high, return 3
            4'b1100: pos = 2'd3; // if both 2 and 3 are high, return 3
            4'b1011: pos = 2'd3; // if 0, 1 and 3 are high, return 3
            4'b1110: pos = 2'd3; // if 1, 2 and 3 are high, return 3
            4'b1111: pos = 2'd3; // if 0, 1, 2 and 3 are high, return 3
            default: pos = 2'd0;
        endcase
    end
endmodule