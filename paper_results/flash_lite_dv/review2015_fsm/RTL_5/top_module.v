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

    // State Definition
    parameter IDLE = 2'b00;
    parameter SHIFT = 2'b01;
    parameter COUNTING = 2'b10;
    parameter DONE = 2'b11;

    // Internal Signals
    reg [1:0] current_state;
    reg [1:0] next_state;
    reg [1:0] data_buffer;  // Shift register for data
    reg [1:0] shift_counter;


    // State Transition Logic
    always @(*) begin
        next_state = current_state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (current_state)
            IDLE: begin
                data_buffer = {data_buffer[0], data};
                if (data_buffer == 2'b01 && data == 1'b0) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_counter == 2'd3) begin
                    next_state = COUNTING;
                end
            end
            COUNTING: begin
                counting = 1'b1;
                if (done_counting) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                done = 1'b1;
                if (ack) begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Output Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            shift_counter <= 2'd0;
            data_buffer <= 2'b00;
        end else begin
            current_state <= next_state;
            if (current_state == SHIFT) begin
                if (shift_counter < 2'd3) begin
                  shift_counter <= shift_counter + 1'b1;
                end else begin
                  shift_counter <= shift_counter; // keep counter at max value
                end

            end else begin
                shift_counter <= 2'd0; // reset counter at state changes
            end
        end
    end

endmodule