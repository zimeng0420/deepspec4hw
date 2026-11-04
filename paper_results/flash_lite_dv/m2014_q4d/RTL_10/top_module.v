module top_module (
    input in,
    input clk,
    output out
);

    reg internal_out;

    always @(posedge clk) begin
        internal_out <= in ^ out;
    end

    assign out = internal_out;
endmodule