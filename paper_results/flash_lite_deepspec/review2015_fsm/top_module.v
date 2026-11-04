module top_module(
	input clk,
	input reset,
	input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack );

    // State Definitions
    parameter IDLE = 2'b00;
    parameter SHIFT = 2'b01;
    parameter COUNTING = 2'b10;
    parameter DONE = 2'b11;

    // Internal Signals
    reg [1:0] state;
    reg [1:0] next_state;
    reg [2:0] shift_counter;
    reg [3:0] data_buffer;

    // State Transition Logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (data_buffer == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                next_state = COUNTING;
            end
            COUNTING: begin
                if (done_counting) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Output Logic
    always @(*) begin
        shift_ena = 0;
        counting = 0;
        done = 0;
        case (state)
            SHIFT: begin
                shift_ena = 1;
            end
            COUNTING: begin
                counting = 1;
            end
            DONE: begin
                done = 1;
            end
        endcase
    end

    // State and Counter Update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_counter <= 3'b000;
            data_buffer <= 4'b0000;
        end else begin
            state <= next_state;
            if (state == SHIFT) begin
                if (shift_counter < 3) begin
                    shift_counter <= shift_counter + 1;
                end else begin
                    shift_counter <= 3'b000;
                end
            end else begin
                shift_counter <= 3'b000;
            end
            if (state == IDLE) begin
                data_buffer <= {data_buffer[2:0], data};
            end
        end
    end

endmodule