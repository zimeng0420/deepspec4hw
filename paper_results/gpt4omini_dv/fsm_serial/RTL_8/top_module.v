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
    reg [7:0] data; // 8 data bits
    reg [3:0] bit_count; // Count the number of received bits

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
        next_state = current_state;
        done = 0;

        case (current_state)
            IDLE: begin
                if (in == 0) begin // Detect start bit
                    next_state = START_BIT;
                end
            end

            START_BIT: begin
                next_state = DATA_RECEIVE;
                bit_count = 0; // Reset bit count
            end

            DATA_RECEIVE: begin
                if (bit_count < 8) begin
                    data[bit_count] = in; // LSB first
                    bit_count = bit_count + 1;
                end else begin
                    next_state = STOP_BIT_VERIFY; // Move to stop bit verification
                end
            end

            STOP_BIT_VERIFY: begin
                if (in == 1) begin // Check for stop bit
                    done = 1; // Byte received successfully
                    next_state = IDLE; // Go back to idle
                end else begin
                    // Remain in STOP_BIT_VERIFY until valid stop bit is detected
                    next_state = STOP_BIT_VERIFY;
                end
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule