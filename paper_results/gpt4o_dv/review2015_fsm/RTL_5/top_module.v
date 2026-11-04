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
        IDLE = 3'b000,
        IDLE_1 = 3'b001,
        IDLE_11 = 3'b010,
        IDLE_110 = 3'b011,
        SHIFT = 3'b100,
        COUNTING = 3'b101,
        DONE = 3'b110
    } state_t;

    state_t state, next_state;
    reg [2:0] shift_counter;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_counter <= 0;
        end else begin
            state <= next_state;
            if (state == SHIFT) begin
                shift_counter <= shift_counter + 1;
            end else begin
                shift_counter <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data == 1) next_state = IDLE_1;
                else next_state = IDLE;
            end
            IDLE_1: begin
                if (data == 1) next_state = IDLE_11;
                else next_state = IDLE;
            end
            IDLE_11: begin
                if (data == 0) next_state = IDLE_110;
                else next_state = IDLE;
            end
            IDLE_110: begin
                if (data == 1) next_state = SHIFT;
                else next_state = IDLE;
            end
            SHIFT: begin
                if (shift_counter == 4) next_state = COUNTING;
                else next_state = SHIFT;
            end
            COUNTING: begin
                if (done_counting) next_state = DONE;
                else next_state = COUNTING;
            end
            DONE: begin
                if (ack) next_state = IDLE;
                else next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting = (state == COUNTING);
        done = (state == DONE);
    end

endmodule