module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State declaration
    typedef enum logic [2:0] {
        IDLE,       // Waiting for start bit
        START,      // Start bit detected
        DATA,       // Receiving data bits
        STOP,       // Verifying stop bit
        ERROR       // Error handling state
    } state_t;

    state_t state, next_state;
    reg [7:0] shift_register;
    reg [3:0] bit_counter;

    // State transition logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_register <= 8'b0;
            bit_counter <= 4'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic & Output logic
    always_comb begin
        next_state = state; // Default is to maintain current state
        done = 1'b0; // Default is to deassert done
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
            end
            START: begin
                if (in == 1'b0) begin
                    next_state = DATA;
                    bit_counter = 4'b0; // Reset bit counter for data bits
                end else begin
                    next_state = IDLE; // False start, go back to IDLE
                end
            end
            DATA: begin
                shift_register[bit_counter] = in; // Shift in data bits
                if (bit_counter == 4'd7)
                    next_state = STOP;
                else
                    bit_counter = bit_counter + 1;
            end
            STOP: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                    done = 1'b1;
                    out_byte = shift_register; // Capture the byte
                end else begin
                    next_state = ERROR; // Incorrect stop bit
                end
            end
            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE; // Go back to IDLE on finding valid stop
            end
        endcase
    end

endmodule