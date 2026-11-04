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

    reg [1:0] state;
    reg [1:0] next_state;
    reg [2:0] bit_count; // Counter to detect the start sequence
    reg [1:0] shift_count;  // Counter for shift_ena

    // Start sequence detection - Using a shift register
    reg [3:0] data_buffer;

    // State Transition Logic
    always @(*) begin
        next_state = state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (state)
            IDLE: begin
                data_buffer <= {data_buffer[2:0], data};
                bit_count <= (data_buffer == 4'b1101) ? 3'b001 : (bit_count == 3'b001? 3'b010: (bit_count == 3'b010 ? 3'b011 : 3'b000));
                if (data_buffer == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_count == 2'd3) begin // shift_ena asserted for 4 cycles
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
        endcase
    end

    // State Register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'd0;
            bit_count <= 3'b000;
            data_buffer <= 4'b0000;
        end else begin
            state <= next_state;
            if (state == SHIFT) begin
                shift_count <= shift_count + 1'b1;
            end
            else
                shift_count <= 2'd0;
        end
    end
endmodule