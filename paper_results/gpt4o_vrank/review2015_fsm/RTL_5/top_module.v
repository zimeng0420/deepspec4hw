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
        IDLE       = 3'b000,
        DETECT_1   = 3'b001,
        DETECT_11  = 3'b010,
        DETECT_110 = 3'b011,
        DETECT_1101= 3'b100,
        SHIFT      = 3'b101,
        COUNTING   = 3'b110,
        DONE       = 3'b111
    } state_t;

    state_t state, next_state;
    reg [2:0] shift_count;

    // State Transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;
            if (shift_ena) shift_count <= shift_count + 1;
            else shift_count <= 3'd0;
        end
    end

    // Next state logic
    always @(*) begin
        shift_ena = 0;
        counting = 0;
        done = 0;
        case (state)
            IDLE: begin
                if (data == 1'b1) next_state = DETECT_1;
                else next_state = IDLE;
            end
            DETECT_1: begin
                if (data == 1'b1) next_state = DETECT_11;
                else next_state = IDLE;
            end
            DETECT_11: begin
                if (data == 1'b0) next_state = DETECT_110;
                else next_state = IDLE;
            end
            DETECT_110: begin
                if (data == 1'b1) next_state = DETECT_1101;
                else next_state = IDLE;
            end
            DETECT_1101: begin
                shift_ena = 1;
                next_state = SHIFT;
            end
            SHIFT: begin
                shift_ena = 1;
                if (shift_count == 3'd3) next_state = COUNTING;
                else next_state = SHIFT;
            end
            COUNTING: begin
                counting = 1;
                if (done_counting) next_state = DONE;
                else next_state = COUNTING;
            end
            DONE: begin
                done = 1;
                if (ack) next_state = IDLE;
                else next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule