module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE = 2'b00,
        START_BIT = 2'b01,
        DATA_RECEIVE = 2'b10,
        STOP_BIT_VERIFY = 2'b11
    } state_t;

    state_t current_state, next_state;
    reg [7:0] data;
    reg [3:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
            bit_count <= 0;
            data <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        done = 0; // Default output
        case (current_state)
            IDLE: begin
                if (in == 0) // Start bit detected
                    next_state = START_BIT;
                else
                    next_state = IDLE;
            end
            START_BIT: begin
                next_state = DATA_RECEIVE; // Move to data reception
                bit_count = 0; // Reset bit count
            end
            DATA_RECEIVE: begin
                if (bit_count < 8) begin
                    data[bit_count] = in; // Receive LSB first
                    next_state = DATA_RECEIVE;
                    bit_count = bit_count + 1;
                end else begin
                    next_state = STOP_BIT_VERIFY; // After 8 bits
                end
            end
            STOP_BIT_VERIFY: begin
                if (in == 1) begin // Stop bit detected
                    done = 1; // Byte received successfully
                    next_state = IDLE; // Go back to idle
                end else begin
                    next_state = STOP_BIT_VERIFY; // Wait for stop bit
                end
            end
            default: next_state = IDLE; // Default to idle state
        endcase
    end

endmodule