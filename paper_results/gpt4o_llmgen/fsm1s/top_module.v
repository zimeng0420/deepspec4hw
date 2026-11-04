module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    // Define state enumeration
    typedef enum logic [1:0] {
        STATE_A = 2'd0,
        STATE_B = 2'd1
    } state_t;

    state_t current_state, next_state;

    // State transition logic (sequential logic)
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_B; // Reset state is B
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic (combinational logic)
    always_comb begin
        case (current_state)
            STATE_B: begin
                if (in == 1'b0) begin
                    next_state = STATE_A;
                end else begin
                    next_state = STATE_B;
                end
                out = 1'b1; // Output for state B
            end
            STATE_A: begin
                if (in == 1'b0) begin
                    next_state = STATE_B;
                end else begin
                    next_state = STATE_A;
                end
                out = 1'b0; // Output for state A
            end
            default: begin
                next_state = STATE_B; // Default to reset state
                out = 1'b1; // Default output (state B)
            end
        endcase
    end

endmodule