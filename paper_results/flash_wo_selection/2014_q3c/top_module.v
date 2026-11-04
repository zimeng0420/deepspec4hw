module top_module (
    input clk,
    input x,
    input [2:0] y,
    output reg Y0,
    output reg z
);

    always @(posedge clk) begin
        z <= y[2] & ~y[1];

        Y0 <= (~y[2] & ~y[1] & ~y[0] & x) |
              (~y[2] & ~y[1] & y[0] & ~x) |
              (~y[2] & y[1] & ~y[0] & x) |
              (~y[2] & y[1] & y[0] & ~x) |
              (y[2] & ~y[1] & ~y[0] & ~x);
    end

endmodule