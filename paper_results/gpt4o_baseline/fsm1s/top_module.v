module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    // State declaration
    typedef enum logic [0:0] {
        STATE_B = 1'b0, // State B
        STATE_A = 1'b1  // State A
    } state_t;
    
    state_t current_state, next_state;

    // State update on the rising edge of the clock, with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_B;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            STATE_B: next_state = (in == 1'b0) ? STATE_A : STATE_B;
            STATE_A: next_state = (in == 1'b0) ? STATE_B : STATE_A;
            default: next_state = STATE_B; // Default state for safety
        endcase
    end

    // Output logic (Moore state machine: out depends only on current state)
    always @(*) begin
        case (current_state)
            STATE_B: out = 1'b1;
            STATE_A: out = 1'b0;
            default: out = 1'b1; // Default output for safety
        endcase
    end

endmodule