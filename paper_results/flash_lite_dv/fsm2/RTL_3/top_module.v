module top_module(
    input clk,
    input j,
    input k,
    input areset,
    output reg out
);

    // Define states
    parameter OFF = 0;
    parameter ON = 1;

    // Define state register
    reg [0:0] state;

    // State transition logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
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
            endcase
        end
    end

    // Output logic
    always_comb begin
        case (state)
            OFF: out = 0;
            ON: out = 1;
        endcase
    end

endmodule