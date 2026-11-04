module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE       = 3'b000,
        START_BIT  = 3'b001,
        DATA_BIT   = 3'b010,
        STOP_BIT   = 3'b011
    } state_t;

    state_t current_state, next_state;
    integer bit_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
            bit_count <= 0;
        end else begin
            current_state <= next_state;

            // Logic to determine when to set done
            if (next_state == STOP_BIT) begin
                done <= 1;
            end else begin
                done <= 0;
            end
        end
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            bit_count <= 0;
        end else begin
            // Count the data bits received
            if (current_state == DATA_BIT) begin
                bit_count <= bit_count + 1;
            end else if (current_state == STOP_BIT) begin
                bit_count <= 0; // Reset data bit count after stop bit
            end else begin
                bit_count <= 0; // Reset count when not in data or stop bit state
            end
        end
    end

    always_comb begin
        case (current_state)
            IDLE: begin
                if (in == 0) 
                    next_state = START_BIT; // Expecting start bit
                else 
                    next_state = IDLE; // Stay in IDLE
            end
            
            START_BIT: begin
                next_state = DATA_BIT; // Move to data bit state after start bit
            end
            
            DATA_BIT: begin
                if (bit_count < 7) // 8 bits including LSB (0 to 7)
                    next_state = DATA_BIT; // Continue receiving data bits
                else
                    next_state = STOP_BIT; // Move to stop bit state
            end
            
            STOP_BIT: begin
                if (in == 1) // Check for stop bit
                    next_state = IDLE; // Correct stop bit, move back to IDLE
                else
                    next_state = STOP_BIT; // Wait for correct stop bit
            end
            
            default: next_state = IDLE; // Default case to handle invalid states
        endcase
    end

endmodule