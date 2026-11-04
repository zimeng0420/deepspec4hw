module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);
    always @(posedge clk) begin
        if (state == 0) begin
            if (a && !b) begin
                q <= 1;
                state <= 1;
            end else begin
                q <= 0;
                state <= 0;
            end
        end else begin
            if (a && b) begin
                q <= 0;
                state <= 0;
            end else if (!a && b) begin
                q <= 1;
                state <= 1;
            end
        end
    end
endmodule