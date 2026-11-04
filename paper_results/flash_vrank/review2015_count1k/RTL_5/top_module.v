module top_module(
    input clk,
    input reset,
    output reg [9:0] q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'b0000000000;
        end else begin
            if (q == 10'b1111100111) begin //999 in binary
                q <= 10'b0000000000;
            end else begin
                q <= q + 1'b1;
            end
        end
    end

endmodule