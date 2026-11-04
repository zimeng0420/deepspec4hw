module top_module(
    input clk,
    input d,
    output reg q
);

    always @(posedge clk) begin
        q <= d; // On the rising edge of clk, update q with the value of d
    end

endmodule