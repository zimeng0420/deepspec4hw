module top_module (
    input [3:0] a, 
    input [3:0] b, 
    input [3:0] c, 
    input [3:0] d,
    input [3:0] e,
    output reg [3:0] q
);
    always @(*) begin
        case (c)
            4'b0000: q = b;   // when c = 0
            4'b0001: q = e;   // when c = 1
            4'b0010: q = a;   // when c = 2
            4'b0011: q = d;   // when c = 3
            4'b0100: q = 4'b1111; // when c = 4 - assuming some value f
            4'b0101: q = 4'b1111; // when c = 5 - assuming some value f
            4'b0110: q = 4'b1111; // when c = 6 - assuming some value f
            4'b0111: q = 4'b1111; // when c = 7 - assuming some value f
            4'b1000: q = 4'b1111; // when c = 8 - assuming some value f
            4'b1001: q = 4'b1111; // when c = 9 - assuming some value f
            4'b1010: q = 4'b1111; // when c = a - assuming some value f
            4'b1011: q = 4'b1111; // when c = b - assuming some value f
            4'b1100: q = 4'b1111; // when c = c - assuming some value f
            4'b1101: q = 4'b1111; // when c = d - assuming some value f
            4'b1110: q = 4'b1111; // when c = e - assuming some value f
            4'b1111: q = 4'b1111; // when c = f - assuming some value f
            default: q = 4'b0000; // default case
        endcase
    end
endmodule