module top_module (
    input clk,
    input a,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a) begin
            q <= q; // Hold the current value
        end else begin
            q <= q + 1'b1; // Increment
        end
    end

endmodule