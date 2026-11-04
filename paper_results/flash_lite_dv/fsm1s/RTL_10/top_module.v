module top_module(
    input clk,
    input in,
    input reset,
    output reg out
);

    // State encoding
    parameter A = 0;
    parameter B = 1;

    // State register
    reg state;
    reg next_state;

    // State transition logic
    always @(*) begin
        next_state = state; // Default: stay in the same state

        case (state)
            A: begin
                if (in)
                    next_state = A;
                else
                    next_state = B;
            end
            B: begin
                if (in)
                    next_state = B;
                else
                    next_state = A;
            end
        endcase

        if (reset)
            next_state = B; // Synchronous reset
    end

    // State register update
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output logic
    always @(*) begin
        case (state)
            A: out = 0;
            B: out = 1;
            default: out = 0; // Should not happen, but good practice
        endcase
    end

endmodule