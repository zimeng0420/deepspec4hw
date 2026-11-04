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
        IDLE        = 3'b000,
        CHECK_1     = 3'b001,
        CHECK_11    = 3'b010,
        CHECK_110   = 3'b011,
        CHECK_1101  = 3'b100,
        SHIFT       = 3'b101,
        COUNT_WAIT  = 3'b110,
        DONE        = 3'b111
    } state_t;

    reg [2:0] state, next_state;
    reg [2:0] shift_counter;

    always @(posedge clk) begin
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
                if (data == 1) next_state = CHECK_1;
            end
            CHECK_1: begin
                if (data == 1) next_state = CHECK_11;
                else next_state = IDLE;
            end
            CHECK_11: begin
                if (data == 0) next_state = CHECK_110;
                else next_state = IDLE;
            end
            CHECK_110: begin
                if (data == 1) next_state = CHECK_1101;
                else next_state = IDLE;
            end
            CHECK_1101: begin
                shift_ena = 1;
                shift_counter = 0;
                next_state = SHIFT;
            end
            SHIFT: begin
                shift_ena = 1;
                shift_counter = shift_counter + 1;
                if (shift_counter == 4) next_state = COUNT_WAIT;
            end
            COUNT_WAIT: begin
                counting = 1;
                if (done_counting) next_state = DONE;
            end
            DONE: begin
                done = 1;
                if (ack) next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule