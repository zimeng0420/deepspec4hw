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

// State register
state_t current_state, next_state;

// State transition logic
always @(*) begin
    case (current_state)
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
    endcase
end

// State memory and output logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        current_state <= next_state;
        shift_ena <= (current_state == SHIFT || current_state == SHIFT_1 ||
                      current_state == SHIFT_2 || current_state == SHIFT_3);
        counting <= (current_state == COUNTING);
        done <= (current_state == DONE);
    end
end

endmodule