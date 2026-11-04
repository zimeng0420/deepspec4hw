module top_module (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Define state constants
    typedef enum reg [2:0] {
        IDLE   = 3'b000,
        START  = 3'b001,
        DATA   = 3'b010,
        STOP   = 3'b011,
        ERROR  = 3'b100
    } state_t;

    // State registers
    state_t current_state, next_state;
    reg [7:0] shift_register;
    reg [2:0] bit_counter;

    // State transition on every clock edge
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 1'b0;
            out_byte <= 8'b0;
            shift_register <= 8'b0;
            bit_counter <= 3'b0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        // Default assignments
        next_state = current_state;
        done = 1'b0;
        
        case (current_state)
            IDLE: begin
                if (in == 1'b0) // Detect start bit
                    next_state = START;
            end

            START: begin
                next_state = DATA; // Move to data state after start bit detection
                shift_register = 8'b0; // Clear shift register
                bit_counter = 3'b0; // Reset bit counter
            end

            DATA: begin
                shift_register[bit_counter] = in; // Shift in data bits
                if (bit_counter == 3'b111) begin // Last data bit
                    next_state = STOP;
                end else begin
                    bit_counter = bit_counter + 1;
                end
            end

            STOP: begin
                if (in == 1'b1) begin // Check stop bit
                    done = 1'b1;
                    out_byte = shift_register; // Transfer received byte to output
                    next_state = IDLE; // Ready for next byte
                end else begin
                    next_state = ERROR; // Incorrect stop bit, move to error state
                end
            end

            ERROR: begin
                if (in == 1'b1) // Wait for line to return to idle
                    next_state = IDLE;
            end

            default: begin
                next_state = IDLE; // Default to IDLE state
            end
        endcase
    end
endmodule