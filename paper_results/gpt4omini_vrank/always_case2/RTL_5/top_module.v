module top_module (
    input [3:0] in,
    output reg [1:0] pos
);

    always @* begin
        casez (in)
            4'b1??? : pos = 2'b00; // Position 0
            4'b01?? : pos = 2'b01; // Position 1
            4'b001? : pos = 2'b10; // Position 2
            4'b0001 : pos = 2'b11; // Position 3
            default : pos = 2'b00;  // Default to 0 when none high
        endcase
    end

endmodule