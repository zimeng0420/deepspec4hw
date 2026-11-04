module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Define state codes
    typedef enum logic [3:0] {
        IDLE,
        ONE,
        TWO_ONES,
        THREE_ONES,
        FOUR_ONES,
        FIVE_ONES,
        SIX_ONES,
        SEVEN_ONES,
        FLAG_DETECTED,
        DISC_DETECTED
    } state_t;

    state_t state, next_state;

    // Synchronous reset and state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and output logic
    always @(*) begin
        // Default output values
        disc = 1'b0;
        flag = 1'b0;
        err = 1'b0;

        case (state)
            IDLE: begin
                if (in)
                    next_state = ONE;
                else
                    next_state = IDLE;
            end
            ONE: begin
                if (in)
                    next_state = TWO_ONES;
                else
                    next_state = IDLE;
            end
            TWO_ONES: begin
                if (in)
                    next_state = THREE_ONES;
                else
                    next_state = IDLE;
            end
            THREE_ONES: begin
                if (in)
                    next_state = FOUR_ONES;
                else
                    next_state = IDLE;
            end
            FOUR_ONES: begin
                if (in)
                    next_state = FIVE_ONES;
                else
                    next_state = IDLE;
            end
            FIVE_ONES: begin
                if (in)
                    next_state = SIX_ONES;
                else begin
                    next_state = DISC_DETECTED;
                end
            end
            SIX_ONES: begin
                if (in)
                    next_state = SEVEN_ONES;
                else begin
                    next_state = FLAG_DETECTED;
                end
            end
            SEVEN_ONES: begin
                err = 1'b1;
                if (~in)
                    next_state = IDLE;
                else
                    next_state = SEVEN_ONES;
            end
            FLAG_DETECTED: begin
                flag = 1'b1;
                next_state = IDLE;
            end
            DISC_DETECTED: begin
                disc = 1'b1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule