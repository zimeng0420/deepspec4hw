module top_module (
    input [3:0] in,
    output reg [1:0] pos
);

    always @(*) begin
        casez (in)
            4'b1???: pos = 2'b11; // when in[3] is high
            4'b01??: pos = 2'b10; // when only in[2] is high
            4'b001?: pos = 2'b01; // when only in[1] is high
            4'b0001: pos = 2'b00; // when only in[0] is high
            default: pos = 2'b00; // when all bits are low
        endcase
    end

endmodule