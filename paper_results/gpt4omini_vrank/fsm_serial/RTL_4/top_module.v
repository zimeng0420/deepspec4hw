module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE,          // idle state
        START_BIT,     // detecting start bit
        DATA_BITS,     // receiving data bits
        STOP_BIT       // verifying stop bit
    } state_t;

    state_t current_state, next_state;
    reg [3:0] bit_count;  // count for data bits
    reg data_valid;       // flag for data valid

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            bit_count <= 0;
            done <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        next_state = current_state;
        done = 0;  // Default done signal
        case (current_state)
            IDLE: begin
                if (in == 0) begin // Start bit detected
                    next_state = START_BIT;
                end
            end
            START_BIT: begin
                next_state = DATA_BITS; // Move to receiving data bits
                bit_count = 0; // Reset the bit counter
            end
            DATA_BITS: begin
                if (bit_count < 8) begin
                    bit_count = bit_count + 1; // Receive data bits
                end else begin
                    next_state = STOP_BIT; // Move to check stop bit
                end
            end
            STOP_BIT: begin
                if (in == 1) begin // Stop bit valid
                    done = 1; // Mark data as valid
                    next_state = IDLE; // Go back to idle state
                end else begin
                    next_state = STOP_BIT; // Wait for a valid stop bit
                end
            end
        endcase
    end

endmodule