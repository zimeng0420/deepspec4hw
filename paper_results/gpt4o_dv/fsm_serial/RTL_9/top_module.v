module top_module (
    input clk,
    input in,
    input reset,
    output reg done
);
    // State declaration
    typedef enum reg [2:0] {
        IDLE, START, RECEIVE, STOP, ERROR
    } state_t;
    state_t current_state, next_state;
    
    reg [7:0] data;  // 8-bit shift register for data bits
    reg [3:0] bit_count;  // 4-bit counter to track the number of received bits
    
    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            bit_count <= 4'd0;
            data <= 8'd0;
            done <= 1'b0;
        end else begin
            current_state <= next_state;
            if (current_state == RECEIVE) begin
                data <= {in, data[7:1]};  // Shift in new data bit (LSB first)
                bit_count <= bit_count + 1'b1;
            end
            if (current_state == STOP && next_state == IDLE)
                done <= 1'b1;
            else
                done <= 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (in == 1'b0)  // Start bit detected
                    next_state = START;
                else
                    next_state = IDLE;
            end
            START: begin
                if (in == 1'b0)  // Continue if start bit is valid
                    next_state = RECEIVE;
                else
                    next_state = ERROR;
            end
            RECEIVE: begin
                if (bit_count == 4'd8)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end
            STOP: begin
                if (in == 1'b1)  // Stop bit valid
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            ERROR: begin
                if (in == 1'b1)  // Wait for stop bit to return to idle
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule