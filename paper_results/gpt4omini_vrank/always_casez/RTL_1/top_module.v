module top_module (
    input [7:0] in,
    output reg [2:0] pos
);
    always @(*) begin
        pos = 3'd0; // Default output to 0
        casez(in)
            8'b1???????: pos = 3'd0; // Bit 0
            8'b01??????: pos = 3'd1; // Bit 1
            8'b001?????: pos = 3'd2; // Bit 2
            8'b0001????: pos = 3'd3; // Bit 3
            8'b00001???: pos = 3'd4; // Bit 4
            8'b000001??: pos = 3'd5; // Bit 5
            8'b0000001?: pos = 3'd6; // Bit 6
            8'b00000001: pos = 3'd7; // Bit 7
            default: pos = 3'd0; // If all are 0, output remains 0
        endcase
    end
endmodule