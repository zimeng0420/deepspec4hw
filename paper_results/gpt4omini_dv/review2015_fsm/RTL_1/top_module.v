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
        IDLE,   // Waiting for pattern
        S1,     // Received '1'
        S2,     // Received '11'
        S3,     // Received '110'
        SHIFT,  // Shift enabled for duration
        COUNTING,// Counting state
        DONE    // Timer done
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

    always @(*) begin
        // Default assignments
        next_state = current_state;
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (current_state)
            IDLE: begin
                if (data == 1) next_state = S1;
            end
            S1: begin
                if (data == 1) next_state = S2;
                else next_state = IDLE;
            end
            S2: begin
                if (data == 0) next_state = S3;
                else next_state = IDLE;
            end
            S3: begin
                if (data == 1) begin
                    shift_ena = 1;
                    next_state = SHIFT;
                    shift_count = 4; // start the shift count
                end else begin
                    next_state = IDLE;
                end
            end
            SHIFT: begin
                if (shift_count > 0) begin
                    shift_count = shift_count - 1;
                    if (shift_count == 0) next_state = COUNTING;
                end
            end
            COUNTING: begin
                counting = 1;
                if (done_counting) next_state = DONE;
            end
            DONE: begin
                done = 1;
                if (ack) next_state = IDLE;
            end
        endcase
    end

endmodule