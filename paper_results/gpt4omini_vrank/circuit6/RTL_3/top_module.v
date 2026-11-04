module top_module (
    input [2:0] a, 
    output reg [15:0] q
);
    always @(*) begin
        case (a)
            3'b000: q = 16'h1232; // When a = 0
            3'b001: q = 16'hAEE0; // When a = 1
            3'b010: q = 16'h27D4; // When a = 2
            3'b011: q = 16'h5A0E; // When a = 3
            3'b100: q = 16'h2066; // When a = 4
            3'b101: q = 16'h64CE; // When a = 5
            3'b110: q = 16'hC526; // When a = 6
            3'b111: q = 16'h2F19; // When a = 7
            default: q = 16'h0000; // Default case
        endcase
    end
endmodule