module top_module (
    input a, 
    input b,
    input c,
    input d,
    output reg out
);
    always @(*) begin
        case ({c, d, a, b})
            4'b00_01: out = 1; // cd=00, ab=01
            4'b00_10: out = 1; // cd=00, ab=10
            4'b00_11: out = 1; // cd=00, ab=11
            4'b01_00: out = 0; // cd=01, ab=00
            4'b01_01: out = 0; // cd=01, ab=01
            4'b01_10: out = 1; // cd=01, ab=10 (don't-care)
            4'b01_11: out = 1; // cd=01, ab=11 (don't-care)
            4'b10_00: out = 0; // cd=10, ab=00
            4'b10_01: out = 1; // cd=10, ab=01
            4'b10_10: out = 1; // cd=10, ab=10
            4'b10_11: out = 1; // cd=10, ab=11
            4'b11_00: out = 0; // cd=11, ab=00
            4'b11_01: out = 1; // cd=11, ab=01
            4'b11_10: out = 1; // cd=11, ab=10
            4'b11_11: out = 1; // cd=11, ab=11
            default: out = 0; // Default case (not required)
        endcase
    end
endmodule