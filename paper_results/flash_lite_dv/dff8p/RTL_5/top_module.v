module top_module(
    input clk,
    input [7:0] d,
    input reset,
    output [7:0] q
);

    reg [7:0] q_internal;

    always @(negedge clk) begin
        if (reset) begin
            q_internal <= 8'h34;
        end else begin
            q_internal <= d;
        end
    end

    assign q = q_internal;

endmodule