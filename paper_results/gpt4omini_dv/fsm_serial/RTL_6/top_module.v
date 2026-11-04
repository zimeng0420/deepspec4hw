module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        START_BIT_DETECT = 2'b01,
        DATA_RECEIVE = 2'b10,
        STOP_BIT_VERIFY = 2'b11
    } state_t;

    state_t current_state, next_state;
    reg [7:0] data_shift;
    reg [3:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
            bit_count <= 0;
            data_shift <= 0;
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
                    next_state = START_BIT_DETECT;
            end

            START_BIT_DETECT: begin
                bit_count = 0;
                next_state = DATA_RECEIVE;
            end

            DATA_RECEIVE: begin
                if (bit_count < 8) begin
                    data_shift[bit_count] = in; // Receive LSB first
                    bit_count = bit_count + 1;
                end else begin
                    next_state = STOP_BIT_VERIFY;
                end
            end

            STOP_BIT_VERIFY: begin
                if (in == 1) begin // Stop bit detected
                    done = 1; // Byte received successfully
                    next_state = IDLE;
                end else begin
                    next_state = STOP_BIT_VERIFY; // Wait for stop bit
                end
            end
        endcase
    end

endmodule