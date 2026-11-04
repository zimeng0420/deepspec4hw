module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State declaration
    typedef enum logic [1:0] {
        IDLE,       // Initial state before the first '1'
        FIRST_ONE   // After detecting the first '1'
    } state_t;

    state_t state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state; // Default to stay in current state
        case (state)
            IDLE: begin
                // Remain in IDLE until first '1' is encountered in x
                if (x == 1'b1)
                    next_state = FIRST_ONE;
            end
            FIRST_ONE: begin
                // Stay in FIRST_ONE after the first '1' is found
                next_state = FIRST_ONE;
            end
        endcase
    end

    always @(*) begin
        case (state)
            IDLE: z = x;
            FIRST_ONE: z = ~x;
        endcase
    end

endmodule