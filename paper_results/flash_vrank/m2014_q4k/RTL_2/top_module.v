module top_module (
    input clk,
    input resetn,
    input in,
    output out
);

    reg d1, d2, d3, d4;

    always @(posedge clk) begin
        if (!resetn) begin
            d1 <= 0;
            d2 <= 0;
            d3 <= 0;
            d4 <= 0;
        end else begin
            d1 <= in;
            d2 <= d1;
            d3 <= d2;
            d4 <= d3;
        end
    end

    assign out = d4;

endmodule