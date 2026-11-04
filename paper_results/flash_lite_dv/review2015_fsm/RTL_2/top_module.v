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

    // Define states
    parameter IDLE = 2'b00;
    parameter SHIFT = 2'b01;
    parameter COUNTING = 2'b10;
    parameter DONE = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;
    reg [1:0] data_buffer; // Shift register for start sequence detection
    reg [1:0] shift_counter;

    // State transition logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (data_buffer == 2'b11 && data) begin // Simplified start sequence detection
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                next_state = (shift_counter == 2) ? COUNTING : SHIFT; // After 4 clock cycles
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

    // Output logic
    always @(*) begin
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
        case (state)
            SHIFT: shift_ena = 1'b1;
            COUNTING: counting = 1'b1;
            DONE: done = 1'b1;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_counter <= 2'b00;
        end else begin
            state <= next_state;
            if (state == SHIFT) begin
                shift_counter <= shift_counter + 1'b1;
            end else begin
                shift_counter <= 2'b00; // Reset the counter
            end
        end
    end

    // Data buffer
    always @(posedge clk) begin
        data_buffer <= {data_buffer[0], data};
    end

endmodule