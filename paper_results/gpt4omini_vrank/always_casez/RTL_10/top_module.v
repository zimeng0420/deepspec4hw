module top_module (
    input [7:0] in,
    output reg [2:0] pos
);

    always @(*) begin
        pos = 3'b000; // Default output
        casez (in)
            8'b0000000?: pos = 3'd0; // First bit high
            8'b0000001?: pos = 3'd1; // Second bit high
            8'b000001??: pos = 3'd2; // Third bit high
            8'b00001???: pos = 3'd3; // Fourth bit high
            8'b0001????: pos = 3'd4; // Fifth bit high
            8'b001?????: pos = 3'd5; // Sixth bit high
            8'b01??????: pos = 3'd6; // Seventh bit high
            8'b1??????? : pos = 3'd7; // Eighth bit high
        endcase
    end

endmodule