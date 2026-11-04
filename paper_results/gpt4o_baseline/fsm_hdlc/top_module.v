module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    typedef enum logic [3:0] {
        IDLE       = 4'b0000, // Initial state
        ONE        = 4'b0001, // Detected 1
        TWO_ONES   = 4'b0010, // Detected 11
        THREE_ONES = 4'b0011, // Detected 111
        FOUR_ONES  = 4'b0100, // Detected 1111
        FIVE_ONES  = 4'b0101, // Detected 11111
        SIX_ONES   = 4'b0110, // Detected 111111
        FLAG       = 4'b0111, // Detected 01111110 (flag state)
        DISCARD    = 4'b1000, // Detected 0111110 (discard state)
        ERROR      = 4'b1001  // Detected 7 or more 1s (error state)
    } state_t;

    // Internal state registers
    state_t current_state, next_state;

    // State transition and logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        // Default assignments
        next_state = current_state;
        disc = 0;
        flag = 0;
        err = 0;

        case (current_state)
            IDLE: begin
                if (in) next_state = ONE;
            end
            ONE: begin
                if (in) next_state = TWO_ONES;
                else next_state = IDLE;
            end
            TWO_ONES: begin
                if (in) next_state = THREE_ONES;
                else next_state = IDLE;
            end
            THREE_ONES: begin
                if (in) next_state = FOUR_ONES;
                else next_state = IDLE;
            end
            FOUR_ONES: begin
                if (in) next_state = FIVE_ONES;
                else next_state = IDLE;
            end
            FIVE_ONES: begin
                if (in) next_state = SIX_ONES;
                else begin
                    next_state = DISCARD;
                    disc = 1; // Bit to be discarded
                end
            end
            SIX_ONES: begin
                if (in) begin
                    next_state = ERROR;
                    err = 1; // Detected 7 consecutive 1s
                end else begin
                    next_state = FLAG;
                    flag = 1; // Flag detected
                end
            end
            FLAG: begin
                next_state = IDLE; // Reset to IDLE after flag
            end
            DISCARD: begin
                next_state = IDLE; // Reset to IDLE after discard
            end
            ERROR: begin
                next_state = IDLE; // Reset to IDLE after error
            end
        endcase
    end

endmodule