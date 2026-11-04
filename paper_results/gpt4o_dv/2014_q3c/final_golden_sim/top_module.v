module top_module (
    input clk,
    input x,
    input [2:0] y,
    output reg Y0,
    output reg z
);

    // Combinational logic for Y0
    always @(*) begin
        Y0 = (~y[2] & ~y[1] & x) | (y[2] & ~y[1] & ~y[0]);
    end

    // Combinational logic for z
    always @(*) begin
        z = (y[2] & y[1]) | (y[2] & y[0]) | (y[1] & y[0] & ~x);
    end

endmodule