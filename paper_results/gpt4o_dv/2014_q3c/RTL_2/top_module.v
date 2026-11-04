module top_module (
    input clk,
    input x,
    input [2:0] y,
    output reg Y0,
    output reg z
);

    always @(*) begin
        // Combinational logic for next state Y0
        Y0 = (~y[2] & ~y[1] & x) | (y[2] & ~y[1] & ~y[0]);

        // Combinational logic for output z
        z = (y[2] & y[1]) | (y[2] & y[0]) | (y[1] & y[0] & ~x);
    end

endmodule