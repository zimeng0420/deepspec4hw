module top_module(
    input clk,
    input reset,
    input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack
);

    typedef enum reg [2:0] {
        IDLE,
        WAIT_PATTERN,
        SHIFT,
        COUNT,
        DONE
    } state_t;

    state_t current_state, next_state;
    reg [3:0] shift_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
            shift_count <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @* begin
        next_state = current_state;
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (current_state)
            IDLE: begin
                if (data == 1) begin
                    next_state = WAIT_PATTERN;
                end
            end
            
            WAIT_PATTERN: begin
                if (data == 1) begin // Assume continuously checking for pattern
                    next_state = SHIFT;
                    shift_ena = 1;
                    shift_count = 4; // Start shifting for 4 counts
                end else if (data == 0) begin
                    next_state = IDLE; // Pattern not matched
                end
            end
            
            SHIFT: begin
                if (shift_count > 0) begin
                    shift_count = shift_count - 1;
                    next_state = SHIFT; // Stay in SHIFT state for 4 cycles
                end else begin
                    counting = 1; // Start counting after shift
                    next_state = COUNT;
                end
            end
            
            COUNT: begin
                if (done_counting) begin
                    done = 1; // Timer done notifying user
                    next_state = DONE;
                end
            end
            
            DONE: begin
                if (ack) begin
                    next_state = IDLE; // Wait for user acknowledgment to reset to IDLE
                end
            end
            
            default: next_state = IDLE;
        endcase
    end
endmodule