module top_module (
    input [3:0] in,
    output reg [1:0] pos
);
    always @(*) begin
        case (in)
            4'b0000: pos = 2'd0; // none high
            4'b0001: pos = 2'd0; // first bit high (index 0)
            4'b0010: pos = 2'd1; // second bit high (index 1)
            4'b0011: pos = 2'd1; // both first and second high, first high is prioritized
            4'b0100: pos = 2'd2; // third bit high (index 2)
            4'b0101: pos = 2'd2; // first and third high, first high is prioritized
            4'b0110: pos = 2'd2; // second and third high, first high is prioritized
            4'b0111: pos = 2'd2; // first, second and third high, first high is prioritized
            4'b1000: pos = 2'd3; // fourth bit high (index 3)
            4'b1001: pos = 2'd3; // first and fourth high, first high is prioritized
            4'b1010: pos = 2'd3; // second and fourth high, first high is prioritized
            4'b1011: pos = 2'd3; // first, second and fourth high, first high is prioritized
            4'b1100: pos = 2'd3; // third and fourth high, first high is prioritized
            4'b1101: pos = 2'd3; // first, third and fourth high, first high is prioritized
            4'b1110: pos = 2'd3; // second, third and fourth high, first high is prioritized
            4'b1111: pos = 2'd3; // all high, first high is prioritized
            default: pos = 2'd0; // should not reach here
        endcase
    end
endmodule