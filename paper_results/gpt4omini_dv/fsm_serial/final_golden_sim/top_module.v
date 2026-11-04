module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE,
        START_BIT,
        DATA_RECEIVE,
        STOP_BIT_VERIFY
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
        case (current_state)
            IDLE: begin
                done = 0;
                if (in == 0) // Start bit detected
                    next_state = START_BIT;
                else
                    next_state = IDLE;
            end

            START_BIT: begin
                next_state = DATA_RECEIVE; // Move to data reception after detecting start bit
            end

            DATA_RECEIVE: begin
                if (bit_count < 8) begin
                    data[bit_count] = in; // Shift in the data bits (LSB first)
                    bit_count = bit_count + 1;
                    next_state = DATA_RECEIVE;
                end else begin
                    next_state = STOP_BIT_VERIFY; // After 8 bits, go to stop bit verification
                end
            end

            STOP_BIT_VERIFY: begin
                if (in == 1) begin // Valid stop bit detected
                    done = 1; // Indicate that a byte is received
                    next_state = IDLE; // Move back to idle after done
                    bit_count = 0; // Reset bit count for next byte
                end else begin
                    next_state = STOP_BIT_VERIFY; // Wait for valid stop bit
                end
            end

            default: next_state = IDLE; // Default case
        endcase
    end
endmodule