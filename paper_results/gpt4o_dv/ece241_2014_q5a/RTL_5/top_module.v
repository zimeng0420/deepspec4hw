module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BEFORE_FIRST_ONE = 2'b01,
        AFTER_FIRST_ONE = 2'b10
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (!areset)
                    next_state = BEFORE_FIRST_ONE;
                else
                    next_state = IDLE;
            end
            BEFORE_FIRST_ONE: begin
                if (x)
                    next_state = AFTER_FIRST_ONE;
                else
                    next_state = BEFORE_FIRST_ONE;
            end
            AFTER_FIRST_ONE: begin
                next_state = AFTER_FIRST_ONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register update
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Output logic
    always @(*) begin
        case (current_state)
            IDLE: z = 1'b0;
            BEFORE_FIRST_ONE: z = x;
            AFTER_FIRST_ONE: z = ~x;
            default: z = 1'b0;
        endcase
    end

endmodule