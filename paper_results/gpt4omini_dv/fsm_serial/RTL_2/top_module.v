module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);

    typedef enum reg [1:0] {IDLE, START_BIT, DATA_RECEIVE, STOP_BIT} state_t;
    state_t state, next_state;
    reg [7:0] data;
    reg [3:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            bit_count <= 0;
        end else begin
            state <= next_state;
            if (next_state == IDLE) begin
                done <= 1; // Signal done in IDLE state only when transitioning back
            end else begin
                done <= 0;
            end
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 0) // Detect start bit
                    next_state = START_BIT;
                else
                    next_state = IDLE;
            end
            
            START_BIT: begin
                next_state = DATA_RECEIVE; // Move to data reception after start bit
            end
            
            DATA_RECEIVE: begin
                if (bit_count < 8) begin
                    next_state = DATA_RECEIVE; // Continue receiving data bits
                end else begin
                    next_state = STOP_BIT; // Move to stop bit verification
                end
            end
            
            STOP_BIT: begin
                if (in == 1) begin
                    next_state = IDLE; // Stop bit is correct, return to IDLE
                end else begin
                    next_state = STOP_BIT; // Wait for correct stop bit
                end
            end
            
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (state == DATA_RECEIVE) begin
            data <= {in, data[7:1]}; // Shift in data bits (LSB first)
            bit_count <= bit_count + 1;
        end else if (state == START_BIT) begin
            bit_count <= 0; // Reset bit count after starting 
        end else if (state == IDLE) begin
            bit_count <= 0; // Reset bit count on idle
        end
    end

endmodule