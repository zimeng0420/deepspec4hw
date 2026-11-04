module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    always @(posedge clk) begin
        if (state == 0) begin
            if (a == 0 && b == 1) begin
                state <= 1;
            end
        end else begin
            if (a == 1 && b == 1) begin
                state <= 0;
            end
        end
        q <= state;
    end

endmodule