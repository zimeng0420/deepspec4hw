module top_module(
    input in,
    input clk,
    output reg out
);

    reg xor_out;

    always @(posedge clk) begin
        xor_out <= in ^ out;
        out <= xor_out;
    end

endmodule