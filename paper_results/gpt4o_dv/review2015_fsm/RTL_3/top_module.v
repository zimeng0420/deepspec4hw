module top_module(
    input clk,
    input reset,
    input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack );

    // State encoding
    typedef enum reg [2:0] {
        IDLE,
        IDLE_1,
        IDLE_11,
        IDLE_110,
        SHIFT,
        SHIFT_1,
        SHIFT_2,
        SHIFT_3,
        COUNTING,
        DONE
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: next_state = data ? IDLE_1 : IDLE;
            IDLE_1: next_state = data ? IDLE_11 : IDLE;
            IDLE_11: next_state = data ? IDLE_11 : IDLE_110;
            IDLE_110: next_state = data ? SHIFT : IDLE;
            SHIFT: next_state = SHIFT_1;
            SHIFT_1: next_state = SHIFT_2;
            SHIFT_2: next_state = SHIFT_3;
            SHIFT_3: next_state = COUNTING;
            COUNTING: next_state = done_counting ? DONE : COUNTING;
            DONE: next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // State updates and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        // Default outputs
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
        
        case (state)
            SHIFT, SHIFT_1, SHIFT_2, SHIFT_3: shift_ena = 1'b1;
            COUNTING: counting = 1'b1;
            DONE: done = 1'b1;
        endcase
    end
endmodule