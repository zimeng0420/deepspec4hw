module top_module (
    input [3:0] in,
    output reg [1:0] pos
);

    always @(*) begin
        case (1'b1) // Check each bit for priority from highest to lowest
            in[3]: pos = 2'b11; // Highest priority
            in[2]: pos = 2'b10;
            in[1]: pos = 2'b01;
            in[0]: pos = 2'b00; // Lowest priority
            default: pos = 2'b00; // No active input
        endcase
    end

endmodule