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
        IDLE, IDLE_1, IDLE_11, IDLE_110, SHIFT, COUNTING, DONE
    } state_t;

    state_t state, next_state;
    reg [1:0] shift_counter;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        shift_ena = 0;
        counting = 0;
        done = 0;
        next_state = state;

        case (state)
            IDLE: begin
                if (data)
                    next_state = IDLE_1;
            end

            IDLE_1: begin
                if (data)
                    next_state = IDLE_11;
                else
                    next_state = IDLE;
            end

            IDLE_11: begin
                if (~data)
                    next_state = IDLE_110;
                else
                    next_state = IDLE_1;
            end

            IDLE_110: begin
                if (data)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end

            SHIFT: begin
                shift_ena = 1;
                shift_counter = 0;
                next_state = SHIFT_1;
            end

            SHIFT_1, SHIFT_2, SHIFT_3: begin
                shift_ena = 1;
                if (shift_counter == 2'd3)
                    next_state = COUNTING;
                else
                    next_state = state + 1'b1;
                shift_counter = shift_counter + 1'b1;
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