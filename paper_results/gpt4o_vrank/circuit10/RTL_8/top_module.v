module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    always @(posedge clk) begin
        if (a && b) begin
            q <= !state;
            state <= !state;
        end
        else begin
            q <= state;
            state <= state;
        end
    end

endmodule