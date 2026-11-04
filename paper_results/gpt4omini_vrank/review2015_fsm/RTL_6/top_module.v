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
        NOTIFY
    } state_t;

    state_t state, next_state;
    reg [3:0] shift_counter; // To count 4 clock cycles for shifting

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
            shift_counter <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    next_state = WAIT_PATTERN;
                end
            end
            
            WAIT_PATTERN: begin
                if (data == 1'b1) begin
                    next_state = WAIT_PATTERN;
                end else if (data == 1'b0) begin
                    next_state = SHIFT;
                end
            end
            
            SHIFT: begin
                shift_ena = 1;
                shift_counter = shift_counter + 1;
                if (shift_counter < 4) begin
                    next_state = SHIFT;
                end else begin
                    next_state = COUNT;
                    shift_counter = 0; // Reset shift counter
                end
            end
            
            COUNT: begin
                counting = 1;
                if (done_counting) begin
                    next_state = NOTIFY;
                end
            end
            
            NOTIFY: begin
                done = 1;
                if (ack) begin
                    next_state = IDLE;
                end
            end
            
        endcase
    end

endmodule