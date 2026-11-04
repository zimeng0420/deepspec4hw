module top_module (
    input clk,
    input x,
    input [2:0] y,
    output reg Y0,
    output reg z
);

// Combinational logic to determine next state Y0 and output z
always @(*) begin
    // Compute Y0 based on current state y and input x
    Y0 = (~y[2] & ~y[1] & x) | (y[2] & ~y[1] & ~y[0]);
    
    // Compute z based on current state y and input x
    z = (y[2] & y[1]) | (y[2] & y[0]) | (y[1] & y[0] & ~x);
end

endmodule