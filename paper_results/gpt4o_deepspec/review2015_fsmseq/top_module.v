module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding
    typedef enum logic [2:0] {
        S_IDLE  = 3'b000,
        S_1     = 3'b001,
        S_11    = 3'b010,
        S_110   = 3'b011,
        S_1101  = 3'b100
    } state_t;
    
    state_t current_state, next_state;
    
    // State transition logic (combinational)
    always @(*) begin
        case (current_state)
            S_IDLE: next_state = (data ? S_1 : S_IDLE);
            S_1:    next_state = (data ? S_11 : S_IDLE);
            S_11:   next_state = (data ? S_11 : S_110);
            S_110:  next_state = (data ? S_1101 : S_IDLE);
            S_1101: next_state = S_1101; // Remains in this state once reached
            default: next_state = S_IDLE; // Default state
        endcase
    end
    
    // State register (sequential)
    always @(posedge clk) begin
        if (reset)
            current_state <= S_IDLE; // Reset to initial state
        else
            current_state <= next_state; // Transition to next state
    end
    
    // Output logic (Moore FSM, depends only on state)
    always @(posedge clk) begin
        if (reset)
            start_shifting <= 0; // Reset output
        else if (current_state == S_1101)
            start_shifting <= 1; // Stay high after detecting 1101
    end

endmodule