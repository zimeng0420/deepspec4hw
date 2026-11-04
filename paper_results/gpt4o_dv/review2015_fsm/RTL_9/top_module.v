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
        IDLE        = 3'b000,
        IDLE_1      = 3'b001,
        IDLE_11     = 3'b010,
        IDLE_110    = 3'b011,
        SHIFT       = 3'b100,
        COUNTING    = 3'b101,
        DONE        = 3'b110
    } state_t;

    state_t current_state, next_state;
    reg [2:0] shift_counter;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            shift_counter <= 3'b000;
        end
        else begin
            current_state <= next_state;
            if (next_state == SHIFT) begin
                shift_counter <= shift_counter + 1;
            end
            else begin
                shift_counter <= 3'b000;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (current_state)
            IDLE: begin
                if (data) next_state = IDLE_1;
            end

            IDLE_1: begin
                if (~data) next_state = IDLE;
                else next_state = IDLE_11;
            end

            IDLE_11: begin
                if (data) next_state = IDLE_11;
                else next_state = IDLE_110;
            end

            IDLE_110: begin
                if (data) next_state = SHIFT;
                else next_state = IDLE;
            end

            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_counter == 3'd3) next_state = COUNTING;
            end

            COUNTING: begin
                counting = 1'b1;
                if (done_counting) next_state = DONE;
            end

            DONE: begin
                done = 1'b1;
                if (ack) next_state = IDLE;
            end
        endcase
    end

endmodule