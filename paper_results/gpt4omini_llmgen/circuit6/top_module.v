module top_module (
    input [2:0] a, 
    output reg [15:0] q
);

always @(*) begin
    case(a)
        3'b000: q = 16'h1232; // if a = 0
        3'b001: q = 16'hAEE0; // if a = 1
        3'b010: q = 16'h27D4; // if a = 2
        3'b011: q = 16'h5A0E; // if a = 3
        3'b100: q = 16'h2066; // if a = 4
        3'b101: q = 16'h64CE; // if a = 5
        3'b110: q = 16'hC526; // if a = 6
        3'b111: q = 16'h2F19; // if a = 7
        default: q = 16'h0000; // default case (optional)
    endcase
end

endmodule