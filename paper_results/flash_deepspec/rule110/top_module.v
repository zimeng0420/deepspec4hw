module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q);

    wire [511:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            wire left;
            wire right;

            assign left = (i == 0) ? 0 : q[i - 1];
            assign right = (i == 511) ? 0 : q[i + 1];

            assign next_q[i] = (left & q[i] & ~right) | (left & ~q[i] & right) | (~left & q[i] & right) | (~left & ~q[i] & right);
        end
    endgenerate

endmodule