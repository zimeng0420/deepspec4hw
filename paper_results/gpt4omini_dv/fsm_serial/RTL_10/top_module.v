module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    typedef enum logic [1:0] {
        IDLE,
        START_BIT_DETECT,
        DATA_RECEIVE,
        STOP_BIT_VERIFY
    } state_t;

    state_t current_state, next_state;
    logic [7:0] data;
    integer bit_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
            bit_count <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        if (current_state == DATA_RECEIVE) begin
            data[bit_count] <= in; // Shift data in
            if (bit_count < 7) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 0; // Reset count after receiving 8 bits
            end
        end else if (current_state == IDLE) begin
            bit_count <= 0; // Reset bit count when entering IDLE
        end
    end

    always_comb begin
        case (current_state)
            IDLE: begin
                if (in == 0) // Detect start bit
                    next_state = START_BIT_DETECT;
                else
                    next_state = IDLE;
                done = 0;
            end

            START_BIT_DETECT: begin
                next_state = DATA_RECEIVE; // Move to receiving data
            end

            DATA_RECEIVE: begin
                if (bit_count == 7)
                    next_state = STOP_BIT_VERIFY; // Move to stop bit verification after receiving 8 bits
                else
                    next_state = DATA_RECEIVE;
            end

            STOP_BIT_VERIFY: begin
                if (in == 1) begin
                    done = 1; // Stop bit received successfully
                    next_state = IDLE; // Go back to IDLE
                end else begin
                    next_state = STOP_BIT_VERIFY; // Stay in this state until stop bit is detected
                end
            end

            default: begin
                next_state = IDLE; // Default to IDLE state
            end
        endcase
    end
endmodule