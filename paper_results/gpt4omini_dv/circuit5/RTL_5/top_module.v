module top_module (
    input [3:0] a, 
    input [3:0] b, 
    input [3:0] c, 
    input [3:0] d,
    input [3:0] e,
    output reg [3:0] q
);

always @(*) begin
    case (c)
        4'd0: q = b; // When c = 0
        4'd1: q = e; // When c = 1
        4'd2: q = a; // When c = 2
        4'd3: q = d; // When c = 3
        default: q = 4'hf; // When c >= 4
    endcase
end

endmodule