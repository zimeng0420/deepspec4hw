module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    always @(posedge clk) begin
        if (state == 0) begin
            if (a == 0 && b == 1)
                state <= 1;
            else if (a == 1 && b == 1)
                state <= 0;
        end else begin
            if (a == 0 && b == 0)
                state <= 1;
            else if (a == 1 && b == 1)
                state <= 1;
            else
                state <= 0;
        end

        q <= state;
    end

endmodule