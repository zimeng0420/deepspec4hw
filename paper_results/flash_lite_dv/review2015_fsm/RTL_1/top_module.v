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
    localparam IDLE = 2'b00;
    localparam SHIFT = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE = 2'b11;

    // State Register
    reg [1:0] current_state;
    reg [1:0] next_state;

    // Internal Signals
    reg [1:0] data_buffer; //shift register for start sequence detection
    reg [1:0] shift_counter; // counter for shift_ena

    // Default Values
    always @(*) begin
        next_state = current_state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
    end

    // State Transition Logic and Output Logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (reset) begin
                  next_state = IDLE;
                end
                else if (data_buffer == 2'b11 && data ) begin
                     next_state = SHIFT;
                end
                else begin
                    next_state = IDLE;
                end
            end
            SHIFT: begin
                if (shift_counter == 2'b11) begin
                    next_state = COUNTING;
                end else begin
                  next_state = SHIFT;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                  next_state = DONE;
                end
                else begin
                  next_state = COUNTING;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end
                else begin
                    next_state = DONE;
                end
            end
        endcase

        // Output Assignments
        case (current_state)
            SHIFT: begin
                shift_ena = 1'b1;
            end
            COUNTING: begin
                counting = 1'b1;
            end
            DONE: begin
                done = 1'b1;
            end
            default: begin
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b0;
            end
        endcase
    end

    // State Update and Counter Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            shift_counter <= 2'b00;
            data_buffer <= 2'b00;
        end
        else begin
            current_state <= next_state;
            // Shift Register for Data Input
            if (current_state == IDLE) begin
                data_buffer[0] <= data;
                data_buffer[1] <= data_buffer[0];
            end
            // Shift Counter
            if (current_state == SHIFT) begin
                if (shift_counter < 2'b11) begin
                    shift_counter <= shift_counter + 1'b1;
                end else begin
                    shift_counter <= 2'b00;
                end
            end else begin
                shift_counter <= 2'b00;
            end
        end
    end

endmodule