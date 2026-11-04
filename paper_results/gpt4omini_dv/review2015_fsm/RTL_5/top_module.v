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

    // State encoding
    typedef enum reg [2:0] {
        IDLE,
        S1,
        S2,
        S3,
        SHIFT,
        COUNTING,
        DONE
    } state_t;

    state_t current_state, next_state;
    reg [2:0] shift_counter;

    // Synchronous state transition
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

    // Next state logic and output logic
    always @(*) begin
        // Default values
        next_state = current_state;
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (current_state)
            IDLE: begin
                if (data == 1)         next_state = S1;
            end
            S1: begin
                if (data == 1)         next_state = S2;
                else                   next_state = IDLE;
            end
            S2: begin
                if (data == 0)         next_state = S3;
                else                   next_state = IDLE;
            end
            S3: begin
                if (data == 1) begin
                    next_state = SHIFT;
                    shift_counter = 0;
                end else begin
                    next_state = IDLE;
                end
            end
            SHIFT: begin
                shift_ena = 1;
                if (shift_counter < 3) begin
                    shift_counter = shift_counter + 1;
                end else begin
                    next_state = COUNTING;
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