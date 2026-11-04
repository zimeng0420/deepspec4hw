module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State Encoding
    typedef enum reg [2:0] {
        IDLE = 3'b000,
        START = 3'b001,
        DATA_BITS = 3'b010,
        STOP = 3'b011,
        VALID = 3'b100
    } state_t;

    state_t state, next_state;
    reg [3:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            bit_count <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        // Default values
        done = 0;
        next_state = state;

        case (state)
            IDLE: begin
                if (in == 0) begin // Start bit detected
                    next_state = START;
                end
            end

            START: begin
                next_state = DATA_BITS; // Move to data bits after start bit
            end

            DATA_BITS: begin
                if (bit_count < 8) begin
                    bit_count = bit_count + 1; // Count data bits
                end else begin
                    next_state = STOP; // Move to stop state after 8 bits
                end
            end

            STOP: begin
                if (in == 1) begin // Stop bit detected
                    done = 1; // Indicate byte received
                    next_state = IDLE; // Go back to idle
                    bit_count = 0; // Reset bit count
                end else begin
                    // Stay in STOP until valid stop bit detected
                    next_state = STOP;
                end
            end

            default: next_state = IDLE; // Default state
        endcase
    end

endmodule