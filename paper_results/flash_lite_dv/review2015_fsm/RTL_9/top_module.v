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

    // State Register
    reg [1:0] state;

    // Internal Signals
    reg [1:0] next_state;
    reg [1:0] data_buffer; // Shift register for data input
    reg [1:0] shift_counter;

    // Combinational Logic for Next State and Outputs
    always @(*) begin
        next_state = state;
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (state)
            IDLE: begin
                // Detect start sequence (1101)
                if (data_buffer == 2'b11 && data && !data_buffer[0]) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                shift_ena = 1;
                if (shift_counter == 2'd3) begin
                    next_state = COUNTING;
                end
            end
            COUNTING: begin
                counting = 1;
                if (done_counting) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                done = 1;
                if (ack) begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential Logic for State and Outputs
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_counter <= 0;
            data_buffer <= 0; // Initialize the data buffer
        end else begin
            state <= next_state;
            if (state == SHIFT && shift_counter < 3) begin
                shift_counter <= shift_counter + 1;
            end else if (state != SHIFT) begin
                shift_counter <= 0;
            end

             // Shift the data buffer in IDLE state.
            if (state == IDLE) begin
                data_buffer <= {data_buffer[0],data}; // Shift the bits in
            end

        end
    end

endmodule