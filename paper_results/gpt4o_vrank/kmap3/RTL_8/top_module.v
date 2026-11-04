module top_module (
    input a, 
    input b,
    input c,
    input d,
    output reg out
);

    always @(*) begin
        case ({c, d, a, b})
            4'b0010: out = 0;
            4'b0001: out = 0;
            4'b0111: out = 0;
            4'b1110: out = 0;
            4'b1010: out = 0;
            4'b0000: out = 0;
            4'b1000: out = 0;
            4'b1100: out = 0;
            default: out = 1;
        endcase
    end

endmodule