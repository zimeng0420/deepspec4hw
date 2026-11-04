module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);
    typedef enum reg [1:0] {IDLE, START_BIT, DATA_RECEIVE, STOP_BIT_VERIFY} state_t;
    state_t state, next_state;
    reg [7:0] data;
    reg [3:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            bit_count <= 0;
            data <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                done = 0;
                if (in == 0) // Start bit detected
                    next_state = START_BIT;
                else
                    next_state = IDLE;
            end
            
            START_BIT: begin
                // Wait for a stable signal after detecting the start bit
                if (in == 0) 
                    next_state = DATA_RECEIVE;
                else
                    next_state = START_BIT;
            end
            
            DATA_RECEIVE: begin
                if (bit_count < 8) begin
                    next_state = DATA_RECEIVE;
                end else begin
                    next_state = STOP_BIT_VERIFY;
                end
            end

            STOP_BIT_VERIFY: begin
                if (in == 1) begin
                    done = 1; // Successfully received a byte
                    next_state = IDLE;
                end else begin
                    next_state = STOP_BIT_VERIFY; // Wait for a valid stop bit
                end
            end
            
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (state == DATA_RECEIVE) begin
            data[bit_count] <= in; // Capture data bits
            bit_count <= bit_count + 1;
        end else if (state == STOP_BIT_VERIFY) begin
            bit_count <= 0; // Reset bit count when verifying stop bit
        end
    end
endmodule