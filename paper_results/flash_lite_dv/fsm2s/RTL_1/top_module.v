module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output out
);

    parameter OFF = 0;
    parameter ON  = 1;

    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            case (state)
                OFF:
                    if (j)
                        state <= ON;
                    else
                        state <= OFF;
                ON:
                    if (k)
                        state <= OFF;
                    else
                        state <= ON;
                default:
                    state <= OFF;
            endcase
    end

    assign out = state;

endmodule