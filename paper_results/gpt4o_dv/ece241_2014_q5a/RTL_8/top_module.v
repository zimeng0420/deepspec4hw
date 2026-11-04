module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State definitions
    typedef enum logic [1:0] {
        WAIT_ZERO = 2'b00,
        DETECT_ONE = 2'b01,
        INVERT = 2'b10
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            WAIT_ZERO: begin
                if (x) 
                    next_state = DETECT_ONE;
                else 
                    next_state = WAIT_ZERO;
            end
            DETECT_ONE: begin
                next_state = INVERT;
            end
            INVERT: begin
                next_state = INVERT;
            end
            default: 
                next_state = WAIT_ZERO;
        endcase
    end

    // Output logic and state updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WAIT_ZERO;
            z <= 0;
        end else begin
            state <= next_state;
            case (state)
                WAIT_ZERO, DETECT_ONE: z <= x;
                INVERT: z <= ~x;
            endcase
        end
    end

endmodule