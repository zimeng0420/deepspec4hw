module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);
    // State declaration
    typedef enum logic [2:0] {
        IDLE, START_BIT, RECEIVE_BITS, STOP_BIT, ERROR
    } state_t;
    
    // Register for current state and bit count
    state_t state, next_state;
    logic [3:0] bit_count;

    // State transition
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'd0;
        end else begin
            state <= next_state;
            if (state == RECEIVE_BITS)
                bit_count <= bit_count + 1;
            else
                bit_count <= 4'd0;
        end
    end
    
    // Next state logic
    always_comb begin
        next_state = state;
        done = 0; // Default value
        
        case (state)
            IDLE: begin
                if (in == 0) // Start bit detected
                    next_state = START_BIT;
            end

            START_BIT: begin
                next_state = RECEIVE_BITS; // Transition to receiving data bits
            end

            RECEIVE_BITS: begin
                if (bit_count == 4'd7) // After 8 data bits received
                    next_state = STOP_BIT;
            end

            STOP_BIT: begin
                if (in == 1) begin // Valid stop bit
                    done = 1; // Indicate byte received
                    next_state = IDLE; // Go back to idle
                end else begin
                    next_state = ERROR; // Invalid stop bit
                end
            end

            ERROR: begin
                if (in == 1) // Wait for stop bit to recover
                    next_state = IDLE;
            end

            default: next_state = IDLE; // Default case to avoid latches
        endcase
    end
endmodule