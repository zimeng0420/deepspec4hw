module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        S_WAIT_FOR_ONE = 2'b00,  // Waiting to detect first '1'
        S_AFTER_ONE    = 2'b01   // Processing after the first '1' is detected
    } state_t;
    
    // State register
    reg state, next_state;

    // State transition
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S_WAIT_FOR_ONE;  // Reset to initial state
        else
            state <= next_state;      // Update state
    end

    // Next state logic
    always @(*) begin
        case (state)
            S_WAIT_FOR_ONE: 
                if (x == 1)
                    next_state = S_AFTER_ONE;   // Transition to after first '1' state
                else
                    next_state = S_WAIT_FOR_ONE; // Stay in this state
            
            S_AFTER_ONE:
                next_state = S_AFTER_ONE;        // Stay in this state

            default: 
                next_state = S_WAIT_FOR_ONE;
        endcase
    end

    // Output logic based on current state
    always @(*) begin
        case (state)
            S_WAIT_FOR_ONE: 
                z = x;             // Output is same as input
            
            S_AFTER_ONE:
                z = ~x;            // Output is inverted input

            default: 
                z = x;
        endcase
    end
endmodule