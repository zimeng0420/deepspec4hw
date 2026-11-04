module top_module (
    input [7:0] in,
    output reg [2:0] pos
);

    always @(*) begin
        casez (in)
            8'bxxxxxxx1: pos = 3'b000;
            8'bxxxxxx10: pos = 3'b001;
            8'bxxxxx100: pos = 3'b010;
            8'bxxxx1000: pos = 3'b011;
            8'bxxx10000: pos = 3'b100;
            8'bxx100000: pos = 3'b101;
            8'bx1000000: pos = 3'b110;
            8'b10000000: pos = 3'b111;
            default: pos = 3'b000;
        endcase
    end

endmodule