module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);

    reg state;
    parameter OFF = 0, ON = 1;

    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: begin
                    if (j) state <= ON;
                end
                ON: begin
                    if (k) state <= OFF;
                end
            endcase
        end
    end

    always @(state) begin
        out = (state == ON) ? 1 : 0;
    end

endmodule