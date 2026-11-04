module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE,
        START_BIT,
        DATA_RECEIVE,
        STOP_BIT_VERIFY
    } state_t;

    state_t current_state, next_state;
    reg [7:0] data_buffer;
    reg [2:0] bit_count;

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
        next_state = current_state;
        done = 0;

        case (current_state)
            IDLE: begin
                if (in == 0) // Start bit detected
                    next_state = START_BIT;
            end
            
            START_BIT: begin
                next_state = DATA_RECEIVE; // Move to data reception after detecting start bit
            end
            
            DATA_RECEIVE: begin
                if (bit_count < 7) begin
                    bit_count = bit_count + 1;
                    data_buffer[bit_count] = in; // Shift in data bits (LSB first)
                end else begin
                    next_state = STOP_BIT_VERIFY; // All data bits received
                end
            end
            
            STOP_BIT_VERIFY: begin
                if (in == 1) begin // Stop bit verified
                    done = 1; // Signal done
                    next_state = IDLE; // Return to idle state
                    bit_count = 0; // Reset bit counter
                end // else stay in STOP_BIT_VERIFY until valid stop bit
            end
        endcase
    end

endmodule