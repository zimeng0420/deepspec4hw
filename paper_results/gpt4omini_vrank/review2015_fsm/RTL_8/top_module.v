module top_module(
    input clk,
    input reset,
    input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack );

    typedef enum reg [2:0] {
        IDLE,
        DETECT,
        SHIFT,
        COUNT,
        NOTIFY
    } state_t;

    state_t current_state, next_state;
    reg [3:0] shift_counter;

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

    always @(*) begin
        // Default assignments
        next_state = current_state;
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (current_state)
            IDLE: begin
                if (data == 1) begin
                    next_state = DETECT;
                end
            end

            DETECT: begin
                if (data == 1) begin
                    shift_counter = 3; // 4 shifts needed
                    next_state = SHIFT;
                end else begin
                    next_state = IDLE;
                end
            end

            SHIFT: begin
                if (shift_counter > 0) begin
                    shift_ena = 1;
                    shift_counter = shift_counter - 1;
                end else begin
                    counting = 1;
                    next_state = COUNT;
                end
            end

            COUNT: begin
                if (done_counting) begin
                    done = 1;
                    next_state = NOTIFY;
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