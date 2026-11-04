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

    // State Definitions
    parameter IDLE = 2'b00;
    parameter SHIFT = 2'b01;
    parameter COUNTING = 2'b10;
    parameter DONE = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;
    reg [2:0] bit_count; // Counter for detecting the start sequence (1101)
    reg [1:0] shift_count; // Counter for shift_ena duration
    reg [3:0] data_buffer; // Buffer to store the 4-bit sequence

    // State transition logic and output logic
    always @(*) begin
        next_state = state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (state)
            IDLE: begin
                // Detect the start sequence (1101)
                if (data_buffer == 4'b1101) begin
                    next_state = SHIFT;
                    bit_count = 3'b000; // Reset the bit counter to 0 after detecting start sequence.
                end
            end
            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_count == 2'd3) { //shift_count goes from 0,1,2,3
                    next_state = COUNTING;
                }
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
            default:
                next_state = IDLE;
        endcase
    end

    // State register and counters
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'b00;
            data_buffer <= 4'b0000;
        end else begin
            state <= next_state;
            if (state == SHIFT) begin
                shift_count <= shift_count + 1'b1;
            end else if (state != SHIFT) begin
                 shift_count <= 2'b00;
            end

        end
    end
      always @(posedge clk) begin
        if (state == IDLE) begin
            data_buffer <= {data_buffer[2:0], data}; // Shift in data
        end
    end
endmodule