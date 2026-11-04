module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    typedef enum logic [2:0] {
        IDLE,
        START_BIT,
        DATA_RECEIVE,
        STOP_BIT_VERIFY
    } state_t;

    state_t current_state, next_state;
    reg [7:0] data;
    reg [2:0] bit_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
            bit_count <= 0;
            data <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        case (current_state)
            IDLE: begin
                done = 0;
                if (in == 0) // Detect start bit
                    next_state = START_BIT;
                else
                    next_state = IDLE;
            end

            START_BIT: begin
                next_state = DATA_RECEIVE;
            end

            DATA_RECEIVE: begin
                if (bit_count < 7) begin
                    data[bit_count] = in; // Shift in data (LSB first)
                    bit_count = bit_count + 1;
                    next_state = DATA_RECEIVE;
                end else begin
                    data[bit_count] = in;
                    next_state = STOP_BIT_VERIFY;
                end
            end

            STOP_BIT_VERIFY: begin
                if (in == 1) begin // Verify stop bit
                    done = 1;
                    bit_count = 0; // Reset bit count
                    next_state = IDLE;
                end else begin
                    next_state = STOP_BIT_VERIFY; // Wait for valid stop bit
                end
            end

            default: next_state = IDLE; // Default case
        endcase
    end

endmodule