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

    parameter IDLE = 0,
              S1 = 1,
              S2 = 2,
              S3 = 3,
              S4 = 4,
              COUNTING = 5,
              WAIT_DONE = 6,
              ACKNOWLEDGE = 7;

    reg [2:0] state, next_state;
    reg [3:0] data_buffer;
    integer i;

    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (state)
            IDLE: begin
                if (data == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                if (data == 1'b1)
                    next_state = S2;
                else
                    next_state = IDLE;
            end
            S2: begin
                if (data == 1'b0)
                    next_state = S3;
                else
                    next_state = IDLE;
            end
            S3: begin
                if (data == 1'b1) begin
                    next_state = S4;
                end
                else
                    next_state = IDLE;
            end

            S4: begin
                shift_ena = 1'b1;
                next_state = COUNTING;
            end

            COUNTING: begin
                shift_ena = 1'b0;
                counting = 1'b1;
                next_state = WAIT_DONE;
            end

            WAIT_DONE: begin
                counting = 1'b1;
                if (done_counting)
                    next_state = ACKNOWLEDGE;
                else
                    next_state = WAIT_DONE;
            end

            ACKNOWLEDGE: begin
                done = 1'b1;
                if (ack)
                    next_state = IDLE;
                else
                    next_state = ACKNOWLEDGE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule