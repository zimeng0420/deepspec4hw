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

    // Define states
    typedef enum logic [2:0] {
        IDLE,
        SHIFT,
        COUNTING,
        DONE
    } state_t;

    reg state;
    reg next_state;
    reg [1:0] shift_count;
    reg [3:0] pattern_buffer;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
            shift_count <= 0;
            pattern_buffer <= 4'b0000;
        end else begin
            state <= next_state;
            if (state == SHIFT) begin
                if (shift_count < 4) begin
                    shift_count <= shift_count + 1;
                end
            end else begin
                shift_count <= 0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (state)
            IDLE: begin
                if (pattern_buffer == 4'b1101) begin
                    next_state = SHIFT;
                    shift_ena = 1;
                } else begin
                    next_state = IDLE;
                end
            end
            SHIFT: begin
                if (shift_count < 3) begin
                    next_state = SHIFT;
                    shift_ena = 1;
                } else begin
                    next_state = COUNTING;
                    counting = 1;
                    shift_ena = 0;
                end
            end
            COUNTING: begin
                counting = 1;
                if (done_counting) begin
                    next_state = DONE;
                    done = 1;
                    counting = 0;
                end else begin
                    next_state = COUNTING;
                end
            end
            DONE: begin
                done = 1;
                if (ack) begin
                    next_state = IDLE;
                    done = 0;
                end else begin
                    next_state = DONE;
                end
            end
            default: next_state = IDLE;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            pattern_buffer <= 4'b0000;
        end else begin
            pattern_buffer <= {pattern_buffer[2:0], data};
        end
    end

endmodule