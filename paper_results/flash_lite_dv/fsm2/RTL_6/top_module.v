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

    // State register
    reg state;

    // Next state logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: state <= (j == 1) ? ON : OFF;
                ON:  state <= (k == 1) ? OFF : ON;
            endcase
        end
    end

    // Output logic
    always_comb begin
        case (state)
            OFF: out = 0;
            ON:  out = 1;
        endcase
    end

endmodule