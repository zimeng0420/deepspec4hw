module top_module(
    input clk,
    input reset,
    input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack );

    // State encoding
    typedef enum reg [2:0] {
        IDLE,       // Searching for pattern
        DETECTED,   // Pattern detected, shifting
        COUNTING,   // Counting phase
        NOTIFY      // Notify user
    } state_t;

    state_t current_state, next_state;
    reg [3:0] shift_counter;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
            shift_counter <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (current_state)
            IDLE: begin
                // Check for the pattern 1101
                if (data) begin
                    // Assuming shift-in mechanism to check pattern (to be implemented)
                    // Pattern checking logic should be here
                    // If detected:
                    next_state = DETECTED;
                end
            end
            
            DETECTED: begin
                shift_ena = 1;
                shift_counter = shift_counter + 1;
                if (shift_counter == 4) begin
                    next_state = COUNTING;
                    counting = 1;
                    shift_counter = 0;
                end
            end
            
            COUNTING: begin
                if (done_counting) begin
                    next_state = NOTIFY;
                    done = 1;
                end
            end
            
            NOTIFY: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end
endmodule