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
        SHIFT_ENABLE,
        COUNTING,
        DONE_STATE
    } state_t;

    state_t current_state, next_state;
    reg [3:0] shift_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
            shift_count <= 0;
        end else begin
            current_state <= next_state;
            if (next_state == SHIFT_ENABLE) begin
                shift_count <= 4;
                shift_ena <= 1;
            end else if (current_state == SHIFT_ENABLE && shift_count > 0) begin
                shift_count <= shift_count - 1;
            end else begin
                shift_ena <= 0;
            end
            if (next_state == COUNTING) begin
                counting <= 1;
            end else if (next_state == DONE_STATE) begin
                done <= 1;
            end else if (next_state == IDLE || ack) begin
                done <= 0;
                counting <= 0;
            end
        end
    end

    always_comb begin
        case (current_state)
            IDLE: begin
                if (data == 1'b1) begin
                    next_state = WAIT_PATTERN;
                end else begin
                    next_state = IDLE;
                end
            end

            WAIT_PATTERN: begin
                if (data == 1'b1) begin
                    next_state = WAIT_PATTERN; // stay in wait if more 1's received
                end else if (data == 1'b0) begin
                    if (some_pattern_detected()) begin // Implement pattern detection logic
                        next_state = SHIFT_ENABLE;
                    end else begin
                        next_state = IDLE;
                    end
                end
            end

            SHIFT_ENABLE: begin
                if (shift_count == 0) begin
                    next_state = COUNTING;
                end else begin
                    next_state = SHIFT_ENABLE;
                end
            end

            COUNTING: begin
                if (done_counting) begin
                    next_state = DONE_STATE;
                end else begin
                    next_state = COUNTING;
                end
            end

            DONE_STATE: begin
                if (ack) begin
                    next_state = IDLE;
                end else begin
                    next_state = DONE_STATE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    function some_pattern_detected;
        // Implement pattern detection logic for 1101 sequence here
        // This function returns 1 if pattern is detected, otherwise returns 0
    endfunction

endmodule