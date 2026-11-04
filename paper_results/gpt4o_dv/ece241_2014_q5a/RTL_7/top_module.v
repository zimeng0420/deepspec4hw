module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        FIRST_ONE = 2'b01,
        INVERT = 2'b10
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic and output logic
    always @(*) begin
        case (state)
            IDLE: begin
                z = x; // Output in this state is same as input
                if (x == 1)
                    next_state = FIRST_ONE;
                else
                    next_state = IDLE;
            end
            FIRST_ONE: begin
                z = x;
                next_state = INVERT; // Move to INVERT state after first '1'
            end
            INVERT: begin
                z = ~x;
                next_state = INVERT; // Stay in INVERT state
            end
            default: begin
                z = x;
                next_state = IDLE;
            end
        endcase
    end

endmodule