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

    // State Encoding
    parameter IDLE = 3'b000,
              S1   = 3'b001,
              S2   = 3'b010,
              S3   = 3'b011,
              SHIFT = 3'b100,
              COUNTING = 3'b101,
              DONE = 3'b110;

    reg [2:0] current_state, next_state;
    reg [3:0] shift_counter;

    // Synchronous Reset and State Transition Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
            shift_counter <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State Logic
    always @* begin
        // Default values
        next_state = current_state;
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (current_state)
            IDLE: begin
                if (data == 1) next_state = S1; // Check for the first bit of the pattern
            end
            S1: begin
                if (data == 1) next_state = S2; // Check for the second bit of the pattern
                else next_state = IDLE; // Reset if not matching
            end
            S2: begin
                if (data == 0) next_state = S3; // Check for the third bit of the pattern
                else next_state = IDLE; // Reset if not matching
            end
            S3: begin
                if (data == 1) next_state = SHIFT; // Check for the fourth bit of the pattern
                else next_state = IDLE; // Reset if not matching
            end
            SHIFT: begin
                if (shift_counter < 4) begin
                    shift_ena = 1; // Assert shift_ena for 4 cycles
                    shift_counter = shift_counter + 1;
                end else begin
                    shift_counter = 0;
                    next_state = COUNTING; // Go to counting state after shifting
                end
            end
            COUNTING: begin
                counting = 1; // Start counting
                if (done_counting) next_state = DONE; // Move to done state when counting is complete
            end
            DONE: begin
                done = 1; // Assert done signal
                if (ack) next_state = IDLE; // Reset to IDLE state after acknowledgment
            end
        endcase
    end

endmodule