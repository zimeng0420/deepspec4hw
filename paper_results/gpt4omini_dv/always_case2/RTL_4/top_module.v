module top_module (
    input [3:0] in,
    output reg [1:0] pos
);

    always @(*) begin
        case (1'b1)
            in[3]: pos = 2'b11; // Priority 3
            in[2]: pos = 2'b10; // Priority 2
            in[1]: pos = 2'b01; // Priority 1
            in[0]: pos = 2'b00; // Priority 0
            default: pos = 2'b00; // No input is high
        endcase
    end

endmodule