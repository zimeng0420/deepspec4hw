module top_module (
    input clk,
    input [7:0] d,
    input reset,
    output [7:0] q
);

    reg [7:0] q_internal;

    always @(posedge clk) begin
        if (reset) begin
            q_internal <= 8'h34;
        end else begin
            q_internal <= d;
        end
    end

    always @(negedge clk) begin
        q <= q_internal;
    end

endmodule