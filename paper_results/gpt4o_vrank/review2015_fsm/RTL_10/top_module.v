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
        IDLE = 3'b000,
        PATTERN_DETECTED = 3'b001,
        SHIFTING = 3'b010,
        WAIT_COUNT = 3'b011,
        DONE = 3'b100
    } state_t;

    state_t state, next_state;
    reg [2:0] pattern_shift_reg;
    reg [2:0] shift_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift_reg <= 3'b000;
            shift_count <= 3'b000;
        end else begin
            state <= next_state;
            if (state == PATTERN_DETECTED) begin
                if (shift_ena)
                    shift_count <= shift_count + 1;
            end
            pattern_shift_reg <= {pattern_shift_reg[1:0], data};
        end
    end

    always @(*) begin
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
        next_state = state;

        case (state)
            IDLE: begin
                if (pattern_shift_reg == 3'b110 && data == 1'b1)
                    next_state = PATTERN_DETECTED;
            end

            PATTERN_DETECTED: begin
                shift_ena = 1'b1;
                if (shift_count == 3) 
                    next_state = WAIT_COUNT;
            end

            WAIT_COUNT: begin
                counting = 1'b1;
                if (done_counting)
                    next_state = DONE;
            end

            DONE: begin
                done = 1'b1;
                if (ack)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule