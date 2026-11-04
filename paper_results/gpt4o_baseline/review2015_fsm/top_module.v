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

    // State declarations
    typedef enum logic [2:0] {
        IDLE,        // Waiting for 1101 pattern
        PATTERN_1,   // Detected 1
        PATTERN_2,   // Detected 11
        PATTERN_3,   // Detected 110
        PATTERN_4,   // Detected 1101
        SHIFT,       // Enable shifting for 4 cycles
        WAIT_COUNT,  // Wait for counting to complete
        DONE         // Notify user of timeout
    } state_t;
    
    state_t state, next_state;

    // Counter for the SHIFT state
    reg [2:0] shift_counter;

    // State and output logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
            shift_counter <= 0;
        end else begin
            state <= next_state;

            // Shift enable output
            if (state == SHIFT) begin
                if (shift_counter < 4) begin
                    shift_counter <= shift_counter + 1;
                    shift_ena <= 1;
                end else begin
                    shift_ena <= 0;
                end
            end else begin
                shift_ena <= 0;
                shift_counter <= 0;
            end

            // Counting output
            counting <= (state == WAIT_COUNT);

            // Done output
            done <= (state == DONE);
        end
    end

    // Next state logic
    always_comb begin
        next_state = state; // Default to hold current state
        case (state)
            IDLE: begin
                if (data) next_state = PATTERN_1;
            end
            PATTERN_1: begin
                next_state = data ? PATTERN_2 : IDLE;
            end
            PATTERN_2: begin
                next_state = data ? PATTERN_3 : IDLE;
            end
            PATTERN_3: begin
                next_state = data ? PATTERN_4 : IDLE;
            end
            PATTERN_4: begin
                next_state = data ? SHIFT : IDLE;
            end
            SHIFT: begin
                if (shift_counter == 4)
                    next_state = WAIT_COUNT;
            end
            WAIT_COUNT: begin
                if (done_counting)
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end
endmodule