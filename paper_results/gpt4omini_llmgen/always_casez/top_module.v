module top_module (
    input [7:0] in,
    output reg [2:0] pos
);

    always @(*) begin
        casez(in)
            8'b1??????? : pos = 3'd7; // Bit 7 is the first high bit
            8'b01?????? : pos = 3'd6; // Bit 6 is the first high bit
            8'b001????? : pos = 3'd5; // Bit 5 is the first high bit
            8'b0001???? : pos = 3'd4; // Bit 4 is the first high bit
            8'b00001??? : pos = 3'd3; // Bit 3 is the first high bit
            8'b000001?? : pos = 3'd2; // Bit 2 is the first high bit
            8'b0000001? : pos = 3'd1; // Bit 1 is the first high bit
            8'b00000001 : pos = 3'd0; // Bit 0 is the first high bit
            default:      pos = 3'd0;  // No bits high, report zero
        endcase
    end

endmodule