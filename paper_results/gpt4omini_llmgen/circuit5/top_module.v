module top_module (
    input [3:0] a, 
    input [3:0] b, 
    input [3:0] c, 
    input [3:0] d,
    input [3:0] e,
    output reg [3:0] q
);

always @(*) begin
    if (c < 4'd10) 
        q = d;  // assign d to q if c is less than 10
    else 
        q = 4'b1111;  // assign f (which is 15) to q if c is 10 or more
end

endmodule