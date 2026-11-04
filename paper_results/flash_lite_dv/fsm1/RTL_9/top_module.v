module top_module(
    input clk,
    input in,
    input areset,
    output out
);

    // Define states using parameters for readability and maintainability
    parameter STATE_A = 0;
    parameter STATE_B = 1;

    // State register
    reg state;

    // Combinational logic for state transitions
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_B; // Asynchronous reset to state B
        end else begin
            case (state)
                STATE_A: begin
                    if (in)
                        state <= STATE_A; // input 1: stay in A
                    else
                        state <= STATE_B; // input 0: go to B
                end
                STATE_B: begin
                    if (in)
                        state <= STATE_B; // input 1: stay in B
                    else
                        state <= STATE_A; // input 0: go to A
                end
            endcase
        end
    end

    // Combinational logic for output
    always @(*) begin
        case (state)
            STATE_A: out = 0;
            STATE_B: out = 1;
            default: out = 0; // Default case, should not occur.  Important for synthesis.
        endcase
    end

endmodule