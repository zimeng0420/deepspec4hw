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
        IDLE        = 3'b000,
        CHECK_1     = 3'b001,
        CHECK_11    = 3'b010,
        CHECK_110   = 3'b011,
        CHECK_1101  = 3'b100,
        SHIFT       = 3'b101,
        WAIT_COUNT  = 3'b110,
        DONE        = 3'b111
    } state_t;

    state_t state, next_state;

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
        shift_ena = 0;
        counting = 0;
        done = 0;
        next_state = state;  // Default state remains the same

        case (state)
            IDLE: begin
                if (data) next_state = CHECK_1;
            end

            CHECK_1: begin
                if (data) next_state = CHECK_11;
                else next_state = IDLE;
            end

            CHECK_11: begin
                if (~data) next_state = CHECK_110;
                else next_state = IDLE;
            end

            CHECK_110: begin
                if (data) next_state = CHECK_1101;
                else next_state = IDLE;
            end

            CHECK_1101: begin
                if (data) begin
                    shift_ena = 1;
                    next_state = SHIFT;
                end else begin
                    next_state = IDLE;
                end
            end

            SHIFT: begin
                shift_ena = 1;
                next_state = WAIT_COUNT;
            end

            WAIT_COUNT: begin
                counting = 1;
                if (done_counting) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                done = 1;
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end
endmodule