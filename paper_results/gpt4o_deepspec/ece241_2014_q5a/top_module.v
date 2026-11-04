module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,    // Waiting for the first `1` bit
        DETECT = 2'b01   // First `1` detected, start inverting
    } state_t;

    state_t current_state, next_state;

    // State transition logic (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case (current_state)
            IDLE: 
                if (x == 1)
                    next_state = DETECT;
                else
                    next_state = IDLE;
            DETECT: 
                next_state = DETECT; // Remain in DETECT state once entered
            default: 
                next_state = IDLE; // Default to reset state
        endcase
    end

    // Output logic (combinational)
    always @(*) begin
        case (current_state)
            IDLE: z = x;       // In IDLE state, output matches input
            DETECT: z = ~x;    // In DETECT state, output is inverted
            default: z = 0;    // Default output (for safety)
        endcase
    end

endmodule