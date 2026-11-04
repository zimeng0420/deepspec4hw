module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (state == 0) begin
        if (a == 1 && b == 1) begin
            q <= 0;
            state <= 1;
        end
        else begin
            q <= q;
            state <= 0;
        end
    end
    else begin
        if (a == 1 && b == 0) begin
            q <= 1;
            state <= 0;
        end
        else if (a == 0 && b == 1) begin
            q <= 0;
            state <= 1;
        end
        else begin
            q <= q;
            state <= state;
        end
    end
end

endmodule