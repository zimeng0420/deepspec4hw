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
    reg state;

    // State transition logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: state <= (j == 1) ? ON : OFF;
                ON: state <= (k == 1) ? OFF : ON;
                default: state <= OFF; // Default state
            endcase
        end
    end

    // Output logic
    always_comb begin
        case (state)
            OFF: out = 1'b0;
            ON: out = 1'b1;
            default: out = 1'b0; // Default output
        endcase
    end

endmodule