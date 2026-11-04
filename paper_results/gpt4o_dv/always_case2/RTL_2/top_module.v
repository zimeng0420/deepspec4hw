module top_module (
    input [3:0] in,
    output reg [1:0] pos
);
    always @(*) begin
        case (1'b1)                  // Synthesis trick to handle priority encoding
            in[3]: pos = 2'd3;       // Highest priority
            in[2]: pos = 2'd2;
            in[1]: pos = 2'd1;
            in[0]: pos = 2'd0;       // Lowest priority
            default: pos = 2'd0;     // If no bits are high, output zero
        endcase
    end
endmodule