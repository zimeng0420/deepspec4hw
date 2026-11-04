module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE       = 3'b000,
        START_BIT  = 3'b001,
        DATA_BITS  = 3'b010,
        STOP_BIT   = 3'b011
    } state_t;

    state_t current_state, next_state;
    reg [3:0] bit_count; // Counts the number of received data bits

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
            bit_count <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        done = 0; // Default done signal to low
        case (current_state)
            IDLE: begin
                if (in == 0) begin // Detect start bit
                    next_state = START_BIT;
                end else begin
                    next_state = IDLE;
                end
            end
            START_BIT: begin
                next_state = DATA_BITS; // Move to data bits after start bit
            end
            DATA_BITS: begin
                if (bit_count < 8) begin
                    next_state = DATA_BITS; // Keep receiving data bits
                end else begin
                    next_state = STOP_BIT;  // Move to stop bit after 8 data bits
                end
            end
            STOP_BIT: begin
                if (in == 1) begin // Check for stop bit
                    done = 1; // Successfully received byte
                    next_state = IDLE; // Return to idle state
                end else begin
                    next_state = IDLE; // Wait for a stop bit and return to idle
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Bit count handling
    always @(posedge clk) begin
        if (current_state == DATA_BITS) begin
            bit_count <= bit_count + 1;
        end else if (current_state == IDLE || current_state == STOP_BIT) begin
            bit_count <= 0; // Reset bit count
        end
    end

endmodule