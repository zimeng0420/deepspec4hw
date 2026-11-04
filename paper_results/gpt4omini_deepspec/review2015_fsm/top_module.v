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
    typedef enum logic [2:0] {
        IDLE,
        S1,
        S2,
        S3,
        SHIFT,
        COUNTING,
        DONE
    } state_t;

    state_t current_state, next_state;
    integer shift_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
            shift_count <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == SHIFT) begin
                if (shift_count < 3) begin
                    shift_count <= shift_count + 1;
                end else begin
                    shift_count <= 0;
                end
            end
        end
    end

    always_comb begin
        // Default outputs
        shift_ena = 0;
        counting = 0;
        done = 0;
        next_state = current_state;

        case (current_state)
            IDLE: begin
                if (data) 
                    next_state = S1;
            end

            S1: begin
                if (data) 
                    next_state = S2;
                else 
                    next_state = IDLE; 
            end

            S2: begin
                if (~data) 
                    next_state = S3;
                else 
                    next_state = IDLE; 
            end

            S3: begin
                if (~data) begin
                    next_state = SHIFT;
                    shift_count = 0; // Reset shift count
                end else
                    next_state = IDLE; 
            end

            SHIFT: begin
                shift_ena = 1;
                if (shift_count == 3) 
                    next_state = COUNTING;
            end

            COUNTING: begin
                counting = 1;
                if (done_counting) 
                    next_state = DONE;
            end

            DONE: begin
                done = 1;
                if (ack) 
                    next_state = IDLE;
            end
        endcase
    end
endmodule