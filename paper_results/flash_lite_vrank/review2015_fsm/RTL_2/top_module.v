module top_module(
	input clk,
	input reset,
	input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack );

    parameter IDLE = 0;
    parameter CHECK1 = 1;
    parameter CHECK2 = 2;
    parameter CHECK3 = 3;
    parameter SHIFT = 4;
    parameter COUNTING_STATE = 5;
    parameter DONE_STATE = 6;
    
    reg [2:0] state, next_state;
    reg [1:0] bit_count;
    reg [3:0] data_buffer;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
            bit_count <= 2'b00;
            data_buffer <= 4'b0000;

        end else begin
            state <= next_state;
            
        end
    end

    always @(*) begin
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
        next_state = state;

        case (state)
            IDLE: begin
                bit_count = 2'b00;
                if (data == 1'b1) begin
                    next_state = CHECK1;
                end else begin
                    next_state = IDLE;
                end
            end
            CHECK1: begin
                if (data == 1'b1) begin
                    next_state = CHECK2;
                end else begin
                    next_state = IDLE;
                end
            end
            CHECK2: begin
                if (data == 1'b0) begin
                    next_state = CHECK3;
                end else begin
                    next_state = IDLE;
                end
            end
            CHECK3: begin
                if (data == 1'b1) begin
                    next_state = SHIFT;
                end else begin
                    next_state = IDLE;
                end
            end
            SHIFT: begin
                shift_ena = 1'b1;
                bit_count = bit_count + 1;
                if (bit_count == 2'b11) begin
                    next_state = COUNTING_STATE;
                    bit_count = 2'b00;
                end else begin
                  next_state = SHIFT;
                end
            end
            COUNTING_STATE: begin
                counting = 1'b1;
                if (done_counting) begin
                    next_state = DONE_STATE;
                end else begin
                    next_state = COUNTING_STATE;
                end
            end
            DONE_STATE: begin
                done = 1'b1;
                if (ack) begin
                    next_state = IDLE;
                end else begin
                    next_state = DONE_STATE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule