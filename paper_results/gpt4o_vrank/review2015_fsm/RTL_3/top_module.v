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
        IDLE = 3'b000,
        DETECT_1 = 3'b001,
        DETECT_11 = 3'b010,
        DETECT_110 = 3'b011,
        DETECT_1101 = 3'b100,
        SHIFT = 3'b101,
        WAIT_COUNT = 3'b110,
        DONE = 3'b111
    } state_t;

    state_t state, next_state;
    reg [2:0] shift_counter;
    
    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        // Default assignments
        next_state = state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (state)
            IDLE: begin
                if (data) next_state = DETECT_1;
            end

            DETECT_1: begin
                if (data) next_state = DETECT_11;
                else next_state = IDLE;
            end

            DETECT_11: begin
                if (~data) next_state = DETECT_110;
                else next_state = IDLE;
            end

            DETECT_110: begin
                if (data) next_state = DETECT_1101;
                else next_state = IDLE;
            end

            DETECT_1101: begin
                shift_ena = 1'b1;
                next_state = SHIFT;
            end

            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_counter == 3'd3) next_state = WAIT_COUNT;
            end

            WAIT_COUNT: begin
                counting = 1'b1;
                if (done_counting) next_state = DONE;
            end

            DONE: begin
                done = 1'b1;
                if (ack) next_state = IDLE;
            end
        endcase
    end

    // Shift counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_counter <= 3'd0;
        end else if (shift_ena) begin
            shift_counter <= shift_counter + 3'd1;
        end else begin
            shift_counter <= 3'd0;
        end
    end

endmodule